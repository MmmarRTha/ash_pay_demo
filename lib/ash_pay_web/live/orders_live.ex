defmodule AshPayWeb.OrdersLive do
  use AshPayWeb, :live_view

  on_mount {AshPayWeb.LiveUserAuth, :live_user_required}

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    is_admin = current_user.role == :admin

    if connected?(socket) do
      if is_admin do
        # Admin users subscribe to all orders
        #
      end

      user_id = socket.assigns.current_user.id
      Phoenix.PubSub.subscribe(AshPay.PubSub, "orders:#{user_id}:created")
      Phoenix.PubSub.subscribe(AshPay.PubSub, "orders:#{user_id}:updated")
    end

    {:ok,
     socket
     |> assign(:page_title, "My Orders")
     |> stream(:orders, [])}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, load_orders(socket)}
  end

  @impl true
  def handle_event("refund", %{"id" => order_id}, socket) do
    case AshPay.Commerce.refund_order(order_id, actor: socket.assigns.current_user) do
      {:ok, _order} ->
        {:noreply,
         socket
         |> put_flash(:info, "Refund request submitted successfully!")
         |> load_orders()}

      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Failed to refund!")}
    end
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{
          topic: "orders:" <> _,
          event: "purchase_product",
          payload: notification
        },
        socket
      ) do
    # Load the product relationship on the order from the notification
    order = Ash.load!(notification.data, :product, actor: socket.assigns.current_user)

    {:noreply, stream_insert(socket, :orders, order, at: 0)}
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{topic: "orders:" <> _, event: _event, payload: notification},
        socket
      ) do
    # Load the product relationship on the order from the notification
    order = Ash.load!(notification.data, :product, actor: socket.assigns.current_user)

    {:noreply, stream_insert(socket, :orders, order)}
  end

  defp load_orders(socket) do
    orders =
      AshPay.Commerce.list_orders!(
        actor: socket.assigns.current_user,
        load: [:product]
      )
      |> Enum.sort_by(& &1.inserted_at, {:desc, DateTime})

    stream(socket, :orders, orders)
  end

  defp format_state(:created), do: {"Processing", "badge-warning"}
  defp format_state(:paid), do: {"Paid", "badge-success"}
  defp format_state(:failed), do: {"Failed", "badge-error"}
  defp format_state(:ready_for_refund), do: {"Refund Pending", "badge-info"}
  defp format_state(:refunded), do: {"Refunded", "badge-neutral"}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto p-6">
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900 mb-2">My Orders</h1>
          <p class="text-gray-600">View and manage your order history</p>
        </div>

        <div :if={Enum.empty?(@streams.orders.inserts)} class="text-center py-12">
          <div class="text-gray-500">
            <svg
              class="mx-auto h-24 w-24 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
              />
            </svg>
            <h3 class="mt-4 text-lg font-medium text-gray-900">No orders yet</h3>
            <p class="mt-2 text-sm text-gray-500">
              You haven't placed any orders yet.
              <.link navigate={~p"/storefront"} class="text-blue-600 hover:text-blue-800">
                Browse products
              </.link>
              to get started.
            </p>
          </div>
        </div>

        <div
          :if={not Enum.empty?(@streams.orders.inserts)}
          class="bg-white rounded-lg shadow overflow-hidden"
        >
          <.table id="orders" rows={@streams.orders}>
            <:col :let={{_id, order}} label="Order ID">
              <span class="font-mono text-sm">{String.slice(order.id, 0, 8)}</span>
            </:col>
            <:col :let={{_id, order}} label="Product">
              <div class="font-medium">{order.product.name}</div>
            </:col>
            <:col :let={{_id, order}} label="Amount">
              <span class="font-semibold text-green-600">
                {Money.to_string!(order.amount)}
              </span>
            </:col>
            <:col :let={{_id, order}} label="Status">
              <% {status_text, badge_class} = format_state(order.state) %>
              <span class={"badge " <> badge_class}>{status_text}</span>
            </:col>
            <:col :let={{_id, order}} label="Date">
              <time class="text-sm text-gray-500">
                {Calendar.strftime(order.inserted_at, "%B %d, %Y at %I:%M %p")}
              </time>
            </:col>
            <:action :let={{_id, order}}>
              <.button
                :if={AshPay.Commerce.can_refund_order?(@current_user, order)}
                phx-click="refund"
                phx-value-id={order.id}
                phx-disable-with="Processing..."
              >
                Refund
              </.button>
            </:action>
          </.table>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
