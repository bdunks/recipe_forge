defmodule RecipeForgeWeb.FavoritesLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes

  @impl true
  def mount(_params, _session, socket) do
    favorites = Recipes.list_favorite_recipes()

    socket =
      socket
      |> assign(:page_title, "Favorite Recipes")
      |> assign(:has_favorites, length(favorites) > 0)
      |> stream(:recipes, favorites)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_favorite", %{"id" => id}, socket) do
    recipe = Recipes.get_recipe!(id)

    case Recipes.toggle_favorite(recipe) do
      {:ok, updated_recipe} ->
        if updated_recipe.is_favorite do
          # Recipe was favorited (shouldn't happen on favorites page, but handle gracefully)
          {:noreply, put_flash(socket, :info, "Recipe added to favorites")}
        else
          # Recipe was unfavorited - remove from favorites page
          remaining_favorites = Recipes.list_favorite_recipes()

          {:noreply,
           socket
           |> stream_delete(:recipes, recipe)
           |> assign(:has_favorites, length(remaining_favorites) > 0)
           |> put_flash(:info, "Recipe removed from favorites")}
        end

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not update favorite status")}
    end
  end
end
