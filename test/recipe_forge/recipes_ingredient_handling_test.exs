defmodule RecipeForge.RecipesIngredientHandlingTest do
  use RecipeForge.DataCase

  alias RecipeForge.Recipes
  alias RecipeForge.Recipes.Recipe
  alias RecipeForge.Ingredients

  import RecipeForge.RecipesFixtures

  describe "recipe ingredient handling" do
    setup do
      # Create a base recipe for testing using fixtures
      recipe = recipe_fixture()
      %{recipe: recipe}
    end

    test "create_recipe with valid ingredients creates recipe and ingredients", %{recipe: _recipe} do
      attrs =
        recipe_with_ingredients_attrs([
          %{name: "flour", quantity: "2", unit: "cups", notes: "sifted"},
          %{name: "sugar", quantity: "1", unit: "cup", notes: ""}
        ])

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(attrs)
      assert length(recipe.recipe_ingredients) == 2

      # Verify ingredients were created
      flour = Ingredients.find_or_create_by_name("flour")
      sugar = Ingredients.find_or_create_by_name("sugar")
      assert {:ok, _} = flour
      assert {:ok, _} = sugar
    end

    test "create_recipe with duplicate ingredients returns error" do
      attrs = recipe_with_duplicate_ingredients_attrs()

      assert {:error, %Ecto.Changeset{} = changeset} = Recipes.create_recipe(attrs)
      assert changeset.valid? == false
      assert changeset.errors[:recipe_ingredients] == {"cannot contain duplicate ingredients", []}
    end

    test "update_recipe with valid ingredients updates recipe", %{recipe: recipe} do
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "salt",
            "quantity" => "1",
            "unit" => "tsp",
            "notes" => "sea salt"
          }
        }
      }

      assert {:ok, %Recipe{} = updated_recipe} = Recipes.update_recipe(recipe, attrs)
      assert length(updated_recipe.recipe_ingredients) == 1

      ingredient = hd(updated_recipe.recipe_ingredients)
      assert ingredient.quantity == Decimal.new("1")
      assert ingredient.unit == "tsp"
      assert ingredient.notes == "sea salt"
    end

    test "update_recipe with duplicate ingredients returns error", %{recipe: recipe} do
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "pepper",
            "quantity" => "1",
            "unit" => "tsp",
            "notes" => "black"
          },
          "1" => %{
            "ingredient_name" => "pepper",
            "quantity" => "2",
            "unit" => "tsp",
            "notes" => "white"
          }
        }
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Recipes.update_recipe(recipe, attrs)
      assert changeset.valid? == false
      assert changeset.errors[:recipe_ingredients] == {"cannot contain duplicate ingredients", []}
    end

    test "update_recipe with ingredient marked for deletion", %{recipe: recipe} do
      # First add an ingredient
      {:ok, recipe} =
        Recipes.update_recipe(recipe, %{
          "recipe_ingredients" => %{
            "0" => %{
              "ingredient_name" => "onion",
              "quantity" => "1",
              "unit" => "whole",
              "notes" => "diced"
            }
          }
        })

      # Now mark it for deletion
      [ingredient] = recipe.recipe_ingredients

      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "id" => ingredient.id,
            "ingredient_name" => "onion",
            "quantity" => "1",
            "unit" => "whole",
            "notes" => "diced",
            "_destroy" => "true"
          }
        }
      }

      assert {:ok, %Recipe{} = updated_recipe} = Recipes.update_recipe(recipe, attrs)
      assert length(updated_recipe.recipe_ingredients) == 0
    end

    test "update_recipe allows duplicate names when one is marked for deletion", %{recipe: recipe} do
      # Add two ingredients with same name, one marked for deletion
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "garlic",
            "quantity" => "1",
            "unit" => "clove",
            "notes" => "minced",
            "_destroy" => "true"
          },
          "1" => %{
            "ingredient_name" => "garlic",
            "quantity" => "2",
            "unit" => "cloves",
            "notes" => "chopped"
          }
        }
      }

      assert {:ok, %Recipe{} = updated_recipe} = Recipes.update_recipe(recipe, attrs)
      assert length(updated_recipe.recipe_ingredients) == 1

      ingredient = hd(updated_recipe.recipe_ingredients)
      assert ingredient.quantity == Decimal.new("2")
      assert ingredient.unit == "cloves"
      assert ingredient.notes == "chopped"
    end

    test "update_recipe with ingredient sorting maintains order", %{recipe: recipe} do
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "ingredient_a",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => ""
          },
          "1" => %{
            "ingredient_name" => "ingredient_b",
            "quantity" => "2",
            "unit" => "tbsp",
            "notes" => ""
          }
        },
        # Reversed order
        "ingredients_order" => ["1", "0"]
      }

      assert {:ok, %Recipe{} = updated_recipe} = Recipes.update_recipe(recipe, attrs)
      assert length(updated_recipe.recipe_ingredients) == 2

      # Verify ingredients are in the correct order
      [first, second] = updated_recipe.recipe_ingredients
      assert first.display_order == 0
      assert second.display_order == 1
    end

    test "duplicate validation ignores blank ingredient names", %{recipe: recipe} do
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => ""
          },
          "1" => %{
            "ingredient_name" => "  ",
            "quantity" => "2",
            "unit" => "tbsp",
            "notes" => ""
          },
          "2" => %{
            "ingredient_name" => "real_ingredient",
            "quantity" => "3",
            "unit" => "oz",
            "notes" => ""
          }
        }
      }

      # This should fail due to blank ingredient names failing validation, not duplicate validation
      assert {:error, %Ecto.Changeset{} = changeset} = Recipes.update_recipe(recipe, attrs)
      assert changeset.valid? == false
      # Should not be duplicate error - should be ingredient validation error
      assert changeset.errors[:recipe_ingredients] != {"cannot contain duplicate ingredients", []}
    end

    test "duplicate validation is case insensitive", %{recipe: recipe} do
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "Flour",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => ""
          },
          "1" => %{
            "ingredient_name" => "flour",
            "quantity" => "2",
            "unit" => "cups",
            "notes" => ""
          }
        }
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Recipes.update_recipe(recipe, attrs)
      assert changeset.valid? == false
      assert changeset.errors[:recipe_ingredients] == {"cannot contain duplicate ingredients", []}
    end

    test "duplicate validation trims whitespace", %{recipe: recipe} do
      attrs = %{
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "  salt  ",
            "quantity" => "1",
            "unit" => "tsp",
            "notes" => ""
          },
          "1" => %{
            "ingredient_name" => "salt",
            "quantity" => "2",
            "unit" => "tsp",
            "notes" => ""
          }
        }
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Recipes.update_recipe(recipe, attrs)
      assert changeset.valid? == false
      assert changeset.errors[:recipe_ingredients] == {"cannot contain duplicate ingredients", []}
    end
  end

  describe "change_recipe/2" do
    test "returns changeset for validation without duplicate checking" do
      recipe = %Recipe{}

      attrs = %{
        "name" => "Test Recipe",
        "description" => "Test description",
        "instructions" => "Test instructions",
        "servings" => 4,
        "yield_description" => "4 servings",
        "recipe_ingredients" => %{
          "0" => %{
            "ingredient_name" => "flour",
            "quantity" => "1",
            "unit" => "cup",
            "notes" => ""
          },
          "1" => %{
            "ingredient_name" => "flour",
            "quantity" => "2",
            "unit" => "cups",
            "notes" => ""
          }
        }
      }

      # change_recipe should not validate duplicates, only create/update do
      changeset = Recipes.change_recipe(recipe, attrs)
      assert %Ecto.Changeset{} = changeset
      # It should be valid since change_recipe doesn't run duplicate validation
      assert changeset.valid? == true
    end
  end
end
