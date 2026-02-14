# Master Prompt: Agent-Governance-Starter (Cursor + Codex)

Nutze diesen Prompt in einem neuen oder bestehenden Projekt, um eine starke, einheitliche Basis aufzubauen.

**Nutzung durch Cursor/Codex:** Was automatisch geladen wird (Rules) vs. was explizit ausgeloest werden muss (Commands, Codex-Prompts), siehe `USAGE_CURSOR_CODEX.md`.

```text
Du arbeitest im Projekt unter <PROJECT_PATH>.

Ziel:
Erstelle eine wiederverwendbare Basis fuer Agent-Governance, die in Cursor und Codex gleich funktioniert, ohne bestehende Projektlogik zu brechen.

Verbindliche Regeln:
1) Kommunikation und Doku auf Deutsch (Du-Form).
2) Kein Auto-Commit. Nur committen bei expliziter User-Aufforderung.
3) Keine Secrets ins Repo.
4) Bestehende Dateien nie blind ueberschreiben; erst lesen, dann minimal-invasiv erweitern.
5) Erst auf vorhandene Rules/Skills/Commands pruefen und harmonisieren statt duplizieren.
6) OpenClaw gilt als Referenz fuer Governance-Qualitaet, aber projektspezifische Inhalte duerfen nicht blind kopiert werden.

Bitte umsetzen:

A) Agent-Basis
- `AGENTS.md` erstellen/vereinheitlichen mit:
  - Projektkontext
  - Kommunikationsregeln
  - Sicherheitsregeln
  - Commit-Regeln
  - Hierarchie: Rules > Commands > Skills/Subagents
  - Cursor/Codex-Kompatibilitaet
- `USAGE_CURSOR_CODEX.md` erstellen/aktualisieren:
  - Was wird automatisch geladen?
  - Was ist explizit/on-demand?
  - Wie wird Skill-Nutzung abgesichert?

B) Cursor-Basis
- `.cursor/rules/` mit:
  - `governance-baseline.mdc`
  - `main.mdc`
  - `secure-delivery.mdc`
  - `python-quality.mdc` (mit Python-Globs)
  - `testing-and-architecture.mdc`
  - `context-hierarchy.mdc`
  - `use-skills-subagents.mdc`
  - `README.md`
- `.cursor/commands/` mit:
  - `README.md`
  - `precommit.md`
  - `commit.md`
  - `security-check.md`
  - `secrets-check.md`
  - `release-gate.md`
  - optional projektspezifische Commands
- `.cursor/skills/` mit:
  - `README.md`
  - `commit-guardian/SKILL.md`
  - `changelog-on-commit/SKILL.md`
  - optional 1-2 projektspezifische Skills

C) Codex-Basis
- `.codex/README.md`
- `.codex/prompts/` mit Templates:
  - `docs-update.md`
  - `security-review.md`
  - `deploy-or-ops.md`
  - `runtime-admin.md`
  - `release-readiness.md`

D) Automatisierte Checks
- `scripts/<projekt>/check_governance_consistency.sh`
- `scripts/<projekt>/docs_link_check.sh`
- `scripts/<projekt>/secrets_scan.sh`
- `scripts/<projekt>/install_git_hooks.sh`
- `.githooks/pre-commit` (ruft Governance-, Secrets- und Docs-Check auf)
- `.github/workflows/governance-ci.yml`

E) GitHub-Standards
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/CODEOWNERS`
- `SECURITY.md`

F) Doku-Integration
- `README.md` und ggf. `docs/<setup>.md` erweitern um:
  - Nutzung der Rules/Commands/Skills/Prompts
  - Hook-Installation
  - Standard-Workflows

G) Repo-Sweep (wenn mehrere Projekte vereinheitlicht werden sollen)
- Baseline-Sync-Skript aus dem Template nutzen:
  - `_templates/agent-governance-starter/scripts/sync_governance_baseline.sh /Users/shuette/Documents/Repo`
- Skript darf fehlende Basisdateien erzeugen, aber bestehende projektspezifische Regeln nicht ueberschreiben.
- Danach Gap-Matrix fuer alle Projekte ausgeben (was weiterhin projektspezifisch offen ist).

Abschluss:
1) Alle neuen Checks ausfuehren.
2) Findings/Rest-Risiken nennen.
3) Exakt auflisten, welche Dateien erstellt/geaendert wurden.
4) Kein Commit ausfuehren.
```
