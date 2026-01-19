# Built-in Subagent Patterns

OpenCode provides built-in subagents for efficient exploration without bloating main context.

## Available Subagents

| Subagent | Model Size | Best For |
|----------|------------|----------|
| **Explore** | Small | File discovery, pattern search, codebase questions |
| **General** | Medium | Complex multi-step research, code analysis |

**Note:** Plan is a primary agent. Do not invoke it as a subagent.

## Invocation

Use the Task tool with the subagent name (respects `permission.task`; denied subagents are not available).

## Explore Agent Thoroughness Levels

| Level | Use Case | Example |
|-------|----------|---------|
| `quick` | Known location, simple search | Find a specific file |
| `medium` | Moderate exploration | Find related implementations |
| `very thorough` | Comprehensive analysis | Understand entire subsystem |

Treat thoroughness as a prompt hint in the subagent prompt, not a config flag.

## Pre-Implementation Exploration

Before implementing a task, gather context efficiently:

```
Use the Explore subagent (medium thoroughness) to find:
- Existing implementations of similar patterns
- Test files for the target module
- Related documentation that may need updates
- Import/export patterns in the target directory
```

## Pattern: Find Related Code

```
Use the Explore subagent (quick thoroughness) to find:
- All files importing {module-name}
- Test coverage for {function-name}
- Configuration files affecting {feature}
```

## Pattern: Understand Architecture

```
Use the Explore subagent (very thorough) to understand:
- How {subsystem} is structured
- Data flow through {component}
- Integration points with {external-system}
```

## When NOT to Use Subagents

- Single file already in context
- Task specifies exact file paths
- Near context limit (80%+)
- Simple, isolated changes
