# ARCHITECTURE_GUIDELINES.md

This file contains agent-specific architectural patterns and advanced guidelines for Phoenix/Elixir development. **See CLAUDE.md for core project setup, MCP tool usage, and essential development commands.**

## Agent Development Patterns

- Always use Tidewave MCP tools as first resort (see CLAUDE.md MCP Integration section)
- Use `mix precommit` alias when done with all changes and fix any pending issues
- Use the already included `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`

### Phoenix v1.8 guidelines

- **Always** begin your LiveView templates with `<Layouts.app flash={@flash} ...>` which wraps all inner content
- The `MyAppWeb.Layouts` module is aliased in the `my_app_web.ex` file, so you can use it without needing to alias it again
- **Always** use `Phoenix.Component.form/1` and `Phoenix.Component.inputs_for/1` instead of the deprecated `Phoenix.HTML.form_for` or `Phoenix.HTML.inputs_for`
- Anytime you run into errors with no `current_scope` assign:
  - You failed to follow the Authenticated Routes guidelines, or you failed to pass `current_scope` to `<Layouts.app>`
  - **Always** fix the `current_scope` error by moving your routes to the proper `live_session` and ensure you pass `current_scope` as needed
- Phoenix v1.8 moved the `<.flash_group>` component to the `Layouts` module. You are **forbidden** from calling `<.flash_group>` outside of the `layouts.ex` module
- Out of the box, `core_components.ex` imports an `<.icon name="hero-x-mark" class="w-5 h-5"/>` component for for hero icons. **Always** use the `<.icon>` component for icons, **never** use `Heroicons` modules or similar
- **Always** use the imported `<.input>` component for form inputs from `core_components.ex` when available. `<.input>` is imported and using it will will save steps and prevent errors
- If you override the default input classes (`<.input class="myclass px-2 py-1 rounded-lg">)`) class with your own values, no default classes are inherited, so your
  custom classes must fully style the input

### JS and CSS guidelines

- **Use Tailwind CSS classes and custom CSS rules** to create polished, responsive, and visually stunning interfaces.
- Tailwindcss v4 **no longer needs a tailwind.config.js** and uses a new import syntax in `app.css`:

      @import "tailwindcss" source(none);
      @source "../css";
      @source "../js";
      @source "../../lib/my_app_web";

- **Always use and maintain this import syntax** in the app.css file for projects generated with `phx.new`
- **Never** use `@apply` when writing raw css
- **Always** manually write your own tailwind-based components instead of using daisyUI for a unique, world-class design
- Out of the box **only the app.js and app.css bundles are supported**
  - You cannot reference an external vendor'd script `src` or link `href` in the layouts
  - You must import the vendor deps into app.js and app.css to use them
  - **Never write inline <script>custom js</script> tags within templates**

### UI/UX & design guidelines

- **Produce world-class UI designs** with a focus on usability, aesthetics, and modern design principles
- Implement **subtle micro-interactions** (e.g., button hover effects, and smooth transitions)
- Ensure **clean typography, spacing, and layout balance** for a refined, premium look
- Focus on **delightful details** like hover effects, loading states, and smooth page transitions

<!-- phoenix-gen-auth-start -->

## Authentication

- **Always** handle authentication flow at the router level with proper redirects
- **Always** be mindful of where to place routes. `phx.gen.auth` creates multiple router plugs and `live_session` scopes:
  - A plug `:fetch_current_scope_for_user` that is included in the default browser pipeline
  - A plug `:require_authenticated_user` that redirects to the log in page when the user is not authenticated
  - A `live_session :current_user` scope - for routes that need the current user but don't require authentication, similar to `:fetch_current_scope_for_user`
  - A `live_session :require_authenticated_user` scope - for routes that require authentication, similar to the plug with the same name
  - In both cases, a `@current_scope` is assigned to the Plug connection and LiveView socket
  - A plug `redirect_if_user_is_authenticated` that redirects to a default path in case the user is authenticated - useful for a registration page that should only be shown to unauthenticated users
- **Always let the user know in which router scopes, `live_session`, and pipeline you are placing the route, AND SAY WHY**
- `phx.gen.auth` assigns the `current_scope` assign - it **does not assign a `current_user` assign**
- Always pass the assign `current_scope` to context modules as first argument. When performing queries, use `current_scope.user` to filter the query results
- To derive/access `current_user` in templates, **always use the `@current_scope.user`**, never use **`@current_user`** in templates or LiveViews
- **Never** duplicate `live_session` names. A `live_session :current_user` can only be defined **once** in the router, so all routes for the `live_session :current_user` must be grouped in a single block
- Anytime you hit `current_scope` errors or the logged in session isn't displaying the right content, **always double check the router and ensure you are using the correct plug and `live_session` as described below**

### Routes that require authentication

LiveViews that require login should **always be placed inside the **existing** `live_session :require_authenticated_user` block**. **Always** put `alias` statements around `scope` blocks for better organization:

    alias MyAppWeb.{UserLive, MyLiveThatRequiresAuth}

    scope "/", AppWeb do
      pipe_through [:browser, :require_authenticated_user]

      live_session :require_authenticated_user,
        on_mount: [{RecipeForgeWeb.UserAuth, :require_authenticated}] do
        # phx.gen.auth generated routes
        live "/users/settings", UserLive.Settings, :edit
        live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
        # our own routes that require logged in user
        live "/", MyLiveThatRequiresAuth, :index
      end
    end

Controller routes must be placed in a scope that sets the `:require_authenticated_user` plug:

    alias MyAppWeb.MyControllerThatRequiresAuth

    scope "/", AppWeb do
      pipe_through [:browser, :require_authenticated_user]

      get "/", MyControllerThatRequiresAuth, :index
    end

### Routes that work with or without authentication

LiveViews that can work with or without authentication, **always use the **existing** `:current_user` scope**, ie:

    alias MyAppWeb.PublicLive

    scope "/", MyAppWeb do
      pipe_through [:browser]

      live_session :current_user,
        on_mount: [{RecipeForgeWeb.UserAuth, :mount_current_scope}] do
        # our own routes that work with or without authentication
        live "/", PublicLive
      end
    end

Controllers automatically have the `current_scope` available if they use the `:browser` pipeline.

<!-- phoenix-gen-auth-end -->

<!-- usage-rules-start -->

## Critical Elixir Patterns

**Key Anti-Patterns to Avoid:**

- Never use map access syntax (`changeset[:field]`) on structs - use `struct.field` or `Ecto.Changeset.get_field/2`
- Never nest multiple modules in same file (causes cyclic dependencies)
- Never use `String.to_atom/1` on user input (memory leak risk)

**Variable Rebinding Pattern:**

```elixir
# VALID: rebind the result of block expressions
socket =
  if connected?(socket) do
    assign(socket, :val, val)
  end

# INVALID: rebinding inside the block
if connected?(socket) do
  socket = assign(socket, :val, val)  # This won't work
end
```

**Variable Naming Conventions:**

```elixir
# Context function parameters - use full descriptive words
def create_resource(attrs), do: ...
def list_user_items(user, resource), do: ...
def get_item_for_user_period(item_id, period), do: ...

# Query bindings - use single letter or 2-3 letter abbreviations
from(r in Resource,
  join: i in Item,
  join: u in User,
  where: i.resource_id == ^resource_id
)
```

## Context Module Patterns

### CRUD Function Naming Conventions

**Standard CRUD operations follow consistent verb prefixes:**

```elixir
# list_* - Returns a collection (always returns a list, empty if none found)
def list_resources, do: Repo.all(Resource)
def list_user_resources(user), do: ...
def list_items_for_summary(resource), do: ...

# get_* - Returns single record or nil
def get_resource_by_code(code), do: Repo.get_by(Resource, code: code)
def get_item_for_user_period(item_id, period), do: ...

# get_*! - Returns single record or raises Ecto.NoResultsError
def get_resource!(id), do: Repo.get!(Resource, id)
def get_item!(id), do: Repo.get!(Item, id)

# create_* - Creates a new record, returns {:ok, struct} | {:error, changeset}
def create_resource(attrs) do
  %Resource{} |> Resource.changeset(attrs) |> Repo.insert()
end

# update_* - Updates existing record, returns {:ok, struct} | {:error, changeset}
def update_resource(%Resource{} = resource, attrs) do
  resource |> Resource.changeset(attrs) |> Repo.update()
end

# delete_* - Deletes a record, returns {:ok, struct} | {:error, changeset}
def delete_resource(%Resource{} = resource), do: Repo.delete(resource)

# change_* - Returns changeset for forms (does not persist)
def change_resource(%Resource{} = resource, attrs \\ %{}), do: Resource.changeset(resource, attrs)
```

### Admin Function Prefix Pattern

**Functions that bypass business rules are prefixed with `admin_`:**

```elixir
# Regular function with business rule check
def create_resource(attrs) do
  changeset = Resource.changeset(%Resource{}, attrs)

  case check_business_rule() do
    :ok -> Repo.insert(changeset)
    {:error, reason} -> {:error, changeset} # Enforce business rule
  end
end

# Admin function bypasses business rules
def admin_create_resource(attrs) do
  %Resource{} |> Resource.changeset(attrs) |> Repo.insert()
end

# Other admin functions
def admin_create_item(attrs), do: ...
def admin_update_status(resource, status), do: ...
def admin_delete_with_impact(resource_id), do: ...
def admin_get_deletion_impact(resource_id), do: ...
```

### Boolean Query Naming Pattern

**Boolean permission/state checks end with `?`:**

```elixir
def user_can_access_resource?(user, resource_id) do
  from(r in Resource,
    left_join: m in Membership,
    on: r.id == m.resource_id,
    where: r.id == ^resource_id and (m.user_id == ^user.id or r.owner_id == ^user.id)
  )
  |> Repo.exists?()
end

def user_owns_resource?(user, resource_id) do
  from(r in Resource, where: r.id == ^resource_id and r.owner_id == ^user.id)
  |> Repo.exists?()
end

def all_items_processed?(batch_id), do: ...
```

**Pattern:** Use `Repo.exists?/1` for efficient boolean queries. Call from LiveView `mount/3` before loading data.

## Essential Ecto Patterns

- **Always** preload associations when accessed in templates: `comment.author.name` requires preloading
- **Always** use `Ecto.Changeset.get_field(changeset, :field)` to access changeset fields
- Security: programatic fields like `user_id` must be explicitly set, not included in `cast` calls

### Upsert Pattern (Insert or Update)

**Use `on_conflict` for idempotent operations:**

```elixir
def create_or_update_result(attrs \\ %{}) do
  %Result{}
  |> Result.changeset(attrs)
  |> Repo.insert(
    on_conflict: :replace_all,
    conflict_target: [:resource_id, :period]
  )
end
```

**Pattern:** Use `on_conflict: :replace_all` with `conflict_target` to upsert. Allows reprocessing without errors.

### Transaction Pattern

**Use `Repo.transaction/1` for multi-step operations:**

```elixir
def delete_item_with_dependencies(%Item{} = item) do
  Repo.transaction(fn ->
    # Delete associated records first
    {dependencies_deleted, _} =
      Dependency
      |> where([d], d.item_id == ^item.id)
      |> Repo.delete_all()

    # Delete the item
    case Repo.delete(item) do
      {:ok, deleted_item} ->
        %{item: deleted_item, dependencies_deleted: dependencies_deleted}

      {:error, changeset} ->
        Repo.rollback(changeset)
    end
  end)
end
```

**Pattern:** Wrap related operations in `Repo.transaction/1`. Use `Repo.rollback/1` to abort and return error.

## Critical HEEx/Template Patterns

**Form Handling:**

- Always use `to_form/2` and `<.form for={@form} id="unique-id">`
- Always add unique DOM IDs for testing: `<.form for={@form} id="product-form">`

**Template Iteration:**

- **Never** use `<% Enum.each %>` or non-for comprehensions for generating template content
- **Always** use `<[HTML_ELEMENT] :for={item <- @collection} id={"item-#{item.id}"}>...</[HTML_ELEMENT]>` for iterating over collections in templates, where "HTML_ELEMENT" could be a div, tr, custom component, etc.

**Conditional Rendering:**

```heex
<%!-- Use cond for multiple conditions (no else if in Elixir) --%>
<%= cond do %>
  <% condition1 -> %>
    ...
  <% condition2 -> %>
    ...
  <% true -> %>
    ...
<% end %>
```

**Class Lists:**

```heex
<a class={[
  "base-classes",
  @flag && "conditional-class",
  if(@condition, do: "class-a", else: "class-b")
]}>Text</a>
```

**Copy to Clipboard:**

```heex
<button
  phx-click={JS.dispatch("phx:copy-to-clipboard", detail: %{text: @pool.invite_code})}
  class="btn-ghost btn-sm"
  aria-label="Copy invite code"
>
  <.icon name="hero-clipboard-document" class="w-5 h-5" />
</button>
```

<!-- phoenix:liveview-start -->

## Phoenix LiveView guidelines

- **Never** use the deprecated `live_redirect` and `live_patch` functions, instead **always** use the `<.link navigate={href}>` and `<.link patch={href}>` in templates, and `push_navigate` and `push_patch` functions LiveViews
- **Avoid LiveComponent's** unless you have a strong, specific need for them
- LiveViews should be named like `AppWeb.WeatherLive`, with a `Live` suffix. When you go to add LiveView routes to the router, the default `:browser` scope is **already aliased** with the `AppWeb` module, so you can just do `live "/weather", WeatherLive`
- Remember anytime you use `phx-hook="MyHook"` and that js hook manages its own DOM, you **must** also set the `phx-update="ignore"` attribute
- **Never** write embedded `<script>` tags in HEEx. Instead always write your scripts and hooks in the `assets/js` directory and integrate them with the `assets/js/app.js` file

### LiveView Assigns Naming Conventions

**Use descriptive atom keys following these patterns:**

| Assign Type     | Convention         | Examples                                     |
| --------------- | ------------------ | -------------------------------------------- |
| Single resource | Singular noun      | `@pool`, `@entry`, `@game`                   |
| Collections     | Plural noun        | `@pools`, `@entries`, `@games`               |
| Boolean flags   | Descriptive flag   | `@show_entry_form`, `@join_deadline_passed`  |
| Forms           | Resource + `_form` | `@entry_form`, `@edit_form`                  |
| Maps/Lookups    | Resource + `_map`  | `@results_map`, `@used_teams_by_week`        |
| UI state        | Descriptive name   | `@show_delete_modal`, `@delete_confirmation` |

**Example:**

```elixir
socket =
  assign(socket,
    pool: pool,                          # Resource
    entries: entries,                    # Collection
    current_week: current_week,          # State value
    show_edit_modal: false,              # Boolean UI state
    show_delete_entry_modal: false,      # Boolean UI state
    entry_to_delete: nil,                # Temporary state
    delete_pool_confirmation: "",        # Form state
    edit_form: to_form(Pools.change_pool(pool))  # Form
  )
```

### LiveView Event Naming Conventions

**Standard event naming patterns:**

| Pattern              | Usage              | Examples                               |
| -------------------- | ------------------ | -------------------------------------- |
| `show_*`             | Display UI element | `show_entry_form`, `show_delete_modal` |
| `hide_*` / `close_*` | Hide UI element    | `hide_edit_modal`, `close_modal`       |
| `create_*`           | Create resource    | `create_entry`                         |
| `update_*`           | Update resource    | `update_pool`                          |
| `delete_*`           | Delete resource    | `delete_entry`, `delete_pool`          |
| `validate_*`         | Validate input     | `validate_delete_confirmation`         |
| `confirm_*`          | Confirm action     | `confirm_delete`                       |
| Action verb          | Perform action     | `make_pick`, `submit_join`             |

### LiveView Streams Pattern

**Stream Template Structure:**

```heex
<div id="messages" phx-update="stream">
  <div class="hidden only:block">No messages yet</div>
  <div :for={{id, msg} <- @streams.messages} id={id}>
    {msg.text}
  </div>
</div>
```

**Stream Operations:**

```elixir
# Reset stream with new data (for filtering)
socket
|> assign(:messages_empty?, messages == [])
|> stream(:messages, messages, reset: true)

# Append/prepend items
socket |> stream(:messages, [new_msg])  # append
socket |> stream(:messages, [new_msg], at: -1)  # prepend

# Delete items
socket |> stream_delete(:messages, msg)
```

**Key Stream Guidelines:**

- **Always** use `phx-update="stream"` on the container element
- **Always** destructure as `{{id, item} <- @streams.collection}` in :for comprehensions
- **Always** set `id={id}` on each stream item for proper DOM tracking
- Use `reset: true` when replacing entire stream contents (filtering/sorting)
- Stream items must have a database `:id` field or implement `Phoenix.Param` protocol
- Consider using `stream(:collection, [], reset: true)` to clear streams

### LiveView Testing Pattern

**Always test elements, not raw HTML:**

```elixir
# GOOD
assert has_element?(view, "#product-form")
assert has_element?(view, "[data-role='submit-btn']")

# BAD
html = render(view)
assert html =~ "<form"
```

**Testing Stream Elements:**

```elixir
# Test stream items with specific IDs
assert has_element?(view, "#messages-#{message.id}")
assert has_element?(view, "[id^='messages-']", "Message text")

# Test stream container
assert has_element?(view, "#messages[phx-update='stream']")
```

**Form Testing:**

```elixir
# Test form submission
view |> form("#product-form", product: @invalid_attrs) |> render_submit()
assert has_element?(view, "#product-form .invalid-feedback")

# Test form fields
view |> form("#product-form") |> render_change(%{product: %{name: "New Name"}})
assert has_element?(view, "#product-form input[value='New Name']")
```

**Debug test failures:**

```elixir
html = render(view)
document = LazyHTML.from_fragment(html)
matches = LazyHTML.filter(document, "your-selector")
IO.inspect(matches, label: "Debug")
```

**Key Testing Guidelines:**

- **Always** use `has_element?/2` and `has_element?/3` for element assertions
- **Always** add unique DOM IDs to components for reliable test targeting
- **Never** test implementation details - test user-visible behavior only
- Use `element/2` to target specific elements for interactions
- Use `render_async/1` when testing async assigns
- Test both success and error states for forms and user actions
- Focus on testing outcomes rather than implementation details
- Be aware that `Phoenix.Component` functions like `<.form>` might produce different HTML than expected. Test against the output HTML structure, not your mental model of what you expect it to be
- When facing test failures with element selectors, add debug statements to print the actual HTML, but use `LazyHTML` selectors to limit the output, ie:

      html = render(view)
      document = LazyHTML.from_fragment(html)
      matches = LazyHTML.filter(document, "your-complex-selector")
      IO.inspect(matches, label: "Matches")

**Data Attributes for Resilient Testing:**

Add these attributes to templates to avoid brittle text-matching tests:

- `data-test-id="{component}-{element}-{id?}"` - Unique identifiers (e.g., `data-test-id="pool-card-{@pool.id}"`)
- `data-status="{status}"` - Status badges (e.g., `data-status="active"`)
- `data-role="{role}"` - Semantic sections (e.g., `data-role="admin-badge"`, `data-role="empty-state"`)
- `data-action="{verb-noun}"` - User actions (e.g., `data-action="copy-code"`)

**What NOT to test:**

- Exact UI copy (headings, help text, marketing copy)
- Badge/label text (use data-status instead)
- Navigation link text (test href only)
- Exception: Validation messages and user-generated content are OK to test

### Form Handling Pattern

**Correct Form Setup:**

```elixir
# LiveView
socket |> assign(form: to_form(changeset))

# Template - ALWAYS use @form, never @changeset
<.form for={@form} id="unique-form-id">
  <.input field={@form[:field]} type="text" />
</.form>
```

**Form from params:**

```elixir
def handle_event("submitted", %{"user" => user_params}, socket) do
  {:noreply, assign(socket, form: to_form(user_params, as: :user))}
end
```

<!-- phoenix:liveview-end -->

<!-- usage-rules-end -->
