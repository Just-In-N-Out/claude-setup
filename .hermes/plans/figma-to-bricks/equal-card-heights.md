# Equal card heights in a row (equal-card-heights)

**Approved by Justin 2026-10-20** (answers 1A 2A 3B 4A; the plan text already reflects them).

Planner: Hermes, 2026-10-20, main at `b2b3a7e` (build `2026-10-20.13`). Revised the same day for Justin's answers
(1A 2A **3B**, then **4A**). Status: **approved, built, reviewed on opus and fixed, merged as build `2026-10-20.15`**
(branch `worktree-equal-card-heights`, paste check 3ab); what the build and the fix pass found and ruled is in the
ledger, `docs/plans/2026-10-20-equal-card-heights-ledger.md`.

## Justin's answers (2026-10-20)

"1A 2A 3B".

1. Which rows keep one height? → **A) Rows whose boxes Figma draws the same height** (as recommended).
2. Inside a card that grows to match the tallest, where do its words go? → **A) They stay at the top, with the extra
   space at the bottom** (as recommended).
3. Card 3's extra bottom space (drawn 63 px against 30 px on card 1 and 39 px on card 2) → **B) Trim it to match the
   other cards** (the plan had recommended A, keep it as drawn).

**What changed because of 3B:**
- A new step (section 3, step 4): in a row or grid that now stretches its boxes, alike boxes share one bottom padding,
  the smallest among them. Card 3 goes 63 → 30 and card 2 goes 39 → 30, on every screen. Nothing moves at the design
  width.
- One line in the layout plan (`adapt/layout.ts`), so its idea of a card's side padding on phones matches the CSS
  after the trim.
- A flaw found in the first plan while checking the corpus: grouping a row's items into lines by their top edge would
  have stretched centred rows whose items differ in height. Lines are now found by vertical overlap. The same flaw is
  already on main in the grid rule, and it shows in the user's current Repairs page (section 2h).
- The work stays in `style/`, plus that one line in `adapt/layout.ts`. link-hrefs touches neither, so the two can still
  be built in parallel.

## Open questions (the plan assumes the recommended answer)

4. The same frozen bottom space also sits in the footer's link columns. They have no fill or outline. Their bottom
   paddings are 92 / 39 / 39 / 14 px on hydraulics and Services, and 115 / 0 / 62 / 95 px on the Repairs page. Trim
   those too?
   - **A) Yes: any alike boxes in a stretched row or grid, painted or not (recommended).** The footer's columns
     stack on phones with even gaps, instead of 92 px under one column and 14 under another.
   - B) Only painted cards. The footer columns keep their uneven gaps on phones.

## 1. The request, played back

Justin (WhatsApp, with a Figma screenshot and then a Bricks screenshot): "On Figma as you can see the third slot is
lined up properly with the 2nd and third. However on bricks when I use the plugin the first slot does not match up
properly and is a bit shorter in length."

1. Under the logo marquee on the hydraulics homepage sits a row of three cards: "Located in Evansville" (address, a
   thin line, three short lines of opening hours), "Call Us Now" (two lines of text and a yellow CALL US pill) and
   "Broken Down?" (warning icon, two lines of text, a line, the emergency number).
2. In Figma the three cards line up: same top, same bottom, same height.
3. In Bricks every card is a different height: "Located in Evansville" is the shortest, "Call Us Now" the tallest,
   "Broken Down?" in between. The bottoms don't line up.
4. He wants cards that Figma shows as one even row to stay one even row in Bricks, on any design, not just this one.
5. (3B) The extra bottom space the third card was drawn with only made the heights match in Figma. It goes: each card
   ends the same distance under its last line as the others.

## 2. Root cause (with evidence)

**In short: the row is sent to Bricks as "Align items: start" and each card shrinks to fit its own words. The plugin
stretches a row's cards to one height only when Figma marks every card "Fill height". These cards are "Hug height".
They only look equal in Figma because each was drawn with a different bottom padding, which happens to even them out
at Figma's exact width.**

### 2a. What Figma holds (`corpus/files/hydraulics-home.json`, section "Info cards" `506:1520`)

- The row `506:1521`: horizontal auto layout, `counterAxisAlignItems: MIN` (items at the top), height Hug, gap 18.
- The three cards (`506:1522`, `506:1534`, `506:1553`): vertical auto layout, **height Hug**, `layoutAlign: INHERIT`
  (not Stretch), fixed width 494.7, painted (fill, 1px outline, radius 8). Padding 30 on top, left and right on all
  three.
- Drawn heights 312.8 / 312.6 / 312.9 px. They match only because the bottom paddings differ: **30 / 39.19 / 63.3
  px**. The page was imported from a website (layers named `div`, `h3`, `p`). The site's CSS stretched the cards, and
  the import froze that stretch into each card's bottom padding. That evens them out at 494.7 px wide and nowhere
  else. The card with the most content (card 1) got no extra padding: its 30 is the real value.
- The same thing shows up elsewhere:
  - the footer's "Opening Hours" / "Visit the Shop" pair (`573:11985`, bottom paddings 115 / 0, both 433.6 tall);
  - the footer's link columns (`573:12060`, section 2g);
  - the user's current debug file (`figma-to-bricks-debug-page-1.json`, "Hydraulic Cylinder Repairs Final",
    row `553:7817`: one Fixed card, one Hug card, both 434 tall).

### 2b. What the plugin sends (replay of the hydraulics file on main)

`npm run replay -- corpus/files/hydraulics-home.json <out>`, Container `ialbxd` (the section's row):

```
_direction: row, _justifyContent: center, _alignItems: "flex-start", _columnGap: 18,
_flexWrap:mobile_landscape: nowrap, _direction:mobile_portrait: column, _alignItems:mobile_portrait: flex-start
```

The cards `zrbcsm`, `ekcbkb`, `xgnnxp` have `_width: 495`, `_flexGrow: 1`, `_widthMin: 0`, and **no height, min
height or align-self**. Nothing on the cards blocks a stretch: the only thing missing is the row's stretch.

### 2c. Why the row is "start"

- `src/core/style/layout.ts:46` `flowStyle`: a row's `align` is `"stretch"` only when `itemsFill` is true, otherwise
  Figma's alignment (`flex-start`).
- `itemsFill` comes from `src/core/style/style.ts:113` (Container), `:139` (box) and `:294` (made-up box):
  `rowStretches(ir) || gridStretches(ir)`.
- `src/core/style/shares.ts:25` `rowStretches`: true only when **every** item fills the row's height
  (`fillsRowHeight`, `sizing.h === "fill"`). Hug cards never qualify.
- `src/core/style/shares.ts:33` `gridStretches` already does what this row needs, **but only for Figma grids**: "A
  Figma grid whose items in each row are drawn the same height ... stretches them, so they stay equal when their words
  reflow" (build 16.3, HANDOFF "A map that didn't show, and grid cards stretched"). Rows never got the same rule.

### 2d. Why the first card ends up the shortest

- Bricks' Container is 1440 wide (1312 inside), so on the user's 1728 design the cards are about 425 px wide, not 495
  (the user's 2026-10-06 decision; not changed here).
- At 425 px the paragraphs in cards 2 and 3 wrap to three lines (the Bricks screenshot shows exactly that). Card 1's
  address stays on one line.
- Each card hugs its own content, so the frozen paddings no longer even them out.

Card heights in px, measured in the renderer (the browser tools' own page, payload as pasted):

| width | Located | Call Us | Broken Down |
|---|---|---|---|
| 1728 | 312.0 | 361.7 | 336.5 |
| 1440 | 312.0 | 336.9 | 329.1 |
| 990 (tablet, one row) | 334.8 | 357.4 | 340.3 |
| 700 (phone sideways, one row) | 334.8 | 407.0 | 386.8 |
| 390 (stacked) | 308.0 | 330.6 | 295.5 |

Same order as Justin's Bricks screenshot: card 1 shortest, card 2 tallest, card 3 in between.

### 2e. The tops

In the renderer all three tops are identical (y = 1378.8 at 1728), and the payload has no margin, align-self or
centring on any card. The few pixels between the tops in Justin's screenshot match the slant of the whole photo (the
stats bar above leans the same way). It's a photo of the screen taken at an angle, not the layout. The new browser
test still checks the tops (section 5) so this stays proven.

### 2f. Reproduce it

1. `npm run replay -- corpus/files/hydraulics-home.json <out>`: Container `ialbxd` has `_alignItems: "flex-start"`.
2. `npm run snap -- corpus/files/hydraulics-home.json <out> 1728,990`: the shot shows the three Info cards at
   different heights. Or measure `#brxe-zrbcsm`, `#brxe-ekcbkb`, `#brxe-xgnnxp` with `getBoundingClientRect()`.
3. The generic fixture in Task 1 reproduces it with no user file.

### 2g. What card 3's frozen padding breaks besides the height (3B)

The same replay, padding settings as pasted (main):

```
zrbcsm (card 1) _padding 30/30/30/30   tablet: sides 27   phone sideways: sides 17
ekcbkb (card 2) _padding 30/30/39/30   tablet: sides 28   phone sideways: sides 17
xgnnxp (card 3) _padding 30/30/clamp(44px … 63px)/30   tablet: sides 27, bottom 44   phone sideways: sides 17
                _padding:mobile_portrait  top 24, sides 20, bottom 32
```

- **One frozen side drags the others along:** `adapt/rules/space.ts:46` calls a box's padding "big" when any side is
  40 or more, and then steps all four sides down the page scale. Card 3's 63 px bottom makes it "big". So on an
  upright phone card 3 alone gets a 24 px top and 20 px sides, while cards 1 and 2 keep 30 and 17.
- **On a stretched row the frozen padding makes the whole row taller.** At 1728 the row would be 361.7 tall (card 2
  with its 39). With 30 it is about 352.5. Worked out from the table: card 2 loses 9 px, card 3 loses 33 px. Task 5
  measures it.
- **Stacked on phones each card ends a different distance under its last line:** 30, 39 and 32 px.
- **The layout plan disagrees with the CSS once it's trimmed:** `adapt/layout.ts:123` `sidesAt` decides "big" from
  Figma's padding (`n.src.flow.padding`), not from what the style stage wrote. After the trim, `space.ramp` would keep
  card 3's sides at 30 while the layout plan assumed 20.

**How often it happens (survey of the 5 corpus files, the user's Repairs file on disk and git's Services copy, read
only):**
- 293 rows or grids hold 2+ laid-out boxes. 209 of them have uneven bottom paddings, but nearly all of those are a
  list's table cells (lists keep their own rules) or boxes unlike each other (a nav link beside a button, a text
  column beside a map card).
- Only **5** have alike boxes (same top, left and right padding) drawn the same height with uneven bottoms:
  - the hydraulics Info cards (30 / 39 / 63);
  - the footer's link columns, in hydraulics, page-1 and Services (92 / 39 / 39 / 14) and in Repairs
    (115 / 0 / 62 / 95).
- Left alone by the rule below: the footer's Opening Hours / Visit the Shop pair (34 px sides and top against 0: not
  alike), the Repairs footer pair (one Fixed card) and every other row (their bottoms already match).

### 2h. A flaw in how lines are found (found during the revision; on main in grids)

- `gridStretches` puts items in the same line when their **tops** are within 2 px. A shorter item centred in its line
  has a lower top, so it lands in a "line" of its own, which is trivially even, and the grid stretches.
- On main this shows in the user's current Repairs file: grid `553:7783` holds a 378 px text column, centred in its
  cell (Figma `cell: center`), beside a 588 px product box.
  - The plugin writes `_alignItems: stretch` on the grid and no centring on the column (`sizing.ts:249` skips it when
    `byRow`).
  - So in Bricks the text sits at the top of the 588 px cell instead of in its middle.
- The first plan copied that grouping into `rowEven`. It would have stretched centred rows whose items differ in
  height: a nav row of links beside a button, a label beside an avatar.
- Fix: items share a line when they overlap up and down, and a row that doesn't wrap is one line. Checked on the
  survey files: no corpus grid changes. The Repairs grid stops stretching and its text column goes back to the middle,
  as drawn.

## 3. The approach

Give rows the rule grids already have: **boxes that Figma draws the same height stay the same height in Bricks.**
Where that stretch takes over, **alike boxes share one bottom padding**, so space frozen in only to fake equal
heights goes.

1. **`evenLines(boxes, oneLine)`** (new, `style/shares.ts`): groups items into drawn lines by vertical overlap. Items
   whose boxes overlap up and down share a line, and a row that doesn't wrap is one line. A line is even when its
   items' heights are within 2 px. `gridStretches` uses it (section 2h).
2. **`rowEven(row)`** (new, `style/shares.ts`): a row stretches its items (Bricks "Align items: stretch") when all of
   these hold:
   - it is a row (`flow.mode === "row"`) with 2+ flowing items;
   - its Figma alignment isn't Baseline (Top, Centre and Bottom all qualify: with equal heights Figma draws them the
     same);
   - every item is a box (role `box`, a frame holding layers). Not texts, pictures, icons or Buttons, so a row of
     buttons or a title beside a photo never changes;
   - none is turned (`sideways`) or a one-picture art group;
   - every line is even (`evenLines`);
   - the row is not a list's row or title row (`ir.list`: `adapt/rules/list.ts` already lines up those columns) and
     not part of a logo marquee (`ir.marquee`).
3. **One entry point:** `stretchesItems(ir) = rowStretches(ir) || rowEven(ir) || gridStretches(ir)`, used at the three
   `style.ts` call sites.
4. **Shared bottom padding (3B)** (new, `style/bottoms.ts`, `sharedBottoms(row) → Map<key, bottom>`). For a row or
   grid that stretches its items, in each line (`evenLines`):
   - **Which boxes:** boxes (not a live map) that hug their height, are laid out (column or row), and hold no flowing
     layer that fills their height.
   - **Alike:** the same layout direction, the same top, left and right padding (to 1 px, measured as written:
     `innerPadding`), and both painted (a fill or an outline) or both plain.
   - **The value:** each group of 2+ alike boxes on a line takes **the smallest bottom padding** in the group. Only
     larger ones change (lowered, never raised), and only when they're more than 1 px larger (rounding stays as drawn).
   - **Why the smallest:** in a frozen stretch the box with the most content got no extra padding, so its value is
     the real one. It's also the only value that can never move anything at the design width:
     - every alike box is drawn at the line's height H = top + content + its bottom;
     - after the trim each one needs at most H;
     - the box holding the smallest still needs exactly H;
     - so the stretched line stays H, every box stays H tall, and its words stay where drawn (they start at the top,
       step 5).
   - **Not touched:** Fixed or Fill height boxes (their padding never set their height), boxes unlike each other
     (another top or side padding, painted beside plain), a box alone of its kind on its line, and every row or grid
     that doesn't stretch.
   - **Wiring:** `style.ts` already marks a stretching parent's children (`byRow`, line 341). It also records
     `sharedBottoms(ir)` there, and `box()` writes that bottom in place of the drawn one. The value lands in
     `Style.padding`, so `space.ramp` steps the trimmed value (card 3 is no longer "big"). `innerPadding` moves from
     `style.ts` to `style/layout.ts` so `bottoms.ts` can use it.
5. **The words in a stretched card stay at its top** (2A). A box that hugs its height and is stretched by its row or
   grid (`byRow`) drops its own vertical centring or bottom alignment (`justify`) and starts at the top. In Figma a
   hugging box has no free space, so the centring shows nothing there. In Bricks it would push the words into the
   middle of the taller card (the user's 16.3 complaint about "Opening Hours pushed to its card's middle"). Done in
   `layout.ts` `flowStyle` with an option, set from `style.ts` `box()`.
6. **The layout plan reads the written padding:** `adapt/layout.ts` `sidesAt` takes "big" and the sides from the
   padding the style stage wrote (`Style.padding`, what `space.ramp` steps), falling back to Figma's. It already reads
   `styled` for `wrap`. A later stage reading an earlier one's recorded output fits the architecture rules.
7. **Nothing else changes:**
   - Boxes drawn at different heights keep their own heights and paddings, at the top (16.3's rule, kept and
     re-tested).
   - Stacked on phones, `row.reflow` already writes `align: flex-start` (`adapt/rules/rows.ts:83`), so each card goes
     back to its own height there, now with the shared bottom padding. Two per row: each line's cards match.
   - On tablets and phones held sideways, where alike cards stay one row (`decideRow` `alikeCards`), the stretch holds.
   - No card gets `_alignSelf`: `payloadProblems` still refuses `_alignSelf: stretch`.
   - The Bricks key `_alignItems: "stretch"` on section/container/block/div is already in use (16.1, the user's
     ExampleBricks "Info row"), and `_padding` is the existing key. No new Bricks key, no new sample needed.

**Expected effect on the user's files:**
- **Lined up:**
  - hydraulics: the Info cards, the stats strip under the hero (`506:1461`), the three outlined boxes (`506:1584`) and
    the footer's Opening Hours / Visit the Shop pair;
  - Services: the stat tiles, reviews, photo pair and footer pair;
  - the Repairs file's footer pair.
- **Bottom padding shared:**
  - Info cards 2 and 3 → 30 at every width;
  - the footer's link columns → 14 (hydraulics, page-1, Services) or 0 (Repairs).
- **Back to the middle, as drawn:** the Repairs product grid's text column (2h).
- **Untouched:** the list's records and title row.

## 4. Tasks (test first; ledger in `.superpowers/sdd/2026-10-20-equal-card-heights/progress.md`)

**Task 0. Setup.** Step 2 of the skill: worktree `equal-card-heights`, `.worktreeinclude` copies, `npm run check`
green, `npm run corpus` numbers saved in the ledger.

**Task 1. Generic fixture + RED tests.**
- `test/fixtures/equal-cards.ts` (builders only; nothing from the user's file: other words, widths, paddings,
  colours). A page 1200 wide, with a section, a heading and a row (Hug height, items at the top, gap 20) of three
  painted cards. The cards are vertical, padding 24 on top, left and right, Hug height, fixed width 360, and their
  contents differ:
  - A: icon box, title, three short lines in a box with a top outline (the most content);
  - B: icon box, title, a two-line paragraph, a pill;
  - C: icon box, title, a one-line paragraph, a box with a top outline holding one line;
  - bottom paddings 24 / 40 / 72, chosen so all three are **drawn** 300 px tall (a frozen stretch).
- Variants (options of one builder):
  - `uneven`: drawn 260 / 300 / 280;
  - `centred`: the cards centre their content;
  - `wrapping`: six cards in a wrapping row, two drawn lines, each line with its own smallest bottom;
  - `mixed`: a box beside a text;
  - `buttons`: a row of two Buttons drawn the same height;
  - `baseline`;
  - `centredRow`: a centred row of a 40 px box beside a 64 px box;
  - `centredCell`: a Figma grid with a hugging column centred in its cell beside a taller box;
  - `unlikeTop`: C's top padding 32;
  - `unlikeSides`: C's left padding 40;
  - `fixed`: the cards Fixed height 300;
  - `fillChild`: C holds a layer that fills its height;
  - `plain`: the same three with no fill or outline;
  - `mixedPaint`: A painted, B and C plain;
  - `rounding`: B's bottom 0.6 px more than A's.
- `test/unit/style-shares.test.ts` (new; `style.test.ts` is already 794 lines):
  1. even cards: the row's `align` is `"stretch"`; no card has `alignSelf`, `height` or `heightMin`;
  2. `uneven`: the row stays `"flex-start"` (16.3);
  3. `mixed`, `buttons`, `baseline`: unchanged from today;
  4. `centred`: stretched, and each card's `justify` is gone (its words at the top);
  5. `wrapping`: both drawn lines even → stretch; make one line uneven → no stretch;
  6. `centredRow`: not stretched (lines found by overlap, not by top);
  7. `centredCell`: the grid is not stretched and the column keeps `alignSelf: "center"`;
  8. a list from `test/fixtures/lists.ts`: its record rows and title row unchanged.
- `test/unit/style-bottoms.test.ts` (new):
  1. even cards: B's and C's `padding.bottom` equal A's (24); A and every other side unchanged;
  2. `uneven`: every bottom as drawn (no stretch, no trim);
  3. `unlikeTop`, `unlikeSides`, `fixed`, `fillChild`: C as drawn; in `unlikeTop` and `unlikeSides` A and B still
     share;
  4. `plain`: trimmed like the painted ones (question 4, A);
  5. `mixedPaint`: A as drawn; B and C share the smaller of their own two;
  6. `rounding`: B as drawn;
  7. `wrapping`: each line takes its own smallest.
- `test/unit/convert-equal-cards.test.ts`:
  - the payload row has `_alignItems: "stretch"` and `payloadProblems` is empty;
  - B's and C's `_padding` and every `_padding:<breakpoint>` equal A's (no "big" stepping on C);
  - where the row stacks, `_alignItems:mobile_portrait: "flex-start"` is still written;
  - nothing at tablet undoes the stretch.
- `test/unit/adapt-layout.test.ts` (one case): at `mobile_portrait` the layout plan gives C's content the same room
  as A's (`sidesAt` reads the written padding).
- `test/browser/equal-cards.test.ts`: render the fixture's paste at 1200 (its design width), 990, 600 and 390.
  1. Wherever the cards share a line, their tops and heights match to 1 px.
  2. At 1200 each card is 300 ± 1 px tall, as drawn: the trim moves nothing there.
  3. At every width the cards' computed `padding-bottom` is equal.
  4. At 390 (stacked) each card is full width and as tall as its own content (heights differ).
  5. `uneven`: heights differ at the design width, as drawn.
- Run them: they fail on main (the even cards differ by more than 10 px in the browser; C's bottom is 72).

**Task 2. GREEN: the stretch.**
- `src/core/style/shares.ts`: `evenLines`, `rowEven`, `stretchesItems`; `gridStretches` uses `evenLines`.
- `src/core/style/style.ts`: the three call sites use `stretchesItems`; `box()` passes "starts at the top" to
  `flowStyle` when `byRow.has(ir.key)` and the box hugs its height.
- `src/core/style/layout.ts`: `flowStyle`'s option drops `justify` for a column that starts at the top.
- `test/unit/style-layout.test.ts`: one case for the new `flowStyle` option.
- The `style-shares` tests green; `npm run check` green. Commit.

**Task 3. GREEN: the shared bottom padding (3B).**
- `src/core/style/bottoms.ts` (new, about 40 lines): `sharedBottoms(row)` as in section 3 step 4.
- `src/core/style/layout.ts`: `innerPadding` moves here from `style.ts` (exported; `button()` uses it too).
- `src/core/style/style.ts`: a `bottoms` map filled beside `byRow` (line 341); `box()` writes the shared bottom.
  `style.ts` stays under its current 355 lines.
- `src/core/adapt/layout.ts` `sidesAt`: "big" and the sides from the written `Style.padding`, Figma's as fallback.
- The `style-bottoms`, convert, layout and browser tests green; `npm run check` green. Commit.

**Task 4. Prove the tests catch the bugs.**
- With the fixes committed, revert the source files that wire them:
  `git checkout HEAD~2 -- src/core/style/shares.ts src/core/style/style.ts src/core/style/layout.ts
  src/core/adapt/layout.ts`. `bottoms.ts` is new; it stays in place but unused.
- Check that the unit, convert, layout and browser tests fail. Then `git checkout HEAD -- <same files>`.
- Do the same with `HEAD~1` for Task 3 alone: the bottoms tests fail and the stretch tests pass.
- Note both in the ledger.

**Task 5. The user's files and the corpus.**
- Replay and snap `corpus/files/hydraulics-home.json` at 1728, 1440, 990, 700 and 390:
  - the Info cards, stats strip, outlined boxes and footer pair share one height and one top wherever they share a
    line;
  - stacked at 390 each has its own height;
  - Info cards 2 and 3 have `_padding` bottom 30, and their tier paddings equal card 1's;
  - the footer's link columns have bottom 14;
  - put the before/after table (heights, like section 2d, plus each card's bottom padding) in the ledger.
- Same for the Repairs debug file:
  - its footer pair `553:7817`;
  - its footer link columns → 0;
  - the product grid `553:7783`: not stretched, its text column centred beside the product box at 1728 and 1440.
- Same for git's copy of Services Page Final (`git show HEAD:figma-to-bricks-debug-page-1.json`): stat tiles,
  reviews, photo pair, footer pair, link columns → 14. The list's records must be byte-identical.
- Golden `test/golden/files/convert-sample.json`: if it changes, check that every line of the diff is one of these,
  then `UPDATE_GOLDEN=1`:
  - a stretched row;
  - a dropped `justify` on a stretched card;
  - a shared bottom padding (and the tier paddings that follow from it);
  - a grid back to its cells' own places.
- **Check first (not yet checked by the planner):**
  - the newly stretched rows in corpus "design" (12, mostly rows of Fixed 39 px boxes) and "final-design" (6, among
    them "Frame 7": a 54 px Fixed box beside a 56 px Hug box): they should move by at most 2 px;
  - the measured Info-card heights after the trim (the 352.5 in 2g is worked out, not measured);
  - the phone footer's link-column gaps at 390 and 700 on hydraulics and Repairs.
  Put the results in the ledger; anything visibly worse is a review question, not a silent ruling.
- `npm run corpus`: no file worse at any width. Expected: only the rows and columns listed in section 3 change.
  Section heights may move a few px, toward Figma's where a shorter card grows, and shorter where the tallest card
  was tall only because of its frozen padding. Explain any lint change.
- Commit.

**Task 6. Review and fix pass.** The main chat runs the opus review; then `receiving-code-review`, each fix test
first.

**Task 7. Docs & records** (the builder writes the first three; the finisher does the rest at the merge):
1. Copy this plan to `docs/plans/2026-10-20-equal-card-heights.md` (use the build day's date if later).
2. Move the ledger to `docs/plans/2026-10-20-equal-card-heights-ledger.md`: the cause, before/after heights and
   paddings, corpus numbers, rulings and deferred minors.
3. `docs/HANDOFF.md`:
   - a new section **"Cards drawn the same height in a row"**: the report, the cause (2a–2h), the fix (stretch,
     shared bottom padding, lines by overlap), the tests, the corpus effect and the rulings;
   - a cross-reference line in "A map that didn't show, and grid cards stretched": rows now follow the grid's rule,
     and the grid's lines are found by overlap;
   - the **paste check owed**, the next free number in "End-of-run check list" (link-hrefs merged first and took
     3aa, so **3ab**): "Convert the hydraulics homepage again, paste into an empty page, Cmd+S. At
     desktop, at 990 and on a phone held sideways, the three cards under the logo marquee share one top and one
     bottom; the footer's Opening Hours / Visit the Shop pair too. On an upright phone each card stacks at its own
     height, with the same space under its last line and the same side padding in all three. On the Repairs page the
     words beside the product photo sit in the middle of it."
4. **`BUILD`** bumped in `src/shared/build.ts` at the merge (`2026-10-20.15`: link-hrefs merged first as
   `2026-10-20.14`), `npm run build`, commit "Build <BUILD>: cards drawn the same height stay the same height".
5. The main folder's `CLAUDE.md`, after the merge, by the finisher following figma-to-bricks Step 4:
   - **"Start here":** a short entry with the build, the cause in one line, and check 3ab;
   - **"Where things stand":** the code (`style/shares.ts` `rowEven`/`evenLines`/`stretchesItems`, `style/bottoms.ts`
     `sharedBottoms`, `layout.ts`'s top option and `innerPadding`, `adapt/layout.ts` `sidesAt`), the tests and the
     corpus effect.
6. **New `CLAUDE.md` rule** (under "Decisions the user made" → Layout, with Justin's words "1A 2A 3B" and the date):
   "Boxes that Figma draws the same height in a row or a grid stay the same height (the row's Align items: stretch,
   never the item's Align self). A line is items that overlap up and down. Boxes drawn at different heights keep their
   own heights at the top (16.3). A hugging box stretched this way keeps its words at its top. In such a line, alike
   boxes (same top and side padding, painted alike, hugging their height) share the smallest bottom padding among
   them: space a website import froze in to fake equal heights goes, and the design width doesn't change."

## 5. Tests (summary)

- Unit:
  - `test/unit/style-shares.test.ts` (8 cases);
  - `test/unit/style-bottoms.test.ts` (7 cases);
  - `test/unit/style-layout.test.ts` (1 case);
  - `test/unit/adapt-layout.test.ts` (1 case).
- Convert: `test/unit/convert-equal-cards.test.ts` (stretch, equal paddings at every breakpoint, stacked
  `flex-start`).
- Browser: `test/browser/equal-cards.test.ts` (tops, heights and bottom padding per width; drawn heights kept at the
  design width; stacked phones; uneven cards).
- Fixture: `test/fixtures/equal-cards.ts` (generic, 15 variants).
- Existing guards that must stay green:
  - `style.test.ts` 16.1 and 16.3 cases;
  - `payload.test.ts` (no `_alignSelf: stretch`);
  - `adapt-rows.test.ts` (stacked `flex-start`);
  - `adapt-space.test.ts`, `adapt-list.test.ts`, `emit-paste-ids`;
  - the golden file.
- Proof of failure without the fix: Task 4.

## 6. Choices I made (written as if the recommended answers were picked)

1. **The trigger is "drawn the same height" (2 px), not "cards that look alike"** (1A). It follows Figma's own
   drawing and the grid rule that's been live since 16.3. Rows drawn at different heights keep hugging at the top.
2. **A line is the items that overlap up and down,** not the ones whose tops match. Otherwise a centred row of a small
   and a big box would count as even. This also fixes the grid rule (2h).
3. **Boxes only.** Texts, pictures, icons and Buttons never stretch, so a title beside a photo or a pair of buttons
   doesn't change.
4. **Top, centre and bottom-aligned rows all count;** baseline rows don't. With equal heights Figma draws them the
   same.
5. **Wrapping rows are checked line by line,** like grids.
6. **Lists and marquees are left to their own rules** (`list.layout` already lines up a record's columns).
7. **Words stay at the top of a stretched card** (2A). 16.3's complaint was the opposite case. This also covers grids
   that stretch; in the corpus none of those centres its content, so no grid output changes from it.
8. **Alike boxes in a stretched line share the smallest bottom padding among them** (3B). The smallest is the real
   value in a frozen stretch, and the only one that can't change the design width. The most common value would need a
   majority (the Info cards have none). "Equal to the top padding" would cut a real bottom wherever a design uses more
   space at the bottom than the top on every card, and would shrink the row at the design width.
9. **When it applies:** boxes that hug their height, with the same direction, the same top and side padding to 1 px,
   painted alike, and no layer filling their height, when the bottoms differ by more than 1 px. Fixed or Fill boxes,
   boxes with another top or side padding, and a box alone of its kind keep their padding as drawn.
10. **Plain columns count as well as painted cards** (question 4, A): the footer's link columns stack with even gaps.
11. **The trim is the box's padding on every screen,** so `space.ramp` steps the shared value. Card 3 gets card 1's
    padding at every width, on upright phones too, where today it alone gets 24 / 20 / 32.
12. **The layout plan reads the padding the style stage wrote,** so it agrees with the CSS.
13. **The footer's Opening Hours card keeps its 115 px bottom.** Its partner, the map card, has no padding at all, so
    nothing proves which value is real (Justin's guard: different top padding means leave it).
14. **Stacked phones keep each card's own height** (as today); only cards sharing a line match.
15. **The Container stays 1440** (the user's 2026-10-06 decision). So the row is taller in Bricks than Figma's 313 px
    (the tallest card wraps more), but even.

## 7. Risks

- **A bigger bottom a designer drew on purpose on one of several alike cards** (a "featured" card) is trimmed to its
  siblings' value. It's invisible at the design width (the stretch keeps every card as tall as drawn). It shows only
  where the words wrap differently or the cards stack, and there the card ends like its siblings.
- **The footer's link columns sit closer on phones** (question 4, A). The gap between stacked columns becomes the
  grid's own gap (50, stepped down by the space rule) plus the shared padding: 14 on hydraulics and Services, 0 on
  Repairs. They never touch.
- **The footer's Opening Hours card keeps its frozen 115 px** (choice 13). Stacked on phones it keeps more space under
  its hours than above them (capped at 40 by the space rule), as today. Deferred: it needs a rule for a lone card,
  which Justin's guard rules out for now.
- **Section heights change** where a shorter box now grows to the tallest (toward Figma's drawing), and shrink a
  little where the tallest box was tall only because of its frozen padding. `npm run corpus` must be no worse; the
  ledger explains every change.
- **The Repairs page changes where it wasn't reported:** the words beside the product photo move from its top to its
  middle, as Figma draws them (2h). It's a fix, but Justin will see it.
- **The layout plan now reads the written padding.** Where an outline outside the layout made Figma's padding and the
  written one differ, a width decision may move by a pixel. It now matches the CSS. Corpus checks.
- **Boxes drawn the same height by chance** (an unpainted text column beside a photo box) now stretch. That's
  invisible unless the box paints something; a box with a background photo shows a little more of it.
- **Dropping the centring of a stretched hugging box** loses a setting Figma doesn't draw anyway. If a designer meant
  it, the words sit at the top instead of the middle.
- **Bricks' editor:** `_alignItems: stretch` is already in the user's own ExampleBricks, and `_padding` is an existing
  key, so no round trip is owed. The live paste is still the final judge (check 3ab).
- **The renderer** draws `_alignItems` and padding exactly like Bricks' front end (plain CSS); no renderer change.

## 8. Parts of the pipeline this touches

- **style:**
  - `src/core/style/shares.ts`: `evenLines`, `rowEven`, `stretchesItems`; `gridStretches` uses `evenLines`;
  - `src/core/style/bottoms.ts` (new): `sharedBottoms`;
  - `src/core/style/layout.ts`: `flowStyle`'s "starts at the top" option, and `innerPadding` moved in;
  - `src/core/style/style.ts`: three call sites, the `bottoms` map, `box()`.
- **adapt:** `src/core/adapt/layout.ts` `sidesAt` (one change: read `Style.padding`). Not a rule file; no breakpoint
  style is written there.
- **tests:**
  - `test/fixtures/equal-cards.ts`;
  - `test/unit/style-shares.test.ts`, `test/unit/style-bottoms.test.ts`, `test/unit/convert-equal-cards.test.ts`,
    `test/unit/style-layout.test.ts`, `test/unit/adapt-layout.test.ts`;
  - `test/browser/equal-cards.test.ts`;
  - maybe `test/golden/files/convert-sample.json`.
- **docs:** `docs/plans/2026-10-20-equal-card-heights*.md`, `docs/HANDOFF.md`; after the merge `src/shared/build.ts`
  and the main folder's `CLAUDE.md`.
- **Not touched:**
  - extract, normalise, understand;
  - `adapt/rules/*`: `row.reflow`'s stacked `flex-start` and `space.ramp`'s stepping are relied on, not changed;
  - emit (existing keys), the panel.

## 9. Overlap with link-hrefs (being built now)

- **No shared source file.** link-hrefs touches `normalise/links.ts`, `normalise/text.ts`, `emit/payload.ts` and
  `src/ui/*`. Its plan says style and adapt aren't touched.
- **3B adds one file outside `style/`:** `src/core/adapt/layout.ts`. link-hrefs doesn't touch it, so the two can still
  be built **in parallel**.
- **Shared records only:**
  - `docs/HANDOFF.md`: separate new sections, plus one End-of-run check each;
  - the main `CLAUDE.md` and `BUILD` at the merge.
- **Whoever merges second:**
  - rebases (HANDOFF: keep both sections);
  - takes the next free check number (3aa / 3ab) and the next `BUILD`;
  - runs `npm run corpus` after the rebase as usual.
- **Corpus diffs don't mix:** link-hrefs expects byte-identical corpus pastes. This plan changes layout and padding
  settings in 4 of the 5 corpus files: hydraulics, page-1, design and final-design; GRO is unchanged.


## Justin's answers, revised plan (2026-10-20)

4A: trim matching boxes in a stretched row or grid, painted or not (footer link columns included). With 1A 2A 3B this approves the plan as written.
