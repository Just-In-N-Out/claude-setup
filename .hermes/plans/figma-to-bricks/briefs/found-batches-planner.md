# Brief: PLANNER for a found-items batch (figma-to-bricks)

You plan ONE batch from `~/.hermes/plans/figma-to-bricks/found-batches.md` (your batch name is in your goal). Your items are the lines under that batch's heading; the full original lines with evidence are in `~/.hermes/plans/figma-to-bricks/found-else.md` (skip struck-through ones). Read "Justin's answers" at the bottom of found-batches.md too.

## How
1. `skill_view('figma-to-bricks')`, PLANNER role. Read `references/rules-summary.md` first, then only the CLAUDE.md sections your items need ("Start here" plus the areas). Never read the whole CLAUDE.md. Then `skill_view('systematic-debugging')`: these are bugs, so find each root cause with file/line evidence before planning its fix. Say in your first steps that you loaded both.
2. Make no worktree, branch, code or commit. Read only. Main is `f3d6ed8` (build 2026-10-21.4).
3. For layout items, reproduce at the paste's real widths with the renderer, not Figma's frame width.
4. Save the plan to `~/.hermes/plans/figma-to-bricks/<batch name>.md`: title, then Open questions (lettered options, recommended marked ⭐, written as if ⭐ chosen), request played back, one section per item (root cause, fix, test), tasks (test first), risks, files and pipeline parts touched, overlaps, then a **Docs & records** task (plan copy in docs/plans, ledger, HANDOFF + paste check, BUILD bump, CLAUDE.md "Start here"/"Where things stand" by the finisher, and marking each item fixed in found-else.md at the merge as `~~item~~ ✅ fixed in build <BUILD> (<batch>)`), then "Other things found".
5. If an item turns out not to be a real bug, or is much bigger than its batch, say so and propose dropping or splitting it, rather than planning a big fix.
6. General logic only: no keying on layer names, IDs, texts, pixel values or colours.

## Work in flight (say whether you touch the same files)
- frame-text-links, building: extract, normalise/text.ts, normalise/page-links.ts, ui/site-read.ts, ui/site-pages.ts, the text HTML `<a href>`.
- cta-label-wrap, building: adapt/layout.ts, adapt/least.ts (new), adapt/rules/unpin.ts, adapt/rules/label.ts (new), adapt/rules/index.ts.
- test-cleanup, queued: test/browser panel tests, splits style/style.ts (picture code to style/picture.ts), tools/snap.ts.
- The other 4 batches are being planned at the same time (fonts-cleanup, link-upload-fixes, text-breaks, equal-card-fixes, layout-floors): name any file you'd share with them.

## Answer
Plain words for a WhatsApp reader. You can't ask Justin anything: questions go in `questions`, each with 2–4 short options (under ~60 chars) and one recommended. Any other bug you find: don't fold it in, list it in `found_else` (one line, evidence, severity) and in "Other things found".
