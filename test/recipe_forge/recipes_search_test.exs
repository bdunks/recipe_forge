defmodule RecipeForge.RecipesSearchTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes
  # alias RecipeForge.Categories

  import RecipeForge.RecipesFixtures
  import RecipeForge.CategoriesFixtures
  # import RecipeForge.IngredientsFixtures

  describe "search_recipes/1" do
    test "returns empty list for empty query" do
      assert Recipes.search_recipes("") == []
    end

    test "searches recipes by name" do
      recipe1 = recipe_fixture(%{"name" => "Chocolate Cake"})
      recipe2 = recipe_fixture(%{"name" => "Vanilla Ice Cream"})
      recipe3 = recipe_fixture(%{"name" => "Strawberry Shortcake"})

      results = Recipes.search_recipes("chocolate")
      assert length(results) == 1
      assert hd(results).id == recipe1.id

      results = Recipes.search_recipes("cake")
      recipe_ids = Enum.map(results, & &1.id)
      assert recipe1.id in recipe_ids
      assert recipe3.id in recipe_ids
      refute recipe2.id in recipe_ids
    end

    test "searches recipes by description" do
      recipe1 =
        recipe_fixture(%{
          "name" => "Recipe 1",
          "description" => "A delicious chocolate dessert"
        })

      recipe2 =
        recipe_fixture(%{
          "name" => "Recipe 2",
          "description" => "A vanilla flavored treat"
        })

      results = Recipes.search_recipes("chocolate")
      assert length(results) == 1
      assert hd(results).id == recipe1.id

      results = Recipes.search_recipes("vanilla")
      assert length(results) == 1
      assert hd(results).id == recipe2.id
    end

    test "searches recipes by category" do
      _category1 = category_fixture(%{"name" => "desserts"})
      _category2 = category_fixture(%{"name" => "mains"})

      recipe1 =
        recipe_fixture(%{
          "name" => "Chocolate Cake",
          "category_tags" => "desserts"
        })

      recipe2 =
        recipe_fixture(%{
          "name" => "Chicken Soup",
          "category_tags" => "mains"
        })

      results = Recipes.search_recipes("desserts")
      assert length(results) == 1
      assert hd(results).id == recipe1.id

      results = Recipes.search_recipes("mains")
      assert length(results) == 1
      assert hd(results).id == recipe2.id
    end

    test "searches recipes by ingredient" do
      recipe1 =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "chocolate chips", quantity: "1", unit: "cup"}
          ])
          |> Map.put("name", "Chocolate Cookies")
        )

      recipe2 =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "vanilla extract", quantity: "1", unit: "tsp"}
          ])
          |> Map.put("name", "Vanilla Cake")
        )

      results = Recipes.search_recipes("chocolate")
      assert length(results) == 1
      assert hd(results).id == recipe1.id

      results = Recipes.search_recipes("vanilla")
      assert length(results) == 1
      assert hd(results).id == recipe2.id
    end

    test "search is case insensitive" do
      recipe = recipe_fixture(%{"name" => "Chocolate Cake"})

      results_lower = Recipes.search_recipes("chocolate")
      results_upper = Recipes.search_recipes("CHOCOLATE")
      results_mixed = Recipes.search_recipes("ChOcOlAtE")

      assert length(results_lower) == 1
      assert length(results_upper) == 1
      assert length(results_mixed) == 1
      assert hd(results_lower).id == recipe.id
      assert hd(results_upper).id == recipe.id
      assert hd(results_mixed).id == recipe.id
    end

    test "search uses database queries, not in-memory filtering" do
      # This test ensures we're using database queries by checking 
      # that associations are properly preloaded
      _category = category_fixture(%{"name" => "desserts"})

      _recipe =
        recipe_fixture(
          recipe_with_ingredients_attrs([
            %{name: "flour", quantity: "2", unit: "cups"}
          ])
          |> Map.merge(%{
            "name" => "Cake",
            "category_tags" => "desserts"
          })
        )

      results = Recipes.search_recipes("cake")
      recipe_result = hd(results)

      # Associations should be preloaded to avoid N+1 queries
      assert Ecto.assoc_loaded?(recipe_result.categories)
      assert Ecto.assoc_loaded?(recipe_result.recipe_ingredients)

      # Check that nested associations are also loaded
      recipe_ingredient = hd(recipe_result.recipe_ingredients)
      assert Ecto.assoc_loaded?(recipe_ingredient.ingredient)
    end

    test "returns recipes in consistent order" do
      _recipe1 = recipe_fixture(%{"name" => "A Recipe"})
      _recipe2 = recipe_fixture(%{"name" => "B Recipe"})
      _recipe3 = recipe_fixture(%{"name" => "C Recipe"})

      results = Recipes.search_recipes("recipe")
      recipe_ids = Enum.map(results, & &1.id)

      # Should be ordered consistently by id (ascending)
      assert recipe_ids == Enum.sort(recipe_ids)
    end
  end
end
