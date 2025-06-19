defmodule RecipeForge.Repo.Migrations.FixRecipeCategoriesJoinTable do
  use Ecto.Migration

  def change do
    drop table(:recipe_categories)

    create table(:recipe_categories, primary_key: false) do
      add :recipe_id, references(:recipes, type: :binary_id, on_delete: :delete_all), null: false

      add :category_id, references(:categories, type: :binary_id, on_delete: :delete_all),
        null: false
    end

    create unique_index(:recipe_categories, [:recipe_id, :category_id])
  end
end
