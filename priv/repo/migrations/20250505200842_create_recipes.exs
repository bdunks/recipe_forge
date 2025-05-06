defmodule RecipeForge.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :descriptions, :text
      add :prep_time, :string
      add :cook_time, :string
      add :servings, :integer
      add :yield_description, :string
      add :image_url, :string
      add :notes, :text
      add :instructions, {:array, :string}
      add :nutrition, :map

      timestamps(type: :utc_datetime)
    end
  end
end
