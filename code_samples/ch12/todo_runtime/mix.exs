defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [ app: :todo,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger, :gproc, :cowboy, :plug, :runtime_tools],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:gproc, "0.3.1"},
      {:cowboy, "1.0.0"},
      {:plug, "0.10.0"},
      {:exrm, "0.14.11"},
      {:meck, "0.8.2", only: :test},
      {:httpoison, "0.4.3", only: :test}
    ]
  end
end