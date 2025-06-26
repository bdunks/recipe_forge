defmodule RecipeForgeWeb.RecipeLive.FormComponent do
  use RecipeForgeWeb, :live_component

  alias RecipeForge.Recipes
  alias RecipeForgeWeb.RecipeHelpers
  alias RecipeForge.Recipes.RecipeIngredient

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
          <div id="ingredients">
            <.inputs_for :let={f_ingredient} field={@form[:recipe_ingredients]}>
              <.ingredient f_ingredient={f_ingredient} target={@myself} />
            </.inputs_for>
          </div>
          <.button type="button" phx-click="add-ingredient" phx-target={@myself}>
            Add Ingredient
          </.button>
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

  def ingredient(assigns) do
    assigns =
      assign(
        assigns,
        :deleted,
        Phoenix.HTML.Form.input_value(assigns.f_ingredient, :_destroy) == true
      )

    ~H"""
    <div class={if(@deleted, do: "opacity-50")}>
      <input
        type="hidden"
        name={Phoenix.HTML.Form.input_name(@f_ingredient, :_destroy)}
        value={to_string(Phoenix.HTML.Form.input_value(@f_ingredient, :_destroy) || false)}
      />
      <div class="flex items-center space-x-2 mb-2">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-2 flex-grow">
          <.input
            field={@f_ingredient[:ingredient_name]}
            type="text"
            label="Ingredient"
            placeholder="e.g., Flour"
          />
          <.input
            field={@f_ingredient[:quantity]}
            type="text"
            label="Quantity"
            placeholder="e.g., 2.5"
          />
          <.input field={@f_ingredient[:unit]} type="text" label="Unit" placeholder="e.g., cups" />
          <.input field={@f_ingredient[:notes]} type="text" label="Notes" placeholder="e.g., sifted" />
        </div>
        <.button
          type="button"
          phx-click="delete-ingredient"
          phx-target={@target}
          phx-value-index={@f_ingredient.index}
          class="mt-6"
        >
          &times;
        </.button>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{recipe: recipe} = assigns, socket) do
    recipe = put_ingredient_names_on_recipe(recipe)
    category_tags = RecipeHelpers.format_categories_for_input(recipe.categories)

    form =
      Recipes.change_recipe(recipe, %{"category_tags" => category_tags})
      |> to_form()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  defp put_ingredient_names_on_recipe(recipe) do
    recipe_ingredients =
      if Ecto.assoc_loaded?(recipe.recipe_ingredients) do
        Enum.map(recipe.recipe_ingredients, fn ri ->
          if Ecto.assoc_loaded?(ri.ingredient) and ri.ingredient do
            %{ri | ingredient_name: ri.ingredient.name}
          else
            ri
          end
        end)
      else
        []
      end

    %{recipe | recipe_ingredients: recipe_ingredients}
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      socket.assigns.recipe
      |> put_ingredient_names_on_recipe()
      |> Recipes.build_recipe_changeset(recipe_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(socket, socket.assigns.action, recipe_params)
  end

  def handle_event("add-ingredient", _params, socket) do
    socket =
      update(socket, :form, fn form ->
        changeset = form.source
        ingredients = Ecto.Changeset.get_field(changeset, :recipe_ingredients)

        changeset
        |> Ecto.Changeset.put_assoc(:recipe_ingredients, ingredients ++ [%RecipeIngredient{}])
        |> to_form()
      end)

    {:noreply, socket}
  end

  def handle_event("delete-ingredient", %{"index" => idx}, socket) do
    idx = String.to_integer(idx)

    # Using `update/3` is a clean way to modify socket assigns
    socket =
      update(socket, :form, fn form ->
        changeset = form.source
        ingredients = Ecto.Changeset.get_field(changeset, :recipe_ingredients)

        ingredient_to_update = Enum.at(ingredients, idx)

        new_ingredients =
          if ingredient_to_update && Ecto.get_meta(ingredient_to_update, :state) == :loaded do
            # Create a changeset for the child ingredient to mark it for deletion
            delete_changeset = Ecto.Changeset.change(ingredient_to_update, %{_destroy: true})
            List.replace_at(ingredients, idx, delete_changeset)
          else
            # It's a new, unsaved ingredient, so just remove it from the list
            List.delete_at(ingredients, idx)
          end

        changeset
        |> Ecto.Changeset.put_assoc(:recipe_ingredients, new_ingredients)
        |> to_form()
      end)

    {:noreply, socket}
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
