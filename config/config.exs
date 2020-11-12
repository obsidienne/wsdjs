# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wsdjs,
  ecto_repos: [Wsdjs.Repo]

# Configures the endpoint
config :wsdjs, WsdjsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJT1iDt6U73/4jsybB6t5FSGqEzxnzfRL4SExYeGc3yPpBSn1/U3JmfDlrsN+9n9",
  render_errors: [view: WsdjsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Wsdjs.PubSub,
  live_view: [signing_salt: "HQjPaNYm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_cldr, default_backend: Wsdjs.Cldr

config :kaffy,
  admin_title: "Wsdjs Admin",
  otp_app: :wsdjs,
  ecto_repo: Wsdjs.Repo,
  router: WsdjsWeb.Router

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
