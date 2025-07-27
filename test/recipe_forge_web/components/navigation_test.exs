defmodule RecipeForgeWeb.NavigationTest do
  use RecipeForgeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Phoenix.Component
  import RecipeForgeWeb.Navigation

  describe "navbar/1" do
    test "renders navbar with all menu items" do
      assigns = %{current_path: "/"}

      html =
        rendered_to_string(~H"""
        <.navbar current_path={@current_path} />
        """)

      assert html =~ "RecipeForge"
      assert html =~ "Browse"
      assert html =~ "Favorites"
      assert html =~ "Search recipes..."
    end
  end
end
