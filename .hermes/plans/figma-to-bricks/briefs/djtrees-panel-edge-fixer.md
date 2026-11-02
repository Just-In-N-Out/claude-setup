# Role: FIXER + REBASER — djtrees-panel-edge (DJ Trees designer note 1; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` and follow them.

Justin's chain: one review; a fixer fixes its P0–P2; then one verification (no second review). Fix the P2 below
test-first, then rebase the job onto the newest local `main`. Leave the P3s (in `E/follow-ups.md`).

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-panel-edge`; write `E/fixer/` and `E/rebase/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` with its probes
  (`probes.log` INNERROUND/ROUND/GROUPROUND, `probes/`, `mutants.log`).
- Job head `4ec8614aaef638f4359d712502291cdf99010f90` on branch `worktree-agent-a270eaf5b45b4d563`. **Task 0:** in your
  own worktree, `git reset --hard 4ec8614aaef638f4359d712502291cdf99010f90`. Base `1aef12f`.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-panel-edge/progress.md`.

## Skills

`receiving-code-review` (verify first), the project skill (FIXER role), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (re-run the builder's mutants for every function you touch).

## The finding

**R1-1 · P2 · `src/core/style/wide.ts:90`:** `reach()` swaps an opened panel's `overflow: hidden` for a rectangular
`clip-path: inset(...)` with no `round`, inside `@media (min-width: 1440px)` (1440 included). A clipping panel with
rounded corners whose covering photo/drawing grows no longer cuts that layer to its corners, from the design width up
(where the plan says nothing changes) — also 31.2's grouped photo in a rounded clipping group. Chrome: corner pixels
show the covering picture on head where base shows the band photo/backdrop (inner corners 32px, all-round 40px,
grouped photo radius 32; at 1440 and 1920). Scenario: a clip-content panel with rounded inner corners against the
section's right side, filled by a photo layer: square corners from 1440 up. Fix direction: carry the panel's radii into
the inset (`inset(… round …)`, per corner), and add a pixel check on rounded variants at 1440 and 1920 (corner pixel
equals base's).

## Then rebase

After the fix is committed and green, rebase onto local `main` per djtrees-rebase-common.md (main has
djtrees-phone-headline and maybe more; conflicts by meaning, `E/rebase/conflicts.md`; gates on the rebased head:
`npm run check`, the plan's AC tests by name, the AC8/AC9 receipt scripts).

## Return

`status` (`ready-for-verification` | `stopped`), `worktree`, `branch`, the fix commit, the rebased head (full SHA),
main's SHA, `pure` or the conflicts and resolutions, the finding's outcome, gates, `found_else`, `skill_lessons`. End with
`MAIN SESSION: check and save these skill_lessons now.`
