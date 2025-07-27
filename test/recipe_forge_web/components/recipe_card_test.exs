defmodule RecipeForgeWeb.RecipeCardTest do
  use RecipeForgeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Phoenix.Component
  import RecipeForgeWeb.RecipeCard

  describe "recipe_card/1" do
    test "renders basic info and navigation link" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [%{name: "Desserts"}, %{name: "Quick"}],
        is_favorite: false
      }

      assigns = %{recipe: recipe}

      html =
        rendered_to_string(~H"""
        <.recipe_card recipe={@recipe} />
        """)

      assert html =~ "Test Recipe"
      assert html =~ "Desserts"
      assert html =~ "Quick"
      assert html =~ ~r/href="\/recipes\/#{recipe.id}"/
    end

    test "renders a placeholder when image_url is nil" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}

      html =
        rendered_to_string(~H"""
        <.recipe_card recipe={@recipe} />
        """)

      assert html =~ "hero-camera"
      refute html =~ "<img"
    end

    test "renders an image when image_url is present" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: "https://example.com/image.jpg",
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}

      html =
        rendered_to_string(~H"""
        <.recipe_card recipe={@recipe} />
        """)

      assert html =~ ~s(<img src="https://example.com/image.jpg" alt="Test Recipe")
      refute html =~ "hero-camera"
    end

    test "favorite button shows correct state for a non-favorite recipe" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: false
      }

      assigns = %{recipe: recipe}

      html =
        rendered_to_string(~H"""
        <.recipe_card recipe={@recipe} />
        """)

      assert html =~ "title=\"Add to favorites\""
      assert html =~ "phx-click=\"toggle_favorite\""
      assert html =~ "hero-heart"
      refute html =~ "hero-heart-solid"
    end

    test "favorite button shows correct state for a favorite recipe" do
      recipe = %{
        id: "a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5",
        name: "Test Recipe",
        image_url: nil,
        categories: [],
        is_favorite: true
      }

      assigns = %{recipe: recipe}

      html =
        rendered_to_string(~H"""
        <.recipe_card recipe={@recipe} />
        """)

      assert html =~ "title=\"Remove from favorites\""
      assert html =~ "phx-click=\"toggle_favorite\""
      assert html =~ "hero-heart-solid"
    end
  end
end
