defmodule RecipeForge.Categories do
  @moduledoc """
  The Categories context.
  """
  import Ecto.Query, warn: false

  alias RecipeForge.Repo

  alias RecipeForge.Categories.Category
  alias RecipeForge.Shared.NameBasedEntityManager

  @doc """
  Returns the list of categories.
  """
  def list_categories do
    Repo.all(Category)
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
    sanitized_names = NameBasedEntityManager.sanitize_names(names)

    # First, insert all the new categories that might not exist.
    # `on_conflict: :nothing` is very efficient. It will not return the IDs
    # of the inserted rows, so a second query is needed.
    new_category_maps =
      Enum.map(sanitized_names, fn name ->
        %{name: name, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}
      end)

    Repo.insert_all(Category, new_category_maps, on_conflict: :nothing, conflict_target: :name)
    # Now, fetch all the required categories (both existing and newly created).
    categories = Repo.all(from c in Category, where: c.name in ^sanitized_names)
    {:ok, categories}
  end

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
