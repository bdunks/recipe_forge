defmodule RecipeForgeWeb.RecipeLive.Show do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes
  alias RecipeForgeWeb.SharedHandlers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:recipe, Recipes.get_recipe!(id))
     |> assign(:show_delete_modal, false)}
  end

  @impl true
  def handle_event("toggle_favorite", %{"id" => recipe_id}, socket) do
    SharedHandlers.toggle_favorite(socket, recipe_id)
  end

  @impl true
  def handle_info({:recipe_deleted, _recipe_id}, socket) do
    socket =
      socket
      |> put_flash(:info, "Recipe deleted successfully.")
      |> push_navigate(to: ~p"/recipes")

    {:noreply, socket}
  end

  @impl true
  def handle_info({RecipeForgeWeb.RecipeLive.FormComponent, {:saved, recipe}}, socket) do
    # Reload recipe with proper associations to ensure consistency
    updated_recipe = Recipes.get_recipe!(recipe.id)
    {:noreply, assign(socket, :recipe, updated_recipe)}
  end

  defp page_title(:show), do: "Show Recipe"
  defp page_title(:edit), do: "Edit Recipe"
end
