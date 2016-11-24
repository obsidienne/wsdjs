use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :photo, ecto_repos: [Photo.Repo]

import_config "#{Mix.env}.exs"
