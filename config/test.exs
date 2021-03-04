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
config :brididi, Brididi.Repo,
  username: "postgres",
  password: "postgres",
  database: "brididi_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  types: Brididi.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :brididi, BrididiWeb.Endpoint,
  http: [port: 4002],
  server: false

config :brididi, BrididiWeb.Mailer, adapter: Bamboo.TestAdapter

config :cloudex,
  api_key: "my-api-key",
  secret: "my-secret",
  cloud_name: "dummy"

# Print only warnings and errors during test
config :logger, level: :warn
