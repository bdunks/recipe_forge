defmodule RecipeForge.Recipes.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipe_ingredients" do
    field :quantity, :decimal
    field :unit, :string
    field :notes, :string
    field :display_order, :integer

    belongs_to :recipe, RecipeForge.Recipes.Recipe
    belongs_to :ingredient, RecipeForge.Recipes.Ingredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:quantity, :unit, :notes, :display_order, :recipe_id, :ingredient_id])
    |> validate_required([:quantity, :unit, :recipe_id, :ingredient_id])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:ingredient_id)
    |> unique_constraint([:recipe_id, :ingredient_id],
      name: :recipe_ingredients_recipe_id_ingredient_id_index
    )
  end
end
