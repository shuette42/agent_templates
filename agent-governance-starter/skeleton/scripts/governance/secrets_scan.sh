#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Fehlende Abhaengigkeit: $1" >&2
    exit 1
  fi
}

require_cmd git
require_cmd rg

tracked_files="$(git ls-files)"
if [[ -z "$tracked_files" ]]; then
  echo "Warnung: Keine getrackten Dateien gefunden." >&2
  exit 0
fi

hard='(ghp_[A-Za-z0-9]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{30,}|-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----)'
assign='(?i)(API_KEY|SECRET|TOKEN|PASSWORD)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9_./+=-]{12,}'

# shellcheck disable=SC2086
hard_matches="$(rg -n -I -S -e "$hard" $tracked_files || true)"
# shellcheck disable=SC2086
assign_matches="$(rg -n -I -S -e "$assign" $tracked_files || true)"

if [[ -n "$hard_matches" || -n "$assign_matches" ]]; then
  echo "Moegliche Secret-Treffer gefunden:" >&2
  if [[ -n "$hard_matches" ]]; then
    echo "$hard_matches"
  fi
  if [[ -n "$assign_matches" ]]; then
    echo "$assign_matches"
  fi
  exit 2
fi

echo "Secrets-Scan OK."
