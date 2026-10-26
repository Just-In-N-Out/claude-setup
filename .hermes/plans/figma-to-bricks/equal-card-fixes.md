# Equal card fixes (equal-card-fixes, batch B4)

**Approved by Justin 2026-10-21** (answers Q1A Q2A, both ⭐).

Planner: Hermes, 2026-10-21, main at `f3d6ed8` (build `2026-10-21.4`). Loaded `figma-to-bricks` (PLANNER) and
`systematic-debugging`. Read only: no worktree, branch, code or commit. Source: the opus recheck of build
`2026-10-20.15` (`~/.hermes/cache/delegation/live/deleg_146cb0ac/task-1.log`; its full verdict and mutation list are in
the gateway dump `~/.hermes/sessions/request_dump_20261020_205559_c04b0860_20261021_030125_291719.json`).

Probes, the mutation script and the scratch sketch I measured with are saved (scratch gets pruned) in
`~/.hermes/plans/figma-to-bricks/equal-card-fixes-tools/`:
- `probe.ts` (the reviewer's scenarios) and `probe-ecf.ts` (the same, old against new);
- `mutate.py` and `mutations.jsonl` (48 mutations, 24 survivors);
- `survey.ts`, `diff.ts`, `rects.ts` (which of Justin's elements each fix reaches; element-by-element diffs);
- `sketch.diff` (my throwaway sketch of the fixes, for measuring only, not to be copied blindly).

## Open questions (the plan is written as if ⭐ is chosen)

**Q1. The R5 fix (the layout plan's room for an outlined box with no padding) changes your Services page.**
Measured: the parts table's cells get 18 px sides on tablets instead of 19, and at 768 one cell's words fit on one
line, so the table is 24 px shorter. It is correct (the plan was 4 px off), but it is a change on your page.
- A) ⭐ Move R5 to layout-floors (B5). That batch already reworks the same code (the 39/40 jump) and changes phone
  padding on your pages anyway, so you see both at once. This batch then leaves your three pages exactly as they are.
- B) Fix it here and accept the Services table change.

**Q2. Row cards (an icon beside the words, centred up and down) can't lose their frozen bottom space without moving.**
- A) ⭐ Keep their bottom padding as drawn. Trim only where the freed space lands under the content. Nothing moves at
  the design width; on phones these cards keep the extra space the import froze in, as before build .15.
- B) Trim it and put their content at the top. The icon stops being centred against the words.

## The request, played back

1. The recheck of build .15 (equal card heights) found it safe on your own pages but not on every design.
2. **R1:** cards laid out as a row (icon beside words, centred) now shift their content down by half the trimmed
   space at full width (+26 px in the probe). The build said "nothing moves at the design width"; that's false for them.
3. **R2:** on tablets, a stretched row card that turns into a column lets a fixed photo or icon grow tall: a 64×64
   square becomes 64×116.
4. **R3:** a card with a Figma min height and centred words loses the centring at full width.
5. **R4:** about 20 guards have no test (24 of 48 mutations survived). **R6:** the pills test is held by the wrong
   rule. **R7:** two branches can never run.
6. **R5:** the layout plan gives an outlined box with no padding 2× its outline too much room (on main before .15
   too).
7. Your pages (hydraulics, Services, Repairs) must come out exactly as they do now. Build order: after
   cta-label-wrap; layout-floors (B5) after this.

## What your pages do with each fix (measured, not guessed)

`survey.ts` on main, then old-against-new replays of every corpus file, the Repairs file on disk (scratch copy), git's
Services copy and inspo-brainstorm, diffed element by element (`diff.ts`), then every element's box measured in Chrome
at 1440, 1200, 990, 768, 600 and 390 (`rects.ts`):

| fix | your pages' elements it reaches | change in the paste |
|---|---|---|
| R1 (trim guard) | none: every trimmed box on your pages is a column with its words at the top | none |
| R2 (flex-grow reset) | none | none (corpus "design": one button gets `_flexGrow:tablet_portrait 0`; no element moves at any width, the same 474 marquee-only moves show old against old) |
| R3 (min height) | none: no stretched hugging box on your pages has a min height | none |
| R5 (outline room) | Services: 79 table cells; plus 19 / 9 / 1 / 7 outlined 0-padding boxes in hydraulics / Services / Repairs / GRO | Services cells 19 → 18 px sides on tablets; at 768 one record row is 24 px shorter. Hence Q1. |

With R1, R2 and R3 (Q1 A), the pastes of hydraulics, Services and Repairs are byte-identical to main's.

## R1 (MAJOR): row cards move down at full width

**Root cause.** `src/core/style/bottoms.ts:16-18` `sizedByPadding` accepts a box laid out as a row (`flow.mode ===
"row"`) whatever its cross alignment. `sharedBottoms` trims its bottom (`:43-44`). The row's Align items keeps
Figma's `center` (`style/layout.ts:47`: `fromTop` only touches columns, `:46`). The trimmed space becomes free space
inside the card, and `align-items: center` splits it: the content drops by half the trim. The bottoms.ts header's proof
("the one holding the smallest still needs exactly that … nothing moves") only holds when the free space ends up under
the content.

Evidence (probe `rowCards`, three row cards, align CENTER, bottoms 24/50/76, all drawn 166 tall; Chrome at 1200): card
C's words at y210 and icon at y219 on main; y184 and y193 with the sketch fix, the drawn place.

**Fix.** A box is trimmed only when the space the trim frees lands under its content:
- a column: always (its centring or bottom alignment is dropped by `fromTop`, 2A), except `space-between`, which
  spreads the space between items;
- a row: only when its items sit at the top (`flow.align === "start"`).
One purpose-named helper in `bottoms.ts` (e.g. `spaceFallsBelow(box)`), used by `sizedByPadding`. Rows centred or at the
bottom keep the drawn bottom (Q2 A). Update the header comment so the proof states this condition.

**Test.** Fixture variants `rowCentred` (row cards, align CENTER, frozen bottoms), `rowEnd` (align MAX), `rowTop`
(align MIN). Unit (`style-bottoms`): `rowCentred` and `rowEnd` keep every bottom; `rowTop` trims like the column
cards. Browser (`equal-cards`): `rowCentred` at 1200, every card's first child top as drawn (±1 px).

## R2 (MAJOR): a fixed photo or icon grows tall on tablets

**Root cause.** `style/sizing.ts:234` gives each fixed-width frame in a row it fills edge to edge
`flexGrow: 1` (`shares.ts:9` `fillsItsRow`: a photo frame and a words column of fixed widths filling the card). When
`row.reflow` stacks the card (`adapt/rules/rows.ts:96-103`), it resets `flexGrow` only on items that widen
(`widens`, `:17-22`). A box of 96 px or less (`BADGE_MAX`), an icon or a small picture doesn't widen, so it gets `{}`
and keeps `flexGrow: 1`, which in a column grows its **height**. On main before .15 the card hugged its content, so
there was no free height. Now the row stretches it to the tallest card, and the photo soaks up the difference. It's
the same shape change as "a reviewer's circle stretched into a pill".

Evidence (probes `rowPhotoCards` and `rowCards`, Chrome at 990, 768 and 600): the photo frame and its picture are 64×116
on main (64×64 with the sketch fix); the icon box is 48×100 (48×48 fixed). The settings are the same either way:
`_width 64, _heightMin 64, _flexGrow 1`, card `_direction:tablet_portrait column`.

**Fix.** In `row.reflow`'s stack branch (`rows.ts:98-102`), an item that doesn't widen and has a non-zero written
`flexGrow` gets `flexGrow: 0` at the first stacked tier. It keeps its size both ways, which is what "icons, small
pictures and Buttons keep their size" means once the row is a column. Written once, at the change of shape, like the
widen reset; Bricks cascades it to narrower tiers. Only `adapt/rules/` writes it, under `row.reflow`'s id.

**Test.** `adapt-rows.test.ts`: a row of a 64 px photo frame and a fixed words column filling a card, stacked at a
tier, writes `_flexGrow:<tier> 0` on the photo, and the words get `width 100%, flexGrow 0` as today; a kept row writes
neither. Browser (`equal-cards`): fixture `rowPhoto` at 990, 768 and 600, the photo stays 64×64 (±1).

## R3 (minor): a min-height card loses its centring

**Root cause.** `style/style.ts:137` passes `fromTop` for every hugging box its row stretches. `fromTop`
(`style/layout.ts:12-13, 46`) assumes a hugging box has no free space. With a Figma min height larger than its
content, it does, and Figma shows the words in its middle.

Evidence (probe `minHCentred`: three hugging cards, `minHeight 300`, justify CENTER, drawn 300; Chrome at 1200): card
C's words at 113 px into the card on main and 24 px with .15; 113 with the sketch fix, as drawn.

**Fix.** One helper "its content sets its height" (`sizing.h === "hug"` and no min height holding it open:
`limits.minH === null || box.height > limits.minH + 1`). It's used by:
- `style.ts`'s `fromTop` (one condition in place; `style.ts` is 356 lines and test-cleanup will split it, so add no
  lines there);
- `sizedByPadding` (a box held open by its min height: its padding didn't set its height, so it isn't trimmed).

It lives in `style/bottoms.ts` or `style/shares.ts`, exported.
Ruling: once size.unpin drops the min height on tablets, the card stays centred in its stretched row. That's the
designer's centring, not a hug's leftover. B5's `size.unpin` item may change that min height later.

**Test.** Fixture `minHeight` (centred) and `minHeightGrown` (min height below the content: still words at top, still
trimmed). Unit: `minHeight` keeps `justify: center` and its bottom; `minHeightGrown` drops it. Browser: `minHeight` at
1200, the words' offset as drawn (±1).

## R4 (minor), R6 and R7 (nits): untested guards, the pills test, dead branches

**What survived** (`mutations.jsonl`, `fail: 0`), and what each needs:

| mutation | guard | plan |
|---|---|---|
| M4, M5 | `round`'s −0.5 tolerance; every corner (not some) | fixture: a box with radius ½·side −0.4 is round; one with a single round corner isn't |
| M7 | a Bricks Button inside a wrapper is a button | fixture: two wrappers each holding one Button |
| M11, M12, M18 | list rows, row marquee, item marquee | a list row and a marquee row of even boxes stay `flex-start` (lists from `test/fixtures/lists.ts`, marquee fixture) |
| M13 | `items.length < 2` | a row holding one card isn't stretched |
| M14, M15 | kind frame, children > 0 | an empty painted frame beside a card. If `role === "box"` already implies both, delete the guard as dead (prove it) |
| M16, M17 | art group, turned item | a row with an art group / a sideways label beside a card |
| M20, M21 | a line grows as items join; the one-line shortcut | `drawnLines` direct: three items where the third overlaps only the grown line; a non-wrapping row of offset items is one line |
| B2, B3, B4 | `sizedByPadding`: role box, live map, laid-out | a text, a live map, an unlaid frame in a stretched line keep their bottoms |
| B7, B11 | alike by direction, by right padding | a row card beside column cards; right padding off by 4 |
| B13 / S3 | `sharedBottoms`' own stretch guard / `style.ts`'s align check | `sharedBottoms` on a non-stretching row returns empty (kills B13); S3 is then an equivalent mutant: name it in the ledger |
| B14 | `oneLine` in bottoms | a wrapping row whose two lines each keep their own smallest (with tops that don't overlap) |
| A4, A5 | `sidesOf` non-number, outline without padding | go to B5 with R5 (Q1 A): they live in `sidesAt` |

- **Rule for the builder:** each survivor ends as a test that fails without its guard (shown by re-running
  `mutate.py` against the copy), or proof it can't be reached, followed by deleting it. Nothing stays silently
  untested.
- **R6.** Split the pills test into "round pills" (radius 999, no label box) and "square label boxes placed straight in
  a row" (radius 4). Each fails with only its own guard removed (M6 and M8).
- **R7.** Delete `round()`'s `ELLIPSE` check (`shares.ts:38`): `rowEven`'s `box()` lets only frames in (`:92`), so it
  can never run. Keep `fromTop`'s space-between exception (`layout.ts:46`): R1's trim guard now uses the same
  condition, so the two say one thing. The comment should say Figma's editor never draws a hugging column with Auto
  spacing (an import or the API could). Ruling: a cheap guard, now tested through the trim fixture.

## Tasks (test first; ledger `.superpowers/sdd/2026-10-21-equal-card-fixes/progress.md`)

**Task 0. Setup.**
- Step 2 of the skill. Worktree `equal-card-fixes` from main once cta-label-wrap has merged (or now, see Overlaps).
- `npm run check` green.
- `npm run corpus` saved: the report plus copies of `corpus/out/v2/*/bricks.json`.
- Old replays (`git archive` of the base commit) of hydraulics, git's Services, the Repairs scratch copy and
  inspo-brainstorm, kept for the element diff.
- Copy `equal-card-fixes-tools/` into the ledger folder.
- `npm run snap` before-shots of a debug-like snapshot written from the fixture's `rowCentred`, `rowPhoto` and
  `minHeight` (`--sides`). None of your files shows these bugs.

**Task 1. RED.**
- Fixture variants `rowCentred`, `rowEnd`, `rowTop`, `rowPhoto`, `minHeight`, `minHeightGrown` in
  `test/fixtures/equal-cards.ts` (generic shapes, no user values; stays under ~300 lines, or split the row-card
  variants into `test/fixtures/equal-row-cards.ts`).
- Unit tests in `style-bottoms`, `style-shares`, `style-layout` and `adapt-rows`, and the three browser cases (R1, R2,
  R3 above).
- Run them: they fail on the base.

**Task 2. GREEN R1 + R3.**
- `style/bottoms.ts`: the two helpers and the new `sizedByPadding`, plus the header comment.
- `style/style.ts:137`: one condition.
- Tests green, `npm run check` green. Commit.

**Task 3. GREEN R2.** `adapt/rules/rows.ts` stack branch. Tests green; check green. Commit.

**Task 4. R4, R6, R7.**
- The guard tests from the table, each shown failing with its guard mutated.
- The R6 split; the R7 deletion.
- Re-run `mutate.py` (point `ROOT` at the copy): every survivor killed, deleted as dead, or named equivalent (S3).
- Commit.

**Task 5. Prove and compare.**
- `git checkout HEAD~3 -- src/core/style/bottoms.ts src/core/style/style.ts src/core/adapt/rules/rows.ts`: the new
  tests fail. Then `git checkout HEAD -- …`.
- Replay hydraulics, git's Services, the Repairs scratch copy and inspo-brainstorm: `diff.ts` against the Task 0
  replays shows **0 changes** on all four (the gate for "your pages unchanged").
- `npm run corpus`: pastes `cmp`-equal except corpus "design"'s one `_flexGrow:tablet_portrait`; `rects.ts` shows no
  element moved there beyond the marquee's old-against-old noise. Lint and the "Worse than v1" list unchanged.
- After-shots. Commit.

**Task 6.** The main chat runs the opus review; one fix pass (`receiving-code-review`, test first).

**Task 7. Docs & records.**
1. Plan copied to `docs/plans/2026-10-21-equal-card-fixes.md` (the build day's date if later).
2. Ledger moved to `docs/plans/2026-10-21-equal-card-fixes-ledger.md`: probes before/after, the mutation re-run, the
   diffs.
3. `docs/HANDOFF.md`:
   - a section "Equal card fixes (recheck R1–R7)";
   - a cross-reference in "Cards drawn the same height in a row";
   - paste check: **none owed**, because your pages' pastes are byte-identical (write that, and the text proof, in
     place of a check number).
4. `BUILD` bumped at the merge, `npm run build`, commit "Build <BUILD>: equal card fixes".
5. Main `CLAUDE.md` after the merge (finisher):
   - "Start here": a short entry;
   - "Where things stand" → "Cards drawn the same height": the new helpers, the `row.reflow` reset, the tests.
6. CLAUDE.md rule wording (Decisions → "Boxes drawn the same height stay the same height"): replace "A hugging box
   stretched this way keeps its words at its top" with "… whose content sets its height (no min height holding it
   open) keeps its words at its top". Append "only where the freed space falls under the content (a column, or a row
   with its items at the top)" to the shared-bottom sentence. Plus the rules-summary line.
7. `found-else.md`: R1, R2, R3, R4 (minus A4/A5), R6, R7 marked `~~item~~ ✅ fixed in build <BUILD>
   (equal-card-fixes)`. R5 (with A4/A5) annotated "moved to layout-floors". The dispatcher moves the R5 line in
   `found-batches.md` to B5.

## Risks

- **Row cards centred up and down keep their frozen bottoms** (Q2 A). On phones they end with uneven space under
  their words, as before .15. It's visible only in imported designs with that shape; none of your pages has one.
- **The `flexGrow: 0` reset** also reaches a stacked row's non-widening Button or icon that had a share of the row.
  In a column, grow only matters with free height, so the corpus shows no movement, but a design with a stretched
  stacked card and a Button in it changes (for the better: it keeps its size).
- **Deleting dead guards** (M14/M15 if proven, ELLIPSE) can't change output for reachable input. The mutation re-run
  and corpus `cmp` confirm it.
- **Timing tests** can fail `npm run check` under load (known; test-cleanup owns it). Re-run before calling a
  regression.
- **R3's ruling at tablets** (centred card stays centred once its min height is dropped) is mine, untested on a real
  file.

## Files and pipeline parts touched

- **style:**
  - `src/core/style/bottoms.ts` (R1, R3 guard, header);
  - `src/core/style/style.ts` (one condition at `:137`);
  - `src/core/style/shares.ts` (R7 deletion; maybe the helper);
  - `src/core/style/layout.ts` (comment only).
- **adapt:** `src/core/adapt/rules/rows.ts` (R2). **Not** `adapt/layout.ts` or `adapt/least.ts` (R5 goes to B5).
- **tests:**
  - `test/fixtures/equal-cards.ts` (+ maybe `equal-row-cards.ts`);
  - `test/unit/style-bottoms.test.ts`, `style-shares.test.ts`, `style-layout.test.ts`, `adapt-rows.test.ts`;
  - `test/browser/equal-cards.test.ts`.
- **docs:** plan, ledger, HANDOFF; at the merge `src/shared/build.ts`, CLAUDE.md, rules-summary, found-else.
- **Not touched:** extract, normalise, understand, emit, panel.

## Overlaps

- **cta-label-wrap (building):** its files are `adapt/layout.ts`, `adapt/least.ts`, `unpin.ts`, `label.ts` and
  `rules/index.ts`. With Q1 A this batch shares **no source file** with it. It can build beside it, or after it as
  planned; either way it rebases cleanly. Note that cta-label-wrap moves `sidesAt` into `adapt/least.ts`, so R5 now
  lives there (B5).
- **layout-floors (B5, after this):**
  - takes R5 + A4/A5 (`least.ts` `sidesAt`, next to its 39/40 jump);
  - its `size.unpin` min-height item interacts with R3's tablet ruling;
  - its "divided item's padding after the row breaks" may touch `adapt/rules/rows.ts` (shared with R2) and the
    layout plan;
  - B5 builds after B4 and rebases on it.
- **test-cleanup (queued):** splits `style/style.ts` (picture code to `style/picture.ts`). This batch changes one
  condition at `style.ts:137`: a trivial rebase either way.
- **frame-text-links, fonts-cleanup, link-upload-fixes, text-breaks:** no shared source file. Shared records only
  (HANDOFF, CLAUDE.md, BUILD, found-else.md).

## Other things found

- R5 shows on your Services page today: on tablets at 768, a parts-table cell wraps a word that would fit, because
  the layout plan counts the outlined table panel 4 px too wide. That record row is 111 px instead of 87. Fixing R5 in
  B5 un-wraps it.
- The recheck's own found-else items are already batched: size.unpin's 60 px photo card (B5), the timing-test flakes
  (test-cleanup). The R2 cause ("rows rule never resets a fixed frame's flex-grow") is the R2 fix here.

## Justin's answers (2026-10-21)
- Q1A: R5 moves to layout-floors (B5). Q2A: centred row cards keep their drawn bottom padding.
