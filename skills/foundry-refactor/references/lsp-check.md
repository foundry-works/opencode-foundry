# LSP Availability Check

Before using LSP-enhanced workflow, verify availability:

**Prerequisites:**
- `permission.lsp: "allow"` in `opencode.json`
- `OPENCODE_EXPERIMENTAL_LSP_TOOL=true` (or `OPENCODE_EXPERIMENTAL=true`)

```
# Try to get symbols from target file
symbols = LSP(operation="documentSymbol", filePath="target_file.py", line=1, character=1)

if symbols returned successfully:
    Use LSP-enhanced workflow
else:
    Fall back to Grep-based workflow
```

**Fallback triggers:**
- LSP tool returns error
- No language server for file type (e.g., Makefile, .txt)
- Empty result for known non-empty file
- Timeout (>5 seconds)
