defmodule Wsdjs.Application do
  @moduledoc false

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Wsdjs.Repo, []),
      worker(Wsdjs.NowPlaying, [Wsdjs.NowPlaying])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wsdjs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
