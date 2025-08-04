defmodule RecipeForgeWeb.RecipeCardGrid do
  @moduledoc """
  A component to render a grid of recipe cards.
  """
  use RecipeForgeWeb, :html

  alias RecipeForgeWeb.RecipeCard

  attr :recipes, :list, required: true, doc: "The list of recipes to render."
  # attr :recipe_to_delete, :map, default: nil, doc: "The recipe currently marked for deletion."

  def recipe_card_grid(assigns) do
    ~H"""
    <div id="recipes-grid" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      <RecipeCard.recipe_card :for={recipe <- @recipes} :key={recipe.id} recipe={recipe} />
    </div>
    """
  end
end
