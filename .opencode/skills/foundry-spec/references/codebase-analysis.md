# Codebase Analysis Patterns

Strategies for understanding existing code before planning.

## Primary: Explore Agents and Grep

```bash
# Find class/function definitions
Grep pattern="class AuthService" type="py"
Grep pattern="def validateToken" type="py"

# Use Explore agent for broader searches
Use the Explore agent (medium thoroughness) to find all usages of AuthService
```

## Analysis Decision Tree

```
Need to understand code?
    |
    +-- Know exact file/symbol?
    |       |
    |       +-- Yes → Explore agent or Grep
    |
    +-- Need call hierarchy?
    |       |
    |       +-- Explore agent (very thorough)
    |
    +-- Need impact analysis?
            |
            +-- findReferences → count affected files
            +-- Or: Grep + manual analysis
```

## Combining Approaches

```
1. Explore agent (quick) → Find relevant files
2. Grep/Read → Understand file structure
3. Map dependencies and assess impact
4. Read critical files → Deep understanding
```
