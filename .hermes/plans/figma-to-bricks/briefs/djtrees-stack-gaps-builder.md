# Role: BUILDER — djtrees-stack-gaps (DJ Trees designer note 9, phones and tablets; Mini pipeline)

Build the approved plan test-first. Don't re-plan. First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md`
(batch rules, git, this machine's checks; note its Chrome wrapper line) and follow it.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps`; you write in `E/builder/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Planner's commits `a33873e`, then
  `b1dbc713d4b9dc4e436fc4bc44c3280538fe7e57` on branch `worktree-agent-a896112426e93f3be` (add
  `docs/plans/2026-11-02-djtrees-stack-gaps.md` on `1aef12f`).
- **Task 0:** in your own worktree, `git merge --ff-only b1dbc713d4b9dc4e436fc4bc44c3280538fe7e57`; check the plan file
  equals `E/plan-approved.md`. Base: `1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e`.
- Planner's probes, simulations and shots: `E/planner/` (`work/`, `blast-radius.txt`, `replay-before-*`, `live-before-*`,
  `sim-*`). On this 16.7k-px page, `screenshot({clip})` can hang: scroll into view and take a viewport shot.
- Ledger: `.superpowers/sdd/2026-11-02-djtrees-stack-gaps/progress.md` in your worktree (committed).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role (and
   `references/rules-summary.md`). 2. `engineering-best-practices`. 3. `test-driven-development`.
4. `mutation-testing-discipline` for the which-rows guard (AC4's controls must fail with it removed).
5. `systematic-debugging` when a test fails unexpectedly or a byte-identity check moves.

## Approved answers

Q1–Q3 ⭐A (Justin: "whatever the planner agent recommends go with it"). AC1–AC8 by test/receipt, AC9 live (3cr).

## Running beside you (same files: expect rebase conflicts, keep changes named)

djtrees-step-sides (note 7: `Divided.edge` rows, stacked `_rowGap` midway rule, `STACK_MIN_GAP` 16) and
djtrees-stack-lines (note 6: a made across line at stacked tiers, items' facing padding set equal, row gap 0, written
by `row.reflow`) are being built from `1aef12f` in `divided.ts`/`rules/rows.ts`. Your plan already says how the three
fit: your `ends` evening applies only to rows divided at their sides (`edge === null`); on stack-lines' across tiers its
`row.reflow` padding writes win. Put your logic in named functions and say in a code comment which sibling rule owns
which tiers, so whoever rebases last can merge by meaning.

## Done means

AC1–AC8 proven by their named tests/receipts (names exactly as the plan's lines); `npm run check` green with no
existing test edited; the browser test green with `skipped 0`; hydraulics differs only in `div.wrap`'s `_rowGap`;
GRO, Repairs, brainstorm, Services byte-identical; DJ Trees differs only inside the three divided rows as AC6 says;
HANDOFF section with paste check **3cr** (found_else 1 and 2 under "Deferred"); ledger committed; worktree clean;
status `ready-for-review`.

## Return

`status`, `worktree`, `branch`, `base`, `last_commit` (full SHA), commits, files changed, gates with results,
`ac_evidence[]` (AC id, test name, log, screenshot), before/after shots in `E/builder/` (credentials and highlights at
390, 767, 991), `found_else`, `skill_lessons`. Mini: stop with `stop_reason: escalate to full` if it needs more than
~3 source files or a decision the plan didn't settle.
