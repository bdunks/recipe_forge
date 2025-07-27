defmodule RecipeForgeWeb.FavoritesLiveTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures

  setup :setup_conn

  describe "Index" do
    test "lists favorite recipes", %{conn: conn} do
      _recipe1 = recipe_fixture(%{"name" => "Favorite Recipe 1", "is_favorite" => true})
      _recipe2 = recipe_fixture(%{"name" => "Regular Recipe", "is_favorite" => false})
      _recipe3 = recipe_fixture(%{"name" => "Favorite Recipe 2", "is_favorite" => true})

      {:ok, _index_live, html} = live(conn, ~p"/favorites")

      assert html =~ "Favorite Recipes"
      assert html =~ "Favorite Recipe 1"
      assert html =~ "Favorite Recipe 2"
      refute html =~ "Regular Recipe"
    end

    test "shows empty state when no favorites", %{conn: conn} do
      recipe_fixture(%{"name" => "Regular Recipe", "is_favorite" => false})

      {:ok, _index_live, html} = live(conn, ~p"/favorites")

      assert html =~ "No Favorite Recipes Yet"
      assert html =~ "Start building your collection"
    end

    test "removes recipe from favorites", %{conn: conn} do
      recipe = recipe_fixture(%{"name" => "Favorite Recipe", "is_favorite" => true})

      {:ok, index_live, _html} = live(conn, ~p"/favorites")

      assert has_element?(index_live, "#recipes-#{recipe.id}")

      index_live
      |> element("#recipes-#{recipe.id} [phx-click='toggle_favorite']")
      |> render_click()

      refute has_element?(index_live, "#recipes-#{recipe.id}")
      assert render(index_live) =~ "No Favorite Recipes Yet"
    end

    test "navigates to recipe details when card is clicked", %{conn: conn} do
      recipe = recipe_fixture(%{"name" => "Favorite Recipe", "is_favorite" => true})

      {:ok, index_live, _html} = live(conn, ~p"/favorites")

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
