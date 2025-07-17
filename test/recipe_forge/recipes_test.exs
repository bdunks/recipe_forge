defmodule RecipeForge.RecipesTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes

  describe "categories" do
    alias RecipeForge.Categories.Category

    import RecipeForge.CategoriesFixtures

    @invalid_attrs %{name: nil}
    @create_attrs %{name: "Test Category"}
    @update_attrs %{name: "Updated Category"}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      [result] = RecipeForge.Categories.list_categories()
      assert result.id == category.id
      assert result.name == category.name
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      result = RecipeForge.Categories.get_category!(category.id)
      assert result.id == category.id
      assert result.name == category.name
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = RecipeForge.Categories.create_category(@create_attrs)
      assert category.name == "Test Category"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecipeForge.Categories.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = RecipeForge.Categories.update_category(category, @update_attrs)
      assert category.name == "Updated Category"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = RecipeForge.Categories.update_category(category, @invalid_attrs)
      result = RecipeForge.Categories.get_category!(category.id)
      assert result.id == category.id
      assert result.name == category.name
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = RecipeForge.Categories.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> RecipeForge.Categories.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = RecipeForge.Categories.change_category(category)
    end
  end

  describe "ingredients" do
    alias RecipeForge.Ingredients.Ingredient

    import RecipeForge.IngredientsFixtures

    @invalid_attrs %{name: nil}
    @create_attrs %{name: "Test Ingredient"}
    @update_attrs %{name: "Updated Ingredient"}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      [result] = RecipeForge.Ingredients.list_ingredients()
      assert result.id == ingredient.id
      assert result.name == ingredient.name
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      result = RecipeForge.Ingredients.get_ingredient!(ingredient.id)
      assert result.id == ingredient.id
      assert result.name == ingredient.name
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{} = ingredient} = RecipeForge.Ingredients.create_ingredient(@create_attrs)
      assert ingredient.name == "Test Ingredient"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecipeForge.Ingredients.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{} = ingredient} =
               RecipeForge.Ingredients.update_ingredient(ingredient, @update_attrs)

      assert ingredient.name == "Updated Ingredient"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = RecipeForge.Ingredients.update_ingredient(ingredient, @invalid_attrs)
      result = RecipeForge.Ingredients.get_ingredient!(ingredient.id)
      assert result.id == ingredient.id
      assert result.name == ingredient.name
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = RecipeForge.Ingredients.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> RecipeForge.Ingredients.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = RecipeForge.Ingredients.change_ingredient(ingredient)
    end
  end

  describe "recipes" do
    alias RecipeForge.Recipes.Recipe

    import RecipeForge.RecipesFixtures

    @invalid_attrs %{
      "name" => nil,
      "instructions" => nil,
      "description" => nil,
      "prep_time" => nil,
      "cook_time" => nil,
      "servings" => nil,
      "yield_description" => nil,
      "image_url" => nil,
      "notes" => nil,
      "nutrition" => nil
    }
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
      "nutrition" => %{},
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
      "notes" => "Updated notes",
      "nutrition" => %{calories: 300}
    }

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      [result] = Recipes.list_recipes()
      assert result.id == recipe.id
      assert result.name == recipe.name
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      result = Recipes.get_recipe!(recipe.id)
      assert result.id == recipe.id
      assert result.name == recipe.name
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@create_attrs)
      assert recipe.name == "Test Recipe"
      assert recipe.instructions == ["Step 1", "Step 2"]
      assert recipe.description == "A test recipe"
      assert recipe.prep_time == "10 min"
      assert recipe.cook_time == "20 min"
      assert recipe.servings == 4
      assert recipe.yield_description == "4 servings"
      assert recipe.image_url == "https://example.com/test.jpg"
      assert recipe.notes == "Test notes"
      assert recipe.nutrition == %{}
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()

      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, @update_attrs)
      assert recipe.name == "Updated Test Recipe"
      assert recipe.instructions == ["Updated step 1", "Updated step 2"]
      assert recipe.description == "An updated test recipe"
      assert recipe.prep_time == "15 min"
      assert recipe.cook_time == "25 min"
      assert recipe.servings == 6
      assert recipe.yield_description == "6 servings"
      assert recipe.image_url == "https://example.com/updated.jpg"
      assert recipe.notes == "Updated notes"
      assert recipe.nutrition == %{calories: 300}
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      result = Recipes.get_recipe!(recipe.id)
      assert result.id == recipe.id
      assert result.name == recipe.name
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end
end
