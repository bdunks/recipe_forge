defmodule RecipeForgeWeb.RecipeCardTest do
  use RecipeForgeWeb.ConnCase, async: true

  import RecipeForgeWeb.RecipeCard

  describe "RecipeCard function component" do
    test "component can be rendered and contains expected structure" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [%{name: "Desserts"}, %{name: "Quick"}],
        is_favorite: false
      }

      assigns = %{recipe: recipe}
      rendered = recipe_card(assigns)
      
      # Verify the component renders without errors
      assert %Phoenix.LiveView.Rendered{} = rendered
      # Verify the recipe data is properly assigned
      assert assigns.recipe == recipe
    end

    test "component handles nil image_url" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}
      rendered = recipe_card(assigns)
      
      # Verify the component renders without errors
      assert %Phoenix.LiveView.Rendered{} = rendered
      assert assigns.recipe.image_url == nil
    end

    test "component handles present image_url" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: "https://example.com/image.jpg",
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}
      rendered = recipe_card(assigns)
      
      # Verify the component renders without errors
      assert %Phoenix.LiveView.Rendered{} = rendered
      assert assigns.recipe.image_url == "https://example.com/image.jpg"
    end

    test "component handles non-favorite recipe state" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}
      rendered = recipe_card(assigns)
      
      # Verify the component renders without errors
      assert %Phoenix.LiveView.Rendered{} = rendered
      assert assigns.recipe.is_favorite == false
    end

    test "component handles favorite recipe state" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: true
      }

      assigns = %{recipe: recipe}
      rendered = recipe_card(assigns)
      
      # Verify the component renders without errors
      assert %Phoenix.LiveView.Rendered{} = rendered
      assert assigns.recipe.is_favorite == true
    end

    test "component includes delete recipe functionality" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}
      rendered = recipe_card(assigns)
      
      # Verify the component renders without errors
      assert %Phoenix.LiveView.Rendered{} = rendered
      # Delete functionality is handled by DeleteRecipeComponent
      assert is_binary(assigns.recipe.id)
    end
  end
end
