defmodule RecipeForge.Repo.Migrations.RecipeFixColumnDescription do
  use Ecto.Migration

  def change do
    rename table("recipes"), :descriptions, to: :description
  end
end
