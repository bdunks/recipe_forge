defmodule RecipeForgeWeb.RecipeCard do
  @moduledoc """
  Recipe card component for displaying recipes in a grid layout.
  """
  use RecipeForgeWeb, :html

  @doc """
  Renders a recipe card with interactive favorite toggle.
  """
  attr :recipe, :map, required: true

  def recipe_card(assigns) do
    ~H"""
    <div
      id={"recipes-#{@recipe.id}"}
      class="card card-compact bg-base-100 shadow-xl hover:shadow-2xl transition-shadow relative"
    >
      <.link navigate={~p"/recipes/#{@recipe.id}"} class="block">
        <figure>
          <img
            :if={@recipe.image_url}
            src={@recipe.image_url}
            alt={@recipe.name}
            class="recipe-card-image"
          />
          <div :if={is_nil(@recipe.image_url)} class="recipe-card-image-placeholder">
            <.icon name="hero-camera" class="h-12 w-12 text-gray-400" />
          </div>
        </figure>
        <div class="card-body">
          <h2 class="card-title text-lg font-semibold">{@recipe.name}</h2>
          <div class="card-actions justify-between items-center">
            <div class="badge-container">
              <div :for={category <- @recipe.categories} class="badge badge-outline text-xs">
                {category.name}
              </div>
            </div>
          </div>
        </div>
      </.link>
      
    <!-- Delete button -->
      <.live_component
        module={RecipeForgeWeb.DeleteRecipeComponent}
        id={"delete-recipe-#{@recipe.id}"}
        recipe={@recipe}
      />
      
    <!-- Interactive favorite toggle button -->
      <button
        phx-click="toggle_favorite"
        phx-value-id={@recipe.id}
        class="button-favorite-card"
        title={
          if Map.get(@recipe, :is_favorite, false),
            do: "Remove from favorites",
            else: "Add to favorites"
        }
      >
        <%= if Map.get(@recipe, :is_favorite, false) do %>
          <.icon name="hero-heart-solid" class="h-5 w-5 text-red-500" />
        <% else %>
          <.icon name="hero-heart" class="h-5 w-5 text-gray-600" />
        <% end %>
      </button>
    </div>
    """
  end
end
