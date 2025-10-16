# DEVELOPMENT_GUIDELINES.md

This file provides guidance to agentic coding on the development workflow.

Assume server is always running on localhost:4000. You should never have to start the server.

## Development Commands

**Setup and Dependencies:**

- `mix setup` - Install dependencies, setup database, and build assets
- `mix deps.get` - Install Elixir dependencies only
- `mix ecto.setup` - Create database, run migrations, and seed data
- `mix ecto.reset` - Drop and recreate database with fresh data

**Development Server:** - Assume always running at localhost:4000

**IMPORTANT: Use MCP tools instead of manual searching:**

- Use `mcp__tidewave__get_ecto_schemas` instead of grepping for schemas
- Use `mcp__tidewave__get_source_location` instead of find/grep for modules
- Use `mcp__tidewave__project_eval` instead of shell commands for Elixir evaluation

**Testing:**

- `mix test` - Run all tests (automatically creates test DB and runs migrations)
- `mix test test/path/to/specific_test.exs` - Run specific test file
- `mix test --failed` - Run only previously failed tests

**Code Quality:**

- `mix precommit` - Run full precommit checks (compile with warnings as errors, remove unused deps, format code, run tests)
- `mix format` - Format Elixir code
- `mix compile --warning-as-errors` - Compile with strict warnings

**Database:**

- `mix ecto.create` - Create database
- `mix ecto.migrate` - Run pending migrations
- `mix ecto.drop` - Drop database
- `run priv/repo/seeds.exs` - Seed database with initial data

**Assets:**

- `mix assets.setup` - Install Tailwind and ESBuild if missing
- `mix assets.build` - Build development assets
- `mix assets.deploy` - Build and minify production assets

**MCP Development Tools:**

- Use Tidewave MCP tools for all Elixir development (see MCP Integration section above)
- Never use grep/find when MCP alternatives exist

## Project Architecture

This is a **Phoenix 1.8 web application** for managing survivor pools, built with:

- **Elixir 1.18.4** and **Erlang 27.3.4.2** (managed via mise)
- **Phoenix Framework** with LiveView for real-time interactions
- **PostgreSQL** database via Ecto
- **Tailwind CSS v4** for styling with custom import syntax
- **ESBuild** for JavaScript bundling
- **Tidewave** for Elixir development tooling

### Core Architecture Components

**Application Structure:**

- `lib/survivor/` - Core business logic and contexts
- `lib/survivor_web/` - Web layer (controllers, views, LiveViews, components)
- `lib/survivor_web/components/` - Reusable UI components
- `lib/survivor_web/controllers/` - Traditional HTTP controllers
- `priv/repo/` - Database migrations and seeds

**Key Modules:**

- `Survivor.Application` - OTP application supervisor tree
- `Survivor.Repo` - Ecto repository for database operations
- `SurvivorWeb.Router` - HTTP routing configuration
- `SurvivorWeb.Endpoint` - Phoenix endpoint configuration
- `SurvivorWeb` - Web module definitions and shared imports

**Database:**

- PostgreSQL with Ecto for schema management and queries
- Migrations in `priv/repo/migrations/`
- Seeds in `priv/repo/seeds.exs`

**Frontend:**

- Phoenix templates use HEEx (HTML + EEx) format
- Tailwind CSS v4 with new import syntax in `app.css`
- JavaScript handled via ESBuild
- LiveView for dynamic, real-time interactions

## Development Guidelines

**HTTP Library:**

- Always use `Req` library for HTTP requests (already included)
- Never use `:httpoison`, `:tesla`, or `:httpc`

**Phoenix v1.8 Specific:**

- LiveView templates must start with `<Layouts.app flash={@flash} ...>`
- Use `SurvivorWeb.Layouts` (pre-aliased) for layout components
- Never use `<.flash_group>` outside of layouts module
- Use imported `<.icon>` component for hero icons
- Use imported `<.input>` component for form inputs

**Tailwind CSS v4:**

- Uses new import syntax in `app.css` without `tailwind.config.js`
- Never use `@apply` in custom CSS
- Import external dependencies into `app.js` and `app.css` bundles
- No inline `<script>` tags in templates

**Testing:**

- Use `Phoenix.LiveViewTest` and `LazyHTML` for assertions
- Always reference element IDs added to templates in tests
- Use `element/2` and `has_element/2` instead of raw HTML testing
- Test outcomes rather than implementation details

## Tidewave MCP Integration

**CRITICAL: Always use Tidewave MCP tools as your first resort for Elixir development tasks.**

### Required MCP Tools (Use These Instead of grep/find/manual searching):

- **`mcp__tidewave__get_ecto_schemas`** - List all Ecto schemas in the project

  - Use this to discover available database models
  - Prefer this over grepping for "schema" or "defmodule"

- **`mcp__tidewave__get_source_location`** - Get source location for modules/functions

  - Use for `Module`, `Module.function`, or `Module.function/arity`
  - Faster and more accurate than filesystem searches

- **`mcp__tidewave__project_eval`** - Evaluate Elixir code in project context

  - Test function behavior, debug issues, explore APIs
  - Includes IEx helpers like `exports(ModuleName)`
  - NEVER use shell commands to evaluate Elixir code

- **`mcp__tidewave__execute_sql_query`** - Query the database directly

  - Introspect database structure and data
  - Limited to 50 rows (use LIMIT/OFFSET for more)

- **`mcp__tidewave__get_docs`** - Get documentation for modules/functions

  - Works for project code and dependencies
  - Use for `Module`, `Module.function`, or `Module.function/arity`

- **`mcp__tidewave__search_package_docs`** - Search Hex documentation
  - Search across project dependencies
  - Use when you need to understand third-party libraries

### MCP Usage Rules:

1. **ALWAYS** try MCP tools before grep, find, or manual file searching
2. **ALWAYS** use `project_eval` to test Elixir code behavior
3. **ALWAYS** use `get_ecto_schemas` when looking for database models
4. **ALWAYS** use `get_source_location` when you know the module/function name

**Additional Notes:**

- Always maintain light- and dark-mode compliance via _-base-_ styles (rather than _-gray-_)
