defmodule RecipeForgeWeb.SearchLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes

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

  @impl true
  def handle_event("search", %{"search" => %{"q" => query}}, socket) do
    {:noreply, push_patch(socket, to: ~p"/search?q=#{URI.encode(query)}")}
  end

  def handle_event("toggle_favorite", %{"id" => id}, socket) do
    RecipeForgeWeb.SharedHandlers.toggle_favorite(socket, id)
  end

  defp perform_search(socket, "") do
    socket
    |> stream(:recipes, [])
    |> assign(:recipe_count, 0)
  end

  defp perform_search(socket, query) when is_binary(query) do
    recipes = search_recipes(query)
    socket
    |> stream(:recipes, recipes)
    |> assign(:recipe_count, length(recipes))
  end

  # Use database search for better performance
  defp search_recipes(query) do
    Recipes.search_recipes(query)
  end
end
