use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :wcs, ecto_repos: [Wcs.Repo]

import_config "#{Mix.env}.exs"
