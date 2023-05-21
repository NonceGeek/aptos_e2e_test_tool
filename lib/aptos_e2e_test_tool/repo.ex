defmodule AptosE2eTestTool.Repo do
  use Ecto.Repo,
    otp_app: :aptos_e2e_test_tool,
    adapter: Ecto.Adapters.Postgres
end
