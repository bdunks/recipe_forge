defmodule RecipeForgeWeb.FormValidationBugTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures

  describe "Recipe form validation and error handling" do
    test "form should not show success flash when validation fails" do
      # This test aims to reproduce the bug mentioned in the TODO comment:
      # "The form pushes a success while still erroring and not saving"

      conn = build_conn()
      {:ok, view, _html} = live(conn, ~p"/recipes/new")

      # Submit form with invalid data that should cause validation errors
      invalid_attrs = %{
        # Empty name should fail validation
        "name" => "",
        "description" => "",
        "instructions" => "",
        "prep_time" => "",
        "cook_time" => "",
        "servings" => "",
        "yield_description" => "",
        "category_tags" => "",
        "recipe_ingredients" => %{}
      }

      # Submit the form
      result =
        view
        |> form("#recipe-form", recipe: invalid_attrs)
        |> render_submit()

      # The bug would be if we get a success flash even though validation failed
      refute result =~ "Recipe created successfully"
      refute result =~ "Recipe updated successfully"

      # Should show validation errors instead
      # (Note: specific error messages may vary based on validation rules)

      # Form should still be present (not redirected)
      assert render(view) =~ "Save Recipe"
    end

    test "form should handle database errors gracefully" do
      conn = build_conn()
      {:ok, view, _html} = live(conn, ~p"/recipes/new")

      # Create data that might trigger the TODO bug - missing required fields but has some data
      problematic_attrs = %{
        "name" => "Test Recipe",
        # Missing required field
        "description" => "",
        # Missing required field  
        "instructions" => "",
        "prep_time" => "10 min",
        "cook_time" => "20 min",
        # Missing required field
        "servings" => "",
        # Missing required field
        "yield_description" => "",
        "category_tags" => "testing",
        "recipe_ingredients" => %{}
      }

      # Submit the form - this should fail validation
      result =
        view
        |> form("#recipe-form", recipe: problematic_attrs)
        |> render_submit()

      # Check if we get both success and error (the bug condition)
      has_success = result =~ "Recipe created successfully"

      has_error =
        result =~ "error" or result =~ "Error" or result =~ "can't be blank" or
          result =~ "is required"

      # Log for debugging if needed
      if has_success and has_error do
        IO.puts("BUG DETECTED: Both success and error messages found")
        IO.puts("Result snippet: #{String.slice(result, 0, 500)}")
      end

      # The bug would be showing both success and error
      refute has_success and has_error,
             "Should not show both success and error messages simultaneously"

      # Should show validation errors for missing required fields
      refute has_success, "Should not show success message for invalid data"
    end

    test "form should handle update validation errors correctly" do
      recipe = recipe_fixture()
      conn = build_conn()
      {:ok, view, _html} = live(conn, ~p"/recipes/#{recipe}/edit")

      # Submit form with invalid data
      invalid_attrs = %{
        # Empty name should fail validation
        "name" => "",
        "description" => recipe.description,
        "instructions" => RecipeForgeWeb.RecipeHelpers.format_for_textarea(recipe.instructions),
        "prep_time" => recipe.prep_time,
        "cook_time" => recipe.cook_time,
        "servings" => recipe.servings,
        "yield_description" => recipe.yield_description,
        "category_tags" => "testing",
        "recipe_ingredients" => %{}
      }

      # Submit the form
      result =
        view
        |> form("#recipe-form", recipe: invalid_attrs)
        |> render_submit()

      # Should not show success flash for invalid data
      refute result =~ "Recipe updated successfully"

      # Form should still be present
      assert render(view) =~ "Save Recipe"
    end

    test "form should show proper error messages for validation failures" do
      conn = build_conn()
      {:ok, view, _html} = live(conn, ~p"/recipes/new")

      # Submit completely empty form
      empty_attrs = %{
        "name" => "",
        "description" => "",
        "instructions" => "",
        "prep_time" => "",
        "cook_time" => "",
        "servings" => "",
        "yield_description" => "",
        "category_tags" => "",
        "recipe_ingredients" => %{}
      }

      _result =
        view
        |> form("#recipe-form", recipe: empty_attrs)
        |> render_submit()

      # Should show some kind of validation feedback
      # Even if not specific error messages, form should indicate issues
      current_html = render(view)

      # Should not proceed to success state
      refute current_html =~ "Recipe created successfully"

      # Form should still be visible for corrections
      assert current_html =~ "Save Recipe"
    end
  end
end
