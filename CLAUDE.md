# RecipeForge Development Guide

RecipeForge is a Phoenix LiveView application for recipe management with AI integration capabilities.

## Tech Stack

- **Phoenix 1.7.21** with **LiveView 1.0** - Real-time interactive web applications
- **Elixir 1.14+** with **PostgreSQL** database using UUID primary keys
- **Tailwind CSS 3.4.3** + **ESBuild** for modern frontend assets
- **Tidewave MCP** integration for enhanced development capabilities

## Core Principles

- Write clean, concise, functional code using small, focused functions.
- **Explicit Over Implicit**: Prefer clarity over magic.
- **Single Responsibility**: Each module and function should do one thing well.
- **Easy to Change**: Design for maintainability and future change.
- **YAGNI**: Don't build features until they're needed.
- **Modal-First UI**: All CRUD operations use modals instead of separate pages.

## Project Structure

- **Phoenix Context Pattern**: Organize business logic into domain contexts (`RecipeForge.Recipes`, `RecipeForge.Categories`, `RecipeForge.Ingredients`).
- **Separation of Core and UI**: Keep business logic in contexts separate from web layer in `RecipeForgeWeb`.
- **Shared Utilities**: Common functionality in `RecipeForge.Shared` modules.
- **Feature-Based Organization**: Group related functionality by domain (recipes, categories, ingredients).
- **LiveView-First Web Layer**: Use LiveView for interactive UIs with CoreComponents for reusable elements.

## Coding Style

- **Follow standard Elixir practices** and let `mix format` take care of formatting (run before committing Elixir code).
- **Always assume the server is running on port 4000**
- **Use Tidewave MCP to: run SQL queries, run elixir code, get source location of functions and modules without grepping the filesystem, introspect the logs and runtime, fetch documentation from hex docs, see all the ecto schemas, and much more**
- **Use one module per file** unless the module is only used internally by another module.
- **Use appropriate pipe operators**: Use standard `|>` for function chaining.
- **Prefer using full module names or aliases** rather than imports.
- **Use descriptive variable and function names**: e.g., `recipe_valid?`, `prepare_associations`.
- **Prefer higher-order functions and recursion** over imperative loops.

## Naming Conventions

- **Verb-First Functions**: Start function names with verbs (`create_recipe`, not `recipe_create`).
- **Singular/Plural Naming**: Use singular for DB tables and schema modules, plural for contexts.
- **LiveView Naming**: Use `Live` suffix for LiveView modules (`RecipeLive.Index`, `RecipeLive.Show`).
- **Component Naming**: Use `Component` suffix for LiveComponents (`RecipeFormComponent`).
- **Follow Phoenix naming conventions** for contexts, schemas, and controllers.

## Error Handling

- **Embrace the "let it crash" philosophy**.
- **Railway-Oriented Programming**: Chain operations with `with` for elegant error handling:
    
    ```elixir
    with 
      {:ok, recipe} <- find_recipe(id),
      {:ok, updated} <- update_recipe(recipe, attrs) 
    do  
      {:ok, updated}
    end
    ```
    
- **Result Tuples**: Return tagged tuples like `{:ok, result}` or `{:error, reason}` for operations that can fail, unless the function name ends with `!`.
- **User-friendly error messages**: Implement proper error logging and user-friendly messages, using `put_flash` in LiveView.
- **Transaction Safety**: Use `Repo.transaction` for operations that modify multiple tables (e.g., recipe with ingredients).

## Data Validation and Database

- **Use Ecto changesets** for data validation, even outside of database contexts.
- **Transaction Safety**: Wrap multi-table operations in `Repo.transaction` for data consistency.
- **Implement proper indexing** for performance.

## UI and Frontend

- **Use Phoenix LiveView** for dynamic, real-time interactions.
- **Implement responsive design** with DaisyUI components and Tailwind CSS.
- **Function Components**: Create reusable function components and LiveComponents for UI elements.
- **Phoenix helpers**: Put `handle_event` functions in a shared `LiveHandler` module per extension to keep views and components DRY.
- **Accessibility**: Apply best practices such as **WCAG**.

## Testing

- **Add tests for all new functionality**.
- Include doctests for pure functions (even if that means making private functions public) and test suites focused on public context APIs or UI flows.
- **Use test fixtures** for test data creation from `test/support/fixtures/`.
- **Arrange-Act-Assert**: Structure tests with clear setup, action, and verification phases.
- **SQL Sandbox**: Database tests use isolated transactions for reliability.
- **LiveView Testing**: Use `render_click`, `render_submit`, `render_change` for interactive UI testing.

## Security

- **Security First**: Always consider security implications (CSRF, XSS, etc.).
- **Use strong parameters** in controllers (params validation).
- **Protect against common web vulnerabilities** (XSS, CSRF, SQL injection).

## Documentation and Quality

- Describe why, not what it does.
- **Document Public Functions**: Add `@doc` to all public functions.
- **Examples in Docs**: Include examples in documentation (as doctests when possible).
- **Cautious Refactoring**: Propose bug fixes or optimizations without changing behavior or unrelated code.
- **Comments**: Write comments only when information cannot be included in docs.