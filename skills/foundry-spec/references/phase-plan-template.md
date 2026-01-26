# Phase Plan Template

High-level markdown plan created before JSON specification.

## Template Structure

```markdown
# {Feature Name} Implementation Plan

## Mission
{Single sentence – this becomes metadata.mission in the JSON spec}

## Objective
{One paragraph describing the core goal}

## Success Criteria
- [ ] {Measurable criterion 1}
- [ ] {Measurable criterion 2}
- [ ] {Measurable criterion 3}

## Constraints
- {Technical constraint}
- {Business constraint}
- {Timeline/resource constraint}

## Phases

### Phase 1: {Phase Name}
**Goal:** {What this phase accomplishes}
**Files:** {Key files affected}
**Tasks:**
- {Task 1 description}
- {Task 2 description}
**Verification:**
- Run tests: {test command or "N/A"}
- Fidelity review: Compare implementation to spec (required)
- Manual checks: {any manual verification steps}

### Phase 2: {Phase Name}
**Goal:** {What this phase accomplishes}
**Files:** {Key files affected}
**Tasks:**
- {Task 1 description}
- {Task 2 description}
**Verification:**
- Run tests: {test command or "N/A"}
- Fidelity review: Compare implementation to spec (required)
- Manual checks: {any manual verification steps}

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {Risk 1} | {L/M/H} | {L/M/H} | {Strategy} |

## Dependencies
- {External dependency 1}
- {Internal dependency 1}

## Open Questions
- {Question needing resolution before implementation}
```

## Creating the Plan

```bash
# Create plan with MCP tool (creates template)
foundry-mcp_plan action="create" name="Feature Name" template="detailed"

# Plan created at: specs/.plans/feature-name.md
```

After creation, read the template and fill in all placeholders with actual content. The Mission sentence you write here is copied verbatim into the JSON spec's `metadata.mission` field.

## Phase Naming Conventions

| Phase Type | Example Names |
|------------|---------------|
| Setup | "Foundation", "Infrastructure Setup", "Core Types" |
| Implementation | "Core Implementation", "Feature Development", "API Layer" |
| Integration | "Integration", "Wiring", "Connection Layer" |
| Testing | "Testing & Validation", "Quality Assurance" |
| Polish | "Documentation", "Cleanup", "Optimization" |

## Good vs Bad Phase Plans

**Good:**
```markdown
### Phase 1: Authentication Core
**Goal:** Implement JWT token generation and validation
**Files:** src/auth/jwt.ts, src/auth/middleware.ts
**Tasks:**
- Create JWT utility with RS256 signing
- Implement auth middleware for protected routes
- Add token refresh endpoint
**Verification:**
- Run tests: `npm test -- --grep "auth"`
- Fidelity review: Compare implementation to spec (required)
- Manual checks: Auth flow works end-to-end
```

**Bad:**
```markdown
### Phase 1: Auth
**Goal:** Do auth stuff
**Tasks:**
- Make it work
**Verification:** It works
```
