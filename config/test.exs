use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :wsdjs, Wsdjs.Repo,
  username: "postgres",
  password: "postgres",
  database: "wsdjs_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  types: Wsdjs.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wsdjs, WsdjsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :wsdjs, WsdjsWeb.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn
