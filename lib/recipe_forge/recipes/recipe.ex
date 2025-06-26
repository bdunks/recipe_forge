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

    has_many :recipe_ingredients, RecipeIngredient, on_replace: :delete
    many_to_many :ingredients, Ingredient, join_through: RecipeIngredient, on_replace: :delete
    many_to_many :categories, Category, join_through: "recipe_categories", on_replace: :delete

    # virtual field to accept IDs from the form
    field :category_tags, :string, virtual: true

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(recipe, attrs) do
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
      :nutrition
      # :category_tags
    ])
    |> cast_instructions(attrs)
    |> cast_assoc(:recipe_ingredients,
      with: &RecipeIngredient.changeset/2
    )
    # The context provides a `categories` key with the structs ready for association.
    |> put_assoc(:categories, Map.get(attrs, "categories", []))
    |> validate_required([
      :name,
      :description,
      :servings,
      :yield_description,
      :instructions
    ])
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
end
