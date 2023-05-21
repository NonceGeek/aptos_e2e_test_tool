defmodule AptosE2eTestTool.Scripts.Script do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scripts" do
    field :content, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(script, attrs) do
    script
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
