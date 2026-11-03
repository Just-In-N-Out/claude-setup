# Role: TRAIN REBASER — djtrees-faq-art (merge-train car 11)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it (it points to
djtrees-common.md: machine rules, Chrome, fonts as `data:` URLs with a load check, ticks as a JSON string, bounded
mutation runs, never end your turn to wait).

| car | job | job head (reviewed, fixed) | E | target |
|---|---|---|---|---|
| 11 | djtrees-faq-art | `0806bf6213889a2d73a141db51fef9629ac39cdf` (review-1 P2s fixed by the fixer; branch `worktree-agent-a33949230d41747b6`) | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-faq-art` | car 10 tip: `git rev-parse train-side-art` (`f154d916…`, side-art rebased onto cars 7–9 on main `f425e79`) |

- The job was built on side-art's pre-train head `e1dc5a6912f7d15c9505148651bc4bc7974f7c84`: its own commits are
  `e1dc5a6..0806bf6`. Rebase with `git rebase --onto <target> e1dc5a6 0806bf6`, then create local branch
  `train-faq-art` at the new head. If `train-side-art` moves while you work, redo with `--onto` and say so.
- Expected overlaps: `src/core/understand/compose.ts`, `src/core/adapt/rules/art.ts`, `test/browser/side-art.test.ts`,
  `test/unit/understand-compose.test.ts`, `test/unit/adapt-art-beside.test.ts` (side-art's train merge commit tightened
  its AC5 test line to `_opacity === "0.24"` and no `_opacity:<tier>` key; faint-picture now writes `_opacity` on faded
  pictures, so faq-art's tests and receipts may need the same reading), `docs/HANDOFF.md` (job section on top, keep all;
  check list 3cs on top). Merge by meaning; never weaken an approved AC test of either job. If two approved ACs
  contradict, stop and report the exact pair.
- **Faint-picture is merged below you now:** the FAQ tree has `_opacity` "0.22". faq-art's AC5 receipt and check 3cs
  (step about the tree's look) assumed it might not be: keep their meaning, and report any receipt clause the faint fix
  changes.
- Gates against the target: `npm run check` by name; faq-art's plan AC tests by name (`E/plan-approved.md`; AC4 is
  Chrome); the AC5 replay check and AC6 witness against the target, ticks off and on (fonts loaded, status checked);
  side-art's AC tests still green; 0 rule collisions on the six real files.
- Write `E/rebase/` (move an older one to `E/rebase-pre-train/` first): `conflicts.md`, logs, replay diff vs target.

## Return

Old head, new head (full SHA), branch, target (full SHA), pure or not, conflicts and resolutions (source ones in
detail), gates. Then `found_else` and `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
