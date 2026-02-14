# Projekt-Erweiterungen (Repo-Sweep, 2026-02-14)

Ziel: Pro Projekt genau 3 Vorschlaege (1 Skill, 1 Command, 1 Prompt-Template), ohne Duplikate zu bestehenden Bausteinen.

Aktive Zielprojekte (nach Bereinigung): `EcoFlow`, `HAConfig`, `ManageContainer`, `RAG`, `Wunschbrunnen`, `db-konto`, `divera-calsync`, `eoip2ha`, `investor`, `openclaw`, `pkv`, `unifi`.

## EcoFlow
- Skill: `energy-anomaly-triage`
  Nutzen: Einheitliche Analyse fuer Ausreisser/Jumps vor HA-Publish.
  Risiko: Zu starke Filterung kann echte Peaks verbergen.
  Trigger: Bei Datenqualitaetsproblemen oder neuen Messfeldern.
- Command: `/mqtt-replay-check`
  Nutzen: Reproduzierbarer Replay-Test gegen Logs/Datendumps.
  Risiko: Replay-Daten nicht repräsentativ.
  Trigger: Vor Deploy von Parser-/Filter-Aenderungen.
- Prompt: `.codex/prompts/ha-energy-regression-review.md`
  Nutzen: Strukturierter Regression-Review fuer Energy-Dashboard-Werte.
  Risiko: Fokus nur auf HA, nicht auf Quellsystem.
  Trigger: Nach Aenderungen an Energie-Integrationslogik.

## HAConfig
- Skill: `package-migration-guardian`
  Nutzen: Sichere Verschiebung von Automationen in Packages inkl. Version-Header.
  Risiko: Inkonsistente Master-Quelle (HA vs Repo) bei falscher Reihenfolge.
  Trigger: Bei Refactoring von `automations.yaml`/`packages/`.
- Command: `/package-version-bump`
  Nutzen: Erzwingt konsistente Header-/Changelog-Updates in Package-YAMLs.
  Risiko: Version wird rein formal erhoeht.
  Trigger: Bei jeder Package-Aenderung.
- Prompt: `.codex/prompts/ha-release-readiness.md`
  Nutzen: Release-Checkliste vor Deploy (Config-Check, Reload-Pfade, Rollback).
  Risiko: Checkliste wird ohne echten Testlauf abgehakt.
  Trigger: Vor produktivem HA-Deploy.

## ManageContainer
- Skill: `multi-host-compose-sync`
  Nutzen: Verhindert Drift zwischen `storage.galaxy` und `backup.galaxy`.
  Risiko: Falsches Zielsystem bei unklarer Zuordnung.
  Trigger: Bei Stack-Aenderungen ueber mehrere Hosts.
- Command: `/container-update-plan`
  Nutzen: Standardisierter Plan vor Container-Upgrade (Backup, Stop, Verify).
  Risiko: Plan wird nicht vollstaendig ausgefuehrt.
  Trigger: Vor jedem Image-/Tag-Update.
- Prompt: `.codex/prompts/synology-change-window.md`
  Nutzen: Strukturierter Prompt fuer wartungsfenster-sichere Aenderungen.
  Risiko: Unterschaetzung von Abhaengigkeiten.
  Trigger: Bei produktiven Eingriffen ausserhalb Routine.

## RAG
- Skill: `collection-schema-guardian`
  Nutzen: Konsistenz von Payload-Schema/Metadaten ueber Collections.
  Risiko: Zu strenge Regeln bremsen Imports.
  Trigger: Bei neuen Importquellen oder Schema-Aenderungen.
- Command: `/rag-quality-gate`
  Nutzen: Ein gemeinsamer Gate-Run (Import, Collection-Check, Spot-Retrieval).
  Risiko: Spot-Checks decken nicht alle Edge-Cases ab.
  Trigger: Vor Merge von Import-/Chunking-Aenderungen.
- Prompt: `.codex/prompts/retrieval-quality-review.md`
  Nutzen: Standardisierter Review fuer Retrieval-Qualitaet und Fehlerbilder.
  Risiko: Qualitative Bewertung ohne Messmetriken.
  Trigger: Bei schlechter Trefferqualitaet oder Embedding-Wechsel.

## Wunschbrunnen
- Skill: `payment-channel-compliance`
  Nutzen: Trennung Web/PWA vs iOS-App-Store-Zahlungslogik sauber halten.
  Risiko: Falsche Compliance-Annahmen bei Plattformwechsel.
  Trigger: Bei Payment-/Monetarisierungsfeatures.
- Command: `/platform-release-check`
  Nutzen: Schnellcheck, ob Build/Feature fuer Zielplattform regelkonform ist.
  Risiko: Nur statische Plausibilitaet, kein Review-Ersatz.
  Trigger: Vor Release von Store- oder Web-Variante.
- Prompt: `.codex/prompts/appstore-vs-web-go-live.md`
  Nutzen: Einheitliche Go-Live-Entscheidungsvorlage fuer iOS vs Web.
  Risiko: Ueberblick statt tiefer technischer Details.
  Trigger: Wenn ein Feature in beide Kanaele ausgerollt werden soll.

## db-konto
- Skill: `challenge-flow-hardening`
  Nutzen: TAN-/VoP-Flow robust halten (Timeouts, Polling, Errors).
  Risiko: Erhoehte Komplexitaet im Challenge-Handling.
  Trigger: Bei Aenderungen an `/transfer/execute` oder Challenge-Routen.
- Command: `/fints-api-smoketest`
  Nutzen: Schnelltest zentraler Endpoints inkl. Challenge-Pfade.
  Risiko: Abhaengigkeit von verfuegbarer Bankverbindung.
  Trigger: Vor Deploy/Version-Bump.
- Prompt: `.codex/prompts/tan-vop-incident-runbook.md`
  Nutzen: Wiederholbarer Incident-Response-Prompt fuer TAN/VoP-Probleme.
  Risiko: Zu technischer Fokus ohne Nutzerperspektive.
  Trigger: Bei Produktionsstoerung im Ueberweisungsflow.

## divera-calsync
- Skill: `ics-drift-detection`
  Nutzen: Erkennt Drift zwischen Divera-ICS und CalDAV-Zielbestand.
  Risiko: Noise bei kurzfristigen Event-Aenderungen.
  Trigger: Bei Sync-Inkonsistenzen.
- Command: `/sync-drift-report`
  Nutzen: Einheitlicher Bericht zu fehlenden/duplizierten/veraenderten Events.
  Risiko: Report ohne automatische Korrektur.
  Trigger: Nach fehlgeschlagenen Sync-Laeufen.
- Prompt: `.codex/prompts/caldav-sync-regression.md`
  Nutzen: Regression-Analyse fuer Sync-Engine und Mapping.
  Risiko: Zeitaufwendig bei grossen Kalendern.
  Trigger: Bei Aenderungen an Sync-Logik.

## eoip2ha
- Skill: `mqtt-entity-contract-guard`
  Nutzen: Sichert Topic-/Payload-Vertraege fuer HA-Entities.
  Risiko: Breaking Changes werden zu spaet erkannt, wenn Vertrag lueckenhaft ist.
  Trigger: Bei neuen Devices oder Topic-Refactoring.
- Command: `/bridge-end2end-check`
  Nutzen: End-to-End-Pruefung von Gateway-Eingang bis HA-Sensor.
  Risiko: Abhaengigkeit von Live-Hardware.
  Trigger: Vor Deploy auf Synology/Produktivsystem.
- Prompt: `.codex/prompts/ha-bridge-latency-review.md`
  Nutzen: Strukturierte Analyse von Latenz/Dropouts im Bridge-Pfad.
  Risiko: Fokus nur auf Latenz statt Datenkorrektheit.
  Trigger: Bei Verzoegerungen oder fehlenden Updates in HA.

## investor
- Skill: `portfolio-data-integrity`
  Nutzen: Konsistenzregeln fuer Portfolio-/Transaktionsdaten.
  Risiko: Zu strenge Validierung blockiert Imports.
  Trigger: Bei Datenmigrationen oder ETL-Aenderungen.
- Command: `/daily-position-check`
  Nutzen: Standardisierter Tagescheck fuer Positionen und Delta.
  Risiko: Kein Ersatz fuer tiefe Risikoanalyse.
  Trigger: Taegliche Routine oder vor Reporting.
- Prompt: `.codex/prompts/investment-risk-daily-brief.md`
  Nutzen: Einheitliches Kurzbriefing zu Risiko-/Exposure-Aenderungen.
  Risiko: Falsche Sicherheit bei unvollstaendigen Quellen.
  Trigger: Taegliche/woechentliche Review-Runs.

## openclaw
- Skill: `workspace-policy-lint`
  Nutzen: Prueft Workspace-Dateien auf Policy-/Struktur-Drift.
  Risiko: Regel-Overhead bei schnellen Iterationen.
  Trigger: Bei Aenderungen unter `docs/workspace/`.
- Command: `/workspace-drift-check`
  Nutzen: Einmal-Workflow fuer Mapping- und Konsistenzcheck vor Deploy.
  Risiko: Dry-Run wird als vollstaendige Verifikation missverstanden.
  Trigger: Vor Workspace-Deploy auf Host.
- Prompt: `.codex/prompts/openclaw-hardening-review.md`
  Nutzen: Sicherheits-/Betriebsreview fuer Host + Workspace.
  Risiko: Doppelung mit bereits vorhandenen Audits, wenn unscharf definiert.
  Trigger: Vor groesseren Betriebs- oder Sicherheitsaenderungen.

## pkv
- Skill: `reimbursement-reconciliation-guard`
  Nutzen: Sichere Abgleichsregeln zwischen DB, Rechnungen und Erstattungen.
  Risiko: False-Alerts bei Sonderfaellen.
  Trigger: Bei Monatsabschluss oder Datenkorrekturen.
- Command: `/db-drift-check`
  Nutzen: Schnellcheck auf Schema-/Daten-Drift zwischen Erwartung und Prod.
  Risiko: Read-only Checks erkennen nicht jede semantische Abweichung.
  Trigger: Vor Deploy, Migration oder Incident-Analyse.
- Prompt: `.codex/prompts/month-end-pkv-close.md`
  Nutzen: Standardisierter Monatsabschluss-Workflow (Kontrolle + Report).
  Risiko: Prozess wird ohne manuelle Plausibilitaet abgearbeitet.
  Trigger: Monatlicher Abschlusslauf.

## unifi
- Skill: `network-change-risk-assessor`
  Nutzen: Bewertet Risiko geplanter API-basierten Netzwerk-Aenderungen.
  Risiko: Falsche Risikoeinschaetzung ohne Topologie-Kontext.
  Trigger: Vor VLAN-/Firewall-/Policy-Aenderungen.
- Command: `/site-health-snapshot`
  Nutzen: Reproduzierbarer Read-only Snapshot fuer API-Erreichbarkeit und Kernstatus.
  Risiko: Snapshot ist zeitpunktbezogen.
  Trigger: Vor und nach administrativen Aenderungen.
- Prompt: `.codex/prompts/unifi-api-upgrade-impact.md`
  Nutzen: Impact-Analyse bei API-/Controller-Update.
  Risiko: Abhaengigkeit von Release-Infos.
  Trigger: Vor Update-Fenstern.
