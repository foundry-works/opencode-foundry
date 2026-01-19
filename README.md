# opencode-foundry

[OpenCode CLI](https://opencode.ai) skills for opinionated spec-driven development using the [foundry-mcp](https://github.com/foundry-works/foundry-mcp).

## Quick Install

Install globally with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash
```

This installs:
- **9 Foundry skills** to `~/.config/opencode/skills/`
- **MCP server config** merged into `~/.config/opencode/opencode.json`
- **foundry-mcp** Python package (via uvx/pipx/pip)

After installation, start OpenCode and run the setup skill:

```bash
opencode
# Then type: /foundry-setup
```

See [install/README.md](install/README.md) for options (`--dry-run`, `--uninstall`, etc.)

## Structure

- `skills/` is the canonical source for all skills.
- `.opencode/skills/` is a mirror used by OpenCode discovery.

## Sync skills for OpenCode

Run this after any changes to `skills/`:

```bash
./scripts/sync-skills.sh --clean
```

## MCP setup

This repo requires the [foundry-mcp](https://github.com/foundry-works/foundry-mcp) MCP server.

### Prerequisites

- Python 3.10 or higher
- [uv](https://docs.astral.sh/uv/) (recommended) or pip

### Configuration

A default OpenCode config is provided in `opencode.json`. To use it:

1. Copy or merge `opencode.json` into your OpenCode configuration, or
2. Add the following to your existing OpenCode config file:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "experimental": {
    "mcp_timeout": 600000
  },
  "mcp": {
    "foundry-mcp": {
      "type": "local",
      "command": ["uvx", "foundry-mcp"],
      "enabled": true
    }
  },
  "permission": {
    "skill": {
      "*": "allow"
    },
    "mcp__plugin_foundry_foundry-mcp__*": "allow",
    "bash": {
      "git status*": "allow",
      "git diff*": "allow",
      "git log*": "allow",
      "git rev-parse*": "allow",
      "git branch*": "allow",
      "git show*": "allow",
      "pytest*": "allow",
      "python -m pytest*": "allow",
      "foundry-mcp*": "allow",
      "foundry-cli*": "allow",
      "codex*": "allow",
      "claude*": "allow",
      "gemini*": "allow",
      "cursor-agent*": "allow",
      "opencode*": "allow"
    },
    "edit": {
      "**/specs/pending/**": "allow",
      "**/specs/active/**": "allow",
      "**/specs/completed/**": "allow",
      "**/specs/archived/**": "allow"
    },
    "read": {
      "**/specs/**/*.json": "deny",
      "*": "allow"
    },
    "lsp": "allow"
  }
}
```

See the [foundry-mcp documentation](https://github.com/foundry-works/foundry-mcp) for all available options.
