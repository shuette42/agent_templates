# /commit (Pre-Commit-Check, Commit, Push optional)

Fuehre in dieser Reihenfolge aus: **Pre-Commit-Check** -> **Commit** -> **optional Push**.

## 0. Regeln

- Kein Commit ohne explizite User-Aufforderung.
- Keine Secrets ins Repo.
- Wenn Checks fehlschlagen: abbrechen und Luecken nennen.

## 1. Pre-Commit-Check

- `git status --short`
- `git diff`

Pruefe:
- CHANGELOG: falls vorhanden und Aenderungen nicht nur Typo/Format: `[Unreleased]` aktualisieren.
- Secrets: keine Tokens/Keys/Passwoerter in Diff.
- Doku/Links: falls Doku betroffen -> Link-Check ausfuehren.

Wenn im Projekt vorhanden, nutze diese Checks:
- `./scripts/<projekt>/check_governance_consistency.sh`
- `./scripts/<projekt>/docs_link_check.sh`
- `./scripts/<projekt>/secrets_scan.sh`

## 2. Commit

- Stage nur relevante Dateien: `git add ...`
- Commit-Message kurz und sachlich.

## 3. Optionaler Push

Nur wenn der User explizit auch pushen will:
- `git push`

## Output

- Abgehakte Checkliste
- Was committet wurde (Dateiliste)
- Ob push gemacht wurde
