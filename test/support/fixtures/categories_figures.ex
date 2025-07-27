defmodule RecipeForge.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RecipeForge.Categories` context.
  """

  @doc """
  Generate a unique category name.
  """
  def unique_category_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    # Normalize string keys to atom keys to avoid mixed key maps
    normalized_attrs = 
      for {key, val} <- attrs, into: %{} do
        atom_key = if is_binary(key), do: String.to_atom(key), else: key
        {atom_key, val}
      end

    {:ok, category} =
      %{name: unique_category_name()}
      |> Map.merge(normalized_attrs)
      |> RecipeForge.Categories.create_category()

    category
  end
end
