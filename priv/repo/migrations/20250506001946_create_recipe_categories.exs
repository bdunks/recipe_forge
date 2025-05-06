defmodule RecipeForge.Repo.Migrations.CreateRecipeCategories do
  use Ecto.Migration

  def change do
    create table(:recipe_categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :recipe_id, references(:recipes, type: :binary_id, on_delete: :delete_all), null: false
      add :category_id, references(:categories, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_categories, [:recipe_id, :category_id], unique: true)
  end
end
