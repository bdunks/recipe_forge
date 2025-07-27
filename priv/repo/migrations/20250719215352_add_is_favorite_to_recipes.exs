defmodule RecipeForge.Repo.Migrations.AddIsFavoriteToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :is_favorite, :boolean, default: false, null: false
    end

    create index(:recipes, [:is_favorite])
  end
end
