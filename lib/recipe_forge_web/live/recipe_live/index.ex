defmodule RecipeForgeWeb.RecipeLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes
  alias RecipeForge.Recipes.Recipe

  @impl true
  def mount(_params, _session, socket) do
    url_form = to_form(%{"url" => ""}, as: :url)

    socket =
      socket
      |> assign(:url_form, url_form)
      |> stream(:recipes, Recipes.list_recipes())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipe")
    |> assign(:recipe, Recipes.get_recipe!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe")
    |> assign(:recipe, %Recipe{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "RecipeForge")
    |> assign(:recipe, nil)
  end

  @impl true
  def handle_info({RecipeForgeWeb.RecipeLive.FormComponent, {:saved, recipe}}, socket) do
    {:noreply, stream_insert(socket, :recipes, recipe)}
  end

  @impl true
  def handle_event("generate_from_url", %{"url" => %{"url" => url}}, socket) do
    # For now, redirect to AI generation page with the URL
    {:noreply, push_navigate(socket, to: ~p"/ai_generate?url=#{URI.encode(url)}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _} = Recipes.delete_recipe(recipe)

    {:noreply, stream_delete(socket, :recipes, recipe)}
  end

  def handle_event("toggle_favorite", %{"id" => id}, socket) do
    RecipeForgeWeb.SharedHandlers.toggle_favorite(socket, id)
  end
end
