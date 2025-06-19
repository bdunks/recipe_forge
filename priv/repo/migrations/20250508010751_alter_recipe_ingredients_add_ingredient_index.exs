defmodule RecipeForge.Repo.Migrations.AlterRecipeIngredientsAddIngredientIndex do
  use Ecto.Migration

  def change do
    create index(:recipe_ingredients, [:ingredient_id])
  end
end
