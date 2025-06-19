defmodule RecipeForgeWeb.AiGenerateLive.Index do
  use RecipeForgeWeb, :live_view

  alias RecipeForge.AI
  alias RecipeForge.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       prompt: "",
       # Store the map returned by the AI parsing step
       generated_recipe_data: nil,
       loading: false,
       errors: nil,
       success: nil
     )}
  end

  @impl true
  def handle_event("generate", %{"prompt" => prompt_text}, socket) do
    prompt = String.trim(prompt_text)

    if prompt == "" do
      {:noreply, apply_error(socket, :prompt, "Please enter a recipe idea.")}
    else
      # TODO - test assign generated_recipe_data: nil?
      socket = socket |> apply_loading() |> assign(prompt: prompt)

      case AI.generate_recipe_from_prompt(prompt) do
        {:ok, recipe_data_map} ->
          {:noreply,
           socket
           |> assign(generated_recipe_data: recipe_data_map)
           |> apply_success()}

        {:error, reason} ->
          {:noreply, apply_error(socket, :ai, reason)}
      end
    end
  end

  @impl true
  def handle_event("save", _params, socket) do
    case socket.assigns.generated_recipe_data do
      nil ->
        {:noreply, apply_error(socket, :base, "No recipe data to save.")}

      recipe_data ->
        socket = apply_loading(socket)

        case Recipes.create_recipe_from_ai(recipe_data) do
          {:ok, saved_recipe} ->
            {:noreply,
             socket
             |> apply_success()
             |> assign(generated_recippe_data: nil)
             |> put_flash(:info, "Recipe '#{saved_recipe.name}' created succesfully")
             |> push_navigate(to: ~p"/recipes/#{saved_recipe.id}")}

          {:error, %Ecto.Changeset{} = changeset} ->
            # --- Use traverse_errors to get all Ecto errors ---
            translator = fn {msg, opts} ->
              Enum.reduce(opts, msg, fn {key, value}, acc ->
                String.replace(acc, "%{#{key}}", to_string(value))
              end)
            end

            # Returns %{field_atom => ["error msg 1", "error msg 2"], ...}
            errors_map = Ecto.Changeset.traverse_errors(changeset, translator)
            {:noreply, apply_errors(socket, errors_map)}
        end
    end
  end

  defp apply_errors(socket, errors_map) do
    IO.inspect(errors_map)

    socket
    |> assign(errors: errors_map)
    |> assign(loading: false)
  end

  defp apply_error(socket, field_atom, error_msg) do
    apply_errors(socket, Map.put(%{}, field_atom, [error_msg]))
  end

  defp apply_success(socket) do
    socket
    |> assign(success: true)
    |> assign(loading: false)
    |> assign(errors: nil)
  end

  defp apply_loading(socket) do
    socket
    |> assign(loading: true)
    |> assign(errors: nil)
    |> assign(success: nil)
  end
end
