# Quickstart Prompt (30-60 Minuten Setup)

```text
Richte im aktuellen Projekt eine minimale, aber produktive Cursor/Codex-Basis ein:

1) Erstelle oder harmonisiere:
- `AGENTS.md`
- `USAGE_CURSOR_CODEX.md`
- `.cursor/rules/{governance-baseline.mdc,main.mdc,secure-delivery.mdc,python-quality.mdc,testing-and-architecture.mdc,context-hierarchy.mdc,use-skills-subagents.mdc,README.md}`
- `.cursor/commands/{README.md,precommit.md,commit.md,security-check.md,secrets-check.md,release-gate.md}`
- `.cursor/skills/{README.md,commit-guardian/SKILL.md,changelog-on-commit/SKILL.md}`
- `.codex/README.md`
- `.codex/prompts/{docs-update.md,security-review.md,deploy-or-ops.md,runtime-admin.md,release-readiness.md}`
- `.github/workflows/governance-ci.yml`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/CODEOWNERS`
- `SECURITY.md`

2) Erstelle Checks + Hook:
- `scripts/<projekt>/check_governance_consistency.sh`
- `scripts/<projekt>/docs_link_check.sh`
- `scripts/<projekt>/secrets_scan.sh`
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
