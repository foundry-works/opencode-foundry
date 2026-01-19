#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="${repo_root}/skills"
dst="${repo_root}/.opencode/skills"

scripts_dir="${repo_root}/scripts"

clean=false
if [[ "${1:-}" == "--clean" ]]; then
  clean=true
fi

# Sync skills
mkdir -p "${dst}"

if command -v rsync >/dev/null 2>&1; then
  if [[ "${clean}" == true ]]; then
    rsync -a --delete "${src}/" "${dst}/"
  else
    rsync -a "${src}/" "${dst}/"
  fi
else
  if [[ "${clean}" == true ]]; then
    rm -rf "${dst}"
    mkdir -p "${dst}"
  fi
  cp -a "${src}/." "${dst}/"
fi

# Sync AGENTS.md to .opencode directory
opencode_dir="${repo_root}/.opencode"
if [[ -f "${repo_root}/AGENTS.md" ]]; then
  cp "${repo_root}/AGENTS.md" "${opencode_dir}/"
  echo "Synced AGENTS.md to .opencode/"
fi

echo "Skills synced successfully"
echo ""
echo "To apply OpenCode permissions, run:"
echo "  ./scripts/setup-opencode-config --apply"
