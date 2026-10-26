# Brief: BUILDER for figma-to-bricks feature "test-cleanup" (the ChatGPT trial)

Build the approved plan at `~/.hermes/plans/figma-to-bricks/test-cleanup.md` (Justin: T1A T2A), **including its three addenda at the end** (1A: four test/tool found items; Addendum 2: corpus score noise + snap section pictures; Addendum 3: snap fonts, stray l1100/l1280/l1366.txt files, F9 listed). Model: Sol 6.1 high. Write a short addendum to the plan copy for the added items (root cause + test) before building them; don't re-plan the original three tasks.

## State
- Main is build **2026-10-21.8** (`f6ee308`) or newer: a lot merged since the plan was written (frame-text-links .5, fonts-cleanup .6, equal-card-fixes .7, cta-label-wrap .8). Re-check each original task against current main first: the 3 stale panel tests may have moved; `src/core/style/style.ts` changed (equal-card-fixes changed one condition near :137; check its current line count and where picture/emptyBox/shape now sit before splitting).
- In flight: text-breaks (style/typography, rag.ts, maybe style.ts wiring), link-upload-fixes (ui/site-*, panel tests?), google-partial-fonts (ui/fonts.ts) are finishing; layout-floors (adapt/) starts ~11:20. Per T2A this one merges after the overlapping ones: whoever merges second rebases and keeps both HANDOFF sections.
- Found items closed by this batch: mark each in `found-else.md` at the merge as `~~item~~ ✅ fixed in build <BUILD> (test-cleanup)`.

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6). `references/rules-summary.md` first, then only the CLAUDE.md sections you need.
2. `skill_view('test-driven-development')`; `skill_view('systematic-debugging')` on surprises. Say you loaded them.
3. Worktree `.claude/worktrees/test-cleanup`, branch `worktree-test-cleanup`, from main.
4. The style.ts split must change no output: prove corpus pastes byte-identical before/after.
5. Plan copy, ledger, HANDOFF (no paste check unless output changes). Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
6. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser` (the 3 stale panel tests should now PASS), `npm run corpus` no worse; not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
7. Plain words for WhatsApp.
