# gro-composition-clipping — fresh REVIEWER brief (2026-10-21 22:44 EDT)

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/gro-composition-clipping, tip eec188f, base main 3f14a32 (.24). Review `git diff main...HEAD` against the approved plan ~/.hermes/plans/figma-to-bricks/gro-composition-clipping.md and briefs/gro-composition-clipping-builder.md. Plan evidence: evidence/gro-composition-clipping/ (probe.ts etc). Builder shots: ~/.hermes/plans/figma-to-bricks/shots/gro-composition-clipping/.

## Built (verify)
A place.ts nudgeStyle: inferred row's positive sideways nudge = max(0px, calc((100% - Fpx) * s)); exact at design width; auto/negative/column/cross nudges unchanged.
B compose.ts layerStyle: box holding flowing layers brought into the column by compose.stack gets height:auto at the joining tier.
Claims: G2 '04' no longer cut 991–479; G3 footer 'Contact' visible at 768; G5 clean 390/375/360/320; G1/G4/G6 unchanged as planned; 1440 rects identical to main. check 1935+6, browser 198/198; corpus pastes byte-identical except GRO (17 row margin-left values + wxjdlj height auto); same 17 worse-than-v1.

## Judge
1. Builder rulings: B2 control impossible (past-edge needs content); footer columns pack left on tablets (space.ts belongs to responsive-pill — deferred); fixture tuning.
2. Side effect: at 767/600/480 GRO's selected-work '01' block (cbufqf) and footer columns now sit beside neighbours instead of wrapping; sections 431–470px shorter. Better or worse vs Figma intent? Measure.
3. Other corpus files' inferred rows at 992–1439 (plan risk) — element diff all corpus + scratch copy of user's debug JSON + inspo brainstorm, Chrome rects at all widths incl. 375/360/320.
4. Mutations (A3 caught only by unit tests — is the browser fixture strong enough?).
5. Interaction with fixed-tile-shrink (in fix pass 2, will merge first; kinds/shapes/unpin/rows) — no source overlap, but outputs both touch GRO? fixed-tile left GRO byte-identical.
Change nothing; restore anything you touch; kill only orphan Chrome. Always pass workdir. Other bugs → found_else.
