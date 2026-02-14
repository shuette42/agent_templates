#!/usr/bin/env bash
set -euo pipefail

# Minimaler Governance-Check fuer neue Projekte.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Fehlende Abhaengigkeit: $1" >&2
    exit 1
  fi
}

require_cmd rg

AGENTS_FILE="$ROOT_DIR/AGENTS.md"
RULE_MAIN_FILE="$ROOT_DIR/.cursor/rules/main.mdc"
USAGE_FILE="$ROOT_DIR/USAGE_CURSOR_CODEX.md"

required_files=("$AGENTS_FILE" "$RULE_MAIN_FILE" "$USAGE_FILE")
for f in "${required_files[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "FEHLT: $f" >&2
    exit 1
  fi
done

errors=0
check() {
  local file="$1"; local pattern="$2"; local label="$3"
  if ! rg -q "$pattern" "$file"; then
    echo "MISSING [$label] in $file" >&2
    errors=$((errors + 1))
  fi
}

check "$AGENTS_FILE" "Deutsch" "language-de"
check "$AGENTS_FILE" "Kein Auto-Commit|kein Auto-Commit|auto-commit" "no-auto-commit"
check "$AGENTS_FILE" "Keine Secrets|keine Secrets" "no-secrets"

check "$RULE_MAIN_FILE" "Deutsch" "language-de"
check "$RULE_MAIN_FILE" "NO AUTO-COMMIT|Auto-Commit" "no-auto-commit"
check "$RULE_MAIN_FILE" "Keine Secrets|keine Secrets" "no-secrets"

check "$USAGE_FILE" "Cursor" "usage-cursor"
check "$USAGE_FILE" "Codex" "usage-codex"

if [[ $errors -gt 0 ]]; then
  echo
  echo "Governance-Check fehlgeschlagen: $errors Problem(e)." >&2
  exit 1
fi

echo "Governance-Check OK."
