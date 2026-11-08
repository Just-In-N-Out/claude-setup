# Brief: 86bcm9284 builder

**Role:** BUILDER (Full pipeline) for Leorna card 86bcm9284, "Predefined integration tiles: GitHub, Google Workspace, ClickUp". You build test-first and stop at `ready-for-review`. No reviewing your own work as a substitute for review, no push, no PR, no ClickUp writes.

**Approved plan (your spec):** `~/.hermes/plans/leorna/86bcm9284-predefined-integration-tiles.md`. The frozen approved copy is `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md`. Read the whole plan, including the "Approval" section at the end. Justin approved it with "go" on 2026-11-07, with every ⭐ answer (Q1 A … Q8 A) and AC2 as `(live)`. Build exactly what it says. If something in it is impossible or wrong, stop and report it with evidence rather than redesigning.

**Base:** 86bcm927y has merged. GitHub main of leorna-control-plane = `f0a326b83aae9d181e4f6681645685ae4b1fff91` (PR #112, 927y merge; 927y's head `0027786` is an ancestor). The shared main checkout `~/Leorna/leorna-control-plane` has been fast-forwarded to it; don't commit there. Re-fetch over HTTPS via gh (command in the `leorna` skill) and record the SHA you branch from. The plan's paths "on main after 927y" are now real: re-check each file:line against `f0a326b` before relying on it.

## Workspace
- Control plane: `git -C ~/Leorna/leorna-control-plane worktree add ~/Leorna/86bcm9284-predefined-integration-tiles -b feat/86bcm9284-predefined-integration-tiles f0a326b` (or the fresher main SHA you fetched). Work only there.
- Client fixture change (Q5 A, plus any rendered-output change): fetch client main over HTTPS via gh, then its own worktree, e.g. `~/Leorna/86bcm9284-client-tile-fixtures` on `feat/86bcm9284-tile-fixtures`. Test fixtures only, as the plan says. It must merge before the control-plane PR. Note in your report that this ordering is owed at PR time.
- Scratch, TMPDIR, Postgres data and caches go in owned folders on the real disk (`~/.cache/86bcm9284-builder/`), never `/tmp` (7.9 GB tmpfs shared by every session). Run your own Postgres test container or no-sudo Postgres (see `leorna-control-plane-workflow.md`); never touch `leorna-pg` or a sibling's DB.
- Toolchain: `go`, `golangci-lint` and `govulncheck` are in `~/.local/leorna-toolchain` at CI's versions. Bind them task-locally (PATH first, plus `GOLANGCI_LINT=`/`GOVULNCHECK=` absolute paths for make). `make`, `gcc`, `docker` and gitleaks 8.30.1 are present.
- Cursor CLI is now installed on this desktop (`~/.local/bin/cursor-agent`, 2026-11-07). Even `--version` writes `~/.config/cursor`, so any agent-side Cursor check must isolate HOME and XDG dirs. It does not change the plan's `(live)` tagging.

## Skills to load (Skill tool), in order
`leorna` (do its Step 1 context load), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the gate rules and Docker-by-digest rules are guards), plus `security-best-practices` and `api-contract-drift-guard` if the API is touched.

## Acceptance criteria (from the approved plan)
- AC1 (done): first three systems recorded. Re-run `TestEmbeddedTilesCoverTheFirstThreeSystems` only.
- AC2 (live): admin enables a tile → engineers connect with their own sign-in → working MCP config syncs to their tools. Build the agent-side test `TestPredefinedTilesAC2EnableAndSyncWithPostgres` and the headless client Sync into a scratch HOME the plan describes. The live sign-in against Justin's test GitHub org and test ClickUp workspace is owed to Justin, not you: mark it NOT VERIFIED (live) in your report. Google's AC2 part is a follow-up (Q3 A).
- AC3: each tile's source, licence, sign-in and scopes are documented and vetted: `TestTileVettingIsDocumented`.
- AC4: each tile passes the content quality gate for every declared tool: `TestShippedTilesPassTheGate`, via `cmd/library-gate -tiles` in `make library-check`, with no `.github/workflows` change.
- AC5: on a fresh install, the three tiles are available: `TestPredefinedTilesAC5FreshInstallWithPostgres` plus a screenshot of the admin page on an empty DB.

One test and one screenshot per AC: a real page capture for visible ACs, and a real terminal capture of the run (command, output, exit code) for ACs with nothing visual. Evidence goes in `~/.hermes/plans/leorna/evidence/86bcm9284/` (`ac<n>-<what>.png`, `gates-<sha7>.txt`). Before writing code, save any before-state screenshots. Each test must fail on base where the plan says it should (RED first); prove the key assertions catch a deliberate break, then restore. Mutation runs always run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Gates (keep real output)
Control-plane `make check` with the DB-skip rules from the `leorna` skill (a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`, plus the story's own packages; fail any skip naming `LEORNA_TEST_DATABASE_URL`). Then `bash ./scripts/test-module-add.sh` serially. Then `make library-check`, showing every tile × variant × tool. Client: the fixture change's own tests (`go test` on the touched packages, plus `make check` if feasible). `git diff --name-only <base>...HEAD -- .github` must be empty. Commits are `feat(86bcm9284): …` as the repo's Leorna identity; no AI attribution lines, and never stage CLAUDE.md.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. If earlyoom killed it, say so, find what grew, and rerun under the systemd-run cap above.

## Skill lessons
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule (kind, what it checks, where it runs). An empty list is normal.

## Report back (short), at ready-for-review
Both worktree paths, branches and head SHAs; the base SHA; the commit list; per AC: test name, RED-on-base result, GREEN result, evidence file; gate results with log paths; the client-fixture-PR-first ordering; anything owed (the live AC2); deviations from the plan with reasons; skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
