# site-faq: an Elementor FAQ pastes as an Accordion whose open look follows Bricks' open item (plan, 2026-11-09)

Planner: site-faq (Opus 5.5). Main `fd1986dc` (Build 2026-11-09.3). Mini pipeline, website importer rules (one real-bug
review; edge cases to follow-ups). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-faq/planner/` (index:
`README.md`). Reuses staging-fit's measurements (`evidence/staging-fit/planner/`, read only).

## Questions (⭐ = the answer the standing auto-go takes)

1. **When the capture's widths disagree about which answer is open.** Bricks has one open state at every width
   (`expandItem`), so the paste must pick one. ⭐ **A:** the design width's range decides (the width the site was drawn
   for); a panel shown at other widths only is named in a note ("answers shown differently at 768–991 px"). B: the
   state most widths share. C: as today (no open item, the open look stays on the first item).
2. **Several answers open at the design width** (rare: an accordion set to show more than one). ⭐ **A:** all of them open
   in Bricks (its "Expand item indexes" control takes `0,2`, read from Bricks' own code, not yet round-tripped) and the
   look they share moves onto Bricks' open state; a click still opens one at a time. B: as today (none opened, a note),
   kept as a follow-up.
3. **The underlined questions.** The old site underlines them too: its theme (Astra) has
   `.ast-single-post .entry-content a{text-decoration:underline}`, which beats ElementsKit's `none` (offline proof below).
   ⭐ **A:** keep them as the site draws them (1:1). B: drop the underline on accordion questions (a look the site doesn't
   have).
4. **The open item's own look must beat Bricks' class controls.** Live Bricks prints a class's controls as
   `.cls.brxe-block` (0,2,0, staging-fit R3); an open look on the item itself is `.acc > .brx-open` (0,2,0): a tie that
   print order decides. ⭐ **A:** write it `.acc > .brx-open.<item class>` (0,3,0), as the rules below the item already
   outrank; pastes holding such a look change bytes. B: leave it.
5. **Order.** ⭐ **A:** build now beside staging-fit's jobs (other files); merge in any order; Justin's live check after
   staging-fit-capture lets him re-capture bdryswi.com (this job's rule alone already fixes today's capture too).

## Playback

1. Justin pasted the importer's whole page (`--elementor`, build 2026-11-09.3, `/home/justin/f2b-test/paste-el3/whole.json`)
   on B-Dry staging `/homev2/`. In the FAQ (a Bricks Accordion (Nestable) made by elementor-map) the first question
   shows its open look (orange, ↑) while its answer is closed.
2. Clicking another question's chevron doesn't move that look or (in the editor) open the answer.
3. The question words are underlined; he asks us to check the site.
4. He wants it general: every Elementor/ElementsKit FAQ opens and closes in real Bricks like the site, its open look
   tied to Bricks' open state, never baked onto one item.

## What the site does (proof)

- **Served page** (bdryswi's home of 2026-10-29 with its full CSS, offline, `offline/shot.png`, `offline/probe.json`):
  the first answer is open, its title orange (`#FFB356`, words `#004774`) with ↑; the others navy with ⌄; every
  question is underlined (DevTools' matched rules for the toggle: `a`, `.elementor a`, `.ekit-wid-con a` say `none`, then
  Astra's `.ast-single-post .entry-content a` says `underline` and wins). Hover and focus: `none`.
- **The 2026-11-09 capture** (`shape.txt`, `shown.ts`): the ElementsKit widget `0a3b057`, five cards; card 0 has
  `elementskit-card active`, its panel `show collapse`, shown at **all 16 ranges**; cards 1–4's panels are shown **only at
  922-991, 835-921, 769-834, 768-768** — the four ranges staging-fit proved were read from a page without its styles
  (`.collapse{display:none}` lost; staging-fit R1). Every toggle is declared `text-decoration-line: underline` at rest,
  `none` on hover/focus (as served). The 2026-11-04 capture declares the same 14 underlined links (`links.ts`).

## What the paste does (proof)

- `whole.json` (`paste-accordion-tree.txt`, `paste-faq-classes.txt`): the accordion has **no `expandItem`**; item 0's
  title row and arrow boxes have their own classes (`row-jniz`: orange background, navy words; `box-zfdm`/`box-ubpj`: ↑
  shown) while items 1–4 share `row-xejn` (navy, orange words) and `box-bneu`/`box-ceov` (⌄); no `.brx-open` look rule.
- **Staging front end** (logged out, `live/probe.json`, `live/faq-*.png`, and staging-fit `probe2/staging.json`): Bricks'
  accordion script runs (`listening` on every item). At load all five answers are closed and item 0 is orange with ↑.
  A click on question 3 opens it (`brx-open`, `aria-expanded=true`, answer `block`) **but its title stays navy ⌄ and item 0
  stays orange ↑**, at 1440, 900 and 390. The renderer draws the same (staging-fit `probe2/renderer.json`;
  `dryrun/dryrun.json` "base").
- **Underline:** the question words are underlined on the front end at 1440 (`live/faq-1440.png`), as on the site. The
  decorating row is a flex container, the words' wrapper a flex item (blockified), so the underline reaches the words.
  (staging-fit read `text-decoration-line` on the words' `p`, which isn't inherited, so its "front end shows none" was a
  measuring slip; corrected here.) In the editor screenshot the canvas is ~990 px wide, inside the paste's broken
  768–991 block (staging-fit R1), which also reverts the words' wrapper to inline.
- **Bricks 2.4.2 = 2.3.9 here:** staging's `bricks.min.js` `bricksAccordionFn` is byte-identical to the 2.3.9 reference
  (4289 chars, `staging/same-js.txt`), and its `accordion-nested.min.css` equals `reference/bricks/frontend-2.3.9/
  el-accordion-nested.min.css` minus the `@layer` wrapper. The function has no `frontEndOnly`, so it runs in the editor's
  canvas too; its click handler ignores only Bricks' `.bricks-active-selector-detector`.

## Root cause (proved)

**C1: the open item is decided from every width at once.** `src/core/site/elementor-accordion.ts:57`
`const open = items.map((x, i) => (shownIn(x.panel).length ? i : -1))` counts an answer as open if **any** kept range
shows it; with the four styleless ranges showing cards 1–4, five answers count as open, so `:61` returns `open: null,
several: true`. Then `accordionPicks` (`:68`) writes no `expandItem`, `openLook` (`:100` `if (s.open === null) return
null`) moves no look, and `foldElementor` (`elementor-fold.ts:275-277`) only adds the note "several answers open at load".
Card 0's open look (orange, ↑) therefore stays in its own classes — a static look that never follows Bricks' `brx-open`.
Proved by `dryrun/`: the same capture with only the closed panels' styleless ranges dropped converts with `expandItem: "0"`,
five `.brx-open` rules, and in Bricks' script the look moves with every click at 1440/1100/600/390.

**C2 (general, same symptom):** whenever more than one answer is open in the decision (several open at the design width,
Q2), the same branch bakes every open item's look. **C3 (latent, Q4):** an item-level open look `.acc > .brx-open` ties
with Bricks' printed class controls `.cls.brxe-block` (`lookCss`, `:159`); the renderer prints controls as `.cls`
(0,1,0), so no test sees it (staging-fit job C changes that).

The capture's styleless ranges themselves are staging-fit-capture's job; this job makes the accordion decision robust
to any width that disagrees (a broken read, or a site script that opens answers per width).

## The general rule

An Elementor or ElementsKit accordion pastes as one Bricks Accordion (Nestable) whose load state is the **design width's**:
`expandItem` lists the answers shown open in the capture's range that holds `web.designWidth` (widest kept range when none
holds it); answers other ranges show differently are named in one note. The look the open items share and every closed
item lacks is moved onto `.brx-open` rules that outrank Bricks' class controls (every selector at least three classes),
so every item keeps the closed look in its own classes and the look follows Bricks' open item after any click, at every
width, front end and editor. None open at the design width: no `expandItem`, no open look (nothing to learn). Nothing
keys on B-Dry: only widget types, structure, `shown` per range and the widget's state classes are read.

## Acceptance criteria (all proposed)

- **AC1 (proposed):** a generic ElementsKit fixture (`elementorCode()`, first card open at every range) whose third panel
  is also shown at a narrower range only pastes with `expandItem: "0"`, the first card's open look on `.brx-open` rules,
  the first card's title/arrow elements sharing the closed cards' classes, and one note naming that range's widths.
  Test `test/unit/site-elementor-open-item.test.ts` "a narrower range showing other answers doesn't stop the design
  width's open item". RED on main (no `expandItem`, no look, "several" note).
- **AC2 (proposed):** an answer shown open only below the design width (Elementor accordion fixture, none open, item 1's
  panel shown at `0-767` only) pastes with no `expandItem`, no `.brx-open` look and the note. Same file, "an answer open
  only below the design width opens nothing at load". RED on main (main writes `expandItem: "1"`).
- **AC3 (proposed, Q2 A):** two answers open at the design width (cards 0 and 2) paste with `expandItem: "0,2"`, the look
  both share on `.brx-open` (cards 0 and 2 share the closed cards' classes), and the note "several answers open at load:
  both open in Bricks, a click opens one at a time". Same file, "several answers open at the design width all open, their
  look on .brx-open". RED on main. Updates the existing `test/unit/site-elementor-widgets.test.ts` "several answers open
  at load: no expandItem, a note; …" (its first three asserts) — allowed edit.
- **AC4 (proposed):** AC1's capture drawn as Bricks draws it (`renderSitePaste`: front-end CSS, accordion CSS and
  `bricksAccordion()`, identical in 2.3.9 and 2.4.2), at 1440, 900 and 390: at load the first answer open, its title in
  the open colour with ↑ (the closed arrow hidden); a click on the third title opens it in the open colour with ↑ and
  closes the first, back to the closed colour with ⌄; a second click closes the third. Test
  `test/web/site-elementor-open-item.test.ts` "the open look follows Bricks' open item at every width". RED on main.
- **AC5 (proposed, Q4 A):** an item-level open look (Elementor fixture, 4 items, the second open, a background on it)
  outranks Bricks' class controls: drawn with `.<item class>.brxe-block { background-color: <closed> }` injected after the
  paste's CSS (the live print), the open item shows the open background at load and the clicked one after a click; every
  selector in the accordion's open look has ≥ 3 classes. Same web file, "the open look outranks Bricks' class controls",
  plus a unit assert in the unit file. RED on main.
- **AC6 (proposed):** unchanged where the widths agree: a witness probe (base `git archive` of `fd1986dc` vs head)
  converts every Elementor fixture capture (`test/fixtures/site-elementor-code.ts` builders incl. `elementorOpen(0..2)`
  with/without classes and 4 items, every capture built in `test/web/site-elementor-*.test.ts` that builds without Chrome)
  and the B-Dry 2026-11-04 code capture (`evidence/bdryswi-com-home-2026-11-04-code.f2b-capture.json`, named-only), with
  and without `--elementor`, both picture modes: byte-identical, except pastes holding an item-level open look (AC5),
  listed by id with the one changed selector; the 2026-11-09 capture's plain route byte-identical; `npm run check`,
  `npm run test:web`, `npm run corpus` green and Figma replays byte-identical. Evidence
  `evidence/site-faq/builder/witness/report.json`; the existing elementor-map tests pass unchanged (except AC3's).
- **AC7 (proposed, named-only):** B-Dry's 2026-11-09 capture (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`,
  env `F2B_BDRY_CAPTURE_1109`, skipped without), FAQ section (`…/div:16`) with the Elementor step: `expandItem: "0"`,
  the note names 768–991, open-look rules present; drawn at 1440, 1100, 600 and 390: at load the first title
  `rgb(255, 179, 86)` with words `rgb(0, 71, 116)` and ↑, its answer open; after a click on the third question the third is
  so and the first navy with ⌄; the questions underlined as the site's (row `text-decoration-line: underline`, the words'
  wrapper not inline-block-atomic). Test `test/web/site-elementor-faq-bdry.test.ts`. RED on main (`dryrun/` "base").
  It calls `siteToBricks` directly, so staging-fit-capture's refusal in the CLI doesn't stop it.
- **AC8 (proposed) (live):** after Justin re-captures (once staging-fit-capture merges) and re-pastes the whole page on
  `/homev2/`: an agent reads the front end logged out at 1440, 900 and 390 (`live/probe.ts`): the first answer open,
  orange ↑; a click on another opens it orange ↑ and closes the first navy ⌄. Justin, in the Bricks editor: the first
  question open; clicking another question opens it and moves the orange. If a click in the editor opens nothing, he adds
  one Accordion (Nestable) from Bricks' own elements on the page and clicks its second title in the editor: if Bricks'
  own doesn't open either, that's the editor (recorded); if it does, a follow-up job.

## Tasks (test-first; commit after each)

0. **Baseline.** `npm run check`, `npm run corpus` (keep numbers); `git archive fd1986dc` into
   `~/.hermes/plans/figma-to-bricks/evidence/site-faq/builder/base/` (a FULL archive: `corpus/files` and `reference` are
   needed) for AC6.
1. **Design range** (`src/core/site/ranges.ts`): `designRange(capture, pr): string` — the kept range id whose span holds
   `web.designWidth`, else `pr.ranges[0]`; its capture range is `pr.from[id]`. Unit test in the new unit file (B-Dry-like
   ranges: 1440 → `1367-up`; a design width in a merged range; no design width → widest).
2. **The decision** (`elementor-accordion.ts` `accordionShape`, `elementor-fold.ts:264-277`): RED AC1, AC2 first.
   `accordionShape(code, pr, e, design)`: per kept range, the items whose panel is shown there; `opened` = the design
   range's set (sorted); `open` = `opened[0]` when one, else null; `several` = `opened.length > 1`; `differs` = kept
   ranges whose set isn't the design range's. `accordionPicks`: `expandItem: opened.join(",")` when any. Notes: one per
   accordion with differs: `answers shown open differently at <min>–<max> px (…): the design width's are pasted
   (<widget> <id>)`, ranges merged into runs; the "several" note's new text (Q2 A). Keep the shape's other checks as they
   are (alike items, title shown wherever the list is).
3. **Several open items' look** (Q2 A, `openLook`): RED AC3. Open items O, closed C (C empty → no look); a property moves
   when every C has c and every O has the same v ≠ c; each O's own value becomes c. The place guard generalises: "alone"
   when any O is first or last or no C shares an O's parity; then `marked(rel)` asks for a token every O has and no C, or
   every C has and no O. One O keeps today's code path byte for byte (AC6).
4. **Selectors** (Q4 A, `lookCss:159`): RED AC5's unit assert. The item-level rule becomes `.<acc> > .brx-open.<item
   class>` (each item's class, de-duplicated, as below-item rules do). Check `test/unit/emit-paste-ids.test.ts`'s
   `.x.brx-open` regex still holds (write `.brx-open.<cls>`, not `.<cls>.brx-open`).
5. **Browser proofs:** `test/web/site-elementor-open-item.test.ts` (AC4, AC5) on `renderSitePaste` (it already runs
   Bricks' script and defines `bricksData.i18n.openAccordion`; wait for `window.__f2bAccordionReady`; `settle` before
   reading; move the mouse away after a click: the toggles' hover look is `none`). Show each RED on main first.
6. **B-Dry named-only** (AC7): `test/web/site-elementor-faq-bdry.test.ts`, modelled on `dryrun/dryrun.ts`; heavy: run
   under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`, `node --max-old-space-size=3000`.
7. **Witness** (AC6): a scratch script importing base and head `src/core/site/convert.ts`/`parts.ts` side by side,
   hashing every paste and notes; report expected differences by id. Then `npm run check`, `npm run test:web`,
   `npm run corpus`, replays.
8. **Reference:** `reference/bricks/README.md` under `accordion-nested`: `expandItem` is "Expand item indexes, separated
   by comma, start at 0" (GPL 2.2 `accordion-nested.php` L44-51, printed as `data-expand-item` L376-377; 2.3.9's script
   splits it on `,`), `independentToggle` exists (L53-57, not used); B-Dry staging's 2.4.2 `bricksAccordionFn` and
   `accordion-nested.min.css` equal 2.3.9's (SHA256 in the evidence `staging/SHA256SUMS`). A comma list is not yet
   round-tripped through a paste (only matters under Q2 A).
9. **Docs & records:** plan copied to `docs/plans/2026-11-09-site-faq.md`; ledger `.superpowers/sdd/site-faq/progress.md`,
   moved by the finisher to `docs/plans/2026-11-09-site-faq-ledger.md` before the premerge rebase; `docs/HANDOFF.md` new
   section above the top `## ` heading (rule, rulings Q1–Q4 "not yet confirmed", the underline being the site's, known
   limits below) and the paste check (next free id at merge, after 3dn; check every branch's HANDOFF and the plans) at the
   top of "End-of-run check list" (AC8's steps); `BUILD` bumped at the merge; main `CLAUDE.md` Status: one line.

## Touches

`src/core/site/elementor-accordion.ts`, `src/core/site/elementor-fold.ts`, `src/core/site/ranges.ts`;
new `test/unit/site-elementor-open-item.test.ts`, `test/web/site-elementor-open-item.test.ts`,
`test/web/site-elementor-faq-bdry.test.ts`; `test/unit/site-elementor-widgets.test.ts` (only the "several answers" test's
expandItem/note asserts, AC3); possibly `test/fixtures/site-elementor-code.ts` (a helper to show a panel at chosen
ranges); `reference/bricks/README.md`; `docs/HANDOFF.md`. No Figma-route file. Tests asserting today's behaviour: only
that "several" test (searched `several answers`, `expandItem`, `brx-open` under `test/`); `test/web/site-elementor-proof`,
`-open-place`, `-bdry` read agreeing captures and must pass unchanged.

## Overlaps with the other jobs (built side by side)

- **staging-fit-capture (A):** fixes the cause of B-Dry's disagreeing widths (other files: `src/web/*`, tools). Independent;
  merge in any order. If A moves its refusal into `siteToBricks`/`siteParts` (its plan puts it in the CLI and panel
  only), AC7 needs A's opt-out or the 2026-11-04 stand-in; say so at rebase.
- **staging-fit-cancels (B):** rewrites `blocks.ts`/`classes.ts` range blocks and mentions reusing `lookCss`'s bounded runs.
  Same file (`elementor-accordion.ts`) only if B edits `lookCss`; this job changes only its selector line (`:159`): a small
  textual conflict at worst. Either order.
- **staging-fit-renderer (C):** the renderer will print controls as `.cls.brxe-<el>`; AC5 already proves the look
  outranks that print, so C's change can't turn this job's tests red. Either order.
- **site-native-structure:** may change what elements a title holds (a Heading, a Button). This job's look addresses
  each item's elements **by class** (`classOf(path)`); a look path whose element loses its class gets no rule
  (`lookCss` skips it) and the look would stay baked. Either way: native-structure keeps the accordion picks
  (`accordion-nested`, Block items, `accordion-title-wrapper`/`accordion-content-wrapper` Blocks) and keeps a class on
  every element of `shape.rels` (or routes them through `classOf`); AC4/AC7 then guard it. If native-structure merges
  first, rebase this job and rerun AC4/AC7.
- **site-menu:** popup 27 holds an Elementor **nested-accordion** (`<details>`), not in `ACCORDION_WIDGETS` and in no
  capture yet (`popups: []`). If site-menu pastes it as an Accordion (Nestable), it takes this rule (design-width load
  state, look on `.brx-open`); recognising `nested-accordion` is site-menu's or a follow-up.
- **site-slider, site-reviews:** no shared files.

## Bricks samples

None needed for Q1/Q3/Q4. Under Q2 A, optional (not blocking): Justin copies one Accordion (Nestable) with "Expand item
indexes" set to `0,2` (Bricks → element → Copy) into `reference/bricks/accordion-nested-expand.json`, to round-trip the
comma list.

## Risks and known limits

- The editor can't be proved offline (Bricks' builder runs the same `bricksAccordion()` in its canvas; whether its own
  click handling lets a title click through is AC8's live check, with the native-accordion control).
- An open item at a place of its own (first/last) with **no** state class still keeps a difference on its own classes
  (elementor-map's place guard); ElementsKit (`active`) and Elementor (`elementor-active`) both mark state, so the common
  widgets move their look. Follow-up if a site without state classes shows it.
- An answer open only at some widths can't be kept per width: Bricks has one load state (Q1 A; named in the note).
- The paste's 768–991 look on today's capture stays wrong until Justin re-captures (staging-fit R1), whatever this job does.
