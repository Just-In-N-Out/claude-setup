# Role: BUILDER — djtrees-cta-center (DJ Trees designer note 3, phones; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-cta-center`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. The planner's commit is
  `192567fc88e89832dd1b065a388825f26bef7fee` on branch `worktree-agent-a0fa5f312fbf482c6` (adds
  `docs/plans/2026-11-02-djtrees-cta-center.md` on top of `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 192567fc88e89832dd1b065a388825f26bef7fee`; check the plan file
  equals `E/plan-approved.md`. Base for comparisons: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes, before shots and the dry run of the planned rule: `E/planner/` (`scripts/plan-check.ts`,
  `measure.ts`, `live.ts`, `blast2.ts`; `before-replay/`, `before-live/`). Reuse them for AC7/AC8 receipts.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-cta-center/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role.
2. `engineering-best-practices`. 3. `test-driven-development`: a failing test before each code change.
4. `mutation-testing-discipline` for the guards (AC4's hover-layer guard in `cta.ts`; AC6's which-pills guard: each
   negative control must fail with its guard removed). 5. `systematic-debugging` when a test fails unexpectedly or a
   byte-identity/payload-scope check moves.

## Approved answers

Q1 ⭐A (phones only, 767 and down), Q2 ⭐A, Q3 ⭐A (Justin: "whatever the planner agent recommends go with it").
AC1–AC10 by test/receipt, AC11 live (Justin's paste check 3cl). If the golden `test/golden/files/convert-sample.json`
needs regenerating, do it the way the plan says and show the diff is only the expected `:mobile_` keys.

## Done means

AC1–AC10 each proven by its named test or receipt (names exactly as the plan's lines); `npm run check` green; the new
browser test green with `skipped 0`; the full browser suite compared by test name with base (no new failures); other
real files change only in the expected `:mobile_` keys; HANDOFF section with paste check **3cl** (plus the planner's
found_else 1, pills with a wide icon gap not marked as calls to action, under "Deferred"); ledger committed; worktree
clean; status `ready-for-review`.

## Return

`status` (`ready-for-review` | `stopped` with `stop_reason`), `worktree`, `branch`, `base`, `last_commit` (full SHA),
commits, files changed, gates with results, `ac_evidence[]` (AC id, test name, log path, screenshot path),
before/after screenshots in `E/builder/` (buttons at 320, 390, 767), `found_else`, `skill_lessons`. Mini: if the fix
needs more than ~3 source files or a decision the plan didn't settle, stop with `stop_reason: escalate to full`.
