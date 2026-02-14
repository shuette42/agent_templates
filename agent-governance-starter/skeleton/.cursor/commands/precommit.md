# /precommit (nur Checks, kein Commit)

Fuehre einen Pre-Commit-Check aus und gib Findings aus. **Kein Commit**.

Checks (wenn vorhanden):
- `./scripts/<projekt>/check_governance_consistency.sh`
- `./scripts/<projekt>/docs_link_check.sh`
- `./scripts/<projekt>/secrets_scan.sh`

Immer zusaetzlich:
- `git status --short`
- `git diff`

Output:
- Checkliste (ok/nicht ok)
- konkrete Fix-Vorschlaege mit Dateiverweisen
