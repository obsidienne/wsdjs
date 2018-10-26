use Mix.Config

config :wsdjs_jobs, Wsdjs.Jobs.Mailer, adapter: Bamboo.LocalAdapter

config :wsdjs_jobs, Wsdjs.Jobs.Scheduler,
  jobs: [
    {"@daily", {Wsdjs.Jobs.NewSuggestion, :call, []}},
    {{:extended, "*/5 * * * *"}, {Wsdjs.Jobs.RadioStreamed, :call, []}},
    {"*/5 * * * *", {Wsdjs.Jobs.UpdatePlaylists, :call, []}}
  ]
