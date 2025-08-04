# lib/recipe_forge_web/components/delete_recipe_component.ex
defmodule RecipeForgeWeb.DeleteRecipeComponent do
  use RecipeForgeWeb, :live_component

  alias RecipeForge.Recipes

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:variant, Map.get(assigns, :variant, :icon))
     |> assign(:show_modal, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <button
        :if={@variant == :icon}
        phx-click="show_modal"
        phx-target={@myself}
        class="absolute top-2 left-2 btn btn-circle btn-ghost btn-sm bg-white/80 hover:bg-white/90 text-red-500 hover:text-red-700"
        title="Delete recipe"
      >
        <.icon name="hero-trash" class="h-5 w-5" />
      </button>

      <button
        :if={@variant == :button}
        class="btn btn-error btn-outline"
        phx-click="show_modal"
        phx-target={@myself}
      >
        <.icon name="hero-trash" class="w-4 h-4" /> Delete Recipe
      </button>

      <.confirmation_modal
        :if={@show_modal}
        id={"delete-recipe-modal-#{@recipe.id}"}
        show
        title="Delete Recipe?"
        message={"Are you sure you want to permanently delete \"#{@recipe.name}\"? This action cannot be undone."}
        confirm_text="Delete Recipe"
        on_confirm={JS.push("confirm_delete", target: @myself)}
        on_cancel={JS.push("hide_modal", target: @myself)}
      />
    </div>
    """
  end

  @impl true
  def handle_event("show_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, true)}
  end

  def handle_event("hide_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, false)}
  end

  def handle_event("confirm_delete", _, socket) do
    recipe = socket.assigns.recipe

    case Recipes.delete_recipe(recipe) do
      {:ok, _deleted_recipe} ->
        send(self(), {:recipe_deleted, recipe.id})

        {:noreply,
         socket
         |> assign(:show_modal, false)
         |> put_flash(:info, "Recipe deleted successfully.")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> assign(:show_modal, false)
         |> put_flash(:error, "Error deleting recipe.")}
    end
  end
end
