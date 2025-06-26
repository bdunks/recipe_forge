defmodule RecipeForge.Ingredients do
  @moduledoc """
  The Ingredients context.
  """
  import Ecto.Query, warn: false

  alias RecipeForge.Shared.NameBasedEntityManager
  alias RecipeForge.Repo

  alias RecipeForge.Ingredients.Ingredient

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredient{}, ...]

  """
  def list_ingredients do
    Repo.all(Ingredient)
  end

  @doc """
  Gets a single ingredient.

  Raises `Ecto.NoResultsError` if the Ingredient does not exist.

  ## Examples

      iex> get_ingredient!(123)
      %Ingredient{}

      iex> get_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.

  ## Examples

      iex> create_ingredient(%{field: value})
      {:ok, %Ingredient{}}

      iex> create_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredient.

  ## Examples

      iex> update_ingredient(ingredient, %{field: new_value})
      {:ok, %Ingredient{}}

      iex> update_ingredient(ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredient.

  ## Examples

      iex> delete_ingredient(ingredient)
      {:ok, %Ingredient{}}

      iex> delete_ingredient(ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Ecto.Changeset{data: %Ingredient{}}

  """
  def change_ingredient(%Ingredient{} = ingredient, attrs \\ %{}) do
    Ingredient.changeset(ingredient, attrs)
  end

  @doc """
  Finds an ingredient by its name, creating it if it doesn't exist.

  The name is trimmed and converted to lowercase before searching to ensure
  consistency and prevent duplicate entries (e.g., "Flour" vs "flour").

  Returns:
    - `{:ok, %Ingredient{}}` if the ingredient is found or created successfully.
    - `{:error, %Ecto.Changeset{}}` if the ingredient is new but fails validation.
    - `{:error, :blank_name}` if the provided name is nil or a blank string.
  """
  def find_or_create_ingredient_by_name(name) when is_binary(name) do
    sanitized_name = String.trim(name) |> String.downcase()

    # Guard against blank strings after trimming.
    if sanitized_name == "" do
      {:error, :blank_name}
    else
      # Look for the ingredient or create it in one database trip.
      # `on_conflict: :nothing` is a highly efficient way to handle this.
      Repo.insert(
        %Ingredient{name: sanitized_name},
        # On conflict, do nothing but ensure the name is set
        on_conflict: [set: [name: sanitized_name]],
        conflict_target: :name
      )
    end
  end

  @doc """
  Takes recipe_ingredient attributes from a form and returns the final
  attributes with `ingredient_id` injected.
  Validation-safe: does not persist to the database.
  """
  def build_from_form_attrs(nil), do: []
  def build_from_form_attrs([]), do: []

  def build_from_form_attrs(recipe_ingredients_attrs) do
    names = Map.values(recipe_ingredients_attrs) |> Enum.map(& &1["ingredient_name"])

    all_structs =
      NameBasedEntityManager.build_from_names(Ingredient, names)
      |> Map.get(:all, [])

    transform_attributes(recipe_ingredients_attrs, all_structs)
  end

  @doc """
  Takes recipe_ingredient attributes from a form, finds or creates all
  necessary ingredients, and returns `{:ok, final_attributes}`.
  """
  def find_or_create_from_form_attrs(nil), do: {:ok, []}
  def find_or_create_from_form_attrs([]), do: {:ok, []}

  def find_or_create_from_form_attrs(recipe_ingredients_attrs) do
    names = Map.values(recipe_ingredients_attrs) |> Enum.map(& &1["ingredient_name"])

    with {:ok, all_structs} <-
           NameBasedEntityManager.find_or_create_from_names(Ingredient, names) do
      final_attrs = transform_attributes(recipe_ingredients_attrs, all_structs)
      {:ok, final_attrs}
    end
  end

  # Add theingredient_id to enable the many-to-many persistance
  defp transform_attributes(original_attrs, all_ingredient_structs) do
    lookup_map = Map.new(all_ingredient_structs, &{&1.name, &1})

    Map.values(original_attrs)
    |> Enum.map(fn ri_attrs ->
      name =
        get_in(ri_attrs, ["ingredient_name"])
        |> to_string()
        |> String.trim()
        |> String.downcase()

      case lookup_map[name] do
        nil -> ri_attrs
        ingredient -> Map.put(ri_attrs, "ingredient_id", ingredient.id)
      end
    end)
  end
end
