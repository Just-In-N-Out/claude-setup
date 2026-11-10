# footer-icon-list: a box side the site writes by two names keeps the site's winner (website importer, bug)

Planner: Opus 5.5 high, 2026-11-10. Base: `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4).
Recommendation: **Mini** (reason at the end). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/planner/`
(`notes.md` lists every receipt). The builder copies this file to `docs/plans/2026-11-10-footer-icon-list.md` as Task 0.

## Questions (⭐ = recommended; the builder takes ⭐ unless Justin answers otherwise)

- **Q1. The inline sides** (`margin-left` beside `margin-inline-start`, `padding-right` beside `padding-inline-end`): the
  same cascade mix-up can happen there, but which physical side a logical inline side means depends on the text
  direction (left-to-right or right-to-left), which a range's declarations can't see.
  - ⭐ **A.** Leave them for a follow-up (no captured site holds one today: probe over B-Dry's captures, `notes.md`).
  - B. Include them now, reading each element's direction from the capture's inherited chain (more code, more risk).
- **Q2. Older captures vs new ones.** The conversion can only read which name the site wrote later from the order the
  capture lists them, which is exact when each name is written once (a reset, then a widget rule: B-Dry's case).
  - ⭐ **A.** Fix the conversion only now (every capture, Justin's saved ones too); making the capture itself keep only
    the winner is a follow-up.
  - B. Also change the capture (`src/web/read/code.ts`) to keep only the cascade's winner (exact on new captures; a
    capture-level change and a second test layer).
- **Q3. Justin's staging page.** It is off by this today too (see "Justin's staging page today").
  - ⭐ **A.** After the merge Justin re-pastes B-Dry's whole home on staging /homev2/ and runs `site:live` (AC6, live).
  - B. Leave staging as it is until site-native-structure merges, then one re-paste for both.

## Playback (plain words)

1. Since Build 2026-11-10.4 our test drawing prints a class's Bricks settings the way the published page prints them.
2. Since then B-Dry's footer contact list (four rows with an icon each: phone, address, hours, email) is drawn 69 px
   too short at every width, where the old drawing matched the site within 0.11 px. The paste itself did not change.
3. Question: is the new drawing wrong, or was the paste always wrong and the old drawing hid it?
4. Answer: **the paste is wrong, and the new drawing shows what real Bricks shows.** Justin's staging page has the
   same short list today.

## Root cause (proved)

**The site writes each row's top and bottom spacing twice, under two names, and our paste keeps both.**

- On bdryswi.com a reset sets every `li` to `margin: 0; padding: 0`. Elementor's icon-list rule, later and stronger,
  spaces the rows with the logical names `margin-block-start: calc(23px/2)` and `padding-block-end: calc(23px/2)`. In
  the browser the later declaration wins, so each row gets 11.5 px above and below.
- The capture keeps both. `src/web/read/code.ts:145-152` builds each element's declarations as a map by property
  name. `margin-top: 0px` and `margin-block-start: calc(23px/2)` are different names, so both survive, in the order
  each was first written. In the stand-in capture, `body/div:0/footer:0/div:9/div:1/div:1/div:0/ul:0/li:1` at
  `1367-up` lists `margin-top` at position 5 and `margin-block-start` at 23 (`probe5`, `notes.md`). Only six nodes in the
  whole B-Dry capture hold such a pair: the four footer rows, with different values, and two page paragraphs, both 0.
- The conversion splits the pair. `src/core/site/controls.ts:72` maps `margin-top`/`padding-bottom` to Bricks
  controls (`_margin`, `_padding`). Logical names have no rule there, so they stay the class's custom CSS
  (`controls.ts:118-122`).
- Published Bricks prints a class's controls as `.<class>.brxe-<element>` (0,2,0) and its custom CSS as `.<class>`
  (0,1,0). That is what B-Dry staging prints, Bricks 2.4.2: all 343 control blocks there
  (`reference/bricks/README.md` "Class selectors"; `evidence/staging-fit/planner/staging/css/inline-2.css`). So the
  physical `margin-top: 0px` control beats the logical `margin-block-start` custom CSS whatever the print order:
  `probe3.log`, "real Bricks / new renderer" gives margin-top 0px either way.
  - The new renderer prints exactly that (`test/browser/render-order.ts:23-46`, `klass`).
  - The old renderer printed the controls as `.<class>` before the custom CSS, so the custom CSS won by order. That
    happened to be the site's winner here, which hid the bug.
- The exact declarations:
  - `.home__facebook__row-cztp.brxe-div { … padding-bottom: 0px … }` vs `.home__facebook__row-cztp { padding-block-end: calc(23px/2) }` (row 1);
  - `.home__facebook__row-upmg.brxe-div { … margin-top: 0px … padding-bottom: 0px … }` vs `.home__facebook__row-upmg { margin-block-start: calc(23px/2); padding-block-end: calc(23px/2) }` (rows 2 and 3);
  - `.home__facebook__row-wwpc.brxe-div { … margin-top: 0px … }` vs `.home__facebook__row-wwpc { margin-block-start: calc(23px/2) }` (row 4).
  - Row 4 sits 11.5 + 23 + 23 + 11.5 = **69 px** higher. `probe1.log` (main's own `footer.html`, Chrome) measured the
    box at 167.11 px against 236.11 px, with row 4's top at 133.69 against 202.69 px: exactly 69.00 at 1440 and at 390.
    Writing those three classes' control selectors back as `.<class>`, or dropping only their `margin-top`/
    `padding-bottom` controls, gives the site's 236.11 px.
- **A paste that held both names never drew right in real Bricks.** The one rule a class's custom CSS is written as
  sorts the names (`src/core/site/classes.ts:85-86`, `Object.keys(decls).sort()`). `margin-block-start` sorts before
  `margin-top` (and `-block-end` before `-bottom`), so the physical name wins there as well. Justin's staging page holds
  an older all-custom-CSS paste of exactly that shape (below).
- Answer to "which side": **(a), the conversion.** The new renderer prints what real Bricks prints; nothing in
  `test/browser/render*.ts` changes.

### Receipts (all under the evidence folder)

- `named-main.log`: `site-elementor-page-bdry` on a `git archive` of main fails, footer 69 px at every width, e.g.
  `footer 1440: 69 (body/div:0/footer:0/div:9/div:1/div:1)`.
- `named-proto.log`: the same test on a prototype of the fix passes 2/2 (footer ≤ 1.09, page ≤ 1.02, header ≤ 0.03).
- `proto-footer.log`, `proto-footer-239.log`: `site:check --part footer --elementor` on the stand-in capture is within
  0.11 px with Bricks 2.4.2 and with `--bricks 2.3.9`. Main gave 69.07 px with both: fixer-3's `main-242.log`,
  `main-239.log`.
- `fixture-main.log` / `fixture-proto.log`: the generic fixture below. Main is 72 px off at 768 and up and 36 px on
  phones; the prototype is 0 px at every width.
- `unit-one-side-main.log` / `-proto.log`: the unit rule. 4 of 5 tests fail on main (the 5th is a guard); 5 of 5 pass
  on the prototype.
- `unit-main.tap` / `unit-proto.tap`: the whole unit suite gives 3462 pass and 0 fail on both. No existing test pins
  the old output, the site-slider goldens included.
- `bytes-2.log` and `sums-proto.log`, five saved real captures: every header and page part, and every part of the
  other captures, is byte for byte as main's. Only footers holding the pair change.
- `proto-whole.log` / `main-whole.log` (`--whole --elementor`): footer 0.11 px with the fix, 69.07 on main. The page
  part is 64 / 46.5 / 6.93 px off in `--whole` on **both**, a separate pre-existing issue (see "Found elsewhere").
- `proto-src.patch`, `proto-tests/`: the prototype the tasks below write out (scratch only, never committed).

## What else the cause reaches (the general rule)

- **Any site element whose cascade writes one side by its physical name and, with a different value, by its logical
  name.** In practice: a reset or normalise (`margin: 0`, `padding: 0`, `p { margin-top: 0 }`) together with a page
  builder's or theme's logical spacing.
  - Elementor ≥ 3 icon lists: `margin-block-start`/`padding-block-end`.
  - Widget gaps: `margin-block-end`.
  - Container paddings written as `padding-block-*`.
  - WordPress block themes' flow spacing: `margin-block-start` on `.is-layout-flow > *`, a very common shape on
    WordPress sites.
- The same mix-up affects sizes (`width`/`inline-size`, `height`/`block-size` and their min/max), insets
  (`top`/`inset-block-start`) and the block borders. The rule covers all of them.
- Inline sides (left/right) have the same mix-up but need the direction (Q1).
- **On the site's own side, either name can win.** When the logical one wins (B-Dry), today's paste loses it in real
  Bricks: the physical name is a control or sorts later.
  - When the physical one wins (a stronger physical rule later), today's paste happens to draw right in real Bricks.
    The old renderer drew it wrong.
  - The fix keeps whichever the site applied last, so both draw right.
- **Only differing pairs change.** Pairs that draw the same (the same value, or both zero, like B-Dry's two page
  paragraphs and its header's `0px`/`0%`) are left alone, byte for byte.
- **Builds 2026-11-09.2 and .3:**
  - .2 claimed the page within 1.02 px. That holds: the page paste has no differing pair and is within 1.02 px with
    the new renderer (`named-proto.log`).
  - .3 claimed the whole page, header, page and footer, within 2 px. That **did not hold for the footer** on the right
    reading: real Bricks drew the icon list 69 px short at every width, and only the old renderer's print order hid
    it. With this fix it holds: footer ≤ 1.09 px.
  - The fold rules themselves (8 and 9) are unaffected. Their `marginOf` (`elementor-measured.ts:10`) reads the
    physical name first, so after the fix it reads the winner too.
- **Justin's staging page today** (read-only GET, `staging/homev2.html`, 2026-11-10; the same paste as the 2026-11-09
  copy except interaction ids). It holds an older paste of this footer: rows `home__facebook__row-yhxt/-crhh/-qinp`,
  all custom CSS, one sorted rule per class (`staging/rows-css.txt`), e.g. `.home__facebook__row-crhh { … margin-block-start:
  calc(23px/2); margin-bottom: 0px; … margin-top: 0px; … padding-block-end: calc(23px/2); padding-bottom: 0px; … }`.
  - In one rule the later declaration of the two names wins: `margin-top: 0px` and `padding-bottom: 0px` (`probe3.log`,
    "one sorted rule"). So **staging's footer contact list is 69 px shorter than bdryswi.com's today.** This is read
    from the printed CSS and the probe, not measured in Chrome on staging (the brief allows curl only).
  - A re-paste with the fix is needed (Q3, AC6).
- **site-native-structure's AC14** (B-Dry's whole page within tolerance at every width) is blocked by this on main,
  and on its own head (`head-239.log`, 69 px). It is unblocked once this merges and that branch rebases:
  `src/core/site/blocks.ts` and `sides.ts` are not in its file list.

## The fix (general rule, conversion only)

**Rule:** in each capture range's full declarations, of a box side written by both its physical name and its logical
name (horizontal writing) with values that don't draw the same, only the one the site applied last stays: the name
later in the capture's listing. Values that draw the same (identical text, or both zero) are left as they are. A
state that declares a `writing-mode` other than `horizontal-tb` is left as it is. Inline sides: Q1.

- **Where:** `statesOf` in `src/core/site/blocks.ts:12-21`. It is the single place the conversion reads a captured
  element's declarations per range: its own and its pseudo and inline elements' blocks (`convert.ts:201-239`, through
  `statesOnKept`), the Elementor fold (`elementor-fold.ts:118, 189-191`), the fold rules' `marginOf`, the sliders,
  the accordion, `roleOf`. So every consumer sees one side.
  - The running state keeps the capture's own listing, so a narrower range that changes one name keeps the base's order.
  - Each range's pushed state is the resolved copy; `oneSide` returns the same object when nothing changes, so pastes
    without a differing pair are byte for byte as before.
- **New file** `src/core/site/sides.ts` (pure, about 40 lines): `PAIRS` and `oneSide(d)`.
- **Not touched:** the renderer (`test/browser/render*.ts`), the capture (`src/web/`), `controls.ts`, `classes.ts`,
  `convert.ts`, `parts.ts`, the fold files, the Figma pipeline.
- **Known limit, recorded in HANDOFF:** the capture lists a name where it was first written. A site that writes the
  earlier name again later (a reset's `margin-top: 0`, a widget's `margin-block-start`, then a stronger `margin-top`)
  is read as the logical one winning. Making the capture exact is Q2's follow-up.
- **Files moving beside this job:**
  - staging-fit-cancels (`staging-fit-cancels-stack7`) changes `blocks.ts` too, but `blocksOfStates` and new helpers
    only, never `statesOf`. Expect at most a context-only conflict at the import line; keep both.
  - site-native-structure and site-menu don't touch `blocks.ts` or `sides.ts`.
  - site-native-structure's `test/unit/site-slider-unchanged.test.ts` edit doesn't meet this job: its goldens hold no
    differing pair (unit suite equal on base and prototype).

## Acceptance criteria (all **proposed**; one named test each)

- AC1 (proposed): B-Dry's named whole-page test passes again because the footer's icon list keeps the site's spacing (footer ≤ 2 px at every width; RED on base: 69 px): test `B-Dry's whole page with the Elementor step: within 2 px at every width` (`test/web/site-elementor-page-bdry.test.ts`, named-only, env below).
- AC2 (proposed): a generic site whose reset writes sides by physical names and whose list rule spaces items by logical ones (plus a physical-wins badge, an equal pair and a phone gap) pastes within 2 px at every width with Bricks' class printing (RED on base: 72 px, 36 on phones): test `a side written by its physical and its logical name keeps the site's winner: 1:1 at every width` (`test/web/site-logical-sides.test.ts`, new fixture `test/fixtures/web/sites/logical-sides/`).
- AC3 (proposed): the rule itself: in every range only the later-listed name of a differing pair stays, physical or logical; equal or zero pairs, another writing-mode and inline sides stay byte for byte; the class's controls hold no physical side its logical custom CSS overrides (RED on base: 4 of the file's 5 tests): test `one side: a later logical name wins over a reset's physical one, in every range` (`test/unit/site-one-side.test.ts`).
- AC4 (proposed): every other paste and every Figma design is byte for byte as before: on saved real captures each part (header, page, footer; code method and Elementor step) equals base's exactly when no node under it holds a differing pair, and differs when one does; the Figma route, the committed site goldens and the corpus are unchanged: test `pastes change only where a part holds a side written by both names` (`test/unit/site-one-side-sums.test.ts`, named-only).
- AC5 (proposed): the merged jobs' checks are unchanged for pastes without the shape: `npm run test:web` and `npm run test:browser` pass by test name as on base (the new AC2 test added), including `site:check --whole` and `site:live`'s drawing: test `--whole draws the parts together and other hosts' pictures from the capture` (`test/web/site-check-cli.test.ts`).
- AC6 (proposed) (live): after Justin re-pastes B-Dry's whole home on staging /homev2/ with the merged build, `npm run site:live -- <capture> https://bdry.staging.growithgro.com/homev2/ --elementor` reports the footer contact list's rows within 2 px of the capture at the widths it reads (paste check, next free id: 3dt if still free at the merge): check `site:live footer rows on staging /homev2/` (Justin's run; the report's footer rows).

Env for the named-only tests (the builder sets these; they are paths on this PC):

```
F2B_CODE_PROOF_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/bdry-2026-10-29
F2B_CODE_PROOF_CAPTURE=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/planner/capture.json
F2B_ELEMENTOR_STANDIN=/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json
F2B_ONE_SIDE_BASE=<a git archive of 7eeca437 with node_modules linked>
F2B_ONE_SIDE_CAPTURES=<E>/site-native-structure/inputs/standin-capture-0581852c.json:<E>/bdryswi-com-home-2026-11-04-code.f2b-capture.json:<E>/site-native-structure/fixer-3/natives.f2b-capture.json:<E>/elementor-phone-fit/planner/bdry-standin.f2b-capture.json:<E>/site-slider/fixer-2/swiper8-check/capture.f2b-capture.json
```

`<E>` = `/home/justin/.hermes/plans/figma-to-bricks/evidence`. Run B-Dry tests under `systemd-run --user --scope -p
MemoryMax=8G -p MemorySwapMax=0` (export the variables first), `TMPDIR=~/.cache/fil-b/t1` (short),
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`, one Chrome job at a time.

## Tasks (test first; one commit per passing task; never bump BUILD; never commit CLAUDE.md)

### Task 0: set up

- Copy this plan to `docs/plans/2026-11-10-footer-icon-list.md` and start the ledger
  `.superpowers/sdd/2026-11-10-footer-icon-list/progress.md`.
- Run `npm run check` and `npm run corpus` and record the numbers.
- Make the base archive for AC4: `git archive 7eeca437 | tar -x -C ~/.cache/fil-b/base`, then link `node_modules`.
- Commit the plan copy and the ledger.

### Task 1: the failing tests (RED)

Write `test/unit/site-one-side.test.ts` exactly:

```ts
// AC3 (footer-icon-list): a range's state never holds one box side by both its names with different values. Of a physical
// side and its logical one in horizontal writing (margin/padding top and bottom, inset, the block borders, the sizes),
// only the name the capture lists later stays (the one the site's cascade wrote later), in every range; both drawing
// the same (the same value, or both zero), a state declaring another writing-mode and the inline sides (left and right
// depend on the direction) are left as they are, byte for byte. The class's split follows: no physical control beside
// its logical custom CSS.
import { test } from "node:test";
import assert from "node:assert/strict";
import { blocksOf, statesOf } from "../../src/core/site/blocks.ts";
import { controlsFor } from "../../src/core/site/controls.ts";
import type { CodeDecls } from "../../src/core/snapshot/web.ts";

const R = ["1025-up", "768-1024", "320-767"];

test("one side: a later logical name wins over a reset's physical one, in every range", () => {
  const st = statesOf({
    "1025-up": { display: "flex", "margin-top": "0px", "padding-bottom": "0px", "margin-block-start": "calc(24px/2)", "padding-block-end": "calc(24px/2)" },
    "768-1024": {},
    "320-767": { "margin-block-start": "calc(12px/2)" },
  }, R);
  assert.deepEqual(st, [
    { display: "flex", "margin-block-start": "calc(24px/2)", "padding-block-end": "calc(24px/2)" },
    { display: "flex", "margin-block-start": "calc(24px/2)", "padding-block-end": "calc(24px/2)" },
    { display: "flex", "margin-block-start": "calc(12px/2)", "padding-block-end": "calc(24px/2)" },
  ]);
});

test("one side: a later physical name wins over an earlier logical one", () => {
  assert.deepEqual(statesOf({ "1025-up": { "margin-block-start": "30px", "margin-top": "6px" } }, ["1025-up"]), [{ "margin-top": "6px" }]);
});

test("one side: insets, block borders and sizes too", () => {
  const st = statesOf({ "1025-up": { top: "0px", "inset-block-start": "10px", "border-top-width": "0px", "border-block-start-width": "1px", height: "auto", "block-size": "40px", width: "100%", "inline-size": "50%" } }, ["1025-up"]);
  assert.deepEqual(st, [{ "inset-block-start": "10px", "border-block-start-width": "1px", "block-size": "40px", "inline-size": "50%" }]);
});

test("one side: pairs that draw the same, another writing-mode and the inline sides are left as they are", () => {
  const kept: CodeDecls[] = [
    { "margin-bottom": "0px", "margin-block-end": "0px" },
    { "margin-top": "0px", "margin-block-start": "0%" },
    { "writing-mode": "vertical-rl", "margin-top": "0px", "margin-block-start": "8px" },
    { "padding-left": "0px", "padding-inline-start": "8px", "margin-right": "0px", "margin-inline-end": "4px" },
  ];
  for (const d of kept) assert.equal(JSON.stringify(statesOf({ "1025-up": d }, ["1025-up"])[0]), JSON.stringify(d));
});

test("one side: the class's controls hold no physical side its logical custom CSS overrides", () => {
  const split = controlsFor(blocksOf({ "1025-up": { "margin-top": "0px", "margin-bottom": "0px", "padding-bottom": "0px", "margin-block-start": "calc(24px/2)", "padding-block-end": "calc(24px/2)" } }, ["1025-up"]), "div");
  assert.deepEqual(split.settings, { _margin: { bottom: "0px" } });
  assert.deepEqual(split.custom, [{ max: null, decls: { "margin-block-start": "calc(24px/2)", "padding-block-end": "calc(24px/2)" } }]);
});
```

Write the fixture `test/fixtures/web/sites/logical-sides/index.html` exactly:

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Logical sides</title>
<link rel="stylesheet" href="/style.css">
</head>
<body>
<!-- footer-icon-list: a site whose reset writes its boxes' sides by their physical names (margin: 0; padding: 0) and
     whose later rules write some of the same sides by their logical names, as page builders' icon lists do
     (margin-block-start between items, padding-block-end under each): the logical one is applied last and wins. One
     badge the other way round (its logical margin first, a stronger physical one later wins), one pair that draws the
     same either way (a reset 0 and a logical 0), and phones with a smaller list gap. Not a copy of any site. -->
<section class="contact" id="contact">
  <h2 class="contact__title">Reach the team</h2>
  <ul class="icons">
    <li class="icons__item"><span class="icons__dot"></span><span class="icons__text">Call the office on weekdays</span></li>
    <li class="icons__item"><span class="icons__dot"></span><span class="icons__text">Write to the team</span></li>
    <li class="icons__item"><span class="icons__dot"></span><span class="icons__text">Visit the yard by the river</span></li>
    <li class="icons__item"><span class="icons__dot"></span><span class="icons__text">Read the news</span></li>
  </ul>
  <div class="card"><em class="badge">New</em><p class="note">Open from eight until five.</p></div>
</section>
</body>
</html>
```

and `test/fixtures/web/sites/logical-sides/style.css` exactly:

```css
@font-face { font-family: "Site Sans"; src: url(/machine-font.ttf); font-weight: 400; }
/* the reset: every side by its physical name */
html, body, section, h2, ul, li, span, div, p { margin: 0; padding: 0; border: 0; }
* { box-sizing: border-box; }
body { font-family: "Site Sans", sans-serif; color: #1d2433; line-height: 1.5; font-size: 18px; }
.contact { max-width: 960px; margin-inline: auto; padding: 40px 20px; }
.contact__title { font-size: 28px; line-height: 1.2; padding-bottom: 16px; }
/* the list: its spacing by logical names, later than the reset (a page builder's icon list) */
.icons { list-style: none; --gap: 24px; }
.icons .icons__item { display: flex; align-items: center; }
.icons .icons__item:not(:first-child) { margin-block-start: calc(var(--gap) / 2); }
.icons .icons__item:not(:last-child) { padding-block-end: calc(var(--gap) / 2); }
.icons__dot { flex: 0 0 14px; height: 14px; border-radius: 50%; background: #2a6f97; margin-right: 10px; }
/* the badge: its logical margin first, a stronger physical one later wins (no reset on em) */
.badge { display: block; font-style: normal; font-size: 14px; margin-block-start: 30px; }
.card .badge { margin-top: 6px; }
/* a pair that draws the same either way: the reset's 0 and a logical 0 */
.note { margin-block-end: 0; padding-top: 8px; }
.card { margin-top: 24px; padding: 16px; background: #eef3f7; }
@media (max-width: 767px) {
  .icons { --gap: 12px; }
  .contact__title { font-size: 22px; }
}
```

Write `test/web/site-logical-sides.test.ts` exactly:

```ts
// AC2 (footer-icon-list): a box side the site writes by two names keeps the site's winner. The fixture
// (test/fixtures/web/sites/logical-sides) is generic, not a copy of any site: a reset writes every side by its physical
// name (margin: 0; padding: 0) and a later list rule spaces the items by their logical names (margin-block-start,
// padding-block-end), as page builders' icon lists do; a badge has the other order (a stronger physical margin wins); a
// note has a pair that draws the same either way; phones have a smaller list gap. Pasted by the code method and drawn as
// published Bricks prints it (a class's controls under `.<class>.brxe-<element>`, its custom CSS under `.<class>`:
// renderSitePaste, Bricks 2.4.2), the section is within 2 px of the site at every width the capture read. Before the
// fix each item's physical 0 (a control) beat its logical spacing (custom CSS): the list was 72 px short from 768 up
// and 36 px on phones. The "# " lines are diagnostics: the per-width worst deltas.
import { after, before, test } from "node:test";
import assert from "node:assert/strict";
import type { Snapshot } from "../../src/core/snapshot/schema.ts";
import { siteToBricks, type SiteResult } from "../../src/core/site/convert.ts";
import { pageRanges, skipWidths } from "../../src/core/site/ranges.ts";
import { pathOf } from "../../src/web/read/page-reader.ts";
import { hasChrome, launchChrome, type Browser } from "../browser/chrome.ts";
import { captureFixture } from "../fixtures/web/capture.ts";
import { captureBoxes, compareToCapture, fontsHead, pastePictures, readSection, renderSitePaste, scriptedAt, settle } from "./lib/site-check.ts";

const skip = hasChrome() ? false : "Google Chrome not installed (set CHROME_PATH)";
const TOLERANCE = 2;
let browser: Browser;
let cap: Snapshot;
let root = "";
const items: string[] = [];
let paste: SiteResult;
before(async () => {
  if (skip) return;
  browser = await launchChrome();
  const { fx, snapshot } = await captureFixture("logical-sides", { browser, shots: false });
  try {
    cap = snapshot;
    const page = await browser.newPage();
    try {
      await page.goto(fx.site + "/");
      root = await page.evaluate<string>(`(() => { const pathOf = ${pathOf.toString()}; return pathOf(document.getElementById("contact")); })()`);
      items.push(...await page.evaluate<string[]>(`(() => { const pathOf = ${pathOf.toString()}; return [...document.querySelectorAll(".icons__item")].map((e) => pathOf(e)); })()`));
    } finally { await page.close(); }
  } finally { await fx.close(); }
  paste = siteToBricks(cap, { section: { path: root } });
});
after(async () => {
  if (browser) await browser.close();
});

test("a side written by its physical and its logical name keeps the site's winner: 1:1 at every width", { skip }, async () => {
  // the shape is in the capture: an item's widest range holds both names of a side, with different values
  const base = cap.web!.code!.nodes[items[1]].decls[cap.web!.code!.ranges[0]] ?? {};
  assert.ok(base["margin-top"] !== undefined && base["margin-block-start"] !== undefined && base["margin-top"] !== base["margin-block-start"], JSON.stringify(base));
  const pr = pageRanges(cap);
  const skipped = skipWidths(cap.web!.ranges, pr);
  const page = await browser.newPage();
  const misses: string[] = [];
  try {
    await page.setContent(renderSitePaste(pastePictures(paste.payload, cap), await fontsHead(cap)));
    const ids = Object.keys(paste.sources);
    const rootId = ids.find((k) => paste.sources[k] === root)!;
    const list = ids.map((id): [string, { id: string }] => [paste.sources[id], { id }]);
    for (const w of cap.web!.widths.filter((x) => !skipped.includes(x))) {
      await page.setViewport(w, cap.web!.height);
      await settle(page);
      const got = await readSection(page, { id: rootId }, list);
      const want = captureBoxes(cap, root, Object.values(paste.sources), w);
      for (const k of Object.keys(want)) if (want[k] !== undefined && scriptedAt(cap, k, w)) want[k] = undefined;
      const c = compareToCapture(want, got.boxes);
      console.log(`# ${w}: ${Math.round(c.worst.delta * 100) / 100} (${c.worst.what})`);
      if (c.worst.delta > TOLERANCE) misses.push(`${w}: ${Math.round(c.worst.delta * 100) / 100} px (${c.worst.what})`);
    }
  } finally { await page.close(); }
  assert.deepEqual(misses, []);
});
```

- **RED:** `node --test test/unit/site-one-side.test.ts` fails 4 of 5; test 4 (the guard) passes on base. Then
  `node --test test/web/site-logical-sides.test.ts`, with `CHROME_PATH` and a short `TMPDIR`, fails with `768: 72 px
  (body/section:0/ul:0)` … `320: 36 px (body/section:0/ul:0)`. Both were proved on a base archive:
  `unit-one-side-main.log`, `fixture-main.log`.
- Record both in the ledger. Don't commit red tests alone: Task 2 commits them with the fix.

### Task 2: the rule (GREEN)

New file `src/core/site/sides.ts` exactly:

```ts
// One side of a box written by two names (footer-icon-list): a site's cascade can set a box side by its physical name
// (`margin-top`, a reset's `margin: 0`) and by its logical one (`margin-block-start`, a page builder's list spacing);
// in the browser the declaration applied last wins and the other has no effect. The capture keeps both (a map by name),
// in the order each name was first written. A paste must never hold both: Bricks prints a class's physical side as a
// control (`.<class>.brxe-<element>`, 0,2,0) and its logical one in custom CSS (`.<class>`, 0,1,0), and the one rule
// a class's custom CSS is written as sorts the names (`margin-block-start` before `margin-top`), so the physical one
// always wins there, whatever the site did. So of each such pair in one range's state only the site's winner is kept:
// the name later in the state (the later written); when both draw the same (the same value, or both zero) both stay as
// they are (the paste draws right, byte for byte as before). Block axis and sizes only, in horizontal writing (a state
// declaring another writing-mode is left as it is): the inline sides' physical names depend on the direction, which a
// state can't see. A site that writes the earlier name again later is read as the later-listed one winning (the
// capture lists a name where it was first written). Pure.
import type { CodeDecls } from "../snapshot/web.ts";

const ZERO = /^[+-]?0*\.?0+(px|%|em|rem|vw|vh)?$/;
// [physical, logical] in horizontal-tb, whatever the direction
export const PAIRS: ReadonlyArray<readonly [string, string]> = [
  ...["margin", "padding"].flatMap((p) => [[`${p}-top`, `${p}-block-start`], [`${p}-bottom`, `${p}-block-end`]] as const),
  ["top", "inset-block-start"], ["bottom", "inset-block-end"],
  ...["width", "style", "color"].flatMap((x) => [[`border-top-${x}`, `border-block-start-${x}`], [`border-bottom-${x}`, `border-block-end-${x}`]] as const),
  ["width", "inline-size"], ["height", "block-size"], ["min-width", "min-inline-size"], ["min-height", "min-block-size"],
  ["max-width", "max-inline-size"], ["max-height", "max-block-size"],
];

export function oneSide(d: CodeDecls): CodeDecls {
  const wm = d["writing-mode"];
  if (wm !== undefined && wm !== "horizontal-tb") return d;
  let out: CodeDecls | null = null;
  const keys = Object.keys(d);
  for (const [physical, logical] of PAIRS) {
    if (!(physical in d) || !(logical in d)) continue;
    const a = d[physical].trim(), b = d[logical].trim();
    // both draw the same (the same value, or both zero): the paste draws right as it is, left as before
    if (a === b || (ZERO.test(a) && ZERO.test(b))) continue;
    const loser = keys.indexOf(physical) > keys.indexOf(logical) ? logical : physical;
    out ??= { ...d };
    delete out[loser];
  }
  return out ?? d;
}
```

In `src/core/site/blocks.ts`:

- Add `import { oneSide } from "./sides.ts";` after the `import type { CodeByRange, CodeDecls }` line.
- In `statesOf`, replace `    out.push(cur);` with `    out.push(oneSide(cur));`. The running `cur` stays as
  captured, so the next range copies the unresolved state.
- Extend the comment above `statesOf` with: "each range's state holds one name per box side (sides.ts oneSide:
  footer-icon-list)".

Then:

- **GREEN:** both Task 1 commands pass (5/5; every width 0 px in `fixture-proto.log`).
- Run `npm run check`. On the prototype the unit tallies were 3462 pass and 0 fail on base and head
  (`unit-*.tap`); compare by test name.
- **Mutation** (`mutation-testing-discipline`, under `systemd-run … MemoryMax=4G`); each must fail at least one named
  test, then restore:
  - (m1) `out.push(cur)` back: AC2 and AC3 fail.
  - (m2) the loser always the physical name: AC3's test 2 fails.
  - (m3) no "draw the same" skip: AC3's test 4 fails, and AC4 fails on the B-Dry stand-in page part.
  - (m4) the writing-mode guard removed: AC3's test 4 fails.
- Commit the tests, the fixture and the fix together.

### Task 3: the byte receipt (AC4)

Write `test/unit/site-one-side-sums.test.ts` exactly:

```ts
// AC4 (footer-icon-list), named-only: on saved real captures, a paste changes only where its part holds a box side
// written by both names with different values. F2B_ONE_SIDE_BASE: a `git archive` of the base commit (its converter is
// loaded beside this tree's); F2B_ONE_SIDE_CAPTURES: capture files, joined by ":". Every part (header, page, footer) of
// every capture, by the code method and with the Elementor step (rich words), converts byte for byte as the base's
// unless a code node under the part's root holds such a pair in some range (then it must differ: the fix reached it).
// The "# " lines name each part's verdict.
import { test } from "node:test";
import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { siteParts } from "../../src/core/site/parts.ts";
import { PAIRS } from "../../src/core/site/sides.ts";
import type { Snapshot } from "../../src/core/snapshot/schema.ts";
import type { CodeDecls } from "../../src/core/snapshot/web.ts";

const BASE = process.env.F2B_ONE_SIDE_BASE, CAPTURES = (process.env.F2B_ONE_SIDE_CAPTURES ?? "").split(":").filter(Boolean);
const skip = !BASE || !CAPTURES.length ? "named-only: set F2B_ONE_SIDE_BASE and F2B_ONE_SIDE_CAPTURES" : false;
const sha = (x: unknown) => createHash("sha256").update(JSON.stringify(x)).digest("hex");
const ZERO = /^[+-]?0*\.?0+(px|%|em|rem|vw|vh)?$/;
// a range's full declarations as captured (no side resolved): the widest range's, then each narrower range's changes
function raw(byRange: Record<string, Record<string, string | null>>, ranges: string[]): CodeDecls[] {
  const out: CodeDecls[] = [];
  let cur: CodeDecls = {};
  for (const r of ranges) { cur = { ...cur }; for (const [k, v] of Object.entries(byRange[r] ?? {})) { if (v === null) delete cur[k]; else cur[k] = v; } out.push(cur); }
  return out;
}
const holdsPair = (d: CodeDecls): boolean => (d["writing-mode"] === undefined || d["writing-mode"] === "horizontal-tb")
  && PAIRS.some(([p, l]) => p in d && l in d && d[p].trim() !== d[l].trim() && !(ZERO.test(d[p].trim()) && ZERO.test(d[l].trim())));

test("pastes change only where a part holds a side written by both names", { skip }, async () => {
  const base = await import(`${BASE}/src/core/site/parts.ts`);
  const misses: string[] = [];
  for (const file of CAPTURES) {
    const cap = JSON.parse(readFileSync(file, "utf8")) as Snapshot;
    const code = cap.web!.code!;
    for (const elementor of [false, true]) {
      const a = base.siteParts(cap, { text: "rich", elementor }), b = siteParts(cap, { text: "rich", elementor });
      for (const part of ["header", "page", "footer"] as const) {
        if (!a[part] && !b[part]) continue;
        const root = (b[part] ?? a[part]).root as string;
        const holds = Object.entries(code.nodes).some(([p, n]) => (p === root || p.startsWith(root + "/")) && [n.decls, n.pseudo?.before, n.pseudo?.after, ...Object.values(n.inline ?? {})].some((by) => by && raw(by, code.ranges).some(holdsPair)));
        const same = sha(a[part]) === sha(b[part]);
        console.log(`# ${file.split("/").pop()} elementor=${elementor} ${part}: ${same ? "same" : "differs"}, ${holds ? "holds a pair" : "no pair"}`);
        if (same === holds) misses.push(`${file.split("/").pop()} elementor=${elementor} ${part}: ${same ? "unchanged though it holds a pair" : "changed with no pair"}`);
      }
    }
  }
  assert.deepEqual(misses, []);
});
```

- Run it with the env above. It is a guard, not a RED test: it imports `sides.ts`. The prototype gave 26 verdicts,
  only the B-Dry footers changing (`sums-proto.log`); (m3) must make it fail.
- Confirm the Figma side is untouched: `npm run corpus` equals Task 0's numbers. `src/core/site/` isn't on the Figma
  pipeline, and `test/unit/plugin-convert.test.ts` stays green.
- Commit.

### Task 4: B-Dry's receipts (AC1 and the brief's checks)

- The named test for AC1, `node --test test/web/site-elementor-page-bdry.test.ts` with the env above, passes 2/2. Prototype:
  `named-proto.log`; base: `named-main.log`, 69 px.
- `npm run site:check -- <stand-in> --part footer --elementor` with the default 2.4.2 and with `--bricks 2.3.9`:
  both OK, worst ≤ 0.11 px.
- `npm run site:check -- <stand-in> --whole --elementor`: the footer within 2 px. The page part's pre-existing
  64 / 46.5 / 6.93 px in `--whole` is the same as base's (`main-whole.log`); name it in the ledger and don't fix it here.
- Before/after pictures (`site:check` writes shots at 1440/1024/768/390 without `--no-shots`): footer before (base
  archive) and after, copied to `~/.hermes/plans/figma-to-bricks/shots/footer-icon-list/`, never committed.
- Ledger only; commit the ledger.

### Task 5: gates

- `npm run check`, `npm run test:browser`, and `npm run test:web` (the web suite runs only with CHROME_PATH; it reads
  `test/browser/render*.ts`): pass by test name as base plus the new AC2 test. AC5's named test is in it.
- `npm run corpus` unchanged. Record runtimes and tallies in the ledger.
- A SIGTERM / 137 / "Killed" is checked against earlyoom first: `journalctl -u earlyoom --since "-30 min" -o short-iso
  | grep sending`.

### Task 6: Docs & records

- Plan copied (Task 0). The finisher moves the ledger to `docs/plans/2026-11-10-footer-icon-list-ledger.md` before
  the final premerge commit and rebase.
- `docs/HANDOFF.md`: a new section above the top `## ` heading, "A side written by two names keeps the site's winner
  (footer-icon-list, website importer; build set at the merge; paste check <id> owed)". It holds:
  - the plain-words fix;
  - the 69 px proof;
  - that Builds 2026-11-09.3's footer claim was a renderer artefact on real Bricks (the old print order);
  - the known limit (a name written again later; inline sides: Q1);
  - the found-elsewhere `--whole` page item;
  - the paste-check entry at the top of "End-of-run check list" (next free id, `3dt` if still free; check main and
    every branch's HANDOFF plus the plans as the project skill says).
- BUILD bumped at the merge only (finisher).
- CLAUDE.md Status after the merge: the build line and one feature line with its paste check. A new standing rule
  under "Working in this repo": "**A captured box side written by both its physical and its logical name keeps only
  the site's winner** (`site/sides.ts`, in `statesOf`): Bricks prints a class's physical side as a control at
  `.<class>.brxe-<element>` (0,2,0), which beats the logical one in its custom CSS." If CLAUDE.md can't be written,
  the finisher leaves it in `~/.hermes/plans/figma-to-bricks/footer-icon-list-claude-md-pending.md`.

## Found elsewhere (not this job)

- `site:check --whole --elementor` on the B-Dry stand-in draws the **page** part 64 px off (from 768 to 2560, at 1440
  too), 46.5 px on phones and 6.93 px at 1196–1964. The same happens on base and on the fix; the per-part checks put the
  page within 1.02 px. So the page drawn beside the header and footer differs from the page drawn alone: a candidate
  for its own job (`main-whole/report.json`, element `…/div:0/div:0/div:0/div:1` of the page's first section).
- Follow-ups:
  - Q1 (inline sides).
  - Q2 (capture-side exactness: `src/web/read/code.ts` keeps only the cascade's winner).
  - Hover/state looks (`code-states.ts` `CodeStateLook.decls`) can mix names the same way and don't pass through
    `statesOf`.

## Mini or Full

**Mini.**

- A clear bug with a proved root cause and a prototype that passes every receipt.
- One new pure source file plus two lines in `blocks.ts`.
- No product or design decision: Q1–Q3 have safe ⭐ defaults.
- No auth, data or contract area.
- No overlap with the running jobs' named functions: `statesOf` is untouched by staging-fit-cancels, and `blocks.ts`
  and `sides.ts` are not in site-native-structure's or site-menu's lists.
