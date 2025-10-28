defmodule AshPay.Commerce.Product do
  use Ash.Resource, otp_app: :ash_pay, domain: AshPay.Commerce, data_layer: AshPostgres.DataLayer

  postgres do
    table "products"
    repo AshPay.Repo
  end

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :price, :money do
      allow_nil? false
      public? true
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end
end
