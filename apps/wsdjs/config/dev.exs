# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :wsdjs, Wsdjs.Repo,
  username: "postgres",
  password: "postgres",
  database: "wsdjs_dev",
  hostname: "localhost",
  types: Wsdjs.PostgresTypes,
  pool_size: 10

config :wsdjs_jobs, WsdjsJobs.Mailer, adapter: Bamboo.LocalAdapter

config :wsdjs_jobs, WsdjsJobs.Scheduler,
  jobs: [
    {"@daily", {WsdjsJobs.NewSuggestion, :call, []}},
    {{:extended, "*/5 * * * *"}, {WsdjsJobs.RadioStreamed, :call, []}},
    {"*/5 * * * *", {WsdjsJobs.UpdatePlaylists, :call, []}}
  ]
