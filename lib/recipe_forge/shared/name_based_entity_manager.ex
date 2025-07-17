defmodule RecipeForge.Shared.NameBasedEntityManager do
  @moduledoc """
  Provides generic functions for finding or creating records based on a list of names.
  Designed for simple schemas with only :name, string, and timestamp fields
  """
  import Ecto.Query, warn: false
  alias RecipeForge.Repo

  @doc """
  Returns a normalized list of unique lowercase names, with whitespace trimed.  No blanks.
  """
  def sanitize_names(names) when is_list(names) do
    names
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.downcase/1)
    |> Enum.uniq()
  end

  def sanitize_names(names) when is_binary(names) do
    names |> String.split(" ", trim: true) |> sanitize_names()
  end

  def sanitize_names(_), do: []

  @doc """
  Generic builder.  Finds existing records and builds new, unsaved structs.
  """
  def build_from_names(schema_module, names) do
    names = sanitize_names(names)

    if Enum.empty?(names) do
      %{built: [], existing: [], all: []}
    else
      # 1. Find existing records by name
      existing = from(s in schema_module, where: s.name in ^names) |> Repo.all()
      # 2. Determine which names are for new structs
      existing_names = Map.new(existing, &{&1.name, true})
      new_names = Enum.reject(names, &Map.has_key?(existing_names, &1))
      # 3. Build the new, in-memory structs
      newly_built = Enum.map(new_names, &struct!(schema_module, name: &1))
      # 4. Return the combined list of all structs
      # existing ++ newly_built

      %{
        :built => newly_built,
        :existing => existing,
        :all => existing ++ newly_built
      }
    end
  end
end
