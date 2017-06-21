use Mix.Config

config :wsdjs, ecto_repos: [Wsdjs.Repo]

import_config "#{Mix.env}.exs"
