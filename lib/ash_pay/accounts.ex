defmodule AshPay.Accounts do
  use Ash.Domain, otp_app: :ash_pay, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource AshPay.Accounts.Token
    resource AshPay.Accounts.User
  end
end
