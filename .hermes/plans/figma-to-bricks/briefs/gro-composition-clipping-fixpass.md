# gro-composition-clipping — FIX PASS brief (2026-10-21 23:10 EDT)

Opus medium. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/gro-composition-clipping, tip eec188f, base 3f14a32 (.24). Plan ~/.hermes/plans/figma-to-bricks/gro-composition-clipping.md; builder brief briefs/gro-composition-clipping-builder.md. Reviewer evidence: ~/.hermes/plans/figma-to-bricks/evidence/gro-composition-clipping-review/ (laptop-slack.txt, main/branch-hero-header-1280.png, gro-measure.json, probe-fullphoto.ts, mutation hook).

## RELEASE BOUNDARY
Fix only: NO merge, push, BUILD bump, CLAUDE.md or cleanup. A new fresh Opus xhigh review follows, then a finisher (after fixed-tile-shrink merges).

## Fresh Opus xhigh review: changes requested (core G2/G3/G5 verified working; all gates green)
F1 (major): laptop drift. freeShare's F uses the drawn gap, but space.ramp slides gaps ≥40px from design value to the tablet step on laptops (e.g. header gap clamp(72px, calc(-417.36px + 49.33vw), 293px): F=1239 while real content at 1300 ≈1100). Nudge collapses to 0 with free space left → rows pack left at 992–1439. Right-edge gap main/branch: hero nav wsgkgc and section-02 nav jmqcyl ('Let's GRO' CTA) 7/74 @1300, 12/73 @1200, 18/70 @1024, 20/69 @992; footer top fjhbmi 46/134 @1200, 4/200 @1024, 0/185 @992; footer eksibh 98/167 @1200, 65/224 @1024; services caption bvttpl +70–96px. Identical at 1440. Not anticipated by the plan; no gate sees it.
 Reviewer options: (a) F follows the row's actual tier gap via an adapt rule writing fluid/tablet margins max(0px, calc((100% - Σw px - (n-1)*<tier gap expr>) * s)) — needs adapt stage (space.ts belongs to responsive-pill, or a new rule file with declared overrides); (b) Justin accepts.
 DISPATCHER RULING (Justin away; his rule = take the safe recommended path; the plan says any per-tier nudge ramp must sequence after responsive-pill and space.ts is not yours):
   1st choice (c): keep main's exact output at ≥992 (where main had no clipping) and apply the free-share nudge only at the tiers that clipped (≤991), using only your owned files (place.ts nudgeStyle / compose.ts layerStyle) or, if tier-specific output must be written by an adapt rule, a NEW rule file with declared overrides — never space.ts, least.ts, layout.ts, sides.ts or fixed-tile's files. Prove laptop widths 992–1439 are byte/rect-identical to main and G2/G3/G5 still fixed.
   2nd choice (a) only if (c) is impossible and it stays outside space.ts.
   If neither is safely possible: commit what passes and stop with exact options (do not ship the laptop drift).
F2 (minor): browser fixture doesn't test the clamp or the footer twin. Mutants A3 (no max(0px)), A4 (placed layers in F), A5 (padding ignored) pass all browser tests; Footer row never fails under any mutant incl. A1. Add a kept/two-per-row row with F wider than a phone; tune the footer twin so A1 fails on Footer at 768.
F3 (minor): no test pins 'placed layers don't count toward F' — A4 survives everything but changes GRO's paste (wnnoks → '0.24%'). Add a unit control.
F4 (minor): Fix B incomplete for past-edge cards whose photo fills the card width at ≤767 (Bricks sections flex-wrap ≤767; auto height computed at drawn width before stretch). Probe probe-fullphoto.ts: @600 content 566 vs card 366, 104px past section bottom (main 88 → 16px worse); @480 92px; @390 11px. Try a definite width for the joining box at its tier in layerStyle; else record the limit in HANDOFF (and stop calling it 'generic: any placed card').
F5 (minor): records overstate '1440 unchanged' — 11 GRO elements move ±1px at 1440 (brblcs, asmsrq, wnnoks −1; obrnre +1). Reword; add laptop widths 1280/1024 to paste check 3az.
J1–J3 info: rulings acceptable; side effect at 767/600/480 judged better/neutral; no interaction with fixed-tile (combined tree differs by the same 18 GRO keys).

## Do
Load figma-to-bricks, receiving-code-review, test-driven-development, systematic-debugging, git-commit-rules. Verify, fix test-first (laptop drift RED test first: right-edge gap at 1300/1200/1024/992 equals main). Gates: check, test:browser, corpus vs baseline, own Chrome sweep of GRO at the reviewer's 23 widths, element diff all files. Commit; stop at ready-for-review. Always pass workdir. Never reset/stash/discard.
