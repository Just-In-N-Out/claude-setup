# Brief: BUILDER for figma-to-bricks feature "font-weight-gaps"

Build the approved plan at `~/.hermes/plans/figma-to-bricks/font-weight-gaps.md`. It was approved under Justin's auto-go with the recommended answers 1A 2A 3A 4A (see the top of the plan). An earlier builder died on a provider connection drop before starting. Commit as you go.

## In short
1. **No weight ranges.** The paste's site font lines write a variable font as `font-weight: 100 900` (`src/ui/font-sources.ts`, siteFaceCss, about line 39).
   - Bricks copies that range into its single Google Fonts link. Google refuses the whole link (HTTP 400), so no Bricks-loaded Google font arrives on 8 pages, and the header's IBM Plex Mono falls back to Times.
   - **Fix:** never write a weight range. Write one @font-face line per design weight.
2. **Standard weights.** `src/ui/sfnt.ts` readFontInfo takes the OS/2 usWeightClass as it is, so Saira Condensed Thin and ExtraLight were uploaded as 250 and 275.
   - **Fix:** read in-between file weights as standard (250 → 100, 275 → 200), both on upload and when reading faces already on the site.
   - 2A: for faces already on the site, read the weight from their file names. No site change.
3. The answers:
   - 1A: Justin sets the header button's weight to 600 in the header template himself. Include the steps for him.
   - 3A: he re-pastes the 8 pages once, after this merges.
   - 4A: a weight Google lacks keeps today's behaviour.
4. This is panel-only. Don't change `src/core`; corpus pastes must stay byte-identical.

This builds on emergency-cta-width, which is merged (main `a75ecec`, Build 2026-10-21.1): `src/ui/site-fonts.ts` now keeps only each family's own faces.

**Done means:** all tasks are committed on branch `worktree-font-weight-gaps` in `.claude/worktrees/font-weight-gaps`; `npm run check`, `npm run test:browser` (3 known stale panel failures) and `npm run corpus` are green; corpus pastes are byte-identical.

## How
1. Load `skill_view('figma-to-bricks')` and follow it in the BUILDER role, Step 2 through Step 3, skipping Step 3 item 6 (the main chat runs the review).
   - Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need (fonts, Google Fonts, uploads). Never read the whole file.
2. Then load `skill_view('test-driven-development')` and write a failing test before each change. On an unexpected failure, load `systematic-debugging`.
3. If `.claude/worktrees/font-weight-gaps` already exists from the dead attempt, reuse it. Otherwise create it from main (`a75ecec` or newer), using exactly that name and branch.
4. Copy the plan into `docs/plans/2026-10-21-font-weight-gaps.md`.
5. Write the ledger and the HANDOFF section with the next free paste check. 3aa–3ac are taken, and the features merging now take the next ones, so check at the end.
6. Don't bump BUILD or edit CLAUDE.md; the finisher does those at the merge. Don't re-plan.
7. The live site is read only: never log in or write to WordPress.
8. No pictures for this one. Put the proof in `proof`, from the test stand-ins:
   - the @font-face lines and the Bricks-style Google Fonts link parameters, before and after, for a variable font
   - the weights read for the Thin and ExtraLight files
9. test-cleanup may edit `test/fixtures/panel.ts` later, so keep your stand-in changes to the font functions.
10. List other bugs in `found_else`; don't fold them in.
11. On a real trade-off, make the ruling and write it in HANDOFF as "My ruling, not yet confirmed". Put only look-changing ones in `rulings`.
12. Stop at ready-for-review: everything committed, gates green, not merged, nothing pushed. Kill any headless Chrome you started. If you run out of steps, stop with `status: stopped` and a `stop_reason`, naming the last commit.
13. Write the summary in plain words for a WhatsApp reader.
