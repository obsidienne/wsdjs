defmodule Wsdjs.Repo do
  use Ecto.Repo,
    otp_app: :wsdjs,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 50
end
