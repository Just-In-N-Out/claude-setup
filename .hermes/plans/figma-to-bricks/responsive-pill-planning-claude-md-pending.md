# responsive-pill-planning — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release: **2026-10-22.5**, pushed commit **b4ed333**; paste check **3ba owed**.

**Apply after the older ones, in build order**, through `media-rename-collision-claude-md-pending.md` (2026-10-22.4). Main CLAUDE's build line is still behind main (many older `*-claude-md-pending.md` files are unapplied), so **none of these edits landed or was attempted**. No retry, terminal/execute_code bypass or main-chat alternative route. Keep this file pending until every section lands by a permitted path. Build line goes last.

## Edit 1 — Start here: insert after the 22.4 Media rename collision bullet

```text
- **Alike pills share their sides (22.5, responsive-pill-planning):** alike buttons side by side in one row (wrapping
  or not; buttonLike, same role, same drawn and styled left/right; never divided-row items, list title/record cells
  or cards) show one side padding, each side the smallest of theirs, in the plan and in one CSS clamp per side
  (`sides.ts peersOf`/`peerPhoneSide`: per slot `(S − largest need)/2`, plus fixed-width peers' smallest
  `(width − need)/2`). `least` and every row/grid/ALONE input unchanged (drawn view gets no peers; zero
  least/row/column deltas on 7 files). G1 — my ruling, not yet confirmed: a hug box judges the L1A phone guard by
  its parent's slot (at the smallest phone by its slot there), not by min(drawn, slot); fixed/fill unchanged.
  Fresh Opus xhigh review approve-with-minors; R1 tests and R2 (payload-neutral, 7 files byte-identical) fixed.
  Wrapped-row least stays deferred (W-B, Justin's call). HANDOFF "Alike pills share their sides"; check 3ba owed.
```

## Edit 2 — Where things stand: append after 22.4, preserving all earlier entries

```text
- **Alike pills share their sides** (build `2026-10-22.5`; plan/ledger `docs/plans/2026-10-21-responsive-pill-planning*.md`):
  F3 A peer sides in `adapt/sides.ts`; `layout.ts` sets every flowing child's room/width/phone slot before visiting
  (pre-pass, same values) and exposes `phone(n)`; `least.ts` plan view passes peers/room/slot only (no change to
  least/content/reading/button/floored); `rules/space.ts` view supplies them. Only `_padding:mobile_portrait`
  changes on 40 elements across the corpus, debug copy and inspo; Chrome 1440→320: page heights and scroll widths
  identical, nothing at ≥992. Gates on main .4 + branch: check 2112/2112 + 6/6, browser 244/244, corpus worse list
  equal to main's (gro Yellowtail branch-run load non-comparable; matched recapture identical at 5 widths).
  Open: inspo arrow-row plan/CSS allocation (plan 230.9 vs real 143 at 375); wrapped-row least (W-B).
```

## Edit 3 — Decisions the user made (layout floors / L1A): append

```text
- Alike button peers in one row share each side's smallest shown value (plan and CSS); a hug box judges the L1A
  phone guard against its parent's slot (G1, my ruling, not yet confirmed).
```

## Edit 4 — Start here build line (apply LAST, after all older pending files and edits above)

```text
**Current build `2026-10-22.5`.**
```

Checks bullet: `npm run check` 2112/2112 unit/rule plus 6/6 serial performance; browser 244/244, no failures/skips.

Evidence: `~/.hermes/plans/figma-to-bricks/evidence/responsive-pill-planning/finisher/` (manifest.sha256), builder evidence under `builder/`.
