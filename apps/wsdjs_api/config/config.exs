# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wsdjs_api,
  namespace: WsdjsApi,
  ecto_repos: [Wsdjs.Repo]

# Configures the endpoint
config :wsdjs_api, WsdjsApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GMAk9GQ6O93fNq0zEgl77H9Q+wphZTNc1nWsHkNU72iWiwkFK+fJePGdt5n3LO7/",
  render_errors: [view: WsdjsApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: WsdjsApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :wsdjs_api, :generators,
  context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
