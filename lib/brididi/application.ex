defmodule Brididi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Brididi.Repo,
      # Start the Telemetry supervisor
      BrididiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Brididi.PubSub},
      # Start the endpoint when the application starts
      BrididiWeb.Endpoint
      # Starts a worker by calling: BrididiWeb.Worker.start_link(arg)
      # {BrididiWeb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Brididi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BrididiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
