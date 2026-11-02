# Role: BUILDER — djtrees-step-sides (DJ Trees designer note 7, phones; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-step-sides`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. The planner's commits are on branch
  `worktree-agent-aaf95af31490f27d2`: `c440ee1`, then `04858af93457609992260fa643dcbaca7b418db6` (adds
  `docs/plans/2026-11-02-djtrees-step-sides.md` on top of `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only 04858af93457609992260fa643dcbaca7b418db6`, then check the
  plan file there equals `E/plan-approved.md`. Base for every comparison: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`
  (= `git merge-base HEAD main` until main moves).
- Planner's probes, before shots and replay notes: `E/planner/` (its scratch patch was diagnostic, not production).
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-step-sides/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role.
2. `engineering-best-practices`. 3. `test-driven-development`: a failing test before each code change.
4. `mutation-testing-discipline` for the row-kind guards (which rows count as "lined along one edge": negative controls
   in AC5 must fail when a guard is removed). 5. `systematic-debugging` when a test fails unexpectedly or a
   byte-identity check moves where the plan says it mustn't.

## Approved answers

Q1 ⭐A, Q2 ⭐A, Q3 ⭐A (Justin: "whatever the planner agent recommends go with it"). ACs AC1–AC8 by test, AC9 live
(Justin's paste check 3cp).

## Running beside you

djtrees-stack-lines (note 6: a stacked divided row gets a made across line between points) and djtrees-stack-gaps
(note 9) and djtrees-top-align (note 5) likely edit `divided.ts`/`rows.ts` too. Keep your change small and named
(the new divided-row kind, e.g. `edge`), so a later rebase can see it; the shared rule stated in your plan ("a line
between two stacked points sits midway … never under 16px") goes in a code comment and the HANDOFF section.

## Done means

AC1–AC8 each proven by its named test or receipt (test names exactly as the plan's lines), AC9 left for Justin;
`npm run check` green; the plan's browser test green with `skipped 0`; corpus-backed tests compared by name in scratch
trees (head vs base, no new failures); the five other real files byte-identical (payload and warnings); DJ Trees diff
only where the plan says; HANDOFF section with paste check **3cp** and the CLAUDE.md phone-rule wording the finisher
should apply (write it into the HANDOFF section as "CLAUDE.md line for the finisher"; don't edit CLAUDE.md); ledger
committed; worktree clean; status `ready-for-review`.

## Return

`status` (`ready-for-review` | `stopped` with `stop_reason`), `worktree`, `branch`, `base`, `last_commit` (full SHA),
commits list, files changed, gates run with results, `ac_evidence[]` (AC id, test name, log path, screenshot path),
before/after screenshots in `E/builder/`, `found_else`, `skill_lessons`. Mini: if the fix needs more than ~3 source
files or a design decision the plan didn't settle, stop with `stop_reason: escalate to full`.
