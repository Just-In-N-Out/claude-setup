# fixed-tile-shrink — FIX PASS 2 brief (2026-10-21 22:32 EDT)

Opus medium. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/fixed-tile-shrink at dc197b3 (on main 3f14a32 .24). Plan + previous briefs (fixed-tile-shrink-builder.md, -fixpass.md). Re-reviewer evidence: ~/.hermes/plans/figma-to-bricks/evidence/fixed-tile-shrink/rereviewer-opus/ (probe4.ts, list-*-990.png, probe2.ts, f3-*.png, hook.mjs mutation harness).

## Re-review verdict: approve_with_minors (gates, mutations, real-file replay all verified)
F1 (low-medium): unpin.ts:93-94 writes `_width:tablet_portrait = held` (carries to phones) even where desktop sizes the tile by its words. Generic list fixture badges fixed both ways: header 'TYPE' badge 51px desktop → 44px 990–320, right padding 10→3px; 'NEW' 40.8→40. No real file affected. Risk: a just-fitting multi-word label or wider fallback font wraps on tablets.
 Suggestion: write the width only where the row's width comes from its content (the row and its hugging ancestors hug); in a fixed-width row the 100% floor already resolves, so the floor alone holds the tile.
F2 (low): records wrongly claim the adapt-rows badge test kills the plan-width mutation (`held > 0 && ctx.layout.width(...) >= drawn-1` → `held > 0` survives everything). besideKeepOnly mutation also survives: F1 width in two-per-row rows untested. Fix wording or add a tiny-parent tablet unit case; add a two-per-row case.
F3 (info): ruling accepted by dispatcher under Justin's away rule (recorded in plan); keep the pinning tests.
F4 (low, optional): firmAt reserves tile width in list rows (list.ts overrides) and icon rows; plan/CSS disagree; loses main's _heightMin:tablet_portrait:0 in the list fixture. Optional: skip firmAt tile hold for list and icon rows, test-first.
F5 (info): HANDOFF Gates line stale (1855/194 → final numbers); add the '3ay' entry to the end-of-run check list.

## Dispatcher rulings
- Do F1 with the reviewer's suggestion (hug-only), test-first (list badge padding case RED first, hugging-row label case stays green). Do F2 tests/wording. F4: do it only if small and test-first; otherwise record. F5 records.
- RELEASE BOUNDARY: F1 changes rendering, so NO merge/push/BUILD/CLAUDE.md/cleanup. Stop at ready-for-review; a focused fresh Opus xhigh check of the delta follows, then a finisher merges.
- Rebase on current main; gates: check, test:browser, corpus vs baseline + element diff on corpus/debug copy/brainstorm; 375/360/320.
