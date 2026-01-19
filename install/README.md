# Global Installation

Install opencode-foundry skills and configuration globally for use across all your projects.

## Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash
```

## What Gets Installed

| Component | Location | Description |
|-----------|----------|-------------|
| **Skills** | `~/.config/opencode/skills/` | 9 foundry skills for spec-driven development |
| **Config** | `~/.config/opencode/opencode.json` | MCP server definition and permissions |
| **foundry-mcp** | System Python | MCP server (via uvx/pipx/pip) |

### Installed Skills

- `foundry-spec` - Create detailed specifications before coding
- `foundry-implement` - Task implementation from specs
- `foundry-test` - Systematic test debugging
- `foundry-review` - Review implementation fidelity
- `foundry-pr` - AI-powered PR creation
- `foundry-research` - Multi-model research workflows
- `foundry-note` - Fast-capture intake queue
- `foundry-refactor` - Safe refactoring with LSP
- `foundry-setup` - Verify and configure setup

## Installation Options

### Preview Changes (Dry Run)

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --dry-run
```

### Skip Python Package

If you've already installed foundry-mcp separately:

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --no-python
```

### Force Overwrite

Overwrite existing files without prompting:

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --force
```

## Update

Re-run the installer to update to the latest version:

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash
```

Or explicitly:

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --update
```

This will:
- Re-download all skills (overwrites existing)
- Merge any new config settings (preserves your existing settings)
- Verify foundry-mcp is available

## Uninstall

```bash
curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --uninstall
```

This removes:
- Foundry skills from `~/.config/opencode/skills/`
- foundry-mcp configuration from `opencode.json`

Note: The foundry-mcp Python package is not removed automatically. To remove it:

```bash
pipx uninstall foundry-mcp
# or
pip uninstall foundry-mcp
```

## Requirements

- **Python 3.10+** - Required for foundry-mcp
- **curl or wget** - For downloading files
- **One of:** uvx (recommended), pipx, or pip

### Installing uv (recommended)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Post-Installation

After installation, verify your setup:

```bash
opencode
# Then type: /foundry-setup
```

This will check that all components are properly configured.

## Troubleshooting

### Python version too old

The installer requires Python 3.10 or higher. Check your version:

```bash
python3 --version
```

### uvx not found

Install uv first:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Permission denied

If you get permission errors, the installer may need to create directories:

```bash
mkdir -p ~/.config/opencode/skills
```

### Config not being loaded

Ensure OpenCode is looking at the right config location. The installer uses `~/.config/opencode/opencode.json` by default.

## Manual Installation

If you prefer to install manually:

1. **Install foundry-mcp:**
   ```bash
   uvx foundry-mcp --version  # Test it works
   # or
   pipx install foundry-mcp
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/foundry-works/opencode-foundry.git
   ```

3. **Copy skills:**
   ```bash
   cp -r opencode-foundry/skills/* ~/.config/opencode/skills/
   ```

4. **Copy config template:**
   ```bash
   cp opencode-foundry/install/assets/opencode-global.json ~/.config/opencode/opencode.json
   ```

## Files

| File | Purpose |
|------|---------|
| `install.sh` | Main installation script |
| `assets/opencode-global.json` | Configuration template |
