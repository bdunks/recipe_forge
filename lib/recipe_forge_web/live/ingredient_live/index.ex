defmodule RecipeForgeWeb.IngredientLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes
  alias RecipeForge.Recipes.Ingredient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :ingredients, Recipes.list_ingredients())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ingredient")
    |> assign(:ingredient, Recipes.get_ingredient!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ingredient")
    |> assign(:ingredient, %Ingredient{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ingredients")
    |> assign(:ingredient, nil)
  end

  @impl true
  def handle_info({RecipeForgeWeb.IngredientLive.FormComponent, {:saved, ingredient}}, socket) do
    {:noreply, stream_insert(socket, :ingredients, ingredient)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ingredient = Recipes.get_ingredient!(id)
    {:ok, _} = Recipes.delete_ingredient(ingredient)

    {:noreply, stream_delete(socket, :ingredients, ingredient)}
  end
end
