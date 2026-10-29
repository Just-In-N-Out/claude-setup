
# BUILDER — leorna-control-plane, story 86bcm901y "Remove and reorder items in a pack version"

Role: BUILDER (Full pipeline). Build the approved plan test-first and stop at `ready-for-review`. Don't re-plan.

## The approved plan
- Plan: `~/.hermes/plans/leorna/86bcm901y-remove-reorder.md`. The read-only approved copy, which `ac-check.sh` reads, is `~/.hermes/plans/leorna/evidence/86bcm901y/plan-approved.md`. Never edit the approved copy.
- Approved 2026-10-29 under Justin's away grant ("just keep everything going and follow what the recommended agent says"): **go** with Q1-A (control-plane sync test plus a read-only run of the client's existing Sync test; no client changes), Q2-A (Move up / Move down buttons, each click saves a version), Q3-A (order shows in the console and API; Sync unchanged). All four ACs approved:
  - AC1: remove an item → a new version without it, audited. Test `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`.
  - AC2: after a removal, engineers' next Sync removes (or flags) the item's files consistently with the lockfile. Test `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`.
  - AC3 (Justin): reorder → a new version in the new order, audited, shown in the console list and API, syncing the same files as its parent. Test `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`.
  - AC4 (proposed, approved): invalid or forbidden removes and reorders are refused and write nothing. Test `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`.
- No AC is `(live)`.

## The ask, and Justin's words
Let an admin remove and reorder a built pack's items. Each change saves a new immutable version with an audit record. A removed item leaves engineers' tools on their next Sync, consistent with the lockfile. Justin added reordering himself and wants **the screenshots to show items being reordered and removed** in the real admin console: before/after captures of the item list for a reorder (`ac3-reorder-before.png` / `ac3-reorder-after.png`) and for a removal (`ac1-remove-before.png` / `ac1-remove-after.png`), plus the audit page, as the plan's evidence section says. Look at every capture yourself and check that it really shows the change (the order visibly differs; the removed item is visibly gone) before you count it.

> Justin's words: "Remove and reorder items in a pack version I want you to go into ClickUp and pick out this user story. I know the acceptance card only says to remove items, but also to reorder items, make sure the photos the agent takes show them changing items and removing items. I won't be on my laptop, so just keep everything going and follow what the recommended agent says."

## Where to work
- Follow the plan's task B0 exactly: check and fast-forward the main checkout's `main` (stop conditions in bold), then create the worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder` on branch `feat/86bcm901y-remove-reorder` from the base (`6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`, or the new `origin/main` if B0.2 allows it). All code changes and commits happen only in that worktree.
- Never switch the main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, their test databases or their evidence folders. Your databases are your own `_test` ones in `leorna-test-pg` (127.0.0.1:55432, read the port with `docker port leorna-test-pg 5432`); never use `leorna-pg` on 5432.
- The client repo `~/Leorna/leorna-client` is read-only. Its Sync e2e test runs only in a scratch clone, as the plan says.
- Commits: `feat(86bcm901y): …`, authored by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or set GIT_AUTHOR/COMMITTER variables, and add no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.

## Skills (load them first and say so)
1. `leorna`, BUILDER role (steps 2–5 and 4b; skip Step 1's full context load beyond what the plan's B0 needs).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each code change. If a test fails unexpectedly or a gate gets worse, use `systematic-debugging` and don't patch around it.
4. `mutation-testing-discipline` for the immutability, permission, CSRF and tenant guards (plan task B10).
5. Specialists the plan's `## Skills` section names: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations` (the last two end with "Mandatory Validation and Agent Defect Loop": you are its implementation agent; the main session runs the problem-finder and verifier, because you can't start agents).

## Gates and evidence
- Run the plan's gates (B12): `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB, `bash ./scripts/test-module-add.sh`, the admin-console UI tests, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, and gitleaks. Confirm Postgres tests really ran (the `leorna` skill's `go test -json` rule: no skip naming `LEORNA_TEST_DATABASE_URL`).
- Evidence goes in `~/.hermes/plans/leorna/evidence/86bcm901y/` (not in its `verifier/` or `auditor/` subfolders): the before-state capture (E0) before any code change, one screenshot per AC, the reorder and removal before/after captures, per-head gate logs `gates-<sha7>.txt`, and an `INVENTORY.md` mapping each AC → test → log → screenshot, plus a "Builder rulings" section.
- Before any capture leaves this machine it must show no server domain, URL bar, tenant ID, token or email (the plan's capture recipe uses headless Chrome with no browser frame; still look at each image).
- Scratch: keep it in your own fresh `<scratchpad>/86bcm901y-builder/` folder (`mkdir` without `-p`, so it fails if it exists) and remove only that folder by its literal absolute path. `/tmp` is a small shared RAM tmpfs here: Go `TMPDIR`, Chrome profiles, built binaries and the base copy go in `~/.cache/86bcm901y-builder/`.
- Leave the worktree committed and clean (`git status --porcelain` empty), because `ac-check.sh` fails any untracked file.

## Rulings and stopping
- You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in INVENTORY.md's "Builder rulings". If the plan is wrong or missing a decision that can't be settled safely within its files, stop with `status: stopped` and list the options; never redesign.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait for one: poll its log in the foreground in waits of under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], worktree, branch, base, last_commit, shots[], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], defect_loop_skills[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
