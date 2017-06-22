use Mix.Config

config :wsdjs, Wsdjs.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") || "postgres://postgres:postgres@localhost:5432/wsdjs",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
