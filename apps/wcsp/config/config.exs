use Mix.Config

config :wcsp, ecto_repos: [Wcsp.Repo]

import_config "#{Mix.env}.exs"
