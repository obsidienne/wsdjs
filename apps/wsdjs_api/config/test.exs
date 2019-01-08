# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wsdjs_api, WsdjsApi.Endpoint,
  http: [port: 5002],
  server: false

config :wsdjs_api, WsdjsApi.WebRouteHelpers, base_url: "http://web:4000"
