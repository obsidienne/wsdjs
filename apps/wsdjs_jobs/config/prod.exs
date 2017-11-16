use Mix.Config

config :wsdjs_jobs, Wsdjs.Jobs.Mailer,
    adapter: Bamboo.SendgridAdapter,
    api_key: "${SENDGRID_API_KEY}"
