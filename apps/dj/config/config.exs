use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :dj, ecto_repos: [Dj.Repo]

import_config "#{Mix.env}.exs"
