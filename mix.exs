defmodule YookassaClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :yookassa_client,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:decimal, "~> 2.0.0"}
    ]
  end
end
