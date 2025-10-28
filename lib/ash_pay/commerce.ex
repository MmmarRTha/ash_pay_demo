defmodule AshPay.Commerce do
  use Ash.Domain,
    otp_app: :ash_pay

  resources do
    resource AshPay.Commerce.Product do
      define :create_product, action: :create
      define :list_products, action: :read
      define :get_product, action: :read, get_by: [:id]
    end

    resource AshPay.Commerce.Order do
      define :purchase_product, action: :purchase_product
      define :list_order, action: :read
      define :refund_order, action: :refund
    end
  end
end
