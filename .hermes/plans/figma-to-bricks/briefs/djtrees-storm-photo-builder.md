# Role: BUILDER — djtrees-storm-photo (DJ Trees designer note 8, phones and tablets; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-storm-photo`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `0e1a79ddacbedec1c5fac71712e5dc56633958a5`
  on branch `worktree-agent-a357a3a9bf3370792` (adds `docs/plans/2026-11-02-djtrees-storm-photo.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 0e1a79ddacbedec1c5fac71712e5dc56633958a5`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes and shots: `E/planner/` (`scripts/shoot-section.ts`, `scripts/diff-replay.mjs`, `blast.txt`,
  `before-section/`, `live/`). `snap` stalls at 1440 on this file: measure ≥ 992 with fonts + a short delay.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-storm-photo/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role. 2. `engineering-best-practices`.
3. `test-driven-development`. 4. `mutation-testing-discipline` for the which-sections guard (AC7's negative controls
   must each fail with their guard removed). 5. `systematic-debugging` when a test fails unexpectedly or a replay diff
   moves outside the storm section.

## Approved answers

Q1–Q8 ⭐A (Justin: "whatever the planner agent recommends go with it"). The planner judged 1 new file + 4 small edits
still Mini; keep it to that. AC1–AC11 by test/receipt, AC12 live (3cq).

## Running beside you

djtrees-side-art (note 4) adds rules to `src/core/adapt/rules/index.ts` too, and edits `unpin.ts`/`compose.ts`;
djtrees-panel-edge edits `style/edge-photo.ts`/`style/wide.ts`. Keep your `RULES` entry a single line so a rebase
merges cleanly.

## Done means

AC1–AC11 proven by their named tests/receipts (names exactly as the plan's lines); `npm run check` green; the browser
tests green with `skipped 0`; replays of the other real files byte-identical, DJ Trees differing only in the storm
section and its Container; nothing changes from 992 up; HANDOFF section with paste check **3cq** (and the planner's
found_else items under "Deferred"); ledger committed; worktree clean; status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (storm section at 390, 767,
991, 1440), `found_else`, `skill_lessons`. Stop with `stop_reason: escalate to full` if it grows past the plan's files
or needs a decision the plan didn't settle.
