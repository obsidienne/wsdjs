defmodule Wsdjs.Cldr do
  use Cldr,
    otp_app: :wsdjs,
    default_locale: "en",
    locales: ["en", "fr"],
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]
end
