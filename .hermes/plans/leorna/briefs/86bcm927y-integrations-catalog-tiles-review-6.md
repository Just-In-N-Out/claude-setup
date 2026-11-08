# REVIEWER 6 — DELTA review of the main bring-in, 86bcm927y

Role: fresh pipeline reviewer (Claude Code general-purpose agent, Opus, high), fork_turns none. Report only. No nested agents.

Story: [Integrations catalog - tiles UI in the admin console](https://app.clickup.com/t/86bcm927y)
Worktree (candidate, READ-ONLY): /home/justin/Leorna/86bcm927y-integrations-catalog-tiles, branch feat/86bcm927y-integrations-catalog-tiles
Expected HEAD: 2bc724965a635bfed9c03a4794ffa54132e125a8, a merge commit with parents 0027786 (story head, review-5 full review clean, ALL ACCEPTED 4/4) and c8abbddf7d45099ea4023c42990334056922937e (GitHub main).
New base (merge-base with main): c8abbddf7d45099ea4023c42990334056922937e. Old base: 3aa979df41568c9039007f66d7f32193e66a8533.
Delta: 0027786..2bc7249 (the referee lists 21 commits: main's #108–#111 and the merge).
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y. Own output folder: <evidence root>/review-6/

## What to review
The bring-in, not the whole story again (review-5 covered 3aa979d..0027786 in full). Concretely:
1. The merge itself: the only conflicted, hand-resolved file is `delivery/stories.json` (main's file plus this story's entry appended last). Verify it independently: one-side files equal that side's blob, the set of files differing from both parents is only `stories.json`, the story's own patch survived, and main's 52 entries are unchanged by value. The integrator's receipts are in <evidence root>/integrate-1/ (merge-verify.txt and gate logs). Treat them as inputs, not proof.
2. Interaction between main's new content and the story: main added #109/#110/#111 (86bcm9033 tagged release, including a klauspost/compress bump and a new CI step `python3 -m unittest scripts/test_release.py`) and #108 (86bcx2a3m getting-started docs). Per `leorna` step 7.2: a clean text merge isn't enough when a sibling merged first. Check for semantic clashes: release/version or build changes that affect the story's code, docs (getting-started, READMEs) that now say something false about integrations or the admin console, a same-named helper or changed signature, new rows/content the story's pages read (probe with production startup loads when relevant), migration-number clashes, contract/OpenAPI drift.
3. Run on the exact head in your OWN detached copy (never in the candidate worktree): the four primary AC tests (`TestIntegrationsAC1TilesWithPostgres`, `…AC2ValidateWithPostgres`, `…AC3PackBuilderWithPostgres`, `…AC4AuditWithPostgres`) plus `TestIntegrationAuditRollbackWithPostgres` with `-json` (no skips), `make check` with the pinned linter/govulncheck, `python3 -m unittest scripts/test_release.py`, and anything else the delta needs. Don't repeat broad story gates beyond that without a reason. A couple of focused merge mutants (e.g. drop the story's stories.json entry, or drop one of main's entries) to prove whatever check you rely on can fail.

## Read first
- review-loop.md and ac-verification.md under /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/.
- <evidence root>/plan-approved.md (option B: GitHub/ClickUp configurable; Google informational/unavailable, deferred), plan-approved-v1-original.md, amendment-approval.json.
- review-5/review.json and its P3s (R5-1..R5-3; known, in follow-ups.md; don't re-raise unless the merge changes them).
- /home/justin/.claude/CLAUDE.md, the worktree AGENTS.md, delivery/README.md.

## Skills (Skill tool)
`leorna` first (step 7.2 merge-verification rules especially), then `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `api-contract-drift-guard`, `backend-data-migrations`, `mutation-testing-discipline`. `systematic-debugging` if something fails unexpectedly.

## Constraints
- Review only: no source edits, commits, rebase, push, PR, ClickUp writes, CI edits.
- Others are running: don't touch containers you didn't create, no shared DB resets, no worktree prune, no `git stash`. Own Postgres 18.6 (SCRAM) and ClickHouse fixtures at CI pins, DBs ending `_test`. Don't print credentials; never read /home/justin/.hermes/.env.
- Toolchain /home/justin/.local/leorna-toolchain/go/bin/go (Go 1.27.3) and that bin dir; task-local PATH, on-disk GOCACHE and short TMPDIR, scratch under /home/justin/.hermes/cache/scratch/86bcm927y-review6-<random>/.
- Every test/gate/mutation command under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM / 143 / 137 / "Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it, report it, rerun capped.
- Read-only GitHub checks: use `gh api` (git-guard denies `git -c credential.helper=… ls-remote`).
- Remove your own containers at the end; list the scratch path, don't delete it.

## review.json and self-check
Write <evidence root>/review-6/review.json:
{"round":6,"scope":"delta","from":"00277865b9ac2305a2716ef2cca2dcdf6611285f","head":"2bc724965a635bfed9c03a4794ffa54132e125a8","findings":[...]}
Ids R6-<n>, `severity`, `file_line`, `claim`, a concrete real-use `scenario` (≥5 words) for every P0–P2, `repeats`/`new_fact` for a repeated defect. Severity scale per review-loop.md / CLAUDE.md step 5. Outside-delta observations are P3.
Self-check: /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm927y-integrations-catalog-tiles --base c8abbddf7d45099ea4023c42990334056922937e /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Exit 2 = malformed record, fix it. Exit 0/1/3 is the referee's call.

## Return (text, no prose report files)
One-line verdict; head/from/base; merge-verification results; semantic-clash checks; commands with exits (and skip counts); mutants and outcomes (compile errors don't count); findings; unrun checks; `verdict`, `ac_status` (per AC: rerun vs inherited), `found_else`, review.json path, scratch path, and
skill_lessons[{skill, lesson, evidence, enforce}]: reusable lessons only (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing). Never edit skills or memory yourself. `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind; what it checks; where it runs). An empty list is the normal answer.

End exactly with:
MAIN SESSION: check and save these skill_lessons now.
