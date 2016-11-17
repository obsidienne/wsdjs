use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :song, ecto_repos: [Song.Repo]

import_config "#{Mix.env}.exs"
