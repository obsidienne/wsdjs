# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :wsdjs, Wsdjs.Repo,
  types: Wsdjs.PostgresTypes,
  pool_size: 1
