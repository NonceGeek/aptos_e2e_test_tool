defmodule AptosE2eTestTool.Scripts do
  @moduledoc """
  The Scripts context.
  """

  import Ecto.Query, warn: false
  alias AptosE2eTestTool.Repo

  alias AptosE2eTestTool.Scripts.Script

  @doc """
  Returns the list of scripts.

  ## Examples

      iex> list_scripts()
      [%Script{}, ...]

  """
  def list_scripts do
    Repo.all(Script)
  end

  @doc """
  Gets a single script.

  Raises `Ecto.NoResultsError` if the Script does not exist.

  ## Examples

      iex> get_script!(123)
      %Script{}

      iex> get_script!(456)
      ** (Ecto.NoResultsError)

  """
  def get_script!(id), do: Repo.get!(Script, id)
  def get_script(id), do: Repo.get(Script, id)
  @doc """
  Gets a script by name.

  ## Examples

      iex> get_script_by_name("duck")
      %Script{}

      iex> get_script_by_email("duck")
      nil

  """
  def get_script_by_name(name) when is_binary(name) do
    Repo.get_by(Script, name: name)
  end
  @doc """
  Creates a script.

  ## Examples

      iex> create_script(%{field: value})
      {:ok, %Script{}}

      iex> create_script(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_script(attrs \\ %{}) do
    %Script{}
    |> Script.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a script.

  ## Examples

      iex> update_script(script, %{field: new_value})
      {:ok, %Script{}}

      iex> update_script(script, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_script(%Script{} = script, attrs) do
    script
    |> Script.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a script.

  ## Examples

      iex> delete_script(script)
      {:ok, %Script{}}

      iex> delete_script(script)
      {:error, %Ecto.Changeset{}}

  """
  def delete_script(%Script{} = script) do
    Repo.delete(script)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking script changes.

  ## Examples

      iex> change_script(script)
      %Ecto.Changeset{data: %Script{}}

  """
  def change_script(%Script{} = script, attrs \\ %{}) do
    Script.changeset(script, attrs)
  end
end
