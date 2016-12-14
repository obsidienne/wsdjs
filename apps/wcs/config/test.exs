use Mix.Config

config :wcs, Wcs.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rwp_#{Mix.env}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
