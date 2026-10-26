# Button words wrapping in narrow cards (cta-label-wrap)

**Approved under Justin's away auto-go 2026-10-21** (⭐ answers W1A W2A W3A).
**W1A confirmed by Justin 2026-10-21.**

Planner: Hermes, 2026-10-21. Main at build `2026-10-20.15`. Plan only: no copy, code or commit made.
Waiting for Justin's go (he asked for the improvement loop before sleeping; this item has no words from him).

## Open questions (the plan is written as if each ⭐ was chosen)

**W1. Three cards side by side that are too narrow for their button: what should they do?**
This changes your rule of 2026-10-20 ("tablet: 3 alike cards stay one row; phone held sideways: all 3 in the
same row"). At 768 each Info card is 163 px inside and the yellow button needs 190 px. At 480 the card is 101 px inside,
and the words "CALL US NOW" alone are 118 px. So no button can fit on one line in a card that narrow.
- **A ⭐ They stack, one card per row, at that screen size. No card is ever left alone.** Info cards: one row from 992
  up, stacked on tablets (768–991) and phones. Four cards would still go two by two when two fit.
- B. Two per row, and the third card sits alone underneath at full width.
- C. The browser decides at the real width: three across while they fit (about 850 px and up), then two plus one alone,
  then one per row (under about 540).
- D. Keep three across, as today. The button's words wrap, and only buttons in rows that do have room get fixed.

**W2. Also fix buttons that wrap on laptop widths (992 px up to the design width)?**
The corpus "design" file's pill buttons wrap at 1200 ("Schedule Your Visit" sits on 2 lines inside its 232 px pill).
- **A ⭐ Yes, with the same rule.** A button holds its line wherever the narrowest laptop screen (992) has room for
  it. Anywhere else it behaves as today.
- B. Not now: tablets and phones only, and laptops become a separate item.

**W3. Plain links with an arrow (no fill, no outline, like "Learn more →")?**
- **A ⭐ Leave them as today.** On a narrow screen their words may wrap beside the arrow, like an FAQ question beside
  its plus.
- B. Treat them like buttons: their words never wrap while there's room.

## The request, played back

1. On the hydraulics homepage, the Info card "Call Us Now" has a yellow pill button reading CALL US NOW, with an arrow.
2. On tablets and phones held sideways (768 down to 480), its words break onto 2 or 3 lines. The pill grows to 81.6 px
   tall at 768 and 106 px at 480, against 57 px in Figma. This shows on the live page and in the renderer.
3. A button's words should stay on one line, as Figma draws them, and the pill should keep its shape.
4. The fix must work for any button in any narrow box, in any design. No keying on names, words or sizes.

## Root cause (proven)

**Reproduced:** `npm run snap -- corpus/files/hydraulics-home.json <out> 768,480`, then the pill and its label were
measured in Chrome (scratch scripts `~/.hermes/cache/scratch/cta-wrap/measure.ts` and `probe.ts`).

| width | card (inside) | pill, w×h | label, lines | the label's own words |
|---|---|---|---|---|
| 1440 | 425 (363) | 201×59 | 117.8 px, 1 line | 118 |
| 991 | 295 (237) | 189×57 | 117.8 px, 1 line | 118 |
| **768** | 221 (**163**) | 163×**81.6** | 91.6 px, **2 lines** | 118 |
| **480** | 137 (**101**) | 101×**106.4** | 38.1 px, **3 lines** | 118 |
| 390 | 358 (stacked) | 322×57 | 117.8 px, 1 line | 118 |

At its tablet padding (20 px a side, 1 px outline), the pill needs 118 + 10 gap + 20 arrow + 40 + 2 = **190 px** to
hold its words on one line. At 480 it needs **182 px**. The card gives it 163 and 101.

**Three steps in the code make it happen:**

1. **The layout plan keeps the cards in one row without checking what can't shrink** (`src/core/adapt/layout.ts`).
   - `decideRow` keeps a row on one line by its 200 px rule only when `firmWidth` fits: what each item can't shrink
     below, its labels and buttons (lines 167–169).
   - The alike-cards exception does no such check (lines 170–174, `ALONE_MIN` line 29). Three alike cards stay one
     row on a tablet while each gets 160 px, or 120 px on a phone held sideways.
   - The same gap exists in "two per row" (lines 175 and 178) and in grids (`fits` line 191, `keepsAlone` line 194).
   - Probe of the plan: the Info card row is `keep` at tablet and at phone landscape. The pill's planned room is
     162 px at tablet and 101 px at landscape; its label's room is 94 and 49.
2. **The button's floor is then let go.**
   - `size.unpin` (`adapt/rules/unpin.ts:55-57`) drops the pill's 200 px min-width at tablet, because its room is
     narrower.
   - `iconRow` (`layout.ts:57-70`) counts a *painted pill with an arrow* as "a question and its icon". So `row.icons`
     (`adapt/rules/icons.ts:16`) writes `_widthMin:tablet_portrait 0` and `_flexShrink:tablet_portrait 1` on the
     label, and the words wrap.
   - This contradicts two of the code's own promises:
     - `labelBox` (`normalise/label-box.ts:48-50`): "It never squeezes its words".
     - `decideRow`'s comment (`layout.ts:160-162`): "a button with its icon … its own minimum width keeps it whole".
   - Every painted pill with an arrow the probe found (hydraulics, design, page-1, the debug file) counts as
     `iconRow` today.
3. **`leastW` undercounts a button** (`layout.ts:105-114`): Figma's padding instead of the stepped one, Figma's gap,
   and no outline. Small, but it matters for a check that has to be exact to a few px.

**What I ruled out:**
- **The equal-card-heights stretch (build .15):** build .14 (`72fbf68`, scratch `git archive` copy) renders the same
  81.6 / 106.4 px pill.
- **The pill's own flex sizing:** it shrinks only because nothing inside it holds.
- **Only `min-width: 0` on the label:** with the label forced onto one line (`white-space: nowrap`) and the cards still
  three across, the words spill out of the label's box (118 px of words in a 91.6 / 38.1 px box), and at 480 out of the
  card (card scrollWidth 152 > 137). The card is the real limit.

**What fixes it (CSS probes in Chrome):**
- **Cards stacked:** the pill is 189×57 at 768 and 181×57 at 480, on one line.
- **Two per row:** fine at 768 (189×57). At 480 it still wraps (179 < 182), so phones held sideways need a stack.
- **The Gallery header's "View Our Gallery" (same bug, a kept row of words + pill):**
  - It wraps at 700, 600 and 480 (81.6 px tall).
  - With the label's floor put back alone, it still wraps at 700: its floor is 171 px, while the browser draws the
    words 171.1 px wide.
  - At 480 the pill spills out of its row.
  - So floors alone aren't enough. The plan has to give the button its room, the button must not shrink below its
    one-line width, and its words must be held on one line.

**The same bug elsewhere in the corpus** (`npm run wraps`):
- **hydraulics:** "call us now" @768/700/480, "view our gallery" @700/480.
- **design:** "implant restoration", "inlays and onlays", "porcelain restorations" @768; "suresmile aligner system",
  "teeth whitening", "dental hygiene exams", "oral cancer screening" @480; and @1200 (see W2).
- **The plan probe** also has page-1's "Download Full Inventory (PDF)" planned at 295 px on upright phones against
  324 needed (the last-resort case), and the debug file's "Emergency Call 24/7" at 200 px against 279 needed at phone
  landscape (a kept row).

## Approach

Three layers, all from structure.

1. **The box makes room (layout plan).** Every decision to keep items side by side checks each item's *one-line width
   at that tier*. That covers rows (the alike-cards exception, two per row, small items two per row) and grid columns
   (`fits`, `keepsAlone`):
   - **A button-like box:** its words + icons + gaps at the tier + its padding as `space.ramp` steps it + its outline.
   - **A Button:** its words + padding.
   - **A box:** its sides + its items.
   - Where cards fail that check only because of it, they stack, never leaving one alone (W1 A).
   - In a row that stays one line, an item that can't shrink gets at least its one-line width, and the rest share
     what's left. Today all items shrink together by the same share.
2. **The button holds its line (rules).**
   - **Button-like:** a label box (short one-line words and icons, as `labelBox`) that is painted or outlined, and
     every native Button.
   - **Not a question row:** a button-like box is never an `iconRow`, so `row.icons` leaves its words alone.
   - **Its floor:** `size.unpin` lets its floor go only down to its one-line width at that tier, never to 0 while
     that still fits.
   - **One line:** a new rule, `label.oneLine`, writes `white-space: nowrap` on the button's words at every tier where
     the plan gives the button its one-line width. A floor alone loses to the browser drawing words 0.1–1 px wider
     than Figma.
3. **Last resort, unchanged.** Where even a full-width row can't hold the words (a very long label on a small phone),
   that tier writes `white-space: normal` and the words wrap as today. Nothing ever spills out of its box. No font is
   shrunk, no icon hidden.

With W2 A, the plan also works out one more width, the narrowest laptop screen (992 px, Figma's shapes kept). Wherever
the button fits there, `label.oneLine` writes its `nowrap` for desktop too (the `fluid` tier). Elsewhere today's
from-the-design-width-up `nowrap` stays.

## Tasks

0. **Before any change** (the copy still equals main):
   - Run `npm run corpus`. Save the report and copies of `corpus/out/v2/*/bricks.json`.
   - Run `npm run wraps -- <file> 1200,992,768,700,480,390` on the 5 corpus files and a scratch copy of the debug
     file. Save the lists: they are the "button words on 2+ lines" baseline.
   - Run `npm run snap -- corpus/files/hydraulics-home.json .superpowers/sdd/cta-label-wrap/shots/before
     1440,991,768,700,480,390 --sides`.
1. **Fixture and failing tests first** (see Tests). Prove each one fails on main.
2. **`src/core/adapt/least.ts` (new, keeps `layout.ts` under 300 lines):** `leastAt(n, tier, …)`, the one-line width
   a layer needs at a tier:
   - a label box: words (+ trailing letter-spacing), icons, gaps at the tier (`gapAt`), and `sidesAt(n, tier,
     drawnWidth)` (stepped padding + outline, no narrow-box cap);
   - a Button: its words + padding;
   - a flow box: its sides plus the sum (row) or widest (column) of its items;
   - a one-line short text: its words;
   - anything that wraps or shrinks: 0.

   Replace `leastW` with it. Add `least(n, tier)` to `Layout`.
3. **`decideRow` / `gridColumns`:**
   - The alike-cards exception (line 174) needs `Σ least + gaps ≤ inner`.
   - "Two" (lines 175, 178) needs each half ≥ the widest item's least.
   - A grid's `fits` / `keepsAlone` need each cell ≥ its widest item's least.
   - Alike odd cards that fail on least alone go straight to `stack` (W1 A).
   - Rows of only labels keep `wrap`, as today.
4. **Kept rows' shares** (`give`, line 240): items whose least is above their share get their least; the others share
   the rest by their drawn widths. The total never passes `inner`, because keep already required `Σ least ≤ inner`.
5. **Buttons hold their line:**
   - `iconRow` returns false for a painted or outlined label box.
   - `unpin.ts`: a label box's floor goes to `layout.least` at the first tier where its room is below the floor but
     at least its least. It goes to 0 only where the room is below its least.
   - New `adapt/rules/label.ts` (`label.oneLine`, one rule, one `decision` line, registered in `rules/index.ts` after
     `row.icons`):
     - button words get `css: ["white-space: nowrap"]` at each tier where `layout.room(button) ≥ layout.least(button)`;
     - `white-space: normal` at the first tier where not;
     - flow buttons only (never placed or turned layers, never a drawn phone design's `fits` path unless it fits).
6. **(W2 A) Laptop widths:**
   - `planLayout` also visits the page at the narrowest laptop content (the tablet breakpoint + 1 less two desktop
     gutters, from `shared/breakpoints.ts`, never typed in), with Figma's shapes. That makes `room` / `least` exist for
     `"fluid"`.
   - `label.oneLine` writes `nowrap` at `"fluid"` where the button fits there.
   - No other rule reads `"fluid"` widths (checked: `space.ts:51` guards it; the rest loop over `TIERS`).
7. **Close:**
   - Run `npm run check`, `npm run test:browser`, `npm run corpus` (no file or width worse; compare lint, scores
     ±0.002, "worse than v1").
   - Re-run the wraps lists: no button's words on 2+ lines except named last-resort cases.
   - Replay main against the branch and diff `bricks.json` by element id.
   - Measure the changed elements in Chrome at every width, so no circle turns into a pill and no card spills.
   - Take the after shots (below).
8. **Docs & records** (see below).

## Tests (test first, generic fixture)

- **`test/fixtures/narrow-buttons.ts`** (new; generic words and sizes, no corpus values):
  - (a) Three alike cards (400 px, padding 30). Each holds a 56 px icon, a heading, a paragraph and a painted pill:
    radius 999, padding 15/26, gap 10, a 16 px uppercase label, a 20 px arrow vector.
  - (b) The same with four cards.
  - (c) The same with short pills that do fit a third of a tablet row. This guards the user's 2026-10-20 "three in a
    row" rule.
  - (d) A row with a words column (440 px) beside a pill, space-between, like a section header.
  - (e) A native Button (one label) in a narrow card.
  - (f) An FAQ question + plus row (must still wrap beside its icon).
  - (g) A plain link + arrow (W3 A: unchanged).
  - (h) A pill whose words are wider than an upright phone's row (last resort: may wrap, never spills).
- **`test/unit/adapt-least.test.ts`** (new):
  - `least` of the pill at each tier equals words + arrow + stepped gap + stepped padding + outline;
  - a column card equals its sides + its widest item.
- **`test/unit/adapt-layout.test.ts`:**
  - (a) is `stack` at tablet and landscape;
  - (b) goes two by two where each half holds the pill;
  - (c) stays `keep, keep, stack`, the existing test and the user's rule;
  - (d) the pill's planned width is ≥ its least at every tier;
  - grids: three cells too narrow for their buttons drop columns without leaving one alone.
- **`test/unit/adapt-label.test.ts`** (new), run on the converted fixture:
  - no `_widthMin:<tier>: 0` or `_flexShrink:<tier>` on a button's words where the plan gives room;
  - `white-space: nowrap` on them at those tiers, and `normal` only in (h);
  - `row.icons` still writes for (f) and not for (a), (d) or (e);
  - `unpin` writes the pill's floor as its least, not 0.
- **`test/browser/narrow-buttons.test.ts`** (new): render the fixture at 1100 (W2 A), 991, 768, 600, 480 and 390.
  - Every button's words are on one line (label height ≤ 1.2 × its line height).
  - Each button's height is within 2 px of its drawn height.
  - No card's or button's scrollWidth passes its clientWidth + 1.
  - (h) is exempt from the one-line check only.
- With each fix file put back to main in turn (`git checkout HEAD~1 -- <fix files>`), the matching tests fail.

## Before / after pictures (for the builder)

- File: `corpus/files/hydraulics-home.json`.
- Command: `npm run snap -- corpus/files/hydraulics-home.json .superpowers/sdd/cta-label-wrap/shots/<before|after>
  1440,991,768,700,480,390 --sides`.
- Crop the sections from each width's full-page shot. Copy them to `~/.hermes/plans/figma-to-bricks/shots/cta-label-wrap/`:
  - **"Info cards"** (under the logo marquee) at **768** and **480** (the bug), at **991** (W1 A stacks the whole
    tablet tier) and at **390** (must be unchanged): `before-info-cards-768.png`, `after-info-cards-768.png`, and so
    on.
  - **"Gallery"** section header ("View Our Gallery") at **700** and **480**: `before-gallery-480.png` and so on.
  - Corpus **"design"** file (`/Users/justin/Desktop/figmaplugin/figma-to-bricks-debug-design.json`), the services
    section with the "Secondary" pills, at **768** and **480**, plus **1200** with W2 A.

## Choices (my rulings, not yet confirmed)

- **"Button-like"** means a painted or outlined label box, plus every native Button. That's the same family
  equal-card-heights calls button-like, minus unpainted boxes (W3).
- **The one-line width comes from Figma's measured words** (+ their trailing letter-spacing). The `nowrap` covers the
  browser drawing them up to about 1 px wider. A ±1 px gap is invisible inside a pill's padding.
- **`least` counts padding as `space.ramp` steps it at the drawn width**, without the narrow-box side cap. That's a
  little cautious: a row may stack a few px earlier than strictly needed.
- **The last resort stays as today:** the words wrap and the pill grows taller. No smaller font, no hidden arrow.
- **Desktop at the design width doesn't change** (Figma-exact). Only tiers, and the `fluid` tier with W2 A, are
  written.

## Risks

- **It changes your 2026-10-20 three-in-a-row rule** for cards whose button doesn't fit (W1). The Info cards stop
  being three across on tablets and sideways phones. The "Decisions the user made" wording needs an update.
- **Pages get taller where cards stack** (Info cards at 768: about 300 px a card, stacked, against one 398 px row).
  The corpus section-height and structure numbers move. The lint should improve (words-per-line, narrow-column).
- **Wrong `nowrap`:** where the plan's room is wrong (unusual layouts), words would spill instead of wrap. Limited to
  flow buttons with planned rooms. The browser test and the wraps / scrollWidth checks at every width guard it.
- **The new laptop width (W2 A)** adds a plan pass. Rules that read widths only loop over `TIERS`, but a later rule
  reading `"fluid"` would now get real numbers instead of 0.
- **`layout.ts` is 268 lines.** The new `least.ts` keeps it under about 300.
- **Equal heights:** stacked cards no longer go through the stretch path, so check the Info cards' bottoms at 991 and
  768 after the change.

## Touches

- `src/core/adapt/layout.ts`: `decideRow`, `gridColumns`, kept-row shares, `iconRow`, `Layout.least`, the W2 pass.
- `src/core/adapt/least.ts` (new).
- `src/core/adapt/rules/unpin.ts`, `src/core/adapt/rules/label.ts` (new), `src/core/adapt/rules/index.ts`.
- Tests:
  - `test/fixtures/narrow-buttons.ts`, `test/unit/adapt-least.test.ts`, `test/unit/adapt-label.test.ts`,
    `test/browser/narrow-buttons.test.ts` (new);
  - `test/unit/adapt-layout.test.ts`;
  - `test/golden/files/convert-sample.json`, if its output moves.
- Pipeline part: **adapt** only (the layout plan and three rules). No extract, normalise, understand, style or emit
  change.

## Overlaps with work in flight

- **phone-side-padding** (`adapt/rules/space.ts`): no shared source file. Both edit `test/unit/adapt-layout.test.ts`
  and maybe the golden file. Also, `least` reads the padding `space.ramp` writes, and that feature changes the Info
  cards' upright-phone padding. **Build this after it merges** and re-take the corpus baseline then.
- **early-line-breaks** (`style/typography.ts`, `adapt/rules/breaks.ts`, `style/style.ts`, `style/rag.ts`): no clash.
  This plan doesn't touch `style/`.
- **emergency-cta-width** (`ui/site-fonts.ts`): no clash. It's about the same kind of pill, but its answer E3A ("buttons
  keep the width Figma draws") matches this plan: desktop widths don't change.
- **frame-text-links** (`normalise/text.ts`, `ui/site-*`): no clash.
- **test-cleanup** (splits `style/style.ts`, panel tests): no clash.
- `adapt/rules/index.ts` gets one line. No other open feature edits it.

## Docs & records (last task)

- Plan copied to `docs/plans/<date>-cta-label-wrap.md`.
- Ledger moved from `.superpowers/sdd/cta-label-wrap/progress.md` to `docs/plans/<date>-cta-label-wrap-ledger.md`.
- `docs/HANDOFF.md`: new section "Button words that wrapped in narrow cards", holding:
  - the cause, the fix, the rulings;
  - the corpus numbers;
  - the before / after wraps lists;
  - the paste check owed (next free number after 3ab): the Info cards at 768 and 480 with the pill on one line, the
    Gallery button at 480.
- `BUILD` bumped at the merge.
- Main `CLAUDE.md` "Start here" and "Where things stand" updated after the merge (the finisher).
- New `CLAUDE.md` rule, in "Decisions the user made": the W1 answer added to the three-in-a-row rule, e.g. "…while
  each card can hold its button on one line; otherwise they stack". Also a line under "Build general logic": a
  button-like box's words never shrink below one line while its box has room, and the layout plan counts its
  one-line width.
- `references/rules-summary.md` in the `figma-to-bricks` skill updated by the finisher (a rule changed).

## Found elsewhere (not folded in)

- **Medium:** Repairs page (the user's debug file) at 480. The 2-column service grid's card titles are squeezed to
  31 px: "Rods 1″–15″ & Rechroming Rods" on 6 lines (`#brxe-zqauio`), `#brxe-szfrvv` on 5, `#brxe-uhdrvx` on 3
  (`npm run wraps`). The title's floor lets go at phone landscape, while the other items in its row keep their width.
  Same family (the plan ignores what can't shrink), but these are headings.
- **Medium:** the corpus design file's pills wrap at laptop widths. @1200: "Schedule Your Visit" 119 px inside a 232 px
  pill, "Inlays and Onlays" on 3 lines. `style/style.ts:193-196` drops a held label's floor below the design width,
  and its `nowrap` only applies from the design width up. Covered here only if W2 = A.


## Justin confirmed (2026-10-21)

W1A confirmed by Justin himself: on tablets, cards too narrow for their button stack one per row, staying 3 across from 992px up. This knowingly updates his 2026-10-20 "keep 3 in a row" decision; the finisher updates that decision wording in CLAUDE.md (or its pending file).
