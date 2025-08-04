defmodule RecipeForgeWeb.SearchLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes
  alias RecipeForgeWeb.SharedHandlers

  @impl true
  def mount(params, _session, socket) do
    query = Map.get(params, "q", "")

    socket =
      socket
      |> assign(:search_form, to_form(%{"q" => query}, as: :search))
      |> assign(:query, query)
      |> assign(:page_title, "Search Recipes")
      |> perform_search(query)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    query = Map.get(params, "q", "")

    socket =
      socket
      |> assign(:search_form, to_form(%{"q" => query}, as: :search))
      |> assign(:query, query)
      |> perform_search(query)

    {:noreply, socket}
  end

  # Handle for the form submission
  @impl true
  def handle_event("search", %{"search" => %{"q" => query}}, socket) do
    {:noreply, push_patch(socket, to: ~p"/search?q=#{URI.encode(query)}")}
  end

  # Handle for the example button/span clicks.
  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply, push_patch(socket, to: ~p"/search?q=#{URI.encode(query)}")}
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
      |> perform_search(socket.assigns.query)

    {:noreply, socket}
  end

  defp perform_search(socket, "") do
    socket
    |> assign(:recipes, [])
    |> assign(:recipe_count, 0)
  end

  defp perform_search(socket, query) when is_binary(query) do
    recipes = search_recipes(query)

    socket
    |> assign(:recipes, recipes)
    |> assign(:recipe_count, length(recipes))
  end

  # Use database search for better performance
  defp search_recipes(query) do
    Recipes.search_recipes(query)
  end
end
