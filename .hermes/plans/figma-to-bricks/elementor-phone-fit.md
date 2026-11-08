# elementor-phone-fit (website importer, Mini): an Elementor heading's negative margin no longer pulls the page up on phones

Planner, 2026-11-08. Base: local `main` `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (Build 2026-11-08.1). Mini pipeline.
Builder: copy this file to `docs/plans/2026-11-08-elementor-phone-fit.md` (in git) as Task 0; ledger in
`.superpowers/sdd/2026-11-08-elementor-phone-fit/progress.md`. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/`.

## Questions (⭐ = taken under the standing auto-go)

- **Q1. Where an Elementor widget's inner negative margin is bigger than its content at some width, what does the paste
  do?**
  - **⭐ A. That widget keeps its own elements (the widget box, its container and its heading, as the plain code
    route pastes it), named in the notes; only where the capture measured the margin outgrowing the content.** Exact
    at every width; on B-Dry's home 8 of the page's 82 folded Elementor elements stay as three elements each (two
    "services" headings and six step headings), the other 74 still fold, header and footer unchanged.
  - B. Never fold a widget with any negative inner top/bottom margin: simpler, but 19 of B-Dry's page folds stay
    unfolded (11 more than needed).
  - C. Keep folding and accept up to ~4 px per heading on phones (today: 7.59 px at 390). Breaks the 2 px promise.
- **Q2. Widths under the capture's narrowest (320).**
  - **⭐ A. The new generic fixture test also measures 300 px; B-Dry's whole-page check measures the capture's widths
    only** (at 300 B-Dry's FAQ shows elementor-map's known limit, "below 320 px an accordion's open look is lost": the
    open/closed arrow pair swaps, 4 boxes; geometry is otherwise 0 px there with the fix; HANDOFF "Known limits").
  - B. Fix the accordion's below-320 open look in this job too (another file, `elementor-accordion.ts`; not Mini-sized).

## Playback

With `--elementor`, `npm run site` / `site:check` on B-Dry's saved home leaves the page part 7.59 px off the site at
390 px (and every width from 767 down); the plain code route is 0 px there and elementor-map promised 2 px at every
width. Find why as a general Elementor rule and make the Elementor route 2 px at every measured width, plain route and
Figma designs unchanged. (Already recorded as elementor-map follow-up R1-5, `evidence/elementor-map/follow-ups.md`.)

## Root cause (proved)

**Which elements.** Per-element diff of the page part at 390, base converter, saved stand-in
(`evidence/elementor-phone-fit/planner/deltas-base-390-768.json`; probe below): every box is 0 px except the ones after
two heading widgets, each shifted up 3.80 px:
- heading `e704deb` (`…/article:0/div:0/div:0/div:2/div:0/div:1/div:0`): from the next widget (`9e0d55e`, its h3 at
  y 1154 on the site) down, every box −3.80 px;
- heading `7c0f9d2` (`…/div:0/div:0/div:14/div:0/div:0/div:0`): from the next widget (`15100f2`'s h2) down, −3.80 px
  more (−7.59 total); the page root is 7.59 px shorter (`ddvtwk`, h 10689.61 on the site).
- At 768 the same thing at 1 px: six step headings (`4c60ce0`, `dcbe415`, `a0d7410`, `482cfb3`, `9f271b5`, `9a81dfc`,
  `div:7/div:N/div:0/div:0`) with `margin-bottom: -27px` and a 26 px heading (−1 px).

**Why.** Each of these widgets is `widget box → .elementor-widget-container → h2/h3`. The site gives the widget
container `margin-bottom: -22px` (every range; Elementor's Advanced → Margin, pulling the next widget closer). The h2 is
`font-size 18px; line-height 1.3em` (23.4 px) from 577 up and 14 px (18.2 px) from 767 down. The widget box is a flex
item of its e-con (`display:flex; flex-direction:column; row-gap:20px`), so it starts its own formatting context: the
container's margin can't leave it, and its auto height is `max(0, 18.2 − 22) = 0` (a box's height is never negative).
The next widget sits 20 px (the gap) under it. On desktop `23.4 − 22 = 1.4 ≥ 0`, so nothing is floored and the routes
agree.

The fold (`src/core/site/elementor-fold.ts`) folds the chain into the h2 and **moves the one margin per side onto it**:
- `merge`, step (d), lines 204–209: `const one = chain.map((_, i) => marginOf(st[i][r], side)).find((v) => !zero(v)); …
  if (one !== undefined) m[`margin-${side}`] = one;` — the h2 now carries `margin-bottom: -22px`;
- `foldable`, rule 5, lines 159–161, checks only that one box per side has a margin, never its sign or size; rule 6
  (162–177) refuses inner margins only inside a widget box that declares a size.
Folded, the h2 *is* the flex item; a flex item's margin box may be negative (18.2 − 22 = −3.8), so the next item moves
up 3.8 px. Two such headings on the page: 7.59 px.

**Proof of the cause** (planner experiment, reverted; `evidence/elementor-phone-fit/planner/`): a rule in `foldable`
refusing exactly the chains whose body's measured height plus their inner top/bottom margins is below 0 at a measured
width turned the page part to **0 px at all 38 widths of the capture** (2560 … 320; boxes, `probe-rule-every-width.log`),
refusing 8 page folds and nothing in the header or footer (`notes-measured.txt`). At 300 px the only difference left is
the FAQ's arrow pair (elementor-map's known below-320 open-look limit, Q2).

## The general rule (fold rule 8, "Margin boxes")

A box's height floors at 0; a flex or grid item's margin box doesn't. So the fold moves a chain's inner margins (on the
wrappers w1…wk-1 and the body, body tag look counted: `tagLook`) onto the merged element only where they leave the
widget box's height as it was: **at every width the capture measured the body at (layer boxes by `web.source.path`,
`layerBoxes`), in a kept range (not a `skipWidths` width), the body's box height plus the chain's inner `margin-top`
and `margin-bottom` of that kept range is ≥ 0** (−0.01 px tolerance). Otherwise the widget keeps its elements (as the
plain code route), named: `not folded: heading e704deb: its margin box is -3.8px tall at <width> (a negative margin the
widget box floors at 0)`.
- Only when some inner box has a **negative** top/bottom margin in some kept range; chains without one are untouched
  (every other fold byte-identical).
- A negative inner margin that isn't a px length (`calc(…)`, `em`; captured margins are computed px, so rare), or a
  body with no measured box at all, refuses (can't be measured; conservative).
- Block axis only. The inline axis needs no rule: a body's measured width already follows its widget box (a block's
  width is its container's minus its margins), so the same sum can't show a floor there; rule 6 covers sized widget
  boxes.
- The widest width of each range has the fewest lines and so the smallest body; the capture reads both ends of every
  range, so the measured widths bound the range (a site whose heading font scales with `vw` inside a range is the
  residual risk; named in HANDOFF).
- Width → kept range: the capture range containing the width (`code.ranges` ids `<min>-<max>` / `<min>-up`); a width in
  `pr.skip` is skipped; else the kept index is `pr.ranges.findIndex((id) => pr.from[id] === <that range>)`. Name the
  most negative sum (ties: the widest width).
- Recognised by geometry and Elementor's element kinds only: nothing keyed on B-Dry ids, words or classes.

## Acceptance criteria (proposed)

- **AC1 (proposed):** B-Dry's whole saved home (header, page and footer) pasted with the Elementor step matches the saved
  page within 2 px at every width the stand-in capture read (38: 2560 … 320; every element, word and picture, as
  `checkPage` measures), offline, no request naming the site. Base: page part 7.59 px at every width from 767 to 320, 1 px from 768 to
  1024 (`planner/probe-base-every-width.log`); with the rule 0 px at all 38 (`probe-rule-every-width.log`). Test: `test/web/site-elementor-page-bdry.test.ts` "B-Dry's whole page with the Elementor step: within
  2 px at every width" (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`; `F2B_ELEMENTOR_STANDIN=<saved
  capture>` reuses a stand-in, e.g. `evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json`, port
  remapped as site-motion's probe does).
- **AC2 (proposed):** a generic Elementor fixture (`test/fixtures/web/sites/elementor-pull/`: heading and text-editor
  widgets whose widget container has a negative block margin; one that outgrows its heading on phones only, one that
  never does, one negative `margin-top` on a text editor's container) captured and pasted with the Elementor step is
  within 2 px at every width the capture read plus 300; the one that outgrows keeps its elements (named in the notes),
  the others fold to one element. RED on base (≥ 3 px at its phone widths). Test: `test/web/site-elementor-pull.test.ts`
  "a negative margin the widget box floors at 0 stays inside it: 1:1 at every width".
- **AC3 (proposed):** fold rule 8 in units: on `test/fixtures/site-elementor-code.ts`, a heading whose holder has
  `margin-bottom: -30px` with a 20 px h2 box at 390 refuses with the note naming `-10px tall at 390` and keeps today's
  elements exactly (same shape as without the step); with a 40 px h2 box it folds and the merged h2 carries
  `margin-bottom: -30px`; a negative `margin-top` counts the same; a non-px negative margin and a body with no box
  refuse; a widget with only positive margins folds as before. RED on base (it folds). Test:
  `test/unit/site-elementor-fold.test.ts` "a negative margin the widget box floors at 0 refuses the fold, named; one
  the body covers still folds".
- **AC4 (proposed):** nothing else changes: the plain code route (`npm run site` without `--elementor`) of B-Dry's
  stand-in (whole page and every section) and of every `test/fixtures/web/sites/*` capture, and the five Figma replays
  (`npm run replay` on `corpus/corpus.json`'s files) are byte-identical base vs head; `npm run check` and `npm run
  corpus` green, corpus numbers unchanged. Test: `tools`-free receipt script `evidence/elementor-phone-fit/builder/ac4/
  bytes.sh` (sha256 of each output, base tree from `git archive 7ff9ba4a` vs head), plus `test/unit/plugin-convert.test.ts`.
- **AC5 (proposed):** no other Elementor fixture is worse: elementor-faq (`site-elementor-proof.test.ts`), elementor-pbox,
  elementor-grid, elementor-svg-icons, elementor-open-place, the WXR and CLI tests and B-Dry's FAQ list
  (`site-elementor-bdry.test.ts`, named-only, with the saved stand-in) all pass, and the Elementor pastes of the five
  fixture sites are byte-identical base vs head (none holds a negative inner margin its content doesn't cover). Test:
  those test files plus the AC4 script's `--elementor` half.
- **AC6 (live) (proposed):** Justin pastes the Elementor whole page (`npm run site -- <stand-in> --elementor`) on B-Dry
  staging and looks at it on his phone (or 390 px): the two "services" headings and the lines under them sit as on the
  saved page, no line pulled up into the heading above it. Test: his paste check (HANDOFF names it **3dl**).

## Tasks (test-first, one commit each)

0. Copy this plan into `docs/plans/`; start the ledger; `npm run corpus` before Task 1 (link `node_modules/.bin/tsc`
   or run tsc directly: the worktree's `node_modules` has no `.bin`).
1. **AC3 unit RED → rule 8.** Add the unit test (extend `site-elementor-code.ts` boxes through its `Over` patch or the
   layer's `web.boxes`, as the existing "3 px wider" case does). RED on base. Implement rule 8 in `foldable`
   (`src/core/site/elementor-fold.ts`, after rule 6, before `return null`; ~20 lines, using `st` (already kept states
   with the body's `tagLook`), `boxes.get(chain[body])`, `marginOf`, `pr`). Update the file's header comment ("the seven
   fold rules" → eight) and the rule list comment. GREEN; `npm run check`.
2. **AC2 fixture RED → GREEN.** Build `test/fixtures/web/sites/elementor-pull/` (Elementor markers as
   `elementor-pbox`'s: boxed e-con, `row-gap`, widget boxes, `.elementor-widget-container` margins, a media query at
   767 shrinking the heading's font) and the browser test modelled on `site-elementor-pbox.test.ts` (capture, close the
   server, paste each section with the step, compare to the capture's boxes at every read width, plus a page check at
   300). Copy the test into a base tree to show RED there (copying the test, not running it from the worktree:
   testing-pitfalls). GREEN on head.
3. **AC1 B-Dry whole page.** New named-only test file (shape of `site-page-bdry.test.ts`'s first test with
   `siteParts(standIn, { text: "rich", elementor: true })`, `F2B_ELEMENTOR_STANDIN` to skip the 32-minute capture,
   widths = the stand-in's). Receipts: per-width table and site | paste shots at 1440/768/390 in
   `evidence/elementor-phone-fit/builder/ac1/`; base RED by running the test copied into a base tree.
4. **AC4/AC5 byte receipts** and the Elementor test files; `npm run check`, `npm run corpus`.
5. **Docs & records:** HANDOFF section "Elementor negative margins" (the rule, the note, the residual `vw` risk, paste
   check 3dl with AC6's steps), close elementor-map follow-up R1-5 there; ledger.

**Touched files:** `src/core/site/elementor-fold.ts` (one source file); tests `test/unit/site-elementor-fold.test.ts`,
`test/fixtures/site-elementor-code.ts` (if needed), new `test/web/site-elementor-pull.test.ts`,
`test/web/site-elementor-page-bdry.test.ts`, new fixture folder; `docs/HANDOFF.md`, the plan and ledger.

## Overlaps

- **site-motion** (`worktree-agent-acb4df7f943f7bd4c`, head `85a1f2fe`) adds one refusal to `foldable`'s first loop
  (`elementor-fold.ts:126`, "changes under a state"); rule 8 goes at the end of `foldable`: no textual overlap, a
  trivial rebase. Its probe (`ac11-still-probe.log`) shows the 7.59 px identical on both converters. It also touches
  `convert.ts`, `classes.ts`, `test/browser/render.ts`: this job doesn't.
- **capture-speed** (`capture-speed-build`, `e455130b`): capture side only; none.
- Once merged, site-motion's AC11 "elementor still" row at 390 should read ≤ 2 px (Justin's "fix 7.59 px later").

## Machine notes for every agent

Node `/home/justin/.local/node-v22.23.3/bin` first; `TMPDIR` ≤ 38 chars; `CHROME_PATH` a wrapper exec'ing
`/home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer`; browser runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; close every Chrome; scripts written with Write and run
with `bash <file>`. The planner's probe (`evidence/elementor-phone-fit/planner/zz-ep-probe.test.ts` with `probe.sh`/`all.sh`,
per-element site-vs-paste deltas of the page part at any widths, both routes; copy it into `test/web/` of the tree under
test, untracked, and delete it after) runs in ~25 s for two widths, ~4 min for all 39, from the saved stand-in. The
reverted experiment is `planner/experiment-reverted.diff` (env-switched; the real rule reads kept ranges and `tagLook`,
never `process.env`, which Figma's sandbox lacks).
