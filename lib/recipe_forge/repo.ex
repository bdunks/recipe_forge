defmodule RecipeForge.Repo do
  use Ecto.Repo,
    otp_app: :recipe_forge,
    adapter: Ecto.Adapters.Postgres
end
