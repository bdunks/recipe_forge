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

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Retrieves a list of categories by their IDs.

  ## Examples

      iex> list_categories_by_ids([1, 2, 3])
      [%Category{}, ...]

      iex> list_categories_by_ids([])
      []
  """
  def get_categories_by_ids(category_ids) when is_list(category_ids) do
    Repo.all(from c in Category, where: c.id in ^category_ids)
  end

  def get_categories_by_ids(nil), do: []

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Builds a list of category structs from a list of names.
  Finds existing categories and builds new, unsaved structs for names not found.
  This function has NO database write side-effects.
  """
  def build_from_names(names) when is_binary(names) do
    NameBasedEntityManager.build_from_names(Category, names) |> Map.get(:all, [])
  end

  def build_from_names(_), do: []

  def build_from_form_attrs(names), do: build_from_names(names)

  @doc """
  Finds or creates categories from a list of names, persisting new ones.
  """
  def find_or_create_from_names(names) do
    NameBasedEntityManager.find_or_create_from_names(Category, names)
  end

  def find_or_create_from_form_attrs(names), do: find_or_create_from_names(names)
end
