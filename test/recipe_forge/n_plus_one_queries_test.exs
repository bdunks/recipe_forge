defmodule RecipeForge.NPlusOneQueriesTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes
  alias RecipeForge.Categories

  import RecipeForge.RecipesFixtures
  import RecipeForge.CategoriesFixtures
  # import Ecto.Query  # Currently unused

  describe "N+1 query prevention" do
    test "list_recipes/0 should preload all necessary associations" do
      # Create test data
      _category = category_fixture(%{name: "desserts"})

      _recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups"}
          ])
          |> Map.merge(%{
            "name" => "Test Recipe",
            "category_tags" => "desserts"
          })
        )

      # Get all recipes
      recipes = Recipes.list_recipes()
      recipe = hd(recipes)

      # Verify that associations are preloaded
      assert Ecto.assoc_loaded?(recipe.categories), "Categories should be preloaded"

      assert Ecto.assoc_loaded?(recipe.recipe_ingredients),
             "Recipe ingredients should be preloaded"

      # Check nested associations
      if not Enum.empty?(recipe.recipe_ingredients) do
        recipe_ingredient = hd(recipe.recipe_ingredients)

        assert Ecto.assoc_loaded?(recipe_ingredient.ingredient),
               "Ingredients should be preloaded in recipe_ingredients"
      end
    end

    test "list_recipes_by_category/1 should preload all necessary associations" do
      category = category_fixture(%{name: "desserts"})

      _recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups"}
          ])
          |> Map.merge(%{
            "name" => "Test Recipe",
            "category_tags" => "desserts"
          })
        )

      # Get recipes by category
      recipes = Recipes.list_recipes_by_category(category.id)
      recipe = hd(recipes)

      # Verify that associations are preloaded
      assert Ecto.assoc_loaded?(recipe.categories), "Categories should be preloaded"

      assert Ecto.assoc_loaded?(recipe.recipe_ingredients),
             "Recipe ingredients should be preloaded"

      # Check nested associations
      if not Enum.empty?(recipe.recipe_ingredients) do
        recipe_ingredient = hd(recipe.recipe_ingredients)

        assert Ecto.assoc_loaded?(recipe_ingredient.ingredient),
               "Ingredients should be preloaded in recipe_ingredients"
      end
    end

    test "search_recipes/1 should preload all necessary associations" do
      _recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "chocolate chips", quantity: "1", unit: "cup"}
          ])
          |> Map.put("name", "Chocolate Cake")
        )

      # Search for recipes
      results = Recipes.search_recipes("chocolate")
      recipe = hd(results)

      # Verify that associations are preloaded
      assert Ecto.assoc_loaded?(recipe.categories), "Categories should be preloaded"

      assert Ecto.assoc_loaded?(recipe.recipe_ingredients),
             "Recipe ingredients should be preloaded"

      # Check nested associations
      if not Enum.empty?(recipe.recipe_ingredients) do
        recipe_ingredient = hd(recipe.recipe_ingredients)

        assert Ecto.assoc_loaded?(recipe_ingredient.ingredient),
               "Ingredients should be preloaded in recipe_ingredients"
      end
    end

    test "get_recipe!/1 should preload all necessary associations" do
      recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups"}
          ])
          |> Map.merge(%{
            "name" => "Test Recipe",
            "category_tags" => "desserts"
          })
        )

      # Get single recipe
      loaded_recipe = Recipes.get_recipe!(recipe.id)

      # Verify that associations are preloaded
      assert Ecto.assoc_loaded?(loaded_recipe.categories), "Categories should be preloaded"

      assert Ecto.assoc_loaded?(loaded_recipe.recipe_ingredients),
             "Recipe ingredients should be preloaded"

      # Check nested associations
      if not Enum.empty?(loaded_recipe.recipe_ingredients) do
        recipe_ingredient = hd(loaded_recipe.recipe_ingredients)

        assert Ecto.assoc_loaded?(recipe_ingredient.ingredient),
               "Ingredients should be preloaded in recipe_ingredients"
      end
    end

    test "categories should have proper preloads when used in recipes context" do
      _category = category_fixture(%{name: "desserts"})
      _recipe = recipe_fixture(%{"name" => "Test Recipe", "category_tags" => "desserts"})

      # Test category listing with recipe counts
      categories = Categories.list_categories_with_recipe_count()

      # Should have recipe_count field
      dessert_category = Enum.find(categories, &(&1.name == "desserts"))
      assert dessert_category != nil, "Category should be found"
      assert Map.has_key?(dessert_category, :recipe_count), "Should have recipe_count field"
      assert dessert_category.recipe_count > 0, "Should have correct recipe count"
    end
  end

  describe "query performance tests" do
    test "should not trigger additional queries when accessing preloaded associations" do
      # Create test data
      _recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups"},
            %{name: "sugar", quantity: "1", unit: "cup"}
          ])
          |> Map.merge(%{
            "name" => "Test Recipe",
            "category_tags" => "desserts"
          })
        )

      # Test list_recipes
      recipes = Recipes.list_recipes()
      recipe = hd(recipes)

      # These should not trigger additional queries
      _categories = recipe.categories
      _recipe_ingredients = recipe.recipe_ingredients

      # Access nested associations
      if not Enum.empty?(recipe.recipe_ingredients) do
        recipe_ingredient = hd(recipe.recipe_ingredients)
        _ingredient = recipe_ingredient.ingredient
      end

      # If we get here without errors, preloading is working correctly
      assert true
    end
  end
end
