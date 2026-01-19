# LSP Availability Check (Optional)

> Note: OpenCode CLI does not provide built-in LSP tools by default. Use this reference only if you have LSP servers configured; otherwise skip it.

Before using LSP-enhanced workflow, verify availability:

```
# Try to get symbols from target file
symbols = documentSymbol(file="target_file.py")

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
