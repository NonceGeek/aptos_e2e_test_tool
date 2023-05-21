defmodule AptosE2eTestTool.ScriptsTest do
  use AptosE2eTestTool.DataCase

  alias AptosE2eTestTool.Scripts

  describe "scripts" do
    alias AptosE2eTestTool.Scripts.Script

    import AptosE2eTestTool.ScriptsFixtures

    @invalid_attrs %{content: nil, name: nil}

    test "list_scripts/0 returns all scripts" do
      script = script_fixture()
      assert Scripts.list_scripts() == [script]
    end

    test "get_script!/1 returns the script with given id" do
      script = script_fixture()
      assert Scripts.get_script!(script.id) == script
    end

    test "create_script/1 with valid data creates a script" do
      valid_attrs = %{content: "some content", name: "some name"}

      assert {:ok, %Script{} = script} = Scripts.create_script(valid_attrs)
      assert script.content == "some content"
      assert script.name == "some name"
    end

    test "create_script/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scripts.create_script(@invalid_attrs)
    end

    test "update_script/2 with valid data updates the script" do
      script = script_fixture()
      update_attrs = %{content: "some updated content", name: "some updated name"}

      assert {:ok, %Script{} = script} = Scripts.update_script(script, update_attrs)
      assert script.content == "some updated content"
      assert script.name == "some updated name"
    end

    test "update_script/2 with invalid data returns error changeset" do
      script = script_fixture()
      assert {:error, %Ecto.Changeset{}} = Scripts.update_script(script, @invalid_attrs)
      assert script == Scripts.get_script!(script.id)
    end

    test "delete_script/1 deletes the script" do
      script = script_fixture()
      assert {:ok, %Script{}} = Scripts.delete_script(script)
      assert_raise Ecto.NoResultsError, fn -> Scripts.get_script!(script.id) end
    end

    test "change_script/1 returns a script changeset" do
      script = script_fixture()
      assert %Ecto.Changeset{} = Scripts.change_script(script)
    end
  end
end
