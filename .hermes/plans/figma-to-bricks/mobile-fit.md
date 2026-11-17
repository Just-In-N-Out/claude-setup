# mobile-fit: pastes look right on tablet and phone in Bricks (both tools)

Planner: Fable 5.2 high, 2026-11-16. Base read: `main` = `2c570217` (Build 2026-11-16.8; the brief named 22d71de4,
internal-links merged since). Pipeline: Full. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/mobile-fit/planner/`
(called **E** below). Nothing was loaded from bdryswi.com, B-Dry staging or darksalmon; every drawing is offline, from
copies of Justin's scans (`~/.cache/mfp/scans/`) and the corpus' debug files (`~/.cache/mfp/figma/`).

## Playback

Justin (2026-11-16): "I want it so that when I paste them inside Bricks they look nice for mobile or tablet." Two
examples: "the FAQ on B-Dry mobile doesn't take up end to end in regards to width, and some texts in paragraphs fall
off." Both tools: B-Dry's scans pasted on staging (Bricks 2.4.2), Figma designs pasted on darksalmon (Bricks 2.3.9).

## Questions for Justin (⭐ = the planner's recommendation)

**Q1 is Justin's own to answer: it changes the standing "the importer stays one to one with the site" decision, so the
standing auto-go must not take its ⭐. Part A's fill tasks (A3–A5) wait for his word; everything else is ready.**

- **Q1. The FAQ is 349 px wide on bdryswi.com itself on phones.** The old site typed a fixed phone width on that
  widget in Elementor (349 px from 767 px down), so on bdryswi.com it also stops short of the column: 21 px short on a
  390 px phone, 109 px at 478, 398 px at 767. The paste copies that exactly. In Bricks' editor the Phone canvas is
  478 px and Phone-sideways 767 px wide, which is where the gap looks biggest. What should the paste do?
  - ⭐ **A. Fill the column.** Where the old site gives a box a fixed pixel width on phones or tablets that leaves it
    short of a column it fills on wider screens, the paste makes it fill the column there (Width 100% in that tab) and
    the notes name it. Everything else stays one to one. On B-Dry's five scans this changes only the home FAQ.
  - B. Keep it as the site has it (one to one). The notes only name the box, so he can clear its Width in Bricks'
    Phone-sideways tab himself (one field).
  - C. As A, and also widen boxes that never fill their column on the old site (Contact's form box, 355 px on phones
    and 419 px on tablets): not recommended, it redesigns the site.
- **Q2. Which paragraph "falls off", on which page and at which width?** Offline, no word of any importer paste leaves
  the screen or is cut: five scans × 17 widths (320–1024) × Bricks 2.4.2 and 2.3.9, today's conversion and his own
  saved home pastes (E `probe-*.log`). A Figma paste does show it (problem 3 below, fixed by Part B). If he saw it on a
  B-Dry paste, one screenshot with the page and the width (or the Bricks tab) is needed before anything is built for
  it: "prove it first".
  - ⭐ A. Build Part B (the Figma case) now; he sends a screenshot if a B-Dry paste still shows it after paste check 3fl.
  - B. Wait for his screenshot before building anything about text.
- **Q3. A faint giant word behind a section's words (the plugin, Part B).** Once the words flow, the faint word stays
  where it is drawn, behind them, cut by the section's edge as in Figma.
  - ⭐ A. Stays behind the words at every width (as drawn; it shrinks with the type scale).
  - B. Hidden on phones.

## What was found (root causes, with numbers)

### 1. Importer: the FAQ "doesn't span end to end": the old site's own typed width, copied one to one (not a paste bug)

- The scan (`~/.cache/mfp/scans/bdryswi-com-home/bdryswi-com-home.f2b-capture.json`): the widget
  `…/article:0/div:0/div:0/div:16/div:0/div:0/div:0/div:0` (marks `elementor-widget__width-initial …
  elementor-widget-elementskit-accordion`) carries `width: 102.985%; max-width: 100%` at 1367-up and
  **`width: 349px` at range 601-767**, carried down to every narrower range (E `faq-chain.cjs`).
- Its measured box on bdryswi.com: 837.5 px at 1440, 1004 at 1024, 971 at 991, 748 at 768 (its column: 748), then
  **349 px from 767 down to 361** (column 747 at 767, 458 at 478, 370 at 390), 340 at 360 and 300 at 320 (there
  `max-width: 100%` caps it, so it fills).
- The paste: Accordion `oxbcvk`, class `home__what-services__accordion-…`, `"_width": "102.985%", "_widthMax": "100%",
  "_width:mobile_landscape": "349px"`. Written by `src/core/site/controls.ts:60` (`width: simple("_width", …)`) at
  the tier `controlsFor` gives the block (`src/core/site/controls.ts:86-109`, `SUFFIX.get(b.max)`).
- Drawn (Bricks' printed CSS, 2.4.2 and 2.3.9 alike, today's conversion and his saved pastes): 349 of 370 at 390,
  349 of 458 at 478, 349 of 747 at 767, full from 768 up; `site:check --whole --elementor` page part worst 0.49 px at
  every read width (E `check-home-242/run.log`, `probe-home-2.4.2.log`, `probe-home-2.3.9.log`,
  `probe-saved-home-2.4.2.log`; picture `shots-saved-home/w478-04.png`).
- Editor: the canvas is the page in a frame exactly the breakpoint's width and draws as the front end (tier-spacing's
  planner measured it; its AC10 pins it), so Phone shows the 478 px case (109 px gap) and Phone-sideways the 767 px
  case (398 px gap). No editor-only difference.
- The same kind elsewhere on his scans (E `census-fixed-width.log`, `probe-*.log`): most typed pixel widths are cards
  in rows or boxes that are short of their column on wider screens too (Contact's form box 355/419 px, home's 716 px
  block on tablets, 300 px cards). Only the home FAQ fills its column on the wider range and then stops short.
- Only the home scan's page holds a FAQ that is short; the other four pages' Accordions (the menu's) are not.

### 2. Importer: "texts in paragraphs fall off": not reproduced

- 0 words off the window, 0 words cut by a clipping box (only the screen-reader "Facebook" label), the document never
  wider than the window, on all five scans at 320, 360, 375, 390, 414, 430, 478, 479, 540, 600, 767, 768, 820, 912,
  991, 992, 1024, both Bricks versions (E `probe-<page>-<version>.log`, `probe-all.status`).
- The old site itself: one footer text box reaches 9 px past the window at 922 px and below, its ink stays inside
  (E `site-overflow.cjs`).
- Recorded as suspicions, not planned: the site's own tight side room on phones (10–15 px; tier-spacing Q3 keeps it);
  a heading breaking inside a word where a device's fallback font is wider (bdryswi.com's own Roboto 600 and ADLaM
  Display files fail, so headings draw in each device's system font); something on staging the renderer doesn't model
  (a Theme Style). Q2 asks for his screenshot.

### 3. Plugin: words placed in a section drawn without auto layout run off the right (real, at every width under 1440)

- Proven on a real conversion: `npm run replay`/`snap` of the corpus file `figma-to-bricks-debug-design-inspo-brainstorm.json`
  (E `snap-brainstorm.log`, `probe-figma-words-brainstorm.log`, `probe-figma-brainstorm.log`).
- Section "05 · The alreadys" (1440×645, no auto layout, clips) holds two layers that overlap: a faint giant word
  (text "ALREADY", 400 px, 12% white, painted first) and the frame "Frame 33" (auto-layout row, x 96, 1248 wide)
  holding all the section's words. Section "12 · Ready to GRO?" is the same shape: a drawing (the saguaro) under the
  frame "Frame 6" (x 96, 1248 wide).
- Root cause: `src/core/normalise/infer.ts` `arrange` sends an overlapping set to `cut(…) ?? lift(…)`; `lift` returns
  `null` for fewer than three layers in a frame of the design (`infer.ts:127-128`: "a pair that overlaps stays as drawn"),
  so `inferLayout` returns at `if (!settled) return;` (`infer.ts:187`) and both layers stay placed. The words' frame is emitted
  `"_position": "absolute", "_left": "96", "_top": "96", "_width": "1248", "_height": "453"` (E
  `proto-brainstorm-changes.log`). Bricks' `max-width: 100%` cap narrows it to the screen, but its left offset stays,
  so it reaches 96 px past the screen: at 375 the box is x 96, 375 wide; the paragraph "The opportunity isn't always
  starting over…" is 85 px off the screen, the cards beside it 248–519 px off; at 768 and 991 every line of the right
  column is 96 px off. The section's `overflow: hidden` cuts them: 11–13 texts cut at 320–767, 10 at 768–991, against
  1 with the fix (the faint word, cut in Figma too). Its fixed height (453) also cuts the stacked column on phones.
- Figma: at the design width the words fit; Figma has no narrower width. A person building it in Bricks would let
  the words' frame flow in the section with the faint word behind it.
- The other four corpus files (hydraulics home, GRO home, Repairs, Services): no word off the screen at 320–991
  (E `probe-figma-words-<file>.log`); their lint findings are narrow columns, tap targets and words per line (known).
- Seen on brainstorm and **not planned** (the offline drawing lacks the file's font Aswatama, so widths of its
  headings are a fallback font's; suspicions until a paste with the font shows them): the footer's giant word
  "REady." (126 px type) makes the page 437 px wide on a 375 px screen (421 px word in a 343 px box; with Figma's
  own glyph width, 397 px at 260 px type, it would be 192 px and fit); a 52 px heading word and a no-wrap button in a
  143 px column of a row that stays a row on phones; a 50 px heading 13 px past a 375 px screen.

## Proposed rules (general; nothing keyed on B-Dry or a file)

- **R1 (importer, notes; ready).** A box the old site holds short of its column by a typed pixel width is named in
  that part's notes with the widths and how short ("as on the old site"). No paste byte changes.
- **R2 (importer, the fill; gated on Q1 A).** At a width range below the design range, a box is **held short** when:
  (1) the site's own rules give it a pixel `width` there that the design range doesn't have; (2) it is a box of block
  content (never a picture, icon, button, field or words' inline element) drawn at least 2 px wide and high there;
  (3) it is its parent's only flowing child across (the parent stacks its children, or holds only it); (4) at the
  nearest wider range its measured box fills its parent's content box at every read width (within 1 px); (5) at one
  read width or more of the range its measured width is the typed one (within 0.5 px) and it stands more than 8 px
  short of the room it filled. Then the paste writes `width: 100%` in place of the pixel width at that range (the
  same Bricks tab), keeps its `max-width` and `min-width`, and the notes name it. A scan that read no width in the
  range, or a box failing any clause, pastes as before. It reads the scan's measured boxes as
  `src/core/site/elementor-measured.ts` does, on every site and both routes (plain and `--elementor`).
- **R3 (plugin; ready).** In a frame drawn without auto layout, a pair of layers that overlap, one a frame with a
  layout of its own holding content (words or pictures), the other a decoration painted under it (a drawing, or a
  faint word: Q3), is laid out as that frame flowing in a column with Figma's spacing as padding, the decoration
  placed under it. Any other pair stays as drawn (two contents such as a photo and a card, a decoration painted over
  the words, a frame without a layout of its own, a part v2 cut). Decided in `normalise` (`infer.ts` `lift`), the
  stage that knows; no later stage edits it. The existing rules then adapt the flowing frame (size.unpin, the row's
  reflow, gutters), and compose/art rules the decoration.
- **How this meets the Bricks pro standard:** R3 turns a section's absolutely placed content into Section → Container
  → Blocks that a builder can edit (point 1) and whose tablet and phone tabs hold ordinary values; R2 writes a
  Bricks Width setting in the tab where the site typed it, never custom CSS (point 3); R1 and R2's notes say where
  "clean" differs from "exact" (point 6).

## Acceptance criteria (all **proposed**; "go" approves them)

- AC1 (proposed): Given the fit helper drawing a paste in Bricks' printed CSS, when a fixture box holds a no-wrap line wider than the window, a line cut by an `overflow: hidden` ancestor, and a box held short of its column, then it reports each one (and nothing for the same fixture without them), on Bricks 2.4.2 and 2.3.9. Test: `test/web/site-fit-helper.test.ts` "AC1 the fit helper names words off the window, cut words and boxes short of their column".
- AC2 (proposed): Given a fixture site whose box fills its column from 768 px up and is typed `width: 349px; max-width: 100%` from 767 px down, when it is converted (plain route and `--elementor`), then that part's notes hold one line naming the box, its typed width and how short it stands at the read widths, and the paste is byte for byte the paste of main. Test: `test/unit/site-fit-width.test.ts` "AC2 a box the site holds short of its column is named in the notes and the paste is unchanged".
- AC3 (proposed): Given the same fixture with the fill on (Q1 A), when it is converted, then the box's class writes Width 100% at the tier the site typed the pixel width (and no pixel width there), keeps its max-width and min-width, and drawn at 767, 600, 478, 390, 375, 360 and 320 on Bricks 2.4.2 and 2.3.9 the box spans its parent's content box within 0.5 px while at 768, 991, 1024 and the design width every element's box equals main's within 0.5 px. Test: `test/web/site-fit-width.test.ts` "AC3 a box held short of its column fills it at the widths the site typed a pixel width".
- AC4 (proposed): Given boxes that fail one clause of R2 each (short of its column on the wider range too; a card beside siblings in a row; a picture; a button; a 1 px hidden box; a pixel width also written at the design range; a range the scan read no width in), when converted with the fill on, then each paste is byte for byte the paste of main and its notes add no fill line. Test: `test/unit/site-fit-width.test.ts` "AC4 every refusal of the fill rule pastes byte for byte as before".
- AC5 (proposed): Given a paste the fill rule changed, when `npm run site:check` measures it against the scan, then the filled box and what it holds are listed as "wider than the site on purpose" at those widths with their sizes, are not counted as failures, and every other element is held to the 2 px tolerance as before; a paste the rule did not change prints and exits as before. Test: `test/web/site-check-fit.test.ts` "AC5 site:check names a filled box as wider on purpose and still fails any other difference".
- AC6 (proposed): Given the copies of Justin's five B-Dry scans (named-only, `F2B_SCANS=<folder>`), when converted with `--elementor` and their own media map, then no shown word leaves the window or is cut at 320, 360, 375, 390, 478, 600, 767, 768, 820 and 991 on Bricks 2.4.2 and 2.3.9; with the fill on the home FAQ spans its column within 0.5 px at 390, 478 and 767 and the four other pages' pastes are byte for byte main's; with the fill off all five are byte for byte main's. Test: `test/web/site-fit-scans.test.ts` "AC6 his scans: no word off the screen, the home FAQ spans its column, the other pages unchanged".
- AC7 (proposed): Given a generic Figma fixture page of three sections whose middle one is drawn without auto layout and holds an auto-layout frame of words (x 96, 1248 wide in 1440) over a decoration that overlaps it (once a drawing, once a faint giant word), when converted, then the words' frame is not placed absolutely, the decoration is placed under it, at the design width every element's box is within 0.5 px of main's, and at 1280, 1024, 991, 768, 767, 600, 478, 390, 375, 360 and 320 no word of the frame leaves the window or is cut by the section and the page is no wider than the window. Test: `test/browser/free-pair-flow.test.ts` "AC7 words over a decoration in a section drawn without auto layout flow and stay on the screen".
- AC8 (proposed): Given pairs R3 refuses (two contents: a photo and a card; a decoration painted over the words; a words' frame without a layout of its own; a part v2 cut; three or more layers), when normalised, then the scene equals main's (same placement, sizing and nudges). Test: `test/unit/infer-pair.test.ts` "AC8 any other overlapping pair stays as drawn".
- AC9 (proposed): Given the corpus' debug files, when replayed, then hydraulics home, GRO home, Repairs and Services give `bricks.json` byte for byte main's, and brainstorm differs only inside the sections "05 · The alreadys" and "12 · Ready to GRO?", where no word of their content frames leaves the window at 375, 768 and 991; every Figma fixture of the unit suite converts byte for byte as on main. Test: `test/unit/free-pair-pins.test.ts` "AC9 the corpus changes only where a words' frame lay over a decoration" (named-only, `F2B_STORY_PINS=1 F2B_PIN_BASE=<main tree>`).
- AC10 (proposed): Given `npm run check` and `npm run corpus` on the head, then both pass with no width worse than the builder's base run, and the plugin's conversion stays byte-identical to replay. Test: `test/unit/plugin-convert.test.ts` "the plugin's paste is exactly what a replay of the same snapshot gives" (the existing test; the two commands' tallies in the ledger).
- AC11 (proposed) (live): Paste check **3fl**, Justin's own: (1) in the importer app, pick the home scan → Make pastes again → paste on B-Dry staging; at Phone (478) and Phone-sideways (767) in Bricks and on a phone, the FAQ spans its column (Q1 A; with Q1 B: as on bdryswi.com, and the notes name it) and no paragraph runs off the side; (2) convert one Figma page whose section holds words over a drawing or faint word (the brainstorm page), paste on darksalmon: at tablet and phone width its words stay on the screen, at the design width it looks as before.

## Tasks

Ready now: Part B (B1–B4), A1–A2, C. Gated: A3–A5 on Q1 A; build them on the head tier-spacing merges
(`src/core/site/tiers.ts`, `class-source.ts` decide which tab a value goes in; this job only swaps the value).

**Part B, the plugin (ready; one commit a task, each green).**

1. B1, RED first. `test/browser/free-pair-flow.test.ts` with a generic fixture (`test/fixtures/free-pair.ts`: three
   sections; the middle a `none`-layout frame 1440×645 clipping, children in paint order: a decoration, then an
   auto-layout row 1248×453 at x 96, y 96 of two columns of texts; a sibling text above so labels survive; fonts the
   test machine has). Assert the criteria of the AC7 line. Expected RED on main: the row is `_position: absolute`,
   its box x 96 and as wide as the window, words off by up to 96 px (the probe on brainstorm shows exactly this).
2. B2, the rule. In `src/core/normalise/infer.ts` `lift`, before the "fewer than three" return: for a design frame
   (not `CUT`) of exactly two items, pick `[words, deco]` where `words` is a frame with a flow of its own
   (`flow.mode !== "none"`), children, and `content(words)`; `deco` is not `content` or is a faint text (a helper in
   `normalise/paint-order.ts` beside `content`: every run's colour under 50% alpha or the layer's opacity under 0.5;
   Q3); and `deco` is painted under `words`. Return `line([words], "y", f.box)` with `floating: [deco]`. The
   prototype diff is E `proto-pair-flow.diff` (drop its `process.env` switch: the sandbox test refuses it). Keep
   `infer.ts` under its size: move the pair pick into `normalise/infer-pair.ts` if it passes ~300 lines.
3. B3, refusals and pins: `test/unit/infer-pair.test.ts` (AC8) and `test/unit/free-pair-pins.test.ts` (AC9, named-only).
4. B4, gates: `npm run check`, `npm run corpus` (base run first, recorded in the ledger), `npm run snap` of brainstorm
   at 375, 768, 991 and the design width with shots for the evidence folder.

**Part A, the importer.**

5. A1 (ready), the fit helper: `test/web/lib/site-fit.ts` (from E `probe-paste.ts`: words off the window, words cut
   by a clipping ancestor, boxes short of their parent's content box, the document's width; a slider's other slides,
   a closed drawer and screen-reader text left out) and `test/web/site-fit-helper.test.ts` (AC1). Launch through
   `launchOffline`.
6. A2 (ready), the notes: new `src/core/site/fit-width.ts` (pure): `heldShort(code, ranges, boxes, path)` implementing
   R2's five clauses and returning `{ range, px, short: [width, px short][] }`; `convert.ts` adds one notes line per
   box per part. Test `test/unit/site-fit-width.test.ts` (AC2) on a generic fixture capture
   (`test/fixtures/site-fit-code.ts`).
7. A3 (gated, Q1 A), the fill: where `heldShort` names a box and the fill is on (`ConvertOptions.fit`, on by default
   for importer pastes once Justin says A; `fit: false` is the test and diagnosis switch), the class's width at that
   range is written `100%` before `controlsFor` splits controls from CSS. Tests AC3, AC4.
8. A4 (gated), `site:check`: `test/web/lib/site-check.ts` and `tools/site-check.ts` take the conversion's list of
   filled boxes and report them apart (AC5); `site:live` reads the same list.
9. A5 (gated), his scans' copies: `test/web/site-fit-scans.test.ts` (AC6), named-only.

**C. Docs and records (ready, at the close).**

10. Copy this plan to `docs/plans/2026-11-16-mobile-fit.md`, the ledger to `.superpowers/sdd/…/progress.md` then
    `docs/plans/2026-11-16-mobile-fit-ledger.md`; a HANDOFF section (rulings, the three questions and their answers,
    paste check 3fl in the end-of-run list, the unplanned suspicions of problem 2 and 3 as follow-ups); at the merge
    the finisher bumps `BUILD`, adds the Status line and, if Q1 A, one standing rule to CLAUDE.md ("a box the old site
    holds short of a column it fills on wider screens fills it; `src/core/site/fit-width.ts`") and amends the
    "Looks stay true" decision's wording with Justin's answer.

## Tests that pin today's behaviour (expect to keep passing, or to be remade on purpose)

- `test/unit/site-no-revert.test.ts` and `test/fixtures/site-no-revert-main.json`, `site-slider-unchanged`, the
  `F2B_STORY_PINS` story pins: unchanged by Part B; Part A's fill changes no existing fixture unless one holds the
  shape (the builder runs the whole unit suite and names any that does).
- Prototype run of R3 on the whole unit suite (a `git archive` copy of 2c570217 plus E `proto-pair-flow.diff`):
  4116 tests, 3975 pass, 134 skipped, 7 fail, none a behaviour pin: 1 is the prototype's own `process.env` switch
  (architecture test), 6 need a git repository the copy isn't (`git show 2199895:…`, `--compare`). Replay of the five
  corpus files: only brainstorm changes (E `proto-replay-compare.log`), 8 + 12 elements in the two sections
  (E `proto-brainstorm-changes.log`); lint at 375: hwgird 13 texts cut → 1 (E `proto-snap-brainstorm.log`).

## Risks and open points

- R3 at the design width: with the words flowing, a section whose words are taller than drawn (a missing font) grows
  instead of cutting them (brainstorm offline: +226 px at 1440 with the fallback font; main cut 5 texts there). With
  the file's fonts the height is Figma's (AC7 asserts it on a fixture whose fonts are present).
- R3 changes a deliberate line ("a pair that overlaps stays as drawn"): the pick is narrow (one side must hold a
  layout of its own and content, the other must be a decoration under it); AC8 holds the rest.
- R2 leans on the scan's measured boxes: a scan that read no width inside the range gives no fill (named in the notes).
- The fill makes `site:check` and `site:live` differ from the site on purpose; AC5 keeps every other element honest.
- Problem 2 stays unproven for the importer; nothing is built for it.

## Files shared with jobs in flight

- **tier-spacing** (being rebased): `src/core/site/controls.ts`, `classes.ts`, `convert.ts`, `blocks.ts`, new
  `tiers.ts`, `class-source.ts`; plugin `src/core/adapt/rules/space.ts`, `facts.ts`, `sides.ts`. Part A touches
  `convert.ts` (one call and the notes) and adds `fit-width.ts`; build A3 on its merged head. Part B shares nothing
  with it (`normalise/infer.ts` only).
- **internal-links**: merged (2c570217); `convert.ts`.
- **multi-page-scan, saved-password**: `tools/lib/site-upload/*`, `tools/lib/site-write.ts`, the importer app; this
  job writes its notes in core (`convert.ts`), so it touches none of them.
- **Paused:** clean-values (`controls.ts`, `convert.ts`, `tools/site-check.ts`), short-class-names
  (`tools/site-check.ts`, `test/web/lib/site-check.ts`, `src/core/normalise/normalise.ts`, `names.ts`),
  fewer-kept-boxes (`convert.ts`, `fold-boxes.ts`); link-keeps-name: no plan file found.

## Completion and reporting

Builder stops at `ready-for-review` with one test and one screenshot (or terminal capture) per AC in
`~/.hermes/plans/figma-to-bricks/evidence/mobile-fit/`, the ledger, both gates' tallies, every ruling in plain words,
and says plainly which of A3–A5 were left gated.
