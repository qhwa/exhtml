defmodule Exhtml.Mixfile do
  use Mix.Project

  @description """
  An HTML page server used for quickly update contents.
  """

  def project do
    [
      app: :exhtml,
      version: "0.4.0-beta1",
      elixir: ">= 1.4.0",
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
      included_applications: [:mnesia],
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
      {:credo, "~> 0.4", only: [:dev]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :docs}
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
