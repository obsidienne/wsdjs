# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wsdjs, ecto_repos: []

# Configures the endpoint
config :wsdjs, Wsdjs.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJT1iDt6U73/4jsybB6t5FSGqEzxnzfRL4SExYeGc3yPpBSn1/U3JmfDlrsN+9n9",
  render_errors: [view: Wsdjs.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wsdjs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
