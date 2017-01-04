use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :wcsp, ecto_repos: [Wcsp.Repo]

import_config "#{Mix.env}.exs"
