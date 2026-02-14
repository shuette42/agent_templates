# AI Agent Guidelines (Baseline)

## Kommunikation

- Deutsch, Du-Form.

## Kernregeln

1. Kein Auto-Commit: nur bei expliziter User-Aufforderung committen/pushen.
2. Keine Secrets in Git.
3. Erst lesen, dann minimal-invasiv aendern.
4. Hierarchie: Rules > Commands > Skills/Subagents.

## Cursor/Codex

- Cursor Rules: `.cursor/rules/*.mdc`
- Cursor Commands: `.cursor/commands/*.md` (per `/...`)
- Projekt-Skills: `.cursor/skills/*/SKILL.md`
- Codex Prompt-Templates: `.codex/prompts/*.md`

Details: `USAGE_CURSOR_CODEX.md`
