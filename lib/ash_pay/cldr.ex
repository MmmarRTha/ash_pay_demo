defmodule AshPay.Cldr do
  use Cldr,
    locales: ["en"],
    default_locale: "en",
    providers: [
      Cldr.Calendar,
      Cldr.DateTime,
      Cldr.List,
      Cldr.PersonName,
      Cldr.Territory,
      Cldr.Unit
    ]
end
