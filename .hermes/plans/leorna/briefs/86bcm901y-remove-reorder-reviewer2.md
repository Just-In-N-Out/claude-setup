
# REVIEWER 2 (review only) — leorna-control-plane, story 86bcm901y "Remove and reorder items in a pack version"

Role: the second fresh full reviewer of the Full pipeline (`review-fix-cadence`: review 1 → fixer 1 → **review 2** → fixer 2 → verifier). You never saw the build or the first review's work. Review the **whole corrected feature**, and check that fixer 1's changes closed review 1's findings without new defects. Report only: change nothing.

## What to review
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder`, branch `feat/86bcm901y-remove-reorder`.
- Base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. Corrected head **`b35d1118472d84da1b0905fed9e33ddfcb7672f6`** (12 commits). Review 1 covered `c574cdd98d68b74bfc8a3c5f997a471193aa3435`; fixer 1 added 4 commits `c574cdd..b35d111` (8 files, +81/-10). Confirm the worktree is at `b35d111` and clean before you start, and name the head you reviewed.
- Review the whole `git diff 6c1709e...b35d111` against the approved plan `~/.hermes/plans/leorna/evidence/86bcm901y/plan-approved.md` (read-only) and the `leorna` skill's rules, and the fix delta `c574cdd..b35d111` in detail.
- Records to check as claims, not facts: `~/.hermes/plans/leorna/evidence/86bcm901y/INVENTORY.md` (builder rulings + "Fixer 1" section), `EVIDENCE.md`, review 1's receipts in `review1/`, fixer 1's in `fixer1/`. Run the gates yourself, try mutations, don't trust summaries.

## The approved story (for judging scope)
Approved 2026-10-29 under Justin's away grant ("just keep everything going and follow what the recommended agent says"): Q1-A (control-plane sync test + read-only run of the client's existing Sync test; no client change), Q2-A (Move up / Move down buttons, each click saves a version), Q3-A (order shows in console and API; Sync unchanged).
- AC1: remove an item → a new version without it, audited. Test `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`.
- AC2: after a removal, engineers' next Sync removes (or flags) the item's files consistently with the lockfile. Test `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`.
- AC3 (Justin): reorder → a new version in the new order, audited, shown in the console list and API, syncing the same files as its parent. Test `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`.
- AC4 (proposed, approved): invalid or forbidden removes and reorders are refused and write nothing. Test `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`.
- Justin asked for the screenshots to **show items being reordered and removed** in the real admin console. Check `ac3-reorder-before/after.png`, `ac1-remove-before/after.png`, the audit captures and the re-rendered `ac2-sync-lockfile-log.png` / `ac4-refused-log.png`: they show the change, match the current code (the console shots come from the `c574cdd` binary; fixer 1 says no console code changed since: check that), and show no domain, URL bar, tenant ID, token or email.

## Review 1's findings and fixer 1's dispositions (verify each yourself)
- **R1-F1 (minor):** a present but empty `order` beside other changes was accepted and ignored. Fixer 1 (`70bf9b9`): `CreatePackVersion` in `internal/web/pack_builder.go` refuses it with 400 `INVALID_PACK`; the spec's new `order` gets `minItems: 1`; new AC4 subtest `empty_order_beside_a_removal`. Note: the repo has no OpenAPI request-validation middleware, so the spec bound is documentation; the handler check is the enforcement.
- **R1-F2 (minor):** the item form's 4 KiB bound had no test (mutant R19 survived). Fixer 1 (`f2eccd5`, tests only): AC4 subtest `oversized_form` (4096 bytes → 303, 4097 → 400 `INVALID_REQUEST`, nothing written).
- **R1-F3 (nit):** the `parent_version` count guard had no test (mutant R3 survived). Fixer 1 (`f2eccd5`, tests only): AC4 subtest `missing_or_repeated_parent_version`.
- **R1-F4 (nit):** an `order` that only rearranged added items wasn't audited. Fixer 1 (`bc5b410`, its ruling, not yet confirmed): the audit records both orders whenever a save names an `order` (`if len(spec.Order) > 0` instead of `if built.Diff.Reordered` in `SavePackVersion`); saves with no `order` keep 901w's audit shape; test `TestPackItemOrderStoreWithPostgres/a_save_that_names_an_order_is_audited_with_both_orders`. Judge whether this ruling is right and whether anything else depends on the old condition.
- **R1-F5 (nit):** versions derived on Pack Versions drop the admin's order (the plan's intended D3 rule). Fixer 1 (`b35d111`): one README line.
- Fixer 1 also re-rendered `ac2-sync-lockfile-log.png` and `ac4-refused-log.png` from `b35d111`'s logs (old renders in `fixer1/superseded/`), and made the AC4 additions as new subtests (no AC or test name changed).

## Skills (load them first and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `mutation-testing-discipline` for your mutation checks, plus the specialists: `security-best-practices`, `multi-tenant-auth-management` (admin-only write route, CSRF, tenant isolation of packs and audit rows), `api-contract-drift-guard` (OpenAPI change incl. `minItems`, generated code), `backend-data-migrations` (migration 24: `pack_version_items.position`). The last two end with "Mandatory Validation and Agent Defect Loop": you are its independent problem-finder. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Gates you run yourself
`make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm901y_review2_test` in `leorna-test-pg` (127.0.0.1:55432; read the port with `docker port leorna-test-pg 5432`; never `leorna-pg` on 5432, never another role's DB such as the builder's `leorna_86bcm901y_test`), `bash ./scripts/test-module-add.sh`, `check-generated-contracts`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (the builder's `env.sh.txt` shows where they are installed), story gitleaks, and each AC test by name on head and on base (base in your own detached copy with your own DB and only the AC test file copied). Confirm the Postgres tests really ran (the `leorna` skill's `go test -json` rule).

## Known, not yours to fix
Three stories each add a migration 24 (901y `000024_pack_item_order`, sibling worktrees 86bcm902a `000024_quick_starts`, 86bcm901r `000024_starter_packs`); 901r also calls the old four-argument `insertVersionItems`. Review 1 recorded how the hand-over finisher renumbers. Report it only if you find something review 1 missed.

## Boundaries
- Change nothing in the worktree: no edits, commits, pushes, merges or ClickUp writes. Probes and mutations go through `go test -overlay` or your own detached copy (`git -C <worktree> worktree add --detach ~/.cache/86bcm901y-review2/<name> <sha>`), removed with `git worktree remove --force` on that exact path. **Never run `git worktree prune`** (it drops other stories' entries).
- Write only in `~/.hermes/plans/leorna/evidence/86bcm901y/review2/` (create it) and your own scratch. Scratch: a fresh `<scratchpad>/86bcm901y-review2/` (`mkdir` without `-p`) for small files; `/tmp` is a small shared RAM tmpfs, so Go `TMPDIR`, binaries, Chrome profiles and detached copies go in `~/.cache/86bcm901y-review2/`. Remove only those folders, by their literal absolute paths, and drop your DBs at the end.
- Never touch other stories' worktrees, branches, DBs or evidence. The client repo `~/Leorna/leorna-client` is read-only.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem outside this story's diff, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, r1_closure[{id, closed: yes|no, evidence}], findings[{id, severity: critical|major|minor|nit, introduced: yes|no, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{gate, exit, log}], defect_loop_skills[], found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
