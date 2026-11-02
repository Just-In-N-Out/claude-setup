# Role: BUILDER — djtrees-top-align (DJ Trees designer note 5, phones; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `7df98bc08e9543c6c9b900b8a327f8d2ce6b762c`
  on branch `worktree-agent-a13d146673301e221` (adds `docs/plans/2026-11-02-djtrees-top-align.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 7df98bc08e9543c6c9b900b8a327f8d2ce6b762c`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes, measurements and payload-diff scripts: `E/planner/` (`scripts/`, `pdiff.cjs`, `replay-all.sh`,
  `before*/`; `candidate-probe*/` was the planner's trial of the planned code, diagnostic only).
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-top-align/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role. 2. `engineering-best-practices`.
3. `test-driven-development`. 4. `mutation-testing-discipline` for the narrowed `button()` guard (AC3's painted,
   outlined and side-by-side controls must each fail with the guard removed). 5. `systematic-debugging` when a test
   fails unexpectedly or a byte-identity check moves.

## Approved answers

Q1–Q3 ⭐A (Justin: "whatever the planner agent recommends go with it"). AC1–AC7 by test/receipt, AC8 live (3cn).

## Done means

AC1–AC7 proven by their named tests/receipts (names exactly as the plan's lines); `npm run check` green with every
existing test unedited; the browser test green with `skipped 0`; hydraulics, GRO, Repairs, Services byte-identical,
brainstorm only its one pairs row; DJ Trees only the row's `_alignItems`; HANDOFF section with paste check **3cn**;
ledger committed; worktree clean; status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (the row at 390, 430, 1200),
`found_else`, `skill_lessons`. Mini: stop with `stop_reason: escalate to full` if it needs more than ~3 source files
or a decision the plan didn't settle.
