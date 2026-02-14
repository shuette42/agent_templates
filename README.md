# Repo Templates

Zentrale Vorlagen fuer wiederverwendbare Projekt-Bootstraps.

## Enthalten

- `agent-governance-starter/` – Standardbasis fuer Cursor + Codex (Rules, Skills, Commands, Prompt-Templates, Hooks, Checks).
- `agent-governance-starter/scripts/sync_governance_baseline.sh` – erstellt fehlende Basisdateien in allen Repo-Projekten (ohne bestehende projektspezifische Dateien zu ueberschreiben).
- `agent-governance-starter/REPO_STANDARDIZATION_REPORT.md` – dokumentiert Analyse und Harmonisierung ueber alle Repo-Projekte.

## Nutzung

1. Zielprojekt oeffnen.
2. Prompt aus `agent-governance-starter/MASTER_PROMPT.md` in Codex oder Cursor verwenden.
3. Platzhalter (`<...>`) ersetzen.
4. Ergebnis pruefen (Checks laufen lassen, Doku querlesen).

Multi-Repo Harmonisierung:

```bash
_templates/agent-governance-starter/scripts/sync_governance_baseline.sh /Users/shuette/Documents/Repo
```

Hinweis: `openclaw` wird standardmaessig als Referenzprojekt uebersprungen. Wenn du es explizit mitziehen willst:

```bash
INCLUDE_REFERENCE_OPENCLAW=1 _templates/agent-governance-starter/scripts/sync_governance_baseline.sh /Users/shuette/Documents/Repo
```
