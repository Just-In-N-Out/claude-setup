# Role: FIXER — djtrees-step-sides (DJ Trees designer note 7; after the one review)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it.

Justin's chain: one review; a fixer fixes its P0–P2; then one verification (no second review). Fix the P2 below
test-first. Leave the P3s (in `E/follow-ups.md`). Don't rebase: stop at your committed fix; root places the job in the
merge train (where it must also fit djtrees-stack-lines and djtrees-stack-gaps).

**Load: the computer crashed twice under load. One Chrome at a time; before a browser run wait until no other
`node --test … test/browser` process is running.**

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-step-sides`; you write in `E/fixer/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` and probes
  `E/review-1/probes/` (`laptop.ts`, `laptop-*.json`, `laptop-p1both-1024-{head,base}.png`).
- Job head `2334846865b06935215cf62c95a5ec51d3a90c90` on branch `worktree-agent-a679766c7d46e51f2`. **Task 0:** in your
  own worktree, `git reset --hard 2334846865b06935215cf62c95a5ec51d3a90c90`. Base `1aef12f`. Commit on your branch.
- Ledger: append a "Review 1 fix" section to `.superpowers/sdd/2026-11-02-djtrees-step-sides/progress.md`.

## Skills

`receiving-code-review` (verify first), the project skill (FIXER role), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (re-run the builder's mutants for the functions you touch).

## The finding

**R1-1 · P2 · `src/core/adapt/rules/space.ts:103`:** laptops change for steps under a line when the row breaks at
tablets. `divided.ts:50` makes such a row a divided row, `sides.ts:116-117` evens every item's left/right to the row's
smallest side (0) at `tablet_portrait`, and `space.ramp`'s laptop slide (`slide(d, trail[0].shown)`) then slides every
side ≥ 40px from its drawn value to that evened 0 between 1439 and 992 while the steps are still side by side. Chrome:
two top-lined steps with 40px inner padding, stacking from 991: base keeps 80px between the paragraphs at every
laptop width; head gives 66.8 at 1366, 19.3 at 1100, 5.7 at 1024, 0 at 992 (nothing between the columns: the lines are
on top). The plan says desktop and the fluid tier are unchanged. DJ Trees isn't affected (its Steps row stays one line
through 767). Fix so laptops keep the drawn sides wherever the row is still on one line (e.g. the fluid slide reads
the plain tablet step for sides this rule evens, or the evening writes only from the tier where the row breaks and the
fluid tier is written back explicitly) — pick the general one, say why, and add a test asserting each item's desktop
`_padding` (the fluid clamp) equals its drawn value for a top-lined row that breaks at tablets, plus a Chrome check at
1024/1100 against base.

## Done means

The finding fixed (or rejected with evidence) with tests that fail on `2334846` and pass on your head; every AC's test
still passes; `npm run check` green; the six real files (ticks off and on as a JSON string) differ from base only as
AC7/AC8 allow; committed; worktree clean; status `ready-for-verification`.

## Return

`status`, `worktree`, `branch`, `last_commit` (full SHA), commits, files changed, the finding's outcome, gates,
`found_else`, `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
