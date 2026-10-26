# Brief: BUILDER for figma-to-bricks feature "fonts-cleanup"

Build the approved plan at `~/.hermes/plans/figma-to-bricks/fonts-cleanup.md`. Read its "Justin's answers" section at the bottom first: **1B 2A**. 1B differs from the plan's ⭐ and splits item 1 into two stages; this build is stage 1 only (items 2, 3, 4, plus item 1's proof harness and HANDOFF proof steps, loader left in place).

## Found items this closes (mark each in `~/.hermes/plans/figma-to-bricks/found-else.md` at the merge as `~~item~~ ✅ fixed in build <BUILD> (fonts-cleanup)`)
- "Low: the panel note for a weight Google lacks doesn't say which weight shows instead."
- "Low: site-fonts.ts addFonts (line ~139) counts a dropped font as 'already there' only on an exact weight match, ..."
- "Site setting (not code): the Theme Style sets all body text to Saira 800 ..." → mark `⚠️ checked in <BUILD>: fresh pastes keep Figma weights (regression tests added); the header template still needs 600 set by hand in Bricks`.
- Leave "Low (speed): each pasted page loads its Google fonts twice" unstruck (stage 2).

## State
- Main `f3d6ed8` (build 2026-10-21.4). Paste checks 3aa–3af taken.
- Building in parallel: frame-text-links (may touch `src/ui/run.ts` and ui tests) and cta-label-wrap (adapt/ only). Stay within this plan's files; whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check.

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6: the main chat runs the review). Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need. Never read the whole file.
2. `skill_view('test-driven-development')`: a failing test before each change (the planner's red seam: covered static upload makes 1 POST, must be 0). On an unexpected failure, `skill_view('systematic-debugging')`. Say in your first steps you loaded them.
3. Worktree `.claude/worktrees/fonts-cleanup`, branch `worktree-fonts-cleanup`, from main.
4. No look change expected: return a text proof instead of pictures (old vs new: upload POST count for the covered case; the new missing-weight note text).
5. Copy the plan to `docs/plans/2026-10-21-fonts-cleanup.md`; ledger; HANDOFF section with the next free paste check and the item-1 stage-2 proof steps.
6. Leave BUILD and CLAUDE.md alone. Never write to the live site (read-only GETs fine).
7. Rulings as "My ruling, not yet confirmed" in HANDOFF. Other bugs go in `found_else`, not folded in.
8. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser` (3 known stale panel failures), `npm run corpus` no worse; not merged, nothing pushed. Kill any headless Chrome you started. Out of steps: commit what passes, `status: stopped`, name the last commit.
9. Plain words for a WhatsApp reader.
