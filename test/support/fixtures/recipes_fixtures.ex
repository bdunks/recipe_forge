defmodule RecipeForge.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RecipeForge.Recipes` context.
  """

  @doc """
  Generate a unique category name.
  """
  def unique_category_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: unique_category_name()
      })
      |> RecipeForge.Recipes.create_category()

    category
  end

  @doc """
  Generate a unique ingredient name.
  """
  def unique_ingredient_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a ingredient.
  """
  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{
        name: unique_ingredient_name()
      })
      |> RecipeForge.Recipes.create_ingredient()

    ingredient
  end

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        cook_time: "some cook_time",
        description: "some description",
        image_url: "some image_url",
        instructions: ["option1", "option2"],
        name: "some name",
        notes: "some notes",
        nutrition: %{},
        prep_time: "some prep_time",
        servings: 42,
        yield_description: "some yield_description"
      })
      |> RecipeForge.Recipes.create_recipe()

    recipe
  end
end
