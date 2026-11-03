# Role: TRAIN REBASER — djtrees-phone-menu (merge-train car 12)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it (it points to
djtrees-common.md: machine rules, Chrome, fonts as `data:` URLs with a load check, ticks as a JSON string, bounded
mutation runs: never `assert.deepEqual` whole IR trees, never end your turn to wait).

| car | job | job head (review-2 MOVE ON) | E | target |
|---|---|---|---|---|
| 12 | djtrees-phone-menu | `594be2685ac3970f0da516aa90230a9957eb4b83` (branch `worktree-agent-a27c25d81789a14c0`) | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu` | car 11 tip: `git rev-parse train-faq-art` (`80ab7429…`; cars 7–11 on main `f425e79`) |

- Job base `1aef12f`: rebase with `git rebase --onto <target> 1aef12f 594be26`, then create local branch
  `train-phone-menu` at the new head. If `train-faq-art` moves while you work, redo with `--onto` and say so.
- This is the largest job (38 files). Expect overlaps with what landed below it since `1aef12f`: `src/core/adapt/rules/index.ts`
  (RULES order: keep every rule, `navigation.menu` where its plan put it), `rules/phone.ts` (`phone.swap`; storm-photo's
  `photo.stack`, cta-center's `cta.center`), `adapt/layout.ts`, `adapt/kinds.ts`, `style/style.ts` and `style/paint.ts`
  (faint-picture, panel-edge, strip-edge edits), `emit/elements.ts`, `understand/understand.ts`/`phone.ts`, the header
  and navigation tests, `test/browser/render.ts`/`chrome.ts`, `docs/HANDOFF.md` (job section on top, keep all; 3ck on
  top) and `reference/bricks/README.md`. Merge by meaning; never weaken an approved AC test of any job. If two approved
  ACs contradict, stop and report the exact pair.
- **Rule collisions:** run the six real files' collision check, ticks off and on. If `navigation.menu` (or the frosted
  bar move) and a rule from cars 1–11 write the same node/tier/property, settle it as rebase-common says (`overrides` on
  the later rule, proven by unchanged payload hashes and a mutant), or stop and report if the meanings differ.
- Gates against the target: `npm run check` by name; the plan's AC tests by name (AC3/AC4/AC6 are Chrome; plus the
  frost tests), `skipped 0`; the AC8 DJ Trees receipt (fonts loaded); the blast-radius witness (six real files plus
  fixtures, ticks off and on; switch off = target byte for byte); the other DJ jobs' AC tests that share files with you
  still green (storm-photo, cta-center, strip-edge, panel-edge, side-art, faq-art).
- Write `E/rebase/` (move an older one to `E/rebase-pre-train/` first): `conflicts.md`, logs, replay diff vs target.

## Return

Old head, new head (full SHA), branch, target (full SHA), pure or not, conflicts and resolutions (source ones in
detail), gates. Then `found_else` and `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
