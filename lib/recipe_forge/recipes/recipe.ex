defmodule RecipeForge.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias RecipeForge.Recipes.{Category, Ingredient, RecipeIngredient}

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

    has_many :recipe_ingredients, RecipeIngredient, on_delete: :delete_all
    many_to_many :ingredients, Ingredient, join_through: RecipeIngredient, on_replace: :delete
    many_to_many :categories, Category, join_through: "recipe_categories", on_replace: :delete

    # virtual field to accept IDs from the form
    field :category_tags, :string, virtual: true

    # TODO _usec
    timestamps(type: :utc_datetime)
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
      :nutrition,
      # Virtual field
      :category_tags
    ])
    |> cast_instructions(attrs)
    |> cast_assoc(:recipe_ingredients, with: &RecipeIngredient.changeset/2)
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
