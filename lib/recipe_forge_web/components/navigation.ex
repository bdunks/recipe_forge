defmodule RecipeForgeWeb.Navigation do
  @moduledoc """
  Navigation component for RecipeForge application.
  """
  use RecipeForgeWeb, :html

  @doc """
  Renders the main navigation bar.
  """
  attr :current_path, :string, default: ""

  def navbar(assigns) do
    ~H"""
    <div class="navbar bg-base-100 sticky top-0 z-40 shadow-md px-4">
      <div class="flex-1">
        <.link navigate={~p"/"} class="btn btn-ghost text-xl">
          🍲 RecipeForge
        </.link>
      </div>
      <div class="flex-none gap-2">
        <div class="form-control hidden md:block">
          <.link navigate={~p"/search"} class="input input-bordered w-24 md:w-auto flex items-center">
            <span class="text-gray-400">Search recipes...</span>
          </.link>
        </div>
        <.link navigate={~p"/browse"} class="btn btn-ghost">
          Browse
        </.link>
        <.link navigate={~p"/favorites"} class="btn btn-ghost">
          Favorites
        </.link>
        <.link navigate={~p"/recipes/new"} class="btn btn-ghost btn-circle" title="Create Recipe">
          <.icon name="hero-plus" class="h-5 w-5" />
        </.link>
      </div>
    </div>
    """
  end
end
