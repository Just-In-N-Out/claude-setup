# tier-spacing: Bricks' Tablet and Phone tabs hold the spacing the breakpoints draw, in both tools (plan, 2026-11-16)

Planner: Fable 5.2 high. Base: `main` `c7abf6d5` (Build 2026-11-16.3). Measured on `ebc7b1d9` (Build 2026-11-16.2);
none of the files this plan changes moved between the two but `src/core/site/convert.ts` and `parts.ts` (25 and 24
lines, site-sticky-cards), which this plan only adds one option and one notes line to. Plan only: nothing was changed
in the repo, nothing committed. Evidence, probes and the prototype: `<P>` =
`/home/justin/.hermes/plans/figma-to-bricks/evidence/tier-spacing/planner/`.

**Goal:** when a Bricks pro presses Tablet, Phone sideways or Phone in the editor, every paste of both tools looks as
it should and the Style tab shows the values that width draws, so they can be changed there.

## Playback

1. Niklas said the padding and spacing "for the tablet, mobile landscape, and mobile version" need work: in the Bricks
   editor, as the canvas gets narrower (the breakpoint buttons, or dragging its edge), a paste should look right and be
   easy to adjust.
2. Justin: look into how to improve this, Full pipeline, both tools, and "all of these need to be general changes".
3. What the measurements say (below): **the website importer draws the old site correctly at every width, but nothing
   can be adjusted**: on his three scans 0 of 71 Sections and 0 of 34 Containers show a value in Padding at any tab,
   and the Tablet and Phone tabs are empty for every element. **The Figma plugin already writes its spacing in the
   tabs** with the 64 / 36 / 16 gutters; what a Bricks pro meets there is odd numbers (98, 57, 50) and formulas.
4. Bricks' editor draws a paste exactly as the published page does at the same width (measured, both tools), so
   nothing has to change for the editor itself.

## Questions (⭐ = the answer taken under the standing auto-go; one word from Justin changes it)

- **Q1. What did Niklas look at?** Which tool and page, and one screenshot per width of a spot that looks wrong.
  A ⭐: build what the measurements show now; if his screenshots show something else it is its own job (CLAUDE.md
  "Prove it on the plugin first"). B: wait for them. *Neither answer blocks the importer half.*
- **Q2. Widths between Bricks' breakpoints (exact against clean).** The old site changes at its own widths (B-Dry:
  1024, 921 and 1366; Bricks: 991, 767, 478). The Tablet tab then holds what 991 draws, Phone sideways what 767 draws,
  Phone what 478 draws.
  A ⭐: the site's look stays everywhere: between the breakpoints (992–1024, 768–921, 1025–1366) one short Custom
  CSS line on the same class keeps the old value (home: 107 lines on 86 of its 451 classes, 57 of them a font
  size), named in the notes. Changing a tab's value changes what the breakpoint button shows; inside such a stretch the line holds
  until it is deleted. **B:** no such lines: the paste follows Bricks' three breakpoints only; an iPad held sideways
  (1024) shows the desktop look and an upright iPad (768–834) the look of 991, not the old site's. **C:** set the new
  site's Bricks breakpoints to the old site's (Bricks' custom breakpoints): a later job, it changes the whole site.
- **Q3. Side room on phones in an importer paste (exact against clean).** The old site keeps its own (home at 478:
  10, 11, 15, 20, 34 px; 3 sections under 12 px), not Bricks' 16. A ⭐: keep the site's, now shown in Padding where
  it can be changed. B: lift every section to at least 16 px on phones (content moves, no longer one to one).
- **Q4. Only spacing, or every setting?** The same rule moves font size (home 195 classes), width (42), display (36),
  line height (30), direction and alignment into the tabs. A ⭐: every setting Bricks has a tab for. B: padding,
  margin and gaps only.
- **Q5. The plugin's tablet spacing on a clean scale.** Tablet values are 70 % of the drawn one, rounded to a pixel
  (72 → 50, 81 → 57, 70 → 49); phones already use steps of 8. A ⭐: tablet steps in whole 4s (50 → 52, 57 → 56,
  49 → 48; at most 2 px, from 991 down and in the laptop slide; the design width stays exact). B: leave them.
- **Q6. Phone sideways in a plugin paste** takes the tablet's top and bottom spacing (a section 84 px where an upright
  phone gets 64). A ⭐: leave it (nothing measured looks wrong). B: a middle step for 479–767.
- **Q7. Formulas in the plugin's Desktop fields** (`clamp(84px, calc(35.48px + 4.891vw), 120px)`; 137–405 per page):
  they keep laptops fluid. A ⭐: keep them; the paused clean-values job tidies their text (its rule M). B: the drawn
  number in the field and the slide as a Custom CSS line (the field reads well, but a number typed there shows only
  at the design width until the line is deleted).
- **Q8. clean-values (paused)** planned the logical-sides rule (its T1, half of its AC4). A ⭐: this job builds it
  (same conditions); clean-values keeps the rest when it resumes and drops that half.

## Acceptance criteria (all **proposed**)

Importer:

- AC1 (proposed): Given an element whose lines run left to right and across (neither it nor a box above it in the paste declares `direction: rtl` or a `writing-mode` other than `horizontal-tb` at any width), a `padding-` or `margin-` `inline-start | inline-end | block-start | block-end` its class declares is the `left | right | top | bottom` side of the class's `_padding` or `_margin` setting; on a right-to-left or sideways element, in a class that holds the physical name of that side at some width, and for a side one of its states writes, the site's name stays where it is today. Test: `test/unit/site-tier-sides.test.ts` "a logical side is its physical setting on a left-to-right element and stays as written everywhere else".
- AC2 (proposed): Given a class whose margin side is `auto` at some width and plain at the others, that side is the `_margin` setting's `auto` there, and the test renderer prints `margin-<side>: auto` for it as Bricks' `assets.php` does. Test: `test/unit/site-tier-sides.test.ts` "a margin side of auto is the Margin setting's auto and prints as Bricks prints it".
- AC3 (proposed): Given a property's plain value at every kept range, its tier plan writes the design range's value as the Desktop setting and the values 991, 767 and 478 show as the Tablet, Phone sideways and Phone settings (each only where it differs from the wider one), and one band per stretch of widths whose site value differs from the setting in force there, bounded by its own widths, neighbours of one value joined; resolving settings and bands gives the site's value at every whole width from 300 to 2600, and no band holds 991, 767, 478 or a design-range width. Test: `test/unit/site-tier-plan.test.ts` "the settings and bands of a property give the site's value at every width and no band holds a breakpoint's own width".
- AC4 (proposed): Given a class whose padding, gap, font size or width changes at a width Bricks has no breakpoint for (1024, 921, 1366, one-pixel ranges), its paste holds the tier settings of AC3 with Bricks' keys, one rule per band `@media (min-width: Xpx) and (max-width: Ypx)` on the same class whose selector out-weighs the class's own settings, and no other line of its Custom CSS writes that property; a copy's own value does the same under its `#brxe-<id>`. Test: `test/unit/site-tier-paste.test.ts` "a value changing off Bricks' breakpoints is the tabs' settings and one bounded line above them".
- AC5 (proposed): Given a property with a value no setting takes at some range, one a range leaves out, one a state of the element changes, a class on the site's element inside a flat wrapper, an Icon's class and a Form's, the class is byte for byte the one the switch-off paste holds. Test: `test/unit/site-tier-paste.test.ts` "what a setting can't hold at every width stays as it is today".
- AC6 (proposed): Given every code fixture and this job's fixture site, both routes and both text modes: no property a class or an element holds as a setting is written by its own unbounded Custom CSS rule, and every band is bounded on both sides or lies wholly inside one tier. Test: `test/unit/site-tier-one-writer.test.ts` "a property in the tabs has no second unbounded writer and every band is bounded".
- AC7 (proposed): Given the fixture site `tier-spacing` (new: Elementor-style switches at 1024 and 767, a theme's at 921, a laptop one at 1366, logical sides, a centred box, a hovered padding, a right-to-left box, a copy keeping its own padding) captured from 127.0.0.1 and converted with the tier settings off and on, the on paste holds Tablet, Phone sideways and Phone settings the off one lacks, and every element's box, padding, margin, gaps, font size, display, direction and wrap are equal within 0.5 px at both edges of every range and at 1440, 991, 767, 478, 390 and 320, with the Elementor step and without it, on Bricks 2.4.2 and 2.3.9. Test: `test/web/site-tier-equal.test.ts` "the fixture site draws the same with the tier settings off and on at every range's edges".
- AC8 (proposed): Given the switch off (`ConvertOptions.tiers: false`, a test and diagnosis switch with no flag, as `photoBoxes`), every paste, notes text and `styles.txt` of every code fixture, both routes and both text modes, is byte for byte the base's. Test: `test/unit/site-tier-off.test.ts` "with the tier settings off every code fixture pastes byte for byte as on the base".
- AC9 (proposed): Given `npm run site`, each part's notes hold one `Breakpoints:` line saying how many values sit in the Tablet, Phone sideways and Phone settings, how many lines keep the site's look between Bricks' breakpoints and at which widths, and what to delete to follow the tabs alone; `styles.txt` lists each class's such lines; a part with none has no such line. Test: `test/unit/site-tier-notes.test.ts` "the notes count the tab values and the lines between Bricks' breakpoints".
- AC10 (proposed): Given an importer paste of the fixture site and a Figma paste of `landingPage`, drawn at 991, 767 and 478 with what Bricks' builder canvas adds to nestable elements (`brx-draggable` and its 90 px minimum for an empty one), no element's box differs from the front end's by more than 0.5 px; a pin: it passes on the base too, and fails for the importer paste when its reset class is left out. Test: `test/web/site-tier-editor.test.ts` "Bricks' editor canvas draws both tools' pastes as the front end does at each breakpoint".
- AC11 (proposed): Given copies of Justin's three scans named by `F2B_TIER_SCANS` (run only when named; the Elementor route, Bricks 2.4.2), every Section and Container whose padding is plain at every width shows it in its Padding setting, the Tablet and Phone sideways tabs hold values (the prototype's counts are in "What Justin will see"), the spacing left in Custom CSS is only what AC5 names plus the bands, and no element differs from the switch-off paste by more than 0.5 px at the 36 widths of `<P>/cmp-root-home.txt`. Test: `test/web/site-tier-scans.test.ts` "on the named scans the Padding boxes are filled, the tabs hold the breakpoints' values and nothing moves".

Plugin:

- AC12 (proposed): Given any drawn spacing at or above the size it steps from (40 for a section, 48 for a gap), its generated tablet step is a whole multiple of 4, at most its cap (96, 72), never above the drawn value and never below its phone step; a drawn value under that size passes through unchanged at both tiers. Test: `test/unit/facts-space-grid.test.ts` "a generated tablet step is a whole multiple of 4 between its phone step and the drawn value".
- AC13 (proposed): Given every zero-argument fixture and the real files the repo holds, converted on the base and on the head and read through `test/fixtures/drawn.ts`: every element's drawn settings at the design width and at the Phone tier are the base's (each changed formula gives the base's value at the design width), and at Tablet and Phone sideways each drawn padding, margin and gap is within 4 px of the base's. Test: `test/unit/plugin-tier-grid-pins.test.ts` "pastes draw as on the base at the design width and on phones, and within 4 px of it on tablets".

Live:

- AC14 (proposed) (live): Justin makes B-Dry's home pastes again (importer app: pick the home scan → Make pastes again, or `npm run site … --elementor`), pastes them on B-Dry staging, and converts one Figma page and pastes it on darksalmon; in the Bricks editor he presses Desktop → Tablet → Phone sideways → Phone: the spacing looks right at each, clicking a Section shows its Padding in Style → Layout at each tab, and a value typed there changes the canvas (paste check **3fh**).

Each unit test above is written first and fails on the base for its criterion's reason. Three are pins instead: the
editor one (the tenth) passes on the base by design, and the eighth and thirteenth are named-only story pins
(`F2B_STORY_PINS`), made by their generator on a `git archive` of the base. The planner wrote no test: what is proven
is the prototype (no element moves, the counts, the unit suite's pins); every RED is the builder's, recorded in the
ledger before its fix.

## What Justin will see (the planner's prototype, his three scans, Elementor route, Bricks 2.4.2)

| | Home | About Us | Basement Waterproofing |
|---|---|---|---|
| Sections / Containers with an empty Padding box, today | 34 of 34 / 19 of 19 | 16 of 16 / 8 of 8 | 21 of 21 / 7 of 7 |
| the same, prototype | 0 / 0 | 0 / 0 | 0 / 0 |
| spacing values in settings (Desktop; Tablet; Phone sideways), today | 807; 0; 88 | 375; 0; 13 | 543; 0; 11 |
| the same, prototype | 1406; 26; 121 | 631; 11; 19 | 980; 11; 31 |
| spacing lines left in Custom CSS, today → prototype | 696 → 47 | 285 → 18 | 470 → 8 |
| type sizes in settings (font size, line height, letter spacing; all tabs), today → prototype | 168 → 286 | 73 → 133 | 84 → 162 |
| lines between Bricks' breakpoints (Q2 A) | 107 rules, 130 values | 54, 65 | 74, 86 |
| elements that move, base against prototype | 0 of 623 at 36 widths | 0 of 229 at 22 | 0 of 290 at 22 |

The Phone tab stays empty on these three pages because B-Dry changes nothing at or under 478; a site that does fills
it (the tier plan's cases). Files: `<P>/census-base-*.txt` and `census-root-*.txt` (today and prototype),
`cmp-root-*.txt` (every element, base against prototype, per width), `bands-root.txt`, `shots/` (both tools at 991,
767 and 478), `proto/apply.cjs` and `proto/tiers.ts` (the code; the band selector was proven both as `html:root
.<class>`, the plan's, and as the class's name three times, `cmp-proto-*.txt`).

Plugin, four pages (hydraulics home, GRO home, repairs, services): spacing already sits in the tabs at every tier
(hydraulics: 442 Desktop, 40 Tablet, 23 Phone sideways, 93 Phone), every Section and Container has its Padding, the
side room measures 63–64 / 33–36 / 13–16 at ≥992 / 991–768 / ≤767. With Q5 A the generated tablet values land on
whole 4s; nothing else changes.

## What is true today (file:line, `main` c7abf6d5)

Importer:

1. **Bricks' Padding and Margin boxes are fed only by the physical names.** `src/core/site/controls.ts:66` lists
   `padding-top…left` and `margin-top…left`; a capture since footer-icon-list keeps each side by the one name the
   site's cascade used (`src/web/code.ts:92` `oneName`), and Elementor writes the logical ones (`padding-block-start`,
   `margin-inline-end`). So 562 of the 722 spacing lines in the Custom CSS of home's three pastes are there only for their name
   (`<P>/census-importer-home.txt`).
2. **A property is a setting only when every change falls on Bricks' own breakpoints.** `controls.ts:93-99`
   `isControl`: every block unbounded below and `SUFFIX.has(b.max)` (991, 767, 478). B-Dry's Elementor changes at
   1024 and 767, its theme at 921, its laptop rules at 1366: one value at 1024 keeps the whole property, every width's,
   in Custom CSS (home: 111 declarations at 1024, 43 at 921, 31 at 1366). Only 767 lines up, so only Phone sideways
   ever gets a value.
3. **A margin of `auto` fits no setting** (`control-values.ts` `plain`; 96 of home's lines), though Bricks prints a
   spacing side as given (`<P>`'s Bricks 2.2 `assets.php:2350-2385`).
4. **Where states become a class:** `src/core/site/class-source.ts:35-42` `fromStates` (ranges' declarations →
   `blocksOfStates` → `controlsFor`), used for an element's own class, a shared look and a copy's own values
   (`copies.ts:112`). Bricks prints a class's settings as `.cls.brxe-<el>` after the class's Custom CSS, an element's
   as `#brxe-<id>` (staging-fit-renderer), so a Custom CSS line that must win over a tab's setting has to out-weigh it.
5. **The editor adds nothing that moves a paste.** Bricks' canvas is the page in a frame as wide as the breakpoint
   (991 / 767 / 478 for the buttons; any width when dragged), so `@media` lines and tab settings both follow it
   (`builder-main-2.4.2.min.js`); its one extra rule, `:where(.brx-draggable:empty){min-height:90px;min-width:90px}`
   (Bricks 2.2 `builder.min.css`), has no weight and the reset class's `all: revert` (`classes.ts:28`) wins: 26 empty
   boxes on home, none grows (`<P>/draw-importer-home.txt`).

Plugin:

6. **Spacing is written per tier by one rule,** `src/core/adapt/rules/space.ts` (`space.ramp`), from the page scale
   `src/core/adapt/facts.ts:26-32` `spaceStep`: phones in steps of 8, tablets `Math.round(v * 0.7)` (line 31), so
   tablet values are any whole number. Tablet and phone sideways share one value (`facts.ts:23`, `atTier` 199).
7. **Formulas in the Desktop field** come from the fluid slide (`facts.ts:220-228` `fluid`, written by `space.ts:89`
   and `type.ts:23`, folded into the desktop value by `src/core/emit/settings.ts:197-199`); a phone's side padding
   formula from `src/core/adapt/sides.ts:73` and `:167` (phone-side-padding, Justin's L1A).
8. **Gutters** are `src/shared/breakpoints.ts:17-20` (64 / 36 / 16) and measure so.

## The rules (general: every scanned site, every Figma design)

### R1. A logical side is its physical setting (importer; clean-values' T1, built here)

In `fromStates`, before the blocks are made: `padding-` and `margin-inline-start | inline-end | block-start |
block-end` are renamed `-left | -right | -top | -bottom` when the element's lines run left to right and across: the
scan's context is `ltr`, and neither the element nor any box above it in the paste declares another `direction` or a
`writing-mode` other than `horizontal-tb` at any width. Never when the class holds the physical name of that side at
some width (an older capture, `sides.ts` `olderPairs`), when a state or its own hover writes either name, for a class
on the site's element inside a flat wrapper, or an Icon's. Shared looks are still decided on the site's names (the
rename is after `looks.ts`), so no class is shared or split differently.

### R2. A margin side may be `auto` (importer)

`_margin`'s side takes `auto` beside a plain value.

### R3. Each tab holds what its breakpoint draws; the widths between keep the site's value (importer)

For a property with a setting (`RULES`, `MORE_RULES`) that every kept range declares with a value the setting takes,
and that today stays Custom CSS because a change falls off Bricks' breakpoints:
- **Desktop** = the design range's value; **Tablet** = the value at 991; **Phone sideways** = at 767; **Phone** = at
  478; each written only where it differs from the wider tab's (Bricks cascades downwards).
- **A band** for every stretch of widths where the site's value differs from the setting in force: `@media
  (min-width: Xpx) and (max-width: Ypx)` on the same class, after its other rules, its selector `html:root .<class>`
  (an element's own: `html:root #brxe-<id>`), which out-weighs the class's settings. Neighbouring ranges of one value
  are one band. By construction no band holds 991, 767, 478 or the design width: **what a breakpoint button draws is
  always what its tab says.**
- Why the widest width of a tier and not the value most of the tier shows: the editor's buttons set the canvas to
  exactly 991, 767 and 478; a tab whose value a band hides at that width would change nothing when edited.
- Everything `controlsFor` keeps today for another reason stays kept (`keep`, a state's property, `onlyHover`,
  all-or-nothing groups, an element type without the setting). A property with a non-plain value at any range, or one
  a range leaves out, is untouched (clean-values' formulas rule may free more later).

### R4. The notes and `styles.txt` (importer)

One line per part: `Breakpoints: N values sit in Bricks' Tablet, Phone sideways and Phone settings (a, b, c); M short
lines keep the old site's look between Bricks' breakpoints (992–1024: x, 768–921: y, …): delete a class's line to
follow its tabs there.` `styles.txt` lists the lines under each class.

### R5. The plugin's generated tablet spacing is on whole 4s (Q5 A)

`spaceStep`'s tablet value: `4 * Math.round(v * 0.7 / 4)` inside the same floor and cap (40 / 48 and 96 / 72 are
whole 4s already). Only values the plugin generates change; a drawn value passed through (under 40 / 48) and every
value at the design width stay. The layout plan reads the same scale, so its widths follow.

### What does not change

Importer side room (Q3 A), the plugin's phone sideways step (Q6 A) and formulas (Q7 A), the capture, the Figma
panel's website route (it has no tier step: `ConvertOptions.tiers` is the code route's), and Figma pastes but R5.

## The standard, point by point (CLAUDE.md "THE STANDARD FOR EVERY PASTE")

1. Structure: untouched. 2. Classes: the tab values and the bands sit on the class that owned the declaration; a
copy's own stay on the element; no second class writes a property (AC6). 3. **Settings before custom CSS:** this job's
point: padding, margin, gaps, sizes and type sit in Bricks' controls at every tab; Custom CSS keeps only what Bricks
has no tab for, one short bounded line. 4. and 5.: untouched. 6. **Looks stay true:** the importer stays one to one at
every width (AC7, AC11); where "clean" and "exact" meet (Q2, Q3) exact wins and the notes say so; the plugin stays
exact at the design width (AC13).

## Architecture

- `src/core/site/tiers.ts` (new, pure, about 80 lines): `physicalSides(states, across, held)` and `tierPlan(values,
  ranges, design)`. The prototype's file is `<P>/proto/tiers.ts`; the real one takes its switch from options, not a
  global, and its `across` from the caller.
- `src/core/site/controls.ts`: `ControlOptions.tiers?: { states, ranges, design }`; after `controls` is decided, the
  properties R3 names get their plan; their settings are written with the same `place()` code as today's; their
  declarations leave the custom blocks; the bands are appended as blocks marked `band`. `_margin`'s `ok` takes `auto`.
- `src/core/site/blocks.ts`: `Block.band?: true`. `src/core/site/classes.ts` `rules`: a band's selector gets
  `html:root ` in front. Nothing else reads the mark.
- `src/core/site/class-source.ts` `fromStates`: R1, then passes the states and ranges on. `convert.ts`: the `tiers`
  option, `across` per element (the direction read as `elementor-fold.ts:232` and `photo-box.ts:180` do), the design
  range (`ranges.ts` `designRange`). `parts.ts`: R4's line. `tools/lib/styles-text.ts`: the lines per class.
- No stage edits an earlier one's output; CSS stays typed until `rules` prints it (the band is a typed block).
- Plugin: `src/core/adapt/facts.ts:31` only.

The prototype (`<P>/proto/apply.cjs` applies it to a `git archive` tree, each edit at an anchor found exactly once)
is the starting code: 5 edits and one new file. It differs from the plan in four named ways the builder closes: the
global switch, `across` read from the element's own declarations only, no notes, no `ConvertOptions` switch.

## Touched files

`src/core/site/tiers.ts` (new), `controls.ts`, `blocks.ts`, `classes.ts`, `class-source.ts`, `convert.ts`,
`parts.ts`, `tools/lib/styles-text.ts`, `test/browser/render.ts` (only if `_margin: auto`
prints wrong), `src/core/adapt/facts.ts`; the tests of the ACs, `test/fixtures/sites/tier-spacing/` (or the code
fixtures' own shape, `test/fixtures/site-code.ts`), `test/unit/lib/site-tier-pins.ts` and its pins file,
`test/fixtures/site-no-revert-main.json` (made again, CLAUDE.md), `docs/HANDOFF.md`, the ledger.

## Tests that pin today's output

The whole unit suite on the prototype tree (`<P>/unit-proto.tap`: 4065 tests, 3920 pass, 123 skipped, 22 fail in 20
top-level tests) against the same files on the base's bare `git archive` tree. Six of the 20 fail on the base tree
too (they need what an archive doesn't hold; not this job's): `emit-class-paste`, `emit-code-inventory`,
`offline-tally-compare` (3), `plugin-looks-resolve`. The other 14, in 9 files, pin where a declaration sits today; the
builder changes each only as said, and names it in the ledger:

| File (`test/unit/`) | Test | What changes |
|---|---|---|
| `site-code-ranges.test.ts` | "through the converter: the narrower range's changes go out at the merged range's upper end, one block" | the padding is the tab settings plus one band; the test's point (one block per merged range) is kept for a property R3 leaves (a non-plain value) |
| `site-css.test.ts` | "controls, custom CSS, media blocks, pseudo and inline rules; rem in px; a background picture inside the paste" | the expected settings and blocks of its fixture, by R1 and R3 |
| `site-inline-own.test.ts` | both tests ("…carries those widths in its own class…", "…at every depth") | the widths stay in the element's own class, now as its settings and bands; the parent's rule is untouched (the assertion that matters) |
| `site-motion.test.ts` | "F1 an element that plays an entrance keeps a box of its own; one that plays none stays as before" | the lead's margins move to settings; the entrance's own rule stays |
| `site-motion-old.test.ts` | "AC9 a capture made before this build pastes as before, with one note" | converts with `tiers: false` (the pin is about motion) |
| `site-slider-unchanged.test.ts` | "pastes without an Elementor slider are byte-identical" | converts with `tiers: false` |
| `site-p-box.test.ts` | the four "a site p that is a box…" and "a p box's own margin wins…" tests, both text modes | the p's spacing is read from the Margin setting where it now sits |
| `site-text-looks.test.ts` | "a size that changes at a width that isn't Bricks' is in the text class's CSS" | this is the rule R3 replaces: the size is the text class's tab settings and one band; rename the test to say so |
| `site-no-revert.test.ts` | both tests | `test/fixtures/site-no-revert-main.json` made again on the job's tree (CLAUDE.md); no `revert` is added (the hash differs because the blocks do) |

**The plugin's grid (R5)**, prototyped alone as the one-line change of `facts.ts:31` (`<P>/unit-grid.tap`: the same
six base-tree failures plus 13 tests in 6 files): `adapt-facts.test.ts` "spacing steps down to whole pixels, capped
at 64 for sections and 48 for gaps on phones"; `adapt-rows.test.ts` "a line made across a stacked divided row sits
midway between two items' words, never under 16px"; `adapt-section-top.test.ts` (4: "a bottom-pinned free section
keeps its top space as stepped padding", "hills or a wave across the bottom edge stay art.edge's and hold no
height", "with the site's header and footer ticked, a frozen section still keeps its top space and the hero its own",
"the space kept beside a left-out site header stays above the words"); `convert.test.ts` "the landing page matches
its golden file"; `understand-rhythm.test.ts` (its criteria 4, 5, 7 and 8); `understand-site-gaps.test.ts` (its
criteria 1 and 2). Where such a test pins a tablet number, the number changes to the grid's; where it asserts a
relation (a line midway, the page's section space under buttons, a kept space), the relation must hold on the new
numbers: if it doesn't, Milestone 3 stops and the grid is reported as not safe, never forced.

Named-only story pins of merged jobs (`F2B_STORY_PINS`, 123 skipped) hash whole pastes and are stale after any job
that changes a paste on purpose; they are not run by `npm run check` and are not edited. The browser and web suites
were not run on the prototype (machine load); the builder runs them file by file and treats a failure there the same
way: a pin of where a value sits is updated and named, anything that moves on screen stops the task.

## Tasks (test-first; one commit per passing task, files by name; never commit CLAUDE.md; no `BUILD` bump)

### Milestone 0: the base's facts
1. `npm run check` and `npm run corpus` on the copy's base; record both tallies in the ledger. Make the pins of the
   eighth and thirteenth criteria on a `git archive` of the base with their generators (the pattern of
   `test/unit/lib/site-sticky-pins.ts`); both tests green on the base.
2. Copy Justin's three scans (`~/Downloads/bdryswi-com-home/`, `-about-us/`, `-basement-waterproofing/`, read-only)
   under the job's own `~/.cache/`; run `<P>/census.cjs` on the base's pastes and check the "today" numbers above.
   **Stop** if they differ: the base moved; write the difference in the ledger and ask.

### Milestone 1: the plan of one property (pure)
3. `test/unit/site-tier-plan.test.ts` red (no `tiers.ts`), then `tierPlan` from `<P>/proto/tiers.ts`; green.
4. `test/unit/site-tier-sides.test.ts` first test red, then `physicalSides` with `across` and `held` as arguments.

### Milestone 2: the paste
5. `site-tier-paste.test.ts` (both tests) red; `Block.band`, `controls.ts`, `classes.ts`, `class-source.ts` as the
   prototype's edits; the `tiers` option through `convert.ts` (default on for every code-route paste; `false` is a
   test and diagnosis switch, no flag). Green; `site-tier-off.test.ts` still green.
6. The margin `auto` test red, then R2; check `test/browser/render.ts` prints it as `assets.php` does.
7. `across`: an element under a right-to-left or sideways box keeps its names (AC1's refusals) from `convert.ts`.
8. `site-tier-one-writer.test.ts` over every code fixture; fix what it finds at its cause, never by an exception.
9. The fixture site and `test/web/site-tier-equal.test.ts` (offline Chrome through `launchOffline`, under the memory
   cap); then `site-tier-editor.test.ts`.
10. Notes and `styles.txt` (R4), test first.
11. Every test the section above lists as pinning today's output: change only what it says, each named in the ledger
    with its reason; make `site-no-revert-main.json` again (`node tools/site-no-revert-golden.ts .`).
12. `site-tier-scans.test.ts` on the three copies (named-only); record the counts beside the prototype's; a count
    that differs is explained in the ledger, not tuned.

### Milestone 3: the plugin's scale (Q5 A; drop the milestone if Justin answers B)
13. `facts-space-grid.test.ts` red, then `facts.ts:31`; `plugin-tier-grid-pins.test.ts`; rule tests that pin an
    off-grid tablet number change to the new one, each named in the ledger. `npm run corpus`: no width worse than the
    base's; a worse one stops the task.

### Close
14. `npm run check`, `npm run corpus`, the browser and web suites file by file under the cap; one screenshot per
    criterion (a terminal capture where nothing is visual; for the seventh and eleventh the fixture and his home at
    991, 767 and 478 beside the base's).
15. Stop at `ready-for-review` with the ledger.

## Docs & records

- `docs/HANDOFF.md`: a "tier-spacing" section (rules R1–R5, the rulings Q1–Q8 as taken, the counts, paste check
  **3fh**, deferred: phone side room, the plugin's phone sideways step, formulas, the panel's website route).
- The ledger `docs/plans/<date>-tier-spacing-ledger.md`; this plan copied to `docs/plans/<date>-tier-spacing.md`.
- CLAUDE.md (the finisher, main folder): the build line; one Status line; under "Working in this repo": "An importer
  tab's setting is what its breakpoint draws (991, 767, 478); a width between keeps the site's value in one bounded
  line `html:root .<class>` (`src/core/site/tiers.ts`); a band never holds a breakpoint's own width"; under Decisions:
  Q2 A, Q3 A and Q5 A as not yet confirmed.
- `~/.hermes/plans/figma-to-bricks/clean-values.md`: a note at its top that T1 and the off-breakpoint part of S were
  built by tier-spacing (the main session or its planner writes it; no agent of this job edits that plan).
- `follow-ups.md` in the evidence folder for what a review defers.

## Overlaps and order

| Job | State | Shared files | How they fit |
|---|---|---|---|
| clean-values | paused | `controls.ts`, `class-source.ts`, `classes.ts`, `control-values.ts`, `parts.ts`, `styles-text.ts`, `emit/settings.ts`, `site-no-revert-main.json` | This job builds its T1 (same conditions) and the off-breakpoint case its rule S left as Custom CSS ("at widths Bricks has no breakpoint for"). It keeps formulas (M), the keyword tidy (T2, T3), rounding (V), states (H), gradients and the plugin's typed fields. On resume it rebases over this job, drops T1 from its AC4, and its `cleanLen` then frees more properties for R3 (a formula that becomes plain). |
| site-sticky-cards | merged (c7abf6d5) | `convert.ts`, `parts.ts` | already on the base |
| site-fonts-import | in review | `convert.ts`, `parts.ts`, `tools/lib/site-write.ts` | different lines (fonts class, notes); whoever merges second rebases the notes order |
| logo-media | finishing | `convert.ts`, `parts.ts` | different lines |
| photo-image-all | building | `convert.ts`, `parts.ts`, `test/browser/render.ts` | different lines |
| bw-colours | building | `convert.ts`, `parts.ts` | different lines (`inked`); the bands print through the same `rule(…, ink)` |
| internal-links | planning | not known yet (no plan) | links only; expected `convert.ts` |
| short-class-names | paused | `classes.ts`, `class-source.ts`, `looks.ts`, `share.ts`, `parts.ts`, `styles-text.ts`, `site-no-revert-main.json` | it renames classes; this job changes what a class holds, so `classKey`'s fingerprint changes and classes arrive under new names on a re-paste either way. Second to merge makes the golden again. |
| fewer-kept-boxes | paused | `convert.ts`, `parts.ts`, `looks.ts` | no shared lines |
| link-keeps-name | planning | not known yet (no plan) | names only |

Every job's AC pins that hash whole pastes are made again by the job that merges second (memory: notes-only rebase
rule covers the test-only case).

## Risks and open points

- **Class names change on a re-paste.** A class is named from its settings and rules, so nearly every class holding a
  padding arrives as a new class; an older paste's classes stay beside them until deleted. HANDOFF says so.
- **A rule of the paste that sat between the class's Custom CSS and its settings in weight** (heavier than `.cls`,
  lighter than `.cls.brxe-<el>`) would now lose to a tab's setting where it used to win. None on the three scans (0
  elements move); AC6 and AC7 guard it; a case found stays Custom CSS by `keep`, never by a heavier selector.
- **A paragraph that is a box** (`site-p-box`: "a p box's own margin wins over the p's spacing"): its margins move
  from the class's rule to the Margin setting, which Bricks prints later and heavier. The unit tests there only pin
  where the margin sits; the builder runs that fixture's drawing test before changing them, and a margin that draws
  differently stays Custom CSS through `keep`.
- **`html:root` and Bricks' own Theme Style rules:** a band out-weighs them too, as the old Custom CSS line did
  through the class's settings. Unverified live: part of 3fh.
- **`_margin: auto` in Bricks' builder field** is read from Bricks 2.2's PHP, not from a copy out of Justin's Bricks
  (`reference/bricks/` holds none): the live check covers it; if the field refuses it, R2 is dropped (its own commit).
- **The plugin's grid moves a layout decision** (a row that fitted by 1 px): the corpus gate decides; a worse width
  stops Milestone 3, which is separable.
- **Machine load:** drawings run one at a time under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`;
  Chrome failed to start within 20 s once at load 95 (not a result; run again).

## Completion and reporting

The builder stops at `ready-for-review` and reports: the head, the gates' tallies, each criterion's test and
screenshot, the counts on the three scans beside the prototype's, every pin it changed and why, every stop it hit,
`skill_lessons[{skill, lesson, evidence, enforce}]`. Reviewers, the verifier and the auditor return `verdict` and
`ac_status`. Nothing is pushed; no live site is loaded; only Justin runs 3fh.
