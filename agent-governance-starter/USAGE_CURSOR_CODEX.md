# Usage: Cursor vs Codex (Baseline)

## Was wird automatisch geladen?

- Cursor: `.cursor/rules/*.mdc` (Rules)

## Was ist explizit?

- Cursor Commands: `.cursor/commands/*.md` -> im Chat per `/name`
- Codex Prompt-Templates: `.codex/prompts/*.md` -> du kopierst sie in den Chat

## Warum fehlt /commit manchmal?

`/commit` erscheint nur, wenn im Zielprojekt die Datei `.cursor/commands/commit.md` existiert und Cursor die Commands neu eingelesen hat.
