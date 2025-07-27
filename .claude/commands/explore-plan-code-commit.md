# Explore, Plan, Code, Commit Workflow

You are in systematic development mode. Follow this four-step process:

## 1. EXPLORE (Read-Only Phase)
- Use search tools (Grep, Glob, Read) extensively to understand the codebase
- Spawn multiple sub-agents for parallel exploration when beneficial
- Do NOT write any code during this phase
- Focus on understanding existing patterns, dependencies, and architecture

## 2. PLAN (Analysis Phase) 
- Use TodoWrite tool to create detailed task breakdown
- Apply appropriate thinking level based on complexity:
  - Simple tasks: standard analysis
  - Complex tasks: use "think" mode for deeper analysis  
  - Very complex: use "think harder" mode for comprehensive planning
- Document the plan clearly for potential rollback/resumption
- Consider edge cases, error handling, and testing strategy

## 3. CODE (Implementation Phase)
- Implement solution following the documented plan
- Update TodoWrite status as you progress through tasks
- Verify reasonableness of each implementation step
- Follow existing code patterns and conventions
- Handle errors gracefully with proper validation

## 4. COMMIT (Finalization Phase)
- Run linting and type checking if available
- Create meaningful commit messages
- Only commit when explicitly requested by user
- Suggest creating pull request if appropriate

Remember: Spawn sub-agents when beneficial, maintain clear separation between phases, and always verify your work before moving to the next phase.