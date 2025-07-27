defmodule RecipeForgeWeb.SearchLiveTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures

  setup :setup_conn

  describe "Index" do
    test "renders search page", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/search")

      assert html =~ "Search Recipes"
      assert html =~ "Find Your Perfect Recipe"
    end

    test "shows empty state when no search performed", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/search")

      assert html =~ "Search through your recipe collection"
    end

    test "searches recipes by name", %{conn: conn} do
      _recipe1 = recipe_fixture(%{"name" => "Chocolate Cake"})
      _recipe2 = recipe_fixture(%{"name" => "Vanilla Ice Cream"})

      {:ok, index_live, _html} = live(conn, ~p"/search")

      index_live
      |> form("#search-form", search: %{q: "chocolate"})
      |> render_submit()

      html = render(index_live)
      assert html =~ "Chocolate Cake"
      refute html =~ "Vanilla Ice Cream"
    end

    test "searches recipes by ingredient", %{conn: conn} do
      _recipe1 =
        recipe_fixture(%{
          "name" => "Chocolate Cake",
          "recipe_ingredients" => %{
            "0" => %{
              "ingredient_name" => "flour",
              "quantity" => "2",
              "unit" => "cups",
              "display_order" => 0
            },
            "1" => %{
              "ingredient_name" => "chocolate",
              "quantity" => "1",
              "unit" => "cup",
              "display_order" => 1
            }
          }
        })

      _recipe2 =
        recipe_fixture(%{
          "name" => "Vanilla Ice Cream",
          "recipe_ingredients" => %{
            "0" => %{
              "ingredient_name" => "milk",
              "quantity" => "2",
              "unit" => "cups",
              "display_order" => 0
            },
            "1" => %{
              "ingredient_name" => "vanilla",
              "quantity" => "1",
              "unit" => "tsp",
              "display_order" => 1
            }
          }
        })

      {:ok, index_live, _html} = live(conn, ~p"/search")

      index_live
      |> form("#search-form", search: %{q: "chocolate"})
      |> render_submit()

      html = render(index_live)
      assert html =~ "Chocolate Cake"
      refute html =~ "Vanilla Ice Cream"
    end

    test "shows no results when search finds nothing", %{conn: conn} do
      recipe_fixture(%{"name" => "Chocolate Cake"})

      {:ok, index_live, _html} = live(conn, ~p"/search")

      index_live
      |> form("#search-form", search: %{q: "nonexistent"})
      |> render_submit()

      html = render(index_live)
      assert html =~ "No recipes found"
      assert html =~ "Try searching for"
    end

    test "handles empty search query", %{conn: conn} do
      recipe_fixture(%{"name" => "Test Recipe"})

      {:ok, index_live, _html} = live(conn, ~p"/search")

      index_live
      |> form("#search-form", search: %{q: ""})
      |> render_submit()

      html = render(index_live)
      assert html =~ "Search through your recipe collection"
    end

    test "search is case insensitive", %{conn: conn} do
      recipe_fixture(%{"name" => "Chocolate Cake"})

      {:ok, index_live, _html} = live(conn, ~p"/search")

      index_live
      |> form("#search-form", search: %{q: "CHOCOLATE"})
      |> render_submit()

      html = render(index_live)
      assert html =~ "Chocolate Cake"
    end

    test "navigates to recipe details", %{conn: conn} do
      recipe = recipe_fixture(%{"name" => "Test Recipe"})

      {:ok, index_live, _html} = live(conn, ~p"/search")

      index_live
      |> form("#search-form", search: %{q: "test"})
      |> render_submit()

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
