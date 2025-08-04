defmodule RecipeForgeWeb.DeleteRecipeComponentTest do
  use RecipeForgeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RecipeForge.RecipesFixtures

  describe "DeleteRecipeComponent" do
    test "renders delete button with icon variant" do
      recipe = recipe_fixture()
      
      component = 
        render_component(RecipeForgeWeb.DeleteRecipeComponent, 
          id: "delete-recipe-#{recipe.id}",
          recipe: recipe,
          variant: :icon
        )
      
      assert component =~ "Delete recipe"
      assert component =~ "hero-trash"
      assert component =~ "phx-click=\"show_modal\""
    end

    test "renders delete button with button variant" do
      recipe = recipe_fixture()
      
      component = 
        render_component(RecipeForgeWeb.DeleteRecipeComponent, 
          id: "delete-recipe-#{recipe.id}",
          recipe: recipe,
          variant: :button
        )
      
      assert component =~ "Delete Recipe"
      assert component =~ "hero-trash"
      assert component =~ "btn-error"
      assert component =~ "phx-click=\"show_modal\""
    end

    test "defaults to icon variant when no variant specified" do
      recipe = recipe_fixture()
      
      component = 
        render_component(RecipeForgeWeb.DeleteRecipeComponent, 
          id: "delete-recipe-#{recipe.id}",
          recipe: recipe
        )
      
      assert component =~ "Delete recipe"
      assert component =~ "btn-circle"
    end

    test "component state starts with modal closed" do
      recipe = recipe_fixture()
      
      # Test the update function behavior
      assigns = %{
        id: "delete-recipe-#{recipe.id}",
        recipe: recipe
      }
      
      socket = %Phoenix.LiveView.Socket{}
      {:ok, updated_socket} = RecipeForgeWeb.DeleteRecipeComponent.update(assigns, socket)
      
      assert updated_socket.assigns.show_modal == false
      assert updated_socket.assigns.variant == :icon
      assert updated_socket.assigns.recipe == recipe
    end
  end
end