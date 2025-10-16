# GEMINI.md

## CRITICAL: MANDATORY INSTRUCTIONS FOR ALL DEVELOPMENT

**YOU MUST READ AND STRICTLY ADHERE TO ALL LINKED DOCUMENTS BELOW. DEVIATIONS ARE NOT TOLERATED.**

---

## Coding Workflow and Tool Usage - MANDATORY COMPLIANCE

**YOU MUST READ:** @.agents/DEVELOPMENT_WORKFLOW.md

**NON-NEGOTIABLE REQUIREMENTS:**
- **ALWAYS use MCP tools as your FIRST resort** - Never use grep/find/manual file searching when MCP alternatives exist
- **ALWAYS use `mcp__tidewave__get_ecto_schemas`** instead of grepping for schemas
- **ALWAYS use `mcp__tidewave__get_source_location`** instead of find/grep for modules
- **ALWAYS use `mcp__tidewave__project_eval`** for Elixir code evaluation - NEVER use shell commands
- **ALWAYS use `mcp__tidewave__execute_sql_query`** for database introspection
- **ALWAYS use `mcp__tidewave__get_docs`** for documentation lookup
- Use `mcp__tidewave__search_package_docs` for third-party library documentation

**These MCP tools save context, reduce errors, and speed up development. Not using them is a violation.**

---

## Architecture Guidelines and Code Standards - MANDATORY COMPLIANCE

**YOU MUST READ:** @.agents/ARCHITECTURE_GUIDELINES.md

**NON-NEGOTIABLE REQUIREMENTS:**
- Follow all Phoenix 1.8 patterns exactly as specified
- Use correct authentication scopes and `@current_scope.user` patterns
- Follow naming conventions for CRUD functions, events, and assigns
- Use MCP tools as first resort (repeated for emphasis)
- Run `mix precommit` when done with changes
- Follow all Ecto patterns, LiveView patterns, and HEEx template rules
- Test elements not raw HTML - use `has_element?/2` and `has_element?/3`

**FAILURE TO FOLLOW THESE GUIDELINES WILL RESULT IN REJECTED CODE.**

---

## Summary

1. **READ both linked documents NOW**
2. **USE MCP tools for ALL Elixir/Phoenix development tasks**
3. **FOLLOW all architectural patterns without deviation**
4. **ASK if unsure** - never guess or deviate from standards
