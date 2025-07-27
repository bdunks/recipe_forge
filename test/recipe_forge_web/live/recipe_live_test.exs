defmodule RecipeForgeWeb.RecipeLiveTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures

  @create_attrs %{
    "name" => "Test Recipe",
    "instructions" => "Step 1\nStep 2",
    "description" => "A test recipe",
    "prep_time" => "10 min",
    "cook_time" => "20 min",
    "servings" => 4,
    "yield_description" => "4 servings",
    "image_url" => "https://example.com/test.jpg",
    "notes" => "Test notes",
    "category_tags" => "test category"
  }
  @update_attrs %{
    "name" => "Updated Test Recipe",
    "instructions" => "Updated step 1\nUpdated step 2",
    "description" => "An updated test recipe",
    "prep_time" => "15 min",
    "cook_time" => "25 min",
    "servings" => 6,
    "yield_description" => "6 servings",
    "image_url" => "https://example.com/updated.jpg",
    "notes" => "Updated notes"
  }
  @invalid_attrs %{
    "name" => nil,
    "instructions" => nil,
    "description" => nil,
    "servings" => nil,
    "yield_description" => nil
  }

  defp create_recipe(_) do
    recipe = recipe_fixture()
    %{recipe: recipe}
  end

  describe "Index" do
    setup [:create_recipe]

    test "lists all recipes", %{conn: conn, recipe: recipe} do
      {:ok, _index_live, html} = live(conn, ~p"/recipes")

      assert html =~ "RecipeForge"
      assert html =~ recipe.name
    end

    test "saves new recipe", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/recipes")

      assert index_live |> element("a[title='Create Recipe']") |> render_click()
      assert_redirect(index_live, ~p"/recipes/new")

      # Follow the redirect to the new recipe page
      {:ok, index_live, _html} = live(conn, ~p"/recipes/new")
      assert render(index_live) =~ "New Recipe"

      assert index_live
             |> form("#recipe-form", recipe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#recipe-form", recipe: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/recipes")

      html = render(index_live)
      assert html =~ "Recipe created successfully"
      assert html =~ "Test Recipe"
    end

    test "updates recipe via detail page", %{conn: conn, recipe: recipe} do
      {:ok, index_live, _html} = live(conn, ~p"/recipes")

      # Click on recipe card to navigate to detail page
      assert index_live |> element("#recipes-#{recipe.id} a") |> render_click()
      assert_redirect(index_live, ~p"/recipes/#{recipe}")

      # Navigate to detail page and test edit from there
      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      assert show_live
             |> form("#recipe-form", recipe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#recipe-form", recipe: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/recipes/#{recipe}")

      html = render(show_live)
      assert html =~ "Recipe updated successfully"
      assert html =~ "Updated Test Recipe"
    end

    # Recipe cards don't have delete functionality - delete should be tested
    # from the recipe detail page instead if delete functionality exists
  end

  describe "Show" do
    setup [:create_recipe]

    test "displays recipe", %{conn: conn, recipe: recipe} do
      {:ok, _show_live, html} = live(conn, ~p"/recipes/#{recipe}")

      assert html =~ recipe.name
    end

    test "updates recipe within modal", %{conn: conn, recipe: recipe} do
      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      assert show_live
             |> form("#recipe-form", recipe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#recipe-form", recipe: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/recipes/#{recipe}")

      html = render(show_live)
      assert html =~ "Recipe updated successfully"
      assert html =~ "Updated Test Recipe"
    end
  end

  describe "Ingredient handling" do
    test "creates recipe without ingredients", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/recipes")

      assert index_live |> element("a[title='Create Recipe']") |> render_click()
      assert_redirect(index_live, ~p"/recipes/new")

      # Follow the redirect to the new recipe page
      {:ok, index_live, _html} = live(conn, ~p"/recipes/new")
      assert render(index_live) =~ "New Recipe"

      # Create recipe without ingredients first
      recipe_attrs = %{
        "name" => "Recipe without Ingredients",
        "instructions" => "Mix and cook",
        "description" => "A simple recipe",
        "prep_time" => "10 min",
        "cook_time" => "20 min",
        "servings" => 4,
        "yield_description" => "4 servings",
        "category_tags" => "test category"
      }

      assert index_live
             |> form("#recipe-form", recipe: recipe_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/recipes")

      html = render(index_live)
      assert html =~ "Recipe created successfully"
      assert html =~ "Recipe without Ingredients"
    end

    test "edits recipe with existing ingredients", %{conn: conn} do
      # Create a recipe with ingredients first
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups", notes: "sifted"}
          ])
        )

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # The form should show the existing ingredient
      html = render(show_live)
      assert html =~ "flour"
      assert html =~ "sifted"

      # Update the ingredient
      [ingredient] = recipe.recipe_ingredients

      updated_recipe = %{
        "name" => "Updated Recipe",
        "recipe_ingredients" => %{
          "0" => %{
            "id" => ingredient.id,
            "ingredient_name" => "updated_flour",
            "quantity" => "3",
            "unit" => "cups",
            "notes" => "updated notes"
          }
        }
      }

      assert show_live
             |> form("#recipe-form", recipe: updated_recipe)
             |> render_submit()

      assert_patch(show_live, ~p"/recipes/#{recipe}")

      html = render(show_live)
      assert html =~ "Recipe updated successfully"
    end

    test "displays form for recipe without ingredients", %{conn: conn} do
      # Create a recipe without ingredients
      recipe = recipe_fixture()

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # Should show the form but no ingredient fields
      html = render(show_live)
      assert html =~ "Ingredients"
      assert html =~ "Add Ingredient"

      # Should not have any ingredient input fields
      refute has_element?(show_live, "input[name*='ingredient_name']")
    end

    test "removes ingredient from existing recipe", %{conn: conn} do
      # Create a recipe with ingredients first
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups", notes: "sifted"}
          ])
        )

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # Mark ingredient for deletion
      [ingredient] = recipe.recipe_ingredients

      recipe_with_deletion = %{
        "recipe_ingredients" => %{
          "0" => %{
            "id" => ingredient.id,
            "ingredient_name" => "flour",
            "quantity" => "2",
            "unit" => "cups",
            "notes" => "sifted",
            "_destroy" => "true"
          }
        }
      }

      assert show_live
             |> form("#recipe-form", recipe: recipe_with_deletion)
             |> render_submit()

      assert_patch(show_live, ~p"/recipes/#{recipe}")

      html = render(show_live)
      assert html =~ "Recipe updated successfully"
    end

    test "displays ingredient fields for existing ingredients", %{conn: conn} do
      # Create a recipe with one ingredient
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "1", unit: "cup", notes: "original"}
          ])
        )

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # Should show the existing ingredient
      html = render(show_live)
      assert html =~ "flour"
      assert html =~ "original"

      # Should have ingredient input fields
      assert has_element?(show_live, "input[name*='ingredient_name']")
      assert has_element?(show_live, "input[name*='quantity']")
      assert has_element?(show_live, "input[name*='unit']")
      assert has_element?(show_live, "input[name*='notes']")
    end

    test "shows validation error for duplicate ingredient names", %{conn: conn} do
      # Create a recipe with two ingredients
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "1", unit: "cup", notes: "first"},
            %{name: "sugar", quantity: "1", unit: "cup", notes: "different"}
          ])
        )

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # Change second ingredient to have same name as first (duplicate)
      [ingredient1, ingredient2] = recipe.recipe_ingredients

      recipe_with_duplicate = %{
        "recipe_ingredients" => %{
          "0" => %{
            "id" => ingredient1.id,
            "ingredient_name" => "flour",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => "first"
          },
          "1" => %{
            "id" => ingredient2.id,
            # Same name as first ingredient
            "ingredient_name" => "flour",
            "quantity" => "2",
            "unit" => "cups",
            "notes" => "duplicate"
          }
        }
      }

      html =
        show_live
        |> form("#recipe-form", recipe: recipe_with_duplicate)
        |> render_submit()

      # Should show error and not redirect
      assert html =~ "cannot contain duplicate ingredients"
      # Should still be on the edit page
      assert has_element?(show_live, "#recipe-form")
    end

    test "shows validation error for empty ingredient name", %{conn: conn} do
      # Create a recipe with one ingredient
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "1", unit: "cup", notes: "original"}
          ])
        )

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # Clear the ingredient name (make it empty) using form change event
      [ingredient] = recipe.recipe_ingredients

      recipe_with_empty_name = %{
        "recipe_ingredients" => %{
          "0" => %{
            "id" => ingredient.id,
            # Empty name
            "ingredient_name" => "",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => "original"
          }
        }
      }

      # Use render_change to test validation, not render_submit
      html =
        show_live
        |> form("#recipe-form", recipe: recipe_with_empty_name)
        |> render_change()

      # Should show validation error
      assert html =~ "can&#39;t be blank"
      # Should still be on the edit page
      assert has_element?(show_live, "#recipe-form")
    end

    test "allows duplicate ingredient names when one is marked for deletion", %{conn: conn} do
      # Create a recipe with two ingredients with different names
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "1", unit: "cup", notes: "original"},
            %{name: "sugar", quantity: "1", unit: "cup", notes: "different"}
          ])
        )

      {:ok, show_live, _html} = live(conn, ~p"/recipes/#{recipe}")

      assert show_live |> element("a", "Edit Recipe") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, ~p"/recipes/#{recipe}/show/edit")

      # Mark first ingredient for deletion and change second to same name
      [ingredient1, ingredient2] = recipe.recipe_ingredients

      recipe_with_deletion_and_duplicate = %{
        "recipe_ingredients" => %{
          "0" => %{
            "id" => ingredient1.id,
            "ingredient_name" => "flour",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => "original",
            # Mark for deletion
            "_destroy" => "true"
          },
          "1" => %{
            "id" => ingredient2.id,
            # Same name as deleted ingredient
            "ingredient_name" => "flour",
            "quantity" => "2",
            "unit" => "cups",
            "notes" => "replacement"
          }
        }
      }

      assert show_live
             |> form("#recipe-form", recipe: recipe_with_deletion_and_duplicate)
             |> render_submit()

      # Should succeed because first ingredient is being deleted
      assert_patch(show_live, ~p"/recipes/#{recipe}")

      html = render(show_live)
      assert html =~ "Recipe updated successfully"
    end
  end
end
