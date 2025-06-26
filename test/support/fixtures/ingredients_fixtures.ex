defmodule RecipeForge.IngredientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RecipeForge.Ingredients` context.
  """

  @doc """
  Generate a unique ingredient name.
  """
  def unique_ingredient_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate an ingredient.
  """
  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{
        name: unique_ingredient_name()
      })
      |> RecipeForge.Ingredients.create_ingredient()

    ingredient
  end
end
