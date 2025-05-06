defmodule RecipeForge.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients, primary_key: false) do
      add :id, :binary_id, primary_key: true

      # Fields specific to the relationship
      add :quantity, :decimal
      add :unit, :string
      add :notes, :string
      add :display_order, :integer

      # FK references
      add :recipe_id, references(:recipes, type: :binary_id, on_delete: :delete_all), null: false
      add :ingredient_id, references(:ingredients, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_ingredients, [:recipe_id, :ingredient_id], unique: true)
  end
end
