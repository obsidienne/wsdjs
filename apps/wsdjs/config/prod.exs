use Mix.Config

config :wsdjs, Wsdjs.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: Wsdjs.PostgresTypes,
  pool_size: 1
