defmodule RecipeForgeWeb.SharedHandlers do
  use RecipeForgeWeb, :live_view

  @moduledoc """
  Shared event handlers for LiveView modules to reduce code duplication.

  This module provides common event handling functions that can be used
  across multiple LiveView modules, particularly for operations like
  toggling recipe favorites and updating streams.
  """

  alias RecipeForge.Recipes

  @doc """
  Handles toggling the favorite status of a recipe.

  This function can be used in any LiveView that needs to handle favorite toggling. It will:

  1. Find the recipe by ID and toggle its favorite status in the database
  2. Intelligently update the socket assigns:
     - If a single `@recipe` is assigned, it updates it
     - If a list of `@recipes` is assigned, it updates the specific recipe in the list
     - If on the favorites page, it removes unfavorited recipes from the list
  3. Display appropriate flash messages

  ## Parameters

  - `socket` - The LiveView socket
  - `recipe_id` - The ID of the recipe to toggle

  ## Examples

      def handle_event("toggle_favorite", %{"id" => id}, socket) do
        SharedHandlers.toggle_favorite(socket, id)
      end
  """
  def toggle_favorite(socket, recipe_id) do
    recipe = Recipes.get_recipe!(recipe_id)

    case Recipes.toggle_favorite(recipe) do
      {:ok, updated_recipe} ->
        socket = update_recipe_assigns(socket, updated_recipe)

        message =
          if updated_recipe.is_favorite do
            "Added to favorites!"
          else
            "Removed from favorites"
          end

        {:noreply, put_flash(socket, :info, message)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not update favorites.")}
    end
  end

  defp update_recipe_assigns(socket, updated_recipe) do
    socket
    |> update_single_recipe_assign(updated_recipe)
    |> update_recipes_list_assign(updated_recipe)
  end

  defp update_single_recipe_assign(socket, updated_recipe) do
    if socket.assigns[:recipe] && socket.assigns.recipe.id == updated_recipe.id do
      assign(socket, :recipe, updated_recipe)
    else
      socket
    end
  end

  defp update_recipes_list_assign(socket, updated_recipe) do
    if recipes = socket.assigns[:recipes] do
      is_favorites_page = is_favorites_page?(socket)

      updated_list =
        if is_favorites_page and not updated_recipe.is_favorite do
          # On favorites page, remove unfavorited recipes
          Enum.reject(recipes, &(&1.id == updated_recipe.id))
        else
          # On other pages, update the recipe in the list
          Enum.map(recipes, fn r ->
            if r.id == updated_recipe.id, do: updated_recipe, else: r
          end)
        end

      socket
      |> assign(:recipes, updated_list)
      |> maybe_update_has_favorites(updated_list, is_favorites_page)
    else
      socket
    end
  end

  defp is_favorites_page?(socket) do
    socket.view == RecipeForgeWeb.FavoritesLive.Index
  end

  defp maybe_update_has_favorites(socket, updated_list, true) do
    assign(socket, :has_favorites, !Enum.empty?(updated_list))
  end

  defp maybe_update_has_favorites(socket, _updated_list, false) do
    socket
  end
end
