# hero-media-row — plan (Figma to Bricks V2)

**Approved by Justin 2026-10-22 ("go" = plan + all ⭐ answers Q1–Q6).**

Planner, 2026-10-22 08:50 EDT, main `b4ed333` (BUILD `2026-10-22.5`). Plan only: no worktree, branch, code or commit.
Scope grew mid-plan (Justin: "Fix them as part of the job"): **three parts** — 1 hero row, 2 tablet header, 3 breadcrumb.

## Open questions (answer with letters; ⭐ = what this plan assumes, so "go" needs no re-plan)

**Q1. Upright phones (≤ 478px)** — you only named tablet and sideways phones.
- A ⭐ Stack as today: words, then picture, then the buttons band
- B Keep words and picture side by side there too (≈ 160px each)

**Q2. Which rows keep words-left / picture-right below 992px?**
- A ⭐ Only the page's hero (top section), any page
- B Every words + picture row (service zigzags too)

**Q3. W-B (your held "wrapped-row least" decision) touches this exact hero grid.**
- A ⭐ Hero-only rule now; W-B stays held, nothing else moves
- B Decide W-B now (Bento grid goes 2 → 3 columns on tablet)

**Q4. The header on that page is your own Bricks header template, not plugin output.**
- A ⭐ You paste one CSS block into it (I tested it in Chrome)
- B The plugin pastes its own header instead (separate feature)
- C Leave the header as it is

**Q5. Logo + 5 links + phone + button need 1,252px on one line. Below that, what folds?**
- A ⭐ Links fold into the menu button below 1,280px
- B Links fold only at ≤ 991px (laptops 992–1,279 stay squeezed)
- C Menu button on every screen, no links in the bar

**Q6. Header on phones** (not asked, but Q5's fix would push it sideways):
- A ⭐ Phone number hides ≤ 767px, button hides ≤ 478px
- B Keep both, wrapping onto several lines as today

## Playback

1. On desktop the service-page hero shows words on the left (breadcrumb, "SERVICE 02", the big heading, a paragraph, two buttons) and a framed picture on the right. That's right.
2. From 991px down (tablets) and on phones held sideways (≤ 767px) the picture frame drops under the buttons and spans the full width. You want it to stay on the right of the words, as on desktop.
3. Added: on a 990px tablet your header loses its logo, the phone number wraps onto three lines and "SCHEDULE NOW" onto two.
4. Added: in the breadcrumb, "SERVICES" sits higher than "HOME" and the page name.
5. The fix must be general (found from structure), never keyed to this page.

## Size

Was ≈ 3 h (hero only). Now ≈ 5–6 h builder time: part 3 ≈ 45 min, part 1 ≈ 3 h, part 2 ≈ 15 min (no plugin code: a tested CSS block plus a live check), gates and records ≈ 1–1.5 h. Plus a fresh review and a fresh verifier (Agent Defect Loop, see Skills).

## Root causes (file:line evidence, reproduced)

Reproduced with the repo's renderer on a scratch copy of the main-folder debug file (`Hydraulic Cylinder Repairs Final`, 553:7604, the sister page built from the same template; the Remanufactured page's own Figma export doesn't exist) and on the live page `/remanufactured-hydraulics-cylinders-final/` (read-only GET, local Chrome). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/hero-media-row/`.

### Part 1 — hero picture drops below the words from 991px down

- The hero `header.shero` holds `div.wrap 553:7783`, a Figma **grid**: 2 columns `1.2fr / 0.8fr`, gap 50, one fixed 588px row. Cells: `div 553:7784` (the words, 882 wide) and `div.prod 553:7813` (the bordered picture frame, 588 wide).
- The paste writes `_gridTemplateColumns:tablet_portrait: "repeat(1, minmax(0, 1fr))"` on it (`grid.columns`, `src/core/adapt/rules/grid.ts:13-16`), from the plan's `columns()` (`layout.ts:138-141` → `shapes.ts:167-201 gridColumns`).
- `gridColumns` keeps a grid's columns at tablet only while each equal cell ≥ `firm`, the largest one-line button need of any cell (`shapes.ts:176-178, 184-187`). Plan numbers at the tablet decision width (768 → room 696): cell = (696 − 48) / 2 = **324**; `firm` = **494** for the words cell.
- The 494 comes from `least.ts:149-153`: a box's least adds its row items side by side, **even when that row wraps**. The words cell's button row `div.row 553:7802` is `layoutWrap: WRAP` (paste: `_flexWrap: wrap`), yet its least is 201 + 14 + 279 = 494 instead of its widest pill (279). So 324 < 494 → 1 column at tablet; shapes only grow, so landscape and portrait stay 1 column.
- At sideways phones the gap gets worse in the plan, though in the paste those buttons are not even in the hero there: they move to the "Phone buttons" band below it (`understand/phone.ts:150-179`, `show = "desktop"` → `_display:mobile_landscape: none` on the row).
- Working comparison: every other kept two-column grid has cells holding only short labels. Changing `least()` for wrapping rows is exactly **W-B** (`found-else.md:252`: "debug grids 553:7783/7606 1→2", Bento grid 2→3), which Justin holds. So the fix stays hero-scoped (Q3 A).
- A second limit appears once the row is kept. The heading's size cap `wordCap` measures the longest word against the whole screen's content width (`facts.ts:58-63`, used by `type.ts:40`), not the narrower column, so a big heading could overflow a half-width column.
- Measured (live, Saira Condensed): "REMANUFACTURED" = 6.50 em, which is 338px at the 52px tablet size. The plan's estimate for a heading Figma draws on 2+ lines is the generic 0.72 em/letter for capitals (`facts.ts:50-56`), 55% too wide for this font.

### Part 2 — tablet header: logo gone, phone and button wrap

- The header on the live page is the site's **own Bricks header template** (post 15: `#brx-header` → section `brxe-pmmkrh`; native Logo `brxe-yejzec`, a Nav Menu `brxe-udfzci` bound to the WP menu "main", Ionicons/Themify icons). The plugin never emits these elements.
- The page was pasted with "My site already has its header" ticked: the paste starts with the plugin's `site-header-room` spacer. That's Justin's 2026-10-20 decision (CLAUDE.md "Header and footer the site already has", :131-141, and Decisions :1378). **No plugin code produces or can repair this header.**
- Cause, from the template's CSS (`evidence/hero-media-row/live-header-template-post-15.css`):
  - `#brxe-salbot` is a `display:flex; justify-content:space-between` row with no wrap.
  - The Nav Menu turns into its menu button only `@media (max-width: 767px)`.
  - The section keeps 64px sides at every width.
  - Every item may shrink (`flex-shrink: 1`), and the logo `img` has Bricks' `max-width:100%`, so it can squeeze to nothing.
- Measured natural widths: logo 161, links 619, phone + button 344, so 1,124 + 128 padding = **1,252px** needed on one line. Live at 990: the logo is **11px wide**, the phone text is 3 lines, the button wraps. At 768: logo 0px. At 1024: logo 45px.

### Part 3 — breadcrumb: "SERVICES" sits 11px high

- In Figma the crumb instance `Component 5` (553:7790, 47×20, no auto layout) holds text `I553:7790;553:7217` "Services". Its box is a **fixed 30px wide** (the component master's width, sized for "Home") with auto height. Figma broke the single word inside itself: render ink 27.5×29.2, box 30×41 at y = −11.
- "Home" (`I553:7786;553:7217`) is 30×21 at y = −1.
- `inferLayout` flows only the layers lying within 2px of their frame (`normalise/infer.ts:24 EDGE`, `:286-287 inside()`). "Services" reaches 11px past the frame, so it stays `absolute` (`normalise.ts:123`, `understand/node.ts:55`). The paste then places it at `_top: -11`, `_position: absolute` (paste `izptso`; live `brxe-gdzbvx` top −11px at 1571/990/600).
- A browser never breaks a plain word, so it draws one line at the top of Figma's two-line box: 11px above its neighbours. Corpus scan: this is the only single-word auto-height text Figma drew on 2+ lines in the 5 corpus files and the debug file.

## Approach

**Part 3 (normalise, smallest, first).**
- Rule: a text Figma sized itself (`textAutoResize: HEIGHT`), holding one unbreakable word, that Figma drew taller than 1.5 lines, is a word Figma broke inside itself. A browser draws it on one line.
- What changes:
  - Normalise gives it a one-line box, keeping the middle of Figma's box.
  - Its `words` becomes `null`, since Figma's ink is of the broken lines.
- Then it flows like its siblings.
- Excluded:
  - words CSS breaks anyway (`style.ts:172` long e-mail/URL words, shared as one predicate);
  - fixed boxes (`NONE`);
  - turned text;
  - text with spaces or hyphens (their extra lines are real breaks).

**Part 1 (understand + adapt, hero only).**
- Understand marks the hero's one **text|picture pair**. That's a row or a one-row 2-cell grid of exactly two flowing items: one with words, one picture box (the same `pictured`/`worded` tests as `splitRow`). It must sit inside `heroOf(page)`'s section, only when there's exactly one such pair. The mark is `IRNode.heroPair = { media: 0 | 1 }`.
- In the layout plan, at `tablet_portrait` and `mobile_landscape` (not upright phones, Q1 A), a marked pair **keeps** its row or its 2 columns while, at the tier's decision width, all of these hold:
  - (a) the picture's share ≥ `ALONE_MIN` (160 tablet / 120 sideways phone, Justin's existing floors);
  - (b) the words' share holds its widest button **still shown there** (a wrapping row counts its widest pill, a non-wrapping row its sum; `show: "desktop"` buttons don't count ≤ 767);
  - (c) the words' share holds the paragraph's existing reading floor (`least.ts reading`, 3 average words);
  - (d) every text in the words column keeps its longest word at body size (16px) or more.
- If any check fails, today's logic runs unchanged.
- Shares are the plan's own: equal cells for a grid (conservative: CSS gives the words 1.2fr = 20% more), drawn widths for a row.
- Type: inside a kept pair's words column, `type.ramp` caps each text so its longest word fits the column's width as the plan has it (the same "longest word fits" rule it applies to the screen today), never below body size.
  - The letter-width estimate for a text Figma drew on several lines comes from Figma's own ink: its widest line, found by greedy wrap. The estimate is padded by 8% (`inkCharWidth`), used only by this cap.
  - A backstop: those headings get `overflow-wrap: break-word` at that tier, which only acts if the estimate missed.

**Part 2 (no plugin code).** Justin pastes one CSS block into his header template (Q4 A, Q5 A, Q6 A). I tested it locally on the live page (CSS injected only in my Chrome, nothing sent):
- logo 161px at every width 1728 → 320;
- phone one line wherever shown;
- header 88px tall everywhere;
- no sideways scroll at any width;
- the menu button opens the panel with all 5 links at 1200/990/600.

Shots: `evidence/hero-media-row/shots/hdr-after-*.png`.

```css
/* Header: logo, phone number and button never squeezed; links fold into the menu button below 1280px */
#brxe-yejzec, #brxe-vqpflr { flex-shrink: 0; }
#brxe-iaoyur, #brxe-gdeklp { white-space: nowrap; }
@media (max-width: 1279px) {
  #brxe-udfzci { order: 3; margin-left: 20px; }
  #brxe-vqpflr { margin-left: auto; }
  #brxe-udfzci .bricks-nav-menu-wrapper { display: none; }
  #brxe-udfzci .bricks-mobile-menu-toggle { display: block; }
}
@media (max-width: 991px) { #brxe-pmmkrh { padding-left: 36px; padding-right: 36px; } }
@media (max-width: 767px) { #brxe-pmmkrh { padding-left: 16px; padding-right: 16px; } #brxe-bhgfth { display: none; } }
@media (max-width: 478px) { #brxe-gdeklp { display: none; } }
```

## Tasks (test first; one commit per passing task; builder follows `figma-to-bricks` Step 2/3)

**T0 — Baseline (copy = main).**
- `npm run check` green.
- Save `corpus/report-v2.json` and every `corpus/out/v2/*/bricks.json` to `.superpowers/sdd/hero-media-row/base/` (`npm run corpus` first).
- Scratch-copy the main-folder debug file (never edit it) and `npm run replay -- <scratch>/debug.json .superpowers/sdd/hero-media-row/base/replay`.
- `npm run snap -- <scratch>/debug.json .superpowers/sdd/hero-media-row/shots/before --sides` (widths `1571,1366,990,768,600,480,375`).
- Run `evidence/hero-media-row/scripts/measure.mjs` on the base replay. It writes the per-width geometry the final task compares against.

**T1 — RED, part 3: `test/unit/normalise-broken-word.test.ts`** (new):

```ts
import { beforeEach, test } from "node:test";
import assert from "node:assert/strict";
import { convert } from "../../src/core/convert.ts";
import { settingsOf } from "../../src/core/emit/payload.ts";
import { normalise } from "../../src/core/normalise/normalise.ts";
import type { SceneNode } from "../../src/core/normalise/scene.ts";
import { column, frame, resetIds, row, snapshot, solid, text } from "../fixtures/builders.ts";

beforeEach(resetIds);
// a crumb drawn as a component without auto layout: its text box keeps the master's width, so Figma breaks a longer
// word inside itself and grows the box up and down (generic shape of a real breadcrumb)
const crumb = (word: string, boxW: number, textW: number, y: number, h: number) =>
  frame(`Crumb ${word}`, { width: boxW, height: 20 }, [text(word, { x: 0, y, width: textW, height: h, autoResize: "HEIGHT", fontSize: 13, lineHeight: 20 })]);
const page = (extra: ReturnType<typeof text>[] = []) => snapshot([frame("Page", { width: 1440, height: 900, fills: [solid("#FFFFFF")] }, [
  column("Top", { width: 1440, height: 900, padding: 80, gap: 24 }, [
    row("Crumbs", { gap: 8, align: "CENTER" }, [crumb("Home", 30, 30, -1, 21), crumb("Services", 47, 30, -11, 41), text("Current page", { fontSize: 13, lineHeight: 20 })]),
    ...extra,
  ]),
])]);
const find = (n: SceneNode, chars: string): SceneNode | null => (n.text?.characters === chars ? n : n.children.map((k) => find(k, chars)).find(Boolean) ?? null);

test("a single word Figma broke inside a too-narrow box is one line where a browser draws it, and flows like its neighbours", () => {
  const root = normalise(page()).pages[0].root;
  const s = find(root, "Services")!;
  assert.equal(s.absolute, false, "it flows in its crumb, as Home does");
  assert.ok(s.box.height < 30, `one line tall, got ${s.box.height}`);
  assert.equal(s.text!.words, null, "Figma's ink is of the broken lines, not the one a browser draws");
  const els = convert(page()).payload.content;
  const st = settingsOf(els.find((e) => settingsOf(e).text === "Services")!);
  assert.deepEqual([st._position, st._top], [undefined, undefined], "no longer placed 11px above its neighbours");
});

test("only a broken single word changes: real line breaks, words CSS breaks itself and fixed boxes keep their boxes", () => {
  const two = text("Hydraulic Cylinder", { width: 60, autoResize: "HEIGHT", fontSize: 13, lineHeight: 20 });
  const mail = text("service@examplehydraulics.com", { width: 60, autoResize: "HEIGHT", fontSize: 13, lineHeight: 20 }); // no hyphen: only the CSS-break exclusion keeps it
  const dot = text("●", { width: 8, height: 59, autoResize: "NONE", fontSize: 9, lineHeight: 9 });
  const root = normalise(page([two, mail, dot])).pages[0].root;
  assert.ok(find(root, "Hydraulic Cylinder")!.box.height >= 30, "two words on two lines stay two lines");
  assert.ok(find(root, "service@examplehydraulics.com")!.box.height >= 30, "a long address CSS breaks keeps Figma's lines");
  assert.equal(find(root, "●")!.box.height, 59, "a fixed box keeps its drawn height");
});
```

RED: `node --test test/unit/normalise-broken-word.test.ts`. The first test fails on `s.absolute === true` (or on `_position: "absolute"`, `_top: "-11"`); the second passes (characterisation).

**T2 — GREEN, part 3.**
- `src/core/normalise/text.ts`:
  - add `lineOf(t: TextData): number`, the line height formula now inside `oneLine` (`:178`); `oneLine` uses it;
  - add `cssBreaksWord(characters)`, moved from `style.ts:172`'s `longWord` test (length ≥ 24 and `[@/.]`); `style.ts:172` imports it, with no other change in `style.ts`;
  - add `brokenWord(n: SNode, t: TextData, h: number): boolean`: `autoResize === "HEIGHT"`, no rotation, `characters.trim()` has no whitespace and `longestWord(chars) === chars.trim()` (no hyphen/dash break), `!cssBreaksWord`, `h >= 1.5 * lineOf(t)`.
- `src/core/normalise/normalise.ts` (around `:108-123`): for a text, compute `text` before the node; if `brokenWord`, use `box = { ...box, y: box.y + (box.height - line) / 2, height: line }`, `size.height = line` and `text.words = null`. `ink` follows `box`.
- GREEN: T1 command passes, plus `npm test`.

**T3 — RED → GREEN, part 3 in Chrome: `test/browser/crumb-baseline.test.ts`** (new).
- Build T1's `page()` with `convert` + `renderPage` (as `test/browser/convert.test.ts` does).
- At 1440, 990, 600, 375, 360 and 320: the three crumb words' line boxes (`Range.getClientRects()`) have bottoms within 1px, and `scrollWidth === innerWidth`.
- RED on the T0 base is ≈ 11px; GREEN after T2.
- Mutation check (`mutation-testing-discipline`): revert `normalise.ts` with `git checkout HEAD~1 -- src/core/normalise/normalise.ts`, see it fail, restore.

**T4 — RED, part 1: fixture `test/fixtures/hero-pair.ts` + `test/unit/hero-pair.test.ts`** (new). The fixture builds generic pages from options, never this page's names or texts:

```ts
// A page whose first section is a hero holding words beside a framed picture, drawn as a 2-cell grid or a row
import type { SNode, Snapshot } from "../../src/core/snapshot/schema.ts";
import { column, frame, image, imageFill, place, resetIds, row, snapshot, solid, text } from "./builders.ts";
import { cta } from "./site-parts.ts";

export interface PairOpts { grid?: boolean; inHero?: boolean; wrapButtons?: boolean; bigButtons?: boolean; heading?: string; headingInk?: number }
export function words(o: PairOpts): SNode {
  const pills = o.bigButtons ? [cta("REQUEST A DETAILED REPAIR QUOTE TODAY", "Quote"), cta("CALL OUR EMERGENCY LINE NOW", "Line")] : [cta("CALL US NOW", "Call"), cta("CALL FOR AN EMERGENCY QUOTE", "Emergency")];
  return column("Words", { width: 757, gap: 15 }, [
    text("Service 01", { fontSize: 16 }),
    text(o.heading ?? "Hydraulic Cylinder Repairs", { width: 757, autoResize: "HEIGHT", fontSize: 68, lineHeight: 71, weight: 800, ...(o.headingInk ? { inkWidth: o.headingInk } : {}) }),
    text("If you are looking for reliable service and advice for your hydraulic cylinder, our team keeps your equipment running.", { width: 560, autoResize: "HEIGHT", fontSize: 18, lineHeight: 28 }),
    row("Buttons", { gap: 14, ...(o.wrapButtons === false ? {} : { layoutWrap: "WRAP" }) }, pills),
  ]);
}
export function media(): SNode {
  return frame("Media", { width: 505, height: 588, cornerRadius: 12, strokes: [solid("#FFFFFF", 0.1)], strokeWeight: 1 }, [image("Shot", { x: 18, y: 106, width: 469, height: 375, hash: "shot" })]);
}
export function pair(o: PairOpts): SNode {
  const w = words(o), m = media();
  if (!o.grid) return row("Pair", { width: 1312, gap: 50, align: "CENTER" }, [w, m]);
  place(w, 0, 105); place(m, 807, 0);
  return frame("Pair", { width: 1312, height: 588, layoutMode: "GRID", gridColumnCount: 2, gridRowCount: 1, gridColumnGap: 50, gridRowGap: 50,
    gridColumnSizes: [{ type: "FLEX", value: 1.2 }, { type: "FLEX", value: 0.8 }], gridRowSizes: [{ type: "FIXED", value: 588 }] }, [w, m]);
}
export function heroPairPage(o: PairOpts = {}): Snapshot {
  resetIds();
  const hero = column("Hero", { width: 1440, height: 748, padding: [80, 64, 80, 64], fills: [imageFill("hero-bg")] }, o.inHero === false ? [text("Welcome", { fontSize: 56 })] : [pair(o)]);
  const later = column("Later", { y: 748, width: 1440, height: 900, padding: [80, 64, 80, 64] }, o.inHero === false ? [pair(o)] : [text("More")]);
  return snapshot([frame("Page", { width: 1440, height: 2548, fills: [solid("#111111")] }, [hero, later, column("End", { y: 1648, width: 1440, height: 900, padding: 80 }, [text("End")])])]);
}
```

```ts
import { test } from "node:test";
import assert from "node:assert/strict";
import { convert } from "../../src/core/convert.ts";
import { settingsOf } from "../../src/core/emit/payload.ts";
import { heroPairPage, type PairOpts } from "../fixtures/hero-pair.ts";

// the pair is its section's only box, so it becomes the section's Container (no label): find it as the words' parent
const pairOf = (o: PairOpts) => {
  const els = convert(heroPairPage(o)).payload.content;
  const words = els.find((e) => e.label === "Words")!;
  return settingsOf(els.find((e) => e.id === words.parent)!);
};
const cols = (s: Record<string, unknown>) => ["tablet_portrait", "mobile_landscape", "mobile_portrait"].map((t) => s[`_gridTemplateColumns:${t}`]);
const dirs = (s: Record<string, unknown>) => ["tablet_portrait", "mobile_landscape", "mobile_portrait"].map((t) => s[`_direction:${t}`]);
const ONE = "repeat(1, minmax(0, 1fr))";

test("a hero's words and picture drawn as a grid keep their two columns on tablets and sideways phones; upright phones stack", () => {
  assert.deepEqual(cols(pairOf({ grid: true })), [undefined, undefined, ONE]);
});
test("drawn as a row they keep one line on tablets and sideways phones; upright phones stack", () => {
  const s = pairOf({});
  assert.deepEqual(dirs(s), [undefined, undefined, "column"]);
  assert.notEqual(s["_flexWrap:mobile_landscape"], "wrap"); // a Block gets an explicit nowrap there (rows.ts); a Div none
});
test("the same pair outside the hero is unchanged: it goes to one column on tablets (W-B still held)", () => {
  assert.deepEqual(cols(pairOf({ grid: true, inHero: false })), [ONE, undefined, undefined]);
});
test("a hero whose words can't hold their unwrapping buttons beside the picture still stacks on tablets", () => {
  assert.equal(cols(pairOf({ grid: true, wrapButtons: false, bigButtons: true }))[0], ONE);
});
test("in a kept hero a long-word heading steps down so its longest word fits its column, never below body size", () => {
  const els = convert(heroPairPage({ grid: true, heading: "Remanufactured Hydraulic Cylinders", headingInk: 718 })).payload.content;
  const h = els.find((e) => settingsOf(e).text === "Remanufactured Hydraulic Cylinders")!;
  const size = (t: string) => Number((settingsOf(h)[`_typography:${t}`] as Record<string, string> | undefined)?.["font-size"] ?? NaN);
  // main gives 51 here (its cap reads the whole 447px screen); the words column is at most 239px wide at 479, and a
  // 14-letter word at ≈0.47em a letter fits it only up to ≈36px
  assert.ok(size("mobile_landscape") >= 16 && size("mobile_landscape") <= 36, `sideways phone ${size("mobile_landscape")}`);
});
```

The planner already ran T1's and T4's code against main `b4ed333` from a scratch copy: tests 1, 2 and 5 failed for exactly the reasons below, and the controls passed (`evidence/hero-media-row/red-on-main/result.txt`).

Command: `node --test test/unit/hero-pair.test.ts`. Expected RED:
- tests 1, 2 and 5 fail (tablet is `ONE`, the row has `"column"` at tablet, landscape size 51 > 36);
- tests 3 and 4 pass (controls).

If test 5's tablet/class arrangement differs (a class carries the size), read the size through the class the element uses rather than weakening the assertion.

**T5 — GREEN, understand: mark the pair.**
- `src/core/understand/ir.ts`: optional `heroPair?: { media: 0 | 1 }` (optional, so no constructor changes).
- `src/core/understand/recognise.ts`:
  - `pairOf(n)`: row, or grid with 2 columns and 1 row, exactly 2 `flowKids`, worded + pictured, reusing the existing predicates;
  - `splitRow` = `pairOf` limited to rows, behaviour unchanged;
  - `markHeroPair(hero)`: exactly one `pairOf` in the hero section (skip `copy:` keys) gets the mark.
- `src/core/understand/phone.ts:74-86` (where hero splits are marked): call `markHeroPair(hero)` when `hero` is non-null.
- GREEN check: `npm test` is still green, and the T4 tests are still red. Commit.

**T6 — GREEN, adapt: keep the pair.**
- New `src/core/adapt/hero-pair.ts` (< 120 lines, one purpose): `pairKeeps(n, inner, tier, d)`. It implements (a)–(d) above.
  - Shares: grid → `(inner − gap) / 2` each; row → drawn widths × `(inner − gap) / (sum of drawn)`.
  - Shown buttons: walk the words cell; skip `show === "desktop"` at `mobile_landscape`; a row with `wraps(row)` counts `max(least(c, tier, true))` over its items, others `least(row, tier, true)`.
  - Reading: `reading(textNode, tier)` from `least.ts`.
  - Body fit: `facts.wordCapIn(text.src, wordsShare) >= BODY` for each text.
  - Returns `false` at `mobile_portrait` and for unmarked nodes.
- `src/core/adapt/least.ts`: export `reading` on `Least` (interface + return object; 2 lines, behaviour unchanged).
- `src/core/adapt/shapes.ts`:
  - `ShapeDeps` gains `facts` and `reading`;
  - `decideRow`, after the list check (`:115`): `if (pairKeeps(n, room, tier, d)) return "keep";`;
  - `gridColumns`, first line: `if (pairKeeps(n, inner, tier, d)) return before;`.
- `src/core/adapt/layout.ts`:
  - pass `facts`/`reading` into `shapesOf` (`:55-57`);
  - record a key set for the words cell's subtree where the pair is kept (`row === "keep"` or columns = 2 at a tier);
  - expose `inHeroPair(n, tier): boolean` on `Layout`.
- `src/core/adapt/facts.ts` (additive):
  - `inkCharWidth(n)`: one-line → `charWidth(n)`. Several lines with known `words` → for each contiguous run of words taken as the widest line, `c = words / (size × run length)`; accept the run when greedy wrapping at `c` over the box width reproduces Figma's line count (`round(box.height / lineOf)`) and that run as its widest line. Else `charWidth(n)`. Then × 1.08.
  - `wordCapIn(n, room) = floor(room / (longestWord.length × inkCharWidth(n)))`, a `PageFacts` member.
- `src/core/adapt/rules/type.ts`:
  - `want(tier)` = `min(textSize(...), max(BODY, wordCapIn(t, ctx.layout.room(n, tier))))` where `ctx.layout.inHeroPair(n, tier)`;
  - add `css: ["overflow-wrap: break-word"]` at the first tier `inHeroPair` holds, unless `breaks` already writes `anywhere` there.
- GREEN: `node --test test/unit/hero-pair.test.ts`, then `npm test`. Fix only the plan's listed pinned tests (T9). Any other failing test: stop and name the assertion (builder rule).

**T7 — Mutation checks.** On the committed fix, for each of these, revert and see the named test go red, then restore:
- `pairKeeps` returning `false` → T4 tests 1 and 2;
- the `show === "desktop"` skip → T4 test 1 (landscape needs the band rule);
- the type cap → T4 test 5;
- `brokenWord` returning `false` → T1.

**T8 — Browser: `test/browser/hero-pair.test.ts`** (new). `heroPairPage({ grid: true, heading: "Remanufactured Hydraulic Cylinders", headingInk: 718 })` and the row variant, rendered through `convert` + `renderPage`.

At the widths below, `scrollWidth === innerWidth` everywhere, and:
- **1440, 1366, 1300, 1200, 1100, 1024, 992:** words left, media right (as on main).
- **990, 900, 768, 767, 600, 480, 479:** media `left >= words.right`, their vertical ranges overlap. The heading `scrollWidth <= clientWidth + 1` and its right edge ≤ the words column's right + 1. The heading's line count < its word count (no line per word). The `Shot` picture is ≥ 80px wide and inside the media box (not clipped).
- **478, 390, 375, 360, 320:** media `top >= words.bottom` (stacked).

RED on the base copy; GREEN after T6.

**T9 — Update the tests that pin the old outcome** (allowed edits only):
- `test/unit/adapt-rows.test.ts:32-42` builds its "Split" photo/text row in the page's first section (a hero beside its photo), asserting it stacks at `mobile_landscape`. Move that row into section "B" (the `pageWith` second section) so it keeps testing an ordinary photo/text row. Keep every assertion unchanged.
- `test/unit/adapt-split.test.ts:27-36` is tier-agnostic and should stay green (the hero now stacks at `mobile_portrait`, still `column-reverse`). Edit only if it fails, and then only to assert `mobile_portrait` explicitly.

**T10 — Real files and gates.**
- Replay the scratch debug copy into `.superpowers/sdd/hero-media-row/after/replay`. Run `measure.mjs` and compare with T0 at 1571, 1366, 1300, 1200, 1100, 1024, 992, 990, 900, 768, 767, 600, 480, 479, 478, 390, 375, 360 and 320:
  - **Hero:** side by side 479–990, stacked ≤ 478. At ≥ 992 every hero element's rect is equal to base ±1px (no laptop change). Expected: the debug H1 cap doesn't bind, so laptop type is identical. Explain any difference, measure each changed row's right edge against main's.
  - **Crumb:** one baseline at every width.
  - **Page:** no sideways scroll at any width, including 375/360/320.
- Diff the base and after `bricks.json` by element id. Only the hero subtree, the crumb, and (if any) type sizes change. List every changed id in the ledger.
- `npm run corpus`, then `cmp` all five pastes with T0's. Expected **byte-identical** (no corpus file has a hero pair or a broken single word). Diff the lint lines and the "Worse than v1" list.
- `npm run check`; at the merge also run `npm run test:browser`.
- `npm run snap -- <scratch>/debug.json .superpowers/sdd/hero-media-row/shots/after --sides` (same widths). Copy the hero and crumb pairs at 990, 768, 600 and 375 to `~/.hermes/plans/figma-to-bricks/shots/hero-media-row/` as `before-hero-990.png`, `after-hero-990.png`, … Never commit them.

**T11 — Part 2 hand-off (no code).**
- Put the CSS block above, with numbered steps, in HANDOFF under this feature:
  1. Bricks → Templates → your Header → select the header Section → Style → CSS → Custom CSS → paste → Save.
  2. LiteSpeed → Purge All.
- Copy `evidence/hero-media-row/scripts/header-fix-probe.mjs` + `toggle-probe.mjs` references into the ledger for the checker.
- The checker verifies live after Justin saves:
  - logo ≥ 150px wide at 1728/1366/1280/1279/1024/990/768/600/480/375/320;
  - phone one line where shown;
  - button one line;
  - links shown at ≥ 1280, menu button below;
  - the menu opens at 1200/990/600;
  - no sideways scroll at any width.

**T12 — Docs & records:** the closing section of this plan.

## Tests and widths (summary)

- Unit: `normalise-broken-word.test.ts` (new), `hero-pair.test.ts` (new), `adapt-rows.test.ts` (moved case). Plus the whole `npm test`.
- Browser: `crumb-baseline.test.ts` (1440/990/600/375/360/320) and `hero-pair.test.ts` (1440, 1366, 1300, 1200, 1100, 1024, 992, 990, 900, 768, 767, 600, 480, 479, 478, 390, 375, 360, 320).
- Real file: debug replay at the same widths (geometry, sideways scroll, picture clipping, text clipping lint). Corpus `cmp` byte-identical.
- Laptop widths 1366/1300/1200/1100/1024/992: hero rects equal to main. Phone widths 375/360/320: no sideways scroll, stacked hero.

## Choices I made

- **Hero only, found from structure:** `heroOf` + one words/picture pair (row or 1-row 2-cell grid). Nothing keyed to names, texts or pixels.
- **Floors reuse Justin's numbers:** `ALONE_MIN` 160/120 for the picture; reading floor of 3 words; body size 16 for headings.
- **The plan stays conservative:** equal cells for the grid decision and for the heading cap. CSS gives the words 1.2fr, about 20% more room than the plan counts.
- **Hero buttons on sideways phones still move to the band under the hero** (Justin's 2026-10-01 phone rule). At 600px the hero shows words + picture; the buttons follow below it.
- **The picture frame hugs its picture beside the words,** vertically centred. It isn't stretched to the words' height. Measured, it stays near its drawn square (≈ 348×294 at 990).
- **The broken-word fix keeps the middle of Figma's box** and doesn't guess the word's width (the crumb holder already has the right 47px).
- **Part 2 delivered as CSS, not Bricks UI steps:** one paste, exact, already tested in Chrome. Uses his template's element ids, which are stable while the template exists.

## Risks

1. **Width estimates.** The heading cap uses letter-width estimates, not real fonts. Mitigation: ink-based estimate + 8%, the conservative plan width, the `overflow-wrap: break-word` backstop, and the Chrome tests at 990–479.
2. **The live site uppercases every heading.** Its theme style sets `h1–h6 { text-transform: uppercase }` (`theme-style-global.min.css`); Figma draws Title Case. Uppercase is wider than the plugin plans. At 768 on the live site, "HYDRAULIC CYLINDERS" at 52px is 409px against a 389px column. If the cap doesn't bind, the heading may show one word per line there. That's site state; the paste check must tell this apart from a plugin fault (measure with the theme rule, then with it disabled locally).
3. **Laptop type** changes only where the new tablet cap binds (the fluid slide then ends at the new tablet size). Expected none on the debug file; T10 measures 1366–992.
4. **No Figma export of the Remanufactured page exists.** Evidence is the sister Repairs design plus a generic Remanufactured-shaped fixture; the live paste check closes it.
5. **Shared files.** `shapes.ts`/`least.ts`/`layout.ts` are read by found-layout and may be edited by found-tiles (Tiles-B). The hooks are small and additive; rebase and re-run gates (see Overlaps).
6. **Header CSS:** if Justin rebuilds his header template, the ids change and the block stops applying. Bricks' own mobile menu JS opens at any width (tested at 1200/990/600), but the installed builder preview may show it differently than the front end.

## Touches (exact allowlist)

- **Source:** `src/core/normalise/text.ts`, `src/core/normalise/normalise.ts` (text box block near `:108-123`), `src/core/style/style.ts` (`:172` only: import the shared `cssBreaksWord`), `src/core/understand/ir.ts` (optional field), `src/core/understand/recognise.ts`, `src/core/understand/phone.ts` (one call near `:85`), `src/core/adapt/hero-pair.ts` (new), `src/core/adapt/shapes.ts` (deps + two hooks), `src/core/adapt/layout.ts` (wiring + `inHeroPair`), `src/core/adapt/least.ts` (export `reading` only), `src/core/adapt/facts.ts` (additive `inkCharWidth`, `wordCapIn`), `src/core/adapt/rules/type.ts`.
- **Tests (new):** `test/fixtures/hero-pair.ts`, `test/unit/hero-pair.test.ts`, `test/unit/normalise-broken-word.test.ts`, `test/browser/hero-pair.test.ts`, `test/browser/crumb-baseline.test.ts`.
- **Tests that pin the old behaviour (may edit as stated):** `test/unit/adapt-rows.test.ts:32-42` (move the row out of the hero), `test/unit/adapt-split.test.ts:27-36` (only if red; assert `mobile_portrait`). `test/unit/adapt-grid.test.ts` must not change: its grids aren't hero pairs.
- **Docs:** `docs/plans/2026-10-22-hero-media-row.md`, its ledger, `docs/HANDOFF.md`.
- **Read-only:** everything else, the main-folder debug JSON (copy only), the live site (GET only).

## Overlaps

- **found-layout (reviewing).** It edits `nudge.ts`, `place.ts`, `style.ts` (turnedLength block) or `sizing.ts`, and `upright.ts`; `shapes.ts`/`layout.ts`/`least.ts` are read-only for it.
  - Shared source: `style.ts`, different block (`:172` here), a textual rebase only.
  - Behaviour: my hooks change shapes/layout only for a marked hero pair, so its rows and fixtures are unaffected. No shared tests.
  - Order: either; if both are ready, found-layout first, then this rebases.
- **found-tiles (reviewing).** Tiles-A (past-edge, scene, compose, emit/settings): no overlap. Tiles-B may edit `least.ts keeps()` and `shapes.ts firmAt` (its Q2B/item 6) plus `kinds.ts`/`unpin.ts`: same files, different functions. Order: tiles first if it touches `shapes.ts`/`least.ts`; this rebases (small hooks).
- **found-list-head (queued).** `lists.ts`, `list-links.ts`, `rules/list.ts` and its tests: no overlap. My `decideRow` hook sits after the list check, so list rows never reach it.
- **W-B (held).** Same grid (553:7783); kept hero-only (Q3 A), so the Bento grid and 553:7606 stay as they are. If W-B is later adopted, the hero's own button check becomes redundant but compatible.
- **hero-photo-blend (merged).** Same hero; its picture filter/shadow on the cut-out is untouched.

## Skills (for the build)

- `engineering-best-practices`, `test-driven-development`, `systematic-debugging` (surprise failures), `mutation-testing-discipline` (T3/T7).
- `frontend-ui-repair`: **carries the Agent Defect Loop**. The finisher stops before the merge until a fresh VERIFIER comes back clean.

## Other things found (not fixed; also in `found_else`)

1. **Medium:** `/remanufactured-hydraulic-cylinders/` redirects to the media file `…/2026/10/remanufactured-hydraulic-cylinders.avif`, and the Services card's arrow links there (replay warning). The live page is `/remanufactured-hydraulics-cylinders-final/`. Media-rename / page-link area.
2. **Medium-low:** the site's theme style uppercases every h1–h6, while the Figma design is Title Case. Live headings are about 20% wider than the plugin plans.
3. **Low:** the plugin's own header (used when "site already has its header" is unticked) splits at tablet into three rows. Plan row `div.wrap 553:8036` is "two" at tablet, "stack" at landscape (replay `main-990.png`).
4. **Low:** `heroOf` counts only flex rows as "beside" pairs (`recognise.ts:145-155`), so a hero drawn as a 2-cell grid without a photo behind isn't a hero (no phone band, no pair keep).
5. **Low:** `charWidth`'s 0.72 em/letter fallback for multi-line capitals (`facts.ts:50-56`) is about 55% too wide for condensed fonts (Saira Condensed ≈ 0.465). `type.ramp` shrinks such headings on phones more than needed.
6. **Info:** in Figma the "Services" crumb text itself shows broken over two lines (its component master is 30px wide). Designer-side; the paste now draws it as a browser would.

## T12 — Docs & records (Justin's standing ask; the FINISHER completes the merge items)

- Plan copied to `docs/plans/2026-10-22-hero-media-row.md`; ledger `.superpowers/sdd/hero-media-row/progress.md` moved to `docs/plans/2026-10-22-hero-media-row-ledger.md`.
- `docs/HANDOFF.md`: new section "Hero words and picture side by side on tablets (build …)", with root causes, the header CSS block, Justin's steps and **paste check owed: the next free number on main at merge time** (3ba/3bb/3bc are taken as of now, so likely 3bd; renumber if a parallel merge took it).
- Paste check content: re-convert and paste the Remanufactured page (and the Repairs page, same template). Measure live:
  - 990/768/600: words left, picture right;
  - 375: stacked;
  - crumbs on one baseline at 1571/990/600/375;
  - the header numbers of T11.
- `BUILD` bumped at merge (`src/shared/build.ts`, `YYYY-MM-DD.N`).
- Main `CLAUDE.md` "Start here" + "Where things stand" updated after the merge (FINISHER).
- New `CLAUDE.md` decisions (as chosen):
  - "the hero's words and picture stay side by side on tablets and sideways phones; upright phones stack (Q1A–Q3A)";
  - "a word Figma broke inside a too-narrow box is one line (normalise)".
- `references/rules-summary.md` updated with the hero rule (≤ 11 KB).
- `found-else.md`: append the "Other things found" items above.

Justin's steps after the merge:
1. Reload the plugin in Figma.
2. Convert and copy the Remanufactured page (and Repairs) and paste each into Bricks, then save.
3. Bricks → Settings → Custom code → Regenerate code signatures (the paste holds the header-room script).
4. Header template: paste the CSS block (T11 steps).
5. LiteSpeed → Purge All.
6. Reply *pasted Remanufactured*.

## Ownership clarification — dispatcher, 2026-10-22

Approved narrow test-scope exception after inspecting `test/unit/adapt-rows.test.ts:64–77`: its Split fixture currently qualifies as a hero and asserts landscape stacking, which directly contradicts the approved hero-only keep-row change. The builder may relocate only Split into a non-hero section B, preserving the existing stacking assertion and every Icons/Tags/Cards control. Add or retain explicit hero tablet/landscape keep-row and portrait-stack positive assertions in hero-pair tests. Do not narrow production recognition to evade the old assertion. All other allowlist restrictions remain.

## Acceptance clarification approved by Justin — 2026-10-22

- Hero heading: **Allow three readable lines; never split words.** T8's universal `lines < 3` requirement is replaced by complete-word line/containment checks at the existing widths, retaining meaningful readable-size, column-fit and no-overflow assertions. No phrase-fitting policy or extra shrinking is requested.
- Breadcrumb: **Allow wrapping; align items within each row.** T10's universal no-wrap requirement is replaced by baseline alignment per visual row, contained/non-overlapping ink and no sideways scroll. The desktop Services baseline fix remains required. Preserve portrait controls and no clipping.
- These choices permit narrowly aligning tests and records; they do not waive independent review, verifier, fonts, other project gates or release holds.

## Justin's answers (2026-10-22)
- Clarified the main ask with two screenshots (desktop hero = correct; tablet hero = picture frame drops below the buttons): Part 1 is the job — on tablet portrait and mobile landscape the picture frame stays on the right of the text column, like desktop. The header screenshot was only for the added Part 2.
- Keep both extra fixes in this job (Part 2 header CSS block, Part 3 breadcrumb).
- Sideways phones (≤767px): keep today's rule — hero buttons move to the band under the hero; text + picture stay side by side above it (matches the plan as written).
- Q1–Q6: "go" → all ⭐ (Q1A Q2A Q3A Q4A Q5A Q6A). Builder on Opus 5.5 xhigh (big).
- Model: Justin picked ChatGPT Sol 6.1 xhigh for the whole pipeline (Claude at 90% of 5h window). Disk 2.2 GiB: build anyway, builder stops safely if low.

## Release decision (Justin, 2026-10-22)
- Verifier-2 CLEAN on 735e725. Justin chose "Release: mark Garamond UNVERIFIED, merge + build + push": Garamond Condensed gate released as UNVERIFIED — pre-existing on main, no stand-in, expected set not narrowed (this release only).

## Release completed — October 22, 2026
- **Merged and pushed BUILD2026-10-22.9**, personal build commit `824bb71f98ad5ae845ff28a566dfad51d3b1f588`. Final source candidate735e725/base93a5d7a unchanged; documentation-only release commit98a1bbe, then ff-only main integration and BUILD-only bump.
- Final exact-tip reruns: Node22.22.0 check2230 unit/rule+6 performance and full browser352/352 pass, no failures/skips/cancellations. Main stayed93a5d7a until merge; no rebase needed. Existing same-base corpus remains actual exits1/1, same18 pre-existing identities, not completeness green. **HMR-R1/HMR-R2/HMR-V1 CLOSED** by independent verifier-2 CLEAN; all unrelated found_else findings remain open.
- **Garamond Condensed UNVERIFIED — pre-existing on main, no stand-in, expected set not narrowed**, this release only. Installed Bricks/header-template save/live acceptance remains unverified.
- Completed merge lock proc_5ca7da630f66 exit0 with owner/ref readback; next free main paste check **3bg** allocated, preserving3bd/3be/3bf. After push, main==origin/main==remote refs/heads/main at824bb71. Actual dist code.js/ui.html reproduce exact in-memory builds, SES clean. Own lock released/read back absent immediately afterward.
- Older main CLAUDE backlog still21.12: exact Start here/Where things stand/new decisions/build-last edits preserved in `hero-media-row-claude-md-pending.md`, apply after older files through22.8. No main CLAUDE write attempt, denial retry or bypass. Rules-summary updated through skill_manage with new hero/broken-Latin-word rules; deep core constraints moved to a linked reference to keep summary compact.
- Own worktree/merged branch removed; no orphan own Chrome roots.222 leftover .superpowers files moved/hash-preserved under `~/.hermes/backups/figma-worktree-leftovers/hero-media-row-20261022-145800`. Main debug SHA unchanged and uncommitted. Exact release/runtime/archive/dist/ref/cleanup receipts: `evidence/hero-media-row/release/`.
- **Paste3bg owed:** reload Figma plugin, Convert/copy Remanufactured Hydraulic Cylinders (and Repairs), paste/save Bricks, regenerate code signatures, save the plan's verbatim header CSS block into Header Section custom CSS, LiteSpeed Purge All, reply **pasted Remanufactured**. Check990/768/600 kept hero/whole words, portrait stacking, desktop Services baseline and990 header logo/single-line phone+button. No agent site writes.
