defmodule RecipeForgeWeb.RecipeLive.FormComponent do
  use RecipeForgeWeb, :live_component

  alias RecipeForge.Recipes
  alias RecipeForgeWeb.RecipeHelpers

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
        <div class="mt-4">
          <h3 class="text-lg font-semibold mb-2">Ingredients</h3>
          <.error :for={msg <- Enum.map(@form[:recipe_ingredients].errors, &elem(&1, 0))}>
            <%= msg %>
          </.error>
          <div id="ingredients" phx-hook="SortableInputsFor">
            <.inputs_for :let={f_ingredient} field={@form[:recipe_ingredients]}>
              <% destroy = Ecto.Changeset.get_field(f_ingredient.source, :_destroy) %>
              <%!-- Start Ingredients --%>
              <div class={[
                "flex items-center space-x-2 mb-2 drag-item",
                if(destroy, do: "opacity-50 grayscale")
              ]}>
                <.icon name="hero-bars-3" class="w-6 h-6 relative top-2" data-handle />
                <input type="hidden" name="recipe[ingredients_order][]" value={f_ingredient.index} />
                <div class="grid grid-cols-1 md:grid-cols-4 gap-2 flex-grow">
                  <.input
                    field={f_ingredient[:ingredient_name]}
                    type="text"
                    label="Ingredient"
                    placeholder="e.g., Flour"
                    disabled={destroy}
                  />
                  <%= if destroy do %>
                    <input
                      type="hidden"
                      name={"recipe[recipe_ingredients][#{f_ingredient.index}][ingredient_name]"}
                      value={f_ingredient[:ingredient_name].value}
                    />
                  <% end %>
                  <.input
                    field={f_ingredient[:quantity]}
                    type="text"
                    label="Quantity"
                    placeholder="e.g., 2.5"
                  />
                  <.input
                    field={f_ingredient[:unit]}
                    type="text"
                    label="Unit"
                    placeholder="e.g., cups"
                  />
                  <.input
                    field={f_ingredient[:notes]}
                    type="text"
                    label="Notes"
                    placeholder="e.g., sifted"
                  />
                </div>
                <label>
                  <.input
                    type="hidden_checkbox"
                    field={f_ingredient[:_destroy]}
                    class="border-red-500"
                  />

                  <.icon name="hero-x-mark" class="w-6 h-6 relative top-2" />
                </label>
              </div>
              <%!-- END INGREDIENTS --%>
            </.inputs_for>
          </div>
          <input type="hidden" name="recipe[ingredients_delete][]" />
          <label class="block cursor-pointer">
            <input type="checkbox" name="recipe[ingredients_order][]" class="hidden" />
            <.icon name="hero-plus-circle" /> add more
          </label>
        </div>

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
    recipe = populate_form_data(recipe)

    form =
      Recipes.change_recipe(recipe)
      |> to_form()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  defp populate_form_data(recipe) do
    recipe_ingredients =
      if Ecto.assoc_loaded?(recipe.recipe_ingredients) do
        Enum.map(recipe.recipe_ingredients, fn ri ->
          ingredient_name = if Ecto.assoc_loaded?(ri.ingredient) do
            ri.ingredient.name
          else
            ri.ingredient_name || ""
          end

          %{ri | ingredient_name: ingredient_name}
        end)
      else
        []
      end

    category_tags = RecipeHelpers.format_categories_for_input(recipe.categories)

    %{recipe | recipe_ingredients: recipe_ingredients, category_tags: category_tags}
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      Recipes.change_recipe(socket.assigns.recipe, recipe_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
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
      
      :rollback ->
        # Handle rollback case - this shouldn't happen in normal operation
        {:noreply, socket}
    end
  end

  # TODO - The form pushes a success while still erroring and not saving
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
      
      :rollback ->
        # Handle rollback case - this shouldn't happen in normal operation
        {:noreply, socket}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
