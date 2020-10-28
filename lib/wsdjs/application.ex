defmodule Wsdjs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Wsdjs.Repo,
      # Start the Telemetry supervisor
      WsdjsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wsdjs.PubSub},
      # Start the endpoint when the application starts
      WsdjsWeb.Endpoint
      # Starts a worker by calling: WsdjsWeb.Worker.start_link(arg)
      # {WsdjsWeb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wsdjs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WsdjsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
