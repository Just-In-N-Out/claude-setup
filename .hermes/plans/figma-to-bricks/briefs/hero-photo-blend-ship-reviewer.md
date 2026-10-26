# hero-photo-blend — fresh REVIEWER brief (option 2 ship), written 2026-10-21 20:51 EDT

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/hero-photo-blend, tip 07b7c04 (gates run at e323f39; later commit is records only), rebased on main 5e32aec (.22). Review `git diff main...HEAD` against the plan (~/.hermes/plans/figma-to-bricks/hero-photo-blend*.md, including "Justin's answer … option 2"), briefs/hero-photo-blend-safari-fixpass.md and briefs/hero-photo-blend-ship-builder.md, and figma-to-bricks references/rendering-validation.md.

## Approved scope
Only a picture's single, outer, zero-spread shadow becomes `filter: drop-shadow(...)` at blur/2, plus `will-change: filter`. Multiple, inner or spread shadows, videos, layer blur alone and painted boxes keep the exact original box-shadow (+warning where specified). No translateZ, z-index, position, SVG, Code element, dependency or live write.

## Accepted by Justin (NOT findings)
1. iOS 18.6 can intermittently lose the shadow outside the box (10/22 on cut-out cylinder).
2. A picture's shadow paints over a later white caption (F2).
Installed Bricks 2.3.9 paste/save/copy-back is unproved and must stay stated as unproved.

## Verify
- The diff vs main is only what the scope allows; rebase kept main's HANDOFF (3av) intact.
- Gates yourself: npm run check, npm run test:browser, npm run corpus (compare to evidence/hero-photo-blend-ship and baseline integrated-mainb5a253f: only the 7 single-shadow pictures change, only by the filter/will-change lines; 17 worse-than-v1 lines unchanged). Watch for silently missing Google fonts in loaded sets.
- Mutations: drop will-change, apply to video/multiple/inner/spread, blur not halved → tests must fail.
- Chrome render at 1440/390/375/360/320 for an opaque rounded photo and a transparent cut-out: no square seam, ordinary shadows not regressed.

Change nothing: no commit, push or merge; restore anything you touch. Kill only orphan Chrome (parent PID 1). Other bugs → found_else.
