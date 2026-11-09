# elementor-footer-fit (website importer, Mini): a widget its row stretches keeps its elements, so B-Dry's footer is 1:1 at 1025

Planner, 2026-11-08. **Base: `elementor-phone-fit-build` head `7b7d345fb0914b97371323294462c0e844a0c928`** (its base
`7ff9ba4a`; plan `docs/plans/2026-11-08-elementor-phone-fit.md` there, fold rule 8). Build on local `main` once
elementor-phone-fit is merged into it (site-motion merges before both; see "Overlaps"); until then branch from
`elementor-phone-fit-build`. Mini pipeline. Builder: copy this file to `docs/plans/2026-11-08-elementor-footer-fit.md`
(in git) as Task 0; ledger in `.superpowers/sdd/2026-11-08-elementor-footer-fit/progress.md`. Evidence:
`~/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/` (the planner's receipts in `planner/`).

## Questions (⭐ = taken under the standing auto-go)

- **Q1. An Elementor widget sits in a row container that stretches its widget box to the row's tallest item, while
  the widget's paragraph or picture keeps its own height inside it. What does the `--elementor` paste do?**
  - **⭐ A. That widget keeps its own elements (widget box, its container, its paragraph or picture, exactly as the plain
    code route pastes it), named in the notes; only where the capture measured the widget's box taller than its body
    (plus the margins between them) at some width.** Exact at every width. On B-Dry's home 1 of the footer's 38 folded
    Elementor elements stays as three elements (the second "Areas We Serve" town list, `f2bd68b`); the header, the page
    and every other fold are byte-identical to today.
  - B. Keep folding and write `align-self: flex-start` on the folded element in the ranges where its row stretches it.
    One element instead of three, but it adds a declaration the site never had and must read each range's row
    direction and alignment (B-Dry's three-photo band sits in stretching rows too and must stay as it is); not
    Mini-sized and riskier.
  - C. Keep folding as today. The 1:1 check stays 51.89 px off at 1025, and a picture in such a row is drawn stretched
    (the generic fixture's picture: 90 px tall on the site, 162 px pasted at 768).
- **Q2. The sideways axis.**
  - **⭐ A. Block axis (heights) only, as rule 8.** Neither B-Dry (39 folds) nor any of the 30 fixture sites has a body
    narrower than its widget box (planner probe: `dx = 0` everywhere). A body narrower than its widget box in a row
    (a picture with its own `max-width`) is named as a known limit in HANDOFF.
  - B. Both axes: also refuses a body narrower than its widget box. Safe, but it would refuse folds that are fine (in
    a column container a narrower body folds 1:1) with no case on hand to prove the rule on.

## Playback

With `--elementor`, `npm run site` / `site:check` on B-Dry's saved home leaves the **footer** 51.89 px off the site at
1025 px (the same on `main` and with elementor-phone-fit); everything else is within 2 px. Find why as a general rule
for Elementor pages and make the Elementor route 2 px at every measured width for every part (header, page, footer),
with the plain code route and Figma designs unchanged. (Recorded as elementor-map's open "Facebook" row: its HANDOFF
table names the footer section by its first words; the element is the footer's second "Areas We Serve" town list.)

What it lets Justin do: paste B-Dry's whole page with `--elementor` and get every part within 2 px at all 38 widths.
**Plainly: on B-Dry this changes nothing he can see** (the 51.89 px is the town list's own box, which paints nothing:
its words were already 1.09 px off both ways); the visible win is on other sites, where a picture in such a row would
otherwise be pasted stretched.

## Root cause (proved)

**Which element.** The builder's AC1 run (`evidence/elementor-phone-fit/builder/ac1/green-head-fresh.log`, line 26;
reproduced by the planner from the saved stand-in, `planner/ac1-base-phone-fit-head.log`): `footer 1025: 51.89
(body/div:0/footer:0/div:9/div:3/div:1/div:1/div:0/p:0) boxes 51.89 words 1.09`; every other row of the three parts
at the 38 widths is ≤ 1.06 px (header 0, page ≤ 1.02).

**Why** (capture declarations and boxes: `planner/facebook-row-decls-boxes.txt`):
- `body/…/div:3/div:1` (Elementor container `737286d`) is `display:flex; flex-direction:row` from 1025 up, with no
  `align-items` (so `normal`, which stretches flex items); it holds two text-editor widgets side by side, `17e78ee`
  (Evansville … Mt Vernon) and `f2bd68b` (Princeton … Tell City). From 992 down it is a column with `align-items:
  center`, so nothing is stretched there.
- At 1025 the columns are 91 px wide: `17e78ee`'s paragraph wraps to 182 px, `f2bd68b`'s to 130 px. The row is 182 px
  tall, so `f2bd68b`'s widget box is stretched to 182 px; its `.elementor-widget-container` has Elementor's `height:
  100%` and follows it (182 px); its `p` is a block with an auto height and stays 130 px. At 1196 and 1366 both
  paragraphs are 130 px, so nothing is stretched there; only the capture's 1025 sample shows it.
- `17e78ee` is not folded (its holder pads at 577–767); `f2bd68b` is (`notes.txt`: 38 footer folds).

**What the fold does** (`src/core/site/elementor-fold.ts` at `7b7d345f`):
- `fold` (lines 274–276) puts the body `p` in the widget box's place in its parent's children: the `p` becomes the
  row's flex item.
- `merge` (line 218) drops the wrappers' placement and size declarations (the holder's `height: 100%`) and (line 219)
  takes the widget box's own placement (`flex-grow: 0; flex-shrink: 0; width: auto; max-width: 100%`); nothing keeps the
  `p` from being stretched.
- `foldable` never compares the widget box's height with its body's: rule 3 (lines 135–142) counts `height: 100%` as
  neutral (`NEUTRAL_SIZE`, line 51), rule 6 (lines 162–177) only looks at sizes the widget box declares, and rule 8
  (`marginBoxes`, lines 188–208) checks only that the body's height plus the inner margins is not below 0.
- Folded, the `p` is stretched to 182 px: its words stay in place (1.09 px), its box is 52 px taller than the site's
  (51.89 px). A picture would be drawn stretched: its box is its look.

**Why the widget box has no measured box of its own.** The capture folds a wrapper into its only child when it paints
nothing and has the child's box (±1 px) at every width (`src/web/map/tree.ts`, header lines 4–6), so `f2bd68b`'s
widget box (always the holder's size) has no layer; its holder does (182 px at 1025, 130 px at 1196). So the widget's
box is the box of the **first element of the chain the capture measured**: comparing `chain[0]` with the body, as the
builder's scan and elementor-map's `sameBoxes` do, skips exactly this case.

**Proof** (planner prototype, in scratch trees only, `planner/rule9-prototype.diff`):
- **B-Dry, every part at every width** (`site-elementor-page-bdry.test.ts` from the saved stand-in, 41 s each):
  base (phone-fit head) header 0 px at all 38 widths, page ≤ 1.02, footer 51.89 at 1025 (else ≤ 1.06), RED; with the
  rule header 0, page ≤ 1.02, footer ≤ 1.09 at all 38, GREEN (`planner/ac1-base-phone-fit-head.log`,
  `planner/ac1-with-rule9.log`; 114 rows each).
- **Only that fold changes:** the rule refuses exactly `f2bd68b` on B-Dry (`planner/notes-diff.txt`: footer 38 → 37
  folded, one new note); of 582 outputs (31 captures: B-Dry's stand-in and the 30 fixture sites, both routes, whole
  page and every section) exactly 2 differ, B-Dry's Elementor footer whole and its section `footer:0/div:9`; plain
  route 0, the five fixture Elementor sites 0; the five Figma replays byte-identical (`planner/bytes/`, the
  phone-fit builder's `ac4/bytes.sh`).
- **Generic fixture** (`planner/proto/elementor-stretch/`, `planner/proto/site-elementor-stretch.test.ts`): base 81 px
  from 1440 up, 108 at 991–992, 135 at 768, 0 from 767 down (stacked), nothing named, RED (`planner/fixture-base.log`);
  with the rule 0 px at all 14 widths and at 300, the short text and the picture named, GREEN
  (`planner/fixture-rule9.log`).
- The unit suites `test/unit/site-*.test.ts` all pass with the prototype (166 of 167, one skipped, as on base).

## The general rule (fold rule 9, "Filled boxes")

A flex or grid container may stretch its item (the widget box) past what the item's contents need; a block body inside
keeps its own height. Folded, the body *is* the item and is stretched itself. So:

- The widget's measured box is the box of the first chain element `layerBoxes` holds (index `k`); the capture folds a
  wrapper with its child's box into it, so earlier chain elements had that box. No chain element measured, or only the
  body (`k === body`): nothing to compare, the rule passes.
- **At every width the capture measured both `chain[k]` and the body at, in a kept range (not a `skipWidths` width),
  `chain[k]`'s height minus (the body's height plus the top and bottom margins of `chain[k+1] … chain[body]` of that
  kept range, the body's tag look counted, `st`) must be ≤ 0.5 px** (elementor-map's `sameBoxes` tolerance). Else the
  widget keeps its elements, named: `not folded: text-editor f2bd68b: its p is 130px tall in its holder's 182px at
  1025 (the widget box is stretched or sized by its container: folded, its p would take its height)` (`its widget
  box's` when `k = 0`). The largest excess is named; on a tie, the wider width (rule 8's tie-break).
- Margins in px, `rem` (the range's `rootFontSize`) and `em` (the element's computed font size: the nearest `inherited`
  `font-size` from the element up, else the capture's `context`; a paragraph's 1em tag look is common) are resolved;
  any other margin (`%`, `auto`, `calc()`) counts as 0, so an excess it would explain refuses (conservative: the plain
  route is 1:1). Margins collapsing through a block wrapper can only make `chain[k]` shorter than the sum, never refuse.
- Judged after rule 8 (`marginBoxes(…) ?? filledBoxes(…)`): a chain rule 8 refuses keeps rule 8's note.
- Block axis only (Q2). Width → kept range exactly as rule 8 (`code.ranges` ids, `pr.skip`, `pr.from`).
- Recognised by geometry only: nothing keyed on B-Dry ids, words, classes or Elementor widget types (every mapped
  widget kind and the accordion chain pass through `foldable`).
- **Known limits (HANDOFF):** judged at the capture's widths only (a widget its row stretches only between two samples
  folds; the capture reads both ends of every range); a body narrower than its widget box (Q2).

Prototype (`planner/rule9-prototype.diff`, ~35 lines; `FOLD_LOG` there is probe-only, don't copy it): two helpers
`fontPx(code, pr, path, r)` and `lengthPx(v, font, root)` and `filledBoxes(code, pr, e, chain, st, boxes, name)` after
`marginBoxes`. Keep `elementor-fold.ts` readable: it is ~320 lines; if it passes ~360, move rules 8 and 9 into
`src/core/site/elementor-measured.ts` (pure, same imports) and import them.

## Acceptance criteria (proposed)

- **AC1 (proposed):** B-Dry's whole saved home (header, page and footer) pasted with the Elementor step matches the saved
  page within 2 px at every width the stand-in capture read (38: 2560 … 320; every element, word and picture, as
  `checkPage` measures), offline, no request naming the site; the footer's `f2bd68b` keeps its elements, named by rule
  9. Base (phone-fit head): footer 51.89 px at 1025, RED. Test: `test/web/site-elementor-page-bdry.test.ts` "B-Dry's
  whole page with the Elementor step: within 2 px at every width" (named-only: `F2B_CODE_PROOF_BDRY`,
  `F2B_CODE_PROOF_CAPTURE`; `F2B_ELEMENTOR_STANDIN=evidence/elementor-phone-fit/builder/ac1/head-fresh/standin-capture.json`
  reuses the saved v2 stand-in; add the assertion that `parts.footer.notes` holds `not folded: text-editor f2bd68b: its
  p is ` … `px tall in its holder's ` …).
- **AC2 (proposed):** a generic Elementor fixture (`test/fixtures/web/sites/elementor-stretch/`, from the planner's
  prototype: a row container, side by side from 768 up, holding a long text editor, a short one and a picture widget,
  so the short text's and the picture's widget boxes are stretched; a row of two one-line headings and a text editor
  whose paragraph keeps the browser's 1em margins, which fill their boxes) captured and pasted with the Elementor step
  is within 2 px at every width the capture read plus 300; the short text and the picture keep their elements, named
  by rule 9; the long text, both headings and the 1em paragraph fold to one element. RED on base (81–135 px from 768
  up, nothing named). Test: `test/web/site-elementor-stretch.test.ts` "a widget box its row stretches past its body
  keeps its elements: 1:1 at every width".
- **AC3 (proposed):** fold rule 9 in units, on `test/fixtures/site-elementor-code.ts` (boxes through layers'
  `web.boxes`, as rule 8's cases do): a text editor whose holder is measured 182 px over a 130 px `p` at one width (its
  widget box with no box of its own) refuses with the holder note and keeps today's elements exactly; a measured widget
  box over a shorter body names `its widget box's`; a px, a `rem` and an `em` margin (the `p`'s 1em tag look, its font
  size from `inherited`) that explain the difference fold; a 0.4 px excess folds, 0.6 px refuses; a width in a left-out
  range or with no body box is ignored; no wrapper measured folds; the largest excess is named, a tie at the wider
  width; a chain rule 8 refuses keeps rule 8's note. RED on base (it folds). Test:
  `test/unit/site-elementor-fold.test.ts` "a widget box measured taller than its body and the margins between them
  refuses the fold, named; margins that explain it still fold".
- **AC4 (proposed):** nothing else changes: of every output of B-Dry's stand-in and the 30 fixture-site captures (both
  routes, whole page and every section) only B-Dry's Elementor footer (whole, and its section `footer:0/div:9`) differs
  base vs head; the plain code route is byte-identical everywhere; the five Figma replays (`hydraulics-home`,
  `gro-home`, `figma-to-bricks-debug-page-1`, `…-design-inspo-brainstorm`, `services-2199895`) are byte-identical;
  `npm run check` and `npm run corpus` green, corpus numbers unchanged. Test: the phone-fit builder's
  `evidence/elementor-phone-fit/builder/ac4/bytes.sh <base tree> <head tree> <out> <captures dir>` (base tree: `git
  archive 7b7d345f`, or the build's base commit; captures: `/home/justin/.cache/ep-b/fixture-caps/*.json` plus the
  stand-in, or captured afresh with its `capture-fixtures.ts`), plus `test/unit/plugin-convert.test.ts`.
- **AC5 (proposed):** no other Elementor fixture is worse: `site-elementor-proof`, `-pbox`, `-grid`, `-svg-icons`,
  `-open-place`, `-pull`, `-cli`, `-names` (and `-wxr` skipped unless named) pass, and B-Dry's FAQ list
  (`site-elementor-bdry.test.ts`, named-only, the saved stand-in) passes; their Elementor pastes are byte-identical
  (AC4's receipt). Test: those test files.
- **AC6 (live) (proposed):** Justin pastes the Elementor whole page (`npm run site -- <stand-in> --elementor`) on B-Dry
  staging and opens it at 1025 px wide: the footer's "Areas We Serve" town lists sit as on the saved page, and in
  Bricks' structure panel the second list (Princeton … Tell City) keeps its two wrapper elements around its text, as
  the first list does.
  Test: his paste check (HANDOFF names it **`<elementor-footer-fit id at merge>`**).

## Tasks (test-first, one commit each)

0. Copy this plan into `docs/plans/`; start the ledger; `npm run corpus` before Task 1 (the worktree's `node_modules`
   has no `.bin`: testing-pitfalls). Read `planner/rule9-prototype.diff` and `planner/proto/`.
1. **AC3 unit RED → rule 9.** Add the unit test (each case a `withBoxes`-style patch of the fixture's layers; the holder's
   layer at `PATHS` of the text editor, no layer for its widget box). RED on base. Implement rule 9 in
   `src/core/site/elementor-fold.ts` from the prototype: `fontPx`, `lengthPx`, `filledBoxes`, called as `return
   marginBoxes(…) ?? filledBoxes(…)` at the end of `foldable`; the header comment's "eight fold rules" → nine (lines 4–5
   and 112) and a rule comment like rule 8's. GREEN; `npm run check`. Mutants (record killed/survived): rule 9 off; `em`
   as 0 (the fixture's 1em paragraph refuses); `chain[0]`'s box only (B-Dry's `f2bd68b` folds); the 0.5 tolerance
   dropped or raised to 60; margins not subtracted; left-out ranges not skipped.
2. **AC2 fixture RED → GREEN.** Move the planner's prototype fixture and test into the repo
   (`test/fixtures/web/sites/elementor-stretch/`, `test/web/site-elementor-stretch.test.ts`; drop the prototype's
   `console.log` lines or keep them as `# ` diagnostics). Its picture is a `data:` svg on purpose: the test closes the
   fixture server before pasting, and a served picture reads "picture not shown" at 300 (planner's first try). Show RED
   by copying the test and fixture into a base tree (testing-pitfalls), GREEN on head.
3. **AC1 B-Dry.** Add the `f2bd68b` note assertion to `site-elementor-page-bdry.test.ts`; run it with
   `F2B_ELEMENTOR_STANDIN` (≈ 41 s, `planner/proto/ac1.sh`); base RED by the test copied into a base tree. Receipts:
   the per-width table, notes and site | paste shots at 1440/768/390 (`F2B_ELEMENTOR_PAGE_OUT`), plus a 1025 shot of
   the footer if the shots helper takes extra widths.
4. **AC4/AC5 receipts** (bytes.sh, the Elementor test files, B-Dry's FAQ named test with the stand-in); `npm run check`,
   `npm run corpus`.
5. **Docs & records:** HANDOFF section "Elementor stretched widgets" (rule 9, its note, Q1 A and Q2 A "not yet
   confirmed", the proof, known limits, paste check `<elementor-footer-fit id at merge>` with AC6's steps in the
   end-of-run list); mark elementor-map's open "Facebook" row (its table and the "Where the step is still worse"
   sentence) and phone-fit's mention of it as fixed by this job; ledger.

**Touched files:** `src/core/site/elementor-fold.ts` (one source file); tests `test/unit/site-elementor-fold.test.ts`,
`test/fixtures/site-elementor-code.ts` (if a box helper is needed), new `test/web/site-elementor-stretch.test.ts` and
fixture folder, `test/web/site-elementor-page-bdry.test.ts`; `docs/HANDOFF.md`, the plan and ledger.

## Overlaps

- **elementor-phone-fit** (`elementor-phone-fit-build`, `7b7d345f`): this job's base; rule 9 goes after its rule 8.
  If its review changes `marginBoxes`' signature, rebase and keep `?? filledBoxes(…)` after it.
- **site-motion** (`site-motion-fix5`, `cd4ac623`): adds one refusal in `foldable`'s first loop (`elementor-fold.ts`
  ~line 126, "changes under a state"); no textual overlap with the end of `foldable`; a trivial rebase.
- **capture-speed** (main `99ff06f4`): capture side only. The saved stand-in is code version 2 from phone-fit's build;
  check `web.code.version` before reusing it (testing-pitfalls), and recapture only if a merged job changed the capture.

## Machine notes for every agent

Node `/home/justin/.local/node-v22.23.3/bin` first; `TMPDIR` ≤ 38 chars (`~/.cache/ef-b/tmp`, its own per concurrent
Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; browser runs under `systemd-run --user
--scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry's whole page: 6G); close every Chrome; scripts written with Write and
run with `bash <file>`. The planner's probes (`planner/proto/folds.ts`: every folded chain's measured widget box vs body
per width; `notes.ts`: each part's fold notes; `row.mjs`: a subtree's declarations and boxes) run from a scratch tree in
about a second; `folds.ts` needs the prototype's `FOLD_LOG` export. Comparing two pastes made against fixture servers on
different ports compares class fingerprints made from different addresses: compare conversions of the saved stand-in in
one process (`planner/proto/bytes.ts`) instead.
