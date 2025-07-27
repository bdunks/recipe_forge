defmodule RecipeForge.RecipesFavoritesTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes
  import RecipeForge.RecipesFixtures

  describe "favorites" do
    test "list_favorite_recipes/0 returns only favorite recipes" do
      favorite_recipe = recipe_fixture(%{"name" => "Favorite Recipe", "is_favorite" => true})
      regular_recipe = recipe_fixture(%{"name" => "Regular Recipe", "is_favorite" => false})

      favorites = Recipes.list_favorite_recipes()

      assert length(favorites) == 1
      assert hd(favorites).id == favorite_recipe.id
      refute Enum.any?(favorites, &(&1.id == regular_recipe.id))
    end

    test "list_favorite_recipes/0 returns empty list when no favorites" do
      recipe_fixture(%{"name" => "Regular Recipe", "is_favorite" => false})

      favorites = Recipes.list_favorite_recipes()

      assert favorites == []
    end

    test "toggle_favorite/1 toggles favorite status from false to true" do
      recipe = recipe_fixture(%{"name" => "Test Recipe", "is_favorite" => false})

      assert {:ok, updated_recipe} = Recipes.toggle_favorite(recipe)
      assert updated_recipe.is_favorite == true
    end

    test "toggle_favorite/1 toggles favorite status from true to false" do
      recipe = recipe_fixture(%{"name" => "Test Recipe", "is_favorite" => true})

      assert {:ok, updated_recipe} = Recipes.toggle_favorite(recipe)
      assert updated_recipe.is_favorite == false
    end

    test "favorites are preserved when updating other recipe fields" do
      recipe = recipe_fixture(%{"name" => "Test Recipe", "is_favorite" => true})

      assert {:ok, updated_recipe} = Recipes.update_recipe(recipe, %{"name" => "Updated Recipe"})
      assert updated_recipe.is_favorite == true
      assert updated_recipe.name == "Updated Recipe"
    end

    test "new recipes default to non-favorite" do
      {:ok, recipe} =
        Recipes.create_recipe(%{
          "name" => "New Recipe",
          "description" => "Test description",
          "instructions" => "Test instructions",
          "servings" => 4,
          "yield_description" => "4 servings"
        })

      assert recipe.is_favorite == false
    end

    test "can create recipe as favorite" do
      {:ok, recipe} =
        Recipes.create_recipe(%{
          "name" => "New Favorite",
          "description" => "Test description",
          "instructions" => "Test instructions",
          "servings" => 2,
          "yield_description" => "2 servings",
          "is_favorite" => true
        })

      assert recipe.is_favorite == true
    end
  end
end
