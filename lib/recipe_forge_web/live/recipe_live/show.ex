defmodule RecipeForgeWeb.RecipeLive.Show do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:recipe, Recipes.get_recipe!(id))}
  end

  defp page_title(:show), do: "Show Recipe"
  defp page_title(:edit), do: "Edit Recipe"

  # def category_opts(changeset) do
  #   existing_ids =
  #     changeset
  #     |> Ecto.Changeset.get_change(:categories, [])
  #     |> Enum.map(& &1.data.id)

  #   for cat <- Recipes.list_categories(),
  #       do: [key: cat.title, value: cat.id, selected: cat.id in existing_ids]
  # end
end
