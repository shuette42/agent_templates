# Prompt: Projektspezifische Erweiterung auf Basis-Standard

Nutze diesen Prompt, nachdem die Basis bereits steht.

```text
Auf Basis der vorhandenen Agent-Governance im aktuellen Projekt:

1) Analysiere Projekttyp und Betriebsmodell (z. B. Python-Finanz, Home Assistant Admin, Kalender-Sync, PKV-Verwaltung).
2) Schlage genau 3 projektspezifische Erweiterungen vor:
   - 1 Skill
   - 1 Command
   - 1 Prompt-Template
3) Begruende jeweils Nutzen, Risiken und Trigger-Kriterien.
4) Implementiere nach Freigabe die ausgewaehlten 3 Erweiterungen.
5) Aktualisiere nur die noetige Doku (README + `.cursor/skills/README.md` + `.cursor/commands/README.md` + `.codex/README.md`).
6) Fuehre Governance- und Docs-Link-Checks aus.
7) Pruefe Konsistenz zur Baseline:
   - `.cursor/rules/governance-baseline.mdc`
   - `AGENTS.md`
   - `.codex/prompts/*`
   und melde Abweichungen bewusst (nicht versehentlich).

No-Go:
- keine Duplikate bestehender Regeln
- keine Secrets
- kein Commit
```
