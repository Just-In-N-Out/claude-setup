# Brief: BUILDER for figma-to-bricks feature "text-breaks"

Build the approved plan at `~/.hermes/plans/figma-to-bricks/text-breaks.md` (all ⭐ answers; see "Justin's answers" at its end). Model: Sol 6.1 xhigh.

## Found items this closes
The batch's lines in `~/.hermes/plans/figma-to-bricks/found-batches.md` (section for text-breaks), whose originals are in `found-else.md`. At the merge the finisher marks each one there as `~~item~~ ✅ fixed in build <BUILD> (text-breaks)`, or `⚠️ partly fixed` with what's left; already-fixed items get their correction as the plan says.

## State
- Starts only after frame-text-links has merged: rebase-free start from the newest main. Check `git log --oneline -5 main` and `BUILD` in `src/shared/build.ts`, and read frame-text-links' HANDOFF section first (it changed ui/site-read.ts, ui/site-pages.ts and text HTML links).
- link-upload-fixes and text-breaks build side by side (no shared source files). Other builders may be running (equal-card-fixes, layout-floors, fonts-cleanup, test-cleanup). Whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check.

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6: the main chat runs the review). Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need. Never the whole file.
2. `skill_view('test-driven-development')`: a failing test before each change. Surprise failure or worse corpus: `skill_view('systematic-debugging')`. Say in your first steps you loaded them.
3. Worktree `.claude/worktrees/text-breaks`, branch `worktree-text-breaks`, from main.
4. Pictures or proof: text-breaks changes the look, so before shots from the untouched copy before the first change, after shots after the last task (phone widths too), pairs copied to `~/.hermes/plans/figma-to-bricks/shots/text-breaks/`, paths in `shots[]`. link-upload-fixes doesn't change the look: give a text proof (old vs new: each link → href, upload slug, rename counts).
5. Copy the plan to `docs/plans/<date>-text-breaks.md`; ledger; HANDOFF with the next free paste check.
6. Leave BUILD and CLAUDE.md alone. Never write to the live site (read-only GETs fine). Rulings as "My ruling, not yet confirmed". Other bugs go in `found_else`.
7. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged, nothing pushed. Kill headless Chrome you started. Out of steps: commit what passes, `status: stopped`, name the last commit.
8. Plain words for a WhatsApp reader.

## Update at dispatch (07:41)
- frame-text-links has merged: main `bfeb633`, build 2026-10-21.5. Its HANDOFF section is "Frame text links"; it added src/ui/text-links.ts and relinks <a href> inside text HTML by position.
- Paste checks 3aa–3ag are taken (fonts-cleanup, reviewing, also claimed 3ag and will renumber). Take the next free one at your merge.
