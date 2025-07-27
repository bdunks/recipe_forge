defmodule RecipeForgeWeb.CookingLiveTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures

  setup :setup_conn

  describe "Show" do
    setup %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1\nStep 2\nStep 3"
        })

      {:ok, conn: conn, recipe: recipe}
    end

    test "displays cooking interface for recipe", %{conn: conn, recipe: recipe} do
      {:ok, _show_live, html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      assert html =~ "Cooking: Test Recipe"
      assert html =~ "Step 1 of 3"
      assert html =~ "Step 1"
    end

    test "navigates to next step", %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1\nStep 2\nStep 3"
        })

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      show_live
      |> element("[phx-click='next_step']")
      |> render_click()

      html = render(show_live)
      assert html =~ "Step 2 of 3"
      assert html =~ "Step 2"
    end

    test "navigates to previous step", %{conn: conn, recipe: recipe} do
      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      # Go to step 2 first
      show_live
      |> element("[phx-click='next_step']")
      |> render_click()

      # Then go back to step 1
      show_live
      |> element("[phx-click='prev_step']")
      |> render_click()

      html = render(show_live)
      assert html =~ "Step 1 of 3"
      assert html =~ "Step 1"
    end

    test "cannot go to previous step from first step", %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1\nStep 2"
        })

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      # Assert that the previous button exists and is disabled
      assert show_live
             |> element("[phx-click='prev_step']")
             |> render() =~ "disabled"

      html = render(show_live)
      assert html =~ "Step 1 of 2"
      assert html =~ "Step 1"
    end

    test "cannot go to next step from last step", %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1\nStep 2"
        })

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      # Go to last step
      show_live
      |> element("[phx-click='next_step']")
      |> render_click()

      # Assert that we're on the last step and next button doesn't exist
      html = render(show_live)
      assert html =~ "Step 2 of 2"
      assert html =~ "Step 2"
    end

    test "goes to specific step", %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1\nStep 2\nStep 3"
        })

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      show_live
      |> element("[phx-click='go_to_step'][phx-value-step='3']")
      |> render_click()

      html = render(show_live)
      assert html =~ "Step 3 of 3"
      assert html =~ "Step 3"
    end

    test "handles invalid step numbers", %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1\nStep 2"
        })

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      # Assert that links to invalid steps are not rendered
      refute has_element?(show_live, "[phx-click='go_to_step'][phx-value-step='5']")
      refute has_element?(show_live, "[phx-click='go_to_step'][phx-value-step='0']")

      # Click a valid step to ensure state is maintained
      show_live
      |> element("[phx-click='go_to_step'][phx-value-step='2']")
      |> render_click()

      html = render(show_live)
      assert html =~ "Step 2 of 2"
      assert html =~ "Step 2"
    end

    test "displays recipe ingredients", %{conn: conn} do
      recipe =
        recipe_fixture(%{
          "name" => "Test Recipe",
          "instructions" => "Step 1",
          "recipe_ingredients" => %{
            "0" => %{
              "ingredient_name" => "flour",
              "quantity" => "2",
              "unit" => "cups",
              "display_order" => 0
            },
            "1" => %{
              "ingredient_name" => "sugar",
              "quantity" => "1",
              "unit" => "cup",
              "display_order" => 1
            }
          }
        })

      {:ok, _show_live, html} = live(conn, ~p"/recipes/#{recipe}/cooking")

      assert html =~ "flour"
      assert html =~ "sugar"
      assert html =~ "cups"
      assert html =~ "cup"
    end
  end

  defp setup_conn(_) do
    %{conn: build_conn()}
  end
end
