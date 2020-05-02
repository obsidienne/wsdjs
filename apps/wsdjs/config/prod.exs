# Since configuration is shared in umbrella projects, this file
# should only configure the :wsdjs application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :wsdjs, Wsdjs.Repo,
  types: Wsdjs.PostgresTypes,
  pool_size: 1

config :wsdjs_jobs, WsdjsJobs.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "${SENDGRID_API_KEY}"

config :wsdjs_jobs, WsdjsJobs.Scheduler,
  jobs: [
    {"@daily", {WsdjsJobs.NewSuggestion, :call, []}},
    {{:extended, "*/5 * * * *"}, {WsdjsJobs.RadioStreamed, :call, []}},
    {"*/5 * * * *", {WsdjsJobs.UpdatePlaylists, :call, []}}
  ]
