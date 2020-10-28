defmodule Wsdjs.Repo do
  use Ecto.Repo,
    otp_app: :wsdjs,
    adapter: Ecto.Adapters.Postgres
end
