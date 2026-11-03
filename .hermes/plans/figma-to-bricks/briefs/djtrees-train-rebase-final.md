# Role: TRAIN REBASER — move DJ cars 7–12 onto the new local main (after the importer's merges)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it (djtrees-common.md:
machine rules, fonts as `data:` URLs with a load check, ticks as a JSON string, bounded mutation runs, never end your
turn to wait).

The train (local branches, each car an ancestor of the next) sits on `f425e79` (DJ car 6). Local `main` has since moved:
Build 2026-11-02.3 (`b09727f`) and the website importer's wave 1 + web panel (root gives you main's SHA in your prompt;
read `git rev-parse main` and check it equals that). Move the whole chain onto it, one car at a time, with `--onto`:

| car | job | branch (old head) | E |
|---|---|---|---|
| 7 | djtrees-stack-gaps | `train-stack-gaps` (`9599c9e`) | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps` |
| 8 | djtrees-stack-lines | `train-stack-lines` (`d2c5899`) | `…/djtrees-stack-lines` |
| 9 | djtrees-step-sides | `train-step-sides` (`a8bef6c`) | `…/djtrees-step-sides` |
| 10 | djtrees-side-art | `train-side-art` (`f154d91`) | `…/djtrees-side-art` |
| 11 | djtrees-faq-art | `train-faq-art` (`80ab742`) | `…/djtrees-faq-art` |
| 12 | djtrees-phone-menu | `train-phone-menu` (`27164d0`) | `…/djtrees-phone-menu` |

- Car 7: `git rebase --onto <main> f425e79 <car 7 old head>`; car N: `git rebase --onto <new car N−1> <old car N−1> <old
  car N>`. Move each `train-*` branch to its new head (`git branch -f`). Never rebase the whole chain with a plain
  `git rebase` (it replays earlier cars' commits again).
- Expected conflicts: `docs/HANDOFF.md` (each car's section on top, keep every section and check-list entry, the
  importer's included; the Build .3 heading and the four ledger renames stay as main has them), `src/core/adapt/rules/
  index.ts` (keep every rule in both sides' order). Anything in source or tests: merge by meaning; never weaken an
  approved AC test; if two approved ACs contradict, stop and report the pair.
- Gates per car against its new target (main for car 7, the previous new car otherwise): `npm run check` by name; its
  plan's AC tests by name (`ok` line, `# pass` ≥ 1, browser `skipped 0`); its real-file receipts, ticks off and on;
  0 rule collisions on the six real files; and the value-by-value check that the car's change equals its pre-move change
  (explain any difference). For the importer's merged code, also confirm its own tests stay green at the last car.
- Per job: `E/rebase/` (move the old one to `E/rebase-train-f425e79/` first) with `conflicts.md`, logs, replay diff.

## Return

Per car: old head, new head (full SHA), branch, target, pure or not, conflicts and resolutions, gates. Then `found_else`
and `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
