# hero-photo-blend — BUILDER (ship option 2) brief, 2026-10-21 ~20:40 EDT

Read first: briefs/hero-photo-blend-safari-fixpass.md (scope, rules) and the worktree ledger section "Safari/iOS fix pass".


## Justin's answer (2026-10-21 ~20:40 EDT): option 2 — ship the will-change fix anyway
Justin's words: "You know what, just like ship the fix anyway, it's fine."
Accepted known limitations, to be written in HANDOFF/plan as accepted by Justin: on iOS 18.6 the picture shadow outside the box can be lost intermittently (10 of 22 captures on the cut-out cylinder page), and a picture's shadow paints over a later white caption (F2). No z-index/position rule added. Release still needs a fresh Opus xhigh review and a finisher merge.

## Job
Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/hero-photo-blend at 15158ad (base dc6713d, build .21; not rebased). Draft test kept in .superpowers/sdd/hero-photo-blend/draft/style-picture-shadow-webkit.test.ts.
1. Do not reset/stash/discard anything.
2. Add the draft test to the suite and show RED, then add `will-change: filter` next to the single-picture drop-shadow filter only (no translateZ, no z-index/position change, video and multiple/inner/spread shadows unchanged). GREEN.
3. Record the two accepted limitations (iOS intermittent loss, caption overlap) as accepted by Justin in HANDOFF, ledger and plan copy; keep "installed Bricks 2.3.9 paste/save/copy-back not proved" explicit.
4. Rebase onto current main (keep both HANDOFF sections), then npm run check, npm run test:browser, npm run corpus against the saved baseline (cmp pastes, diff lint and Worse-than-v1).
5. Commit and stop at ready-for-review. No merge, push, BUILD bump or CLAUDE.md edit. Paste check: next free number on main at merge time.
