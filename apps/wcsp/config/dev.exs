use Mix.Config

# Configure your database
config :wcsp, Wcsp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rwp_dev",
  hostname: "localhost",
  pool_size: 10
