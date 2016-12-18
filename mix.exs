defmodule Exhtml.Mixfile do
  use Mix.Project

  @description """
  An HTML page server used for quickly update contents.
  """

  def project do
    [
      app: :exhtml,
      version: "0.1.0-beta.1",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      name: "exhtml",
      description: @description,
      package: package()
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger],
      mod: {Exhtml.App, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:upyun, github: "qhwa/elixir-upyun", branch: "v0.2-dev", only: [:test, :dev]},
      {:credo, "~> 0.4", only: [:dev]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["qhwa"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/qhwa/exhtml"}
    ]
  end
end
