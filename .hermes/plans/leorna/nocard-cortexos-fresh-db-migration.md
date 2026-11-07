# CortexOS: a fresh database fails its first migration (`relation "public._sqlx_migrations" does not exist`)

- **Status:** PROPOSED. Waiting for Justin's **go**. The planner only investigated: no worktree, branch, repo edit, commit, push, issue or ClickUp change.
- **Repo:** LeornaAI/cortexos, `~/Leorna/cortexos`. **Base:** `main` @ `262cf33` (GitHub `main` read back as `262cf334d5ca4991e8886e4c7a4ecc6a6892c89b` on 2026-11-06 19:5x EST via `gh api`; local checkout clean, same SHA). No open PRs at planning time.
- **Card:** none yet (Justin is creating one). Names below use `nocard`; rename on arrival (Q1).
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/nocard-cortexos-fresh-db-migration/` (or `evidence/<card-id>/` if the ID arrives before the build).

## Questions for Justin (a bare "go" takes every ⭐)

1. **ClickUp card ID?** ⭐ Send it when it exists. Until then the branch is `feat/cortexos-fresh-db-migration` and the plan/evidence keep `nocard`; with an ID they become `feat/<id>-fresh-db-migration` and `<id>-cortexos-fresh-db-migration`. (IDs are never guessed.)
2. **Seaweed healthcheck** (secondary report): ⭐ **separate story**, its own card / fold it into this one. Reason: different file and cause, no shared test, and it keeps this review about migrations. Facts for that card are under "Found elsewhere".
3. **AC6, your exact README command:** ⭐ **agent-run**: the verifier may stop your `cortexos-*` containers and run your command from the story worktree, which has its own empty `local/data` (your `.env` and `local/docker-compose.dev.yml` copied in, never committed), then stop that stack. / No: you run it yourself after merge, and AC6 becomes `(live)`.
4. **Experimental packed-v2 installer path** (`prepare_packed_database` with `CORTEXOS_PACKED_IMPLEMENTATION=experimental-v2`, migration.rs:936-1016): ⭐ **leave it unchanged**, follow-up (it is offline-only, blocked by issue #80, and needs its own `make check-packed-v2` DB lane) / pin it here too. The default path (`PackedMode::V1`) goes through `run_migrations` and is fixed either way.
5. **Docker acceptance script** `scripts/ops/test-fresh-db-migration.sh`: ⭐ **commit it** (next to the other `scripts/ops/test-*.sh`; not wired into CI, so no workflow change) / keep it as evidence tooling only.

## Playback

On a brand-new local stack started per `local/README.md`, Postgres, embedder, control-plane and seaweed come up, but `cortexos-api` exits 101 on its first startup migration with `relation "public._sqlx_migrations" does not exist`. Find and prove why, say whether databases that already migrated are affected and which commit introduced it, and plan a fix: a fresh database must start cleanly, and an already-migrated database must be unaffected.

## Root cause (proven)

**In one line:** the Postgres init script creates the Apache AGE graph `cortexos`, which is a schema named `cortexos`, the same name as the migration login role. The default `search_path` (`"$user", public`) therefore puts that schema first, so SQLx's unqualified `_sqlx_migrations` ledger (and the init script's tables) land in `cortexos`, while baseline-v2 hard-codes `public._sqlx_migrations`.

### Mechanism, with evidence

1. `docker-compose.yml:9` sets `POSTGRES_USER: cortexos`, and `:53` migrates as that role (`DATABASE_MIGRATION_URL=postgres://cortexos:…`). `:18` mounts `infra/postgres/init` as `/docker-entrypoint-initdb.d`. The Helm in-chart dev Postgres does the same (`values.yaml` `postgres.auth.username: cortexos`; `templates/postgres-configmap.yaml:13-17` ships `files/postgres/*`, byte-identical to `infra/postgres/init/*`).
2. `infra/postgres/init/01_bootstrap.sql:3-11` runs `ag_catalog.create_graph('cortexos')` (line 8). An AGE graph is a schema, so this creates schema `cortexos`, owned by role `cortexos`. Lines 13+ then run unqualified `CREATE TABLE IF NOT EXISTS memory_spaces …` and seven more tables. These are pre-migration-era DDL that resolve to the first schema on the search path, which is now `cortexos`, not `public`.
3. The live failed stack confirms it (read-only query on `cortexos-postgres`): schemas `ag_catalog(cortexos) cortexos(cortexos) public`; `cortexos` holds `_ag_label_vertex, _ag_label_edge, memory_spaces, memory_objects, memory_events, memory_snapshots, memory_relationships, memory_policies, memory_policy_assignments, memory_artifacts, _sqlx_migrations`; `public` holds nothing; `SHOW search_path` = `"$user", public`.
4. The classifier only looks at `public` (`crates/cortexos-api/src/migration.rs:668` `to_regclass('public._sqlx_migrations')`, `:685` `nspname = 'public'`), so it sees `Blank` and runs the baseline-v2 migrator (`:1034`).
5. SQLx 0.9.0 creates its ledger unqualified: `sqlx-postgres-0.9.0/src/migrate.rs:130` `CREATE TABLE IF NOT EXISTS {table_name}`, default name `_sqlx_migrations` (`sqlx-core-0.9.0/src/migrate/migrator.rs:40`, called at `:247`). It lands in `cortexos._sqlx_migrations`.
6. Baseline-v2 then runs `REVOKE ALL ON public._sqlx_migrations FROM cortexos_runtime;` (`crates/cortexos-api/migrations-v2/1000000_baseline_v2.sql:1182`, inside `IF EXISTS cortexos_runtime`; that role exists because `infra/postgres/init/00_runtime_role.sh` creates it). It fails with 42P01, and `deploy_safety.rs:146` panics.
7. **"at line 429"** is not a line of the SQL file. sqlx-postgres prints PostgreSQL's own source-line field (`src/error.rs:158-163`), and `\set VERBOSITY verbose` gives `ERROR: 42P01 … LOCATION: RangeVarGetRelidExtended, namespace.c:429`.

### Tight reproduction (planner, throwaway `cxrepro-*` containers, all removed)

Real images built today from 262cf33: `cortexos-postgres-age:pg16` and `cortexos-api:0.1.0`, migrate-only (`CORTEXOS_MIGRATE_ONLY=true`), split roles as in compose.

| Run | Layout | Result |
|---|---|---|
| A | AGE image, full `infra/postgres/init`, role `cortexos` (= compose) | run 1 exit 101, **the exact reported panic**; `public` empty, ledger `cortexos._sqlx_migrations` empty |
| D | same init, role `cxadmin` (graph schema ≠ role) | exit 101 `ambiguous database: CortexOS relations exist without _sqlx_migrations`: the bootstrap tables land in `public`, so the init DDL breaks the classifier on its own |
| B | AGE image, only `00_runtime_role.sh` (no bootstrap DDL), role `cortexos` | run 1 **exit 0 but corrupt**: `public._sqlx_migrations`=`1000000`, then the baseline's own `create_graph` makes schema `cortexos`, so `cortexos._sqlx_migrations`=`1000001…1000018` and 4 tables (`memory_entity_aliases, memory_events_archive, memory_objects_cold, memory_snapshots_cold`) and 2 functions (`cortexos_compact_packed_term, cortexos_remove_packed_document`) land in `cortexos`. Run 2 and a normal start: exit 101 `function "cortexos_authenticate_workspace_api_token" already exists` |
| E | B's init, role `cxadmin` | runs 1 and 2 exit 0, everything in `public`, normal start healthy in 2 s (control) |
| A-pin / B-pin | A / B with `?options=-csearch_path%3Dpublic` on the migration URL (simulates the fix's pin) | runs 1 and 2 exit 0, complete ledger in `public`, nothing CortexOS-made outside `public`. A-pin still leaves the init script's 8 orphan tables in `cortexos` |
| L / L-pin | A plus a simulated pre-2026-09-23 compose DB (ledger rows 1-20 and one `memory_spaces` row in `cortexos`) | L: the same reported panic (fails closed by accident). **L-pin: exit 0, starts an empty `public` copy and ignores the old row**, a silent fork. So the pin alone is unsafe and needs a guard |
| Emix | E migrated unpinned, then rerun pinned twice | ledger (version, checksum, installed_on, success), object list and index evidence fingerprints are **identical** across all runs |

### Why CI never caught it

`.github/workflows/ci.yml:29-33` uses plain `pgvector/pgvector:pg16`: no AGE (so the baseline's `create_graph` is skipped and no `cortexos` schema ever exists) and no init scripts. And `scripts/ci/db-gate.py:84-96` migrates *before* it creates `cortexos_runtime`, so the baseline's REVOKE branch never runs on a fresh CI database.

### Who is affected (the brief's question about already-migrated databases)

| Database | Today (262cf33) | After this fix |
|---|---|---|
| Fresh compose / Helm in-chart dev Postgres (AGE + init + role `cortexos`) | fails the first start (this report); nothing was ever migrated | starts cleanly (AC1, AC6) |
| Ledger in `public`, migration role without a same-named schema (CI layout; managed Postgres without AGE; any role name other than `cortexos`) | **not affected** | unchanged byte for byte (AC3; planner pre-check "Emix" already identical) |
| AGE + role `cortexos` + no bootstrap DDL, migrated once since 2026-09-23 (layout B) | split ledger, wrong-schema tables; every later start fails | refused with a message naming the objects; manual repair or recreate. None known |
| Local compose DB created before 2026-09-23 (all data and ledger 1-20 in schema `cortexos`) | fails with this same error | refused with a clear message instead of silently starting an empty `public` copy (AC4) |
| Justin's current `local/data/postgres` (old init ran, migration failed) | broken | refused (old init tables in `cortexos`). Recreate it: README step (Task 5); nothing in it to keep |

### Which commit introduced it

- **120690e** (MNylif, 2026-09-23 06:10 -0700, "feat(db): add baseline-v2 migration preflight") made `public` explicit: the classifier's `public._sqlx_migrations` / `nspname='public'` checks and `1000000_baseline_v2.sql:1182` `REVOKE ALL ON public._sqlx_migrations` (`git blame` attributes all of these lines to it). Before it, `MIGRATOR.run()` with unqualified legacy SQL (`0019` uses `REVOKE ALL ON _sqlx_migrations`) worked, because *everything* consistently lived in the role-named schema.
- **391c4c5** (2026-09-23 02:35, 3.5 h earlier) added `00_runtime_role.sh`, which creates `cortexos_runtime`. That makes the baseline's grant block, and its REVOKE, run in compose.
- The precondition is older: **224857e** (2026-01-06), the first compose, had role `memoryos` and graph `memoryos`; **5f88aaf** (2026-09-10, product rename) kept the collision as `cortexos`/`cortexos`.

## Acceptance criteria (all **proposed**; "go" approves them)

Each AC's check runs on head and on base (`262cf33`). The allowed difference is stated per AC.

- **AC1 (proposed):** Given a brand-new database created exactly like the compose `postgres` service (`cortexos-postgres-age:pg16`, `shared_preload_libraries=age`, the repo's `infra/postgres/init` mounted, role `cortexos`, runtime role `cortexos_app`), when the API runs its startup migrations twice and then starts normally in split mode, then both runs exit 0, the normal start serves `/healthz`, `public._sqlx_migrations` holds exactly the embedded baseline and shared versions (`1000000,1000001,1000002,1000010,1000011,1000012,1000013,1000014,1000018` at base), and no relation or function exists outside `public` other than AGE's own catalog and label tables. **Test:** `scripts/ops/test-fresh-db-migration.sh fresh`. Base: FAIL on run 1 with the reported panic (planner-verified); head: PASS.
- **AC2 (proposed):** Given a fresh database in which a schema named after the migration role already exists, when `migration::run_migrations` runs twice on one pooled connection, then the first returns `Blank` and the second `V2`; the complete catalog is recorded in `public._sqlx_migrations`, and the second run rewrites no ledger row; nothing is created in the role-named schema; and the connection's `search_path` afterwards equals its value before. This runs in CI's DB lane. **Test:** `tests::migration_search_path_db::db_fresh_database_with_role_named_schema_migrates_into_public`. Base: FAIL (expected message is the reported 42P01 once `cortexos_runtime` exists, as in db-gate); head: PASS.
- **AC3 (proposed):** Given databases already migrated by the base build, one in CI's layout (`pgvector/pgvector:pg16`, role `cortexos`, no AGE) and one in a healthy AGE layout (role `cxadmin`), each with a seeded `memory_spaces` row, when the head build runs startup migrations twice and starts normally, then every ledger row (any schema, all columns), the full object list and the md5 of every `public` table's rows are unchanged. The index-evidence table is compared without its `verified_at`, which every start rewrites, base or head. A base-on-base rerun proves the fingerprint is stable. **Test:** `scripts/ops/test-fresh-db-migration.sh upgrade`. Base vs base: PASS (planner-verified: 312 and 673 fingerprint lines); head: PASS. No difference allowed.
- **AC4 (proposed):** Given a database where a non-`public` schema on the migration role's default search path already holds `_sqlx_migrations` or a CortexOS relation (a pre-2026-09-23 local DB, layout B's split ledger, or tables from the old init script), when the API starts, then it refuses before writing anything, with `ambiguous database: CortexOS objects outside schema public are on the migration role's search_path (<schema.object>, …)` naming each object and pointing at `local/README.md`, and creates nothing in `public`. CortexOS names in a schema that is *not* on the search path, and AGE's own label tables, are not refused. **Test:** `tests::migration_search_path_db::db_migrations_refuse_cortexos_objects_in_role_named_schema` (supporting: `db_migrations_ignore_cortexos_names_off_the_search_path`, unit `search_path_shadowing_refusal_names_every_object_and_the_remedy`, and the real-binary `test-fresh-db-migration.sh split` and `stale-init`). Base: FAIL (no such refusal; `split` gives "already exists", planner-verified); head: PASS.
- **AC5 (proposed):** Given `infra/postgres/init/01_bootstrap.sql` and `infra/helm/cortexos/files/postgres/01_bootstrap.sql`, then the two files are byte-identical and their only statements are `CREATE EXTENSION IF NOT EXISTS pgcrypto;` and `CREATE EXTENSION IF NOT EXISTS vector;`: no tables, indexes, policies or AGE graph. **Test:** unit `migration::tests::postgres_init_scripts_create_only_extensions`. Base: FAIL; head: PASS.
- **AC6 (proposed):** Given Justin's README start command (`docker compose -f docker-compose.yml -f local/docker-compose.override.yml -f local/docker-compose.dev.yml up -d`) with his `.env` and dev override on an empty `local/data`, run without `--build`: the story's API image, built under the memory cap in Task 7, is pre-tagged `cortexos-api:0.1.0`, because `--build` would run an uncapped BuildKit cargo build on this desktop. The image's release build is unchanged by this story, since the new `include_str!` is test-only. When the stack comes up, then `cortexos-api` reaches `healthy` and `GET http://127.0.0.1:8080/healthz` returns 200. `artifact-seaweed`'s healthcheck status is out of scope (Q2). **Test:** the AC6 receipt run in Task 10. Base: FAIL (the original report); head: PASS. Agent-run if Q3 = yes; otherwise this AC becomes `(live)`.
- **AC7 (proposed):** Regression: given CI's DB gate (`python3 -B scripts/ci/db-gate.py --provision` against a fresh `pgvector/pgvector:pg16`, role `cortexos`), then it prints `DB gate: PASSED (executed)`, with every base test still passing plus the new ones, 0 failed, 0 ignored and no `skipping` line. **Base tally (planner, 2026-11-06, clean export of 262cf33):** `DB gate: PASSED (executed)`, **380 passed, 0 failed, 0 ignored** (329 in `cortexos-api` unittests, 15 `startup_fail_closed`, 5 `dependency_contracts`, 2 `embedder_deployment_contract`, the rest in the other crates). **Test:** `scripts/ci/db-gate.py --provision`. Head: PASS with 380 + the 6 new tests (3 unit + 3 DB) = 386.

## Approach and choices

1. **Pin the migration session to `public`** (`SET search_path TO public`) at the start of `run_migrations`, after the advisory lock, and `RESET search_path` before unlocking. This covers SQLx's ledger, the baseline's unqualified functions (`1000000_baseline_v2.sql:1286,1338`) and the shared migrations' unqualified `CREATE TABLE` (`1000011:9`, `1000013:11,42,63`), for every caller: split mode, single-URL mode, the Helm migration Job and the DB test helpers.
   - *Rejected: only qualifying SQLx's table name* (`Migrator.table_name = "public._sqlx_migrations"`). Layout B shows that the shared migrations' tables and the baseline's functions would still land in schema `cortexos`.
   - *Rejected: `options=-csearch_path=public` in the compose URLs.* It is deployment-specific, misses Helm and external databases, and is invisible to tests. It remains a documented stop-gap for anyone stuck today.
   - *Rejected: renaming the AGE graph.* The baseline is immutable and already creates `cortexos`.
2. **Guard before the pin** (fail closed, matching the classifier's "ambiguous database" style). Refuse when any schema in `current_schemas(false)` other than `public` holds `_sqlx_migrations` or a `CORTEXOS_RELATIONS` name. Without it, the pin would silently fork pre-2026-09-23 local DBs (run L-pin). The guard is scoped to the search path, so the ops lineage probe's private schemas (`scripts/ops/test-baseline-v2-sqlx-lineages.sh`) never trip it.
3. **Strip the init scripts to extensions only**, both copies. Migrations have owned the schema since 120690e, and the baseline creates the AGE graph itself. Without this the guard would refuse every fresh compose DB (run A-pin's orphans).
4. **Reset, don't leak:** single-URL mode hands the migration connection back to the serving pool, so AC2 asserts the `search_path` is restored.
5. Unchanged: migration SQL (immutable), the classifier's semantics, `bind_packed_runtime_database` (already `public`-qualified), the experimental installer (Q4), CI workflows, `docker-compose.yml`.

## Host prerequisites (checked on this desktop, 2026-11-06)

- Present: Docker Desktop (`docker compose version` v2.40.3-desktop.1), `python3`, `jq`, cached Chrome for Testing 156 (`/home/justin/.cache/chrome-for-testing/chrome-linux64/chrome` with `LD_LIBRARY_PATH=/home/justin/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`). Images present: `rust:1.94.1-trixie@sha256:652612f0…` (the API Dockerfile's builder), `pgvector/pgvector:pg16` (CI's service), `cortexos-postgres-age:pg16`, `koalaman/shellcheck:v0.10.0`, `cortexos-api:0.1.0` (built today from the 262cf33 tree).
- **Missing on the host:** `cargo`/`rustc`, `helm`, `psql`, `shellcheck`. Every Rust and shell gate runs in containers (recipe below), never bare.
- `/tmp` is a RAM-backed tmpfs (9.8 GB). Put build scratch on disk under `~/.hermes/cache/scratch/<job>-<role>/` and Cargo `target`/registry in **owned** docker volumes (`<job>-<role>-target`, `<job>-<role>-cargo`), never in the worktree.
- **Memory rule:** every Rust container gets `--memory 10g --memory-swap 10g --cpus 8 -e CARGO_BUILD_JOBS=4`. Planner timings with these caps: a debug `cargo build --all --all-features` takes about 4 min cold, and a full DB gate about 5 min warm. Treat a 137/143/"Killed" exit as a possible OOM and check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. The `--memory` cap is what bounds a container; give every container one.
- Never touch `leorna-pg`, `ndx6-preview-server` or `ndx6-preview-db`. Name every container, network and volume you create with your job prefix and remove them when done.

### Container gate recipe (adapt names; the planner ran its G3 build and G5 DB gate on 262cf33, and G1/G2/G3/G5 on the planned change, see "Plan validation")

```bash
J=cortexos-fresh-db-builder          # role-owned prefix
WT=<absolute worktree path>
docker network create $J-net
PW=$(openssl rand -hex 16)
docker run -d --name $J-pg --network $J-net --memory 1g -e POSTGRES_DB=cortexos -e POSTGRES_USER=cortexos \
  -e POSTGRES_PASSWORD=$PW pgvector/pgvector:pg16
docker run --rm --name $J-rust --network $J-net --memory 10g --memory-swap 10g --cpus 8 \
  -v "$WT":/src -v $J-target:/src/target -v $J-cargo:/usr/local/cargo/registry \
  -e CARGO_BUILD_JOBS=4 -e CI_POSTGRES_USER=cortexos -e CI_POSTGRES_DB=cortexos -e CI_POSTGRES_PASSWORD=$PW \
  -e CI_POSTGRES_ENDPOINTS=$J-pg:5432 -e CI_DB_ARTIFACT_DIR=/src/artifacts/db -w /src \
  -e HOST_UID=$(id -u) -e HOST_GID=$(id -g) \
  rust:1.94.1-trixie@sha256:652612f07bfbbdfa3af34761c1e435094c00dde4a98036132fca28c7bb2b165c \
  bash -c 'set -o pipefail; mkdir -p /src/artifacts; trap "chown -R \$HOST_UID:\$HOST_GID /src/artifacts" EXIT
    apt-get update -qq && apt-get install -y -qq postgresql-client shellcheck >/dev/null
    rustup component add rustfmt clippy
    cargo fmt --all -- --check;                               echo "G1 fmt EXIT=$?"
    python3 -B scripts/ci/retrieval-cargo.py clippy;          echo "G2 clippy EXIT=$?"
    cargo build --locked --all --all-features;                echo "G3 build EXIT=$?"
    env -u DATABASE_URL -u DATABASE_MIGRATION_URL cargo test --workspace --all-features -- --test-threads=1; echo "G4 tests(no DB) EXIT=$?"
    python3 -B scripts/ci/db-gate.py --provision;             echo "G5 db-gate EXIT=$?"
    bash -n scripts/backup.sh scripts/restore.sh scripts/ci/test-backup-restore-integrity.sh scripts/ops/test-fresh-db-migration.sh \
      && shellcheck scripts/backup.sh scripts/restore.sh scripts/ci/test-backup-restore-integrity.sh scripts/ops/test-fresh-db-migration.sh \
      && bash scripts/ci/test-backup-restore-integrity.sh;    echo "G6 shell EXIT=$?"'
docker rm -f -v $J-pg; docker network rm $J-net
```

`artifacts/` is written inside the worktree by db-gate, as root, which is why the script ends with the `chown` trap (planner hit this: without it the host user gets `Permission denied` deleting it). It is untracked: keep it out of commits (`git status --porcelain` must show only the intended files) and copy the receipts to the evidence folder. Use a fresh `$J-pg` for every G5 run.

## Tasks (builder)

Estimate: 3–4 h of work plus about 40 min of builds and gates. Work test-first (`test-driven-development`); commit in small steps (CortexOS style, e.g. `fix(db): …`; add the card ID to the PR title once it exists). Identity comes from `~/.gitconfig`'s `includeIf` (the repo reports `justin@leorna.com`); never override it, and add no AI attribution lines.

**Task 0: Workspace and baseline (10 min).**
- Re-read GitHub `main` (`gh api repos/LeornaAI/cortexos/commits/main --jq .sha`). If it is no longer `262cf33`, stop and report: the base tally and line numbers here need a refresh.
- Create the story worktree and branch from `262cf33` (Q1 decides the name). Create the evidence folder and `~/.hermes/cache/scratch/<job>-builder/`.
- Re-running the base tally is optional; the planner's is above. For the evidence, build a **base API image** from a clean `git archive 262cf33` with the image recipe in Task 7, tagged `cortexos-api:base-262cf33`. Don't rely on `cortexos-api:0.1.0`: its provenance is "built from the main checkout's tree today", which is not attestable.

**Task 1: RED tests that compile on base (15 min).** All four fail on base code.
- Create `crates/cortexos-api/src/tests/migration_search_path_db.rs` with exactly the appendix's "DB test module" code.
- Register it in `crates/cortexos-api/src/main.rs`'s `mod tests` list, alphabetically after `mod memory_integrity_tests;` (currently line 19437): `    mod migration_search_path_db;`.
- Append this unit test at the end of `crates/cortexos-api/src/migration.rs`'s `#[cfg(test)] mod tests` (just before the module's closing `}`). The `include_str!` paths are relative to `src/migration.rs`. The test lives under `#[cfg(test)]`, so the API Dockerfile's release build (which copies only `crates/`) is unaffected.

```rust
    #[test]
    fn postgres_init_scripts_create_only_extensions() {
        let compose = include_str!("../../../infra/postgres/init/01_bootstrap.sql");
        let helm = include_str!("../../../infra/helm/cortexos/files/postgres/01_bootstrap.sql");
        assert_eq!(
            compose, helm,
            "compose and Helm bootstrap SQL must stay identical"
        );
        let statements: Vec<&str> = compose
            .lines()
            .map(str::trim)
            .filter(|line| !line.is_empty() && !line.starts_with("--"))
            .collect();
        assert_eq!(
            statements,
            [
                "CREATE EXTENSION IF NOT EXISTS pgcrypto;",
                "CREATE EXTENSION IF NOT EXISTS vector;"
            ],
            "the API's migrations own every CortexOS table, policy, index and the AGE graph"
        );
    }
```

- RED: run G5 (the DB gate) and save it as `red-<sha7>.txt`. The expected failures are listed under "Plan validation" below:
  - `db_fresh_database_with_role_named_schema_migrates_into_public` and `db_migrations_ignore_cortexos_names_off_the_search_path`: the reported 42P01 `relation "public._sqlx_migrations" does not exist`.
  - `db_migrations_refuse_cortexos_objects_in_role_named_schema`: no "CortexOS objects outside schema public" refusal.
  - `postgres_init_scripts_create_only_extensions`: the base file's `CREATE TABLE`/`create_graph` statements.
- These DB tests need `DATABASE_MIGRATION_URL` with CREATEDB, as CI's superuser has. Under `make check` (no database) they print the repo's usual `skipping …` line. Under db-gate the variables are set, so they run (db-gate fails on any `skipping` line).

**Task 2: Helpers, test-first (10 min).**
- Append these two unit tests next to the previous one:

```rust
    #[test]
    fn search_path_shadowing_refusal_names_every_object_and_the_remedy() {
        let refusal = search_path_shadowing_decision(&[
            "cortexos._sqlx_migrations".to_string(),
            "cortexos.memory_spaces".to_string(),
        ])
        .unwrap_err();
        assert!(
            refusal.starts_with("ambiguous database: CortexOS objects outside schema public"),
            "{refusal}"
        );
        assert!(
            refusal.contains("(cortexos._sqlx_migrations, cortexos.memory_spaces)"),
            "{refusal}"
        );
        assert!(refusal.contains("local/README.md"), "{refusal}");
        assert_eq!(search_path_shadowing_decision(&[]), Ok(()));
    }

    #[test]
    fn search_path_shadowing_covers_the_ledger_and_every_cortexos_relation() {
        let names = shadowing_relation_names();
        assert_eq!(names.first().map(String::as_str), Some("_sqlx_migrations"));
        assert_eq!(names.len(), CORTEXOS_RELATIONS.len() + 1);
        assert!(CORTEXOS_RELATIONS
            .iter()
            .all(|relation| names.iter().any(|name| name == relation)));
    }
```

- RED: `cargo test -p cortexos-api --all-features search_path_shadowing` fails to compile (`cannot find function search_path_shadowing_decision`).
- GREEN: insert the three functions from the appendix's "Pin and guard helpers" directly above `pub async fn run_migrations` in `migration.rs` (currently line 1018). Rerun: both pass. The DB tests are still RED, because nothing calls the helpers yet.

**Task 3: Wire the pin and the reset into `run_migrations` (5 min).**
- Make the first statement inside `let outcome = async {` be `pin_migration_search_path(&mut connection).await?;`, before `let observation = observe_database(&mut connection).await?;`.
- Replace everything after that block's `.await;` up to the function's closing brace with:

```rust
    // The pin is session state, and a single-URL pool hands this connection to traffic.
    let reset_result = sqlx::query("RESET search_path")
        .execute(&mut *connection)
        .await
        .map_err(|error| format!("migration search_path reset failed: {error}"));
    let unlock_result = sqlx::query("SELECT pg_advisory_unlock($1)")
        .bind(MIGRATION_PREFLIGHT_LOCK_KEY)
        .execute(&mut *connection)
        .await
        .map_err(|error| format!("migration preflight advisory unlock failed: {error}"));

    match (outcome, reset_result, unlock_result) {
        (Err(error), _, _) => Err(error),
        (Ok(_), Err(error), _) | (Ok(_), _, Err(error)) => Err(error),
        (Ok(lineage), Ok(_), Ok(_)) => Ok(lineage),
    }
}
```

- Do not touch `prepare_packed_database`'s experimental branch (Q4). Its `PackedMode::V1` path already calls `run_migrations`.
- GREEN: run G1, G2 and G5. All 3 DB tests and both helper unit tests pass. `postgres_init_scripts_create_only_extensions` stays RED until Task 4.

**Task 4: Init scripts (5 min).** Replace **both** `infra/postgres/init/01_bootstrap.sql` and `infra/helm/cortexos/files/postgres/01_bootstrap.sql` with exactly:

```sql
-- Extensions only. The API's startup migrations (crates/cortexos-api/migrations-v2 and
-- migrations-shared) own every CortexOS table, policy and index and the Apache AGE
-- graph. Creating them here, outside the migration ledger, made the first start fail:
-- the graph's schema is named like the cortexos role, so it captured the tables and
-- SQLx's ledger instead of schema public.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;
```

- Leave `00_runtime_role.sh` and `02_control_plane.sql` unchanged.
- `postgres_init_scripts_create_only_extensions` goes GREEN; confirm with `cmp` of the two files.

**Task 5: Docs (10 min).**
- `local/README.md`: after "## Stop", add:

````markdown
## Starting over after a failed first start

Databases first started before the fix for `relation "public._sqlx_migrations" does
not exist` have CortexOS tables in a schema named `cortexos`, created by the old init
script. The API now refuses them with "CortexOS objects outside schema public are on
the migration role's search_path". A local database is disposable: stop the stack and
delete its data folder (owned by the container's postgres user, so delete it from a
container). This deletes the local database.

```bash
docker compose -f docker-compose.yml -f local/docker-compose.override.yml down
docker run --rm -v "$PWD/local/data:/data" alpine:3.20 rm -rf /data/postgres
```
````

- `docs/deployment-k8s.md:164`: replace "to create the CortexOS schema and the control plane database." with "to create the runtime role, the extensions and the control plane database; the API's startup migrations (or the migration Job) create the CortexOS schema."

**Task 6: Acceptance script (10 min).**
- Create `scripts/ops/test-fresh-db-migration.sh` (mode 0755) with exactly the appendix's "Docker acceptance script". The planner already ran `bash -n` and `shellcheck` v0.10.0 on it (clean) and validated the modes against the base image: `fresh` FAIL with the reported panic, `upgrade` (base vs base) PASS, `split` FAIL "already exists".
- G6 in the recipe already runs `bash -n` and `shellcheck` on it. Don't edit the Makefile's `check-shell` (it lists the CI-run scripts only).

**Task 7: Images (≈ 25 min of builds).**
- **PG:** `cortexos-postgres-age:pg16` exists. If missing, run `docker build -t cortexos-postgres-age:pg16 infra/postgres` (no cargo).
- **API, capped:** for each of head (the worktree) and base (a clean `git archive 262cf33` under scratch):

```bash
docker run --rm --memory 10g --memory-swap 10g --cpus 8 -e CARGO_BUILD_JOBS=4 \
  -v <src>:/src -v $J-reltarget:/src/target -v $J-cargo:/usr/local/cargo/registry -w /src \
  rust:1.94.1-trixie@sha256:652612f07bfbbdfa3af34761c1e435094c00dde4a98036132fca28c7bb2b165c \
  -e HOST_UID=$(id -u) -e HOST_GID=$(id -g) \
  bash -c 'cargo build -p cortexos-api --release --locked && install -D -m 0755 target/release/cortexos-api /src/.image/cortexos-api && chown -R "$HOST_UID:$HOST_GID" /src/.image'
```

  Then package `<src>/.image/` with a Dockerfile identical to `infra/api/Dockerfile`'s runtime stage (`FROM docker.io/debian:trixie-slim@sha256:a99cfc517144bc59b1978475ec53b46ecabec7e43635402ee5b77cc54cd1b20a`, the same apt line, `COPY cortexos-api /usr/local/bin/`, `USER 10001:10001`, `CMD ["cortexos-api"]`).
  - Tag `cortexos-api:story-<sha7>` and `cortexos-api:base-262cf33`, and record `docker image inspect --format '{{.Id}}'` and the binary's sha256 for both.
  - Use a separate `.image/` under scratch for base. In the worktree, `.image/` must stay untracked and be deleted afterwards.
  - Don't use plain `docker compose build api` for these: BuildKit cannot be memory-capped here.

**Task 8: Acceptance runs (≈ 15 min).** From the worktree, each with `2>&1 | tee <evidence>/acN-…-<sha7>.log; echo "EXIT=${PIPESTATUS[0]}"`:
- `API_IMAGE=cortexos-api:story-<sha7> scripts/ops/test-fresh-db-migration.sh fresh` (AC1)
- `API_IMAGE=… BASE_API_IMAGE=cortexos-api:base-262cf33 scripts/ops/test-fresh-db-migration.sh upgrade` (AC3)
- `… split` and `BASE_REF=262cf33 … stale-init` (AC4)
- The base column of each: `fresh` with `API_IMAGE=cortexos-api:base-262cf33` (expect FAIL), and the same for `split`/`stale-init` (expect FAIL).

**Task 9: Falsification (`mutation-testing-discipline`, 20 min).** Each mutant is a temporary edit, re-run under the container caps, then restored with `git checkout -- <file>`:
- M1: delete the `pin_migration_search_path(&mut connection).await?;` line. AC2's DB test must fail.
- M2: inside `pin_migration_search_path`, delete `search_path_shadowing_decision(&shadowing)?;`. AC4's DB test must fail.
- M3: delete the `RESET search_path` query (use `let reset_result: Result<(), String> = Ok(());`). AC2's search_path assertion must fail.
- M4: change `AND namespace.nspname <> 'public'` to `AND namespace.nspname <> 'public_x'`. AC2's second-run assertion must fail, because the guard would then refuse every migrated database's own `public`.
- Record the outcome per mutant ID in `mutations-<sha7>.txt` and restore the tree; `git diff --stat` must be clean afterwards.

**Task 10: AC6 (15 min, only if Q3 = yes).**
- `docker compose … down` in `~/Leorna/cortexos` (Justin's stack; never `-v`).
- Copy `~/Leorna/cortexos/.env` and `local/docker-compose.dev.yml` into the worktree. Both are untracked and ignored: `.env` by `.gitignore`, the dev file by the shared `.git/info/exclude`.
- Record `docker image inspect -f '{{.Id}}' cortexos-api:0.1.0` (Justin's current image), then `docker tag cortexos-api:story-<sha7> cortexos-api:0.1.0`.
- Run Justin's command without `--build` in the worktree, wait up to 5 min for `docker inspect -f '{{.State.Health.Status}}' cortexos-api` = `healthy`, and `curl -fsS http://127.0.0.1:8080/healthz`. Capture `docker compose ps` and the api log tail.
- Then `docker compose … down` in the worktree and re-tag Justin's recorded image ID back to `cortexos-api:0.1.0`. Delete the copied `.env` and dev file and the worktree's `local/data/*` (from a container), and tell the main session that Justin's own stack is stopped. Don't restart it on old `main`.
- If Q3 = no, skip this and mark AC6 `(live)` owed to Justin.

**Task 11: Evidence (20 min).** One PNG per AC, rendered from the real log of its run (command line, output, `EXIT=` line); nothing staged. Set `SCR=~/.hermes/cache/scratch/<job>-builder` (on disk) first:

```bash
render() { # <log> <png> <title>
  local html="$SCR/$(basename "$2" .png).html" lines; lines=$(wc -l < "$1")
  { printf '<!doctype html><meta charset="utf-8"><title>%s</title><style>body{background:#101418;color:#e6e6e6;font:13px/1.4 ui-monospace,monospace;margin:16px}h1{font-size:14px;color:#9cdcfe}</style><h1>%s</h1><pre>' "$3" "$3"
    sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$1"; printf '</pre>'; } > "$html"
  LD_LIBRARY_PATH=/home/justin/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu \
    /home/justin/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu \
    --user-data-dir="$SCR/chrome-profile" --hide-scrollbars --window-size=1500,$(( lines * 19 + 90 )) \
    --screenshot="$2" "file://$html"
  [ "$(head -c 4 "$2" | od -An -tx1 | tr -d ' ')" = 89504e47 ] || echo "NOT A PNG: $2"
}
```

- Files: `ac1-fresh-start.png`, `ac2-db-test.png` (the db-gate log lines for the named test plus the gate summary), `ac3-upgrade.png`, `ac4-refusal.png`, `ac5-init-scripts.png`, `ac6-local-compose.png`, `ac7-db-gate.png`, plus `gates-<sha7>.txt` and the base logs `acN-base-262cf33.log`.
- Open every log before citing it, and read its `EXIT=`.
- Check that no password or DSN appears: the script never prints its random secrets, and db-gate scrubs DSNs, but grep the logs for `postgres://` and `PASSWORD=` before capture.

**Task 12: Gates on the exact head, then stop (20 min).**
- Run G1–G6 once more on the final head SHA and save the output as `gates-<sha7>.txt`.
- `git status --porcelain` must list only the intended files. Remove `artifacts/` and `.image/` from the worktree.
- `git diff --stat 262cf33...HEAD` must show only the touched files below, and `git diff --name-only 262cf33...HEAD -- .github` must be empty.
- Stop at **ready-for-review** with a report: head SHA, per-AC result table (head and base), gate exits, mutant outcomes and evidence paths.

## Evidence map

| AC | Real state shown | Capture point | Artifact |
|---|---|---|---|
| AC1 | `fresh` PASS lines: two exit-0 runs, healthy, ledger, nothing stray; base FAIL with the panic | Task 8 | `ac1-fresh-start.png`, `ac1-fresh-<sha7>.log`, `ac1-fresh-base-262cf33.log` |
| AC2 | `test … db_fresh_database_with_role_named_schema_migrates_into_public ... ok` in the db-gate log; RED line from Task 1 | Tasks 1, 12 | `ac2-db-test.png`, `red-<sha7>.txt`, `dbgate-<sha7>.log` |
| AC3 | `upgrade` PASS per layout with fingerprint line counts | Task 8 | `ac3-upgrade.png`, `ac3-upgrade-<sha7>.log` |
| AC4 | refusal text naming `cortexos._sqlx_migrations` / `cortexos.memory_spaces`, "refused start wrote nothing", the DB test `ok` | Tasks 8, 12 | `ac4-refusal.png`, `ac4-split-<sha7>.log`, `ac4-stale-init-<sha7>.log` |
| AC5 | the unit test `ok` and `cmp` of the two files | Task 12 | `ac5-init-scripts.png` |
| AC6 | `docker compose ps` with `cortexos-api … (healthy)` and the `/healthz` 200 | Task 10 | `ac6-local-compose.png`, `ac6-local-compose-<sha7>.log` |
| AC7 | `DB gate: PASSED (executed)` and the tally, next to the base tally | Task 12 | `ac7-db-gate.png`, `gates-<sha7>.txt` |

## Skills

- **Builder:** `leorna` (roles, evidence, hand-over; skip its Step 1 load, which this plan carries), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the guard is a data-integrity guard), `backend-data-migrations`; `systematic-debugging` if anything fails unexpectedly.
- **Reviewers:** `requesting-code-review`, `code-review-practice`, `backend-data-migrations`, `security-best-practices` (fail-closed guard, no auth/RLS change).
- **Fixers:** `receiving-code-review`, `test-driven-development`.
- **Verifier and auditor:** per `feature-dispatch/references/ac-verification.md`, with this plan's container recipe and memory caps.

## Risks

1. **The session pin leaks into a serving connection** (single-URL mode). Mitigation: `RESET search_path` on every path, asserted by AC2 and killed by mutant M3.
2. **Guard false-refusal.** It only considers schemas in the role's effective search path (`current_schemas(false)`), and only the ledger name plus `CORTEXOS_RELATIONS`. AGE label tables and private probe schemas pass (control test, AC4). A layout that intentionally keeps CortexOS tables in a role-named schema could not work since 120690e anyway.
3. **Justin's existing `local/data/postgres` will be refused after merge** (old init tables). The README recovery step covers it, and the hand-over must tell him.
4. **Layout-B databases** (split ledger) are refused, not repaired. Repair is manual and out of scope; none are known (they need AGE, role `cortexos` and no init DDL).
5. **CI still has no AGE lane.** The compose path is proven only by the Docker script (not in CI). List this under the PR's Assumptions; an AGE CI lane is a follow-up needing an explicit CI exception.
6. **Scratch-database tests need CREATEDB.** CI has it. A `check-db` run with a non-CREATEDB admin fails loudly (by design: db-gate forbids skips).
7. **A sibling changes `migration.rs` or the init scripts first.** No open PRs today; issue #80 (packed-v2) is near `prepare_packed_database`, which this story leaves alone.

## Touches

- `crates/cortexos-api/src/migration.rs`: 3 helpers, `run_migrations` pin/reset/match, 3 unit tests.
- `crates/cortexos-api/src/tests/migration_search_path_db.rs` (new): 3 DB tests.
- `crates/cortexos-api/src/main.rs`: one `mod` line in `mod tests`.
- `infra/postgres/init/01_bootstrap.sql` and `infra/helm/cortexos/files/postgres/01_bootstrap.sql`: extensions only.
- `scripts/ops/test-fresh-db-migration.sh` (new, if Q5 = yes).
- `local/README.md` and `docs/deployment-k8s.md`: docs.
- **Not touched:** migration SQL (immutable), `.github/`, `.forgejo/`, `docker-compose.yml`, `Cargo.toml`/`Cargo.lock`, the control-plane crate. The control-plane's own `_sqlx_migrations` lives in database `cortexos_control_plane`, which has no AGE graph; the container is healthy today.

## Found elsewhere (not in this story)

- **Seaweed healthcheck (Q2, recommend its own card):** `docker-compose.yml:118` runs `curl -fsS http://localhost:8888/`, but `chrislusf/seaweedfs:3.80` is Alpine without curl (health log: exit 127 `/bin/sh: curl: not found`). Busybox `wget` exists, but `localhost` resolves to `::1` first and SeaweedFS listens on IPv4 only ("Connection refused"); `wget -q -O /dev/null http://127.0.0.1:8888/` succeeds. Proposed check: `["CMD-SHELL", "wget -q -O /dev/null http://127.0.0.1:8888/ || exit 1"]`. Present since the first compose file (224857e, 2026-01-06; the image tag is from the same commit). Nothing depends on that health status (no `condition: service_healthy` on seaweed).
- **Baseline session settings persist (P3):** baseline-v2's pg_dump header (`SET statement_timeout = 0; … SET row_security = off;`, lines 15-23) runs inside SQLx's transaction and so persists on the migration connection; in single-URL mode that connection then serves traffic. Local-only mode, superuser, low impact; `RESET search_path` here doesn't change it.
- **`CORTEXOS_RELATIONS` is incomplete (P3):** it omits tables added by shared migrations (`memory_entity_aliases` is listed, but `memory_objects_cold`, `memory_snapshots_cold` and `memory_events_archive` are not). The classifier is unaffected today because the baseline tables are always present alongside.
- **An intermittent DB test (P3, unrelated):** `tests::embedding_backfill::automatic_worker_recovers_after_process_restart` timed out once in 5 planner DB-gate runs, and two `embedding_backfill` tests after it failed on the jobs it left queued. Worth its own look if it recurs in CI.
- **The stop-gap for anyone stuck before this lands:** append `?options=-csearch_path%3Dpublic` to `DATABASE_MIGRATION_URL`. The API then starts (run A-pin), but the old init's 8 orphan tables stay in schema `cortexos`, so once this fix lands that database is refused and must be recreated (README step).

## Appendix: code

### Pin and guard helpers (insert above `pub async fn run_migrations`)

```rust
/// SQLx creates and reads its ledger as unqualified `_sqlx_migrations`, and the shared
/// migrations use unqualified DDL, so both follow the session search_path. Its default,
/// `"$user", public`, puts a schema named after the migration role first: with the
/// compose/Helm role `cortexos`, that is the Apache AGE graph schema `cortexos` (created
/// by the baseline, or before it by an old init script). Pin the session to `public`, the
/// only schema the baseline, the classifier and the runtime use. Refuse first when an
/// earlier unpinned start or an old init script already put CortexOS objects in a schema
/// the default search_path reaches: pinning would hide them behind a second, empty copy.
async fn pin_migration_search_path(connection: &mut PgConnection) -> Result<(), String> {
    let shadowing = sqlx::query_scalar::<_, String>(
        r#"
        SELECT pg_catalog.format('%I.%I', namespace.nspname, relation.relname)
        FROM pg_catalog.pg_class AS relation
        JOIN pg_catalog.pg_namespace AS namespace ON namespace.oid = relation.relnamespace
        WHERE namespace.nspname = ANY (pg_catalog.current_schemas(false))
          AND namespace.nspname <> 'public'
          AND relation.relname = ANY($1::text[])
          AND relation.relkind IN ('r', 'p', 'v', 'm', 'S')
        ORDER BY 1
        "#,
    )
    .bind(shadowing_relation_names())
    .fetch_all(&mut *connection)
    .await
    .map_err(|error| format!("migration preflight could not inspect the search_path: {error}"))?;
    search_path_shadowing_decision(&shadowing)?;
    sqlx::query("SET search_path TO public")
        .execute(&mut *connection)
        .await
        .map_err(|error| format!("migration search_path pin failed: {error}"))?;
    Ok(())
}

/// The ledger plus every relation the classifier treats as CortexOS-owned.
fn shadowing_relation_names() -> Vec<String> {
    std::iter::once("_sqlx_migrations")
        .chain(CORTEXOS_RELATIONS.iter().copied())
        .map(str::to_string)
        .collect()
}

fn search_path_shadowing_decision(found: &[String]) -> Result<(), String> {
    if found.is_empty() {
        return Ok(());
    }
    Err(format!(
        "ambiguous database: CortexOS objects outside schema public are on the migration \
         role's search_path ({}); CortexOS migrates only schema public and will not start a \
         second, empty copy. Move or drop them in a maintenance window, or recreate a \
         disposable local database (local/README.md)",
        found.join(", ")
    ))
}
```

### DB test module (`crates/cortexos-api/src/tests/migration_search_path_db.rs`)

```rust
//! Startup migrations on a fresh database whose migration role has a same-named schema.
//! Apache AGE's graph `cortexos` is such a schema for the compose and Helm default role
//! `cortexos`. Before the fix SQLx put its ledger there and the first start failed with
//! `relation "public._sqlx_migrations" does not exist`. Each test owns a throwaway
//! database, so a role-named schema never reaches the shared test database.
use super::*;

const ROLE_SCHEMA: &str = "DO $$ BEGIN EXECUTE format('CREATE SCHEMA %I', current_user); END $$";

struct Scratch {
    admin: PgPool,
    name: String,
    pool: PgPool,
}

async fn scratch(label: &str) -> Option<Scratch> {
    let Ok(admin_url) = std::env::var("DATABASE_MIGRATION_URL") else {
        eprintln!("skipping {label}: DATABASE_MIGRATION_URL not set");
        return None;
    };
    let admin = PgPoolOptions::new()
        .max_connections(1)
        .connect(&admin_url)
        .await
        .expect("migration server");
    let name = format!("cortexos_search_path_{}", Uuid::new_v4().simple());
    sqlx::query(sqlx::AssertSqlSafe(format!("CREATE DATABASE \"{name}\"")))
        .execute(&admin)
        .await
        .expect("scratch database: DATABASE_MIGRATION_URL needs CREATEDB, as CI's superuser has");
    let options: sqlx::postgres::PgConnectOptions = admin_url.parse().expect("migration URL");
    let pool = PgPoolOptions::new()
        .max_connections(1)
        .connect_with(options.database(&name))
        .await
        .expect("scratch database connection");
    Some(Scratch { admin, name, pool })
}

impl Scratch {
    async fn exec(&self, sql: &str) {
        sqlx::raw_sql(sqlx::AssertSqlSafe(sql))
            .execute(&self.pool)
            .await
            .unwrap_or_else(|error| panic!("{sql}: {error}"));
    }

    async fn text(&self, sql: &'static str) -> String {
        sqlx::query_scalar::<_, String>(sql)
            .fetch_one(&self.pool)
            .await
            .unwrap_or_else(|error| panic!("{sql}: {error}"))
    }

    /// Every public ledger row as stored, so a rewrite of any column shows.
    async fn ledger(&self) -> Vec<(i64, Vec<u8>, bool, String, i64)> {
        sqlx::query_as(
            "SELECT version, checksum, success, installed_on::text, execution_time \
             FROM public._sqlx_migrations ORDER BY version",
        )
        .fetch_all(&self.pool)
        .await
        .expect("public._sqlx_migrations")
    }

    /// Relations and functions in the schema named after the migration role.
    async fn role_schema_objects(&self) -> Vec<String> {
        sqlx::query_scalar::<_, String>(
            "SELECT c.relname::text FROM pg_catalog.pg_class AS c \
               JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace \
              WHERE n.nspname = current_user \
             UNION ALL \
             SELECT p.proname::text || '()' FROM pg_catalog.pg_proc AS p \
               JOIN pg_catalog.pg_namespace AS n ON n.oid = p.pronamespace \
              WHERE n.nspname = current_user \
             ORDER BY 1",
        )
        .fetch_all(&self.pool)
        .await
        .expect("role schema objects")
    }

    async fn drop(self) {
        self.pool.close().await;
        sqlx::query(sqlx::AssertSqlSafe(format!(
            "DROP DATABASE IF EXISTS \"{}\" WITH (FORCE)",
            self.name
        )))
        .execute(&self.admin)
        .await
        .expect("drop scratch database");
        self.admin.close().await;
    }
}

fn complete_catalog() -> Vec<i64> {
    let catalog = migration::embedded_catalog();
    catalog
        .baseline
        .keys()
        .chain(catalog.shared.keys())
        .copied()
        .collect()
}

/// AC2: the compose/Helm first start, with the AGE graph schema simulated.
#[tokio::test]
async fn db_fresh_database_with_role_named_schema_migrates_into_public() {
    let Some(db) = scratch("db_fresh_database_with_role_named_schema_migrates_into_public").await
    else {
        return;
    };
    db.exec(ROLE_SCHEMA).await;
    let search_path = db.text("SELECT current_setting('search_path')").await;

    assert_eq!(
        migration::run_migrations(&db.pool).await,
        Ok(migration::DatabaseLineage::Blank),
        "first start on a fresh database"
    );
    let ledger = db.ledger().await;
    assert_eq!(
        ledger.iter().map(|row| row.0).collect::<Vec<_>>(),
        complete_catalog(),
        "the complete catalog is recorded in public._sqlx_migrations"
    );
    assert_eq!(
        db.role_schema_objects().await,
        Vec::<String>::new(),
        "nothing is created in the role-named schema"
    );
    assert_eq!(
        db.text("SELECT current_setting('search_path')").await,
        search_path,
        "the pin does not outlive run_migrations on a pooled connection"
    );

    assert_eq!(
        migration::run_migrations(&db.pool).await,
        Ok(migration::DatabaseLineage::V2),
        "second start on the same database"
    );
    assert_eq!(
        db.ledger().await,
        ledger,
        "the second start rewrites no ledger row"
    );
    assert_eq!(db.role_schema_objects().await, Vec::<String>::new());
    db.drop().await;
}

/// AC4: a pre-baseline local compose database (old init tables and an unpinned SQLx
/// ledger in the role-named schema) is refused before anything is written to public.
#[tokio::test]
async fn db_migrations_refuse_cortexos_objects_in_role_named_schema() {
    let Some(db) = scratch("db_migrations_refuse_cortexos_objects_in_role_named_schema").await
    else {
        return;
    };
    db.exec(ROLE_SCHEMA).await;
    db.exec(
        r#"DO $$ BEGIN
          EXECUTE format('CREATE TABLE %I._sqlx_migrations (version bigint PRIMARY KEY, description text NOT NULL, installed_on timestamptz NOT NULL DEFAULT now(), success boolean NOT NULL, checksum bytea NOT NULL, execution_time bigint NOT NULL)', current_user);
          EXECUTE format('INSERT INTO %I._sqlx_migrations VALUES (1, ''init'', now(), true, ''\x00'', 0)', current_user);
          EXECUTE format('CREATE TABLE %I.memory_spaces (id uuid PRIMARY KEY)', current_user);
        END $$"#,
    )
    .await;
    let role = db.text("SELECT current_user::text").await;

    let refusal = migration::run_migrations(&db.pool)
        .await
        .expect_err("CortexOS objects on the role's search_path must be refused");
    assert!(
        refusal.contains("CortexOS objects outside schema public"),
        "{refusal}"
    );
    for object in ["_sqlx_migrations", "memory_spaces"] {
        assert!(refusal.contains(&format!("{role}.{object}")), "{refusal}");
    }
    assert_eq!(
        db.text(
            "SELECT (to_regclass('public._sqlx_migrations') IS NULL \
                 AND to_regclass('public.memory_objects') IS NULL)::text"
        )
        .await,
        "true",
        "a refused start creates nothing in public"
    );
    db.drop().await;
}

/// AC4 control: CortexOS names off the search_path (the ops lineage probe's schemas)
/// and AGE's own label tables in the role-named schema are not refused.
#[tokio::test]
async fn db_migrations_ignore_cortexos_names_off_the_search_path() {
    let Some(db) = scratch("db_migrations_ignore_cortexos_names_off_the_search_path").await else {
        return;
    };
    db.exec(
        "CREATE SCHEMA lineage_probe; \
         CREATE TABLE lineage_probe._sqlx_migrations (version bigint PRIMARY KEY); \
         CREATE TABLE lineage_probe.memory_spaces (id uuid)",
    )
    .await;
    db.exec(ROLE_SCHEMA).await;
    db.exec(
        "DO $$ BEGIN EXECUTE format('CREATE TABLE %I._ag_label_vertex (id bigint)', current_user); END $$",
    )
    .await;
    assert_eq!(
        migration::run_migrations(&db.pool).await,
        Ok(migration::DatabaseLineage::Blank)
    );
    db.drop().await;
}
```

### Docker acceptance script (`scripts/ops/test-fresh-db-migration.sh`)

```bash
#!/usr/bin/env bash
# Real-binary migration checks for the compose/Helm Postgres layouts that CI's plain
# pgvector service cannot reproduce (Apache AGE graph schema named after the role).
#
#   API_IMAGE=<candidate api image> [BASE_API_IMAGE=<base api image>] \
#     scripts/ops/test-fresh-db-migration.sh fresh|upgrade|split|stale-init
#
#   fresh       a brand-new database initialised exactly like the compose postgres
#               service starts: migrate-only twice, then a normal start reaches /healthz.
#   upgrade     databases migrated by BASE_API_IMAGE (CI layout, healthy AGE layout)
#               are byte-identical after API_IMAGE starts on them.
#   split       a database left half-migrated across two schemas by BASE_API_IMAGE is
#               refused by API_IMAGE, which writes nothing.
#   stale-init  a database initialised by the pre-fix 01_bootstrap.sql (BASE_REF) is
#               refused by API_IMAGE, which writes nothing.
#
# Needs Docker only. Creates containers and a network named cortexos-dbtest-<pid>-*
# and removes them on exit. PG_AGE_IMAGE defaults to cortexos-postgres-age:pg16
# (docker compose build postgres); PG_PLAIN_IMAGE to CI's pgvector/pgvector:pg16.
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MODE="${1:-}"
: "${API_IMAGE:?API_IMAGE must name the candidate cortexos-api image}"
PG_AGE_IMAGE="${PG_AGE_IMAGE:-cortexos-postgres-age:pg16}"
PG_PLAIN_IMAGE="${PG_PLAIN_IMAGE:-pgvector/pgvector:pg16}"
PREFIX="cortexos-dbtest-$$"
NET="${PREFIX}-net"
WORK="$(mktemp -d)"
FAILED=0

cleanup() {
  local ids
  ids="$(docker ps -aq --filter "name=^${PREFIX}-" || true)"
  if [[ -n "${ids}" ]]; then
    # shellcheck disable=SC2086 # word splitting of container ids is intended
    docker rm -f -v ${ids} >/dev/null 2>&1 || true
  fi
  docker network rm "${NET}" >/dev/null 2>&1 || true
  rm -rf "${WORK}"
}
trap cleanup EXIT

pass() { printf 'PASS %s\n' "$*"; }
fail() { printf 'FAIL %s\n' "$*"; FAILED=1; }

secret() { od -An -N16 -tx1 /dev/urandom | tr -d ' \n'; }

docker network create "${NET}" >/dev/null

# start_pg <name> <image> <admin role> <init dir>
start_pg() {
  local name="$1" image="$2" admin="$3" init="$4" password runtime_password
  password="$(secret)"; runtime_password="$(secret)"
  printf '%s %s\n' "${password}" "${runtime_password}" > "${WORK}/${name}.secrets"
  local args=(-d --name "${PREFIX}-${name}" --network "${NET}" --memory 1g
    -e "POSTGRES_USER=${admin}" -e "POSTGRES_PASSWORD=${password}" -e POSTGRES_DB=cortexos
    -e POSTGRES_RUNTIME_USER=cortexos_app -e "POSTGRES_RUNTIME_PASSWORD=${runtime_password}"
    -v "${init}:/docker-entrypoint-initdb.d:ro")
  if [[ "${image}" == "${PG_AGE_IMAGE}" ]]; then
    docker run "${args[@]}" "${image}" postgres -c shared_preload_libraries=age >/dev/null
  else
    docker run "${args[@]}" "${image}" >/dev/null
  fi
  local _
  for _ in $(seq 1 120); do
    if docker logs "${PREFIX}-${name}" 2>&1 | grep -q 'PostgreSQL init process complete' \
      && docker exec "${PREFIX}-${name}" pg_isready -q -h 127.0.0.1 -U "${admin}" -d cortexos; then
      return 0
    fi
    sleep 1
  done
  docker logs "${PREFIX}-${name}" 2>&1 | tail -5
  return 1
}

# sql <pg name> <admin role> <query>: tuples only, unaligned
sql() {
  docker exec -i "${PREFIX}-$1" psql -X -A -t -v ON_ERROR_STOP=1 -U "$2" -d cortexos -c "$3"
}

# api <pg name> <admin role> <image> migrate|serve <log name>; returns 0 on success
api() {
  local pg="$1" admin="$2" image="$3" how="$4" log="${WORK}/$5.log" password runtime_password
  read -r password runtime_password < "${WORK}/${pg}.secrets"
  local envs=(-e CORTEXOS_ENV=local -e CORTEXOS_BIND_ADDR=0.0.0.0:8080 -e "CORTEXOS_API_KEY=$(secret)"
    -e "DATABASE_MIGRATION_URL=postgres://${admin}:${password}@${PREFIX}-${pg}:5432/cortexos"
    -e "DATABASE_URL=postgres://cortexos_app:${runtime_password}@${PREFIX}-${pg}:5432/cortexos"
    -e OBJECT_STORE_ENDPOINT=http://artifact-seaweed.invalid:8333 -e OBJECT_STORE_BUCKET=cortexos-artifacts
    -e OBJECT_STORE_REGION=local -e OBJECT_STORE_ACCESS_KEY=dbtest -e OBJECT_STORE_SECRET_KEY=dbtest
    -e CORTEXOS_EMBEDDING_BACKEND=hash -e CORTEXOS_EMBEDDING_DIM=384 -e NO_COLOR=1)
  if [[ "${how}" == migrate ]]; then
    docker run --rm --name "${PREFIX}-api" --network "${NET}" --memory 1g "${envs[@]}" \
      -e CORTEXOS_MIGRATE_ONLY=true "${image}" > "${log}" 2>&1
    return $?
  fi
  docker run -d --name "${PREFIX}-api" --network "${NET}" --memory 1g "${envs[@]}" "${image}" >/dev/null
  local _ status=1
  for _ in $(seq 1 60); do
    if ! docker ps -q --filter "name=^${PREFIX}-api$" | grep -q .; then break; fi
    if docker exec "${PREFIX}-api" curl -fsS http://127.0.0.1:8080/healthz >/dev/null 2>&1; then
      status=0; break
    fi
    sleep 1
  done
  docker logs "${PREFIX}-api" > "${log}" 2>&1 || true
  docker rm -f -v "${PREFIX}-api" >/dev/null 2>&1 || true
  return "${status}"
}

last_error() {
  sed "s/$(printf '\033')\\[[0-9;]*m//g" "${WORK}/$1.log" | grep -aE 'panicked|migrations:|refusing' | tail -1 || true
}

expected_versions() {
  local file
  for file in "${ROOT}"/crates/cortexos-api/migrations-v2/*.sql "${ROOT}"/crates/cortexos-api/migrations-shared/*.sql; do
    file="${file##*/}"; printf '%s\n' "${file%%_*}"
  done | sed 's/^0*//' | sort -n | paste -sd, -
}

public_versions() {
  sql "$1" "$2" "SELECT coalesce(string_agg(version::text, ',' ORDER BY version), '') FROM public._sqlx_migrations"
}

# Relations and functions outside public and the system/AGE catalogs; the AGE graph's
# own label tables are expected and excluded.
stray_objects() {
  sql "$1" "$2" "
    SELECT coalesce(string_agg(name, ', ' ORDER BY name), '') FROM (
      SELECT format('%I.%I', n.nspname, c.relname) AS name
      FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE c.relkind IN ('r', 'p', 'v', 'm')
        AND n.nspname NOT IN ('public', 'pg_catalog', 'information_schema', 'pg_toast', 'ag_catalog')
        AND c.relname NOT LIKE '\\_ag\\_label\\_%'
      UNION ALL
      SELECT format('%I.%I()', n.nspname, p.proname)
      FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
      WHERE n.nspname NOT IN ('public', 'pg_catalog', 'information_schema', 'ag_catalog')
    ) stray"
}

# Every ledger row (any schema), every object name, and the md5 of every public table's
# rows. The index-evidence table's verified_at is rewritten by every start, base or
# candidate, so only its identifying columns are compared.
fingerprint() {
  local pg="$1" admin="$2" table
  sql "${pg}" "${admin}" "
    SELECT n.nspname || '.' || c.relname || ':' || c.relkind::text
    FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    UNION ALL
    SELECT n.nspname || '.' || p.proname || '()' FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
    ORDER BY 1"
  for table in $(sql "${pg}" "${admin}" "
      SELECT format('%I.%I', n.nspname, c.relname) FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE c.relname = '_sqlx_migrations' OR (n.nspname = 'public' AND c.relkind IN ('r', 'p'))
      ORDER BY 1"); do
    if [[ "${table}" == public.cortexos_operational_index_evidence ]]; then
      printf '%s %s\n' "${table}" "$(sql "${pg}" "${admin}" "SELECT md5(coalesce(string_agg(concat_ws('|', manifest_version, schema_name, index_name, definition_sha256), ',' ORDER BY index_name), '')) FROM ${table}")"
    else
      printf '%s %s\n' "${table}" "$(sql "${pg}" "${admin}" "SELECT md5(coalesce(string_agg(t::text, ',' ORDER BY t::text), '')) FROM ${table} AS t")"
    fi
  done
}

role_only_init() {
  mkdir -p "${WORK}/init-role"
  cp "${ROOT}/infra/postgres/init/00_runtime_role.sh" "${WORK}/init-role/"
  printf '%s\n' "${WORK}/init-role"
}

mode_fresh() {
  start_pg fresh "${PG_AGE_IMAGE}" cortexos "${ROOT}/infra/postgres/init"
  local run
  for run in 1 2; do
    if api fresh cortexos "${API_IMAGE}" migrate "fresh-migrate-${run}"; then
      pass "fresh: startup migrations run ${run} exit 0"
    else
      fail "fresh: startup migrations run ${run}: $(last_error "fresh-migrate-${run}")"
      return
    fi
  done
  if api fresh cortexos "${API_IMAGE}" serve fresh-serve; then
    pass "fresh: normal start reaches /healthz"
  else
    fail "fresh: normal start: $(last_error fresh-serve)"
  fi
  local expected actual stray
  expected="$(expected_versions)"; actual="$(public_versions fresh cortexos)"
  if [[ "${actual}" == "${expected}" ]]; then
    pass "fresh: public._sqlx_migrations = ${actual}"
  else
    fail "fresh: public._sqlx_migrations = '${actual}', expected '${expected}'"
  fi
  stray="$(stray_objects fresh cortexos)"
  if [[ -z "${stray}" ]]; then
    pass "fresh: no CortexOS object outside public"
  else
    fail "fresh: objects outside public: ${stray}"
  fi
}

# upgrade_layout <pg name> <pg image> <admin role>
upgrade_layout() {
  local pg="$1" image="$2" admin="$3" before control after run
  start_pg "${pg}" "${image}" "${admin}" "$(role_only_init)"
  api "${pg}" "${admin}" "${BASE_API_IMAGE}" migrate "${pg}-base" \
    || { fail "upgrade ${pg}: base migration: $(last_error "${pg}-base")"; return; }
  sql "${pg}" "${admin}" "INSERT INTO public.memory_spaces (tenant_id, space_id, name) VALUES ('dbtest', 'upgrade', 'seeded by the base build')" >/dev/null
  before="$(fingerprint "${pg}" "${admin}")"
  api "${pg}" "${admin}" "${BASE_API_IMAGE}" migrate "${pg}-base-control" \
    || { fail "upgrade ${pg}: base control rerun: $(last_error "${pg}-base-control")"; return; }
  control="$(fingerprint "${pg}" "${admin}")"
  [[ "${control}" == "${before}" ]] || { fail "upgrade ${pg}: fingerprint unstable across a base rerun"; return; }
  for run in 1 2; do
    api "${pg}" "${admin}" "${API_IMAGE}" migrate "${pg}-head-${run}" \
      || { fail "upgrade ${pg}: candidate migration run ${run}: $(last_error "${pg}-head-${run}")"; return; }
  done
  api "${pg}" "${admin}" "${API_IMAGE}" serve "${pg}-head-serve" \
    || { fail "upgrade ${pg}: candidate normal start: $(last_error "${pg}-head-serve")"; return; }
  after="$(fingerprint "${pg}" "${admin}")"
  if [[ "${after}" == "${before}" ]]; then
    pass "upgrade ${pg}: ledger, objects and every public table unchanged ($(printf '%s\n' "${before}" | wc -l) fingerprint lines)"
  else
    fail "upgrade ${pg}: database changed:"
    diff <(printf '%s\n' "${before}") <(printf '%s\n' "${after}") | head -20 || true
  fi
}

mode_upgrade() {
  : "${BASE_API_IMAGE:?BASE_API_IMAGE must name the base cortexos-api image}"
  upgrade_layout ci-layout "${PG_PLAIN_IMAGE}" cortexos
  upgrade_layout age-layout "${PG_AGE_IMAGE}" cxadmin
}

# refused <pg name> <admin role> <log prefix> <expected object>
refused() {
  local pg="$1" admin="$2" label="$3" object="$4" before after
  before="$(fingerprint "${pg}" "${admin}")"
  if api "${pg}" "${admin}" "${API_IMAGE}" migrate "${label}-head"; then
    fail "${label}: candidate started on a database with CortexOS objects outside public"
  elif last_error "${label}-head" | grep -q "CortexOS objects outside schema public.*${object}"; then
    pass "${label}: refused: $(last_error "${label}-head" | cut -c1-200)"
  else
    fail "${label}: wrong refusal: $(last_error "${label}-head")"
  fi
  after="$(fingerprint "${pg}" "${admin}")"
  if [[ "${after}" == "${before}" ]]; then
    pass "${label}: refused start wrote nothing"
  else
    fail "${label}: refused start changed the database"
  fi
}

mode_split() {
  : "${BASE_API_IMAGE:?BASE_API_IMAGE must name the base cortexos-api image}"
  start_pg split "${PG_AGE_IMAGE}" cortexos "$(role_only_init)"
  # The base build creates the ledger in public, then the baseline's AGE graph creates
  # schema "cortexos", and the shared migrations' ledger and tables land there.
  api split cortexos "${BASE_API_IMAGE}" migrate split-base || true
  refused split cortexos split 'cortexos\._sqlx_migrations'
}

mode_stale_init() {
  local ref="${BASE_REF:-origin/main}"
  mkdir -p "${WORK}/init-stale"
  cp "${ROOT}/infra/postgres/init/00_runtime_role.sh" "${WORK}/init-stale/"
  git -C "${ROOT}" show "${ref}:infra/postgres/init/01_bootstrap.sql" > "${WORK}/init-stale/01_bootstrap.sql"
  grep -q 'CREATE TABLE' "${WORK}/init-stale/01_bootstrap.sql" \
    || { fail "stale-init: ${ref}:infra/postgres/init/01_bootstrap.sql has no bootstrap DDL; set BASE_REF to the pre-fix commit"; return; }
  start_pg stale "${PG_AGE_IMAGE}" cortexos "${WORK}/init-stale"
  refused stale cortexos stale-init 'cortexos\.memory_spaces'
}

case "${MODE}" in
  fresh) mode_fresh ;;
  upgrade) mode_upgrade ;;
  split) mode_split ;;
  stale-init) mode_stale_init ;;
  *) echo "usage: API_IMAGE=... $0 fresh|upgrade|split|stale-init" >&2; exit 2 ;;
esac
if [[ "${FAILED}" -eq 0 ]]; then echo "RESULT ${MODE}: PASS"; else echo "RESULT ${MODE}: FAIL"; exit 1; fi
```

## Plan validation (planner, throwaway exports of 262cf33; nothing in the repo)

The plan's code was applied to throwaway `git archive 262cf33` exports in the session scratchpad (never the repo, a branch or a worktree) and run with the container gate recipe against fresh `pgvector/pgvector:pg16` databases, 2026-11-06 20:00-20:30 EST. Planner pre-checks do not replace the builder's own RED/GREEN runs and evidence on the story branch.

| Run | Tree | fmt | clippy | build | DB gate | Tally | New tests |
|---|---|---|---|---|---|---|---|
| Base | 262cf33 unchanged | n/a | n/a | 0 | PASSED (executed) | 380 / 0 / 0 | n/a |
| RED (Task 1 only) | base + DB test module + registration + AC5 unit test | 0 | n/a | 0 | FAILED (tests_failed), as intended | 329 passed / 4 failed / 0 ignored | the 4 below fail |
| GREEN ×2 | base + Tasks 1-4 | 0 (second run, after the one rustfmt fix now in this plan) | 0 (`scripts/ci/retrieval-cargo.py clippy`) | 0 | PASSED (executed) | **386 / 0 / 0** | all 6 `ok` |

RED messages (verbatim, base code):
- `db_fresh_database_with_role_named_schema_migrates_into_public`: `left: Err("baseline-v2 migration failed: while executing migration 1000000: error returned from database: relation \"public._sqlx_migrations\" does not exist at line 429") right: Ok(Blank)`, the reported error, reproduced in CI's own lane.
- `db_migrations_ignore_cortexos_names_off_the_search_path`: the same 42P01.
- `db_migrations_refuse_cortexos_objects_in_role_named_schema`: the refusal assertion prints the same 42P01, with no "CortexOS objects outside schema public".
- `postgres_init_scripts_create_only_extensions`: `left: ["CREATE EXTENSION IF NOT EXISTS pgcrypto;", "CREATE EXTENSION IF NOT EXISTS vector;", "DO $$", … create_graph …]`.

Also observed:
- **An unrelated intermittent failure:** in 1 of 5 DB-gate runs (a RED run), `tests::embedding_backfill::automatic_worker_recovers_after_process_restart` hit its 40 s child-process timeout ("automatic worker left queued jobs unembedded after restart/provider recovery"). The two `embedding_backfill` tests after it then failed on the jobs it left queued (`scheduler_capability_is_bounded_scoped_and_rollback_safe`, `worker_tick_obeys_500_job_bound_and_disabled_provider_preserves_queue`). The identical tree rerun passed all three, and base and both GREEN runs passed them. If it recurs, rerun once and record both logs. Don't treat it as a regression of this story; it sorts before the new module and shares none of its state.
- **The acceptance script:** `bash -n` and `shellcheck` v0.10.0 clean. Against the base image (from a clean export): `fresh` → `FAIL fresh: startup migrations run 1: migrations: baseline-v2 migration failed: … relation "public._sqlx_migrations" does not exist at line 429`; `upgrade` base vs base → `PASS ci-layout (312 fingerprint lines)`, `PASS age-layout (673)`; `split` → `FAIL split: wrong refusal: … function "cortexos_authenticate_workspace_api_token" already exists`. `stale-init` needs a git checkout (`git show`), so it was not run in the export; its scenario is run A plus the guard.
- **Not pre-checked by the planner:** any head API image (so the script's head column for AC1, AC3 and AC4), mutants M1-M4, AC6, G4 and G6 on the planned change, and the Task 5 docs.

## Completion contract

The builder stops at **ready-for-review**. It reports the branch, head SHA and per-AC head/base results, G1–G7 exits, mutant outcomes, image IDs and binary hashes, and evidence paths. It never pushes, opens a PR, merges or posts to ClickUp (Leorna rules). The review → fix loop, verifier, blind auditor and `ac-check.sh` follow the pipeline. Hand-over names AC6 as owed to Justin if Q3 = no, and tells him to recreate his `local/data/postgres` (README step) after the merge.
