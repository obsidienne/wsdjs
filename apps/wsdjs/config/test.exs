# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :wsdjs, Wsdjs.Repo,
  username: "postgres",
  password: "postgres",
  database: "wsdjs_test",
  hostname: "localhost",
  types: Wsdjs.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox
