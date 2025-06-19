defmodule RecipeForgeWeb.RecipeHelpers do
  @doc """
  Joins a list of instructions into a single string for a textarea.
  """
  def format_for_textarea(instructions) when is_list(instructions) do
    Enum.join(instructions, "\n")
  end

  def format_for_textarea(other), do: other

  @doc """
  Joins a list of category structs into a space-delimited string of names
  """
  def format_categories_for_input(categories) when is_list(categories) do
    categories
    |> Enum.map(& &1.name)
    |> Enum.join(" ")
  end

  def format_categories_for_input(_other), do: ""
end
