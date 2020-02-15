defmodule ResourceID.MixProject do
  use Mix.Project

  def project do
    [
      app: :resource_id,
      description: "REST endpoints without PII in URLs.",
      version: "1.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Testing
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [ignore_warnings: ".dialyzer", plt_add_deps: true],

      # Docs
      name: "ResourceID",
      source_url: "https://github.com/IanLuites/resource_id",
      homepage_url: "https://github.com/IanLuites/resource_id",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def package do
    [
      name: :resource_id,
      maintainers: ["Ian Luites"],
      licenses: ["MIT"],
      files: [
        # Elixir
        "lib/resource_id.ex",
        ".formatter.exs",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      links: %{
        "GitHub" => "https://github.com/IanLuites/resource_id"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.9"},
      {:analyze, "~> 0.1.10", only: [:dev, :test], runtime: false, optional: true},
      {:dialyxir, "~> 1.0.0-rc.7 ", only: :dev, runtime: false, optional: true}
    ]
  end
end
