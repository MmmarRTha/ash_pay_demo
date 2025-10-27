defmodule AshPayWeb.PageController do
  use AshPayWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
