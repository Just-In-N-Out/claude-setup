# control-weight: an element its parent reads as a word at some widths carries those widths in its own class (website importer, bug)

Planner: Opus 5.5 high, 2026-11-10. Base: `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4) **plus
staging-fit-cancels' head** (`staging-fit-cancels-stack7`, `ce5b38ac` when planned; Q3). Recommendation: **Mini** (reason
at the end). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/control-weight/planner/` (`NOTES.md` lists every
receipt; `logs/`; the probe scripts `contest.ts`, `dual.ts`, `dump.ts`, `cap-fixture.ts`; the prototype's files
`inline-own.ts`, `convert.diff`, `site-inline-own.ts`, `site-inline-own.test.ts`, `site-inline-own-bytes.test.ts`).
The builder copies this file to `docs/plans/2026-11-10-control-weight.md` as Task 0.

## Questions (⭐ = recommended; under the repo's standing auto-go the builder takes ⭐ unless Justin answers otherwise)

- **Q1. What Justin sees in Bricks for such an element (a small design decision, flagged for Justin).** The honest fix
  puts the element's own values for those widths in its own class. Bricks' tiers can't hold every one of them (a link
  that is `inline` on tablets: the importer writes no Display control for `inline`, a value not proved in Bricks'
  samples, and a range like 768–1024 isn't one of Bricks' tiers), so those properties go to the class's Custom CSS by the rule every other site
  element already follows (web-code-proof Q7 A: a control only where every value is plain and sits on Bricks' own
  breakpoints).
  - ⭐ **A.** The element's own class carries every width. Trade-off in plain words: **the page is right at every
    width; for these few elements a property like Display shows in the class's Custom CSS instead of its control.**
    Everything else in its panel stays as it is (its background, padding, colour, size controls).
  - B. Weigh the parent's copied rule up (`.wrapper.wrapper > :nth-child(1)`, 0,3,0). The Display control stays
    visible, but on tablets it does nothing (Justin's edit there is silently overridden), and values the site doesn't
    set on the word there (padding, a fixed display) still leak in from the control: measured on the 2026-11-09 B-Dry
    capture, where the header call button's controls (`_padding`, `_display: inline-block`) apply at 768–991 where
    the capture's reading of it there sets neither.
  - C. Leave it a known limit (the todo test stays).
- **Q2. A parent hidden at those widths** (a menu a phone hides: its links are read as words of the hidden menu).
  - ⭐ **A.** Leave those as they are: nothing is drawn there, and five fixture pastes (code-page, fixedbars,
    many-ranges, tiers, tiers-split) stay byte for byte.
  - B. Move them too (cleaner classes; those five pastes change bytes with nothing visible).
- **Q3. Build order.** This job's fixture (`test/fixtures/web/sites/range-cancels/`), its `todo` test, and the helpers
  the tests use (`test/fixtures/site-css-text.ts` `declsIn`, `test/fixtures/site-drops.ts`) exist only on
  staging-fit-cancels' branch.
  - ⭐ **A.** Build on staging-fit-cancels' accepted head now (`git worktree`/`claude -w` from that branch), rebase onto
    `main` once staging-fit-cancels merges (memory "keep agents busy"). footer-icon-list in either order (no shared
    file; below).
  - B. Wait until staging-fit-cancels has merged, then start from `main`.
- **Q4. B-Dry.** The fixer's "the hero buttons' own case at 768–1024" is **refuted** (below): no saved B-Dry capture
  that main accepts holds the shape. ⭐ **A.** No B-Dry AC and no live AC; the 3do re-paste is judged as already planned.

## Playback (plain words)

1. On some sites a link is its own painted button at most widths but, at one width range, a plain word inside its
   wrapper's line (the site's CSS makes it `display: inline` there). The capture then reads the link two ways: as its
   own element where it is a box, and as "the wrapper's first inline element" where it is a word.
2. The paste writes those two readings into **two different classes**: the link's own class (as Bricks controls where
   it can), and the wrapper's class as `.wrapper > :nth-child(1) { display: inline; … }` for the word range.
3. Real Bricks prints a class's controls as `.link.brxe-div` (weight 0,2,0) **after** the wrapper's class. The wrapper's
   copied rule has the same weight (0,2,0), so the link's own `display: inline-block` control wins inside the word
   range, where on the site the link is `inline`. On the generic fixture the hero is **28 px taller at 768, 880 and
   991** (the link's line 6 px taller, the wrapper 28).
4. The fix: one element, one class. The link's own class carries its word-range values too; the wrapper writes no rule
   for it. Nothing else changes.

## Root cause (proved)

- **The capture reads one element in two places.** At a range where a box's children are only inline elements with
  words, the reader reads the box as words and its children as inline elements (`src/web/read/code-facts.ts:41`
  `textual`, `:62` `words`, each inline element's declared values read like an element's: `src/web/read/code.ts:107-116`).
  The child is then not read as an element there: `shown` lacks that range and its declarations are "not read, kept as
  the wider one" (`src/web/code.ts:11`, `encode`). The node keeps the kind and children of its widest reading
  (`src/web/code.ts:47`), and the inline readings ride on the parent (`src/web/code.ts:64-65`).
  - Fixture receipt (`~/.cache/cw-p/probe/range-cancels-cap.json`, captured on this base): the wrapper
    `body/main:0/section:0/div:0` has `inline["0"]["768-991"] = { display: "inline", padding…, background-color:
    "#0b6e4f", … }`; the link `…/div:0/a:0` has `shown: ["992-up", "320-767"]` and `decls["768-991"] = {}` (its
    `display: inline-block` carried over).
- **The paste writes the two readings in two classes.** `src/core/site/convert.ts:202` builds the link's class from its
  own `decls` only; `:229` writes the wrapper's `inline` readings into the wrapper's class, printed by
  `src/core/site/classes.ts:137` under `inlineSel` (`:106`), `.wrapper > :nth-child(1)` (0,2,0), inside the range's
  media block. `src/core/site/controls.ts:101-107` (stack 7) makes the link's `display: inline-block` (one value, every
  range) a control.
- **Real Bricks lets the control win.** Bricks prints a global class's controls as `.<class>.brxe-<element>` (0,2,0),
  then its custom CSS as written, then its tier controls (`reference/bricks/README.md` "Class selectors", read on B-Dry
  staging: all 343 control blocks; `test/browser/render-order.ts:30-47`), and prints the classes in the paste's order
  (staging's saved `inline-2.css` against the pasted `page.json`: 253 of 254 classes found, in the paste's order but for 2
  neighbours: `logs/` and `NOTES.md`). A parent comes before its child in document order, so its class prints first and
  the child's control, equal in weight and later, wins.
  - Dump (`dump.ts` on the fixture capture, this base): `.home__a-button__box` writes `@media (max-width: 991px) {
    .home__a-button__box > :nth-child(1) { … display: inline; … } }`; `.home__a-button__text` has `_display:
    "inline-block"`. The probe (`contest.ts`: every rule of one class's custom CSS that reaches another pasted
    element, at every captured width, compared with the value it writes) finds exactly one lost property: `display` at
    991, 880, 768, the link's box 6 px off, the page's root 28 px (`logs/contest-main-fx-range-cancels-2.4.2.log` and
    `-2.3.9.log`; the same on staging-fit-cancels' head).
- **The element-id CSS and the tier controls don't change the picture.** The code route writes no element-level style
  setting (every element of B-Dry's stand-in paste carries only `_cssGlobalClasses`, `tag`, `text`, `customTag`, `link`,
  `image`, `altText`, `code`, `executeCode`; the Elementor route adds `_hidden` on 10 and one slider's options:
  `elkeys.ts`), so `#brxe-<id>` CSS plays no part. Tier controls print after the class's custom CSS too, so a tier
  control would win the same way.

## How wide is it (measured)

- **Why it is narrow:** the capture resolves the cascade per element before the paste (`src/web/read/code.ts`
  `cascade`: matched rules in cascade order, `!important` winning, then only the winning value per property is kept;
  no selector or weight is kept). So a site rule's id, compound, state or `!important` weight never reaches the paste:
  its winning value lands in the element's own class. The only places the paste itself writes a rule of one class that
  reaches **another** pasted element are: (1) a parent's inline-element rule (`inlineSel`), (2) a look an ancestor's
  state sets (`withStates`: `.trigger:hover .child`, 0,3,0, and `looksOf`'s `keep` already keeps such properties out of
  the child's controls), (3) a live slot's served boxes (`inside`: inside a Code element, no controls), (4) an accordion's
  open look (`.acc > .brx-open …`, 0,3,0). Only (1) meets a control at equal weight, and only when the inline element
  is also a pasted element of its own: **the shape this job fixes**. Its sibling inside one class, a box side written
  by a physical and a logical name, is footer-icon-list's (planned, not re-planned here).
- **Counts** (`dual.ts`: a box reading an inline element at a range where its element child isn't shown; `contest.ts`:
  rules that lose, at every captured width, Bricks 2.4.2 order unless named):

  | Capture | Elements with the shape | Lost properties (plain / --elementor) | What a person sees |
  |---|---|---|---|
  | range-cancels fixture (staging-fit-cancels) | 1 (the link) | 1 / 1: `display` at 991, 880, 768 (plain with 2.3.9 and 2.4.2, `--elementor` with 2.4.2) | the link a 6 px taller block, the hero 28 px taller |
  | B-Dry stand-in `standin-capture-0581852c.json` (12 ranges, 38 widths) | 0 | 0 / 0 | nothing |
  | `bdryswi-com-home-2026-11-04-code` (version 1, 16 ranges) | 0 | 0 / 0 | nothing |
  | B-Dry 2026-11-09 capture (`/home/justin/f2b-test/`, refused by main since staging-fit-capture: its 768–991 read without styles) | 18, all at exactly the 4 styleless ranges (the header call button, the hero and page buttons) | 0 / 0 | nothing declared lost; the buttons' controls leak padding and `inline-block` there |
  | letsgro, darksalmon | no saved capture holds `web.code` (all 9 on disk are from 2026-11-03, before the code reader; the code route refuses them) | n/a | n/a |
  | 45 other test fixture sites, captured on this base | 15 in 5 fixtures (code-page 4, fixedbars 3, many-ranges 3, tiers 3, tiers-split 3): a menu's links read as words of the menu **where a phone hides the menu** | 0 / 0 (2.3.9 and 2.4.2) | nothing (the menu isn't drawn there) |

- **B-Dry's hero buttons: refuted.** In every B-Dry capture main accepts, no element has the shape. The 768–1024 "hero
  buttons' own case" exists only in the 2026-11-09 capture whose tablet ranges loaded without the site's styles
  (staging-fit R1): there the buttons were words of their wrapper only because the page was unstyled, and even there
  no copied rule loses a declared value. A re-capture (3do) reads the tablets with styles, like the stand-in (0).
- **So the shape is real but rare today:** one generic fixture; on real sites, a link or label that a breakpoint turns
  into a word of its wrapper's line (`display: inline` on a button at one width range, or a flex row turned `display:
  block` so its items become words). The fix is small and general, and touches no paste without the shape.

## The fix, candidates weighed

| Candidate | Exact? | Bytes of pastes without the shape | What Justin sees for the element | When he edits it |
|---|---|---|---|---|
| ⭐ **One element, one class** (`src/core/site/inline-own.ts`): the parent's inline readings of a pasted child move onto the child's own declarations at those ranges; the parent writes no rule for it; `controlsFor` then decides controls as for any element | yes: the child's class holds the site's value at every range, nothing else reaches it | none change (the function returns nothing; prototype: every saved capture byte for byte) | controls for properties whose values Bricks' tiers hold (background, padding, colour, font size in the fixture); the rest (here `display`) in its Custom CSS | a control edit applies everywhere it shows; a Custom CSS edit is as written |
| Weigh the copied rule up (`.p.p > :nth-child(k)`, or `!important`) | no: values the site doesn't declare on the word there still leak in from the control | none, if limited to the shape | the control still shows `inline-block`, but the page shows `inline` on tablets | an edit to the control silently does nothing on tablets |
| Keep a property out of controls where "another rule beats the element's own class rule" (by the capture's matched rules) | can't be built: the capture keeps no selector or weight (`read/code.ts` keeps only the cascade's winning value) | — | — | — |
| Print the contested range as a bounded run on the element itself | that is the ⭐ row, limited to the contested properties; moving the whole reading is simpler and also stops leaks | — | — | — |

The ⭐ rule, exactly (all conditions must hold, else the paste is as before):
1. The parent is a pasted site element of kind `box` (not a Code or Rich Text element) with `inline` readings.
2. Its pasted site children (spaces it draws between them are words, never counted by the reader) are each its own
   child (none lifted from below: site-native-structure's `lift`), and at every range where it reads any inline
   element, exactly the first steps `0 … n-1` read something: the capture's inline elements are the paste's children
   one for one (a child the reader skipped there, a hidden one, would shift the count).
3. For a first step `i` whose child has its own class: every range where the parent reads it is a range where the
   **parent is shown** (Q2 A) and **the child isn't**. Then the key `"i"` replaces the child's declarations at those
   ranges, and `"i/rest"` replaces its words' inline element `"rest"` there; those keys leave the parent's rules.

## Acceptance criteria (proposed)

- AC1 (proposed): Given the generic fixture `range-cancels` (a link that is a word in its wrapper's line at 768–991 and its own painted button elsewhere), when it is captured and pasted (the whole page and the hero alone, Rich Text and Basic Text) and drawn as Bricks 2.3.9 and 2.4.2 print it, then inside 768–991 the link is `inline` with the site's look and every listed element's look equals the site's, and outside it the painted button is as before, and every box and word is within 2 px of the site at every width read. Test: `test/web/site-range-cancels.test.ts` "inside 768–991 the link is a word in its line, as on the site" (no longer `todo`), with "a narrower range never reverts another rule" still passing.
- AC2 (proposed): Given a hand-made capture whose wrapper reads its link as an inline element on tablets (768–1024) and the link as its own element elsewhere (also with a space drawn before the link), when the section is pasted (Rich and Basic Text), then the wrapper's class writes no `> :nth-child` rule, the link's own class writes `display` inline-block / inline from 1024 down / inline-block from 767 down, writes no Display control, and keeps its background control. Test: `test/unit/site-inline-own.test.ts` "an element its parent reads inline at some widths carries those widths in its own class, and the parent writes no rule for it"
- AC3 (proposed): Given the same capture with a child before the link hidden on tablets (the reader skips it, so the count can't prove which pasted child is which), or with the wrapper itself hidden on tablets, when pasted, then the wrapper keeps its `> :nth-child(1)` rule and the link's class is as before. Test: `test/unit/site-inline-own.test.ts` "where the paste's children can't be proved the capture's inline elements, or the parent is hidden there, the parent's rule stays as before"
- AC4 (proposed): Given every saved real capture (B-Dry's stand-in `standin-capture-0581852c.json`, `bdryswi-com-home-2026-11-04-code.f2b-capture.json`) and every test fixture site's capture except `range-cancels`, each holding no element of the shape, when the whole page is pasted (code and `--elementor` routes, both picture modes, both text modes), then every paste is byte for byte the base tree's, so every merged job's check that reads those pastes (site-elementor-page-bdry, site-faq, site-slider, site-reviews, staging-fit-renderer's) reads the same paste. Test: `test/unit/site-inline-own-bytes.test.ts` "a capture holding no element its parent reads inline pastes byte for byte as the base tree's" (named only: `F2B_BASE_TREE`, `F2B_INLINE_OWN_CAPTURES`)
- AC5 (proposed): Given staging-fit-cancels' hand-made captures and its golden of main's pastes, when the unit suite runs, then every class without a dropped declaration still prints byte for byte as there (no hand-made capture there holds the shape). Test: `test/unit/site-no-revert.test.ts` "classes without a dropped declaration print byte for byte as on main" (unchanged, golden file unchanged)
- AC6 (proposed): Given the Figma route, when the source is scanned, then no file under `src/plugin` or `src/core` outside `src/core/site` imports `src/core/site`, so every Figma design converts as before (with `npm run corpus` unchanged at the close). Test: `test/unit/site-inline-own.test.ts` "no Figma stage imports the website importer's converter"

No AC is `(live)`: no page Justin has holds the shape (Q4).

## Current context and where it would conflict

- Base for the build: staging-fit-cancels' head (Q3 A). Its `src/core/site/blocks.ts` (`runsOf`, `boundsOf`, `mediaOf`),
  `classes.ts`, `controls.ts` stay untouched by this job; `convert.ts` isn't in its diff. This job adds one file
  (`src/core/site/inline-own.ts`) and changes four lines of `src/core/site/convert.ts` (`prepare`'s class loop).
- **footer-icon-list** (`footer-icon-list-build`, `b9a338d8`: `src/core/site/sides.ts` and `statesOf` in `blocks.ts`):
  no shared file. `inline-own.ts` keeps its own `running` (the capture's listing, not `statesOf`), so the moved readings
  keep both names of a box side in the capture's order, and footer-icon-list's `statesOf` picks the winner later as for
  any element. Either merge order works with no textual conflict.
- **site-native-structure** (`site-native-structure-stack5`): `convert.ts` context conflicts expected in the class loop
  (it adds a `parts` line right after the `inline:` line and changes the `full` line); keep both sides. Its `lift`
  (a lifted box's children take its place) is why rule 2 checks each child's path is the parent's own child; its
  `absorb` leaves no pasted children (the rule does nothing).
- **site-menu** (`site-menu-stack6`): `convert.ts` conflict on the `own` line (it maps `pointer-events` onto
  `boxLook(...)`); resolve as `boxLook(t.node, statesOnKept(rewrite(decls, t.path), code, pr), t).map(...)`, keeping its
  map and this job's `decls`.

## Tasks (test first; each task one commit, green)

The machine notes for every step: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38
characters; `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time; B-Dry runs under
`systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` (export variables first); a 143/137/"Killed" may be
earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

### Task 0: the plan and the ledger

1. Copy this file to `docs/plans/2026-11-10-control-weight.md`; start `.superpowers/sdd/2026-11-10-control-weight/progress.md`.
2. `npm run corpus` before Task 1 (ledger: its summary lines). Commit `control-weight Task 0: the plan and the ledger`.

### Task 1: the rule (AC1, AC2, AC3, AC6), test first

1. **Tests first.** Write `test/fixtures/site-inline-own.ts` and `test/unit/site-inline-own.test.ts` exactly as below,
   and in `test/web/site-range-cancels.test.ts` remove the `todo` option from the last test (its line becomes
   `test("inside 768–991 the link is a word in its line, as on the site", { skip }, () => {`) and replace the comment
   above `const inside` with the one below.
2. **RED** (proved by the planner on a `git archive` of `staging-fit-cancels-stack7`, logs in the evidence folder):
   - `node --test test/unit/site-inline-own.test.ts`: test 1 (AC2) fails (`the wrapper writes no rule for its child`:
     the wrapper writes `.home__repairs-that__box > :nth-child(1)` declarations); tests 2 (AC3) and 3 (AC6) pass on the
     base (they are guards; Task 3 kills their mutants). `logs/unit-s7.tap`: 1 fail of 3553, the rest as the base.
   - `node --test test/web/site-range-cancels.test.ts`: its second test (AC1's) is `not ok 2`
     (`logs/s7-range-cancels-notodo.log`: `#btn at 850: paste {"display":"inline-block",…}` for each of the 4 pastes on
     each of the 2 Bricks samples, and the page rows at 991, 880, 768).
3. **GREEN:** add `src/core/site/inline-own.ts` and the four `convert.ts` lines below. Then both commands pass
   (`logs/proto-range-cancels-notodo.log`: 2 of 2; the unit file 3 of 3).
4. `npm run check`; `npm run test:web` file by file against the base by name (ledger). Commit
   `control-weight Task 1: an element its parent reads as a word at some widths carries those widths in its own class`.

`test/fixtures/site-inline-own.ts`:

```ts
// control-weight: hand-made captures holding an element the page reads as its parent's inline element at some widths
// (a word in its parent's line there) and as its own element at the others: a wrapper whose link is its own painted
// button on desktops and phones and a word of the wrapper's line on tablets (768–1024). Generic, built on site-code.ts's
// page (section S2 gains the wrapper); no site's copy. Variants: a space the page draws before the link (the reader
// counts no space: the link stays the wrapper's second inline element); a child before the link hidden on tablets (the
// reader skips it there, so the link's reading is its first while the paste's first child is the hidden one); the
// wrapper itself hidden on tablets (a menu a phone hides: nothing to draw there).
import type { Snapshot } from "../../src/core/snapshot/schema.ts";
import type { CodeByRange, CodeNode } from "../../src/core/snapshot/web.ts";
import { code, PATHS, RANGES as R, S2 } from "./site-code.ts";

export const WRAP = `${S2}/div:0`, LINK = `${WRAP}/a:0`, ICON = `${WRAP}/span:0`, CALL = `${WRAP}/span:1`;
// the link's own look (desktops and phones) and its look as the wrapper's inline element (tablets)
export const BUTTON = { display: "inline-block", "padding-top": "14px", "padding-bottom": "14px", "background-color": "#0b6e4f", color: "#ffffff", "font-size": "18px", "border-top-left-radius": "6px" };
export const WORD = { ...BUTTON, display: "inline" };
const dropAll = (d: Record<string, string>): Record<string, null> => Object.fromEntries(Object.keys(d).map((k) => [k, null]));
// the wrapper's reading of an inline element: nothing on desktops, the given look on tablets, nothing again on phones
const inlineAtTablets = (look: Record<string, string>): CodeByRange => ({ [R[0]]: {}, [R[1]]: look, [R[2]]: dropAll(look) });

type Variant = "plain" | "space" | "hidden" | "wrapper-hidden";
export function inlineAtSome(variant: Variant = "plain"): Snapshot {
  const kids = variant === "hidden" ? [ICON, LINK] : variant === "space" ? [CALL, LINK] : [LINK];
  // with a space: the words "Call us" before the link, both words of the wrapper's line on tablets
  const inline: Record<string, CodeByRange> = variant === "space" ? { "0": inlineAtTablets({ color: "#1d2433" }), "1": inlineAtTablets(WORD) } : { "0": inlineAtTablets(WORD) };
  const hiddenWrap = variant === "wrapper-hidden";
  const extra: Record<string, Partial<CodeNode>> = {
    [S2]: { children: [PATHS.H2, PATHS.LEAD, WRAP] },
    [WRAP]: {
      tag: "div", kind: "box", attrs: {}, children: kids, inline, inherited: { [R[0]]: {} },
      decls: { [R[0]]: { "margin-top": "24px" }, ...(hiddenWrap ? { [R[1]]: { display: "none" }, [R[2]]: { display: null } } : {}) },
      shown: hiddenWrap ? [R[0], R[2]] : R, ...(variant === "space" ? { spaces: [1] } : {}),
    },
    [LINK]: { tag: "a", kind: "words", attrs: { href: "https://site.test/book/" }, children: [], html: "Book a visit", decls: { [R[0]]: BUTTON }, inherited: { [R[0]]: {} }, shown: [R[0], R[2]] },
  };
  if (variant === "space") extra[CALL] = { tag: "span", kind: "words", attrs: {}, children: [], html: "Call us", decls: { [R[0]]: { color: "#1d2433" } }, inherited: { [R[0]]: {} }, shown: [R[0], R[2]] };
  if (variant === "hidden") extra[ICON] = { tag: "span", kind: "box", attrs: {}, children: [], decls: { [R[0]]: { width: "8px", height: "8px" }, [R[1]]: { display: "none" }, [R[2]]: { display: null } }, inherited: { [R[0]]: {} }, shown: [R[0], R[2]] };
  const s = code({ patch: extra as Record<string, Partial<CodeNode>> });
  // site-code.ts's code() patches only the nodes it knows: the new ones go in whole
  for (const [p, n] of Object.entries(extra)) if (p !== S2) s.web!.code!.nodes[p] = n as CodeNode;
  return s;
}
```

`test/unit/site-inline-own.test.ts`:

```ts
// control-weight AC2, AC3, AC6: an element the page reads as its parent's inline element at some widths and as its own
// element at the others carries those widths in its own class (the parent writes no `> :nth-child` rule for it, so no
// Bricks control of the element, printed `.cls.brxe-<element>` after the parent's class, can outweigh it); where the
// paste's children can't be proved the capture's inline elements one for one, or the parent is hidden there, the
// parent's rule stays as before; and no Figma stage imports the website importer's converter.
import { test } from "node:test";
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { siteToBricks } from "../../src/core/site/convert.ts";
import type { BricksPayload } from "../../src/core/emit/payload.ts";
import { declsIn } from "../fixtures/site-css-text.ts";
import { inlineAtSome, LINK, WRAP } from "../fixtures/site-inline-own.ts";
import { S2 } from "../fixtures/site-code.ts";

type Settings = Record<string, unknown>;
// an element's own class (the last class it lists that isn't a shared site- class)
const classOf = (payload: BricksPayload, sources: Record<string, string>, path: string): { name: string; settings: Settings } => {
  const id = Object.keys(sources).find((k) => sources[k] === path)!;
  const el = payload.content.find((e) => e.id === id)!;
  const ids = (el.settings as Settings)._cssGlobalClasses as string[];
  const own = payload.globalClasses!.filter((g) => ids.includes(g.id) && !g.name.startsWith("site-")).pop()!;
  return { name: own.name, settings: own.settings as Settings };
};
const written = (s: Settings) => declsIn(String(s._cssCustom ?? ""));

test("an element its parent reads inline at some widths carries those widths in its own class, and the parent writes no rule for it", () => {
  for (const [variant, text] of [["plain", "rich"], ["plain", "basic"], ["space", "rich"]] as const) {
    const { payload, sources } = siteToBricks(inlineAtSome(variant), { section: { path: S2 }, text });
    const wrap = classOf(payload, sources, WRAP), link = classOf(payload, sources, LINK);
    assert.deepEqual(written(wrap.settings).filter((d) => d.selector.includes(":nth-child")), [], `${variant} ${text}: the wrapper writes no rule for its child`);
    // the link's display: inline-block, inline from 1024 down, inline-block again from 767 down, in its own class
    const display = written(link.settings).filter((d) => d.prop === "display").map((d) => `${d.at.join(" ")}|${d.selector}|${d.value}`);
    assert.deepEqual(display, [
      `|.${link.name}|inline-block`,
      `@media (max-width: 1024px)|.${link.name}|inline`,
      `@media (max-width: 767px)|.${link.name}|inline-block`,
    ], `${variant} ${text}: the link's own class says inline on tablets`);
    // a property whose value never changes stays the Bricks control it was; display is no control at any width
    assert.equal(link.settings._display, undefined, `${variant} ${text}: no display control to outweigh the tablets' value`);
    assert.deepEqual(link.settings._background, { color: { hex: "#0b6e4f" } }, `${variant} ${text}: the background stays a control`);
  }
});

test("where the paste's children can't be proved the capture's inline elements, or the parent is hidden there, the parent's rule stays as before", () => {
  for (const variant of ["hidden", "wrapper-hidden"] as const) {
    const { payload, sources } = siteToBricks(inlineAtSome(variant), { section: { path: S2 }, text: "rich" });
    const wrap = classOf(payload, sources, WRAP), link = classOf(payload, sources, LINK);
    const rule = written(wrap.settings).filter((d) => d.selector === `.${wrap.name} > :nth-child(1)`);
    assert.ok(rule.some((d) => d.prop === "display" && d.value === "inline"), `${variant}: the wrapper keeps its inline-element rule`);
    assert.equal(link.settings._display, "inline-block", `${variant}: the link's class is as before`);
  }
});

test("no Figma stage imports the website importer's converter", () => {
  const root = new URL("../../src/", import.meta.url).pathname;
  const files = (dir: string): string[] => readdirSync(join(root, dir), { withFileTypes: true })
    .flatMap((e) => (e.isDirectory() ? files(join(dir, e.name)) : e.name.endsWith(".ts") ? [join(dir, e.name)] : []));
  const figma = [...files("plugin"), ...files("core").filter((f) => !f.startsWith("core/site/"))];
  const site = join(root, "core/site/");
  const reach = figma.filter((f) => [...readFileSync(join(root, f), "utf8").matchAll(/from\s+["'](\.[^"']+)["']/g)]
    .some((m) => resolve(dirname(join(root, f)), m[1]).startsWith(site)));
  assert.deepEqual(reach, [], "the Figma route never imports src/core/site");
});
```

The comment above `const inside` in `test/web/site-range-cancels.test.ts` becomes:

```ts
// control-weight (AC1): inside the widths where the wrapper's words hold the link (768–991) the site's link is a word
// (`display: inline`). The link's own class carries those widths now (src/core/site/inline-own.ts), so no copied
// `.wrapper > :nth-child(1)` rule meets its Bricks controls (`.cls.brxe-<element>`, printed after). Those widths' full
// looks and the page's 2 px rows there are collected here and asserted by the test below.
```

`src/core/site/inline-own.ts` (new):

```ts
// control-weight: an element the capture reads as its parent's inline element at some ranges (a word in its parent's
// line there: read/code-facts.ts reads the parent as a box of words) and as its own element at the others is one
// element of the paste, with a class of its own. Its readings at those ranges go in its own class, never in the
// parent's `> :nth-child(k)` rule: two classes for one element let the element's Bricks controls (printed
// `.cls.brxe-<element>`, 0,2,0, after the parent's class) beat that rule where the site's own class rule lost. Pure.
import type { CodeByRange, CodeDecls, WebCode } from "../snapshot/web.ts";
import type { TreeNode } from "./tree.ts";

// a by-range record's full declarations per range, as the capture lists them (widest first; null: no longer declared)
function running(byRange: CodeByRange | undefined, ranges: string[]): CodeDecls[] {
  const out: CodeDecls[] = [];
  let cur: CodeDecls = {};
  ranges.forEach((r, i) => {
    cur = i === 0 ? {} : { ...cur };
    for (const [k, v] of Object.entries(byRange?.[r] ?? {})) { if (v === null) delete cur[k]; else cur[k] = v; }
    out.push(cur);
  });
  return out;
}
// full declarations per range → the capture's own form: the widest in full, then each narrower range's changes (null:
// no longer declared), as src/web/code.ts `encode` stores them
export function byRangeOf(states: CodeDecls[], ranges: string[]): CodeByRange {
  const out: CodeByRange = {};
  ranges.forEach((r, i) => {
    if (i === 0) { out[r] = { ...states[0] }; return; }
    const prev = states[i - 1], now = states[i], d: Record<string, string | null> = {};
    for (const k of new Set([...Object.keys(prev), ...Object.keys(now)])) if (prev[k] !== now[k]) d[k] = now[k] ?? null;
    out[r] = d;
  });
  return out;
}

export interface InlineOwn {
  decls: Map<string, CodeByRange>;                    // an element's path → its declarations, every range its own
  inline: Map<string, Record<string, CodeByRange>>;   // an element's path → its words' inline elements, likewise
  moved: Map<string, Set<string>>;                    // a parent's path → the inline keys its class no longer writes
}

// For each Div or Block of the paste holding site elements that its capture reads as its inline elements one for one
// (a space the page draws between two of them is words, which the reader never counts; none lifted from below; at
// every range reading any, exactly the first steps 0 … n-1 read something, so no child the reader skipped there, a
// hidden one, shifts the count): an inline key whose first step i is a child with its own class, read only at ranges
// where the parent is shown and that child isn't, moves onto the child ("i" onto its own declarations at those ranges,
// "i/rest" onto its words' inline element "rest"). Anything else stays as before.
export function inlineOwners(code: WebCode, nodes: readonly TreeNode[]): InlineOwn {
  const out: InlineOwn = { decls: new Map(), inline: new Map(), moved: new Map() };
  const byId = new Map(nodes.map((t) => [t.id, t]));
  const ranges = code.ranges;
  for (const p of nodes) {
    if (!p.site || p.node.kind !== "box" || !p.node.inline || p.name === "code" || p.name === "text") continue;
    const kids = p.children.map((id) => byId.get(id)!).filter((k) => k.site);
    if (!kids.length || kids.some((k) => k.path.slice(0, k.path.lastIndexOf("/")) !== p.path)) continue;
    const read = Object.entries(p.node.inline).map(([key, by]) => ({ key, step: Number(key.split("/")[0]), rest: key.split("/").slice(1).join("/"), states: running(by, ranges) }));
    const reads = (r: { states: CodeDecls[] }, j: number): boolean => Object.keys(r.states[j]).length > 0;
    const aligned = ranges.every((_, j) => {
      if (!read.some((r) => reads(r, j))) return true;
      const steps = new Set(read.filter((r) => r.rest === "" && reads(r, j)).map((r) => r.step));
      return steps.size === kids.length && kids.every((_, i) => steps.has(i));
    });
    if (!aligned) continue;
    for (const i of new Set(read.map((r) => r.step))) {
      const x = kids[i];
      if (!x || !x.own) continue;
      const mine = read.filter((r) => r.step === i);
      const at = ranges.filter((_, j) => mine.some((r) => reads(r, j)));
      // read where the parent shows and the child doesn't stand alone (a menu hidden there keeps its rules as before)
      if (!at.length || at.some((r) => x.node.shown.includes(r) || !p.node.shown.includes(r))) continue;
      // the child's own readings, with the parent's reading of it at those ranges in their place
      const take = (own: CodeByRange | undefined, there: CodeDecls[] | undefined): CodeByRange =>
        byRangeOf(running(own, ranges).map((d, j) => (at.includes(ranges[j]) ? { ...(there?.[j] ?? {}) } : d)), ranges);
      out.decls.set(x.path, take(x.node.decls, mine.find((r) => r.rest === "")?.states));
      for (const r of mine.filter((m) => m.rest !== "")) {
        const words = out.inline.get(x.path) ?? { ...(x.node.inline ?? {}) };
        words[r.rest] = take(x.node.inline?.[r.rest], r.states);
        out.inline.set(x.path, words);
      }
      const moved = out.moved.get(p.path) ?? new Set<string>();
      for (const r of mine) moved.add(r.key);
      out.moved.set(p.path, moved);
    }
  }
  return out;
}
```

`src/core/site/convert.ts` (staging-fit-cancels' head; line numbers there): one import after
`import { liveWidgets, scriptMade } from "./live.ts";` (`:30`), then in `prepare`'s class loop (`:196-229`):

```diff
+import { inlineOwners } from "./inline-own.ts";
@@ prepare, the class loop
   const specs: Prepared["specs"] = new Map();
+  const owners = inlineOwners(code, tree.nodes);
   for (const t of tree.nodes) {
     if (!t.site || !t.own) continue;
+    const decls = owners.decls.get(t.path) ?? t.node.decls;
+    const words = owners.inline.get(t.path) ?? t.node.inline ?? {};
+    const moved = owners.moved.get(t.path);
@@
-    const own = boxLook(t.node, statesOnKept(rewrite(t.node.decls, t.path), code, pr), t);
+    const own = boxLook(t.node, statesOnKept(rewrite(decls, t.path), code, pr), t);
@@
-      inline: Object.keys(t.node.inline ?? {}).sort(byIndexPath).map((k): [string, Block[]] => [k, kept(t.node.inline![k])]),
+      inline: Object.keys(words).filter((k) => !moved?.has(k)).sort(byIndexPath).map((k): [string, Block[]] => [k, kept(words[k])]),
```

(`parts.ts:43` still reads the capture's own inline readings for the fonts the page uses: unchanged on purpose. No
stage edits an earlier stage's output: `inlineOwners` reads the capture and the tree and returns new records.)

### Task 2: the byte receipt (AC4, AC5), named only

1. Write `test/unit/site-inline-own-bytes.test.ts` as below (skipped unless named).
2. Make the base tree: `git archive <base commit> | tar -x -C ~/.cache/<job>-base` with `node_modules` linked; capture
   every fixture site on the head (`captureFixture` for each `test/fixtures/web/sites/*` but `range-cancels`; the
   planner's `cap-all.ts` does it in about 5 minutes with one Chrome) into a scratch folder.
3. Run, under the memory cap: `F2B_BASE_TREE=<base tree> F2B_INLINE_OWN_CAPTURES=<the fixture captures, B-Dry's
   stand-in, bdryswi-com-home-2026-11-04-code> node --test test/unit/site-inline-own-bytes.test.ts` → pass; the ledger
   lists every capture and its 8 pastes. `node --test test/unit/site-no-revert.test.ts` → pass with
   `test/fixtures/site-no-revert-main.json` unchanged (AC5).
4. Commit `control-weight Task 2: every paste without the shape byte for byte as the base tree's (named only)`.

```ts
// control-weight AC4 (named only): a capture holding no element its parent reads as an inline element at some widths
// (where the parent shows and the element doesn't stand alone) pastes byte for byte as the base tree's: the whole page
// (header, page, footer), both routes (code, --elementor), both picture modes, both text modes. F2B_BASE_TREE: a git
// archive of the base with node_modules linked; F2B_INLINE_OWN_CAPTURES: capture files, comma separated (the builder's
// list is in the ledger).
import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { siteParts } from "../../src/core/site/parts.ts";
import type { Snapshot } from "../../src/core/snapshot/schema.ts";

const base = process.env.F2B_BASE_TREE ?? "";
const files = (process.env.F2B_INLINE_OWN_CAPTURES ?? "").split(",").map((f) => f.trim()).filter(Boolean);
const skip = !base || !files.length ? "named only: set F2B_BASE_TREE (a git archive of the base) and F2B_INLINE_OWN_CAPTURES" : false;

// the shape this job moves: a box shown at a range where it reads an inline element and one of its element children
// isn't shown
function inlineAndOwn(s: Snapshot): string[] {
  const code = s.web?.code;
  if (!code) return [];
  const out: string[] = [];
  for (const n of Object.values(code.nodes)) {
    if (n.kind !== "box" || !n.inline) continue;
    const kids = n.children.filter((c) => code.nodes[c]?.shown.length);
    for (const by of Object.values(n.inline)) {
      let cur: Record<string, string> = {};
      code.ranges.forEach((r, i) => {
        cur = i === 0 ? {} : { ...cur };
        for (const [k, v] of Object.entries(by[r] ?? {})) { if (v === null) delete cur[k]; else cur[k] = v; }
        if (Object.keys(cur).length && n.shown.includes(r)) for (const c of kids) if (!code.nodes[c].shown.includes(r) && !out.includes(c)) out.push(c);
      });
    }
  }
  return out;
}

test("a capture holding no element its parent reads inline pastes byte for byte as the base tree's", { skip }, async () => {
  const was = (await import(join(resolve(base), "src/core/site/parts.ts"))).siteParts as typeof siteParts;
  for (const f of files) {
    const capture = JSON.parse(readFileSync(f, "utf8")) as Snapshot;
    if (!capture.web?.code) continue;
    assert.deepEqual(inlineAndOwn(capture), [], `${f}: holds no element its parent reads inline`);
    let n = 0;
    for (const elementor of [false, true]) for (const pictures of ["data", "address"] as const) for (const text of ["rich", "basic"] as const) {
      const opts = { elementor, pictures, text };
      let now: string, then: string;
      try { now = JSON.stringify(siteParts(capture, opts)); } catch (e) { now = `refused: ${(e as Error).message}`; }
      try { then = JSON.stringify(was(capture, opts)); } catch (e) { then = `refused: ${(e as Error).message}`; }
      assert.equal(now, then, `${f} ${elementor ? "elementor" : "code"} ${pictures} ${text}: as the base tree's`);
      n++;
    }
    assert.equal(n, 8);
  }
});
```

### Task 3: mutation, HANDOFF, gates

1. Mutants (`mutation-testing-discipline`, under `systemd-run … MemoryMax=4G`), each must fail a named test:
   M1 drop `|| !p.node.shown.includes(r)` (AC3's `wrapper-hidden`; AC4 on the five hidden-menu fixtures);
   M2 `aligned` always true (AC3's `hidden`); M3 drop the own-child path check (keep a lifted child: write a unit case
   if no test kills it, through `buildTree`'s `lift` once site-native-structure merged, else record the survivor);
   M4 keep moved keys in the parent (`filter` removed: AC2's "writes no rule"); M5 take `t.node.decls` again (AC1,
   AC2); M6 `at.some(x shown)` removed (AC2's display rows on desktops); M7 `.filter((k) => k.site)` removed (AC2's
   `space` variant). Table in the ledger.
2. HANDOFF: a section "An element its parent reads as a word carries those widths in its own class (control-weight,
   website importer; build at the merge; paste check id set at the merge)" with the plain-words change, the Q answers
   as "not yet confirmed", the counts above, and staging-fit-cancels' Known-limits bullet ("Inside the widths where a
   parent's words hold an element as an inline element …") replaced by one line pointing here. Deferred: the reverse
   shape (a word box at its widest range whose child stands alone narrower, 1 in the fixedbars fixture: its narrow
   look is never pasted), and Bricks' Display control holding `inline` (unverified in `reference/bricks/`).
3. Gates: `npm run check`; `npm run test:web` and `npm run test:browser` file by file against the base by name;
   `npm run corpus` (the same as Task 0's). Commit `control-weight Task 3: mutation, HANDOFF and the gates`; status
   `ready-for-review`.

## Tests and validation (planner's runs, on `git archive` copies)

- Base `staging-fit-cancels-stack7` `ce5b38ac` + this plan's tests only: unit suite 3553 tests, 3480 pass, **1 fail
  (AC2's test)**, 72 skipped (`logs/unit-s7.tap`); `site-range-cancels.test.ts` with the `todo` removed: 1 pass, 1 fail
  (`logs/s7-range-cancels-notodo.log`).
- Prototype (the same + this plan's source and tests): unit suite 3554 tests, 3481 pass, 0 fail, 73 skipped (the byte
  test skips unless named; `logs/unit-proto.tap`); `site-range-cancels.test.ts` 2 of 2 (`logs/proto-range-cancels-notodo.log`);
  `contest.ts` on the fixture finds 0 lost properties with 2.3.9 and 2.4.2, plain and `--elementor`
  (`logs/contest-proto-fx-range-cancels-*.log`).
- The plan's own text (its six code blocks pulled by `~/.cache/cw-p/probe/apply-plan.py` and applied by anchor to fresh
  `git archive`s of `staging-fit-cancels-stack7`): tests only → AC2 1 fail, AC3 and AC6 pass, AC1 `not ok 2`
  (`logs/plan-red-unit.log`, `logs/plan-red-web.log`); the whole plan → `npm run typecheck` 0, the unit file 3 of 3,
  `site-range-cancels.test.ts` 2 of 2, AC4 named over the 45 fixture captures, B-Dry's stand-in and bdryswi 2026-11-04
  passes (`logs/plan-green-*.log`), and AC4 given the range-cancels capture fails on its own scan, as it should
  (`logs/plan-bytes-shape-refused.log`).
- Bytes, base head vs prototype (`bytes.ts`: the whole page, 2 routes × 2 picture modes × 2 text modes, over 50 captures:
  the 46 fixture sites captured on this base, the range-cancels capture again, B-Dry's stand-in, bdryswi 2026-11-04
  code and the 2026-11-09 capture): **376 of 400 pastes byte for byte**; the 24 that differ are exactly the three
  captures holding the shape (range-cancels twice, the 2026-11-09 capture main refuses). The five hidden-menu fixtures
  are byte for byte (`logs/bytes-compare.txt`, `bytes-s7.json`, `bytes-proto.json`).

## Risks and follow-ups

- A capture of a parent that reads an inline element with **no declarations at all** at a range counts as not reading
  it there; rule 2 then fails and the paste stays as before (safe, never a wrong move).
- The reverse shape (above) and Bricks' Display offering `inline` are follow-ups, not this job.
- Spaces: today a parent with a space between pasted children addresses its inline rules by `:nth-child`, which counts
  the space element. Where this job moves those rules the miscount goes too; where it doesn't (rule 2 fails) it stays
  as before (a follow-up only if a capture shows it).

## Mini or Full

**Mini.** A clear bug with a proved cause, one new pure file and four lines in one existing file, no auth or data
areas, no new UI. The one design point (Q1) follows the existing controls rule (web-code-proof Q7 A) and is flagged
for Justin under the auto-go. The overlap with site-native-structure and site-menu is a few lines of `convert.ts`'s
class loop, resolved by keeping both sides (above); the importer's standing "one review per job" fits Mini's single
review.
