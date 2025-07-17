defmodule RecipeForge.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias RecipeForge.Recipes.RecipeIngredient
  alias RecipeForge.Ingredients.Ingredient
  alias RecipeForge.Categories.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipes" do
    field :name, :string
    field :description, :string
    field :instructions, {:array, :string}
    field :prep_time, :string
    field :cook_time, :string
    field :servings, :integer
    field :yield_description, :string
    field :image_url, :string
    field :notes, :string
    field :nutrition, :map

    has_many :recipe_ingredients, RecipeIngredient,
      preload_order: [asc: :display_order],
      on_replace: :delete

    many_to_many :ingredients, Ingredient, join_through: RecipeIngredient, on_replace: :delete
    many_to_many :categories, Category, join_through: "recipe_categories", on_replace: :delete

    # virtual field to accept IDs from the form
    field :category_tags, :string, virtual: true

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(recipe, attrs, opts \\ []) do
    recipe
    |> cast(attrs, [
      :name,
      :description,
      :prep_time,
      :cook_time,
      :servings,
      :yield_description,
      :image_url,
      :notes,
      :nutrition,
      :category_tags
    ])
    |> cast_instructions(attrs)
    |> validate_required([
      :name,
      :description,
      :servings,
      :yield_description,
      :instructions
    ])
    |> validate_length(:instructions,
      min: 1,
      message: "should have at least %{count} instruction"
    )
    |> put_assoc(:categories, Map.get(attrs, "categories", []))
    |> cast_ingredients(attrs, opts)

    # The context provides a `categories` key with the structs ready for association.
  end

  # This function handles the transformation for the :instructions field.
  defp cast_instructions(changeset, %{"instructions" => instructions})
       when is_binary(instructions) do
    # If "instructions" is a string, split it and put it in the changeset.
    lines = String.split(instructions, ~r/\R/, trim: true)
    put_change(changeset, :instructions, lines)
  end

  defp cast_instructions(changeset, %{"instructions" => instructions})
       when is_list(instructions) do
    put_change(changeset, :instructions, instructions)
  end

  defp cast_instructions(changeset, _attrs) do
    # If "instructions" isn't in the params or isn't a string, do nothing.
    changeset
  end

  defp cast_ingredients(changeset, attrs, opts) do
    recipe_ingredients = Map.get(attrs, "recipe_ingredients")

    case Keyword.get(opts, :action) do
      :save when not is_nil(recipe_ingredients) ->
        cast_ingredients_for_save(changeset, recipe_ingredients)

      _ ->
        cast_assoc(changeset, :recipe_ingredients,
          with: &RecipeIngredient.changeset/3,
          sort_param: :ingredients_order
        )
    end
  end

  defp cast_ingredients_for_save(changeset, recipe_ingredients) when is_map(recipe_ingredients) do
    {filtered_ingredients, keys_to_delete} = process_ingredient_deletions(recipe_ingredients)

    updated_changeset = update_changeset_params(changeset, filtered_ingredients, keys_to_delete)

    cast_assoc(updated_changeset, :recipe_ingredients,
      with: &RecipeIngredient.changeset/3,
      sort_param: :ingredients_order,
      drop_param: :ingredients_delete
    )
  end

  defp process_ingredient_deletions(normalized_ingredients) do
    Enum.reduce(normalized_ingredients, {%{}, []}, fn {key, params}, {filtered_acc, delete_acc} ->
      cond do
        marked_for_deletion?(params) and new_ingredient?(params) ->
          # Skip new ingredients marked for deletion
          {filtered_acc, [key | delete_acc]}

        marked_for_deletion?(params) ->
          # Keep existing ingredients for proper deletion
          {Map.put(filtered_acc, key, params), [key | delete_acc]}

        true ->
          # Keep normal ingredients
          {Map.put(filtered_acc, key, params), delete_acc}
      end
    end)
  end

  defp marked_for_deletion?(%{"_destroy" => "true"}), do: true
  defp marked_for_deletion?(_), do: false

  defp new_ingredient?(%{"id" => id}) when is_binary(id) and id != "", do: false
  defp new_ingredient?(_), do: true

  defp update_changeset_params(changeset, filtered_ingredients, keys_to_delete) do
    updated_params =
      (changeset.params || %{})
      |> Map.put("recipe_ingredients", filtered_ingredients)
      |> Map.put("ingredients_delete", keys_to_delete)

    %{changeset | params: updated_params}
  end

end
