defmodule RecipeForge.AI do
  # Check API Docs for correct endpoint"
  # @gemini_endpoint "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

  # defp google_api_key() do
  #   Application.fetch_env!(:recipe_forge, :google_api_key)
  # end

  @typedoc """
  The expected structure of a successfully generated recipe map from the AI.
  Keys should be atoms after parsing.
  """
  @type generated_recipe_map :: %{
          name: String.t(),
          description: String.t() | nil,
          category_name: String.t() | nil,
          prep_time: String.t() | nil,
          cook_time: String.t() | nil,
          servings: integer() | nil,
          yield_description: String.t() | nil,
          ingredients:
            list(%{
              name: String.t(),
              quantity: String.t() | nil,
              unit: String.t() | nil,
              notes: String.t() | nil
            }),
          instructions: list(String.t()),
          notes: String.t() | nil,
          # Or a more specific map type
          nutrition: map() | nil,
          image_url: String.t() | nil
        }

  @spec generate_recipe_from_prompt(String.t()) ::
          {:ok, generated_recipe_map()} | {:error, String.t()}
  def generate_recipe_from_prompt(prompt_text) do
    # TODO: Implement logic using Tesla/Jason to:
    # 1. Build the structured prompt for the AI
    # 2. Build the request body (JSON)
    # 3. Make the POST request to @gemini_endpoint with API key
    # 4. Handle {:ok, response} -> Parse JSON body, extract fields, return {:ok, map}
    # 5. Handle {:error, reason} -> Return {:error, "Reason"}
    # Placeholder:

    # --- TEMPORARY PLACEHOLDER ---
    # Simulate a successful response structure for now
    # This allows the {:ok, ...} clause in the LiveView to be reachable
    # Simple way to test error path too
    if prompt_text != "force_error" do
      {:ok,
       %{
         name: "Generated: #{prompt_text}",
         description: "A delicious recipe based on your idea.",
         category_name: "AI Suggested",
         prep_time: "10 mins",
         cook_time: "20 mins",
         servings: 4,
         yield_description: "4 servings",
         ingredients: [
           %{name: "Placeholder Ingredient 1", quantity: "1", unit: "cup"},
           %{name: "Placeholder Ingredient 2", quantity: "2", unit: "tbsp"}
         ],
         instructions: ["Step 1: Do something.", "Step 2: Do something else."],
         notes: "Enjoy!",
         nutrition: %{"calories" => "lots"},
         image_url: nil
       }}
    else
      {:error, "Simulated AI error for prompt: #{prompt_text}"}
    end
  end
end
