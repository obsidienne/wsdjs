use Mix.Config

config :dj, Dj.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rwp_#{Mix.env}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
