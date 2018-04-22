use Mix.Config

# Configure your database
config :wsdjs, Wsdjs.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wsdjs_dev",
  hostname: "localhost",
  types: Wsdjs.PostgresTypes,
  pool_size: 10
