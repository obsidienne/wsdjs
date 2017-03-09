defmodule Wsdjs.Application do
  @modulefoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Wsdjs.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: Wsdjs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Wsdjs.Endpoint.config_change(changed, removed)
    :ok
  end
end
