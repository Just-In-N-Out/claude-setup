# fixed-tile-shrink — NEW fresh REVIEWER brief (after fix pass), 2026-10-22 ~22:09 EDT

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/fixed-tile-shrink, tip dc197b3, rebased on main 3f14a32 (build .24). Review the whole `git diff main...HEAD` against the plan ~/.hermes/plans/figma-to-bricks/fixed-tile-shrink.md, briefs/fixed-tile-shrink-builder.md and briefs/fixed-tile-shrink-fixpass.md (which holds the first review's findings F1–F5). First review evidence: evidence/fixed-tile-shrink/reviewer-opus/ (phone3.ts, probe.ts, mutation hook).

## Fix pass claims (verify, don't trust)
- F1: size.unpin also writes the tile's held width as _width at tablet_portrait, only when the tile has no set width and its row doesn't stack there. Hug-row label back to 27px at 990–480.
- F2: !besideIcon added; unit test asserts no collisions.
- F3: new two-per-row tablet shape kept and pinned (ruling, not yet confirmed).
- F4: laptop-guard tests added.
- F5 laptops 992–1199 deferred; paste check doesn't claim laptops.
- Reviewer lead (phone button floors in hugging rows) did not reproduce.
- Gates: check 1952+6, browser 203/203; corpus identical to main except page-1 3 floors + qsfiof _width:tablet_portrait 52 (no movement over 21 widths).

## Check especially
1. F1 fix in all row shapes: hugging, fixed-width, stacked, wrapped, icon rows; tile width never exceeds parent at 375/360/320 (no sideways scroll); no label wraps vs main at 990/768/600/480.
2. Rulings F1/F2/F3 soundness.
3. Mutations of the new conditions; rerun your own probes from the first review.
4. Element-by-element replay main vs branch on corpus + scratch copy of the user's debug file + inspo/brainstorm file; Chrome rects at all widths.
Change nothing; restore anything you touch; kill only orphan Chrome. Always pass workdir to terminal. Other bugs → found_else.
