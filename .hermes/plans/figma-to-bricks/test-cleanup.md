# Test cleanup: stale panel tests, card-guard tests, style.ts split

**Approved by Justin 2026-10-21** (answers T1A T2A).

## Open questions
1. Where should the picture/shape code from style.ts go?
   - A ⭐ New `src/core/style/picture.ts` (picture, emptyBox, shape)
   - B Split text + button out instead (`text-style.ts`)
2. When should this merge, relative to the other three planners?
   - A ⭐ Last, after the others (rebase onto their style.ts edits)
   - B First, so others rebase onto the split

(Plan written with the ⭐ choices.)

## Request played back
1. Fix the 3 panel browser tests that expect the old upload names (no `-image` / `-video` ending) since build .14.
2. Add one generic test for each of 3 untested card guards: rowEven skips lists, rowEven skips marquees, sizedByPadding skips live maps. Each must fail when its guard is removed.
3. Split `src/core/style/style.ts` (353 lines) under ~300 with no output change.
None of it changes the paste.

## Evidence (main, build 2026-10-20.15, `npm run test:browser`: 131 pass, 3 fail)
- `panel.test.ts:134` (#84) line 156 expects `uploads/team.png`, gets `uploads/team-image.png`.
- `panel.test.ts:373` (#97) line 393/394 expects `Hero-clip.mp4`, gets `Hero-clip-video.mp4` (line 394's saveVideos address and 398/447 use the old name too).
- `panel.test.ts:464` (#101) line 470 regex expects `Hero-clip.mp4`, panel says `Hero-clip-video.mp4`.
- Cause: link-hrefs (build .14) renamed uploads; only `npm run check` ran at merge, which skips the browser suite. Tests are stale; the plugin is right.
- Guards: `shares.ts:89` `row.list !== null || row.marquee !== null` in rowEven; `bottoms.ts` sizedByPadding `k.map === null`. `test/unit/style-layout.test.ts` holds the equal-cards tests; none builds a list row, a marquee row or a map card.
- style.ts: one big `styleAll` closure. Lines 219–287 (picture, emptyBox, shape, ~70 lines) form a self-contained group that only needs sizeOf, placement, assets, warn, ink and wide.

## Approach
- Task 5: change only the expected names to the new endings. Check each test still proves its point: #84 the picture's paste url is the uploaded file's; #97 the uploaded file's name and the address saved to the file match; #101 the message names the real saved address. Use one shared constant per test so expected names can't drift apart within a test (e.g. 394/398/447 all use the saved `-video` address).
- Task 6: three fixtures in `test/unit/style-layout.test.ts` (or a new `test/unit/style-bottoms.test.ts` if that file passes ~300): a row of alike cards with uneven bottom padding that would stretch and share a bottom, made (a) a list row, (b) a marquee row, (c) with one card a live map. Assert no stretch / no shared bottom for (a), (b), and the map card's padding untouched for (c). Mutation proof: delete each guard by hand, see the test fail, restore.
- Task 7: move picture/emptyBox/shape to `style/picture.ts` as `pictureStyles(ctx)` returning `{ picture, shape }`; ctx = `{ sizeOf, placement, assets, warn, ink, wide }`. Same code, same call order. style.ts drops to ~285 lines.

## Tasks
1. Save corpus baseline: `npm run corpus` report + copies of `corpus/out/v2/*/bricks.json`.
2. Task 5 test edits; `npm run test:browser` fully green. Commit.
3. Task 6 three tests, each mutation-proven (record in ledger). Commit.
4. Task 7 split; `npm run check` green. Commit.
5. `npm run corpus`; `cmp` every bricks.json against the baseline (all identical), lint lines and "Worse than v1" list unchanged.
6. Docs & records (below).

## Tests
- `npm run check`, `npm run test:browser` (134/134), `npm run corpus` with byte-identical pastes.
- 3 new unit tests, each shown failing with its guard removed.

## Choices (as recommended)
- Picture group moves (smallest clean seam; text/button touch typography that 'early-line-breaks' may edit).
- Merge last.
- Fix test expectations, not the plugin.

## Risks
- Parallel planners edit style.ts (early-line-breaks: textStyled; phone-side-padding maybe sizing). Moving picture code only keeps their hunks applying; merging last means the rebase is ours.
- Closure capture: `wide` and `exact` are set later/mutated in styleAll; pass getters or the objects themselves, not copies, or output changes. Corpus cmp catches it.
- A guard fixture may pass for a different reason (e.g. no stretch at all). Each fixture also gets a control case without the list/marquee/map that does stretch.
- One showcase browser test can flake; re-run before calling it a regression.

## Files touched
- `test/browser/panel.test.ts`
- `test/unit/style-layout.test.ts` (or new `test/unit/style-bottoms.test.ts`)
- `src/core/style/style.ts`, new `src/core/style/picture.ts`
- docs: `docs/plans/`, `docs/HANDOFF.md`, `src/shared/build.ts`

## Overlaps
- style.ts split is the likely clash with 'early-line-breaks' (text code in style.ts) and maybe 'phone-side-padding'. 'frame-text-links' (normalise/text.ts, ui/site-*) shouldn't clash; panel.test.ts may if it adds panel tests. Merge this one last.

## Docs & records
- Plan copied to `docs/plans/2026-10-21-test-cleanup.md`.
- Ledger moved to `docs/plans/2026-10-21-test-cleanup-ledger.md`.
- `docs/HANDOFF.md` updated; no paste check owed (no output change).
- `BUILD` bumped by the finisher at merge.
- Main `CLAUDE.md` "Start here" / "Where things stand" updated by the finisher; add the rule "run `npm run test:browser` before every merge" if not already there.

## Other things found
- Merge process gap: link-hrefs merged with 3 failing browser tests because only `check` ran (skill now says to run test:browser; CLAUDE.md may not). Medium.


## Justin's answers (2026-10-21)

1A: move picture/emptyBox/shape to style/picture.ts. 2A: merge last. All recommended.

## Justin's answers (2026-10-21 ~06:45): 1A, fold in these found items
Also fix, each with a test where it's code (they are lines in found-else.md; mark each fixed there at the merge):
- "Low (tool): npm run snap --sides pairs Figma sections in layer order, not top to bottom (tools/snap.ts ~line 85)."
- "Low (test honesty): other WordPress stand-ins in test/fixtures/panel.ts and panel.test.ts STUB were never checked against WordPress's real answers (paging, newest-first, _fields)."
- equal-card-heights recheck: "Timing tests flaky under load (7/54)."
- "Low (tooling): the hydraulics page score moves up to 0.006 between identical runs (moving logo strip), wider than the ±0.002 noise noted."
Builder: plan these four first (short addendum to this plan, no re-plan of the rest), then build.

## Addendum 2 (main chat, 2026-10-21 ~08:20, Justin: "start agents for those 17 fixes")
Two more tooling items (mark each in found-else.md at the merge):
- Corpus section scores swing far beyond ±0.002 with byte-identical pastes (hydraulics section 3 structure 0.279 vs 0.587, frame-text-links reviewer). Pair with the hydraulics-noise item: make the noise known/handled, and update the documented tolerance.
- `npm run snap -- … --sides` wrote only full-page PNGs for hydraulics-home.json, no Figma-vs-built section pictures (cta-label-wrap builder). Pair with the snap layer-order item.

## Addendum 3 (main chat, 2026-10-21 ~09:45, Justin: "fold")
- Low (tools): `npm run snap` renders without the corpus font stand-ins (Mont→Montserrat), so its lint disagrees with corpus/wraps (design @1024: 21 cut vs 8). Pair with the other snap items.
- Low: three empty stray files l1100.txt, l1280.txt, l1366.txt tracked in the repo root since 515eec5: delete them (check nothing reads them).
- Low (cleanup, optional if small): held buttons' white-space is per-element `_cssCustom` (review F9); leave it listed unless adapt can add classes cleanly. And the F7 ruling (drawn input fields count as buttons) stays a ruling: list it, don't change it.
