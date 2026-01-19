# Parallel Investigation Strategies

Use OpenCode's built-in subagents to efficiently explore codebases without bloating main context.

## When to Use Parallel Exploration

| Scenario | Agents | Thoroughness |
|----------|--------|--------------|
| Single feature area | 1 | medium |
| Cross-cutting concerns | 2-3 | medium each |
| Full architecture review | 2-3 | very thorough |
| Quick file discovery | 1 | quick |

## Parallel Exploration Pattern

If you need parallel exploration, use Task tool delegation. Do not assume a single message can spawn multiple subagent sessions.

```
Use the Explore subagent (medium thoroughness) to find:
- All files in the authentication module
- Existing auth patterns and middleware
- Related test files

Use the Explore subagent (medium thoroughness) to find:
- Database models and schemas
- Migration patterns
- ORM usage examples

Use the Explore subagent (quick thoroughness) to find:
- Configuration files
- Environment variable usage
- Deployment scripts
```

Treat thoroughness as a prompt hint in the subagent prompt, not a config flag.

## Investigation Focus Areas

| Focus | What to Look For |
|-------|------------------|
| **Patterns** | Existing implementations of similar features |
| **Structure** | Directory organization, naming conventions |
| **Dependencies** | Import chains, shared utilities |
| **Testing** | Test patterns, fixtures, mocks |
| **Config** | Environment handling, feature flags |

## Benefits of Parallel Investigation

1. **Context isolation** - Each agent uses separate context
2. **Speed** - Haiku model processes quickly
3. **Thoroughness** - Multiple perspectives on codebase
4. **Main context preserved** - Results summarized, not raw file contents

## Anti-Patterns

- **Too many agents** - Maximum 3 per round
- **Overlapping scope** - Each agent should have distinct focus
- **Sequential when parallel possible** - Launch independent searches together
- **Exploring known code** - Use direct Read for files you've already identified
