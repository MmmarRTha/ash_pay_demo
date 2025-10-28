defmodule AshPay.Commerce do
  use Ash.Domain,
    otp_app: :ash_pay

  resources do
    resource AshPay.Commerce.Product
  end
end
