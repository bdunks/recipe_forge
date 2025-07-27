defmodule RecipeForge.RecipesAIIntegrationTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes
  alias RecipeForge.Recipes.Recipe

  import RecipeForge.RecipesFixtures

  describe "create_recipe_from_ai/1" do
    test "creates recipe from AI data with ingredients" do
      ai_data =
        ai_recipe_data(%{
          name: "AI Generated Recipe",
          description: "A recipe created by AI",
          instructions: ["Step 1", "Step 2", "Step 3"],
          prep_time: "15 min",
          cook_time: "30 min",
          servings: 4,
          yield_description: "4 servings",
          image_url: "https://example.com/image.jpg",
          notes: "AI generated notes",
          nutrition: %{calories: 250, protein: 15},
          category_name: "AI_Recipes",
          ingredients: [
            %{name: "flour", quantity: "2", unit: "cups", notes: "all-purpose"},
            %{name: "eggs", quantity: "3", unit: "whole", notes: "large"},
            %{name: "milk", quantity: "1", unit: "cup", notes: "whole milk"}
          ]
        })

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe_from_ai(ai_data)

      # Verify basic recipe fields
      assert recipe.name == "AI Generated Recipe"
      assert recipe.description == "A recipe created by AI"
      assert recipe.instructions == ["Step 1", "Step 2", "Step 3"]
      assert recipe.prep_time == "15 min"
      assert recipe.cook_time == "30 min"
      assert recipe.servings == 4
      assert recipe.yield_description == "4 servings"
      assert recipe.image_url == "https://example.com/image.jpg"
      assert recipe.notes == "AI generated notes"
      assert recipe.nutrition == %{calories: 250, protein: 15}

      # Verify ingredients were created
      assert length(recipe.recipe_ingredients) == 3

      # Verify ingredients have correct display order
      ingredients = Enum.sort_by(recipe.recipe_ingredients, & &1.display_order)

      [flour_ri, eggs_ri, milk_ri] = ingredients

      assert flour_ri.quantity == Decimal.new("2")
      assert flour_ri.unit == "cups"
      assert flour_ri.notes == "all-purpose"
      assert flour_ri.display_order == 0

      assert eggs_ri.quantity == Decimal.new("3")
      assert eggs_ri.unit == "whole"
      assert eggs_ri.notes == "large"
      assert eggs_ri.display_order == 1

      assert milk_ri.quantity == Decimal.new("1")
      assert milk_ri.unit == "cup"
      assert milk_ri.notes == "whole milk"
      assert milk_ri.display_order == 2

      # Verify category was created
      assert length(recipe.categories) == 1
      category = hd(recipe.categories)
      # normalized to lowercase
      assert category.name == "ai_recipes"
    end

    test "creates recipe from AI data with minimal fields" do
      ai_data = %{
        name: "Simple AI Recipe",
        description: "Simple description",
        instructions: ["Do something"],
        servings: 2,
        yield_description: "2 servings"
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe_from_ai(ai_data)

      assert recipe.name == "Simple AI Recipe"
      assert recipe.description == "Simple description"
      assert recipe.instructions == ["Do something"]
      assert recipe.servings == 2
      assert recipe.yield_description == "2 servings"

      # Verify defaults
      assert recipe.prep_time == nil
      assert recipe.cook_time == nil
      assert recipe.image_url == nil
      assert recipe.notes == nil
      assert recipe.nutrition == nil
      assert recipe.recipe_ingredients == []

      # Verify default category
      assert length(recipe.categories) == 1
      category = hd(recipe.categories)
      assert category.name == "ai_generated"
    end

    test "fails when AI data has duplicate ingredients" do
      ai_data = %{
        name: "Duplicate AI Recipe",
        description: "Recipe with duplicate ingredients",
        instructions: ["Mix ingredients"],
        servings: 2,
        yield_description: "2 servings",
        ingredients: [
          %{
            name: "flour",
            quantity: "1",
            unit: "cup",
            notes: "first"
          },
          %{
            name: "flour",
            quantity: "2",
            unit: "cups",
            notes: "second"
          }
        ]
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Recipes.create_recipe_from_ai(ai_data)
      assert changeset.valid? == false
      assert changeset.errors[:recipe_ingredients] == {"cannot contain duplicate ingredients", []}
    end

    test "handles AI data with empty ingredients list" do
      ai_data = %{
        name: "No Ingredients Recipe",
        description: "Recipe without ingredients",
        instructions: ["Do nothing"],
        servings: 1,
        yield_description: "1 serving",
        ingredients: []
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe_from_ai(ai_data)
      assert recipe.recipe_ingredients == []
    end

    test "handles AI data with nil ingredients" do
      ai_data = %{
        name: "Nil Ingredients Recipe",
        description: "Recipe with nil ingredients",
        instructions: ["Do nothing"],
        servings: 1,
        yield_description: "1 serving",
        ingredients: nil
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe_from_ai(ai_data)
      assert recipe.recipe_ingredients == []
    end

    test "handles AI data with string instructions" do
      ai_data = %{
        name: "String Instructions Recipe",
        description: "Recipe with string instructions",
        instructions: "Step 1\nStep 2\nStep 3",
        servings: 1,
        yield_description: "1 serving"
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe_from_ai(ai_data)
      assert recipe.instructions == ["Step 1", "Step 2", "Step 3"]
    end

    test "handles AI data with complex nutrition object" do
      ai_data = %{
        name: "Nutrition Recipe",
        description: "Recipe with detailed nutrition",
        instructions: ["Cook"],
        servings: 4,
        yield_description: "4 servings",
        nutrition: %{
          calories: 350,
          protein: 25,
          carbs: 45,
          fat: 12,
          fiber: 8,
          sugar: 5,
          sodium: 450
        }
      }

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe_from_ai(ai_data)

      assert recipe.nutrition == %{
               calories: 350,
               protein: 25,
               carbs: 45,
               fat: 12,
               fiber: 8,
               sugar: 5,
               sodium: 450
             }
    end

    test "validates required fields from AI data" do
      # Missing required fields should fail
      invalid_ai_data = %{
        name: "Invalid Recipe"
        # Missing description, instructions, servings, yield_description
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Recipes.create_recipe_from_ai(invalid_ai_data)

      assert changeset.valid? == false

      # Check that required field errors are present
      required_fields = [:description, :instructions, :servings, :yield_description]

      Enum.each(required_fields, fn field ->
        assert Keyword.has_key?(changeset.errors, field)
      end)
    end
  end
end
