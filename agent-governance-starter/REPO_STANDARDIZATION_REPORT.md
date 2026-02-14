# Repo Standardization Report (Stand: 2026-02-14)

## Ziel

Alle Projekte unter `/Users/shuette/Documents/Repo` auf eine gemeinsame Cursor/Codex-Governance-Basis ziehen, mit `openclaw` als Referenz.

## Was in den Projekten bereits gleich war

- Fast alle Projekte nutzen Deutsch als Kommunikationssprache.
- Viele Projekte hatten bereits `.cursor/rules/main.mdc`, `context-hierarchy.mdc`, `use-skills-subagents.mdc`.
- `AGENTS.md` war in den meisten, aber nicht in allen Projekten vorhanden.
- OpenClaw war als einziges Projekt vollstaendig mit Cursor + Codex + Commands + Skills + Checks + Hooks ausgebaut.

## Hauptluecken vor der Harmonisierung

- Mehrere Projekte ohne `AGENTS.md`.
- Mehrere Projekte ohne `.cursor/rules/` (oder nur altes `.cursorrules`).
- In fast allen Projekten fehlten:
  - `commit-guardian` Skill
  - `precommit`/`commit` Command
  - `.codex/prompts/*`
  - versionierte Git-Hooks und Governance-Checks
- Keine einheitliche Baseline-Datei fuer gemeinsame Repo-Regeln.

## Neue Template-Bausteine

Im Template aufgenommen:

- `_templates/agent-governance-starter/scripts/sync_governance_baseline.sh`
- `governance-baseline.mdc` als zusaetzliche Always-Apply-Rule
- erweiterte Prompt-Standards in:
  - `MASTER_PROMPT.md`
  - `QUICKSTART_PROMPT.md`
  - `PROJECT_EXTENSION_PROMPT.md`

Standardverhalten des Sync-Skripts:

- `openclaw` wird als Referenz standardmaessig uebersprungen.
- Optional mitziehen: `INCLUDE_REFERENCE_OPENCLAW=1`.

## Umgesetzte Harmonisierung

Der Baseline-Sync wurde auf alle Projekte (ausser `_templates` und `openclaw`) ausgefuehrt.

Ergebnis:

- 242 fehlende Governance-Dateien erstellt.
- Alle Zielprojekte enthalten jetzt:
  - `AGENTS.md`
  - `.cursor/rules` inkl. `governance-baseline.mdc`
  - `.cursor/commands` inkl. `precommit`/`commit`/`security-check`
  - `.cursor/skills/commit-guardian`
  - `.codex/README.md` + Prompt-Templates
  - `.githooks/pre-commit`
  - `scripts/<projekt>/check_governance_consistency.sh`
  - `scripts/<projekt>/docs_link_check.sh`
  - `scripts/<projekt>/install_git_hooks.sh`

## Validierung

- `check_governance_consistency.sh` laeuft in allen standardisierten Projekten erfolgreich.
- `docs_link_check.sh` wurde gehaertet:
  - sauberes Verhalten ausserhalb von Git-Repos
  - korrektes Handling von `core.quotepath` in Git

## Hinweis zu OpenClaw

`openclaw` wurde bewusst nicht ueberschrieben, bleibt Referenzprojekt und weiterhin Quelle fuer projektspezifische Best Practices.
