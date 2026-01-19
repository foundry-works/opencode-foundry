# Codebase Analysis Patterns

Strategies for understanding existing code before planning.

## LSP Analysis (Preferred)

Use OpenCode's built-in LSP tool for precise semantic analysis:

```python
# Find all references to a symbol
references = LSP(operation="findReferences", filePath="src/auth/service.py", line=15, character=6)

# Get file structure
symbols = LSP(operation="documentSymbol", filePath="src/auth/service.py", line=1, character=1)

# Navigate to definition
definition = LSP(operation="goToDefinition", filePath="src/api/routes.py", line=42, character=10)

# Find implementations of interface
implementations = LSP(operation="goToImplementation", filePath="src/auth/base.py", line=8, character=6)

# Call hierarchy
incoming = LSP(operation="incomingCalls", filePath="src/auth/service.py", line=42, character=10)
outgoing = LSP(operation="outgoingCalls", filePath="src/auth/service.py", line=42, character=10)
```

## Fallback: Explore Agents and Grep

When LSP is unavailable, use:

```bash
# Find class/function definitions
Grep pattern="class AuthService" type="py"
Grep pattern="def validateToken" type="py"

# Use Explore agent for broader searches
Use the Explore agent (medium thoroughness) to find all usages of AuthService
```

Treat thoroughness as a prompt hint in the subagent prompt, not a config flag. Use Task tool delegation when programmatic subagents are allowed.

## Analysis Decision Tree

```
Need to understand code?
    |
    +-- Know exact file/symbol?
    |       |
    |       +-- Yes → LSP tools (findReferences, documentSymbol)
    |       |
    |       +-- No → Explore agent or Grep
    |
    +-- Need call hierarchy?
    |       |
    |       +-- LSP available → incomingCalls/outgoingCalls
    |       |
    |       +-- No LSP → Explore agent (very thorough)
    |
    +-- Need impact analysis?
            |
            +-- findReferences → count affected files
            +-- Or: Grep + manual analysis
```

## Combining Approaches

```
1. Explore agent (quick) → Find relevant files
2. documentSymbol → Understand file structure
3. findReferences → Map dependencies and assess impact
4. Read critical files → Deep understanding
```
