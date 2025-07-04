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
    field :_destroy, :boolean, virtual: true

    belongs_to :recipe, RecipeForge.Recipes.Recipe
    belongs_to :ingredient, RecipeForge.Ingredients.Ingredient, on_replace: :nilify

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [
      :quantity,
      :unit,
      :notes,
      :display_order,
      :ingredient_name,
      :ingredient_id,
      :_destroy
    ])
    |> validate_required([:quantity, :unit, :ingredient_name])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:ingredient_id)
    |> unique_constraint([:recipe_id, :ingredient_id],
      name: :recipe_ingredients_recipe_id_ingredient_id_index
    )
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :_destroy) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
