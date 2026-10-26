# Brief: BUILDER for figma-to-bricks feature "layout-floors" (B5)

Build the approved plan at `~/.hermes/plans/figma-to-bricks/layout-floors.md` (approved under Justin's away auto-go: F1A F2A F3A), **including its two addenda at the end** (Addendum 1: twoShare / reflow flex-grow from the equal-card-fixes review; Addendum 2: 39/40 on top/bottom, the stacked row-card height, split layout.ts, the inspo strip if small). Item 7 is equal-card R5 (moved here, Justin's Q1A). For each addendum item, write a short root cause + test in the plan copy before building it; fix those that are small and general, list the rest as left.

Model: Opus 5.5 medium (in-between size; Justin: Opus jobs wait for the Claude reset, never move to Sol). Reviewer will be Opus xhigh. Main has moved to build 2026-10-21.11+ (text-breaks .10, link-upload-fixes .11; test-cleanup may merge with a style.ts split into picture.ts). The existing copy `.claude/worktrees/layout-floors` has no commits: bring it up to main with `git merge --ff-only main` (never `git reset --hard`). text-link-followups (Sol) is building in style/rag.ts and normalise/emit text files: not yours.

## State
- Main is build **2026-10-21.8** (`f6ee308`) or newer. Since the plan was written, equal-card-fixes (.7, adapt/rules/rows.ts flexGrow 0 at the first stacked tier, style/bottoms.ts) and cta-label-wrap (.8, adapt/least.ts with sidesAt/buttonLike/floored, rules/label.ts, layout.ts at ~283 lines, unpin.ts floors) merged. **Task 0: re-run the plan's repro of every item on current main** (cta-label-wrap may already have changed item 1, the Repairs titles at 480) and say what's left.
- Split `src/core/adapt/layout.ts` before adding to it (keep it under ~300 lines). pill-clip (queued after you) also edits layout.ts and least.ts.
- In flight: test-cleanup (splits style/style.ts, tests, tools), text-breaks and link-upload-fixes (finishing; not adapt/). Whoever merges second rebases and keeps both HANDOFF sections; take the next free paste check.
- Found items closed: mark each in `found-else.md` at the merge as `~~item~~ ✅ fixed in build <BUILD> (layout-floors)` (the B5 lines in found-batches.md, plus equal-card R5 and the addendum items).

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6). `references/rules-summary.md` first, then only the CLAUDE.md sections you need (adapt, space.ramp, size.unpin, rows, phone rules).
2. `skill_view('test-driven-development')`: a failing test before each change; `skill_view('systematic-debugging')` on surprises or a worse corpus number. Say you loaded them.
3. Worktree `.claude/worktrees/layout-floors`, branch `worktree-layout-floors`, from main.
4. Reproduce at the paste's real widths (renderer), not Figma's frame width. Before shots from the untouched copy, after shots after the last task (Repairs grid at 480, a fixed photo/circle box at 990/768, an upright-phone padding case, the Services parts table at 768); pairs to `~/.hermes/plans/figma-to-bricks/shots/layout-floors/`, paths in `shots[]`.
5. F2A (each side on its own, at most 32 on upright phones) changes ~120 corpus boxes: compare main vs branch element by element and list what moves on Justin's pages.
6. Plan copy, ledger, HANDOFF with the next free paste check. Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`. General logic only: no keying on names, ids, texts or pixel values from his files.
7. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
8. Plain words for WhatsApp.
