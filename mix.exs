defmodule TDMS.Parser.MixProject do
  use Mix.Project

  def project do
    [
      app: :tdms_parser,
      version: "0.2.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      source_url: "https://github.com/ni/tdms-parser"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/unittest", "test/integrationtest", "test/helper"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Parser for NI TDMS files written in Elixir"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["tschmittni"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ni/tdms-parser"}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.0", only: :test, runtime: false}
    ]
  end
end
