# Role: BUILDER — djtrees-faint-picture (job 13, all widths; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks; note its Chrome wrapper line) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faint-picture`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `d0a9447fba2fd992b5656971a6f786cc594acd6e`
  on branch `worktree-agent-adb3a0238cfd712cd` (adds `docs/plans/2026-11-02-djtrees-faint-picture.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only d0a9447fba2fd992b5656971a6f786cc594acd6e`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's prototype and probes: `E/planner/` (`prototype/prototype.diff` and `ac-probe-*.log` = the planner's trial,
  diagnostic only; `scripts/`, `witness-prototype.log`, `live-*.log`, `before/`).
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-faint-picture/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role. 2. `engineering-best-practices`.
3. `test-driven-development`. 4. `mutation-testing-discipline` for the plain-vs-render guard in `pictureBake` (AC2 and
   AC4's controls must each fail with it removed). 5. `systematic-debugging` when a test fails unexpectedly or the
   witness moves outside the FAQ tree.

## Approved answers

Q1–Q5 ⭐A (Justin: "whatever the planner agent recommends go with it"); Q3's faded box background is a follow-up
(HANDOFF "Deferred", with found_else F1–F3). AC1–AC6 by test/receipt, AC7 live (3cv).

## Done means

AC1–AC6 proven by their named tests/receipts (names exactly as the plan's lines); `npm run check` green with every
existing test unedited; across the six real files in both picture modes only DJ's FAQ tree differs, only by
`_opacity`; HANDOFF section with paste check **3cv**; ledger committed; worktree clean; status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (the FAQ tree at 1440 and 390),
`found_else`, `skill_lessons`. Mini: stop with `stop_reason: escalate to full` if it needs a decision the plan didn't
settle.
