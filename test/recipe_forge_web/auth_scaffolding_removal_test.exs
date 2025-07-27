defmodule RecipeForgeWeb.AuthScaffoldingRemovalTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures
  # import RecipeForge.CategoriesFixtures  # Currently unused

  describe "Pages work without authentication scaffolding" do
    test "browse page works without authentication setup" do
      # Test that browse page works with just build_conn() - no auth needed
      conn = build_conn()

      {:ok, _live, html} = live(conn, ~p"/browse")
      assert html =~ "Browse Recipes"
    end

    test "search page works without authentication setup" do
      # Test that search page works with just build_conn() - no auth needed  
      conn = build_conn()

      {:ok, _live, html} = live(conn, ~p"/search")
      assert html =~ "Search Recipes"
    end

    test "favorites page works without authentication setup" do
      # Test that favorites page works with just build_conn() - no auth needed
      conn = build_conn()

      {:ok, _live, html} = live(conn, ~p"/favorites")
      assert html =~ "Favorite Recipes"
    end

    test "cooking page works without authentication setup" do
      # Test that cooking page works with just build_conn() - no auth needed
      recipe = recipe_fixture()
      conn = build_conn()

      {:ok, _live, html} = live(conn, ~p"/recipes/#{recipe}/cooking")
      assert html =~ recipe.name
    end

    test "recipe pages work without authentication setup" do
      # Test that recipe index and show pages work without auth
      recipe = recipe_fixture()
      conn = build_conn()

      {:ok, _live, html} = live(conn, ~p"/")
      assert html =~ "Quick Create"

      {:ok, _live, html} = live(conn, ~p"/recipes/#{recipe}")
      assert html =~ recipe.name
    end
  end
end
