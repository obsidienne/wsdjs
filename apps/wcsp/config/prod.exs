use Mix.Config

config :wcsp, Wcsp.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") || "postgres://postgres:postgres@localhost:5432/rwp",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
