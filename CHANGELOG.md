# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-01-24

### Changed
- Intake actions migrated to authoring router: `intake action="add"` → `authoring action="intake-add"`, etc.
- MCP command changed from `uvx foundry-mcp` to `python -m foundry-mcp` in documentation
- Batch task API parameters: `batch_id` → `task_ids`, `results` → `completions`

### Added
- Deep research polling protocol with mandatory status check guidelines
- Anti-pattern examples for deep research workflow (rapid polling, independent research)
- Spec lifecycle documentation: "Completed vs Archived" guidance section
- Batch reset now supports auto-detection of stale tasks with `threshold_hours`

## [0.3.0] - 2026-01-22

### Changed
- Renamed model names to generic size descriptors (haiku → small, sonnet → medium, opus → large)
- Documentation updated for model-agnostic naming

## [0.2.0] - 2026-01-22

### Added
- Global installer for opencode-foundry via npm
- LSP integration support for foundry skills (refactoring operations)

## [0.1.0] - 2026-01-21

### Added
- Initial release of OpenCode Foundry
- OpenCode-native Foundry skills for spec-driven development:
  - `/foundry-spec`: Create and manage specifications
  - `/foundry-implement`: Task implementation with spec-driven workflows
  - `/foundry-test`: Systematic test debugging
  - `/foundry-note`: Fast-capture intake queue
  - `/foundry-pr`: AI-powered PR creation
  - `/foundry-review`: Implementation fidelity review
  - `/foundry-research`: Multi-workflow research (chat, consensus, thinkdeep, ideate, deep)
  - `/foundry-refactor`: LSP-powered safe refactoring
  - `/foundry-setup`: First-time configuration
- AGENTS.md with AI agent workflow guidance
- OpenCode permissions script (`scripts/setup-permissions-opencode`)
- OpenCode configuration with MCP server integration
- foundry-mcp.toml workspace configuration
- Skill synchronization via `sync-skills.sh`

[Unreleased]: https://github.com/tyler-burleigh/opencode-foundry/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/tyler-burleigh/opencode-foundry/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/tyler-burleigh/opencode-foundry/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/tyler-burleigh/opencode-foundry/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/tyler-burleigh/opencode-foundry/releases/tag/v0.1.0
