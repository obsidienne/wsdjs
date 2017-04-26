use Mix.Config

config :master_proxy, ecto_repos: []


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
