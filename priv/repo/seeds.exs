# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AshPay.Repo.insert!(%AshPay.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
AshPay.Commerce.create_product!(%{name: "Basic Plan", price: "9.99"}, authorize?: false)
AshPay.Commerce.create_product!(%{name: "Pro Plan", price: "19.99"}, authorize?: false)
AshPay.Commerce.create_product!(%{name: "Max Plan", price: "199.00"}, authorize?: false)

{:ok, hashed_password} = AshAuthentication.BcryptProvider.hash("password123")

Ash.Seed.seed!(AshPay.Accounts.User, %{
  email: "admin@ashpay.com",
  hashed_password: hashed_password,
  role: :admin
})

Ash.Seed.seed!(AshPay.Accounts.User, %{
  email: "user@ashpay.com",
  hashed_password: hashed_password
})
