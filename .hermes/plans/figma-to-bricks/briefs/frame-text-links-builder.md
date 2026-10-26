# Brief: BUILDER for figma-to-bricks feature "frame-text-links"

Build the approved plan at `~/.hermes/plans/figma-to-bricks/frame-text-links.md` (Justin's answers: F1A F2A F3A, all recommended). Commit as you go: the model connection has been dropping.

## In short
- Today, words in a Figma text that link to **another frame** (a NODE link) are dropped, so they come out as plain text in Bricks. Web-address text links already work.
- Make frame links work:
  1. Extract saves the target frame's name.
  2. The words link to that frame's page, the same way card arrows and "Learn more" links already find their pages (`normalise/page-links.ts`).
  3. These links go through the same site check at Convert (`ui/site-read.ts`, `ui/site-pages.ts`).
  4. Relink also changes or removes the `<a href>` inside the text HTML, never touching a web address typed in Figma.
- Same safety rules as other links: never a picture or video file, plus panel notes.
- The answers:
  - F1A: if the page doesn't exist yet, use the guessed address and add a panel note.
  - F2A: a link to a section or card goes to its top frame's page.
  - F3A: if the target frame was deleted, plain words with a panel note.
- Planner's found item, which this feature closes: text-part links were never checked against the site (`ui/site-pages.ts` relink only changed `settings.link`). Mark it fixed in found-else at the merge.
- No corpus file has a text hyperlink, so build a generic fixture. Old debug files lack the target frame's name; give those links a "frame not found" note.

## State (updated 2026-10-21 ~06:30)
- Main: `f3d6ed8` (Build 2026-10-21.4). early-line-breaks (.2, changed `textHtml` in `src/core/style/typography.ts` with a `soft` flag, added `style/rag.ts`), font-weight-gaps (.3) and phone-side-padding (.4) have all merged.
- The old copy `.claude/worktrees/frame-text-links` (branch `worktree-frame-text-links`) is at `9923fe1` with no commits, only an untracked `.superpowers/`. Reuse it: check `git -C <copy> log main..HEAD` is empty, then `git -C <copy> reset --hard main` to start from `f3d6ed8`, and refresh node_modules/CLAUDE.md/corpus per the skill's Step 2.
- Paste checks 3aa–3af are taken. `cta-label-wrap` (adapt/ only) is building in parallel: no shared source files. Whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check.
- `test-cleanup` waits until this merges.

## How
1. Load `skill_view('figma-to-bricks')` in the BUILDER role, Step 2 through Step 3, skipping Step 3 item 6 (the main chat runs the review). Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need (page links, links checked against the site, link-hrefs). Never read the whole file.
2. Then load `skill_view('test-driven-development')` and write a failing test before each change. On an unexpected failure, load `systematic-debugging`.
3. Use exactly the worktree name `frame-text-links` and branch `worktree-frame-text-links`, from main `9923fe1` or newer.
4. Copy the plan into `docs/plans/2026-10-21-frame-text-links.md`. Write the ledger and the HANDOFF section with the next free paste check.
5. Leave BUILD and CLAUDE.md alone; those are for the finisher.
6. If the extract change alters the debug-file format, note it in HANDOFF.
7. Proof instead of pictures: in `proof`, show the words → href for each link in the fixture, before and after, plus the notes for a missing page and a deleted frame.
8. Never write to the live site.
9. Put other bugs in `found_else`.
10. Rulings go in HANDOFF as "My ruling, not yet confirmed". Only list look-changing rulings in `rulings`.
11. Stop at ready-for-review:
    - everything committed
    - `npm run check`, `npm run test:browser` (3 known stale panel failures) and `npm run corpus` green
    - corpus pastes byte-identical (no corpus text links)
    - not merged, nothing pushed
12. Kill any headless Chrome you started. If you run out of steps, stop with `status: stopped` and a `stop_reason`, naming the last commit.
13. Write the summary in plain words for a WhatsApp reader.
