defmodule RecipeForge.RecipesTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes

  describe "categories" do
    alias RecipeForge.Recipes.Category

    import RecipeForge.RecipesFixtures

    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Recipes.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Recipes.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Category{} = category} = Recipes.create_category(valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Recipes.update_category(category, update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_category(category, @invalid_attrs)
      assert category == Recipes.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Recipes.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Recipes.change_category(category)
    end
  end

  describe "ingredients" do
    alias RecipeForge.Recipes.Ingredient

    import RecipeForge.RecipesFixtures

    @invalid_attrs %{name: nil}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Recipes.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Recipes.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Ingredient{} = ingredient} = Recipes.create_ingredient(valid_attrs)
      assert ingredient.name == "some name"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Ingredient{} = ingredient} =
               Recipes.update_ingredient(ingredient, update_attrs)

      assert ingredient.name == "some updated name"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Recipes.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Recipes.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Recipes.change_ingredient(ingredient)
    end
  end

  describe "recipes" do
    alias RecipeForge.Recipes.Recipe

    import RecipeForge.RecipesFixtures

    @invalid_attrs %{
      name: nil,
      instructions: nil,
      description: nil,
      prep_time: nil,
      cook_time: nil,
      servings: nil,
      yield_description: nil,
      image_url: nil,
      notes: nil,
      nutrition: nil
    }

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      valid_attrs = %{
        name: "some name",
        instructions: ["option1", "option2"],
        description: "some description",
        prep_time: "some prep_time",
        cook_time: "some cook_time",
        servings: 42,
        yield_description: "some yield_description",
        image_url: "some image_url",
        notes: "some notes",
        nutrition: %{}
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(valid_attrs)
      assert recipe.name == "some name"
      assert recipe.instructions == ["option1", "option2"]
      assert recipe.description == "some description"
      assert recipe.prep_time == "some prep_time"
      assert recipe.cook_time == "some cook_time"
      assert recipe.servings == 42
      assert recipe.yield_description == "some yield_description"
      assert recipe.image_url == "some image_url"
      assert recipe.notes == "some notes"
      assert recipe.nutrition == %{}
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()

      update_attrs = %{
        name: "some updated name",
        instructions: ["option1"],
        description: "some updated description",
        prep_time: "some updated prep_time",
        cook_time: "some updated cook_time",
        servings: 43,
        yield_description: "some updated yield_description",
        image_url: "some updated image_url",
        notes: "some updated notes",
        nutrition: %{}
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, update_attrs)
      assert recipe.name == "some updated name"
      assert recipe.instructions == ["option1"]
      assert recipe.description == "some updated description"
      assert recipe.prep_time == "some updated prep_time"
      assert recipe.cook_time == "some updated cook_time"
      assert recipe.servings == 43
      assert recipe.yield_description == "some updated yield_description"
      assert recipe.image_url == "some updated image_url"
      assert recipe.notes == "some updated notes"
      assert recipe.nutrition == %{}
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
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
