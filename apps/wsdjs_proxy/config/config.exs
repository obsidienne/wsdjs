# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs_proxy application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :wsdjs_proxy,
  generators: [context_app: false]

# Configures the endpoint
config :wsdjs_proxy, WsdjsProxy.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G7XeDKpBltFjKT0RBOWoOxnyh4cgFC5olA5FPDKx2btpqKdS2ndASrCCrep7giGj",
  render_errors: [view: WsdjsProxy.ErrorView, accepts: ~w(json)],
  pubsub: [name: WsdjsProxy.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
