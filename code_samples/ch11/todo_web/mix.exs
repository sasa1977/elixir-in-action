defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.6-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      applications: [:gproc, :cowboy, :plug],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:gproc, "0.3.1"},
      {:cowboy, "1.0.4"},
      {:plug, "1.3.0"},
      {:meck, "0.8.9", only: :test},
      {:httpoison, "0.8.0", only: :test}
    ]
  end
end
