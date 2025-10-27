defmodule AshPay.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        AshPay.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:ash_pay, :token_signing_secret)
  end
end
