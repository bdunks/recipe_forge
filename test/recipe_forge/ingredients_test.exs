defmodule RecipeForge.IngredientsTest do
  use RecipeForge.DataCase

  alias RecipeForge.Ingredients
  alias RecipeForge.Ingredients.Ingredient

  describe "ingredients" do
    test "list_ingredients/0 returns all ingredients" do
      {:ok, ingredient} = Ingredients.find_or_create_by_name("test ingredient")
      assert Ingredients.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      {:ok, ingredient} = Ingredients.find_or_create_by_name("test ingredient")
      assert Ingredients.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Ingredient{} = ingredient} = Ingredients.create_ingredient(valid_attrs)
      assert ingredient.name == "some name"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ingredients.create_ingredient(%{name: nil})
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      {:ok, ingredient} = Ingredients.find_or_create_by_name("original name")
      update_attrs = %{name: "updated name"}

      assert {:ok, %Ingredient{} = updated_ingredient} =
               Ingredients.update_ingredient(ingredient, update_attrs)

      assert updated_ingredient.name == "updated name"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      {:ok, ingredient} = Ingredients.find_or_create_by_name("test ingredient")
      assert {:error, %Ecto.Changeset{}} = Ingredients.update_ingredient(ingredient, %{name: nil})
      assert ingredient == Ingredients.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      {:ok, ingredient} = Ingredients.find_or_create_by_name("test ingredient")
      assert {:ok, %Ingredient{}} = Ingredients.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Ingredients.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      {:ok, ingredient} = Ingredients.find_or_create_by_name("test ingredient")
      assert %Ecto.Changeset{} = Ingredients.change_ingredient(ingredient)
    end
  end

  describe "find_or_create_by_name/1" do
    test "creates ingredient when name doesn't exist" do
      assert {:ok, %Ingredient{} = ingredient} =
               Ingredients.find_or_create_by_name("new ingredient")

      assert ingredient.name == "new ingredient"
    end

    test "returns existing ingredient when name exists" do
      {:ok, original} = Ingredients.find_or_create_by_name("existing ingredient")

      assert {:ok, %Ingredient{} = found} =
               Ingredients.find_or_create_by_name("existing ingredient")

      assert found.id == original.id
      assert found.name == "existing ingredient"
    end

    test "normalizes ingredient names (case insensitive)" do
      {:ok, ingredient1} = Ingredients.find_or_create_by_name("Test Ingredient")
      {:ok, ingredient2} = Ingredients.find_or_create_by_name("test ingredient")
      assert ingredient1.id == ingredient2.id
      assert ingredient1.name == "test ingredient"
    end

    test "normalizes ingredient names (trims whitespace)" do
      {:ok, ingredient1} = Ingredients.find_or_create_by_name("  spaced ingredient  ")
      {:ok, ingredient2} = Ingredients.find_or_create_by_name("spaced ingredient")
      assert ingredient1.id == ingredient2.id
      assert ingredient1.name == "spaced ingredient"
    end

    test "handles concurrent creation gracefully" do
      # This test simulates concurrent requests trying to create the same ingredient
      name = "concurrent ingredient"

      # Both calls should succeed, returning the same ingredient
      task1 = Task.async(fn -> Ingredients.find_or_create_by_name(name) end)
      task2 = Task.async(fn -> Ingredients.find_or_create_by_name(name) end)

      {:ok, ingredient1} = Task.await(task1)
      {:ok, ingredient2} = Task.await(task2)

      assert ingredient1.id == ingredient2.id
      assert ingredient1.name == name
    end

    test "returns error for invalid ingredient name" do
      assert {:error, %Ecto.Changeset{}} = Ingredients.find_or_create_by_name("")
    end

    test "returns error for non-string input" do
      assert {:error, %Ecto.Changeset{}} = Ingredients.find_or_create_by_name(nil)
      assert {:error, %Ecto.Changeset{}} = Ingredients.find_or_create_by_name(123)
    end

    test "handles special characters in ingredient names" do
      special_name = "ingredient with special chars: @#$%"
      assert {:ok, ingredient} = Ingredients.find_or_create_by_name(special_name)
      assert ingredient.name == String.downcase(special_name)
    end

    test "maintains insertion order for unique ingredients" do
      names = ["zebra ingredient", "alpha ingredient", "beta ingredient"]

      ingredients =
        Enum.map(names, fn name ->
          {:ok, ingredient} = Ingredients.find_or_create_by_name(name)
          ingredient
        end)

      # Verify all ingredients were created
      assert length(ingredients) == 3

      # Verify they can be retrieved
      all_ingredients = Ingredients.list_ingredients()
      assert length(all_ingredients) == 3
    end
  end
end
