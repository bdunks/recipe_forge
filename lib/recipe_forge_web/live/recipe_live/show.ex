defmodule RecipeForgeWeb.RecipeLive.Show do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:recipe, Recipes.get_recipe!(id))}
  end

  @impl true
  def handle_event("toggle_favorite", _params, socket) do
    recipe = socket.assigns.recipe

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
         |> assign(:recipe, updated_recipe)
         |> put_flash(:info, message)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not update favorites")}
    end
  end

  defp page_title(:show), do: "Show Recipe"
  defp page_title(:edit), do: "Edit Recipe"
end
