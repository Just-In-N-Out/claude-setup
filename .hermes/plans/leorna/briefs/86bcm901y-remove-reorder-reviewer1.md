
# REVIEWER 1 (review only) — leorna-control-plane, story 86bcm901y "Remove and reorder items in a pack version"

Role: the first fresh full reviewer of the Full pipeline (`review-fix-cadence`: review 1 → fixer → review 2 → fixer → verifier). You never saw the build. Report only: change nothing.

## What to review
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder`, branch `feat/86bcm901y-remove-reorder`.
- Base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (= GitHub `main` when the build started). Reviewed head **`c574cdd98d68b74bfc8a3c5f997a471193aa3435`** (8 commits, 21 files). Confirm the worktree is still at that head before you start, and name the head you reviewed in your report.
- Review `git diff 6c1709e...c574cdd` against the approved plan `~/.hermes/plans/leorna/evidence/86bcm901y/plan-approved.md` (read-only) and the `leorna` skill's rules.
- The builder's records are in `~/.hermes/plans/leorna/evidence/86bcm901y/` (`INVENTORY.md` with its "Builder rulings", `EVIDENCE.md`, gate logs, screenshots). Treat them as claims to check, not facts: run the gates yourself, try mutations, don't trust summaries.

## The approved story (for judging scope)
Approved 2026-10-29 under Justin's away grant ("just keep everything going and follow what the recommended agent says"): Q1-A (control-plane sync test + read-only run of the client's existing Sync test; no client change), Q2-A (Move up / Move down buttons, each click saves a version), Q3-A (order shows in console and API; Sync unchanged).
- AC1: remove an item → a new version without it, audited. Test `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`.
- AC2: after a removal, engineers' next Sync removes (or flags) the item's files consistently with the lockfile. Test `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`.
- AC3 (Justin): reorder → a new version in the new order, audited, shown in the console list and API, syncing the same files as its parent. Test `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`.
- AC4 (proposed, approved): invalid or forbidden removes and reorders are refused and write nothing. Test `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`.
- Justin asked for the screenshots to **show items being reordered and removed** in the real admin console. Check `ac3-reorder-before/after.png`, `ac1-remove-before/after.png` and the audit captures really show that, and that no domain, URL bar, tenant ID, token or email is visible.

## Skills (load them first and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `mutation-testing-discipline` for your mutation checks, plus the specialists: `security-best-practices`, `multi-tenant-auth-management` (admin-only write route, CSRF, tenant isolation of packs and audit rows), `api-contract-drift-guard` (OpenAPI change, generated code), `backend-data-migrations` (migration 24: `pack_version_items.position`). The last two end with "Mandatory Validation and Agent Defect Loop": you are its independent problem-finder. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Points to look at in particular (not a limit)
- Immutability of versions; ParentVersion; the audit record's actor, action and diff for remove and reorder (and that 901w's audit shape is unchanged for other saves).
- Migration 24: add-only, safe on existing rows (position 0), the CHECK and partial unique index, the down migration, and the merge risk that sibling worktrees 86bcm902a (`000024_quick_starts`) and 86bcm901r (`000024_starter_packs`) also take number 24 (say how the finisher should handle it; don't change anything).
- The new `POST /admin/library/packs/{packId}/items` route: session, admin, CSRF, 4 KiB form limit, tenant scoping, stale-version handling, error pages.
- The `order` field in the JSON API and OpenAPI (additive only; generated code regenerated, `check-generated-contracts` green).
- The builder's three rulings in `INVENTORY.md` and the mutation record `mutations-fd03953.txt` (M3 survives over HTTP and is killed by a unit test; check that claim).
- AC tests: each fails on base for the right reason and proves its whole AC, not just one clause.

## Gates you run yourself
`make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm901y_review1_test` in `leorna-test-pg` (127.0.0.1:55432; read the port with `docker port leorna-test-pg 5432`; never `leorna-pg` on 5432, never the builder's `leorna_86bcm901y_test`), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (the builder's `env.sh.txt` in the evidence folder shows where they are installed), and each AC test by name. Confirm the Postgres tests really ran (the `leorna` skill's `go test -json` rule).

## Boundaries
- Change nothing in the worktree: no edits, commits, pushes, merges or ClickUp writes. Run mutations only in your own detached copy (`git -C <worktree> worktree add --detach ~/.cache/86bcm901y-review1/mut <head>`), and remove it with `git worktree remove --force` on that exact path. **Never run `git worktree prune`** (it drops other stories' entries).
- Write only in `~/.hermes/plans/leorna/evidence/86bcm901y/review1/` (your logs and probes; create it) and your own scratch. Scratch: a fresh `<scratchpad>/86bcm901y-review1/` (`mkdir` without `-p`) for small files; `/tmp` is a small shared RAM tmpfs, so Go `TMPDIR`, binaries, Chrome profiles and the mutation copy go in `~/.cache/86bcm901y-review1/`. Remove only those folders, by their literal absolute paths, and drop your DB at the end.
- Never touch other stories' worktrees, branches, DBs or evidence. The client repo `~/Leorna/leorna-client` is read-only.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem outside this story's diff, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, findings[{id, severity: critical|major|minor|nit, introduced: yes|no, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{gate, exit, log}], defect_loop_skills[], found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
