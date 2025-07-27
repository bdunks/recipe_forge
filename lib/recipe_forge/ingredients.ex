defmodule RecipeForge.Ingredients do
  @moduledoc """
  The Ingredients context.
  """
  import Ecto.Query, warn: false

  alias RecipeForge.Repo

  alias RecipeForge.Ingredients.Ingredient

  @doc """
  Returns the list of ingredients.
  """
  def list_ingredients do
    Repo.all(Ingredient)
  end

  @doc """
  Gets a single ingredient.

  Raises `Ecto.NoResultsError` if the Ingredient does not exist.
  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.
  """
  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Finds an ingredient by its name, creating it if it doesn't exist.

  The name is trimmed and converted to lowercase before searching to ensure
  consistency and prevent duplicate entries (e.g., "Flour" vs "flour").

  Returns:
    - `{:ok, %Ingredient{}}` if the ingredient is found or created successfully.
    - `{:error, %Ecto.Changeset{}}` if the ingredient is new but fails validation.
  """
  def find_or_create_by_name(name) when is_binary(name) do
    sanitized_name = String.trim(name) |> String.downcase()

    changeset =
      %Ingredient{}
      |> Ingredient.changeset(%{name: sanitized_name})

    if changeset.valid? do
      Repo.insert(changeset, on_conflict: :nothing, conflict_target: :name)
      # Fetch the definitive record.
      # This is guaranteed to exist, whether it was just inserted or was already there.
      # This ensures we ALWAYS return the correct, persisted ID.
      {:ok, Repo.get_by!(Ingredient, name: sanitized_name)}
    else
      {:error, changeset}
    end
  end

  def find_or_create_by_name(_), do: {:error, Ingredient.changeset(%Ingredient{}, %{name: ""})}

  @doc """
  Updates a ingredient.
  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredient.
  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.
  """
  def change_ingredient(%Ingredient{} = ingredient, attrs \\ %{}) do
    Ingredient.changeset(ingredient, attrs)
  end
end
