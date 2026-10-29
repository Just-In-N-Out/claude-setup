# REVIEWER 2 brief (review only): 86bcm901r-starter-packs [leorna]

**Role:** REVIEWER 2 (report only) for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). You are the second fresh full review (`review-fix-cadence`): you review the **whole corrected branch**, and you also check that fixer 1's changes really close reviewer 1's findings without breaking anything. You have never seen this build. **Change nothing:** no commit, push, merge or file edit in the worktree; restore anything you touch.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply.

## What to review

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`.
- **Candidate head:** `08dac8dbe49e662662b67184ef91cebde7c7e159`. **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Review the whole `git diff 6c1709e...08dac8d` (three dots) against the plan and the `leorna` skill's rules, and look hard at the fix delta `aa57092..08dac8d` (7 commits). First check the worktree HEAD is `08dac8d` and clean; if not, stop and report.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29 under Justin's away grant, every ⭐: Q1–Q6 A).
- **Earlier work, to check, not to trust:** the evidence folder `~/.hermes/plans/leorna/evidence/86bcm901r/` (`INVENTORY.md` has the builder's and fixer 1's sections; `reviewer1/` has reviewer 1's logs, mutants and probes; `fixer1/` has fixer 1's TDD receipts and mutant logs). Write only into your own `reviewer2/` subfolder.

## Reviewer 1's findings (on `aa57092`) and fixer 1's dispositions

Reviewer 1 returned "findings", none critical or major, accepted all six builder rulings and AC1, AC2, AC3 and AC5.
- **F1 (minor):** the starter-column test missed migration 24's reverse direction of `pack_versions_starter_complete` and the 64-character `starter_role` bound, and checked only SQLSTATE (mutants R4, R5 survived). **Fixer: fixed** (commit `c545b40`): three new cases plus a 64-character accept case; asserts `pgErr.ConstraintName`. R4, R5 killed at `starter_packs_test.go:451`.
- **F2 (minor):** nothing pinned the `beginOrg` actor check in `LatestStarterVersions` (R1 survived). **Fixer: fixed** (`3a7377a`): new `TestLatestStarterVersionsChecksTheActorWithPostgres`; R1, R1b, R1c killed at `:371`.
- **F3 (minor):** `starterLoadError` said "retry setup", but setup never runs the starter load. **Fixer: fixed** (`5a17408`): now "restart the control plane to retry, it is safe to run again", pinned in AC5. *Ruling, not yet confirmed:* in the README's migration-down-then-up case a restart can't succeed either; the README says to fix forward there.
- **F4 (minor):** the held warning mixed an older binary (order < 0) with a forgotten library bump (order == 0). **Fixer: fixed** (`08d438d`) with a new `StarterLoadResult.Older` field, logged at info in `main.go`; AC3 asserts the split. *Ruling, not yet confirmed:* that shape.
- **F5 (minor):** a rename-only change wrote nothing, so the catalog showed the old stored name next to the new description. **Fixer: fixed** (`b62de55`): a name change counts as a change under the same release rule (held on the same library version, released as the role's next version with the same items on the next library release; older binary writes nothing); new `TestStarterPackRenameIsReleasedLikeAnItemChangeWithPostgres`. *Ruling, not yet confirmed:* this choice over reading the name from the definition.
- **F6 (nit):** no automated test of the `main.go` wiring. **Fixer: declined** (needs a `main.go` refactor, out of scope; proven by the real binary at `08dac8d`, `ac1-startup.txt`). Follow-up.
- **F7 (nit):** AC2 didn't require the Codex prompt skip warning. **Fixer: fixed** (`9d0eb2b`): every skipped prompt must carry the exact warning with a non-empty reason; F7a, F7b killed at `:363`.
- Docs: `08dac8d` updates `internal/pack/README.md`.

Judge each disposition and each "not yet confirmed" ruling: is the fix right, minimal and within the plan's design? Does a fix change behaviour the plan or main relied on? Did the stronger tests keep every AC's meaning? Is F6's decline reasonable?

Also do the full review the plan asks of every reviewer ("Notes for later roles"): `beginOrg(…, false)` keeps the page tenant-scoped; no write path takes a tenant actor; `ensureStarterPacks` can't touch tenant rows (inserts only `tenant_id` NULL); migration 24's CHECKs and its down file with `TestMigrationRoundTrip`; the held, older-binary and now rename logic; resolution before the transaction; the advisory lock; the startup wiring order in `cmd/control-plane/main.go`; the Q1 A mapping; README claims true as written; no `.github/`, `contracts/` or `packages/contracts/` path changed; commit authorship (`Justin Issa <justin@leorna.com>`, no AI attribution lines, no `CLAUDE.md`).

**Integration (read only):** check whether GitHub `main` moved since `6c1709e` (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`; never fetch into or touch the main checkout) and, if it did, whether the new commits touch any file this branch changes (`gh api repos/LeornaAI/leorna-control-plane/compare/6c1709e...<new sha> --jq '.files[].filename'`). Report it; don't merge anything.

## Acceptance criteria (approved plan; check each, return `ac_status`)

- **AC1:** fresh install → the agreed starter packs are in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres` (`./internal/web`).
- **AC2:** assigned to a team → engineers sync it in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres` (`./internal/web`).
- **AC3:** library item update → starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres` (`./internal/store/postgres`).
- **AC4 (proposed) (live):** Justin's real desktop Sync. Mark it `accepted: false`, `not_run: "live: needs Justin's server and desktop app"`. Check `ac4-live/CHECKLIST.md` is still accurate after the fixes (e.g. the warnings it lists).
- **AC5 (proposed):** a bad definition or failed write stops the load, writes nothing, a retry works. Test `TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres` (`./internal/store/postgres`).

For each: does the test prove the AC's every clause, does it pass on `08dac8d`, does it fail (or fail to build) on base, and is there a real screenshot of the current head?

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (reviewer rules; skip its Step 1 full context load, but read `$MEM/leorna-control-plane-workflow.md` for test recipes: `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip their "spawn an independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't start agents.
4. `review-fix-cadence` (you are the second review of the corrected candidate).
5. `mutation-testing-discipline`, plus the plan's specialists: `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`. `backend-data-migrations` ends with the Agent Defect Loop: you are its independent problem-finder for this round.

## Run things yourself; don't trust summaries

- Gates on `08dac8d`, in a **detached copy** (`git -C <worktree> worktree add --detach ~/.cache/86bcm901r-review2/head 08dac8d`), because `make check` and `test-module-add.sh` briefly write into their tree: `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, and the Postgres skip check from a `go test -json` stream (`leorna` step 4). Also the production image once: `docker build --no-cache --file Containerfile --tag 86bcm901r-review2 .` in the copy (check the `go build` steps say DONE, not CACHED), then `docker run --rm --entrypoint /usr/local/bin/gitleaks 86bcm901r-review2 version` prints `8.30.1`; remove the tag after.
- Each AC test by name on head and on base (base in its own detached worktree at `6c1709e` with only that AC's test files, plus any test files of packages the story creates that it imports, copied in; `ac-verification.md` has the recipe).
- Your own mutations (overlay or a detached copy, never the story worktree), especially on the fix delta: the `Older`/`Held` split, the rename compare, the restart advice, the actor check, and any guard the fixes touched. Re-run one or two of reviewer 1's surviving mutants (R1, R4, R5) to confirm they now die on the intended assertion.
- **Database:** your own, `leorna_86bcm901r_review2_test` (and `leorna_86bcm901r_review2_base_test` for base runs), in `leorna-test-pg` only. The password never goes on a command line or into a log. Never another role's or a sibling's database, never `leorna-pg`. Drop yours when done.
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries, logs) in `~/.cache/86bcm901r-review2/`, made fresh with `mkdir` (no `-p`). Nothing big on `/tmp` (a small shared RAM disk). Keep the logs you cite in `~/.hermes/plans/leorna/evidence/86bcm901r/reviewer2/` (create it). At the end remove your detached worktrees with `git worktree remove`, then `rm -r /home/justin/.cache/86bcm901r-review2` by that literal path.
- Siblings: PR #98 (86bcm901j) is open in this repo. Never touch another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- Severity per finding: critical / major / minor / nit. Mark `introduced: true` only when the defect is in this branch's diff (pre-existing problems go in `found_else`).
- If you find any other bug or problem outside this story's diff, don't fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, reviewed_head, base, main_moved{github_main, touches_story_files[]}, findings[{id, severity, introduced, claim, evidence, suggested_test}], dispositions_judged[{id, verdict, why}], rulings_judged[{ruling, verdict, why}], ac_status[{ac, accepted, test, screenshot, evidence, not_run}], gates[{gate, log, exit}], mutants[{id, target, result, evidence}], defect_loop_skills[], found_else[], skill_lessons[]}`. `verdict`, `reviewed_head`, `findings` and `ac_status` are required. Plain words.
