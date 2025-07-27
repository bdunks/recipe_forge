defmodule RecipeForge.RecipesCategoryFilteringTest do
  use RecipeForge.DataCase

  alias RecipeForge.{Recipes, Categories}
  import RecipeForge.{RecipesFixtures, CategoriesFixtures}

  describe "list_recipes_by_category/1" do
    test "returns all recipes when category_id is nil" do
      recipe1 = recipe_fixture(%{"name" => "Recipe 1"})
      recipe2 = recipe_fixture(%{"name" => "Recipe 2"})

      recipes = Recipes.list_recipes_by_category(nil)

      assert length(recipes) == 2
      recipe_ids = Enum.map(recipes, & &1.id)
      assert recipe1.id in recipe_ids
      assert recipe2.id in recipe_ids
    end

    test "returns only recipes in specified category" do
      category1 = category_fixture(%{name: "desserts"})
      _category2 = category_fixture(%{name: "mains"})

      _recipe1 = recipe_fixture(%{"name" => "Chocolate Cake", "category_tags" => "desserts"})
      _recipe2 = recipe_fixture(%{"name" => "Chicken Curry", "category_tags" => "mains"})
      _recipe3 = recipe_fixture(%{"name" => "Ice Cream", "category_tags" => "desserts"})

      recipes = Recipes.list_recipes_by_category(category1.id)

      assert length(recipes) == 2
      recipe_names = Enum.map(recipes, & &1.name)
      assert "Chocolate Cake" in recipe_names
      assert "Ice Cream" in recipe_names
      refute "Chicken Curry" in recipe_names
    end

    test "returns empty list when category has no recipes" do
      category = category_fixture(%{name: "empty"})
      recipe_fixture(%{"name" => "Test Recipe", "category_tags" => "others"})

      recipes = Recipes.list_recipes_by_category(category.id)

      assert recipes == []
    end

    test "returns recipes with categories preloaded" do
      category = category_fixture(%{name: "desserts"})
      recipe = recipe_fixture(%{"name" => "Chocolate Cake", "category_tags" => "desserts"})

      [returned_recipe] = Recipes.list_recipes_by_category(category.id)

      assert returned_recipe.id == recipe.id
      assert returned_recipe.categories != %Ecto.Association.NotLoaded{}
      assert length(returned_recipe.categories) == 1
      assert hd(returned_recipe.categories).name == "desserts"
    end

    test "handles recipes with multiple categories" do
      category1 = category_fixture(%{name: "desserts"})
      category2 = category_fixture(%{name: "quick"})

      recipe =
        recipe_fixture(%{
          "name" => "Quick Chocolate Cake",
          "category_tags" => "desserts quick"
        })

      # Should appear in both category filters
      dessert_recipes = Recipes.list_recipes_by_category(category1.id)
      quick_recipes = Recipes.list_recipes_by_category(category2.id)

      assert length(dessert_recipes) == 1
      assert length(quick_recipes) == 1
      assert hd(dessert_recipes).id == recipe.id
      assert hd(quick_recipes).id == recipe.id
    end

    test "handles binary UUID properly" do
      category = category_fixture(%{name: "testing"})
      recipe = recipe_fixture(%{"name" => "Test Recipe", "category_tags" => "testing"})

      # Test with binary UUID (as stored in database)
      recipes = Recipes.list_recipes_by_category(category.id)

      assert length(recipes) == 1
      assert hd(recipes).id == recipe.id
    end
  end

  describe "Categories.list_categories_with_recipe_count/0" do
    test "returns categories with correct recipe counts" do
      _category1 = category_fixture(%{name: "desserts"})
      _category2 = category_fixture(%{name: "mains"})

      recipe_fixture(%{"name" => "Cake 1", "category_tags" => "desserts"})
      recipe_fixture(%{"name" => "Cake 2", "category_tags" => "desserts"})
      recipe_fixture(%{"name" => "Curry", "category_tags" => "mains"})

      categories = Categories.list_categories_with_recipe_count()

      desserts_category = Enum.find(categories, &(&1.name == "desserts"))
      main_dishes_category = Enum.find(categories, &(&1.name == "mains"))

      assert desserts_category.recipe_count == 2
      assert main_dishes_category.recipe_count == 1
    end

    test "returns zero count for categories with no recipes" do
      category_fixture(%{name: "empty"})

      categories = Categories.list_categories_with_recipe_count()

      empty_category = Enum.find(categories, &(&1.name == "empty"))
      assert empty_category.recipe_count == 0
    end

    test "returns categories ordered by name" do
      category_fixture(%{name: "Z Category"})
      category_fixture(%{name: "A Category"})
      category_fixture(%{name: "M Category"})

      categories = Categories.list_categories_with_recipe_count()

      category_names = Enum.map(categories, & &1.name)
      assert category_names == Enum.sort(category_names)
    end

    test "handles recipes with multiple categories correctly" do
      _category1 = category_fixture(%{name: "desserts"})
      _category2 = category_fixture(%{name: "quick"})

      recipe_fixture(%{"name" => "Quick Cake", "category_tags" => "desserts quick"})

      categories = Categories.list_categories_with_recipe_count()

      desserts_category = Enum.find(categories, &(&1.name == "desserts"))
      quick_category = Enum.find(categories, &(&1.name == "quick"))

      assert desserts_category.recipe_count == 1
      assert quick_category.recipe_count == 1
    end
  end
end
