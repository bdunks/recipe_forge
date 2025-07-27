defmodule RecipeForge.Categories do
  @moduledoc """
  The Categories context.
  """
  import Ecto.Query, warn: false

  alias RecipeForge.Repo

  alias RecipeForge.Categories.Category

  @doc """
  Returns the list of categories.
  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Returns the list of categories with recipe counts.
  """
  def list_categories_with_recipe_count do
    from(c in Category,
      left_join: rc in "recipe_categories",
      on: rc.category_id == c.id,
      group_by: c.id,
      select: %{
        id: c.id,
        name: c.name,
        recipe_count: count(rc.recipe_id)
      },
      order_by: c.name
    )
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.
  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Retrieves a list of categories by their IDs.
  """
  def get_categories_by_ids(category_ids) when is_list(category_ids) do
    Repo.all(from c in Category, where: c.id in ^category_ids)
  end

  def get_categories_by_ids(nil), do: []

  @doc """
  Creates a category.
  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Finds or creates categories from a list or space-seperated string of names.
  Returns a list of `Category` structus
  """
  def find_or_create_from_names(nil), do: {:ok, []}
  def find_or_create_from_names(""), do: {:ok, []}
  def find_or_create_from_names([]), do: {:ok, []}

  def find_or_create_from_names(names) when is_binary(names) do
    names
    |> String.split(" ", trim: true)
    |> find_or_create_from_names()
  end

  def find_or_create_from_names(names) when is_list(names) do
    sanitized_names = sanitize_names(names)

    if Enum.empty?(sanitized_names) do
      {:ok, []}
    else
      now = DateTime.utc_now()

      new_maps =
        Enum.map(sanitized_names, fn name ->
          %{name: name, inserted_at: now, updated_at: now}
        end)

      # Atomically insert any new records without raising an error for existing ones.
      Repo.insert_all(Category, new_maps, on_conflict: :nothing, conflict_target: :name)

      # Now, fetch all the required records (both existing and newly created) in a single query.
      records = from(c in Category, where: c.name in ^sanitized_names) |> Repo.all()
      {:ok, records}
    end
  end

  defp sanitize_names(names) when is_list(names) do
    names
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.downcase/1)
    |> Enum.uniq()
  end

  defp sanitize_names(names) when is_binary(names) do
    names |> String.split(" ", trim: true) |> sanitize_names()
  end

  defp sanitize_names(_), do: []

  @doc """
  Updates a category.
  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.
  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.
  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
