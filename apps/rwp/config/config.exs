use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :rwp, ecto_repos: [Rwp.Repo]

import_config "#{Mix.env}.exs"
