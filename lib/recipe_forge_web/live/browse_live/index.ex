defmodule RecipeForgeWeb.BrowseLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Categories
  alias RecipeForge.Recipes

  @impl true
  def mount(_params, _session, socket) do
    categories =
      Categories.list_categories_with_recipe_count()
      |> Enum.filter(&(&1.recipe_count > 0))

    categories_map = Map.new(categories, &{&1.id, &1})
    total_recipes = Recipes.count_recipes()
    recipes = Recipes.list_recipes()

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:categories_map, categories_map)
      |> assign(:total_recipes, total_recipes)
      |> assign(:selected_category_id, nil)
      |> assign(:selected_category_name, "All")
      |> assign(:empty_recipes, length(recipes) == 0)
      |> stream(:recipes, recipes)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    category_id = Map.get(params, "category")

    {recipes, selected_category_name} =
      case category_id do
        nil ->
          {Recipes.list_recipes(), "All"}

        id ->
          case Map.get(socket.assigns.categories_map, id) do
            nil ->
              # Category not found or invalid, return all recipes
              {Recipes.list_recipes(), "All"}

            category ->
              {Recipes.list_recipes_by_category(id), category.name}
          end
      end

    socket
    |> assign(:page_title, "Browse Recipes")
    |> assign(:selected_category_id, category_id)
    |> assign(:selected_category_name, selected_category_name)
    |> assign(:empty_recipes, length(recipes) == 0)
    |> stream(:recipes, recipes, reset: true)
  end

  @impl true
  def handle_event("filter_by_category", %{"category_id" => category_id}, socket) do
    # Convert empty string to nil for "All" category
    category_id = if category_id == "", do: nil, else: category_id

    path =
      case category_id do
        nil -> ~p"/browse"
        id -> ~p"/browse?#{%{category: id}}"
      end

    {:noreply, push_patch(socket, to: path)}
  end

  def handle_event("toggle_favorite", %{"id" => id}, socket) do
    RecipeForgeWeb.SharedHandlers.toggle_favorite(socket, id)
  end
end
