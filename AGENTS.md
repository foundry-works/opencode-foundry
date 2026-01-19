# AGENTS.md - AI Agent Guidance for OpenCode Foundry

This repository uses **Spec-Driven Development (SDD)** - a methodology where detailed specifications are created before any code is written. AI agents working in this codebase should leverage the available skills to maintain consistency, quality, and traceability.

## Available Skills

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| `/foundry-spec` | Create specifications before coding | New features, complex refactoring, API integrations, architecture changes |
| `/foundry-implement` | Execute tasks from specs | Ready to implement a task from an existing spec |
| `/foundry-test` | Debug test failures systematically | Complex test failures, flaky tests, failures needing investigation |
| `/foundry-review` | Verify implementation matches specs | After implementation, before PR, phase completion checkpoints |
| `/foundry-pr` | Create PRs from completed specs | After spec completion, when creating comprehensive PRs |
| `/foundry-research` | AI-powered research workflows | Complex questions, multi-perspective analysis, brainstorming |
| `/foundry-note` | Capture ideas/bugs without disrupting flow | Quick capture during implementation, parking lot items |
| `/foundry-refactor` | Safe refactoring with LSP impact analysis | Renaming, extracting, moving symbols across files |
| `/foundry-setup` | First-time foundry plugin setup | Initial repository configuration |

## Recommended Workflow

For typical feature development, follow this sequence:

```
1. /foundry-spec     Create specification with phases and tasks
         |
         v
2. /foundry-implement  Execute tasks one by one
         |
         v
3. /foundry-test     Debug any test failures
         |
         v
4. /foundry-review   Verify implementation matches spec
         |
         v
5. /foundry-pr       Create pull request
```

**During implementation:**
- Use `/foundry-note` to capture ideas without breaking flow
- Use `/foundry-research` when facing complex decisions
- Use `/foundry-refactor` for safe cross-file changes

## Skill Selection Guide

```
Is this a new feature or significant change?
├── Yes → /foundry-spec (create specification first)
└── No
    │
    Does a spec already exist?
    ├── Yes → /foundry-implement (execute from spec)
    └── No
        │
        Is this a test failure?
        ├── Yes, complex → /foundry-test
        ├── Yes, obvious → Fix directly
        └── No
            │
            Is this a refactoring?
            ├── Yes, multi-file → /foundry-refactor
            └── No
                │
                Is this a quick idea/bug capture?
                ├── Yes → /foundry-note
                └── No
                    │
                    Need research or analysis?
                    └── Yes → /foundry-research
```

## Critical Rules

### MUST Follow

1. **Spec First**: For any non-trivial feature, create a spec before writing code
2. **Use MCP Tools**: Never read spec JSON files directly with `Read()` or shell commands - always use MCP tools
3. **Track Progress**: Update task status as you work (`in_progress` → `completed`)
4. **Journal Decisions**: Document significant decisions and deviations in journals
5. **Verify Before Complete**: Never mark tasks complete if tests fail or implementation is partial

### NEVER Do

1. **Never skip specifications** for features requiring multiple files or phases
2. **Never read spec JSON directly** - use `foundry-mcp_task`, `foundry-mcp_spec` tools
3. **Never mark tasks complete** if:
   - Tests are failing
   - Implementation is partial
   - Blockers exist
4. **Never refactor without impact analysis** - always check references first
5. **Never invoke `/foundry-implement` from within itself** (anti-recursion rule)

### When NOT to Use Skills

- **Simple one-file changes**: Edit directly
- **Obvious bug fixes**: Fix directly
- **Tests passing**: No need for `/foundry-test`
- **Trivial PRs**: Use `gh` CLI directly
- **Single-file refactoring**: Use Edit tool directly

## Quick Reference

### /foundry-spec
```bash
# Create a plan first
foundry-mcp_plan action="create" name="Feature Name" template="detailed"

# Review the plan
foundry-mcp_plan action="review" plan_path="specs/.plans/feature-name.md"

# Create spec from approved plan
foundry-mcp_authoring action="spec-create" name="feature-name" template="empty"

# Add phases with tasks
foundry-mcp_authoring action="phase-add-bulk" spec_id="{spec-id}" phase='{"title": "Phase 1"}' tasks='[...]'

# Validate
foundry-mcp_spec action="validate" spec_id="{spec-id}"
```

### /foundry-implement
```bash
# Get next recommended task
foundry-mcp_task action="prepare" spec_id="{spec-id}"

# Start working on task
foundry-mcp_task action="update-status" spec_id="{spec-id}" task_id="{task-id}" status="in_progress"

# Complete task (journals automatically)
foundry-mcp_task action="complete" spec_id="{spec-id}" task_id="{task-id}" completion_note="Summary of work done"
```

### /foundry-test
```bash
# Run specific test
pytest tests/test_module.py::test_function -vvs

# Consult AI for complex failures
foundry-mcp_research action="chat" prompt="Debug this failure: {error}" system_prompt="You are debugging a test failure."
```

### /foundry-review
```bash
# Review a phase
foundry-mcp_review action="fidelity" spec_id="{spec-id}" phase_id="{phase-id}"

# Review a specific task
foundry-mcp_review action="fidelity" spec_id="{spec-id}" task_id="{task-id}"
```

### /foundry-pr
```bash
# Create PR for completed spec
foundry-mcp_pr action="create" spec_id="{spec-id}"

# Get PR context first
foundry-mcp_pr action="context" spec_id="{spec-id}"
```

### /foundry-research
```bash
# Single model chat
foundry-mcp_research action="chat" prompt="Your question"

# Multi-model consensus
foundry-mcp_research action="consensus" prompt="Your question" strategy="synthesize"

# Deep investigation
foundry-mcp_research action="thinkdeep" prompt="Complex problem"

# Brainstorming
foundry-mcp_research action="ideate" prompt="Generate ideas for..."
```

### /foundry-note
```bash
# Capture an idea
foundry-mcp_intake action="add" title="[Idea] description" priority="p2"

# List pending items
foundry-mcp_intake action="list" limit=20

# Dismiss resolved item
foundry-mcp_intake action="dismiss" item_id="{item-id}" reason="Resolved"
```

### /foundry-refactor
```bash
# Prefer LSP for impact analysis
LSP(operation="findReferences", filePath="src/module.py", line=10, character=6)

# Fallback if LSP is unavailable
rg -n "SymbolName" src/

# Then proceed with refactoring using Edit tool
# Verify with /foundry-test after changes
```

## Spec File Locations

| Location | Purpose |
|----------|---------|
| `specs/pending/` | Active specs being worked on |
| `specs/completed/` | Finished specs |
| `specs/archived/` | Old specs for reference |
| `specs/.plans/` | Markdown plans before JSON conversion |
| `specs/.plan-reviews/` | AI review outputs for plans |
| `specs/.backups/` | Automatic spec backups |

## Integration with SDD Workflow

```
User Request
     │
     v
/foundry-spec ─────────────────────────────────┐
     │                                          │
     v                                          │
Plan Created → AI Review → Human Approval       │
     │                                          │
     v                                          │
JSON Spec Created                               │
     │                                          │
     v                                          │
/foundry-implement ←───────────────────────────┘
     │
     ├── Task 1 → Implement → Journal → Complete
     ├── Task 2 → Implement → Journal → Complete
     │   └── /foundry-note (capture ideas)
     │   └── /foundry-research (complex decisions)
     │   └── /foundry-refactor (safe refactoring)
     └── Task N → Implement → Journal → Complete
           │
           v
     /foundry-test (if failures)
           │
           v
     /foundry-review (verify fidelity)
           │
           v
     /foundry-pr (create pull request)
```

---

For detailed documentation on each skill, see the `skills/` directory.
