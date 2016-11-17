use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :user, ecto_repos: [User.Repo]

import_config "#{Mix.env}.exs"
