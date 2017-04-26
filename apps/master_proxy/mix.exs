defmodule MasterProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :master_proxy,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {MasterProxy.Application, []}]
  end

  defp deps do
    [{:plug, "~> 1.2"},
     {:cowboy, "~> 1.0"},
     {:wsdjs_api, in_umbrella: true},
     {:wsdjs, in_umbrella: true}]
  end
end
