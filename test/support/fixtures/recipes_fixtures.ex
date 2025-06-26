defmodule RecipeForge.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RecipeForge.Recipes` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        instructions: "some instructions",
        prep_time: "some prep_time",
        cook_time: "some cook_time",
        servings: 42,
        yield_description: "some yield_description",
        image_url: "some image_url",
        notes: "some notes",
        nutrition: %{},
        category_tags: "tag1 tag2",
        recipe_ingredients: []
      })
      |> RecipeForge.Recipes.create_recipe()

    recipe
  end
end
