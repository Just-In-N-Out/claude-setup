# Role: BUILDER — djtrees-panel-edge (DJ Trees designer note 1, desktop; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-panel-edge`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. The planner's commit is
  `14cfa28af6f16cd6aef362c4c055dd9ffba64dab` on branch `worktree-agent-a077b19fead3fb115` (adds
  `docs/plans/2026-11-02-djtrees-panel-edge.md` on top of `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 14cfa28af6f16cd6aef362c4c055dd9ffba64dab`; check the plan
  file equals `E/plan-approved.md`. Base for comparisons: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes and before shots: `E/planner/` (`work/probe-html.ts`, `live-probe.ts`, `scan.ts`, `clip-chrome.ts`,
  Chrome wrappers; `proto/` is a CSS prototype, diagnostic only). The planner found `test/browser/shoot.ts`
  `settleCapture` never settles on the DJ Trees replay; measure without it as the planner did, and say so.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-panel-edge/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role (note its line on
   fixture `frame()` defaulting to `clipsContent: false`: this job's fixtures must clip as Figma does).
2. `engineering-best-practices`. 3. `test-driven-development`: a failing test before each code change.
4. `mutation-testing-discipline` for the recognition guards (AC7's negative controls must each fail with its guard
   removed). 5. `systematic-debugging` when a test fails unexpectedly or a byte-identity check moves.

## Approved answers

Q1 ⭐A, Q2 ⭐A, Q3 ⭐A (Justin: "whatever the planner agent recommends go with it"). AC1–AC10 by test/receipt,
AC11 live (Justin's paste check 3cj).

## Done means

AC1–AC10 each proven by its named test or receipt (names exactly as the plan's lines); `npm run check` green; the new
browser test green with `skipped 0`; full browser suite compared by test name with base (no new failures); the five
other real files byte-identical; DJ Trees diff only in the band's section, panel and drawing; HANDOFF section with
paste check **3cj**; ledger committed; worktree clean; status `ready-for-review`.

## Return

`status` (`ready-for-review` | `stopped` with `stop_reason`), `worktree`, `branch`, `base`, `last_commit` (full SHA),
commits, files changed, gates with results, `ac_evidence[]` (AC id, test name, log path, screenshot path),
before/after screenshots in `E/builder/` (the band at 1440, 1512, 1920), `found_else`, `skill_lessons`. Mini: if the
fix needs more than ~3 source files or a decision the plan didn't settle, stop with `stop_reason: escalate to full`.
