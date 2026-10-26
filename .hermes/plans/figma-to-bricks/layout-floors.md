# Layout floors: squeezed titles, collapsing boxes, padding jumps (layout-floors, B5)

**Approved under Justin's away auto-go 2026-10-21 ~07:00** (⭐ answers F1A F2A F3A). Flag for Justin: F2A makes big padded boxes roomier on upright phones (20→32 on ~120 corpus boxes).

Planner: Hermes, 2026-10-21. Main at `f3d6ed8` (build `2026-10-21.4`). Plan only: no copy, code or commit made.
Loaded `figma-to-bricks` (PLANNER) and `systematic-debugging`; every item below was reproduced with the renderer at
the paste's real widths (scratch tools in `~/.hermes/cache/scratch/layout-floors/`: `probe.ts` dumps the layout plan
for element ids, `measure.ts` measures them in Chrome, `heights.ts` is the generic item-2 fixture, `scan.ts` and
`sides.ts` count what each fix reaches in every file). Builds **after cta-label-wrap and after equal-card-fixes (B4)**.

## Open questions (the plan is written as if each ⭐ was chosen)

**F1. Boxes that lose their height on tablets (item 2). Which keep it?**
- **A ⭐ Two kinds keep it.** (1) A box Figma draws at a fixed width and height keeps its drawn height wherever it
  keeps its drawn width (a numbered circle, an icon tile, a photo card). (2) A box showing a photo as its own fill keeps
  the photo's shape where it gets narrower, like photos do. Everything else lets go on tablets, as today (v1's rule).
- B. Only kind (1).
- C. Leave it as v1 did (drop the item).

**F2. The 39/40 padding jump on upright phones (item 3).**
- **A ⭐ Each side on its own, at most 32 on upright phones.** Sides up to 32 stay as drawn (the Info cards keep the 30
  you approved for P1A); 33–39 and 40+ all become 32. No other side's size decides it.
- B. Every side above 20 becomes 20 (v1's cap for every box; the Info cards go 30 → 20).
- C. Leave it (v1's rule; drop the item).

**F3. The inspo-brainstorm Industries pills (item 5).**
- **A ⭐ Fix only the uneven pills:** alike pills in one row share one side padding (the smallest). The sideways-scroll
  strip's phone layout around them becomes its own item.
- B. Drop the item (it's your experiment file, not your site).

## The request, played back

1. Repairs page, 480 px: the 2-column service cards squeeze their titles to 31 px ("Rods 1″–15″ & Rechroming Rods" on
   6 lines).
2. Boxes with a drawn height (a photo card, a numbered circle) collapse on tablets.
3. A box with 39 px sides keeps 39 on upright phones; one with 40 drops to 20. Near-identical designs look different.
4. GRO's "Let's talk →" pill: on sideways phones the paste shows the tablet's 22 px sides (your P2B, kept) while the
   layout plan assumes Figma's 34. The plan and the paste should agree.
5. inspo-brainstorm's Industries pills look rough on phones.
6. The layout plan still counts a divided item's padding and line after its row breaks.
7. (moved here from B4, equal-card R5) The plan gives an outlined box with no padding 2× its outline too much room;
   your Services parts table wraps a word at 768 that would fit. Plus mutations A4/A5 (untested guards in `sidesAt`).
8. General logic only, every width checked, nothing on your pages worse.

## Item 1: Repairs card titles squeezed to 31 px

**Reproduced** (`npm run wraps` + `measure.ts`, scratch copy of the on-disk debug file):

| width | card `wmhxsm` | words column `yzqwuf` | title `zqauio` |
|---|---|---|---|
| 991 | 453 | 267 | 235, 1 line |
| 768 | 341 | **155** (title spills out: card scrollWidth 359) | 235, 1 line |
| 600 | 277 | **91** | 4 lines |
| 480 | 217 | **31** | **6 lines** |
| 400 | 368 (1 column) | 182 | 2 lines |

Same for `uhdrvx` and `szfrvv`, and the 4th card.

**Root cause (not the title's floor).**
- The card is a row of [number box 80, words column (Figma *fill*), arrow 16]. All three count as labels
  (`understand/widgets.ts:41`: a box holding one text is a label), so `decideRow` (`layout.ts:165`) makes the row
  **wrap** from tablets down. The plan then gives each item the whole row (`layout.ts:239`, 162.5 px at 480).
- But the paste can't wrap it: a fill item in a row is written `flex-grow:1; flex-basis:0; min-width:0`
  (`style/sizing.ts:204-207`). A flex line breaks by each item's basis clamped by its min-width: here 0, so the words
  column never moves to its own line and gets what's left beside the number and arrow (31 px).
- `size.unpin` letting the title's 235 px floor go at 767 (`unpin.ts:55-57`) only decides *how* it fails: with the
  floor kept, the title spills out of the card instead (that's what happens at 768 today).
- Probe: `min-width: min(235px, 100%)` on the words column alone puts it on its own line at 768/600/480 (163 px wide at
  480, 2 lines, nothing spills) and leaves 991 and 400 as they are.

**Fix** (`adapt/rules/rows.ts`, `row.reflow`): at the first tier where a row is planned `wrap` (not drawn wrapping),
each fill item gets a floor: `widthMin: min(<its least>px, 100%)`, its least from `layout.least` (cta-label-wrap).
`row.reflow` lists `size.unpin` in `overrides` (it already runs after it). Scan: only Repairs' 4 service cards have a
fill item in a planned-wrap row today (`scan.ts` over the 5 corpus files, Repairs and inspo).

**Overlap with cta-label-wrap:** its grid check (`fits` needs each cell ≥ its widest item's least) may count this card
as the sum of its row (~52 + 47 + 235 + 16 + 36 ≈ 386 px) and drop the grid to one column from tablets down. That
would hide item 1 but also change the Repairs grid on tablets. Task 0 re-runs the repro on the merged main; if the
31 px is gone, item 1 shrinks to the guard test (and the fixture stays, a 2-column grid of such cards).

**Test:** generic fixture (a 2-column grid of cards: a small number box, a fill column with a 30-letter title, an
icon), `adapt-rows` unit test for the floor at the wrap tier; browser test at 768/600/480: the title column is ≥ its
row's width or its least, no card's scrollWidth > clientWidth + 1.

## Item 2: boxes that lose their drawn height on tablets

**Reproduced** (`heights.ts`, a generic fixture, Chrome): an 82×82 numbered circle holding "01" is **82×25** from 990
down; a 344×300 card painted with a photo, its caption at the bottom, is **344×73** from 990 down.

**Root cause:** `style/sizing.ts:244-247` writes a fixed box's height as `heightMin` (so it can grow), and
`size.unpin` (`unpin.ts:40-49`) writes `heightMin: <reach of its placed layers>` (0 for most) at tablets for every flow
box with flow content. A min height never pins anything, so letting it go only makes boxes whose drawn height *is*
their shape collapse to their words. (v1 did the same: `docs/research/v1-phone-rules.md` §4.)

**Fix (F1 A), in `unpin.ts`:**
- A box fixed both ways keeps its drawn min height on every tier where `layout.width` is its drawn width; the
  let-go moves to the first tier where it gets narrower (none, for a badge).
- A box (not a section) showing a photo fill with a fixed height: where it gets narrower, `heightMin: 0` plus
  `aspect-ratio: W / H`, as `picture.band` does (`band.ts:19`).
- Everything else as today. A hugging card with a Figma min height (B4's R3) is not fixed both ways: unchanged.

**Reach** (`scan.ts`): boxes fixed both ways at their drawn width: Repairs 15, Services 19, hydraulics 5, GRO 32,
design 8, final-design 8, inspo 6. Most are buttons whose words already make them that tall (no visual change);
the builder lists every one that moves at 990/768/390 with its before/after height. Photo-fill boxes that narrow:
2 in design (1606 × 933 and 1622 × 817).

**Test:** the `heights.ts` fixture as `test/fixtures/drawn-heights.ts`; unit test on unpin's writes; browser test:
the circle is 82×82 at 990/768/390, the photo card 300 tall at its drawn width and W/H shaped when narrower.

## Item 3: the 39/40 jump

**Root cause:** `space.ts:47-54`, `sideAt`: if any side of a box is ≥ 40 ("big"), every side steps and is capped at 20
on upright phones (`BOX_CAP.phone`), else each side stays as drawn (only `sideCap` for a box narrower than drawn).
So 39 → 39 and 40 → 20; and a box with a 40 top and 24 sides gets 20 sides (hydraulics `cvsrhj`, `ayszrh`). The layout
plan copies the same switch (`layout.ts:135`; moving to `least.ts` with cta-label-wrap).
Repairs product box `kffcjo` (39) keeps 39 at 390, `igycsd` (40) gets 20.

**Fix (F2 A):** one function, `shownSide(...)`, used by both `space.ts` and the plan's `sidesAt` so they can't
disagree: each left/right side on its own: tablets and sideways phones as today; upright phones `min(side, 32)`, then
`sideCap` for a narrower box. Top/bottom unchanged (see Other things found).
**Reach** (`sides.ts`): sides 40+ go 20 → 32 at 390 on design 55 boxes, final-design 29, inspo 22, hydraulics 12,
Repairs 3, Services 4, GRO 2; sides 33–39 go → 32 on 10 boxes. Sides ≤ 32 (hundreds on your pages) unchanged.
**Test:** `adapt-space` unit: sides 39 and 40 give the same upright-phone value; 30 stays 30; a 40-top box keeps its
24 sides; the plan's room equals the CSS content box for each.

## Item 4: GRO "Let's talk →", plan vs paste on sideways phones

**Reproduced** (`gro-home.json`): the pill `jvdcnf` shows 22 px sides at 700/600/480 (written at tablet, cascaded,
P2B) and 34 at 400. The plan (`probe.ts`) gives it 204 px at `mobile_landscape` with Figma's 34 sides.
**Root cause:** `layout.ts:129-140` works out each tier's sides on their own; Bricks cascades tablet → sideways
phones, and `space.ts:90` only writes a tier that changes. Where `sideAt` says "as drawn" at sideways phones, the paste
keeps the tablet's squeeze but the plan uses Figma's.
**Fix:** `shownSide` (item 3) takes the tier above's shown value: sideways phones inherit tablets' unless written;
upright phones get the drawn one back (P1A). The plan walks tiers top-down already, so it keeps each node's shown
sides per tier. No CSS change (P2B stays); only rooms change (the plan gives the label 163 not 136 here).
**Test:** the P2B fixture from phone-side-padding: plan room at `mobile_landscape` = the CSS content box.

## Item 5: inspo-brainstorm Industries pills

**Reproduced** (`inspo` file, Selected-work strip panel `tixrqb`): four Button pills in a wrapping row. At 600 and
480, three have 25 px sides and "Home Services" (`dtfdds`, narrow enough to fit) keeps 36: `sideAt` caps each pill by
its own planned width. "Construction & Real Estate" is 2 lines in a 219 px panel at 480 (no room: cta-label-wrap's
last resort). Nothing spills out of the page (no element past the screen unclipped at 600/480/390); the strip scrolls.
**Fix (F3 A):** in `shownSide`, alike siblings in one row (same kind, same drawn sides) share the smallest shown side
at each tier. The strip's phone layout goes to found-else as its own item.
**Test:** fixture: four alike pills of different word lengths in a wrapping row in a narrow column; all show one side
value at each tier.

## Item 6: divided items after their row breaks

**Root cause:** once a divided row breaks, `space.ts:75-76` evens each item's sides to the row's smallest and
`rows.ts:80` drops the outlines, but the plan's `sidesAt` (`layout.ts:133-134`) still counts the drawn padding and
outline. The plan gives the words a little less room than the paste (safe, small).
**Fix:** `shownSide` uses the divided rule too: `divided()` takes `{ items, styled }` instead of a whole
`RuleContext`, so the plan can call it; the row's shape is already decided before its items are visited.
**Test:** final-design-like fixture (stats split by their own outlines): plan room = CSS content box at every tier.

## Item 7 (B4's R5, plus A4/A5): outline counted twice

**Root cause:** `layout.ts:133-134`: when the style stage wrote no padding (Figma's padding no wider than the
outline), the plan takes Figma's padding and **no** outline (`line` needs `st.padding`). With Figma padding 0 and a
2 px outline the plan gives 4 px more room than the CSS content box (`equal-card-fixes-tools/room.ts`). On your
Services page at 768 this wraps a parts-table word that fits (record row `brxe-kyjtff` 111 px instead of 87).
**Fix:** in `shownSide`'s plan side: padding = what the style stage wrote (none = 0) when it wrote a style, else
Figma's; the outline always when written. Expected change (wanted, per B4 Q1 A): Services table cells 19 → 18 px
sides on tablets, that row 24 px shorter at 768.
**Tests:** padding 0/2/8 with a 2 px outline: plan room = CSS content box (kills A5); a written padding that isn't a
number (a `clamp`) counts its drawn value (kills A4). Re-run `equal-card-fixes-tools/mutate.py` A4/A5 against the copy.

## Tasks (test first; ledger `.superpowers/sdd/layout-floors/progress.md`)

0. Rebase check: main has cta-label-wrap and equal-card-fixes. Re-run every repro above on main (scratch tools);
   note what changed (item 1 especially). Save `npm run corpus` report + `corpus/out/v2/*/bricks.json`, and replays of
   Repairs (scratch copy), Services (git copy) and inspo. `npm run snap -- <Repairs copy> .superpowers/sdd/layout-floors/shots/before 991,768,600,480,390 --sides`, same for GRO and the item-2 fixture.
1. Fixtures + failing tests for items 1–7 (above). Prove each fails on main.
2. `adapt/sides.ts` (new, one purpose: the side a box shows at a tier): items 3, 4, 5, 6, 7. `space.ts` `sideAt` and the
   plan's `sidesAt` (wherever cta-label-wrap left it, `least.ts` per its plan) both call it. `divided.ts` signature.
3. `unpin.ts` heights (item 2).
4. `rows.ts` wrap floor (item 1).
5. Close: `npm run check`, `test:browser`, `corpus` (no file or width worse; lint, scores ±0.002, worse-than-v1 list);
   replay old vs new and diff by element id; measure every changed element at 1440/990/768/600/480/390; after shots.
6. Docs & records (below).

## Risks

- **Item 3 changes how big padded boxes look on upright phones** (20 → 32 on ~120 corpus boxes; few on your pages).
  F2 is the gate.
- **Item 2:** a fixed box whose words grew on tablets is unaffected (a min height lets it grow), but one whose drawn
  height was only desktop composition could now stay tall on tablets. Limited to boxes keeping their drawn width.
- **Item 1** depends on cta-label-wrap's `least`; if its grid check already stacks these cards, re-scope (task 0).
- **One shared side function** touches every rule that reads padding. The corpus diff by element id is the guard.
- `layout.ts`/`least.ts` near 300 lines: the new `sides.ts` keeps them under.

## Files and pipeline parts touched (adapt only)

- `src/core/adapt/sides.ts` (new), `src/core/adapt/rules/space.ts`, `src/core/adapt/layout.ts` and/or
  `src/core/adapt/least.ts` (sidesAt), `src/core/adapt/divided.ts`, `src/core/adapt/rules/unpin.ts`,
  `src/core/adapt/rules/rows.ts`.
- Tests: `test/fixtures/drawn-heights.ts`, `wrap-floors.ts`, `alike-pills.ts` (new); `test/unit/adapt-space.test.ts`,
  `adapt-layout.test.ts`, `adapt-unpin` (new or existing), `adapt-rows`; `test/browser/layout-floors.test.ts` (new);
  golden `test/golden/files/convert-sample.json` if it moves.

## Overlaps

- **cta-label-wrap (building):** shares `layout.ts`, `least.ts` (sidesAt moves there), `unpin.ts` (it changes the
  *width* floors at `unpin.ts:51-58`; item 2 changes the *height* part, lines 35-50). It may already fix or change
  item 1 (above). Its `least` uses `sidesAt`, so items 3–7 change its numbers a little: a row may stack a few px
  earlier or later. Build after it.
- **equal-card-fixes (B4):** edits `adapt/rules/rows.ts` (R2) and `style/bottoms.ts`; item 1 edits `rows.ts` too.
  Its R3 ruling relies on unpin dropping a hugging card's min height: item 2 leaves hugging cards alone. Build after it.
- **frame-text-links, fonts-cleanup, link-upload-fixes, text-breaks:** no shared file.
- **test-cleanup:** no shared source file; it may move `test/browser` helpers this plan's browser test uses.

## Docs & records (last task)

- Plan copied to `docs/plans/<date>-layout-floors.md`; ledger to `docs/plans/<date>-layout-floors-ledger.md`.
- `docs/HANDOFF.md`: section "Layout floors" (causes, fixes, rulings, corpus numbers, before/after measurements),
  paste check owed (next free number after 3ae): Repairs service cards at 768 and 480 (title on its own line, nothing
  spills), Services parts table at 768 (the row 24 px shorter).
- `BUILD` bumped at the merge.
- Main `CLAUDE.md` "Start here" / "Where things stand" by the finisher; new rules there: F1 A wording ("a box fixed both
  ways keeps its drawn height while it keeps its drawn width; a photo-filled box keeps its shape") and F2 A ("a box's
  sides at most 32 on upright phones, each side on its own"), plus "the plan and the paste read one side function".
  `references/rules-summary.md` updated by the finisher.
- `found-else.md` at the merge: each of the 6 items and R5 (A4/A5) as `~~item~~ ✅ fixed in build <BUILD> (layout-floors)`.

## Other things found (not folded in)

- **Low-medium:** the same 39/40 jump for top/bottom padding: a box with 39 keeps 39 on upright phones, 40 gets 24
  (`space.ts:47-54`, the `big` switch).
- **Low:** inspo-brainstorm's Selected-work sideways strip (`feuwkb`, an absolute 3147 px row): at 390 its container
  `gaikeu` measures at x −828 and the panel 390 wide with no gutter; needs its own look.
- **Low (likely cta-label-wrap's):** GRO "Let's talk →" is 163×76 at 768 (drawn 60 tall): a pill with an arrow wrapping.

## Addendum (main chat, 2026-10-21 ~07:45, from the equal-card-fixes review)
Two found items in the same code (adapt/rules/rows.ts), to include if small and general (Justin's standing ruling for review finds); otherwise list them as left:
- row.reflow's 'two per row' stage doesn't reset flex-grow on a fixed item that keeps its size, so a small fixed frame grows sideways (reviewer probe twoShare in ~/.hermes/cache/scratch/ecf-review/: 64px icon frame 272x63 at 600, 52x63 at 768; same on main).
- R2's reset reads only the desktop flex-grow; a divided row that row.reflow gave flexGrow 1 at its 'wrap' stage keeps it once stacked (code reading).

## Addendum 2 (main chat, 2026-10-21 ~08:20, Justin: "start agents for those 17 fixes")
More found items in this batch's code. Builder: write a short addendum (root cause + test) for each before building; fix those that are small and general, list the rest as left:
- The 39/40 jump also on top/bottom padding: 39 stays 39 on upright phones, 40 becomes 24 (space.ts:47-54). Fold into item 3's shared side function.
- A stacked row-card section is 59–185px off its Figma height at 990/768/600 with words-per-line lint at 768/600 (equal-card-fixes fixture rowCentred; same before and after build .7). Investigate.
- Split `src/core/adapt/layout.ts` (283 lines after cta-label-wrap) before adding to it, so it stays under ~300.
- inspo Selected-work sideways strip (absolute 3147px row feuwkb): at 390 its container gaikeu sits at x -828 and the panel has no gutter. Include only if small and general; otherwise list it.

## Justin's answers (2026-10-21, after review)
- **L1A:** on upright phones a side shrinks back toward 20 only where 2×side + the content's least width + a few px of slack would not fit the planned width, at every phone width (375/360/320 included). Otherwise 32.
- **L2A:** finisher on Opus 5.5 medium after the Claude reset (16:19).

- **Model (Justin, ~13:20):** finisher runs on Sol 6.1 xhigh now instead of waiting for Opus.
