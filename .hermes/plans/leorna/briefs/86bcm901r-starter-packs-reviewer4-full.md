# REVIEWER brief (review-2, full, report only): 86bcm901r-starter-packs [leorna]

**Role:** fresh REVIEWER (report only) for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). This is **round 2 of the review referee** (`review-check.sh`): a **full** review of the whole story as it stands on its new head, against GitHub `main` it was just merged with. You have never seen this build. **Change nothing:** no commit, push, merge or file edit in the worktree; restore anything you touch.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Why this round, and what to look at hardest

Review-1 (`~/.hermes/plans/leorna/evidence/86bcm901r/review-1/`, full, `dd006b7`→`abc60dc`) was clean; `abc60dc` was then ALL ACCEPTED. Since then GitHub `main` moved three times (#99, #100, #101) and four commits landed that **no one has reviewed**:
1. **`034156e`**: merge of `b985422` (#99, 86bcm901y remove/reorder) with code changes inside the merge: this story's migration renumbered 24→25, its call to #99's `insertVersionItems` given the new 5th argument `ordered` as `false`, and this story's test helper renamed `mintStarterDesktopToken` (it clashed with #99's `mintDesktopToken`). Is `ordered=false` right for starter versions (read #99's meaning of `ordered` and this story's order expectations)? Was anything of #99's behaviour lost in `internal/web/library.go`, `internal/pack/README.md`, `delivery/stories.json`?
2. **`805b6cd`**: docs, the QA1 line in `internal/pack/README.md` (AC4 is now an agent-run check; Justin: "Fix it if a fixer runs"). True as written?
3. **`a21c545`**: merge of `e2254e0` (#100 item editor live preview, #101 quick start): this story's migration renumbered 25→**26** (#101 took `000025_quick_starts`), `delivery/stories.json`; auto-merged `cmd/control-plane/main.go`, `internal/pack/README.md`, `internal/web/handler.go`.
4. **`1aa8ca3`**: docs, #101's onboarding notes reworded (`internal/onboarding/README.md`, `starters.go`, `starters_test.go`): #101's stand-in starter list stays, and a later story moves the quick start onto this story's shared packs.

**Justin's decision on #101's stand-in list (2026-10-29): "Separate story later".** #101's quick start keeps its own list in `internal/onboarding/starters.go` and makes the company's own pack on pick; switching it to this story's shared starter packs is a new card. So "replace the stand-in" is out of scope. Still review how the two meet: the fixer's report says both work on one database with no constraint collision, the lists hold identical items, and each role's pack name shows twice (shared `starter-<role>-1` and the company's `v<timestamp>`). Check that yourself (its probe is `main-in-101/overlap-probe.go.txt`; don't trust its log): does anything break for a real admin or engineer (startup order in `main.go`, setup "ready", the assignments page, the catalog, sync), and is every rewritten sentence true?

## What to review

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`. First check HEAD is `1aa8ca3107d1a0dbde3da57737ae7ac2e8182e4c` and `git status --porcelain` is empty; if not, stop and report.
- **Review range (full):** `--base e2254e0100a482b9201edf9b96f01936e4486d44` (GitHub `main` and the merge base now) to head `1aa8ca3`: the whole `git diff e2254e0...1aa8ca3` (three dots) is this story's change against current main. Also read the four never-reviewed commits above in their own diffs (for a merge: `git diff <first parent> <merge>` and the both-sides files). The story's first base was `6c1709e`; don't review main's own #99/#100/#101 changes except where they meet this story's files.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29: every ⭐ Q1–Q6 A; **Amendment 1**: AC4 is the agent-run check `ac4_starter_pack_desktop_sync`, approved with "Go"). Where the plan says "migration 24", read this story's migration, now `000026_starter_packs`.
- **Earlier work, to check, not to trust:** `~/.hermes/plans/leorna/evidence/86bcm901r/` (`review-1/`, `verifier-abc60dc/`, `auditor-abc60dc/`, `main-in-99/`, `main-in-101/` with the latest fixer's merge proof, gates, AC logs and overlap probe, `follow-ups.md` with the P3 ids so far). Write only into your own folder `~/.hermes/plans/leorna/evidence/86bcm901r/review-2/` (create it fresh with `mkdir`, no `-p`; stop if it exists).

The plan's "Notes for later roles" lists what every reviewer checks: `beginOrg(…, false)` keeps the page tenant-scoped; no write path takes a tenant actor; `ensureStarterPacks` can't touch tenant rows (inserts only `tenant_id` NULL); the migration's CHECKs and its down file with `TestMigrationRoundTrip`; the held, older-binary and rename logic; resolution before the transaction; the advisory lock; the startup wiring order in `cmd/control-plane/main.go` (now next to #101's quick start wiring); the Q1 A mapping; README claims true as written; no `.github/`, `contracts/` or `packages/contracts/` path changed; commit authorship of the branch's own commits (`git log HEAD ^6c1709e ^e2254e0`: Leorna identity, report it as a result and never print the address; no AI attribution lines; no `CLAUDE.md`).

Also check: does #100's item editor (new item versions from the admin UI, `internal/pack/version_service.go`, `internal/web/item_create.go`, `item_preview.go`) or #99's reorder change anything a starter pack holds or how its items resolve, or let an admin edit, reorder or remove items in a shared starter version (tenant scoping of the new routes against `tenant_id` NULL rows)? Is renumbering to 26 safe for every database that matters (GitHub never had 24 or 25 from this story; a local test database that ran `034156e`/`805b6cd` stops with "migration 25 checksum mismatch": the fixer called that P3 for the PR's migration notes)?

## Acceptance criteria (approved plan; check each, return `ac_status`)

- **AC1:** fresh install → the agreed starter packs are in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres` (`./internal/web`).
- **AC2:** assigned to a team → engineers sync it in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres` (`./internal/web`).
- **AC3:** library item update → starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres` (`./internal/store/postgres`).
- **AC4:** the agent-run check `ac4_starter_pack_desktop_sync`, run exactly as the plan's "AC4's check" says (`bash ~/.hermes/plans/leorna/86bcm901r-ac4/run.sh …`, its own work, out folder and database). Read `run.sh` and `client-sync.go` first and confirm the client can't write into the real `/home/justin`. Head must print `ok 1`, base `not ok 1`.
- **AC5:** a bad definition or failed write stops the load, writes nothing, a retry works. Test `TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres` (`./internal/store/postgres`).

For each: does the test prove every clause, does it pass on `1aa8ca3`, and does it fail (or fail to build) on base `e2254e0`?

## The referee's record (required)

Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` in full, and the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh`. Write **`review-2/review.json`** exactly in the format they define: `round` 2, a **full** round, `from` = `e2254e0100a482b9201edf9b96f01936e4486d44`, `head` = `1aa8ca3107d1a0dbde3da57737ae7ac2e8182e4c`, and every finding with its P0–P3 severity (CLAUDE.md's definitions: **P0/P1** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work; **P2** a bug a real person or agent could plausibly hit, realistic edge cases included, anything that breaks an AC or the UI, or a test that can't fail; **P3** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has). A P0–P2 needs a concrete real-use scenario. Don't repeat a P3 already in `follow-ups.md` unless you have a new fact. Before handing back, run `review-check.sh --repo <worktree> --base e2254e0100a482b9201edf9b96f01936e4486d44 ~/.hermes/plans/leorna/evidence/86bcm901r` and report its last line (it must parse your record; fix the record, not the code, if it doesn't).

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (reviewer rules; skip its Step 1 full context load, but read `$MEM/leorna-control-plane-workflow.md` for test recipes: `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip their "spawn an independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't start agents.
4. `review-fix-cadence`.
5. `mutation-testing-discipline`, plus the plan's specialists: `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`. `backend-data-migrations` ends with the Agent Defect Loop: you are its independent problem-finder for this round.

## Run things yourself; don't trust summaries

- Gates on `1aa8ca3` in a **detached copy** (`git -C <worktree> worktree add --detach ~/.cache/86bcm901r-rev2/head 1aa8ca3`), because `make check` and `test-module-add.sh` briefly write into their tree: `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, and the Postgres skip check from a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/onboarding` (`leorna` step 4).
- Each AC by name on head and on base (Go ACs on base: a detached worktree at `e2254e0` with only that AC's test files, plus any test files of packages the story creates that it imports, copied in; `ac-verification.md` has the recipe).
- Your own mutations (overlay or a detached copy, never the story worktree), especially on the never-reviewed commits: `ordered=false`, the renumbered migration's CHECKs, the startup wiring order next to the quick start.
- **Databases:** your own only, prefix `leorna_86bcm901r_rev2_`, ending `_test` (incl. AC4's), in `leorna-test-pg` only (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another role's or a sibling's database, never `leorna-pg`. Drop yours when done.
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries, AC4 work folders) in `~/.cache/86bcm901r-rev2/`, made fresh with `mkdir` (no `-p`). Nothing big on `/tmp`. Keep the logs you cite in `review-2/`. At the end remove your detached worktrees with `git worktree remove`, stop any server by its verified PID, then `rm -r /home/justin/.cache/86bcm901r-rev2` by that literal path.
- Never touch the main checkout, another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- Mark `introduced: true` only when the defect is in this story's diff against `e2254e0` (pre-existing problems go in `found_else`).
- If you find any other bug or problem outside this story's diff, don't fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, reviewed_head, base, review_json, review_check_last_line, findings[{id, severity, introduced, claim, scenario, evidence, suggested_test}], ac_status[{ac, accepted, test, screenshot, evidence, not_run}], gates[{gate, log, exit}], mutants[{id, target, result, evidence}], quick_start_overlap, found_else[], skill_lessons[]}`. `verdict`, `reviewed_head`, `findings`, `ac_status` and `review_json` are required. Plain words.
