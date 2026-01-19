#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="${repo_root}/skills"
dst="${repo_root}/.opencode/skills"

clean=false
if [[ "${1:-}" == "--clean" ]]; then
  clean=true
fi

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
