# Role: BUILDER — djtrees-phone-headline (DJ Trees designer note 11, phones; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-headline`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commit `8e96cbbbb0ce681403ac0c138ccb852769ea2a5f`
  on branch `worktree-agent-a296e9ec92299c7cd` (adds `docs/plans/2026-11-02-djtrees-phone-headline.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 8e96cbbbb0ce681403ac0c138ccb852769ea2a5f`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's prototype, probes and shots: `E/planner/` (`replay-diff.ts`, `measure.ts`, `probe/diff-021.txt` = the
  expected payload diff, `probe/unit-{base,probe}.log`, `blast/scan.txt`, `options-preview.png`). Measure with the real
  Big Shoulders Display font as the planner did.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-phone-headline/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role. 2. `engineering-best-practices`.
3. `test-driven-development`. 4. `mutation-testing-discipline` for the which-texts guards (AC4's controls and AC2's
   one-word/tablet exclusions must each fail with their guard removed). 5. `systematic-debugging` when a test fails
   unexpectedly or the payload diff differs from the planner's expected diff.

## Approved answers

Q1 ⭐A (72/93), Q2 ⭐A, Q3 ⭐A (hero included) (Justin: "whatever the planner agent recommends go with it").
AC1–AC7 by test/check, AC8 live (3ct).

## Running beside you

djtrees-storm-photo and djtrees-side-art each add one line to `src/core/adapt/rules/index.ts`; keep yours one line too.
Rule order matters (`RULES` runs in order; an overriding rule comes after the one it overrides and lists it in
`overrides`).

## Done means

AC1–AC7 proven by their named tests/checks (names exactly as the plan's lines); `npm run check` green with every
existing test unedited; DJ Trees diff exactly the expected `_typography` changes, the other five files only
`line-height: "1"` entries (GRO none); HANDOFF section with paste check **3ct** (and the 768 four-line heading under
"Deferred"); ledger committed; worktree clean; status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (closing heading at 320, 390,
479, 768; hero at 390), `found_else`, `skill_lessons`. Mini: stop with `stop_reason: escalate to full` if it needs
more than ~3 source files or a decision the plan didn't settle.
