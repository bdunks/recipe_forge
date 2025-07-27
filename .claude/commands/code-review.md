---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Write
description: Perform a detailed code review of in-process implementation
---

# Code Review Workflow

You are in code review mode.  DO NOT WRITE OR MODIFY ANY CODE. Follow this systematic process to review an in-process implementation:

## 1. Validate Prerequisites
* Verify the plan file exists: `llm_context/plan/$ARGUMENTS.md`
* If plan file doesn't exist, list available plans and ask user to clarify

## 2. High-Level Goal Analysis
* Read and analyze `llm_context/plan/$ARGUMENTS.md` to understand:
  - Overall implementation objectives and scope
  - Features marked as "DRAFT", "DRAFTED", or "🚧" (focus areas)
  - Success criteria and acceptance requirements
  - Any specific review priorities mentioned in the plan

## 3. Code Context Gathering
**Git Repository State:**
* Current git status: !`git status`
* Current git diff (staged and unstaged changes): !`git diff HEAD`
* Current branch: !`git branch --show-current`
* Recent commits: !`git log --oneline -10`

**Codebase Analysis:**
* Leverage TideWave MCP tools for code scanning, function finding, and deeper context
* Use Grep, Glob, and Read tools to examine modified files when necessary
* Spawn multiple sub-agents for parallel exploration and analysis

## 4. Systematic Code Review
Note: This may be the second or third time this tool has been run.  
* Do NOT identify findings just to respond with something.  It is okay to say "no additional findings at this time."
* Do NOT suggest new features or scope beyond what's specified in the plan, and label them as findings.

Provide comprehensive feedback in these priority areas:

### Critical Issues (Must Fix)
* **Correctness & Logic Flaws:** Potential bugs, race conditions, logical errors
* **Security Vulnerabilities:** SQL injection, XSS, insecure data handling, authorization bypass
* **Breaking Changes:** Code that might break existing functionality

### Quality Issues (Should Fix)
* **Idiomatic Code & Best Practices:** Framework conventions, language idioms
* **Performance:** Clear bottlenecks, inefficient queries (N+1), memory issues
* **Test Coverage:** Missing critical test cases for new functionality

### Enhancement Opportunities (Could Fix)
* **Maintainability & Readability:** Code clarity, structure, naming consistency
* **Documentation:** Missing or inadequate documentation
* **Error Handling:** Incomplete error scenarios

## 5. Generate Remediation Plan
* Use TodoWrite tool to create detailed, prioritized task breakdown
* Apply appropriate analysis depth:
  - Simple issues: standard analysis
  - Complex issues: use "think" mode for deeper analysis
  - Critical/complex issues: use "think harder" mode for comprehensive planning
* Include specific justification and impact assessment for each task
* Document the plan clearly for rollback/resumption capability

## 6. Save Review Results
* Save the review to to `./llm_context/code_review/$ARGUMENTS_[timestamp].md`
* Include executive summary, detailed findings, and remediation plan


## Review Principles
* Focus on the specific scope defined in the plan document
* Provide constructive, actionable feedback with clear reasoning
* Consider the broader codebase context and existing patterns