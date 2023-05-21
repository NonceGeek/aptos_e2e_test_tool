defmodule AptosE2eTestTool.ScriptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AptosE2eTestTool.Scripts` context.
  """

  @doc """
  Generate a script.
  """
  def script_fixture(attrs \\ %{}) do
    {:ok, script} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> AptosE2eTestTool.Scripts.create_script()

    script
  end
end
