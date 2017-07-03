use Mix.Config

config :wsdjs_jobs, Wsdjs.Jobs.Mailer,
    adapter: Bamboo.SendgridAdapter,
    api_key: System.get_env("SENDGRID_API_KEY")
