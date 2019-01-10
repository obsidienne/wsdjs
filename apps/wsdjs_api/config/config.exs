# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :wsdjs_api,
  generators: [context_app: false]

# Configures the endpoint
config :wsdjs_api, WsdjsApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJT1iDt6U73/4jsybB6t5FSGqEzxnzfRL4SExYeGc3yPpBSn1/U3JmfDlrsN+9n9",
  render_errors: [view: WsdjsApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: WsdjsApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
