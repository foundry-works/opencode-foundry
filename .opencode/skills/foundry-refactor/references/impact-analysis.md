# Impact Analysis

**NEVER refactor without understanding impact first.**

## Impact Report Format

Present to user before proceeding:

```markdown
## Refactoring Impact: Rename OldClassName -> NewClassName

**Total References:** 47 across 12 files

**By Category:**
- Imports: 12 files
- Class instantiation: 8 locations
- Type annotations: 15 locations
- Inheritance: 2 locations

**Files Affected:**
- src/auth/service.py (8 refs)
- src/api/handlers.py (12 refs)
- tests/test_auth.py (15 refs)
- ... (9 more files)

**Risk Assessment:** MEDIUM
- All references in controlled codebase
- Good test coverage (15 test refs)

Proceed? [Execute] [Dry Run] [Cancel]
```

## Impact Analysis Method

Use Grep/rg to find references:

```
rg -n "OldClassName" src/
```

WARNING: Grep-based analysis may include false positives (comments, strings).
Review each match before proceeding.
