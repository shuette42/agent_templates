# Cursor Commands (Baseline)

Commands werden mit `/name` explizit gestartet.

Vorhanden:
- `/precommit` – Checks, kein Commit
- `/commit` – Checks + Commit, Push optional
- `/security-check` – Repo-Security-Check
- `/secrets-check` – nur Secret-Scan
- `/release-gate` – Release-Readiness

Regeln:
- Kein Auto-Commit
- Keine Secrets
