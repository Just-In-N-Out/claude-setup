# Brief: BUILDER for figma-to-bricks feature "text-link-followups" (B7)

Build the approved plan at `~/.hermes/plans/figma-to-bricks/text-link-followups.md` (Justin: N1A). Model: Sol 6.1 high.

## Found items this closes
The 4 lines under "## B7 text-link-followups" in `~/.hermes/plans/figma-to-bricks/found-batches.md` (originals in `found-else.md`, sections "text-breaks planner", "frame-text-links builder", "frame-text-links reviewer"). The finisher marks each `~~item~~ ✅ fixed in build <BUILD> (text-link-followups)`.

## Current dispatch update (2026-10-21 10:50)
- Both prerequisites verified merged: text-breaks .10 2dd96eb, link-upload-fixes .11 6ba11f5; verify ancestors of actual main.
- In flight: test-cleanup fresh reviewer (tools/style/panel tests) and google-font-hardening builder (fonts.ts/new isolated test). No expected source overlap; do not edit their shared tools/panel fixtures/style.ts or font sources.
- Queued card-link-words Opus plan revision overlaps contact-links.ts / emit/page-addresses.ts. B7 now owns these build files; dispatcher will serialize card-link-words builder AFTER B7. A read-only planner may run alongside you. Stop/report unexpected active-builder overlap.
- Phone-recognizer false positives and LINK-RENAME-COLLISION remain separate, not yours. Preserve B3 punctuation/emergency wrapping and B2 cancellation/payload guard/media-ID note counters. No scope expansion.
- Save full baseline/final reports, font-load status, paste bytes; matched motion/font comparisons only. Test before fixes; real hours widths and keyboard Tab checks per plan. Existing stale panel tests may be fixed by test-cleanup's later merge; don't assume counts. Return gates/proof and shots, no merge/push/main/BUILD/CLAUDE.md edits.

## Resume after 8f621f7 (2026-10-21)
Parent inspected the sole failing test and grants a narrow ownership exception: update the existing cross-run case ONLY in test/unit/style-phone-numbers.test.ts (old lines 29–33). It expressly prohibits the cross-run links B7 is approved to add. Keep visual grouping, punctuation, styles and exact-character assertions; replace no-anchor assertion with full href per slice, no nested anchors, and correct wrapper checks. All other B3 tests remain intact; no other scope expansion. Plan records this exception. Resume clean worktree at 8f621f7; do not recreate/reset it. Finish phone acceptance (five tests alone aren't the whole plan), then hours, labels and marquee tasks in order, before/after hours pictures, full gates and committed ready-for-review. Main may move while test-cleanup finishes; preserve changes, rebase/gates at final integration. Builder must not merge/push.

## State
- Starts only after text-breaks AND link-upload-fixes have merged. Check `git log --oneline -8 main`, `BUILD`, and read both features' HANDOFF sections first; follow the plan's "what changes after the predecessors land" section.
- Other work may be in flight (layout-floors, test-cleanup, pill-clip, google-partial-fonts). Stay within this plan's files; whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check.

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6). `references/rules-summary.md` first, then only the CLAUDE.md sections you need.
2. `skill_view('test-driven-development')`; `skill_view('systematic-debugging')` on surprises. Say you loaded them.
3. Worktree `.claude/worktrees/text-link-followups`, branch `worktree-text-link-followups`, from main.
4. Before shots from the untouched copy (the opening-hours separator) and after shots; pairs to `~/.hermes/plans/figma-to-bricks/shots/text-link-followups/`, paths in `shots[]`. Text proof for links/notes/Tab.
5. Plan copy, ledger, HANDOFF with the next free paste check. Leave BUILD and CLAUDE.md alone. Never write to the live site. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
6. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
7. Plain words for WhatsApp.
