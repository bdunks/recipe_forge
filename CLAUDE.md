# RecipeForge Development Guide

Phoenix LiveView recipe management app with AI integration.

## Key Notes:
- **Server is running on port 4000** (standard Phoenix port)
- **IMPORTANT**: **Use Tidewave MCP tools** for: SQL queries, Elixir code execution, source location lookup, runtime introspection, Hex docs, Ecto schemas

## Bash Commands
- `mix phx.server` - Start dev server (port 4000)
- `mix test` - Run all tests
- `mix format` - Format Elixir code (run before commits)
- `mix compile` - Compile project
- `mix ecto.migrate` - Run database migrations

## Code Style
- Follow Phoenix Context Pattern: `RecipeForge.Recipes`, `RecipeForgeWeb.RecipeLive`
- LiveView-first UI with DaisyUI/Tailwind CSS
- Verb-first function names: `create_recipe`, not `recipe_create`
- Railway-oriented programming with `with` for error handling
- Return `{:ok, result}` or `{:error, reason}` tuples

## Testing
- TDD cycle: Write failing tests → Make them pass → Don't modify tests unless directed otherwise
- Use test fixtures from `test/support/fixtures/`
- LiveView testing: `render_click`, `render_submit`, `render_change`

## Project-Specific Notes
- Put `handle_event` functions in shared `LiveHandler` modules
- Plans in `llm_context/plan/` should be updated after each step