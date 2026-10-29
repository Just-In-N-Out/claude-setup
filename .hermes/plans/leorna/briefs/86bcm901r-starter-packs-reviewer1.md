# REVIEWER 1 brief (review only): 86bcm901r-starter-packs [leorna]

**Role:** REVIEWER 1 (report only) for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). You are the first of two fresh full reviews (`review-fix-cadence`): after you, a fixer handles your valid findings, then a second fresh reviewer checks the corrected code. You have never seen this build. **Change nothing:** no commit, push, merge or file edit in the worktree; restore anything you touch.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply.

## What to review

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`.
- **Candidate head:** `aa5709225a72dd24056e1b91169114786b24f8b0`. **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (GitHub `main` when built). Review `git diff 6c1709e...aa57092` (three dots) against the plan and the `leorna` skill's rules. First check the worktree HEAD is `aa57092` and clean; if not, stop and report.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29 under Justin's away grant, every ⭐: Q1–Q6 A).
- **Builder's evidence and inventory:** `~/.hermes/plans/leorna/evidence/86bcm901r/` (top level; `INVENTORY.md`). Treat it as a claim to check, not proof. Don't write into that folder except your own `reviewer1/` subfolder.

The builder made six rulings "not yet confirmed". Judge each one:
1. AC2's test reads desktop responses past `readBody`'s 64 KiB cap (bounded at 16 MiB, fails if exceeded); test-only.
2. AC2 also checks each served item against the shipped library item (version, description, body, every supporting file).
3. AC5's write-failure case also forces a failure at the last pack and requires zero starter versions (proves one transaction).
4. The concurrency test runs the load on its own pool with a unique `application_name` and waits on that backend's `wait_event='advisory'` in `current_database()`.
5. The Starter packs table keeps Kind and Version on one line (one CSS rule); visual only, proof `ac1-catalog.png`.
6. `internal/pack/README.md` adds one clause about ruling 2.

The plan's "Notes for later roles" asks reviewers to check: `beginOrg(…, false)` keeps the page tenant-scoped; no write path takes a tenant actor; `ensureStarterPacks` can't touch tenant rows (it inserts only `tenant_id` NULL); migration 24's CHECKs; the held and older-binary logic; resolution happening before the transaction; the README claims are true as written. Also check: the migration's down file and `TestMigrationRoundTrip`; the advisory lock; the startup wiring order in `cmd/control-plane/main.go`; that the pack mapping matches the approved Q1 answer; that no `.github/`, `contracts/` or `packages/contracts/` path changed; commit authorship (`Justin Issa <justin@leorna.com>`, no AI attribution lines, no `CLAUDE.md`).

## Acceptance criteria (approved plan; check each, return `ac_status`)

- **AC1:** fresh install → the agreed starter packs are in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres` (`./internal/web`).
- **AC2:** assigned to a team → engineers sync it in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres` (`./internal/web`).
- **AC3:** library item update → starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres` (`./internal/store/postgres`).
- **AC4 (proposed) (live):** Justin's real desktop Sync. Mark it `accepted: false`, `not_run: "live: needs Justin's server and desktop app"`. Check its `ac4-live/CHECKLIST.md` is accurate.
- **AC5 (proposed):** a bad definition or failed write stops the load, writes nothing, a retry works. Test `TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres` (`./internal/store/postgres`).

For each: does the test really prove the AC's every clause, does it pass on head, does it fail (or fail to build) on base, and is there a real screenshot?

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (reviewer rules; skip its Step 1 full context load, but read `$MEM/leorna-control-plane-workflow.md` for test recipes: `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip their "spawn an independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't start agents.
4. `mutation-testing-discipline` (your own mutation checks), plus the plan's specialists: `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`. `backend-data-migrations` ends with the Agent Defect Loop: you are its independent problem-finder.

## Run things yourself; don't trust summaries

- Run the gates yourself on `aa57092`, in a **detached copy** (`git -C <worktree> worktree add --detach ~/.cache/86bcm901r-review1/head aa57092`), because `make check` and `test-module-add.sh` briefly write into the tree they run in: `make check` with CI's tools bound by absolute path (Go, `GOLANGCI_LINT`, `GOVULNCHECK` in `~/.local/leorna-toolchain`, task-local PATH), `bash ./scripts/test-module-add.sh`, and the Postgres skip check from a `go test -json` stream (`leorna` step 4). Also run the production image build once, as CI does since PR #94 (`docker build --no-cache --file Containerfile --tag 86bcm901r-review1 .` in the copy, then `docker run --rm --entrypoint /usr/local/bin/gitleaks 86bcm901r-review1 version` must print `8.30.1`; remove the tag after).
- Run each AC test by name on head and on base (base in its own detached worktree at `6c1709e` with only that AC's test files copied in; `ac-verification.md` has the recipe).
- Try your own mutations (overlay or a detached copy, never the story worktree) on the guards that matter: tenant scoping, `tenant_id` NULL inserts, the advisory lock, the held/older-binary logic, the one-transaction rule, the CHECKs.
- **Database:** your own, `leorna_86bcm901r_review1_test` (and `leorna_86bcm901r_review1_base_test` for base runs), in the `leorna-test-pg` container only. The password never goes on a command line or into a log. Never use the builder's or a sibling's database, never `leorna-pg`. Drop yours when done.
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries, logs) in `~/.cache/86bcm901r-review1/`, made fresh with `mkdir` (no `-p`). Never anything big on `/tmp` (a small shared RAM disk). Keep the logs you cite in `~/.hermes/plans/leorna/evidence/86bcm901r/reviewer1/` (create it). At the end remove your detached worktrees with `git worktree remove`, then `rm -r /home/justin/.cache/86bcm901r-review1` by that literal path.
- Siblings: PR #98 (86bcm901j) is open in this repo. Never touch another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- Severity per finding: critical / major / minor / nit. Mark `introduced: true` only when the defect is in this branch's diff (pre-existing problems go in `found_else`).
- If you find any other bug or problem outside this story's diff, don't fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, reviewed_head, base, findings[{id, severity, introduced, claim, evidence, suggested_test}], rulings_judged[{ruling, verdict, why}], ac_status[{ac, accepted, test, screenshot, evidence, not_run}], gates[{gate, log, exit}], mutants[{id, target, result, evidence}], defect_loop_skills[], found_else[], skill_lessons[]}`. `verdict`, `reviewed_head`, `findings` and `ac_status` are required. Plain words.
