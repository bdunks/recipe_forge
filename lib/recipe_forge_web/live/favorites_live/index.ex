defmodule RecipeForgeWeb.FavoritesLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes
  alias RecipeForgeWeb.SharedHandlers
  @impl true
  def mount(_params, _session, socket) do
    favorites = Recipes.list_favorite_recipes()

    socket =
      socket
      |> assign(:page_title, "Favorite Recipes")
      |> assign(:has_favorites, length(favorites) > 0)
      |> assign(:recipes, favorites)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_favorite", %{"id" => recipe_id}, socket) do
    SharedHandlers.toggle_favorite(socket, recipe_id)
  end

  @impl true
  def handle_info({:recipe_deleted, recipe_id}, socket) do
    updated_recipes = Enum.reject(socket.assigns.recipes, &(&1.id == recipe_id))

    socket =
      socket
      |> assign(recipes: updated_recipes)
      |> put_flash(:info, "Recipe deleted successfully.")
      |> recalculate_favorites()

    {:noreply, socket}
  end

  defp recalculate_favorites(socket) do
    remaining_favorites = Recipes.list_favorite_recipes()

    socket
    |> assign(:has_favorites, length(remaining_favorites) > 0)
  end
end
