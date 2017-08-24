use Mix.Config

config :wsdjs, Wsdjs.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: String.to_integer(System.get_env("POOL_SIZE"))
