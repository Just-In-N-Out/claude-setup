# quote-button-hover: no light ring on "Get Your Free Quote" (B-Dry Home paste)

Mini plan, 2026-10-29 19:06 EDT. Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/quote-button-hover/planner/`
(`states.json`, `probe-states.ts`, `probe-paste.ts`, state shots `ours-*.png` / `bdryswi-*.png`, captured Bricks CSS).
Paste-only job: **no plugin or repo change, no BUILD bump, no commit in the worktree.**

## Questions (⭐ = taken under Justin's "go with the recommended")

- **Q1. After a mouse click (pointer moved off, page not yet gone), should the button stay orange, as bdryswi.com does?**
  - **A ⭐ Yes, copy bdryswi.com:** orange under the pointer *and* while it has focus (`:hover, :focus`). Keyboard focus is
    orange too (`:focus` covers it).
  - B No: orange only under the pointer and on keyboard focus (`:hover, :focus-visible`, as v4); after a click it goes
    back to white once the pointer leaves.
- **Q2. Keyboard focus ring.** bdryswi.com draws a 1px dotted rgb(0,71,116) outline on focus (after Tab, and after a mouse
  click), which is dark blue on a dark-blue band: almost invisible. The website rules want a visible ring for keyboard
  users only.
  - **A ⭐ Keep Bricks' own keyboard-only ring** (`body.bricks-is-frontend :focus-visible { outline: auto }`, Chrome
    draws a dark ring with a white edge, see `planner/ours-keyboard-focus.png`). Mouse and touch never see it. The paste
    adds nothing for it. bdryswi's dotted mouse-focus outline is not copied.
  - B Copy bdryswi.com exactly (1px dotted rgb(0,71,116), keyboard and mouse): matches the source but breaks the
    website rule (keyboard users can barely see where they are).
  - C Our own 2px white ring, 2px out, keyboard only: more visible than A but adds a white ring Justin may see when he
    tabs and read as the same bug.
- **Q3. How the four jobs on this paste (this one, `services-band-speed`, `sixty-years-marker`, `fee-band-photo`) land in
  one next version.**
  - **A ⭐ One patch module per job + one shared v5 builder** (section "Landing in v5" below): each job's patch asserts
    the exact v4 values it replaces, declares what it touches, and `build-v5.ts` applies every listed patch to v4 and
    refuses any two that touch the same element or class.
  - B One version per job in a queue (v5, v6, v7, v8): no clash logic, but serial and three re-pastes.
  - C One combined builder for all four jobs: one agent, but one failure holds up all four.

## Playback

On our staging Home ("Schedule A Consultation" band, `/homev2/`), the orange "Get Your Free Quote" pill shows a light,
almost white 3px ring when Justin points at it or clicks it. On bdryswi.com the same button is the orange pill with no
visible ring. Make ours look like bdryswi.com in every state (rest, hover, pressed, after a click, keyboard focus),
keeping a ring that only keyboard users see. Fix it in a new paste version (never v4 in place) and hand Justin one file
with the header and the whole Home page, as he pastes it now.

## Root cause (measured, Chrome 156 at 1440, both live pages, 2026-10-29)

1. **The paste gives the button a border with no colour.** v4's element `byywvz` ("Quote button") has
   `_border: {width: 3/3/3/3, style: "solid", radius: 28}` and no `color`
   (`evidence/bdry-paste/v4/scripts/build-v4.ts:131`; the only element in the whole pasted file with a border style and
   no colour, `planner/probe-paste.ts`).
2. **Bricks 2.3.9 then writes Bricks' default grey on the element's id.** Live `post-155.min.css` (captured as
   `planner/post-155.min.css`): `#brxe-fqkzpd {… border: 3px solid var(--bricks-border-color); border-radius: 28px; …}`,
   and Bricks' `frontend-light-layer.min.css` sets `--bricks-border-color:#dddedf`. With a colour Bricks writes it in
   the same shorthand (`border: 2px solid #FFFFFF`, 6 times in the same file).
3. **An id beats the class.** `home-quote`'s `border-color: #004774` (`.brxe-button.home-quote`, 0-2-0) and its hover
   (`:hover`, 0-3-0) lose to `#brxe-fqkzpd` (1-0-0). Computed border on ours is **rgb(221,222,223) in every state**
   (`planner/states.json` → `ours`): a light grey ring around the white pill at rest and around the orange pill under the
   pointer (`planner/ours-hover.png`, matches Justin's `screens/1-ours-hover.png`). v4's comment
   (`build-v4.ts:55-57`) knew colours on `#brxe-` beat a class, but `_border`'s width/style alone also writes a colour.
4. **Not the site, not the plugin's focus ring.** No Theme Style or global rule sets this colour; the plugin's
   `focus-ring` class is only on the header section (`#brxe-tgcodr`), not an ancestor of the button; no box-shadow or
   outline is drawn on ours in any mouse state (outline-style none). So the fix is in the paste.
5. **Why v4's checks passed:** the repo's renderer writes no colour for a `_border` without one
   (`test/browser/render.ts:57-66`), so `after-faq-render.test.ts:291` saw the class's rgb(0,71,116). Recorded as
   found_else, not fixed here.

**bdryswi.com's button** (Elementor, footer template 35, widget `58a7a74`), computed at 1440:

| State | Background | Border (all sides) | Outline drawn | Box-shadow |
|---|---|---|---|---|
| rest | rgb(255,255,255) | 3px solid rgb(0,71,116), radius 28px | none | none |
| hover | rgb(255,179,86) | same | none (`a:hover{outline:0}`) | none |
| pressed (held) | rgb(255,179,86) | same | none | none |
| clicked, pointer still on it | rgb(255,179,86) | same | none | none |
| clicked, pointer moved off | rgb(255,179,86) (its `:hover, :focus` rule) | same | 1px dotted rgb(0,71,116) (`a:focus`) | none |
| keyboard focus | rgb(255,179,86) | same | 1px dotted rgb(0,71,116), offset 1px | none |

Text rgb(0,71,116), transition 0.3s in all states, on both sites. The border never changes colour on bdryswi.com; on its
dark-blue band it simply can't be seen, which is why it looks borderless.

## The fix (in the paste, two values)

1. Element `byywvz`: `_border` becomes
   `{"width":{"top":"3","right":"3","bottom":"3","left":"3"},"style":"solid","color":{"raw":"#004774"},"radius":{"top":"28","right":"28","bottom":"28","left":"28"}}`
   (Bricks then writes `border: 3px solid #004774` on the id, in every state, as bdryswi.com draws it; `{raw}` is the
   colour shape this paste already uses for typography, and Bricks' own sample `reference/bricks/hero-video-buttons.json`
   uses it in `_border.color`).
2. Class `rxumcp` (`home-quote`) `_cssCustom` becomes (border lines dropped: the id owns the border now; Q1 A: `:focus`):
   ```css
   .brxe-button.home-quote {
     background-color: #FFFFFF;
     transition: all 0.3s;
   }
   .brxe-button.home-quote:hover,
   .brxe-button.home-quote:focus {
     background-color: #FFB356;
   }
   @media (prefers-reduced-motion: reduce) {
     .brxe-button.home-quote {
       transition: none;
     }
   }
   ```
   Keyboard ring: nothing added (Q2 A, Bricks' own `:focus-visible { outline: auto }`). A mouse click on a link doesn't
   match `:focus-visible` in Chrome (measured: `focusVisible:false` after a click), so mouse users see no ring.

## Landing in v5 with the other three jobs (Q3 A)

- **Input:** `evidence/bdry-paste/v4/home-paste-v4.json` sha256 `0a9c9d07e5576419f533246f9231198568c4ba4e689303f51f3a8914dc383324`
  and `evidence/bdry-paste/header-v1/header-paste.json` sha256 `f48783e50da30d89d963d60e57b372d3cfb31f3e416c9927e5b0b8cbf96bba3e`,
  read-only. `after-faq-sections` is still verifying v4: if v4's sha has changed when you start, use the new v4 only if
  this patch's preconditions still hold, and record both shas; never edit v4, its scripts or its evidence.
- **Each job ships a patch module** in its own evidence folder with this interface (tell the other jobs' builders, via
  the orchestrator, to use the same):
  ```ts
  export const name: string;                                   // the job name
  export const touches: { elements: string[]; classes: string[] }; // ids it changes, adds or removes
  export function apply(paste: any): void;                     // mutates the given copy; throws unless every value it
                                                               // replaces is exactly v4's
  ```
- **One shared builder** `evidence/bdry-paste/v5/scripts/build-v5.ts`: reads v4 and header-v1, applies the patch modules
  listed one absolute path per line in `evidence/bdry-paste/v5/patches.txt` (in that order) to a deep copy of v4, and
  after each `apply` diffs before/after: the element and class ids it actually changed, added or removed must equal its
  `touches`, and no id may appear in two patches' `touches` (it exits non-zero naming both). It writes
  `v5/home-paste-v5.json`, `v5/bdry-home-with-header-v5.json` (the `compose` below) and `v5/manifest.json`
  (input shas, each patch's name and sha256, output shas, element/class counts).
- **Whoever gets there first** creates `v5/` (builder, `compose.ts`, empty `patches.txt`); later jobs only append their
  line with the Edit tool after reading the file fresh. Re-running `build-v5.ts` is safe and deterministic, so the last
  job's finisher builds the v5 Justin pastes. A job that isn't ready simply isn't listed yet.
- This job's patch touches only element `byywvz` and class `rxumcp` in the consult band; the other three name other
  bands, so no overlap is expected; `build-v5.ts` proves it.

## Acceptance criteria (all **proposed**; Justin gave none)

Rendered states below come from a page that writes the button's `#brxe-` rule exactly as Bricks 2.3.9 does (calibrated
against the live `post-155.min.css`) with Bricks' real `frontend-light-layer.min.css`; the bdryswi.com values are the
captured fixture (table above).

- AC1 (proposed): At rest the patched button's computed border (3px solid rgb(0,71,116) on all four sides, 28px radius), drawn outline (none), box-shadow (none), background rgb(255,255,255) and text rgb(0,71,116) equal bdryswi.com's rest values. Test: `quote-states: rest matches bdryswi.com`
- AC2 (proposed): Under the pointer the patched button's border, drawn outline, box-shadow, background (rgb(255,179,86)) and text colour equal bdryswi.com's hover values. Test: `quote-states: hover matches bdryswi.com`
- AC3 (proposed): Pressed (mouse held), and after a click with the pointer still on it, the patched button equals bdryswi.com's values; after a click with the pointer moved off, its background, border and box-shadow equal bdryswi.com's and no outline is drawn. Test: `quote-states: pressed and clicked match bdryswi.com`
- AC4 (proposed): When Tab reaches the button it is orange with the same border and a drawn focus outline (style not none, width > 0 or auto), and in no mouse state (rest, hover, pressed, clicked on or off) is an outline or box-shadow drawn. Test: `quote-states: focus ring only for the keyboard`
- AC5 (proposed): Applying the patch to v4 changes exactly two values, element byywvz's `_border` (gains `color: {raw: "#004774"}`, width/style/radius unchanged) and class rxumcp's `_cssCustom`; every other element, class and top-level key is byte-identical to v4, and `apply` throws on an input whose button or class differ from v4's. Test: `quote-paste: only the quote button's border colour and its class change`
- AC6 (proposed): The composed paste stays valid: `bdry-paste/check.ts` prints payloadProblems [], placeholders 0 and css naming another id 0 (v4's composed file today: the same three), with no duplicate element ids, class ids or class names, and every element whose `_border` sets a style also sets a colour. Test: `quote-paste: composed file is a valid Bricks paste`
- AC7 (proposed): One file to paste: `compose(header-v1, v4)` reproduces Justin's pasted `bdry-home-with-header.json` byte for byte (sha256 9070659e…), and the delivered files are `compose(header-v1, patched v4)` and `compose(header-v1, v5 home)`. Test: `compose: header plus home reproduces the pasted file`
- AC8 (proposed): `build-v5.ts` applies this patch with any others listed, each patch's actual changes equal its declared touches, two patches touching one id stop the build, and v5's quote button and class equal this patch's output. Test: `build-v5: patches change only what they declare and never overlap`
- AC9 (proposed) (live): After Justin pastes the new file on /homev2/, Chrome at 1440 on `https://bdry.staging.growithgro.com/homev2/?f2b=<random>` measures the button's border rgb(0,71,116) at rest, under the pointer and pressed (no rgb(221,222,223) anywhere), and Justin sees no light ring when he points at or clicks it. Test: `live: probe-states.ts on staging after the paste`

Each of AC1–AC3 fails on v4 (border rgb(221,222,223)); the verifier runs them on v4 to show it.

## Files (all outside git, in `~/.hermes/plans/figma-to-bricks/evidence/`)

`E = ~/.hermes/plans/figma-to-bricks/evidence`, `Q = E/quote-button-hover`.

- New: `Q/patch/quote-button-hover.ts`, `Q/scripts/bricks-css.ts`, `Q/scripts/states-page.ts`, `Q/scripts/build-quote.ts`,
  `Q/test/quote-paste.test.ts`, `Q/test/quote-states.test.ts`, `Q/test/fixtures/` (copies:
  `bdryswi-states.json`, `frontend-light-layer.min.css`, `post-155.min.css`), `Q/out/home-paste-v4-quote.json`,
  `Q/out/bdry-home-with-header-quote.json`, `Q/shots/`, `Q/manifest.json`.
- New or extended (shared): `E/bdry-paste/v5/scripts/compose.ts`, `E/bdry-paste/v5/scripts/build-v5.ts`,
  `E/bdry-paste/v5/patches.txt`, `E/bdry-paste/v5/test/build-v5.test.ts`, `E/bdry-paste/v5/manifest.json`.
- Read only: v4, header-v1, `E/bdry-paste/check.ts`, `/mnt/c/Users/Admin/Downloads/bdry-home-with-header.json`, the repo's
  `test/browser/chrome.ts` (import it from `/home/justin/Documents/FigmaToBricksV2/test/browser/chrome.ts`).

## Tasks (test first; run each test file as one plain command)

Environment (from the memory note "Checks on the desktop"): Node `/home/justin/.local/node-v22.23.3/bin/node`; Chrome
via `process.env.CHROME_PATH = "/home/justin/.cache/chrome-for-testing/chrome-f2b"` set inside the script before
`launchChrome()` (see `planner/probe-states.ts`, which already does this and works). Tests run with
`<node> --test <file>`; a browser test counts only when its output says `skipped 0`.

**T0. Fixtures.** Copy `planner/states.json`'s `bdryswi` object to `Q/test/fixtures/bdryswi-states.json`, and
`planner/frontend-light-layer.min.css`, `planner/post-155.min.css` to `Q/test/fixtures/`. Record sha256 of v4, header-v1
and the Downloads file in `Q/manifest.json` (`inputs`). Optional: re-run `planner/probe-states.ts` once (read-only, both
live sites) and keep the fresh bdryswi values if they differ, naming the difference.

**T1. compose (AC7).** RED: `Q/test/quote-paste.test.ts` test `compose: header plus home reproduces the pasted file`
imports `compose` from `E/bdry-paste/v5/scripts/compose.ts` (missing → fails) and asserts
`sha256(compose(header, v4)) === sha256(readFileSync(Downloads file))`. GREEN:
```ts
// E/bdry-paste/v5/scripts/compose.ts: the one file Justin pastes: the header paste, then the whole Home
export function compose(header: any, home: any): string {
  for (const k of ["source", "sourceUrl", "version"]) if (header[k] !== home[k]) throw new Error(`header and home differ in ${k}`);
  const classes = [...header.globalClasses];
  for (const c of home.globalClasses) {
    const same = classes.find((m: any) => m.id === c.id || m.name === c.name);
    if (!same) classes.push(c);
    else if (JSON.stringify(same) !== JSON.stringify(c)) throw new Error(`class clash: ${c.id} ${c.name}`);
  }
  return JSON.stringify({ content: [...header.content, ...home.content], source: header.source,
    sourceUrl: header.sourceUrl, version: header.version, globalClasses: classes });
}
```
(no trailing newline: the pasted file ends `}]}`). If v5's `compose.ts` already exists from another job, reuse it and
only add this test.

**T2. The patch (AC5).** RED: test `quote-paste: only the quote button's border colour and its class change`: deep-copy
v4, `apply` it, then assert: element `byywvz` `_border` deep-equals the fix value; class `rxumcp` `_cssCustom` equals
`CSS`; for every other index `i`, `JSON.stringify(after.content[i]) === JSON.stringify(v4.content[i])` and the same for
`globalClasses` and the top-level keys; and `apply` throws when given v4 with the button's `_border.width.top` set to
"2", and when given an already patched copy. GREEN `Q/patch/quote-button-hover.ts`:
```ts
export const name = "quote-button-hover";
export const touches = { elements: ["byywvz"], classes: ["rxumcp"] };
const V4_CSS = ".brxe-button.home-quote {\n  background-color: #FFFFFF;\n  border-color: #004774;\n  transition: all 0.3s;\n}\n.brxe-button.home-quote:hover,\n.brxe-button.home-quote:focus-visible {\n  background-color: #FFB356;\n  border-color: #004774;\n}\n@media (prefers-reduced-motion: reduce) {\n  .brxe-button.home-quote {\n    transition: none;\n  }\n}";
// the border's colour goes on the element (Bricks writes `border: 3px solid <colour>` on #brxe-<id>, which no class can
// override; without one it writes var(--bricks-border-color), #dddedf); the class keeps only the fill, as bdryswi.com:
// white, orange under the pointer and while focused
export const CSS = ".brxe-button.home-quote {\n  background-color: #FFFFFF;\n  transition: all 0.3s;\n}\n.brxe-button.home-quote:hover,\n.brxe-button.home-quote:focus {\n  background-color: #FFB356;\n}\n@media (prefers-reduced-motion: reduce) {\n  .brxe-button.home-quote {\n    transition: none;\n  }\n}";
const SIDES = (v: string) => JSON.stringify({ top: v, right: v, bottom: v, left: v });
export function apply(paste: any): void {
  const btn = paste.content.filter((e: any) => e.id === "byywvz");
  const b = btn[0]?.settings?._border;
  if (btn.length !== 1 || btn[0].name !== "button" || btn[0].label !== "Quote button"
    || btn[0].settings.text !== "Get Your Free Quote" || JSON.stringify(btn[0].settings._cssGlobalClasses) !== '["rxumcp"]'
    || !b || "color" in b || b.style !== "solid" || JSON.stringify(b.width) !== SIDES("3") || JSON.stringify(b.radius) !== SIDES("28")) {
    throw new Error("quote-button-hover: the quote button isn't v4's");
  }
  const cls = paste.globalClasses.filter((c: any) => c.id === "rxumcp");
  if (cls.length !== 1 || cls[0].name !== "home-quote" || cls[0].settings._cssCustom !== V4_CSS) {
    throw new Error("quote-button-hover: class home-quote isn't v4's");
  }
  btn[0].settings._border = { width: b.width, style: b.style, color: { raw: "#004774" }, radius: b.radius };
  cls[0].settings._cssCustom = CSS;
}
```
Then `Q/scripts/build-quote.ts` writes `Q/out/home-paste-v4-quote.json` (`JSON.stringify` of the patched copy, same
compact form as v4) and `Q/out/bdry-home-with-header-quote.json` (`compose(header, patched)`), and their sha256 into
`Q/manifest.json`.

**T3. Bricks' border, calibrated.** RED: test `quote-states: bricks border output is calibrated` in
`Q/test/quote-states.test.ts`: `bricksBorder({width 3s, style "solid"})` must equal `3px solid var(--bricks-border-color)`
and the fixture `post-155.min.css` must contain `border: 3px solid var(--bricks-border-color)`;
`bricksBorder({width 2s, style "solid", color {raw "#FFFFFF"}})` must equal `2px solid #FFFFFF`, also in the fixture.
GREEN `Q/scripts/bricks-css.ts`:
```ts
// The #brxe-<id> rule Bricks 2.3.9 writes for the controls this button uses (read from live post-155.min.css)
const px = (v: string) => (/^-?[\d.]+$/.test(v) ? `${v}px` : v);
const colour = (c: any) => c?.raw ?? c?.hex ?? c?.rgb;
export function bricksBorder(b: any): string {
  const w = b.width;
  if (!(w.top === w.right && w.top === w.bottom && w.top === w.left)) throw new Error("only equal sides are calibrated");
  return `${px(w.top)} ${b.style} ${colour(b.color) ?? "var(--bricks-border-color)"}`;
}
export function bricksIdRule(id: string, s: any): string {
  const d: string[] = [];
  for (const side of ["top", "right", "bottom", "left"]) if (s._margin?.[side]) d.push(`margin-${side}: ${px(s._margin[side])}`);
  for (const side of ["top", "right", "bottom", "left"]) if (s._padding?.[side]) d.push(`padding-${side}: ${px(s._padding[side])}`);
  if (s._border?.width) d.push(`border: ${bricksBorder(s._border)}`);
  if (s._border?.radius) d.push(`border-radius: ${px(s._border.radius.top)}`);
  const t = s._typography || {};
  if (t["font-family"]) d.push(`font-family: "${t["font-family"]}"`);
  for (const k of ["font-weight", "line-height", "text-align"]) if (t[k]) d.push(`${k}: ${t[k]}`);
  if (t["font-size"]) d.push(`font-size: ${px(t["font-size"])}`);
  if (t.color) d.push(`color: ${colour(t.color)}`);
  return `#brxe-${id} {${d.join("; ")}}`;
}
```
Add an assertion that `bricksIdRule("fqkzpd", v4 button settings)` holds every declaration of the live
`#brxe-fqkzpd {…}` rule in the fixture (compare as a set of `prop: value` strings).

**T4. States (AC1–AC4).** `Q/scripts/states-page.ts` exports `statesFor(paste)` that builds one HTML page:
`<body class="bricks-is-frontend">`, `<style>` with the fixture `frontend-light-layer.min.css`, then a band
`<div style="background:#004774;padding:40px;text-align:center">` holding
`<a id="brxe-byywvz" class="brxe-button home-quote bricks-button" href="#q">Get Your Free Quote</a>`, a
`<style>` with `bricksIdRule("byywvz", button settings)` and the class's `_cssCustom`, and the Roboto link from v4's
fonts if the render helper has one (not needed for colours). It opens the page with `page.setContent` at 1440×900,
prevents the click's navigation (`addEventListener('click', e => e.preventDefault(), true)`), and measures the same
states and properties as `planner/probe-states.ts` (rest, hover, active via `mousePressed`, clicked-still-hovered,
clicked-pointer-away, and keyboard: blur, focus a `<button>` placed before the band, `page.press("Tab")`), waiting
600ms per state for the 0.3s transition, and saves a 40px-padded shot per state. "Outline drawn" = `outline-style` not
`none` and (`outline-width` not `0px` or style `auto`). Tests, each RED on v4 and GREEN on the patched paste except AC4's
mouse half (green on both):
- `quote-states: rest matches bdryswi.com`: rest values vs fixture `rest` (border four sides width/style/colour, radius,
  outline drawn, box-shadow, background, colour).
- `quote-states: hover matches bdryswi.com`: vs fixture `hover`.
- `quote-states: pressed and clicked match bdryswi.com`: `active` and `clicked-still-hovered` vs fixture in full;
  `clicked-pointer-away`: background, border, box-shadow vs fixture, outline not drawn.
- `quote-states: focus ring only for the keyboard`: keyboard state focus-visible true, background rgb(255,179,86),
  border = rest border, outline drawn; every mouse state outline not drawn and box-shadow none.
Run once with `paste = v4` and keep the failing output as `Q/checks/states-v4.log` (expect rgb(221,222,223)), then with
the patched paste as `Q/checks/states-quote.log`.

**T5. Validity (AC6).** Test `quote-paste: composed file is a valid Bricks paste`: run `E/bdry-paste/check.ts` on
`Q/out/bdry-home-with-header-quote.json` (spawn `<node> E/bdry-paste/check.ts <file>`), expect exactly the three lines
`payloadProblems: []`, `placeholders: 0`, `css naming another id after paste: 0`; assert no duplicate element ids, class
ids or class names; and no element whose `_border` has `style` but no `color`.

**T6. v5 (AC8).** If `E/bdry-paste/v5/scripts/build-v5.ts` doesn't exist, write it as "Landing in v5" says, with test
`build-v5: patches change only what they declare and never overlap` in `E/bdry-paste/v5/test/build-v5.test.ts`
(fixtures: a stub patch touching `byywvz` must make the build fail naming both; a stub that changes an undeclared id
must fail; with only this patch listed, v5's `byywvz` and `rxumcp` equal `Q/out/home-paste-v4-quote.json`'s). If it
exists, add only this patch's line to `patches.txt` and run its test. Build v5 and run T5's check on
`v5/bdry-home-with-header-v5.json` too.

**T7. Shots.** `Q/shots/`: per state, `before-<state>.png` (v4), `after-<state>.png` (patched), next to
`planner/bdryswi-<state>.png`; one side-by-side for hover (Justin's case). A terminal capture of every test run goes in
`Q/checks/`.

**T8. Docs & records.** Write `Q/manifest.json` (inputs and their sha256; patch, scripts, tests, fixtures, outputs and
shots with sha256; node and Chrome versions; the test tallies), and update `E/bdry-paste/v5/manifest.json` via
`build-v5.ts`. Write `Q/memory-note-update.md`: the exact lines for the B-Dry memory note
(`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`): a "v5 paste" entry naming the
file, its sha256, which jobs' patches it holds, the quote fix in one line ("the quote button's border colour is on the
element now: Bricks wrote its default #dddedf on the id, which beat the class") and live check AC9 owed. Agents don't
edit memory: the main session saves those lines. Don't copy anything to Windows Downloads and never overwrite
`bdry-home-with-header.json`; the hand-over offers `C:\Users\Admin\Downloads\bdry-home-with-header-v5.json` (a new name)
once v5 holds the jobs Justin wants.

**Plan snippets checked (planner, read-only):** `planner/validate-plan-code.ts` runs T1's `compose`, T2's `apply` and
T3's `bricksIdRule` as written: compose(header-v1, v4) = the pasted file byte for byte; `apply` changes only `byywvz`
and `rxumcp` and throws on a second run; the v4 button's rule equals live `#brxe-fqkzpd` declaration for declaration;
the patched rule writes `border: 3px solid #004774`.

## Stop conditions

- v4's quote button or `home-quote` CSS differ from the values in T2 (another job changed them): stop, report.
- The calibration test (T3) fails against the live CSS: stop; the emulation can't be trusted.
- More than this one element and one class need to change, or a plugin/repo change looks needed: stop, `escalate to full`.

## Receipts

No repo commit: ac-check's receipts bind to the evidence files' sha256 in `Q/manifest.json` (head = base in the
worktree). The verifier runs AC1–AC4 on v4 and on the patched paste, AC5–AC8 on the patched outputs.

## Not in this job (found_else)

- The repo's renderer draws no border colour for a `_border` without one (`test/browser/render.ts:57-66`) while Bricks
  2.3.9 writes `var(--bricks-border-color)` (#dddedf): paste and plugin tests can pass on a border the live site draws
  light grey (it hid this bug in v4's `after-faq-render.test.ts:291`). Medium.
- The plugin's emitter writes `_border` width and style without a colour whenever the style has no `border.color`
  (`src/core/emit/settings.ts:144-150`); Bricks would draw #dddedf there. Whether understand/style ever produces that
  (e.g. a gradient or image stroke) is unverified. Low.
- The button is 198.3px wide on ours vs 188.8px on bdryswi.com at 1440 with the same 24px side padding and 15px type
  (`planner/states.json`): text metrics differ (bdryswi's Roboto faces partly fail to load, memory note). Low.
