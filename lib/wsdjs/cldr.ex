defmodule Brididi.Cldr do
  use Cldr,
    otp_app: :brididi,
    default_locale: "en",
    locales: ["en", "fr"],
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]
end
