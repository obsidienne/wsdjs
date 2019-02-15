# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :wsdjs_web,
  namespace: WsdjsWeb,
  ecto_repos: [Wsdjs.Repo]

# Configures the endpoint
config :wsdjs_web, WsdjsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJT1iDt6U73/4jsybB6t5FSGqEzxnzfRL4SExYeGc3yPpBSn1/U3JmfDlrsN+9n9",
  render_errors: [view: WsdjsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WsdjsWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
