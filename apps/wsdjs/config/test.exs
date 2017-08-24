use Mix.Config

config :wsdjs, Wsdjs.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wsdjs_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
