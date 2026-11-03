# Role: TRAIN REBASER — djtrees-side-art (merge-train car 10)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it (it points to
djtrees-common.md: machine rules, Chrome, fonts, ticks as a JSON string, never end your turn to wait).

| car | job | job head (reviewed, clean) | E | target |
|---|---|---|---|---|
| 10 | djtrees-side-art | `e1dc5a6` (`git rev-parse e1dc5a6`; review-2 MOVE ON, branch of worktree `agent-ab2c6eb04d077d512`) | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art` | train car 9 tip: `git rev-parse train-step-sides` (djtrees-step-sides on stack-lines on stack-gaps on cars 3–6 on main `9a2a9667`) |

- Job base: `1aef12f` (its commits are `1aef12f..e1dc5a6`). Rebase with `git rebase --onto <target> 1aef12f e1dc5a6`, then
  create local branch `train-side-art` at the new head.
- **If `train-step-sides` moves while you work** (the divided-row rebaser is still finishing its gates), redo onto the
  new tip with `git rebase --onto <new tip> <old tip> train-side-art` and say so.
- Expected overlaps: `src/core/adapt/rules/index.ts` (RULES order: keep both jobs' rules, each where its own plan put it
  relative to the rules it overrides), `docs/HANDOFF.md` (job section on top, keep all), the check list (3cm on top),
  maybe `src/core/adapt/rules/section-top.ts` / `art.ts` vs the divided-row files (`rows.ts`, `sides.ts`, `divided.ts`).
  Merge by meaning; never weaken an approved AC test of either job. If two approved ACs contradict, stop and report
  the exact pair.
- Gates against the target: `npm run check` by name; side-art's plan AC tests by name (`E/plan-approved.md`; AC7 is
  Chrome: take it with the Chrome rule in djtrees-common); the AC8 receipt `E/builder/replay-check.ts` (or its
  equivalent) and the AC9 witness against the target, ticks off and on; 0 rule collisions on the six real files.
- Write `E/rebase/` fresh (move an older `E/rebase/` to `E/rebase-pre-train/` first): `conflicts.md` with every
  conflict, its resolution and the approved AC it protects; logs; replay diff vs target.

## Return

Old head, new head (full SHA), branch, target (full SHA), pure or not, conflicts and resolutions (source ones in detail),
gates. Then `found_else` and `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
