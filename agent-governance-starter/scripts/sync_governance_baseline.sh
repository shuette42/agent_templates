#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-/Users/shuette/Documents/Repo}"
DRY_RUN="${DRY_RUN:-0}"

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKELETON="$TEMPLATE_DIR/skeleton"

if [[ ! -d "$SKELETON" ]]; then
  echo "Fehler: skeleton nicht gefunden: $SKELETON" >&2
  exit 1
fi

log() { printf '%s\n' "$1"; }

copy_if_missing() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" ]]; then
    return
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] create $dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst"
}

sync_repo() {
  local repo="$1"

  # Nur Git-Repos (normaler Clone) anfassen.
  if [[ ! -d "$repo/.git" ]]; then
    return
  fi

  log "==> $repo"

  # Copy-baseline: nur fehlende Dateien.
  while IFS= read -r f; do
    rel="${f#$SKELETON/}"
    copy_if_missing "$f" "$repo/$rel"
  done < <(find "$SKELETON" -type f | sort)

  # Exec-Bits in Zielrepo (nur wenn Datei existiert).
  if [[ "$DRY_RUN" != "1" ]]; then
    chmod +x "$repo/.githooks/pre-commit" 2>/dev/null || true
    find "$repo/scripts" -type f -path '*/governance/*' -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
  fi

  # Gap-Matrix (kurz)
  missing=()
  for must in \
    "AGENTS.md" \
    "USAGE_CURSOR_CODEX.md" \
    ".cursor/rules/main.mdc" \
    ".cursor/commands/commit.md" \
    ".codex/README.md" \
    "scripts/governance/check_governance_consistency.sh" \
    ".githooks/pre-commit"; do
    if [[ ! -e "$repo/$must" ]]; then
      missing+=("$must")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    log "  GAP: ${missing[*]}"
  else
    log "  GAP: none"
  fi
}

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "Fehler: ROOT_DIR nicht gefunden: $ROOT_DIR" >&2
  exit 1
fi

log "Sync Governance Baseline"
log "- ROOT_DIR: $ROOT_DIR"
log "- TEMPLATE: $TEMPLATE_DIR"
log "- DRY_RUN: $DRY_RUN"
log ""

# Nur 1 Level unter ROOT_DIR (dein Setup: /Users/shuette/Documents/Repo/<projekt>)
while IFS= read -r repo; do
  sync_repo "$repo"
done < <(find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

log ""
log "Fertig. Hinweis: /commit erscheint in Cursor erst, wenn .cursor/commands/commit.md im Projekt existiert und Cursor die Commands neu geladen hat."
