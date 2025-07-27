defmodule RecipeForgeWeb.BrowseLiveTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures
  import RecipeForge.CategoriesFixtures

  setup :setup_conn

  describe "Index" do
    test "lists all recipes by default", %{conn: conn} do
      recipe1 = recipe_fixture(%{"name" => "Recipe 1"})
      recipe2 = recipe_fixture(%{"name" => "Recipe 2"})

      {:ok, _index_live, html} = live(conn, ~p"/browse")

      assert html =~ "Browse Recipes"
      assert html =~ "All Recipes"
      assert html =~ recipe1.name
      assert html =~ recipe2.name
    end

    test "shows empty state when no recipes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/browse")

      assert html =~ "No recipes found"
      assert html =~ "No recipes found"
    end

    test "only shows categories with recipes", %{conn: conn} do
      category_with_recipes = category_fixture(%{"name" => "mains"})
      category_without_recipes = category_fixture(%{"name" => "empty"})

      recipe_fixture(%{"name" => "Test Recipe", "category_tags" => "mains"})

      {:ok, _index_live, html} = live(conn, ~p"/browse")

      assert html =~ category_with_recipes.name
      refute html =~ category_without_recipes.name
    end

    test "filters recipes by category", %{conn: conn} do
      category = category_fixture(%{"name" => "desserts"})
      recipe1 = recipe_fixture(%{"name" => "Chocolate Cake", "category_tags" => "desserts"})
      recipe2 = recipe_fixture(%{"name" => "Chicken Soup", "category_tags" => "soups"})

      {:ok, index_live, _html} = live(conn, ~p"/browse")

      # Click on category filter
      index_live
      |> element("[phx-click='filter_by_category'][phx-value-category_id='#{category.id}']")
      |> render_click()

      assert_patch(index_live, ~p"/browse?category=#{category.id}")

      html = render(index_live)
      assert html =~ "desserts Recipes"
      assert html =~ recipe1.name
      refute html =~ recipe2.name
    end

    test "handles invalid category id gracefully", %{conn: conn} do
      recipe = recipe_fixture(%{"name" => "Test Recipe"})

      {:ok, _index_live, html} = live(conn, ~p"/browse?category=invalid-uuid")

      assert html =~ "All Recipes"
      assert html =~ recipe.name
    end

    test "shows all recipes when clicking 'All' category", %{conn: conn} do
      category = category_fixture(%{"name" => "desserts"})
      recipe1 = recipe_fixture(%{"name" => "Chocolate Cake", "category_tags" => "desserts"})
      recipe2 = recipe_fixture(%{"name" => "Chicken Soup", "category_tags" => "soups"})

      {:ok, index_live, _html} = live(conn, ~p"/browse?category=#{category.id}")

      # Click on "All" category
      index_live
      |> element("[phx-click='filter_by_category'][phx-value-category_id='']")
      |> render_click()

      assert_patch(index_live, ~p"/browse")

      html = render(index_live)
      assert html =~ "All Recipes"
      assert html =~ recipe1.name
      assert html =~ recipe2.name
    end

    test "displays recipe counts for categories", %{conn: conn} do
      category = category_fixture(%{"name" => "desserts"})
      recipe_fixture(%{"name" => "Cake 1", "category_tags" => "desserts"})
      recipe_fixture(%{"name" => "Cake 2", "category_tags" => "desserts"})

      {:ok, _index_live, html} = live(conn, ~p"/browse")

      assert html =~ category.name
      assert html =~ ~r/2\s*<\/span>/
    end

    test "navigates to recipe details", %{conn: conn} do
      recipe = recipe_fixture(%{"name" => "Test Recipe"})

      {:ok, index_live, _html} = live(conn, ~p"/browse")

      index_live
      |> element("#recipes-#{recipe.id} a")
      |> render_click()

      assert_redirected(index_live, ~p"/recipes/#{recipe}")
    end
  end

  defp setup_conn(_) do
    %{conn: build_conn()}
  end
end
