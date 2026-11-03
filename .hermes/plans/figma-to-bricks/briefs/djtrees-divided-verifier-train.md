# Role: VERIFIER — the divided-row cars (merge-train cars 7, 8, 9) — one car per agent

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it (it points to
djtrees-common.md: Chrome, fonts, ticks as a JSON string, bounded mutation runs, never end your turn to wait). Your
prompt names your car. Prove every AC of YOUR job on its train head against its base, judge the rebase (report-only),
and check the extra points for your car below. Use your own worktree, detached at the head, as `ac-check --repo`.

| car | job | head | base (previous car) | old reviewed head (job base `1aef12f`) | E | live AC |
|---|---|---|---|---|---|---|
| 7 | djtrees-stack-gaps | `9599c9e7418adc9b9fa39e550c58baf2b0c5e1c0` | `f425e79c52eef094b94033ad96fbbae0705d8a50` | `8a6deac6ec9a86ca9764afce620ed234af44955e` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps` | AC9 (3cr) |
| 8 | djtrees-stack-lines | `d2c58998f57de1d7404378e35354c139e314de40` | `9599c9e7418adc9b9fa39e550c58baf2b0c5e1c0` | `d0c373a6aec90cc3f8e639fd6971e9516a69211d` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines` | AC8 (3co) |
| 9 | djtrees-step-sides | `a8bef6c2b3bb227a39d385eb8d33f7b6e68e5bed` | `d2c58998f57de1d7404378e35354c139e314de40` | `530d1cad5a090e246e628069c7a4e18714c5ac05` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-step-sides` | AC9 (3cp) |

Write `E/verifier/` fresh (move an older `E/verifier/` to `E/verifier-pre-train/` first). Approved plan: `E/plan-approved.md`.
The rebase notes are in each `E/rebase/conflicts.md`.

## Extra checks per car

- **Car 7 (stack-gaps):** a HANDOFF-only rebase (`git range-diff 1aef12f..<old> <base>..<head>`). Also judge the
  rebaser's found_else (now in `E/follow-ups.md`): the top/bottom evening reaching a zigzag photo/words pair split by a
  line. Is that a P2 a real design hits (say which), or P3?
- **Car 8 (stack-lines):** the rebase merged real source and test conflicts plus ONE merge commit on top (comments in
  source; test edits). Judge each resolution by meaning (`E/rebase/conflicts.md`, `merge-mutants.log`): the R1-3 choice
  (each lower point keeps its own top on an across tier), and especially the merge commit's edits to **stack-gaps'** AC2
  and AC3 tests (flat-line variants now assert the merged rule; gradient-line variants keep every original assertion)
  and stack-lines' AC4 controls (`stacked: "0"`). Re-run stack-gaps' plan AC tests (its `plan-approved.md`) on this
  head too: say whether each stack-gaps AC as approved still holds here, and whether any approved AC test was weakened.
- **Car 9 (step-sides):** the merge commit adds source guards from the reviewers (`rows.ts` `div?.edge ? lineGap(...)
  : dividedRowGap(...)`, `sides.ts` `alone()` `&& (!vertical(side) || div!.d.edge === null)`, `acrossLines` explicit
  `div.edge` return, plus a pinning test). Prove each guard is needed (mutants), and re-run stack-gaps' and
  stack-lines' plan AC tests on this head: all three jobs' approved ACs must hold at the train tip.

Return verdict, `ac_status` per AC of your job, the extra checks, new P0–P2 findings (P3s listed), and `skill_lessons`;
end with `MAIN SESSION: check and save these skill_lessons now.`
