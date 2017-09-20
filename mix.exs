defmodule Kraal.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kraal,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
    ]
  end


  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kraal.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :scrivener, :scrivener_ecto, :scrivener_html],
    ]
  end


  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end


  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:slugger, "~> 0.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", [only: :dev]},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:guardian, "~> 1.0-beta"},
      {:sweet_xml, "~> 0.6.5"},
      {:ex_machina, "~> 2.0", [only: :test]},
      {:faker_elixir_octopus, "~> 1.0.0", [only: [:dev, :test]]},
      {:credo, "~> 0.8", [only: [:dev, :test], runtime: false]},
      {:ecto_enum, "~> 1.0"},
      {:scrivener, "~> 2.3"},
      {:scrivener_ecto, "~> 1.2"},
      {:scrivener_html, "~> 1.7"},
      {:bamboo, "~> 1.0-rc1"},
      {:comeonin, "~> 4.0"},
      {:argon2_elixir, "~> 1.2"},
      {:junit_formatter, "~> 2.0", only: [:test]},
      {:pandex, "~> 0.1"},
      {:earmark, "~> 1.2" }
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
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
    ]
  end
end
