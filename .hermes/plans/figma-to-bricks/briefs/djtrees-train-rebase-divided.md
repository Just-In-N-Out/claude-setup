# Role: TRAIN REBASER — the divided-row jobs (merge-train cars 7 and 8; car 9 later)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it. You build a
chain on top of the current train tip. These jobs all edit the same divided-row code
(`src/core/adapt/divided.ts`, `src/core/adapt/sides.ts`, `src/core/adapt/rules/rows.ts`, `test/unit/adapt-rows.test.ts`,
`test/browser/divided-rules.test.ts`), so expect real source conflicts and merge them **by meaning**, using the exact
guards their reviewers worked out.

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** before every browser test or Chrome probe wait
until no `node --test.*test/(browser|web)` and no `chrome-linux64/chrome.*--headless` process runs (check from a script
file). One Chrome job at a time.

| car | job | job head (reviewed/fixed) | E | target |
|---|---|---|---|---|
| 7 | djtrees-stack-gaps | `8a6deac6ec9a86ca9764afce620ed234af44955e` (review-1 clean) | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps` | train car 6 tip: `git rev-parse train-panel-edge` (`f425e79c…`, djtrees-panel-edge on cars 3–5 on main `9a2a9667`) |
| 8 | djtrees-stack-lines | `d0c373a6aec90cc3f8e639fd6971e9516a69211d` (review fixed, verifier P2 fixed) | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines` | car 7's new head |

(Car 9, djtrees-step-sides, is still being fixed; root sends it later.)

- Branches: `train-stack-gaps`, `train-stack-lines` (local only).
- **Guards to apply where the jobs meet** (read both jobs' plans and these notes before resolving):
  - `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps/follow-ups.md` R1-3 (stack-gaps × stack-lines: `drawAcross`
    should step the evened top (`evenedSide(div, "top")`) or keep each point's own top per stack-lines' approved rule —
    pick the one that keeps BOTH jobs' approved ACs true and say why; limit stack-gaps' AC1–AC3 assertions to tiers
    without an across line only if a test needs it; stack-lines' "divider missing" control expects
    `max(0, S − top − bottom)`), and R1-4 (step-sides guards, for car 9 later).
  - `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines/follow-ups.md` R1-6 (`acrossLines` must refuse
    `Divided.edge` rows once step-sides lands: car 9).
  - Every test of both jobs must stay green with its approved meaning; never weaken an AC test to make a merge pass.
    If two approved ACs truly contradict, stop and report the exact pair.
- Gates per car against its target: `npm run check` by name; both jobs' plan AC tests by name; each job's real-file
  receipts (`E/builder/replay-check.ts`, `E/builder/byte-identity.ts` or their equivalents) against the target, ticks
  off and on (`s.site = JSON.stringify({header: true, footer: true})`); 0 rule collisions on the six real files.
- `E/rebase/conflicts.md` per job: every conflict, how it was resolved, and which approved AC each resolution protects.

## Return

Per car: old head, new head (full SHA), branch, target, conflicts and resolutions (source ones in detail), gates.
Then `found_else` and `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
