defmodule RecipeForge.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias RecipeForge.Recipes.{Category, Ingredient, RecipeIngredient}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipes" do
    field :name, :string
    field :description, :string
    field :instructions, {:array, :string}
    field :prep_time, :string
    field :cook_time, :string
    field :servings, :integer
    field :yield_description, :string
    field :image_url, :string
    field :notes, :string
    field :nutrition, :map

    # Join struct association (for quantity/unit data)
    # Delete join entries if recipe deleted
    has_many :recipe_ingredients, RecipeIngredient, on_delete: :delete_all

    # Convenience association (reads through recipe_ingredients)
    many_to_many :ingredients, Ingredient, join_through: RecipeIngredient, on_replace: :delete

    # Standard many_to_many
    many_to_many :categories, Category, join_through: "recipe_categories", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [
      :name,
      :description,
      :prep_time,
      :cook_time,
      :servings,
      :yield_description,
      :image_url,
      :notes,
      :instructions,
      :nutrition
    ])
    |> validate_required([
      :name,
      :description,
      :servings,
      :yield_description,
      :instructions
    ])

    # -- Association Hnadling
    |> cast_assoc_categories(attrs)
    |> cast_assoc_ingredients(attrs)
  end

  defp cast_assoc_categories(changeset, attrs) do
    case attrs do
      %{"category_ids" => category_ids} ->
        put_assoc(changeset, :categories, get_categories_by_id(category_ids))

      _ ->
        # No categories passed, do nothing
        changeset
    end
  end

  defp get_categories_by_id(ids) do
    RecipeForge.Repo.all(from c in Category, where: c.id in ^ids)
  end

  defp cast_assoc_ingredients(changeset, _attrs) do
    cast_assoc(changeset, :recipe_ingredients, sort_param: :display_order, required: false)
  end
end
