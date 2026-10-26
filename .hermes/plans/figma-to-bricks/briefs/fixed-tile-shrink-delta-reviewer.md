# fixed-tile-shrink — focused fresh REVIEWER of fix pass 2 (2026-10-21 22:54 EDT)

Review only, Opus xhigh. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/fixed-tile-shrink, tip 86bef1a, on main 3f14a32 (.24). Focus: the delta dc197b3..86bef1a (fix pass 2), while confirming the whole `git diff main...HEAD` still holds. Previous reviews' evidence: evidence/fixed-tile-shrink/reviewer-opus/, rereviewer-opus/; fix pass 2 evidence: evidence/fixed-tile-shrink/fixpass2/. Brief with the findings it addressed: briefs/fixed-tile-shrink-fixpass2.md. F3 ruling already accepted (recorded in plan).

## Claims
F1: size.unpin writes the tile width only when its row is sized by its items (row hugs, or fill chain up to a hugging box); fixed-width rows rely on the min(Wpx,100%) floor. List 'TYPE' badge back to 51px, 10/10 padding at 990 (byte-identical shot to main).
F2: new tests; 5 mutants killed; redundant unpin-side list guard removed.
F4: firmAt skips list record and column-title rows (listLine in kinds.ts); record badges regain _heightMin:tablet_portrait:0. Icon rows unchanged.
Gates: check 1960+6, browser 203/203; corpus identical except page-1 qsfiof loses _width:tablet_portrait 52 (floor stays), no movement 1728–320.

## Check
1. 'Sized by its items' walk correctness: hug, fill-in-hug, nested, wrapped, two-per-row, stacked; re-run the first review's F1 hugging-row probe (label 27px at 990–480) and the list badge probe.
2. listLine scope: does it skip anything that isn't a list row? Does kinds.ts change affect other consumers?
3. Mutations of the new conditions; 375/360/320 no sideways scroll; element diff on corpus + debug copy + brainstorm.
Change nothing; restore anything; kill only orphan Chrome; always pass workdir. GRO reviewer runs in parallel; stagger Chrome. Other bugs → found_else.
