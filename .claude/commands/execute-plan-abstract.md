---
allowed-tools: Read, Bash(mix test:*), Bash(mix format:*), Bash(git status:*), Bash(git diff:*), Bash(ls:*), TodoWrite, Task, Grep, Glob, mcp__tidewave__*
description: Systematically implement all fixes from code review findings using TDD, prioritizing critical issues first
---

# Code Review Implementation Command

This command systematically implements ALL fixes from code review findings using Test-Driven Development.

## Usage

```
/implement-fixes <plan-name>
```

**Example:**
```
/implement-fixes screens
```

This will process `llm_context/code_review/screens_20250720.md` and implement ALL findings from the related `llm_context/plan/screens.md`.

## Implementation Workflow

### Phase 1: Analysis and Planning 

1. **Parse Code Review File**
   - Read `llm_context/code_review/$ARGUMENTS_[datestamp].md`
   - Extract ALL findings categorized by priority:
     - 🚨 **Critical Issues (Must Fix)** - Security, performance, breaking changes
     - ⚠️ **Quality Issues (Should Fix)** - Best practices, maintainability  
     - 💡 **Enhancement Opportunities (Could Fix)** - Nice-to-haves

2. **Create Implementation Plan**
   - Use TodoWrite to create tasks for ALL findings, prioritized by urgency
   - Reference the related plan file `llm_context/plan/$ARGUMENTS.md` for context
   - Group related fixes to minimize file conflicts
   - Order implementation: Critical → Quality → Enhancement

3. **Pre-Implementation Verification**
   - Run `git status` to ensure clean working directory
   - Run `mix test` to establish baseline test results
   - Check for any compilation warnings with `mix compile --warnings-as-errors`

### Phase 2: Test-Driven Implementation (All Finding Types)

4. **For Each Finding (in priority order: Critical → Quality → Enhancement):**

   **4.1 Test-Driven Development Cycle:**
   - **Write Tests First**: Where possible, reasonable, and best-practice, create or modify tests that verify the expected behavior after the fix.  
      - Note: Some fixes may not require tests (updating a library version), or the code path already has passing tests (e.g., review found code that is not idiomatic or can be simplified).  In this case move straight to implementing a fix.
   - **Run Tests**: Execute `mix test` to confirm the new tests fail (red phase)
   - **Implement Fix**: Apply the specific solution recommended in the code review
   - **Run Tests**: Execute `mix test` to confirm tests pass (green phase)
   - **Refactor**: Clean up code while keeping tests passing
   - **Update TodoWrite**: Mark finding as completed

   **4.2 Implementation Steps per Finding:**
   - Read the affected file(s) listed in the finding location
   - Identify what tests are needed to verify the fix
   - Write failing tests that capture the expected behavior
   - Apply the recommended solution from the code review
   - Ensure all tests pass, including existing ones
   - Run `mix format` for code style compliance

### Phase 3: Final Verification and Documentation

5. **Comprehensive Testing**
   - Run full test suite: `mix test`
   - Run `mix format` to ensure all code is properly formatted
   - Check for any compilation warnings
   - Verify all TodoWrite tasks are marked as completed

6. **Update Documentation**
   - Update the original code review file with implementation status
   - Add a new section "## Implementation Status" with:
     - ✅ **Implemented** - List of ALL completed fixes with commit references
     - ⚠️ **Modified** - List of fixes that required adaptation with explanations
     - 📝 **Notes** - Any implementation details or discovered issues
    
7. **Update Plan File**
   - Mark ALL relevant items in `llm_context/plan/{review-file-name}.md` as 🚧 DRAFTED or ✅ completed
   - Add implementation notes and any discovered issues

## Implementation Guidelines

### Test-Driven Development Requirements
- **Always write tests before implementing fixes if the feature under development does not have tests**
- **Confirm tests fail before implementing (when relevant)** (red phase)
- **Ensure tests pass after implementation** (green phase)
- **Write tests that would catch the original issue**
- **Include edge cases and error conditions in tests**

### Tool Usage
- **Use Task tool** for parallel analysis when examining multiple files
- **Use mcp__tidewave__ tools** for Elixir-specific operations (tests, compilation, docs)
- **Spawn sub-agents** when implementing unrelated fixes simultaneously
- **Use TodoWrite religiously** to track progress and ensure no findings are missed

### Safety Measures
- **Never skip tests** - always run `mix test` after any code changes
- **Make atomic changes** - implement one finding at a time
- **Preserve functionality** - ensure no existing features are broken
- **Follow project conventions** - maintain consistency with existing codebase

### Error Handling
- If a fix causes test failures, analyze and fix the underlying issue
- If a recommended fix conflicts with current architecture, adapt the solution
- If dependencies are missing for a fix, add them as part of the implementation

### Documentation Requirements
- Update code review file with implementation status
- Update related plan file with progress
- Include specific commit hashes for traceability
- Document any deviations from recommended solutions with reasoning

## Expected Outcomes

After running this command:
- ALL critical issues resolved
- ALL quality issues addressed
- ALL enhancement opportunities implemented
- Comprehensive test coverage for all fixes
- Full test suite passing
- Code properly formatted
- Documentation updated with implementation status
- Clean commit history with descriptive messages
- TodoWrite tasks completed for full traceability

## Example Implementation Sequence

For a review file with 10 findings:
1. Parse and prioritize all 10 findings
2. For each of 3 critical findings: Write tests → Fail → Implement → Pass → Refactor
3. For each of 5 quality findings: Write tests → Fail → Implement → Pass → Refactor  
4. For each of 2 enhancement findings: Write tests → Fail → Implement → Pass → Refactor
5. Final verification and documentation
6. Create focused commits with clear messages
7. Update all tracking documents

This systematic TDD approach ensures thorough implementation with robust test coverage while maintaining code quality and project stability.