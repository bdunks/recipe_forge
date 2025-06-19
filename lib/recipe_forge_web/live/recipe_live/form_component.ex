defmodule RecipeForgeWeb.RecipeLive.FormComponent do
  use RecipeForgeWeb, :live_component

  alias RecipeForge.Recipes
  alias RecipeForgeWeb.RecipeHelpers
  alias RecipeForge.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage recipe records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="recipe-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:prep_time]} type="text" label="Prep time" />
        <.input field={@form[:cook_time]} type="text" label="Cook time" />
        <.input field={@form[:servings]} type="number" label="Servings" />
        <.input field={@form[:yield_description]} type="text" label="Yield description" />
        <.input
          field={@form[:instructions]}
          type="textarea"
          label="Instructions"
          value={RecipeHelpers.format_for_textarea(@form[:instructions].value)}
        />
        <.input field={@form[:category_tags]} type="text" label="Categories" />
        <.input field={@form[:notes]} type="text" label="Notes" />
        <.input field={@form[:image_url]} type="text" label="Image url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Recipe</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{recipe: recipe} = assigns, socket) do
    category_tags = RecipeHelpers.format_categories_for_input(recipe.categories)

    form =
      Recipes.change_recipe(recipe, %{"category_tags" => category_tags})
      |> to_form()

    {:ok,
     socket
     |> assign(assigns)
     #  |> assign_new(:form, fn ->
     #    to_form(Recipes.change_recipe(recipe))
     |> assign(:form, form)}
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      Recipes.validate_recipe_changeset(socket.assigns.recipe, recipe_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset, label: "VALIDATE CHANGESET")
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(socket, socket.assigns.action, recipe_params)
  end

  defp save_recipe(socket, :edit, recipe_params) do
    case Recipes.update_recipe(socket.assigns.recipe, recipe_params) do
      {:ok, recipe} ->
        notify_parent({:saved, recipe})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_recipe(socket, :new, recipe_params) do
    case Recipes.create_recipe(recipe_params) do
      {:ok, recipe} ->
        notify_parent({:saved, recipe})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
