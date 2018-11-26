use Mix.Config

config :wsdjs_jobs, WsdjsJobs.Mailer, adapter: Bamboo.LocalAdapter

config :wsdjs_jobs, WsdjsJobs.Scheduler,
  jobs: [
    {"@daily", {WsdjsJobs.NewSuggestion, :call, []}},
    {{:extended, "*/5 * * * *"}, {WsdjsJobs.RadioStreamed, :call, []}},
    {"*/5 * * * *", {WsdjsJobs.UpdatePlaylists, :call, []}}
  ]
