# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :wsdjs,
  ecto_repos: [Wsdjs.Repo]

import_config "#{Mix.env()}.exs"
