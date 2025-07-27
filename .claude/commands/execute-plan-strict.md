---
allowed-tools: Read, Bash(mix test:*), Bash(mix format:*), Bash(git status:*), Bash(git diff:*), Bash(ls:*), TodoWrite, Task, Grep, Glob, mcp__tidewave__*
description: Systematically implement all fixes from an AI agent plan.  Do not troubleshoot test or compile failures.  
---

# Code Review Implementation Command

This command systematically implements ALL fixes from a plan.  Do not troubleshoot compilation or test failures.  Simply report the failures exist and stop at the end of the plan.

# Workflow

Follow the plan at `llm_context\plan\$ARGUMENTS.md`.  

Create a todo list for each item in the plan.

Do not deviate from the plan, even to troubleshoot errors.

After all todos are complete, stop.

Assume execution in "Auto-Accept" mode.  Spawn as many sub-agents as possible to keep context clean and quickly move through the plan.