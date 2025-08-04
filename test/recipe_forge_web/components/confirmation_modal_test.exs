defmodule RecipeForgeWeb.ConfirmationModalTest do
  use RecipeForgeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Phoenix.Component
  import RecipeForgeWeb.CoreComponents

  describe "confirmation_modal/1" do
    test "renders confirmation modal with default attributes" do
      assigns = %{
        id: "test-modal",
        show: true,
        title: "Delete Item?",
        message: "Are you sure you want to delete this item?",
        on_confirm: Phoenix.LiveView.JS.push("confirm_delete"),
        on_cancel: Phoenix.LiveView.JS.push("hide_modal")
      }

      html =
        rendered_to_string(~H"""
        <.confirmation_modal
          id={@id}
          show={@show}
          title={@title}
          message={@message}
          on_confirm={@on_confirm}
          on_cancel={@on_cancel}
        />
        """)

      assert html =~ "Delete Item?"
      assert html =~ "Are you sure you want to delete this item?"
      assert html =~ "Confirm"
      assert html =~ "Cancel"
      assert html =~ "hero-exclamation-triangle"
      assert html =~ "btn-error"
    end

    test "renders with custom confirm and cancel text" do
      assigns = %{
        id: "test-modal",
        show: true,
        title: "Custom Title",
        message: "Custom message",
        confirm_text: "Yes, Delete",
        cancel_text: "No, Keep",
        on_confirm: Phoenix.LiveView.JS.push("confirm_delete"),
        on_cancel: Phoenix.LiveView.JS.push("hide_modal")
      }

      html =
        rendered_to_string(~H"""
        <.confirmation_modal
          id={@id}
          show={@show}
          title={@title}
          message={@message}
          confirm_text={@confirm_text}
          cancel_text={@cancel_text}
          on_confirm={@on_confirm}
          on_cancel={@on_cancel}
        />
        """)

      assert html =~ "Yes, Delete"
      assert html =~ "No, Keep"
    end

    test "renders non-danger modal when danger is false" do
      assigns = %{
        id: "test-modal",
        show: true,
        title: "Save Changes?",
        message: "Do you want to save your changes?",
        danger: false,
        on_confirm: Phoenix.LiveView.JS.push("save"),
        on_cancel: Phoenix.LiveView.JS.push("cancel")
      }

      html =
        rendered_to_string(~H"""
        <.confirmation_modal
          id={@id}
          show={@show}
          title={@title}
          message={@message}
          danger={@danger}
          on_confirm={@on_confirm}
          on_cancel={@on_cancel}
        />
        """)

      assert html =~ "btn-primary"
      refute html =~ "btn-error"
      refute html =~ "hero-trash"
    end

    test "includes trash icon for danger actions" do
      assigns = %{
        id: "test-modal",
        show: true,
        title: "Delete Recipe?",
        message: "This action cannot be undone.",
        danger: true,
        on_confirm: Phoenix.LiveView.JS.push("confirm_delete"),
        on_cancel: Phoenix.LiveView.JS.push("hide_modal")
      }

      html =
        rendered_to_string(~H"""
        <.confirmation_modal
          id={@id}
          show={@show}
          title={@title}
          message={@message}
          danger={@danger}
          on_confirm={@on_confirm}
          on_cancel={@on_cancel}
        />
        """)

      assert html =~ "hero-trash"
      assert html =~ "btn-error"
    end

    test "has proper accessibility attributes" do
      assigns = %{
        id: "test-modal",
        show: true,
        title: "Test Title",
        message: "Test message",
        on_confirm: Phoenix.LiveView.JS.push("confirm"),
        on_cancel: Phoenix.LiveView.JS.push("cancel")
      }

      html =
        rendered_to_string(~H"""
        <.confirmation_modal
          id={@id}
          show={@show}
          title={@title}
          message={@message}
          on_confirm={@on_confirm}
          on_cancel={@on_cancel}
        />
        """)

      assert html =~ ~s(role="dialog")
      assert html =~ ~s(aria-modal="true")
      assert html =~ ~s(aria-labelledby="test-modal-title")
      assert html =~ ~s(aria-describedby="test-modal-description")
    end
  end
end
