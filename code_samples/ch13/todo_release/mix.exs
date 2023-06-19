defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [release: :prod]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:plug_cowboy, "~> 2.6"}
    ]
  end
end
