defmodule RecipeForgeWeb.SharedHandlers do
  @moduledoc """
  Shared event handlers for LiveView modules to reduce code duplication.
  
  This module provides common event handling functions that can be used
  across multiple LiveView modules, particularly for operations like
  toggling recipe favorites and updating streams.
  """

  alias RecipeForge.Recipes

  @doc """
  Handles toggling the favorite status of a recipe and updates the stream.
  
  This function can be used in any LiveView that has a stream of recipes
  and needs to handle favorite toggling. It will:
  
  1. Find the recipe by ID
  2. Toggle its favorite status
  3. Update the stream with the modified recipe
  4. Display appropriate flash messages
  
  ## Parameters
  
  - `socket` - The LiveView socket
  - `recipe_id` - The ID of the recipe to toggle
  - `stream_name` - The name of the stream to update (defaults to :recipes)
  
  ## Examples
  
      def handle_event("toggle_favorite", %{"id" => id}, socket) do
        SharedHandlers.toggle_favorite(socket, id)
      end
      
      def handle_event("toggle_favorite", %{"id" => id}, socket) do
        SharedHandlers.toggle_favorite(socket, id, :search_results)
      end
  """
  def toggle_favorite(socket, recipe_id, stream_name \\ :recipes) do
    recipe = Recipes.get_recipe!(recipe_id)

    case Recipes.toggle_favorite(recipe) do
      {:ok, updated_recipe} ->
        message =
          if updated_recipe.is_favorite do
            "Added to favorites!"
          else
            "Removed from favorites"
          end

        {:noreply,
         socket
         |> Phoenix.LiveView.stream_insert(stream_name, updated_recipe)
         |> Phoenix.LiveView.put_flash(:info, message)}

      {:error, _changeset} ->
        {:noreply, Phoenix.LiveView.put_flash(socket, :error, "Could not update favorites")}
    end
  end
end