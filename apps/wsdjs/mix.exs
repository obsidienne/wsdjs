defmodule Wsdjs.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wsdjs,
      version: "1.8.4",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "1.5.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {Wsdjs.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:postgrex, ">= 0.0.0"},
      {:scrivener_ecto, "~> 1.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:csv, "~> 1.4.4"},
      {:bamboo, "~> 0.8"},
      {:ex_machina, "~> 2.1", only: :test},
      {:httpoison, "~> 0.12"},
      {:earmark, "~> 1.2"},
      {:hashids, "~> 2.0"},
      {:geo_postgis, "~> 1.0"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"},
      {:timex, "~> 3.1"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
