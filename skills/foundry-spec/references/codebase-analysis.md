# Codebase Analysis Patterns

> Note: OpenCode CLI does not provide built-in LSP tools by default. Use this reference only if you have LSP servers configured; otherwise skip it.

Strategies for understanding existing code before planning.

## LSP Analysis (Optional)

If you have LSP servers configured, you can use LSP tools for semantic analysis:

```python
# Find all references to a symbol
references = findReferences(file="src/auth/service.py", symbol="AuthService", line=15, character=6)

# Get file structure
symbols = documentSymbol(file="src/auth/service.py")

# Navigate to definition
definition = goToDefinition(file="src/api/routes.py", symbol="authenticate", line=42, character=10)

# Find implementations of interface
implementations = goToImplementation(file="src/auth/base.py", symbol="AuthProvider", line=8, character=6)

# Call hierarchy
incoming = incomingCalls(file="src/auth/service.py", symbol="authenticate", line=42, character=10)
outgoing = outgoingCalls(file="src/auth/service.py", symbol="authenticate", line=42, character=10)
```

## Primary: Explore Agents and Grep

Use these by default, and treat LSP as optional:

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
    |       +-- Yes → LSP tools (if configured)
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
2. Grep/Read → Understand file structure
3. findReferences (if configured) → Map dependencies and assess impact
4. Read critical files → Deep understanding
```
