# Quickstart Prompt (30-60 Minuten Setup)

```text
Richte im aktuellen Projekt eine minimale, aber produktive Cursor/Codex-Basis ein:

1) Erstelle oder harmonisiere:
- `AGENTS.md`
- `.cursor/rules/{governance-baseline.mdc,main.mdc,context-hierarchy.mdc,use-skills-subagents.mdc,README.md}`
- `.cursor/commands/{README.md,precommit.md,commit.md}`
- `.cursor/skills/{README.md,commit-guardian/SKILL.md}`
- `.codex/README.md`
- `.codex/prompts/{docs-update.md,security-review.md,deploy-or-ops.md,runtime-admin.md}`

2) Erstelle Checks + Hook:
- `scripts/<projekt>/check_governance_consistency.sh`
- `scripts/<projekt>/docs_link_check.sh`
- `.githooks/pre-commit`
- `scripts/<projekt>/install_git_hooks.sh`

3) Integriere in README:
- kurze Governance-Sektion
- Hook-Installation
- Verweis auf Rules/Commands/Skills/Prompts

4) Fuehre Checks aus und gib nur:
- geaenderte Dateiliste
- offene Risiken
- konkrete naechste Schritte

Optional fuer Multi-Repo-Setup:
- `_templates/agent-governance-starter/scripts/sync_governance_baseline.sh /Users/shuette/Documents/Repo`

Kein Commit.
```
