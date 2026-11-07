# PLANNER brief: cortexos-fresh-db-migration (Leorna, CortexOS) — INVESTIGATE ONLY

Role: PLANNER for Leorna project CortexOS (repo LeornaAI/cortexos, clone at ~/Leorna/cortexos, branch main @ 262cf33).
Justin chose "Just investigate": find and prove the root cause and write a fix plan he can approve later.
Make no worktree, branch, code edit or commit in any repo. Do not push, post, open issues or touch ClickUp.

## Skills to load first (Skill tool), and say so in one line each
1. `leorna` — PLANNER role; do its Step 1 context load as it applies to CortexOS.
2. `engineering-best-practices`
3. `implementation-planning`
4. `systematic-debugging` — root cause with evidence before any fix is planned.
5. `backend-data-migrations` (migration change that existing deployments also run).

## The bug
Fresh local stack, started per local/README.md:
`docker compose -f docker-compose.yml -f local/docker-compose.override.yml -f local/docker-compose.dev.yml up -d --build`
(`.env` with random secrets and `local/docker-compose.dev.yml` are local, untracked: the dev override adds
CORTEXOS_API_KEY_SCOPES=leorna:*, REQUIRE_SCOPED_AUTH/REQUIRE_CHANNEL_HEADER=true, and remaps postgres host port to 5433
because leorna-pg holds 5432.) Postgres, embedder, control-plane and seaweed come up; the api container exits 101:
```
thread 'main' panicked at crates/cortexos-api/src/deploy_safety.rs:146:35:
migrations: baseline-v2 migration failed: while executing migration 1000000: error returned from database:
relation "public._sqlx_migrations" does not exist at line 429
```
The database was brand new (local/data/postgres was empty; postgres never started on the first attempt because of the port clash).
No existing GitHub issue covers it. Also observed (secondary, cosmetic): artifact-seaweed healthcheck runs `curl`, which isn't in
the chrislusf/seaweedfs:3.80 image, so it reports unhealthy while working.

## What to deliver
Plan file: `~/.hermes/plans/leorna/nocard-cortexos-fresh-db-migration.md` (no ClickUp card yet; Justin is creating one).
- Questions at the top; playback; root cause with file:line evidence and a reproduction (how a fresh DB hits it; whether existing
  deployments with a populated `_sqlx_migrations` are affected; which commit introduced it — use git log/blame).
- Numbered ACs AC1, AC2… marked **proposed**, one named test each; tag `(live)` any only Justin can check. Include an AC that a fresh
  database starts cleanly AND one that an already-migrated database is unaffected.
- Tasks a context-free builder can follow, `## Skills` section, risks, touches. Say whether the seaweed healthcheck belongs in this story
  or a separate one (recommend; don't fold it in silently).

## Boundaries
- You may reproduce with the local CortexOS containers (cortexos-*) and their data in ~/Leorna/cortexos/local/data, or a throwaway
  postgres container you start and remove yourself. NEVER touch other containers: leorna-pg, ndx6-preview-server, ndx6-preview-db.
- Windows desktop memory rule: any cargo build/test runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`
  (or in Docker with a --memory cap), never bare. A command dying with SIGTERM/143/137/"Killed" may be an earlyoom kill: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.
- Rust is not installed on the host; use the repo's Docker build or a rust container.

## Report
Return `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[],
overlaps, found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
