# Role: BUILDER — djtrees-strip-edge (DJ Trees designer note 12, desktop; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks; note its Chrome wrapper line) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `1d2645ba7d2b7e4765ba694671f03dabc2cd20e5`
  on branch `worktree-agent-ab5230f33934f89c0` (adds `docs/plans/2026-11-02-djtrees-strip-edge.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 1d2645ba7d2b7e4765ba694671f03dabc2cd20e5`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes, spike and shots: `E/planner/` (`scripts/probe.ts`, `spike.ts`, `paths.ts`, `scan.cjs`,
  `figma-crop.ts`, `chrome-wrap.sh`; they take `F2B_REPO` for your copy; `spike-*` was a CSS injection, diagnostic
  only). Showcase cards fade in: wait ~2.5s after scrolling before a shot.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-strip-edge/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role. 2. `engineering-best-practices`.
3. `test-driven-development`. 4. `mutation-testing-discipline` for the which-strips guards (AC5's mutants: drop the
   clip, paint or column-span checks, each must fail). 5. `systematic-debugging` when a test fails unexpectedly or a
   byte-identity check moves.

## Approved answers

Q1–Q4 ⭐A (Justin: "whatever the planner agent recommends go with it"). This replaces the 30.7 ruling "The track stays
clipped at its own box" (HANDOFF "DJ Trees homepage carousels"): say so in your HANDOFF section. AC1–AC6 by
test/receipt, AC7 live (3cu: re-paste, Regenerate code signatures, Purge All).

## Running beside you

djtrees-panel-edge (note 1) is being built in `style/classes.ts`, `style/edge-photo.ts`, `style/wide.ts`: no overlap
with your two files; don't touch theirs.

## Done means

AC1–AC6 proven by their named tests/receipts (names exactly as the plan's lines); `npm run check` green; the existing
1440 strips test unchanged and passing; the new browser and unit tests green with `skipped 0`; the five other real
files byte-identical; DJ Trees `bricks.json` differs only in the two strips' `_cssCustom` (and their sections'
overflow if the plan says so); HANDOFF section with paste check **3cu**; ledger committed; worktree clean; status
`ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (services and resources strips
at 1280, 1440, 1920), `found_else`, `skill_lessons`. Mini: stop with `stop_reason: escalate to full` if it needs more
than ~3 source files or a decision the plan didn't settle.
