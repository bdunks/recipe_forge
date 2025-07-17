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

    field :ingredient_name, :string, virtual: true
    field :_destroy, :boolean, virtual: true, default: false

    belongs_to :recipe, RecipeForge.Recipes.Recipe
    belongs_to :ingredient, RecipeForge.Ingredients.Ingredient

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(recipe_ingredient, attrs, display_order) do
    recipe_ingredient
    |> cast(attrs, [
      :quantity,
      :unit,
      :notes,
      :ingredient_name,
      :recipe_id,
      :ingredient_id,
      :_destroy
    ])
    # Use change() for internal data (display_order) - no validation needed
    |> change(display_order: display_order)
    |> validate_required([:quantity, :unit, :ingredient_name])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:ingredient_id)
    |> unique_constraint([:recipe_id, :ingredient_id])
  end
end
