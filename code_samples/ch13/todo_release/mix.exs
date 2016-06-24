defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [ app: :todo,
      version: "0.0.1",
      elixir: "~> 1.0",
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger, :gproc, :cowboy, :plug],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:gproc, "0.3.1"},
      {:cowboy, "1.0.0"},
      {:plug, "1.1.6"},
      {:exrm, "1.0.5"},
      {:meck, "0.8.2", only: :test},
      {:httpoison, "0.8.0", only: :test}
    ]
  end
end
