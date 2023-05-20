defmodule AptosE2ETestTool.MixProject do
  use Mix.Project

  def project do
    [
      app: :aptos_e2e_test_tool,
      version: "0.1.0",
      elixir: "~> 1.14",
      escript: [main_module: AptosE2ETestTool.CliParser],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        aptos_e2e_test_tool: [
        steps: [:assemble] ++ ex_unit_release()
        ]]
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
      {:web3_aptos_ex, "~> 1.1.4"},
      {:binary, "~> 0.0.5"},
      {:nimble_parsec, "~> 1.2"},
      {:ex_unit_release, "~> 0.1"},
      {:rename_project, "~> 0.1.0", only: :dev},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp ex_unit_release(),do: [&ExUnitRelease.include/1]
end
