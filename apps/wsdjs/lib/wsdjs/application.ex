defmodule Wsdjs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Wsdjs.Repo,
      WsdjsJobs.Scheduler
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Wsdjs.Supervisor)
  end
end
