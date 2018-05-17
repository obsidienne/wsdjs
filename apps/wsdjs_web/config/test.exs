use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wsdjs_web, WsdjsWeb.Endpoint,
  http: [port: 4001],
  server: true

config :wsdjs, :sql_sandbox, true

config :wallaby,
  driver: Wallaby.Experimental.Chrome