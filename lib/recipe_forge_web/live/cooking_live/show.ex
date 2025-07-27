defmodule RecipeForgeWeb.CookingLive.Show do
  use RecipeForgeWeb, :live_view

  on_mount {__MODULE__, :assign_cooking_layout}

  def on_mount(:assign_cooking_layout, _params, _session, socket) do
    {:cont, Phoenix.Component.assign(socket, :layout, {RecipeForgeWeb.Layouts, "cooking"})}
  end

  alias RecipeForge.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    recipe = Recipes.get_recipe!(id)
    total_steps = length(recipe.instructions)

    socket =
      socket
      |> assign(:page_title, "Cooking: #{recipe.name}")
      |> assign(:recipe, recipe)
      |> assign(:current_step, 1)
      |> assign(:total_steps, total_steps)

    {:noreply, socket}
  end

  @impl true
  def handle_event("next_step", _params, socket) do
    current_step = socket.assigns.current_step
    total_steps = socket.assigns.total_steps

    next_step = min(current_step + 1, total_steps)

    {:noreply, assign(socket, :current_step, next_step)}
  end

  @impl true
  def handle_event("prev_step", _params, socket) do
    current_step = socket.assigns.current_step
    prev_step = max(current_step - 1, 1)

    {:noreply, assign(socket, :current_step, prev_step)}
  end

  @impl true
  def handle_event("go_to_step", %{"step" => step_string}, socket) do
    step = String.to_integer(step_string)
    total_steps = socket.assigns.total_steps

    valid_step = max(1, min(step, total_steps))

    {:noreply, assign(socket, :current_step, valid_step)}
  end


  defp current_instruction(recipe, step) do
    Enum.at(recipe.instructions, step - 1, "")
  end
end
