defmodule RecipeForge.Repo.Migrations.AlterRecipeCategoriesForCategoryDeletionAndIndex do
  use Ecto.Migration

  def change do
    drop constraint(:recipe_categories, :recipe_categories_category_id_fkey)

    alter table(:recipe_categories) do
      modify :category_id, references(:categories, type: :binary_id, on_delete: :delete_all)
    end

    create index(:recipe_categories, [:category_id])
  end
end
