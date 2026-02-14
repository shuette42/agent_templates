#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-/Users/shuette/Documents/Repo}"
DRY_RUN="${DRY_RUN:-0}"
INCLUDE_REFERENCE_OPENCLAW="${INCLUDE_REFERENCE_OPENCLAW:-0}"

created_files=()
updated_files=()

log() {
  printf '%s\n' "$1"
}

ensure_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    return
  fi
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] mkdir -p $dir"
    return
  fi
  mkdir -p "$dir"
}

write_if_missing() {
  local path="$1"
  local content="$2"
  local mode="${3:-}"

  if [[ -f "$path" ]]; then
    return
  fi

  ensure_dir "$(dirname "$path")"
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] create $path"
    return
  fi

  printf '%s\n' "$content" > "$path"
  if [[ -n "$mode" ]]; then
    chmod "$mode" "$path"
  fi
  created_files+=("$path")
}

write_or_update_governance_baseline() {
  local path="$1"
  local content="$2"
  local mode="${3:-}"

  if [[ -f "$path" ]]; then
    if cmp -s <(printf '%s\n' "$content") "$path"; then
      return
    fi
    if [[ "$DRY_RUN" == "1" ]]; then
      log "[dry-run] update $path"
      return
    fi
    printf '%s\n' "$content" > "$path"
    if [[ -n "$mode" ]]; then
      chmod "$mode" "$path"
    fi
    updated_files+=("$path")
    return
  fi

  write_if_missing "$path" "$content" "$mode"
}

template_agents() {
  cat <<'EOF'
# AI Agent Guidelines fuer __REPO_NAME__

Diese Datei dokumentiert die verbindlichen Grundregeln fuer AI-Agents in diesem Projekt.

## Kommunikation

- Sprache: Deutsch
- Anrede: Du-Form
- Ausnahmen: Technische Begriffe, API-Namen und Variablennamen duerfen Englisch bleiben

## Verbindliche Kernregeln

1. Kein Auto-Commit: Nur committen, wenn der User explizit "commit", "save" oder "push" sagt.
2. Keine Secrets in Git: Keine Passwoerter, Tokens, Keys oder Zugangsdaten committen.
3. Bestehende Dateien nicht blind ueberschreiben: Erst lesen, dann minimal-invasiv aendern.
4. Regeln-Hierarchie einhalten: Rules > Commands > Skills/Subagents.

## Repo-weite Standards

- Gemeinsame Regeln: `../RULES-COMMON.md`
- Projekttyp-Standards: `../PROJECT-STYLES.md`
- Globale Cursor-Rules bleiben verbindlich: `~/Library/Application Support/Cursor/.cursorrules`

## Cursor Regeln, Commands und Skills

- Projekt-Regeln liegen in `.cursor/rules/*.mdc` und sind verbindlich.
- Commands liegen in `.cursor/commands/*.md` und werden explizit mit `/` aufgerufen.
- Skills liegen in `.cursor/skills/` und ergaenzen die Rules.
- Bei Konflikten gelten immer die Rules.

## Codex Kompatibilitaet

- `AGENTS.md` ist die verbindliche Regelquelle fuer Codex.
- `.cursor/rules/*.mdc` und `AGENTS.md` muessen inhaltlich konsistent gehalten werden.
- Prompt-Templates fuer Codex liegen unter `.codex/prompts/`.

## Projektspezifische Ergaenzungen

Projektkontext, Architektur, Deploy-Details und fachliche Spezialregeln gehoeren in dieses Dokument oder in verlinkte Fachdokumente.
EOF
}

template_rules_readme() {
  cat <<'EOF'
# Cursor Project Rules

Dieser Ordner enthaelt die verbindlichen Projekt-Regeln fuer Cursor.

## Prioritaet

1. Rules (`.cursor/rules/*.mdc`) sind verbindlich.
2. Commands (`.cursor/commands/*.md`) sind explizite Workflows.
3. Skills (`.cursor/skills/`) und Subagents ergaenzen die Rules.

Kurzform: Rules > Commands > Skills/Subagents.

## Gemeinsame Quellen

- `../RULES-COMMON.md`
- `../PROJECT-STYLES.md`
- `AGENTS.md`

## Enthaltene Basisdateien

- `governance-baseline.mdc`
- `main.mdc`
- `context-hierarchy.mdc`
- `use-skills-subagents.mdc`
EOF
}

template_rule_governance_baseline() {
  cat <<'EOF'
---
description: "Repo-weite Governance-Baseline: Sprache, Commit-Regel, Security, gemeinsame Standards."
alwaysApply: true
---

# Governance Baseline

## Gemeinsame Standards

- Gemeinsame Regeln: `../RULES-COMMON.md`
- Projekttyp-Regeln: `../PROJECT-STYLES.md`
- AGENTS fuer Codex: `AGENTS.md`

## Commit

- NO AUTO-COMMIT.
- Nur committen, wenn der User explizit "commit", "save" oder "push" sagt.

## Sicherheit

- Keine Secrets in Git (Tokens, API-Keys, Passwoerter, Zugangsdaten).
- `.env`, `.env.*` und Credentials-Dateien muessen per `.gitignore` ausgeschlossen sein.

## Kommunikation

- Kommunikation und Doku auf Deutsch.
- Du-Form.

## Hierarchie

Rules > Commands > Skills/Subagents.
EOF
}

template_rule_main() {
  cat <<'EOF'
---
description: "Kernregeln fuer dieses Projekt: Kommunikation, Commit, Sicherheit, gemeinsame Standards."
alwaysApply: true
---

# Projekt Kernregeln

## Verbindliche Quellen

- `AGENTS.md`
- `../RULES-COMMON.md`
- `../PROJECT-STYLES.md`
- `~/Library/Application Support/Cursor/.cursorrules`

## Muss-Regeln

- NO AUTO-COMMIT.
- Keine Secrets im Repository.
- Kommunikation auf Deutsch in Du-Form.
- Rules > Commands > Skills/Subagents.

## Arbeitsweise

- Bestehende Projektlogik zuerst verstehen.
- Erst vorhandene Rules, Commands und Skills harmonisieren, dann erweitern.
- Aenderungen minimal-invasiv halten.
EOF
}

template_rule_context_hierarchy() {
  cat <<'EOF'
---
description: "Hierarchie von Rules, Commands, Skills und Subagents."
alwaysApply: true
---

# Kontext-Hierarchie

1. Rules (`.cursor/rules/*.mdc`) sind verbindlich.
2. Commands (`.cursor/commands/*.md`) sind explizite Workflows.
3. Skills (`.cursor/skills/`) und Subagents sind ergaenzende Expertise.

Bei Konflikten gilt immer: Rules > Commands > Skills/Subagents.
EOF
}

template_rule_use_skills() {
  cat <<'EOF'
---
description: "Skills und Subagents gezielt nutzen, ohne Rules zu umgehen."
alwaysApply: true
---

# Skills und Subagents nutzen

## Grundsatz

- Skills und Subagents aktiv nutzen, wenn die Aufgabe dazu passt.
- Sie ergaenzen Rules und duerfen Rules nie aushebeln.

## Typische Zuordnung

- Sicherheitsthemen -> security-checklist
- Refactoring -> refactoring-guide
- API-Design -> api-designer
- Dokumentation -> technical-writer oder documentation-agent
- Tests -> test-agent

## Commit-Kontext

- Bei Commit-Wunsch immer commit-guardian nutzen.
- Kein Commit ohne erfuellten Pre-Commit-Check.
EOF
}

template_commands_readme() {
  cat <<'EOF'
# Cursor Commands

Commands sind explizite Workflows und werden mit `/` im Chat gestartet.

## Basis-Commands

- `/precommit` -> Fuehrt nur den Pre-Commit-Check aus.
- `/commit` -> Fuehrt Pre-Commit-Check aus und committet nur bei explizitem User-Wunsch.
- `/security-check` -> Fuehrt einen fokussierten Sicherheitscheck aus.

Rules bleiben immer verbindlich.
EOF
}

template_command_precommit() {
  cat <<'EOF'
# Pre-Commit-Check

Pruefe vor jedem Commit:

1. User hat Commit/Push explizit angefordert.
2. Keine Secrets in geaenderten Dateien.
3. Versionierung gepflegt (wenn im Projekt vorhanden: VERSION, CHANGELOG).
4. Relevante Doku/Kommentare wurden mitgezogen.

Wenn etwas fehlt: nicht committen, Luecken klar benennen.
EOF
}

template_command_commit() {
  cat <<'EOF'
# Commit Workflow

1. Fuehre den Pre-Commit-Check aus.
2. Bei offenen Punkten abbrechen und Luecken melden.
3. Nur bei explizitem User-Wunsch committen.
4. Push nur bei explizitem User-Wunsch.

Keine Force-Pushes ohne explizite Freigabe.
EOF
}

template_command_security_check() {
  cat <<'EOF'
# Security Check

Fuehre einen fokussierten Security-Review durch:

1. Secrets-Check in geaenderten Dateien.
2. `.gitignore` auf sensible Dateien pruefen.
3. Konfiguration auf sichere Defaults pruefen.
4. Findings priorisiert melden (Risiko, Datei, konkrete Abhilfe).

Keine stillen Aenderungen mit Sicherheitsrelevanz.
EOF
}

template_skills_readme() {
  cat <<'EOF'
# Projekt Skills

Projekt-Skills liegen in Unterordnern mit `SKILL.md`.

## Basis-Skill

- `commit-guardian`: Erzwingt den Pre-Commit-Check bei jedem Commit-Wunsch.

Globale Skills/Subagents aus Cursor-Settings bleiben zusaetzlich aktiv.
EOF
}

template_skill_commit_guardian() {
  cat <<'EOF'
# Skill: commit-guardian

## Wann nutzen

- Immer bei Commit-/Push-Wunsch.

## Was tun

1. Pre-Commit-Check ausfuehren.
2. Bei Luecken keinen Commit ausfuehren.
3. Erst nach erfuelltem Check und explizitem User-Wunsch committen.
4. Push nur bei explizitem User-Wunsch.

## Verbindlich

- Kein Auto-Commit.
- Keine Secrets in Git.
EOF
}

template_codex_readme() {
  cat <<'EOF'
# Codex Prompt Standards

Dieser Ordner enthaelt wiederverwendbare Prompt-Templates fuer Codex.

## Struktur

- `.codex/prompts/docs-update.md`
- `.codex/prompts/security-review.md`
- `.codex/prompts/deploy-or-ops.md`
- `.codex/prompts/runtime-admin.md`

Rules aus `AGENTS.md` und `.cursor/rules/*.mdc` bleiben verbindlich.
EOF
}

template_prompt_docs_update() {
  cat <<'EOF'
# Prompt-Template: Doku-Update

Kontext:
- Regeln: `AGENTS.md`, `.cursor/rules/*.mdc`

Aufgabe:
Aktualisiere die Dokumentation fuer `<thema>` in `<dateien>`.

Anforderungen:
1. Deutsch, klar und reproduzierbar.
2. Keine Secrets in Beispielen.
3. Links und Verweise konsistent halten.
4. Optional Governance-Check ausfuehren: `./scripts/__REPO_SLUG__/check_governance_consistency.sh`

Output:
1. Kurzfassung der Aenderungen.
2. Dateiliste.
3. Offene Risiken oder nicht ausgefuehrte Checks.
EOF
}

template_prompt_security_review() {
  cat <<'EOF'
# Prompt-Template: Security-Review

Aufgabe:
Fuehre ein Security-Review fuer `<pfad oder bereich>` durch.

Anforderungen:
1. Findings zuerst, priorisiert nach Schwere.
2. Pro Finding: Risiko, Datei, konkrete Abhilfe.
3. False-Positives als solche markieren.
4. Keine pauschalen Aussagen ohne Dateibezug.

Output:
1. Findings (kritisch -> niedrig)
2. Offene Fragen/Annahmen
3. Konkreter Fix-Plan
EOF
}

template_prompt_deploy_ops() {
  cat <<'EOF'
# Prompt-Template: Deploy oder Ops

Aufgabe:
Bereite einen sicheren Deploy/Ops-Ablauf fuer `<scope>` vor oder fuehre ihn aus.

Anforderungen:
1. Erst Ist-Status erfassen.
2. Aendernde Schritte klar von Read-only Schritten trennen.
3. Keine Secrets in Kommandos oder Logs.
4. Bei Risiko-Aenderungen Rollback-Option nennen.

Output:
1. Ausgefuehrte oder geplante Schritte
2. Ergebnis je Schritt
3. Naechster sicherer Schritt
EOF
}

template_prompt_runtime_admin() {
  cat <<'EOF'
# Prompt-Template: Runtime-Administration

Aufgabe:
Fuehre folgende Runtime-Admin-Aufgabe aus: `<task>`.

Anforderungen:
1. Minimal-invasive Kommandos.
2. Vorher/Nachher-Status dokumentieren.
3. Keine geheimen Daten im Output.
4. Bei Unsicherheit zuerst Read-only Diagnose.

Output:
1. Kompakte Kommandoliste
2. Befunde
3. Konkrete Folgeaktion
EOF
}

template_check_governance() {
  cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

required_files=(
  "$ROOT_DIR/AGENTS.md"
  "$ROOT_DIR/.cursor/rules/main.mdc"
  "$ROOT_DIR/.cursor/rules/context-hierarchy.mdc"
  "$ROOT_DIR/.cursor/rules/use-skills-subagents.mdc"
  "$ROOT_DIR/.cursor/commands/precommit.md"
  "$ROOT_DIR/.cursor/commands/commit.md"
  "$ROOT_DIR/.cursor/skills/commit-guardian/SKILL.md"
  "$ROOT_DIR/.codex/README.md"
  "$ROOT_DIR/.codex/prompts/docs-update.md"
  "$ROOT_DIR/.codex/prompts/security-review.md"
)

errors=0

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "FEHLT: $file"
    errors=$((errors + 1))
  fi
done

check_any_contains() {
  local label="$1"
  local pattern="$2"
  shift 2
  local found=1
  local f
  for f in "$@"; do
    if [[ -f "$f" ]] && rg -qi "$pattern" "$f"; then
      found=0
      break
    fi
  done
  if [[ $found -ne 0 ]]; then
    echo "MISSING [$label] pattern: $pattern"
    errors=$((errors + 1))
  fi
}

check_any_contains "no-auto-commit" "NO AUTO-COMMIT|kein Auto-Commit|Kein Auto-Commit" \
  "$ROOT_DIR/AGENTS.md" \
  "$ROOT_DIR/.cursor/rules/main.mdc" \
  "$ROOT_DIR/.cursor/rules/governance-baseline.mdc"

check_any_contains "no-secrets" "keine Secrets|Keine Secrets|Passwoerter|Tokens|API-Keys" \
  "$ROOT_DIR/AGENTS.md" \
  "$ROOT_DIR/.cursor/rules/main.mdc" \
  "$ROOT_DIR/.cursor/rules/governance-baseline.mdc"

check_any_contains "language-de" "Deutsch|Sprache" \
  "$ROOT_DIR/AGENTS.md" \
  "$ROOT_DIR/.cursor/rules/main.mdc" \
  "$ROOT_DIR/.cursor/rules/governance-baseline.mdc"

check_any_contains "hierarchy" "Rules > Commands > Skills/Subagents|Hierarchie" \
  "$ROOT_DIR/AGENTS.md" \
  "$ROOT_DIR/.cursor/rules/context-hierarchy.mdc" \
  "$ROOT_DIR/.cursor/rules/governance-baseline.mdc"

if [[ $errors -gt 0 ]]; then
  echo
  echo "Governance-Check fehlgeschlagen: $errors Problem(e) gefunden."
  exit 1
fi

echo "Governance-Check OK."
EOF
}

template_docs_link_check() {
  cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Fehlende Abhaengigkeit: $1" >&2
    exit 1
  fi
}

require_cmd git
require_cmd rg
require_cmd sed
require_cmd tr

if ! git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Fehler: $ROOT_DIR ist kein Git-Repository." >&2
  exit 1
fi

slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/`//g; s/&amp;/ /g; s/[^a-z0-9[:space:]-]//g; s/[[:space:]]+/-/g; s/^-+//; s/-+$//; s/--+/-/g'
}

build_anchor_list() {
  local file="$1"
  sed -nE 's/^[[:space:]]{0,3}#{1,6}[[:space:]]+(.+)$/\1/p' "$file" \
    | while IFS= read -r heading; do
        slugify "$heading"
      done
}

errors=0

mapfile -t md_files < <(git -c core.quotepath=off -C "$ROOT_DIR" ls-files '*.md')

if [[ "${#md_files[@]}" -eq 0 ]]; then
  echo "Docs-Link-Check OK: keine Markdown-Dateien im Git-Index."
  exit 0
fi

for md_file_rel in "${md_files[@]}"; do
  md_file="$ROOT_DIR/$md_file_rel"
  while IFS=: read -r line_no raw_link; do
    link="$raw_link"
    link="$(echo "$link" | sed -E 's/[[:space:]]+"[^"]*"$//')"
    link="${link#<}"
    link="${link%>}"
    link="${link//\"/}"

    case "$link" in
      http://*|https://*|mailto:*|tel:*|data:*|javascript:*|[#]*)
        continue
        ;;
    esac

    target_path="$link"
    anchor=""
    if [[ "$link" == *"#"* ]]; then
      target_path="${link%%#*}"
      anchor="${link#*#}"
    fi

    if [[ -z "$target_path" ]]; then
      target_file="$md_file"
    elif [[ "$target_path" == /* ]]; then
      target_file="$target_path"
    else
      target_file="$(cd "$(dirname "$md_file")" && cd "$(dirname "$target_path")" 2>/dev/null && pwd)/$(basename "$target_path")"
    fi

    if [[ ! -f "$target_file" ]]; then
      echo "BROKEN FILE: $md_file:$line_no -> $link"
      errors=$((errors + 1))
      continue
    fi

    if [[ -n "$anchor" ]]; then
      anchors_tmp="$(mktemp)"
      build_anchor_list "$target_file" > "$anchors_tmp"
      if ! rg -qx -- "$anchor" "$anchors_tmp"; then
        echo "BROKEN ANCHOR: $md_file:$line_no -> $link"
        errors=$((errors + 1))
      fi
      rm -f "$anchors_tmp"
    fi
  done < <(
    rg -n --no-heading -o '\[[^]]+\]\(([^)]+)\)' "$md_file" \
      | while IFS= read -r match_line; do
          line_no="${match_line%%:*}"
          raw_match="${match_line#*:}"
          raw_link="$(echo "$raw_match" | sed -E 's/^\[[^]]+\]\(([^)]+)\)$/\1/')"
          echo "$line_no:$raw_link"
        done
  )
done

if [[ $errors -gt 0 ]]; then
  echo
  echo "Docs-Link-Check fehlgeschlagen: $errors Problem(e) gefunden."
  exit 1
fi

echo "Docs-Link-Check OK."
EOF
}

template_install_hooks() {
  cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HOOKS_DIR="$ROOT_DIR/.githooks"

if [[ ! -d "$HOOKS_DIR" ]]; then
  echo "Fehler: $HOOKS_DIR fehlt." >&2
  exit 1
fi

git -C "$ROOT_DIR" config core.hooksPath "$HOOKS_DIR"

echo "Git hooksPath gesetzt auf: $HOOKS_DIR"
echo "Aktiver Pre-Commit-Hook: $HOOKS_DIR/pre-commit"
EOF
}

template_pre_commit_hook() {
  cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${ROOT_DIR:-}" ]]; then
  echo "Fehler: Repo-Root nicht ermittelbar." >&2
  exit 1
fi

echo "==> Pre-Commit: Governance-Check"
"$ROOT_DIR/scripts/__REPO_SLUG__/check_governance_consistency.sh"

echo ""
echo "==> Pre-Commit: Docs-Link-Check"
"$ROOT_DIR/scripts/__REPO_SLUG__/docs_link_check.sh"

echo ""
echo "Pre-Commit-Checks erfolgreich."
EOF
}

apply_repo_baseline() {
  local repo="$1"
  local repo_name="$2"
  local repo_slug="$3"

  local content

  content="$(template_agents)"
  content="${content//__REPO_NAME__/$repo_name}"
  write_if_missing "$repo/AGENTS.md" "$content"

  write_if_missing "$repo/.cursor/rules/README.md" "$(template_rules_readme)"
  write_or_update_governance_baseline "$repo/.cursor/rules/governance-baseline.mdc" "$(template_rule_governance_baseline)"
  write_if_missing "$repo/.cursor/rules/main.mdc" "$(template_rule_main)"
  write_if_missing "$repo/.cursor/rules/context-hierarchy.mdc" "$(template_rule_context_hierarchy)"
  write_if_missing "$repo/.cursor/rules/use-skills-subagents.mdc" "$(template_rule_use_skills)"

  write_if_missing "$repo/.cursor/commands/README.md" "$(template_commands_readme)"
  write_if_missing "$repo/.cursor/commands/precommit.md" "$(template_command_precommit)"
  write_if_missing "$repo/.cursor/commands/commit.md" "$(template_command_commit)"
  write_if_missing "$repo/.cursor/commands/security-check.md" "$(template_command_security_check)"

  write_if_missing "$repo/.cursor/skills/README.md" "$(template_skills_readme)"
  write_if_missing "$repo/.cursor/skills/commit-guardian/SKILL.md" "$(template_skill_commit_guardian)"

  write_if_missing "$repo/.codex/README.md" "$(template_codex_readme)"

  content="$(template_prompt_docs_update)"
  content="${content//__REPO_SLUG__/$repo_slug}"
  write_if_missing "$repo/.codex/prompts/docs-update.md" "$content"
  write_if_missing "$repo/.codex/prompts/security-review.md" "$(template_prompt_security_review)"
  write_if_missing "$repo/.codex/prompts/deploy-or-ops.md" "$(template_prompt_deploy_ops)"
  write_if_missing "$repo/.codex/prompts/runtime-admin.md" "$(template_prompt_runtime_admin)"

  write_if_missing "$repo/scripts/$repo_slug/check_governance_consistency.sh" "$(template_check_governance)" "755"
  write_if_missing "$repo/scripts/$repo_slug/docs_link_check.sh" "$(template_docs_link_check)" "755"
  write_if_missing "$repo/scripts/$repo_slug/install_git_hooks.sh" "$(template_install_hooks)" "755"

  content="$(template_pre_commit_hook)"
  content="${content//__REPO_SLUG__/$repo_slug}"
  write_if_missing "$repo/.githooks/pre-commit" "$content" "755"
}

main() {
  if [[ ! -d "$ROOT_DIR" ]]; then
    echo "Fehler: Root-Verzeichnis nicht gefunden: $ROOT_DIR" >&2
    exit 1
  fi

  local dir
  for dir in "$ROOT_DIR"/*; do
    [[ -d "$dir" ]] || continue
    local repo_name
    repo_name="$(basename "$dir")"

    case "$repo_name" in
      _templates)
        continue
        ;;
    esac
    if [[ "$repo_name" == "openclaw" && "$INCLUDE_REFERENCE_OPENCLAW" != "1" ]]; then
      continue
    fi

    local repo_slug
    repo_slug="$repo_name"
    log "--- Bearbeite: $repo_name"
    apply_repo_baseline "$dir" "$repo_name" "$repo_slug"
  done

  log ""
  log "Fertig."
  log "Neu erstellt: ${#created_files[@]}"
  log "Aktualisiert: ${#updated_files[@]}"

  if [[ "${#created_files[@]}" -gt 0 ]]; then
    log ""
    log "Erstellte Dateien:"
    printf '%s\n' "${created_files[@]}"
  fi

  if [[ "${#updated_files[@]}" -gt 0 ]]; then
    log ""
    log "Aktualisierte Dateien:"
    printf '%s\n' "${updated_files[@]}"
  fi
}

main "$@"
