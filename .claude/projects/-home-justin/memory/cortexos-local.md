---
name: cortexos-local
description: "Local CortexOS on the Windows desktop — how it's started, the untracked stop-gap override, search gate and query-logging gotchas"
metadata:
  node_type: memory
  type: project
  originSessionId: a9335c8b-35f9-4848-b6b7-031b4326a629
  modified: 2026-11-07T01:50:41.182Z
---

Justin runs CortexOS (LeornaAI/cortexos, ~/Leorna/cortexos) locally on the desktop since 2026-11-06, for trying it with Claude Code; he doesn't want branches/pushes for it.

- Start/stop from ~/Leorna/cortexos: `docker compose -f docker-compose.yml -f local/docker-compose.override.yml -f local/docker-compose.dev.yml up -d` (or `down`). No restart policy: not up after a reboot. ~1.4 GB RAM (embedder).
- `local/docker-compose.dev.yml` and `.env` are untracked (`.git/info/exclude` also has `local/data/`). The override grants the key `leorna:*`, requires the channel header, maps Postgres to 5433 (5432 = leorna-pg), fixes the seaweed healthcheck, and pins `DATABASE_MIGRATION_URL ...?options=-csearch_path%3Dpublic` — a stop-gap for the fresh-DB crash; real fix planned, not built: ~/.hermes/plans/leorna/nocard-cortexos-fresh-db-migration.md. If that fix ever lands, drop the pin and recreate local/data/postgres once.
- API 127.0.0.1:8080, headers `X-API-Key` (CORTEXOS_API_KEY in .env) + `X-Betwixt-Channel: desktop`; tenant `leorna`.
- **Search gate:** /v1/query and context packs drop pure-vector hits sharing no 3+ letter non-stopword term with the content (relevance_gate_query_rows, crates/cortexos-api/src/main.rs:14314), so paraphrases miss. A non-empty metadata filter (other than label, correlation_id, agent_id+cycle) skips the gate (main.rs:14318).
- **Query text is logged:** every query's full text goes to the event log (log_event 'memory_object_query', main.rs:9941; readable via GET /v1/events).

**Why:** set up 2026-11-06; the memory-hook planner found the gate and logging the same day ([[desktop-docker-gotchas]]).
**How to apply:** brief any CortexOS work with these; the memory hook plan is ~/.hermes/plans/claude-setup/cortexos-memory-hook.md.
