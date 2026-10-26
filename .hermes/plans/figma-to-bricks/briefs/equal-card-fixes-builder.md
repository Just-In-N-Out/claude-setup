# Brief: BUILDER for figma-to-bricks feature "equal-card-fixes" (batch B4)

Build the approved plan at `~/.hermes/plans/figma-to-bricks/equal-card-fixes.md`. Justin's answers: **Q1A** (R5 is NOT in this batch: it moved to layout-floors) and **Q2A** (centred row cards keep their drawn bottom padding). Both ⭐, so the plan text stands. The planner's probes, mutate.py, survey/diff/rects scripts and sketch diff are in `~/.hermes/plans/figma-to-bricks/equal-card-fixes-tools/`: reuse them.

## Found items this closes (mark each in `~/.hermes/plans/figma-to-bricks/found-else.md` at the merge as `~~item~~ ✅ fixed in build <BUILD> (equal-card-fixes)`, or `⚠️ partly fixed` with what's left)
- MAJOR R1 (row-direction cards shift down at full width once 3B trims their bottom padding)
- MAJOR R2 (tablet: stretched row card turned column gives free height to a fixed child left with flex-grow 1)
- Minor R3 (hugging card with min height and centred content loses its centring)
- Minor R4 (~20 more guards with no test)
- Nits R6 R7 (pills test held by the round rule; dead ELLIPSE branch / space-between exception)
- Leave R5 unstruck (layout-floors owns it).

## State
- Main `f3d6ed8` (build 2026-10-21.4); paste checks 3aa–3af taken.
- Building in parallel: cta-label-wrap (adapt/layout.ts, least.ts, unpin.ts, label.ts, rules/index.ts), frame-text-links (extract, normalise, ui/site-*), fonts-cleanup (ui fonts). No shared source file with any. Whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check.
- layout-floors (B5) builds after you and rebases on your adapt/rules/rows.ts and style/bottoms.ts changes. test-cleanup later splits style/style.ts (you change one condition at :137).

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6: the main chat runs the review). Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need (equal cards, rows stacking, bottoms). Never the whole file.
2. `skill_view('test-driven-development')`: a failing test before each change. On a surprise failure or a worse corpus number, `skill_view('systematic-debugging')`. Say in your first steps you loaded them.
3. Worktree `.claude/worktrees/equal-card-fixes`, branch `worktree-equal-card-fixes`, from main.
4. Before pictures from the untouched copy, before the first code change (the planner's probe designs: row card at full width, stacked card on tablet), after pictures after the last task. Copy pairs to `~/.hermes/plans/figma-to-bricks/shots/equal-card-fixes/` as before-/after-<section>.png; return absolute paths in `shots[]`.
5. Justin's pages (hydraulics, Services, Repairs) must stay byte-identical: prove it by replay cmp, and say so.
6. Copy the plan to `docs/plans/2026-10-21-equal-card-fixes.md`; ledger; HANDOFF with the next free paste check.
7. Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs go in `found_else`, not folded in.
8. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser` (3 known stale panel failures), `npm run corpus` no worse; not merged, nothing pushed. Kill any headless Chrome you started. Out of steps: commit what passes, `status: stopped`, name the last commit.
9. Plain words for a WhatsApp reader.
