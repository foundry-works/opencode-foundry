# Subagent Investigation Patterns

For complex fidelity reviews, leverage OpenCode's built-in subagents to gather context before and investigate findings after the MCP review.

## Built-in Subagents for Fidelity Review

| Subagent | Model Size | Use Case |
|----------|------------|----------|
| **Explore** | Small | Fast file discovery, implementation mapping |
| **General** | Medium | Complex deviation analysis requiring code reading |

## Invocation

Use the Task tool with the subagent name (respects `permission.task`; denied subagents are not available).

## Pre-Review Context Gathering

Before running `foundry-mcp_review action="fidelity"`, gather implementation context:

**Phase review preparation:**
```
Use the Explore subagent (medium thoroughness) to find:
- All files matching the phase's task file_path patterns
- Test files corresponding to implementation files
- Configuration or setup files that affect behavior
- Recent git changes in the implementation area
```

**Task review preparation:**
```
Use the Explore subagent (quick thoroughness) to find:
- The implementation file and its imports
- Related test file for the task
- Any configuration the implementation depends on
```

## Post-Review Investigation

After receiving fidelity results, investigate deviations:

**For major deviations:**
```
Use the Explore subagent (very thorough) to investigate:
- Why the implementation differs from spec
- What constraints led to the deviation
- Whether deviation is documented (comments, commits, journals)
- Impact on dependent files
```

**For missing functionality:**
```
Use the Explore subagent (medium thoroughness) to find:
- Whether the feature exists elsewhere (different file/name)
- Related implementations that might explain the gap
- Test coverage for the expected functionality
```

Treat thoroughness as a prompt hint in the subagent prompt, not a config flag.

## When to Use Subagents vs Direct Review

**Use Explore subagent when:**
- Phase spans many files you haven't read
- Deviations are unclear and need investigation
- Need to understand implementation context first
- Want to preserve main context for review results

**Skip subagent exploration when:**
- Single task review in familiar code
- Implementation files already in context
- Quick validation of known changes
- Near context limit

## Benefits

| Benefit | Description |
|---------|-------------|
| **Context isolation** | File searches don't bloat main conversation |
| **Faster discovery** | Small model finds files quickly |
| **Focused investigation** | Post-review exploration targets specific deviations |
| **Parallel preparation** | Can explore while formulating review strategy |
