defmodule GithubDrawing.MixProject do
  use Mix.Project

  def project do
    [
      app: :github_drawing,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def deps do
    [
      # {:egit, "~> 0.1"}
    ]
  end
end

