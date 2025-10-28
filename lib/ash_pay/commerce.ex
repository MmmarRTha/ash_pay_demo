defmodule AshPay.Commerce do
  use Ash.Domain,
    otp_app: :ash_pay

  resources do
    resource AshPay.Commerce.Product do
      define :create_product, action: :create
      define :list_products, action: :read
      define :get_product, action: :read, get_by: [:id]
    end
  end
end
