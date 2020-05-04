use Mix.Config

# Configure your database
config :wsdjs, Wsdjs.Repo,
  username: "postgres",
  password: "postgres",
  database: "wsdjs_test",
  hostname: "localhost",
  types: Wsdjs.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wsdjs, WsdjsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :wsdjs, WsdjsWeb.ApiRouteHelpers, base_url: "http://api:5000"
config :wsdjs, WsdjsApi.WebRouteHelpers, base_url: "http://web:4000"

# Print only warnings and errors during test
config :logger, level: :warn
