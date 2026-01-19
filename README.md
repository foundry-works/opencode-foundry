# opencode-foundry

OpenCode-native Foundry skills.

## Structure

- `skills/` is the canonical source for all skills.
- `.opencode/skills/` is a mirror used by OpenCode discovery.

## Sync skills for OpenCode

Run this after any changes to `skills/`:

```bash
./scripts/sync-skills.sh --clean
```

## MCP setup

This repo expects a local MCP server named `foundry-mcp`. A default config is provided:

- `opencode.json`

If needed, adjust the `command` in `opencode.json` to match your environment.
