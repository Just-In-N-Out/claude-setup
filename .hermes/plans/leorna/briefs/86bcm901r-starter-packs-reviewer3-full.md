# REVIEWER brief (review-1, full, report only): 86bcm901r-starter-packs [leorna]

**Role:** fresh REVIEWER (report only) for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). This is **round 1 of the review referee** (`review-check.sh`): a **full** review of the whole story as it stands on its new head, against GitHub `main` it was just merged with. You have never seen this build. **Change nothing:** no commit, push, merge or file edit in the worktree; restore anything you touch.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Why this round, and what to look at hardest

Earlier reviews (folders `reviewer1/`, `reviewer2/`, written before the referee existed) covered the story up to `08dac8d`. Three things since then have **never been reviewed**:
1. **Fixer 2's commits** `08dac8d..398af64`: the starter role capped at 32 characters in `StarterPack.Validate` and in migration 24 (edited in place; never on GitHub), the load's version check returning `ErrStarterLoad` naming `check <role> version <n>`, and a test that the catalog shows the stored name.
2. **The merge of GitHub `main`** `dd006b7` (PR #98, 86bcm901j) in merge commit `4ea7548`: conflicts in `delivery/stories.json` (main's file unchanged, this story's entry appended last as text) and `internal/library/README.md` (both kept).
3. **Docs commit** `abc60dc`: a README sentence from #98 ("… until the role packs story (86bcm901r)") reworded, because this story leaves the starter seed unchanged (Q4 A).

## What to review

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`. First check HEAD is `abc60dc74fc898c43cc9f010aed40e5cb6c29e54` and `git status --porcelain` is empty; if not, stop and report.
- **Review range (full):** `--base dd006b79f9908976e853c57489032bd5d9d471df` (GitHub `main` and the merge base now) to head `abc60dc`: the whole `git diff dd006b7...abc60dc` (three dots) is this story's change against current main. Also read the three never-reviewed parts above in their own commits. The story's first base was `6c1709e`; don't review main's own #98 changes except where they meet this story's files.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29 under Justin's away grant, every ⭐: Q1–Q6 A). A planner is amending AC4 in parallel (it becomes an agent-run check); review AC4 as written in that approved copy.
- **Earlier work, to check, not to trust:** `~/.hermes/plans/leorna/evidence/86bcm901r/` (`INVENTORY.md`, `reviewer1/`, `reviewer2/`, `fixer1/`, `fixer2/`, `verifier/`, `main-in/` with the bring-main-in fixer's gates and merge proof). Write only into your own folder `~/.hermes/plans/leorna/evidence/86bcm901r/review-1/` (create it fresh with `mkdir`, no `-p`; stop if it exists).

The plan's "Notes for later roles" lists what every reviewer checks: `beginOrg(…, false)` keeps the page tenant-scoped; no write path takes a tenant actor; `ensureStarterPacks` can't touch tenant rows (inserts only `tenant_id` NULL); migration 24's CHECKs and its down file with `TestMigrationRoundTrip`; the held, older-binary and rename logic; resolution before the transaction; the advisory lock; the startup wiring order in `cmd/control-plane/main.go`; the Q1 A mapping; README claims true as written (now including #98's library 0.8.0 text next to this story's); no `.github/`, `contracts/` or `packages/contracts/` path changed; commit authorship of the branch's own commits (`git log HEAD ^6c1709e ^dd006b7`: Leorna identity, report it as a result and never print the address; no AI attribution lines; no `CLAUDE.md`).

Also check: does #98's library 0.8.0 change anything a starter pack holds or how its items resolve (`TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary`)? Is the 32-character cap right for every id path (`starter-<role>-<n>` within the 50-character version id) and enforced in both Go and SQL? Is editing migration 24 in place safe given it was never on GitHub?

**Integration (read only):** PR #99 (86bcm901y, head `008c612`) is open and, per the fixer, conflicts with this head in `delivery/stories.json`, `internal/pack/README.md` and `internal/web/library.go`, and also adds migration `000024`. Confirm it with a read-only `git merge-tree` (fetch `pull/99/head` read-only over HTTPS through `gh` into a scratch clone or detached worktree, and check `git rev-parse FETCH_HEAD` equals `gh pr view 99 --json headRefOid` first). That's integration work for whichever merges later; report it, but it is **not a finding against this branch** unless this branch does something wrong.

## Acceptance criteria (approved plan; check each, return `ac_status`)

- **AC1:** fresh install → the agreed starter packs are in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres` (`./internal/web`).
- **AC2:** assigned to a team → engineers sync it in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres` (`./internal/web`).
- **AC3:** library item update → starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres` (`./internal/store/postgres`).
- **AC4 (proposed) (live):** being rewritten. Mark it `accepted: false`, `not_run: "being rewritten as an agent check"`.
- **AC5 (proposed):** a bad definition or failed write stops the load, writes nothing, a retry works. Test `TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres` (`./internal/store/postgres`).

For each: does the test prove every clause, does it pass on `abc60dc`, and does it fail (or fail to build) on base?

## The referee's record (required)

Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` in full, and the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh`. Write **`review-1/review.json`** exactly in the format they define: `round` 1, a **full** round, `from` = `dd006b79f9908976e853c57489032bd5d9d471df`, `head` = `abc60dc74fc898c43cc9f010aed40e5cb6c29e54`, and every finding with its P0–P3 severity (CLAUDE.md's definitions: **P0/P1** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work; **P2** a bug a real person or agent could plausibly hit, realistic edge cases included, anything that breaks an AC or the UI, or a test that can't fail; **P3** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has). A P0–P2 needs a concrete real-use scenario. Before handing back, run `review-check.sh --repo <worktree> --base dd006b79f9908976e853c57489032bd5d9d471df ~/.hermes/plans/leorna/evidence/86bcm901r` and report its last line (it must parse your record; fix the record, not the code, if it doesn't).

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (reviewer rules; skip its Step 1 full context load, but read `$MEM/leorna-control-plane-workflow.md` for test recipes: `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip their "spawn an independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer, and you can't start agents.
4. `review-fix-cadence`.
5. `mutation-testing-discipline`, plus the plan's specialists: `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`. `backend-data-migrations` ends with the Agent Defect Loop: you are its independent problem-finder for this round.

## Run things yourself; don't trust summaries

- Gates on `abc60dc` in a **detached copy** (`git -C <worktree> worktree add --detach ~/.cache/86bcm901r-rev1/head abc60dc`), because `make check` and `test-module-add.sh` briefly write into their tree: `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, and the Postgres skip check from a `go test -json` stream (`leorna` step 4).
- Each AC test by name on head and on base (base: a detached worktree at `dd006b7` with only that AC's test files, plus any test files of packages the story creates that it imports, copied in; `ac-verification.md` has the recipe).
- Your own mutations (overlay or a detached copy, never the story worktree), especially on fixer 2's changes: the 32-character cap in Go and in SQL, the `check <role> version <n>` error, the stored-name test.
- **Database:** your own, `leorna_86bcm901r_rev1_test` (and `leorna_86bcm901r_rev1_base_test`), in `leorna-test-pg` only. The password never goes on a command line or into a log. Never another role's or a sibling's database, never `leorna-pg`. Drop yours when done.
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries) in `~/.cache/86bcm901r-rev1/`, made fresh with `mkdir` (no `-p`). Nothing big on `/tmp`. Keep the logs you cite in `review-1/`. At the end remove your detached worktrees with `git worktree remove`, then `rm -r /home/justin/.cache/86bcm901r-rev1` by that literal path.
- In parallel, a planner works in `~/.cache/86bcm901r-plan4/` with databases `leorna_86bcm901r_plan4_*`: never touch them. Never touch another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Rules

- You can't ask Justin anything.
- Mark `introduced: true` only when the defect is in this story's diff against `dd006b7` (pre-existing problems go in `found_else`).
- If you find any other bug or problem outside this story's diff, don't fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, reviewed_head, base, review_json, review_check_last_line, findings[{id, severity, introduced, claim, scenario, evidence, suggested_test}], ac_status[{ac, accepted, test, screenshot, evidence, not_run}], gates[{gate, log, exit}], mutants[{id, target, result, evidence}], integration{pr99}, found_else[], skill_lessons[]}`. `verdict`, `reviewed_head`, `findings`, `ac_status` and `review_json` are required. Plain words.
