# /security-check

Fokussierter Security-Check fuer Repo-Hygiene:

- `.gitignore` (Secrets ausgeschlossen?)
- `git diff` auf Secrets/Keys/Tokens pruefen
- Konfig: keine Klartext-Secrets; Env-Variablen bevorzugen

Wenn vorhanden: `./scripts/<projekt>/secrets_scan.sh` ausfuehren.

Output:
- Findings nach Schwere
- konkrete Fixes
