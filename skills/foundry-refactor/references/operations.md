# Refactoring Operations

## Rename Operation

1. Use `rg` to find all occurrences
2. Review each match for false positives
3. Edit files one at a time
4. Verify with `rg` that old name no longer appears

## Extract Function/Method

1. **Identify code block** to extract (line range)
2. **Analyze variables:**
   - Inputs: referenced but not defined in block
   - Outputs: defined in block, used after
3. **Create new function** with appropriate signature
4. **Replace original code** with function call
5. **Verify structure:** check the updated file with `Read` and re-run any relevant tests

## Move Symbol

1. **Find all references** to the symbol
2. **Move definition** to new file
3. **Add export** in new location (if needed)
4. **Update all imports** across codebase
5. **Remove from original** file
6. **Verify no broken references:** use `rg` to confirm old import paths are gone

## Dead Code Cleanup

1. **Identify candidate** symbols for removal
2. **Check reference count:**
   ```
   rg -n "unused_function" src/
   ```
3. **Remove symbol** if safe
4. **Clean up imports** that referenced removed symbol
