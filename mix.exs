defmodule Brididi.MixProject do
  use Mix.Project

  def project do
    [
      app: :brididi,
      version: "2.4.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      # Docs
      name: "Brididi",
      source_url: "https://github.com/obsidienne/brididi",
      docs: [
        # The main page in the docs
        extras: ["README.md"]
      ],
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {Brididi.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:argon2_elixir, "~> 2.0"},
      {:phoenix, "~> 1.5.1"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.15"},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.3"},
      {:phx_gen_auth, "~> 0.5.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ex_cldr_dates_times, "~> 2.0"},
      {:bamboo, "~> 1.1"},
      {:earmark, "~> 1.4"},
      {:hashids, "~> 2.0"},
      {:geo_postgis, "~> 3.1"},
      {:ecto_psql_extras, "~> 0.2"},
      {:html_sanitize_ex, "~> 1.4"},
      {:kaffy, "~> 0.9.0"},
      {:cloudex, "~> 1.3"},
      {:timex, "~> 3.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": [
        "ecto.create",
        "ecto.load --skip-if-loaded",
        "ecto.migrate",
        "run priv/repo/seeds.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.migrate": ["ecto.migrate", "ecto.dump"],
      "ecto.rollback": ["ecto.rollback", "ecto.dump"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
