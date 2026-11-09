# site-menu (website importer): what a site's ☰ and pop-up links open becomes a working Bricks Offcanvas

Planner: Opus 5.5 (high), 2026-11-09. Base: main `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3).
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-menu/planner/` (scripts `nodes.mjs`, `popup27.mjs`,
`paste-burger.mjs`, `widgets.mjs`; Bricks sources `offcanvas-2.2.php`, `offcanvas-2.2.min.css`, `interactions-2.2.php`;
live copies `offcanvas-darksalmon-2.3.9.min.css`, `offcanvas-bdry-staging-2.4.2.min.css`,
`bricks-bdry-staging-2.4.2.min.js`; `popup27.html` (the saved template); `base-unit.log`; `SHA256SUMS`).
Pipeline: Full. Website importer rules apply (one real-bug review per job, edge cases to follow-ups).

## Questions (⭐ = taken under the standing auto-go unless Justin says otherwise)

- **Q1 Which Bricks parts?**
  - ⭐ **A:** Bricks' **Offcanvas** holds the site's own opened panel, and the site's own ☰ element (its exact drawing,
    unchanged) opens it through a Bricks **Interaction** (Click → Toggle offcanvas). Bricks' own script opens, closes,
    traps focus, makes the ☰ focusable (`tabindex="0"`, `aria-expanded`) and handles Escape and the dim.
  - B: Nav (Nestable) and its mobile menu (Bricks' own ☰ bars; the site's panel layout, photo and dim are lost; it
    is built for a row of links, not a panel holding a logo, an accordion and a button).
  - C: Offcanvas opened by a Bricks Toggle element (Bricks' bars or an icon font, not the site's drawing).
- **Q2 Which openers?**
  - ⭐ **A:** every link or button inside the page's parts that opens a box lying outside them: a page builder's pop-up
    link (Elementor's `#elementor-action…popup:open`) and any `aria-controls` toggle. On bdryswi.com: both ☰ (pop-up
    27, the menu) and the four other pop-up links of the page (hotspots → 1453, 1458, 1542; a button → 1731). One code
    path; nothing names a menu.
  - B: only the header's ☰.
- **Q3 The Offcanvas sample** (`reference/bricks/` has none: CLAUDE.md "Waiting on the user: Bricks samples").
  - ⭐ **A:** build now on a researched candidate `reference/bricks/offcanvas.json` (Bricks 2.2 GPL source
    `offcanvas.php` / `interactions.php`, the 2.4.3 schema, the 2.3.9 and 2.4.2 front-end CSS and JS read from Justin's
    sites; Task 1), as nav-nested was built; Justin's own copy replaces it when he sends it.
  - B: wait for his copy first.
  - Either way, the copy wanted (one action each): in Bricks, Add element → **Offcanvas**; add a **Div**, open its
    Interactions, add one: Trigger **Click**, Action **Toggle offcanvas**, Offcanvas CSS selector `.my-menu`; give the
    Offcanvas the class `my-menu` (Style → CSS → CSS classes); select both → right-click → **Copy**; paste the text to me.
- **Q4 Opening and closing motion.**
  - ⭐ **A:** the site's own: the panel plays the site's opening animation (its keyframes, duration and easing:
    bdryswi.com's fadeInRight, 0.75 s) each time it opens, and the same animation backwards as it closes; under
    reduced motion it opens and closes at once.
  - B: Bricks' slide from the side (0.2 s).
- **Q5 The menu's "Services" list** (an Elementor nested accordion: `details`/`summary`).
  - ⭐ **A:** kept as the site's `details`: it opens and closes with the browser's own behaviour and its seven links
    are pasted (the hidden content of a closed `details` pastes). Its chevron keeps the closed drawing while open
    (follow-up: the nested-accordion conversion, which overlaps site-faq).
  - B: a Bricks Accordion (Nestable) (needs the nested-accordion conversion first).
- **Q6 How it closes.**
  - ⭐ **A:** as the capture proves the site does: Escape and/or a click outside the panel (each only when the site's
    does), and the site's own × (any control in the opened box that the capture proved closes it).
  - B: Bricks' defaults always (dim click + Escape).

## Playback (plain words)

1. Justin pasted bdryswi.com's whole home (`--elementor`, Build 2026-11-09.3) on B-Dry staging `/homev2/`.
2. On bdryswi.com, the orange ☰ at the top right opens the site's menu: a panel slides in from the right over a dim,
   holding the logo, "Services" (opens to 7 service links), About Us, Service Areas, Warranty, Contact Us, the phone
   number and "Get Your Estimate".
3. In the paste the ☰ does nothing (screenshot `images/3.png`). He wants the importer to understand that a ☰ (and any
   such action) opens something, and to build it as working Bricks parts, at every width, with the site's links.
4. General rule wanted: whatever a part's link or button opens on the old site opens the same way in the paste.

## What the site does (proof)

- Both ☰ are Elementor Icon widgets (`a99df50` in the desktop bar, the phone bar's twin) whose link is
  `#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3DeyJpZCI6IjI3IiwidG9nZ2xlIjpmYWxzZX0%3D` = open pop-up
  `{"id":"27","toggle":false}` (`nodes.mjs` on Justin's capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`):
  - `body/div:0/header:0/div:0/div:2/div:1/div:0/div:0/a:0` (an `a` holding `i.icon.icon-menu-11`, an ElementsKit
    glyph), shown 768 and up;
  - `body/div:0/header:0/div:1/div:2/div:0/div:0/a:0` (`i.icon-menu-circle`), shown 991 and down.
  - The page part holds four more pop-up links: hotspots `…/div:13/div:0/div:1/div:0/div:0/a:0..2` → 1458, 1453, 1542;
    a button `…/div:13/div:0/div:1/div:2/div:0/div:0/a:0` → 1731.
- Pop-up 27 is a hidden child of `<body>` (`popup27.mjs` on the saved 2026-10-29 home,
  `evidence/web-code-proof/inputs/bdry-2026-10-29/home.html`, 12,383 bytes): `div[data-elementor-type=popup]
  [data-elementor-id=27]` with settings `entrance_animation: fadeInRight`, `exit_animation: fadeInRight`, duration
  0.75, `a11y_navigation: yes`; inside: an `article` container (background slideshow of one photo, a mountains shape
  divider, a 64vh minimum height, a navy gradient overlay), a spacer, the logo (link home), a nested accordion
  (`details#e-n-accordion-item-3520` "Services" → Foundation Repair, Basement Waterproofing, Crawlspace Repair, Basement
  Windows, Egress Windows, Sump Pump, Exterior Drainage), heading links About Us, Service Areas, Warranty, (a heading
  hidden at every width), Contact Us, a phone icon `tel:8124362379`, a button "Get Your Estimate" → /contact-us/.
  **It holds no WPForms form** (`grep -c wpforms popup27.html` = 0; the staging-fit note read 20,000 characters, past
  the template's end into pop-up 1458).
- When opened, Elementor Pro's script moves the template into a dialog it builds,
  `div#elementor-popup-modal-27.dialog-widget.dialog-lightbox-widget.elementor-popup-modal` › `.dialog-widget-content
  .animated` › `.dialog-message` (+ `.dialog-close-button`), styled only by rules that need that dialog (home.html's
  inline CSS): `#elementor-popup-modal-27{background-color:#00000042;justify-content:flex-end;align-items:center;
  pointer-events:all}`, `.dialog-message{width:25vw;height:auto}` (40vw ≤1024, 85vw ≤767), `.dialog-widget-content
  {animation-duration:.75s;border-radius:20px;box-shadow:2px 8px 23px 3px rgba(0,0,0,.2)}`, `.dialog-close-button
  {display:flex;top:1%;right:1%;font-size:24px}` (css1.css: `[data-elementor-type=popup]:not(.elementor-edit-area)
  {display:none}`, `.elementor-popup-modal.dialog-type-lightbox{display:flex;pointer-events:none…}`). So the panel's
  look exists only once a visitor opens it: reading the hidden template can't give it.

## What the paste does (proof)

- Today's header paste (`paste-burger.mjs` on `/home/justin/f2b-test/paste-el3/header.json`): both ☰ `a`s are plain
  Divs (`home__call-us__inner-efra`, `home__section__inner-zjfw`) with no link and no interaction; the paste holds no
  pop-up content at all. `notes.txt`: "a menu button opens nothing yet: its link was the page builder's pop-up action
  (the menu job)".
- Staging (`evidence/staging-fit/planner/staging/homev2-2.html`, logged-out GET): `<div class="brxe-div
  home__call-us__inner-efra">` with no `data-interactions`; no `brxe-offcanvas` on the page. (Class Interactions do
  print there: entrances show `data-interactions` on `home__over-oakj` etc., so Bricks 2.4.2 on staging prints a
  pasted class's or element's Interactions.)

## Root cause (file:line)

1. **The capture never has the opened panel.** `src/web/code.ts:42` drops every never-shown child of `<body>`
   (`if (!shown.length && (parentOf(path) === "body" || …)) continue;`, comment lines 4–6: "pop-up templates stay
   out"), and no step of `src/web/capture.ts` (`readOpened`, lines 149–226) ever opens anything, so the dialog
   Elementor builds on a click is never read; `capture.ts:393-397` `popups()` records pop-ups raw (this capture: `[]`).
2. **The converter drops the action.** `src/core/site/links.ts:19` returns `{ none: "action" }` for any
   `#elementor-action` link and `links.ts:32` names it "opens nothing yet"; `src/core/site/kinds.ts:66-69` makes an `a`
   whose link is left off a plain Div. No code in `src/` emits an Offcanvas or a click Interaction
   (`grep -rli offcanvas src` → nothing).

## The general rule

> **What a part's link or button opens on the old site opens the same way in the paste.** The capture presses every
> opener (a page builder's pop-up link, an `aria-controls` toggle) whose box lies outside the page's parts, lets the
> page's own script open it, reads the opened box's code at every range (as the page's code is read), proves how it
> closes (its own × , Escape, a click outside) and puts it back. The paste holds one Bricks **Offcanvas** per opened
> box, in the part of its first opener, holding the site's opened box as the site's code (its own classes, per-range
> rules, pictures and links), and every opener (and every proven ×) carries a Bricks Interaction **Click → Toggle
> offcanvas** naming it. The panel plays the site's own opening animation, and closes as the site does. Keyed on page
> builders' and ARIA's own markers and on what the page does when pressed, never on a site.

Nothing changes where nothing opens: a capture with no opener, and every older capture (no `opens` field), pastes byte
for byte as on main except the action note's wording; Figma designs are untouched (only `src/web/` and
`src/core/site/` change, plus the snapshot type).

### How the Offcanvas is built (Bricks 2.2 `offcanvas.php`, 2.3.9 `bricks.min.js`, 2.4.2 CSS; Task 1 cites each)

```
offcanvas            parent 0, right after the part's root; settings { direction?, closeOn?, noScrollBody?,
                     ariaLabel?, _cssClasses: "<page>__open-<4>" }; global class site-offcanvas;
                     _cssCustom: the open/close motion (below)
├ block "Content"    _hidden._cssClasses "brx-offcanvas-inner"  (Bricks positions it; site-offcanvas makes it a
│ │                  full-window, see-through, click-through layer that doesn't slide)
│ └ R …              the site's opened box R (a body child) and its subtree, converted by prepare() exactly as a part
│                    is (R takes the reset class and what <body> passed down; --elementor folds its widgets too)
└ block "Backdrop"   _hidden._cssClasses "brx-offcanvas-backdrop" (see-through; it catches the outside click)
```

- **Why a second root and not inside the part's root:** `site-reset-pqgx` (`classes.ts:26`) is `all: revert` on the
  part root and everything under it, which would cancel Bricks' offcanvas CSS (printed in `@layer bricks` on staging:
  `post-155.min.css`), as it cancels the accordion's (`site-accordion`). Outside the reset, Bricks' own CSS works; R
  gets the reset itself. Bricks expects an Offcanvas in a header: its 2.4.2 `frontend-light-layer.min.css` holds
  `#brx-header.brx-sticky:has(.brxe-offcanvas.brx-open){transition:none}`.
- **`site-offcanvas`** (a shared class in `SHARED_CSS`, fixed text; unlayered, so it beats Bricks' layered rules;
  Bricks' `.brx-open .brx-offcanvas-inner{transform:translate(0)!important}` still applies, harmlessly):

```css
.site-offcanvas > .brx-offcanvas-inner { top: 0; right: 0; bottom: 0; left: 0; width: auto; height: auto; transform: none; background-color: transparent; display: block; overflow: visible; pointer-events: none; }
.site-offcanvas > .brx-offcanvas-backdrop { background: none; }
.site-offcanvas > .brx-offcanvas-inner > * { pointer-events: auto; }
```

- **A cover root** (R covers the whole window when open: Elementor's dialog) keeps its own paint (the site's dim) and
  lets clicks through to Bricks' backdrop: R's class gets `pointer-events: none`, R's element children
  `pointer-events: auto` (written into their states before the blocks, so they print per range like every site value).
  A root that is itself the panel (an ARIA drawer) keeps its own pointer events; the see-through backdrop behind it
  catches the outside click.
- **Settings from the capture:** `direction` the window side the panel touches at the design width (right / left /
  top / bottom; none: unset); `closeOn` from what closed it: Escape and outside → unset (Bricks' default
  backdrop-esc), Escape only → `"esc"`, outside only → `"backdrop"`, neither → `"none"`; `noScrollBody: true` when the
  page stopped scrolling while it was open; `ariaLabel` R's or the panel's own `aria-label`, else the first opener's,
  else unset (Bricks prints "Offcanvas").
- **The motion (Q4 A):** the element in R whose declared `animation-name` plays when opened (the capture names it,
  `entrance`) keeps no animation in its own rules; the Offcanvas's `_cssCustom` carries (after class naming, as
  `withLooks` does):

```css
#brxe-<id> > .brx-offcanvas-inner { transition-duration: <dur>; }
#brxe-<id>.brx-open <entrance selector> { animation: <renamed keyframes> <dur> <timing> <delay> both; }
#brxe-<id>.brx-closing <entrance selector> { animation: <renamed keyframes> <dur> <timing> 0s reverse both; }
@media (prefers-reduced-motion: reduce) { #brxe-<id> > .brx-offcanvas-inner { transition-duration: 0s; } #brxe-<id> <entrance selector> { animation: none; } }
```

  Bricks reads the inner's `transition-duration` to time the close (`bricks.min.js` 2.3.9 `bricksOffcanvas`: `r=1e3*
  parseFloat(getComputedStyle(n).transitionDuration)`), so the closing animation finishes before `brx-closing` goes.
  `<entrance selector>` is the entrance element's class with its `where.self` (convert.ts `whereOf`); keyframes as
  site-motion pastes them (`motionOf` names, `css.keyframes`). Without an entrance: no rules but the
  `transition-duration: 0s` pair (opens at once, as a site with no animation).
- **Openers:** each opener's element (by its site path, whatever element it became) gets
  `_interactions: [{ id: shortId("open:" + target + ":" + path), trigger: "click", action: "toggleOffCanvas",
  offCanvasSelector: ".<marker>" }]` on its own settings (its class is unchanged, so no class name moves). Bricks'
  PHP then adds `target: "offcanvas"`, `data-brx-toggle-offcanvas="true"`, `tabindex="0"`, `aria-expanded="false"`,
  `aria-label="Open"` (`interactions-2.2.php:546-652`). If another job makes the opener a Bricks `toggle` element,
  Bricks refuses this Interaction on it (`interactions-2.2.php:548`): write `toggleSelector: ".<marker>"` instead.
  Each proven closer in R gets the same Interaction (inside an open Offcanvas it closes it).
- **The link note:** an action link that opens a box the capture read is no longer "left off"; only a capture without
  `opens` (older) keeps the note, reworded: "a menu or pop-up button opens nothing: capture again with this build so
  the capture reads what it opens".
- **A closed `details`** anywhere in a part or an opened box pastes its never-shown content (the browser shows it once
  opened): `buildTree`'s `pasteHidden` gains every `details` node (Q5 A).

## Acceptance criteria (proposed)

- AC1 (proposed): Given the generic fixture `site-menu` (a header ☰ in each bar opening an Elementor-style pop-up, a page link opening a centred Elementor-style dialog, a footer `aria-controls` button opening a left drawer), when captured, then `web.code.opens` lists three boxes, each with its openers, its root, its closers, `closeOn`, `cover`, `side`, `noScroll`, its entrance path and the ranges it was read at, and its nodes hold the opened subtree's code per range (the panel's message 25vw / 40vw / 85vw by range); every other field of `web.code` equals a capture made with openers ignored. Test: `test/web/capture-opens.test.ts` "the capture reads what each opener opens"
- AC2 (proposed): Given hand-made code with one cover pop-up (two openers, a closer, an entrance) and one drawer, when converted with `siteParts` (with and without the Elementor step), then each part holding an opener pastes one Offcanvas root right after its own root, shaped as `reference/bricks/offcanvas.json` (Content and Backdrop Blocks with Bricks' hidden classes, the marker class, direction, closeOn, noScrollBody), the site box under Content with the reset on its root and every link rewritten as the part's are, every opener and closer carrying the Toggle offcanvas Interaction naming the marker, no "opens nothing" note, and `payloadProblems` clean. Test: `test/unit/site-opens.test.ts` "a box an opener opens pastes as an Offcanvas its openers toggle"
- AC3 (proposed): Given the `site-menu` fixture captured and pasted (rich), rendered with Bricks 2.3.9's own offcanvas CSS and script and its Interactions, at every width the capture read and at 300, a click on the ☰ shown there opens the menu, and once both finish opening every element of the opened panel is within 2 px of the fixture site's opened pop-up and its links match the site's; Escape, a click outside and the × close it as on the site (the dialog ignores the outside click, as its site does); Tab reaches the ☰ and Enter opens it; the drawer and the dialog likewise. Test: `test/web/site-opens-proof.test.ts` "every opener opens its box as on the site, within 2 px"
- AC4 (proposed): Given the same paste, when the menu opens, then the panel plays the site's opening animation (its renamed keyframes, 0.75 s, the site's easing) and, when it closes, the same animation backwards before Bricks hides it; under reduced motion it opens and closes at once. Test: `test/web/site-opens-proof.test.ts` "the panel opens and closes with the site's own animation"
- AC5 (proposed): Given a closed `details` in an opened box or a part, when pasted, then its hidden content is pasted and, clicked in the paste, it opens and shows its links as on the site. Test: `test/unit/site-opens.test.ts` "a closed details pastes its hidden content" (+ the fixture's "Services" in AC3's test)
- AC6 (proposed): Given a capture without `opens` (every capture made before this build: the fixtures' saved captures and Justin's 11-09 bdryswi.com capture), when converted, then every paste is byte for byte main's but the action note's new wording; and the page parts of a capture with `opens` measure as before (`site:check` passes on the fixture, the closed Offcanvas taking no room). Test: `test/unit/site-opens-old.test.ts` "a capture without opens pastes as before" (named-only B-Dry: `F2B_SITE_MENU_BDRY=<capture>`; site:check: `test/web/site-check-opens.test.ts` "site:check passes with opened boxes")
- AC7 (proposed): The Offcanvas candidate sample `reference/bricks/offcanvas.json` and Bricks' offcanvas CSS `reference/bricks/frontend-2.3.9/el-offcanvas.min.css` (byte copy of Justin's darksalmon 2.3.9 file, sha256 `fa02fbfd…b9be`) are in the repo with their sources in `reference/bricks/README.md`, and every emitted Offcanvas matches the sample's shape. Test: `test/unit/bricks-shapes.test.ts` "an emitted Offcanvas has the sample's shape"
- AC8 (proposed) (live): Justin captures bdryswi.com with this build (after staging-fit-capture is merged), runs `npm run site`, pastes the page on B-Dry staging `/homev2/`, and at 1440, 1024, 768 and 390 the ☰ opens the menu from the right over the dim with the logo, "Services" (opens to its 7 links), About Us, Service Areas, Warranty, Contact Us, the phone and "Get Your Estimate", the links go to staging's own pages, and the ×, Escape and a tap outside close it; the hotspots open their pop-ups. Paste check `<site-menu id at merge>`. Test: `test/web/site-opens-bdry.test.ts` "Justin's bdryswi.com capture pastes the menu pop-up and its two openers" (named-only: `F2B_SITE_MENU_CAPTURE=<his new capture>`, checks the conversion before his paste)

The plain route and Figma designs: byte-identical (AC6; `test/unit/site-figma-unchanged.test.ts` and `npm run corpus`
stay green). The capture's existing fields: unchanged (AC1's last clause).

## Current context

- Base tally: `node --test "test/unit/**/*.test.ts"` on `fd1986dc`: 3453 tests, 3384 pass, 0 fail, 69 skipped, 34 s
  (`base-unit.log`). The builder records `npm run test:web`, `npm run test:browser` and `npm run corpus` on the base
  before Task 2 (the ledger).
- Machine: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR=~/.cache/smm-b/tmp` (≤38 characters,
  its own); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome; one `bash <file>` per
  Bash call; heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. The worktree's
  `node_modules` has no `.bin`: link `node_modules/.bin/tsc -> ../typescript/bin/tsc` and
  `node_modules/.bin/esbuild -> ../esbuild/bin/esbuild` (untracked) or run them by path (testing-pitfalls).
- **Never load bdryswi.com.** The B-Dry proofs are the named-only conversion of Justin's next capture (AC8) and his
  live paste; the saved 2026-10-29 stand-in has no scripts, so its pop-ups never open.
- Bricks facts read for this plan (all cited in Task 1's README section):
  - Offcanvas (2.2 `offcanvas.php`): settings `direction` (top/right/bottom/left, default left → `data-direction`),
    `effect`, `closeOn` (`backdrop`/`esc`/`none`, unset = both → `data-close-on`), `noScrollBody` (`data-no-scroll`),
    `noAutoFocus`, `scrollToTop`, `openByDefault`, `ariaLabel` (default "Offcanvas"), `width`/`height`,
    `transitionDuration`; nestable children: Block "Content" `_hidden._cssClasses: "brx-offcanvas-inner"` (`deletable:
    false`, `cloneable: false`; Bricks' default holds a Basic Text and a close Toggle, the plugin writes the site's
    box instead) and Block "Backdrop" `_hidden._cssClasses: "brx-offcanvas-backdrop"` ("delete to disable"). Prints
    `<div class="brxe-offcanvas …" aria-label data-direction [data-close-on] [data-no-scroll]>` + children.
  - CSS: 2.3.9 (darksalmon) byte-identical to 2.2's; 2.4.2 (B-Dry staging) adds only
    `--brx-offcanvas-direction:initial`; staging prints element CSS inside `@layer bricks` (`post-155.min.css`).
  - Interactions (2.2 `interactions.php`): action `toggleOffCanvas` with `offCanvasSelector`; not allowed on a `toggle`
    element; the element then gets `data-brx-toggle-offcanvas`, `tabindex="0"`, `aria-expanded`, `aria-label`. 2.3.9
    and 2.4.2 `bricks.min.js`: `case"toggleOffCanvas"` → `bricksUtils.toggleAction(e,{selector})`; `bricksOffcanvas()`
    closes on the backdrop click and Escape per `data-close-on`, focuses the first focusable, restores focus to the
    opener (`[data-interaction-id][data-brx-toggle-offcanvas]`).
- Capture code paths: `codeFacts` (`src/web/read/code-facts.ts:132-171`) visits every body child; `readCode`
  (`src/web/read/code.ts:77`) reads them all; `assembleCode` (`src/web/code.ts:30`) encodes per range.

## Architecture (files)

Capture (`src/web/`):
- `src/web/readers/openers.ts` (new, in-page): `openersOf(helpers)` lists `{ opener, target, how }`: every
  `a[href*="elementor-action" i]` whose decoded hash is `action=popup:open&settings=<base64 JSON with id>` → target
  `[data-elementor-type="popup"][data-elementor-id="<id>"]`; every `a, button, [role=button]` with `aria-controls` and
  `aria-expanded` whose controlled element exists; `opener` and `target` as `pathOf` paths. `openIt(arg)`,
  `shutIt(arg)`, `openedRoot(arg)`, `facts(arg)` (below).
- `src/web/read/opens.ts` (new, Node side): `readOpens(s, range, parts, { probe })` per range, after every other
  reading of that page load: for each target outside every part root whose opener (inside a part) shows at this width:
  `el.click()` on that opener; wait until the target shows (≤ 3 s; else a note and skip); finish R's finite animations
  (`R.getAnimations({ subtree: true })`, `.finish()`, as the capture reads animations at their end); R = the target's
  ancestor that is a child of `<body>` (or the target itself); `readCode(s, range, { root: R path })`; with `probe`
  (the design width's range only): `cover` (R's rect equals the window within 1 px), `side`, `noScroll`
  (`document.scrollingElement` can't scroll while open but could before, or `overflow: hidden` on html/body
  appeared), then the close proofs in order, reopening between them: Escape (`Input.dispatchKeyEvent` keyDown/keyUp
  "Escape"), a click outside (cover: at R's corner pixel (2, 2) via `Input.dispatchMouseEvent`; else at the window's
  far side from the panel), each candidate closer (`a, button, [role=button]` under R with no address: `href`
  missing, `#…`, `javascript:` or an action); closed = the target no longer shows within 1.5 s. Last: shut it (the
  first closer, else Escape, else leave it: it is the page load's last step).
- `src/web/read/code-facts.ts` and `src/web/read/code.ts`: an optional `root` (a path): visit only that element
  (`findPath`) instead of every body child; the body context is read as before.
- `src/web/code.ts`: `assembleOpens(rangeIds, readings)` → `CodeOpen[]` (each open's nodes encoded as `assembleCode`
  does; a range with no reading takes the nearest read range's, wider first, as `encode`'s undefined does), their
  `@keyframes` merged into `web.code.keyframes` by the same rule.
- `src/web/capture.ts`: `readOpened` calls `readOpens` last for the ranges other than the design width's; the design
  width's runs (with `probe`) after the renders, just before `captureSite` returns, and the result is set as
  `snapshot.web.code.opens` (`[]` when nothing opens). Pictures the opened boxes show (their `img` `src`, `url()` in
  `background-image`) join the download list. Timings `opens <range>`.
- `src/core/snapshot/web.ts`: `WebCode.opens?: CodeOpen[]` (absent: an older capture; no `version` bump, so no clash
  with other jobs' capture changes):

```ts
// web-code (site-menu): a box a part's link or button opens, read open at each range where an opener shows
export interface CodeOpen {
  target: string;                       // the box the openers name, as served (Elementor: the pop-up template; ARIA: the controlled element)
  root: string;                         // the opened box's top element, a child of <body> (its path while open)
  how: "elementor-popup" | "controls";
  openers: string[];                    // paths of the openers inside the parts, document order
  closers: string[];                    // paths under root the capture proved close it (design width)
  closeOn: { esc: boolean; outside: boolean };
  cover: boolean;                       // root covers the whole window while open (its own paint is the dim)
  side: "left" | "right" | "top" | "bottom" | null;
  noScroll: boolean;                    // the page stops scrolling while it's open
  entrance: string | null;              // the element under root whose declared animation plays as it opens
  read: string[];                       // ranges it was read at
  nodes: Record<string, CodeNode>;      // root's subtree, encoded as web.code.nodes (widest full, then changes)
}
```

Converter (`src/core/site/`):
- `src/core/site/opens.ts` (new, pure, ≤300 lines): `opensOf(capture)` (the opens whose first opener lies in a part);
  `openView(capture, open)` (a capture whose `web.code.nodes` = `open.nodes`, everything else shared); `offcanvasTree(
  open, prepared, ids)` (the three Bricks elements as `TreeNode`s with `site: false`, R re-parented under Content);
  `openerInteraction(marker, open, path)`; `openMotionCss(id, open, …)`; `OPEN_NOTE`.
- `src/core/site/classes.ts`: `SHARED_CSS["site-offcanvas"]` (the text above).
- `src/core/site/convert.ts`: `prepare` gains `opened?: { cover: boolean; entrance: string | null }` (R's and its
  children's pointer events; the entrance's animation kept out of its rules and out of `entranceOf`); `payloadOf` puts
  the reset on the prepared root's own element (`t.path === p.root`) instead of every `parent === 0` element.
- `src/core/site/parts.ts`: after preparing the parts, prepares each open's R (`prepare(openView(…), open.root, o,
  pr)`), names its classes in the same pass (base `<page>__open-<k>` for R, `<page>__open-<k>__<role>` below; scope
  `site-open-<k>`), appends its Offcanvas content after the part's own content and its classes after the part's,
  writes the openers' and closers' Interactions on their elements, and the motion `_cssCustom` once the names are
  known.
- `src/core/site/links.ts`: `siteLink(href, finalUrl, opened?)`: an action link whose box was read returns
  `{ none: "opens" }` with no note; the `action` note's new words.
- `src/core/site/tree.ts`: `buildTree` treats a `details` node as `pasteHidden`.

Tests and tools:
- `test/fixtures/web/sites/site-menu/` (new): `index.html`, `style.css`, `popup.js` (the Elementor-style pop-up
  behaviour as Elementor Pro's front end does it: build the dialog, move the template in, add `animated <entrance>`,
  close by its × (`a.dialog-close-button[role=button][aria-label=Close]`, no href), Escape, a click on the dim unless
  `prevent_close_on_background_click`, the exit animation reversed, `overflow: hidden` on body while open when
  `prevent_scroll`), `drawer.js` (an `aria-controls` button toggling `is-open` on `aside#drawer`, a body child; its
  × inside; Escape closes; no outside close).
- `test/browser/render.ts`: prints `offcanvas` as Bricks 2.2/2.3.9 does (root attributes above; children as Blocks);
  prints a `toggleOffCanvas` Interaction as Bricks' PHP does (`target: "offcanvas"` added, `data-interactions`,
  `data-interaction-id`, `data-brx-toggle-offcanvas="true"`, `tabindex="0"`, `aria-expanded="false"`,
  `aria-label="Open"` unless set); with `bricksCss` and an offcanvas in the payload: `el-offcanvas.min.css` and Bricks'
  own `bricksOffcanvas()` and `bricksInteractions()` (ready flag `__f2bOffcanvasReady`).
- `test/web/lib/site-page-check.ts`: elements under a `.brxe-offcanvas` are not measured as page boxes (hidden at
  load); `test/web/lib/opens-check.ts` (new): `openedRows(browser, capture, partPaste, open, width)` opens both pages
  and compares every paste element under the Offcanvas to its site element (sources) by box, words and link.
- `tools/site.ts` prints each part's Offcanvas count with its notes ("opens: 1 box (2 openers)").

## Tasks (test-first; commit after each passing task, explicit files; never `CLAUDE.md`)

**Task 0 — plan copy and ledger.** Copy this approved plan to `docs/plans/2026-11-09-site-menu.md`; start
`.superpowers/sdd/2026-11-09-site-menu/progress.md`; run and record the base `npm run test:web`,
`npm run test:browser`, `npm run corpus` tallies. Commit "site-menu task 0: the approved plan copied into docs/plans".

**Task 1 — the Offcanvas candidate (AC7).**
1. Fetch read-only (one plain call each; never write to a site): `https://darksalmon-badger-335429.hostingersite.com/
   wp-content/themes/bricks/assets/css/elements/offcanvas.min.css?f2b=<random>` → `reference/bricks/frontend-2.3.9/
   el-offcanvas.min.css`; check its sha256 is `fa02fbfd3350a849c7d42dc07aea6648e7f8452cb0cb73f5103978c7130bb9be` and add
   it to `SHA256SUMS`. (The planner's copies are in the evidence folder.)
2. Write `reference/bricks/offcanvas.json` (Bricks' clipboard shape, as `nav-nested.json`): an Offcanvas with
   `settings: { direction: "right", _cssClasses: "my-menu" }`, its Content Block (`label "Content"`, `deletable:
   false`, `cloneable: false`, `_hidden._cssClasses "brx-offcanvas-inner"`) holding one Basic Text, and its Backdrop
   Block (`label "Backdrop"`, `_hidden._cssClasses "brx-offcanvas-backdrop"`), then a Div whose `_interactions` is
   `[{ "id": "abcdef", "trigger": "click", "action": "toggleOffCanvas", "offCanvasSelector": ".my-menu" }]`; ids 6
   lowercase letters, `parent`/`children` consistent, `"source": "bricksCopiedElements"`, `"version": "2.3.9"`.
3. `reference/bricks/README.md`: section "`offcanvas.json` (built from Bricks' code, NOT copied from Justin's Bricks;
   2026-11-09)" citing `offcanvas-2.2.php` lines 20–64 and 155–236, `interactions-2.2.php` lines 196–200, 307–318,
   546–552, 621–652, the 2.4.3 schema keys, the CSS copies and the JS functions (`bricksOffcanvas`,
   `bricksOffcanvasClose`, `toggleAction`, `case"toggleOffCanvas"`); "Still wanted": his own copy (Q3's steps).
   CLAUDE.md is the finisher's (pending file).
4. RED: `test/unit/bricks-shapes.test.ts` "an emitted Offcanvas has the sample's shape" — fails until Task 5 emits one
   (import `siteParts` on the AC2 hand-made code; assert the emitted Offcanvas's child names, `_hidden` classes,
   `label`s, `deletable`/`cloneable` on Content, and every settings key appears in the sample or in
   `evidence/…/schema-2.4.3/offcanvas.json`'s keys copied into the test as a list). Commit the sample, CSS and README;
   the test joins Task 5's commit.

**Task 2 — the capture reads what an opener opens (AC1).**
1. Fixture `test/fixtures/web/sites/site-menu/` (generic; nothing from B-Dry but the shape of Elementor's markup):
   - header: bar A (shown ≥768) with a logo `img`, a phone `a[href^=tel]` and ☰ A (`a.elementor-icon` holding an inline
     svg of three bars, href `#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3D<base64 of {"id":"77","toggle":
     false}>`); bar B (shown ≤767) with ☰ B (a `span`-drawn ☰, same href);
   - page: a section with words and a "Details" link opening pop-up 78 (`{"id":"78","toggle":false}`);
   - footer: words and `button#drawer-open[aria-controls=drawer][aria-expanded=false]` "Contact";
   - body children: pop-up 77 (`div.elementor.elementor-77.elementor-location-popup[data-elementor-type=popup]
     [data-elementor-id=77][data-elementor-settings='{"entrance_animation":"fadeInRight","exit_animation":
     "fadeInRight","prevent_scroll":"yes"}']` holding a logo link, `details` "Services" with three links, three
     heading links, a `tel:` icon link and a button link), pop-up 78 (a centred dialog with words and one link,
     `prevent_close_on_background_click: "yes"`, entrance `fadeIn`), `aside#drawer` (a 320px panel against the left,
     hidden until `.is-open`, a CSS transition, its own × `button[aria-label=Close]`).
   - `style.css`: Elementor's dialog rules as css1.css writes them (`.dialog-type-lightbox{position:fixed;height:100%;
     width:100%;bottom:0;left:0;z-index:9999}`, `.elementor-popup-modal{display:flex;pointer-events:none;…}`,
     `.elementor-popup-modal .dialog-widget-content{background-color:#fff;max-height:100%;overflow:visible;…}`,
     `.elementor-popup-modal .dialog-close-button{position:absolute;…}`), the pop-ups' own
     `#elementor-popup-modal-77{background-color:#00000042;justify-content:flex-end;align-items:center;
     pointer-events:all}`, `#elementor-popup-modal-77 .dialog-message{width:25vw;height:auto}` (40vw ≤1024, 85vw ≤767),
     `.dialog-widget-content{animation-duration:.75s;border-radius:20px}`, `@keyframes fadeInRight` and `fadeIn`
     (animate.css's frames), `.animated{animation-fill-mode:both}`, `.fadeInRight{animation-name:fadeInRight}`;
     the drawer's rules.
   - `popup.js`: on a click of any `a[href*="elementor-action"]`, decode, build `div#elementor-popup-modal-<id>
     .dialog-widget.dialog-lightbox-widget.dialog-type-buttons.dialog-type-lightbox.elementor-popup-modal`
     › `div.dialog-widget-content.dialog-lightbox-widget-content.animated` › (`div.dialog-header`,
     `div.dialog-message.dialog-lightbox-message` › the template, `a.dialog-close-button[role=button][tabindex=0]
     [aria-label=Close]` with an svg ×), the first time; later opens show it again; add the entrance class; Escape
     (keyup) and a click whose target is the dim (the wrapper itself) close it unless prevented; closing plays the
     exit animation with `animation-direction: reverse`, then `display: none` on the wrapper. `drawer.js` likewise.
2. RED `test/web/capture-opens.test.ts` "the capture reads what each opener opens": `captureSite({ url: fx.site +
   "/", fontSource: standIn(fx), browser, shots: false })`; assert `cap.web.code.opens.length === 3`; for pop-up 77:
   `openers` = both ☰ paths (via `pathOf` on the live fixture), `how: "elementor-popup"`, `cover: true`, `side:
   "right"`, `noScroll: true`, `closeOn {esc: true, outside: true}`, `closers` = the × path, `entrance` = the
   `.dialog-widget-content` path, `read` = every range; its `.dialog-message` node's `width` is `25vw` at the widest
   range and changes to `40vw` and `85vw` at the ranges holding 1024 and 767; every link of the template is a node
   with its `href`; `keyframes.fadeInRight` exists; pop-up 78: `closeOn {esc: true, outside: false}`, `side: null`;
   the drawer: `how: "controls"`, `cover: false`, `side: "left"`, `closeOn {esc: true, outside: false}`, closer its
   ×. Then a second capture with `opens: false` (a test-only `CaptureOptions.opens` flag): every `web.code` field but
   `opens` is deep-equal to the first's (the page's own reading untouched). RED on base: `opens` is undefined.
3. GREEN: `src/web/readers/openers.ts`, `src/web/read/opens.ts`, the `root` option (code-facts.ts, code.ts),
   `assembleOpens` (code.ts), the calls in capture.ts, `CaptureOptions.opens?: boolean` (default true), the type in
   `src/core/snapshot/web.ts`, `docs/specs/web-capture.md` "The site's own code" gains `opens`. The in-page parts
   (self-contained, sent with `Runtime.evaluate`, helpers `pathOf`, `findPath` as code-facts does):

```ts
// Runs in the page (site-menu): every opener whose box the page's own script opens on a click, keyed on a page
// builder's own marker (Elementor's pop-up action link) or ARIA's (aria-controls + aria-expanded), never on a site.
export interface OpenerFact { opener: string; target: string; how: "elementor-popup" | "controls" }
export function openersOf(_: unknown, helpers: { pathOf: (el: Element) => string | null }): OpenerFact[] {
  const out: OpenerFact[] = [];
  const add = (el: Element, target: Element | null, how: OpenerFact["how"]) => {
    const o = helpers.pathOf(el), t = target && helpers.pathOf(target);
    if (o && t) out.push({ opener: o, target: t, how });
  };
  for (const a of document.querySelectorAll("a[href]")) {
    let h = a.getAttribute("href") ?? "";
    try { h = decodeURIComponent(h); } catch { /* as written */ }
    const m = /#elementor-action:action=popup:open&settings=([A-Za-z0-9+/=]+)/i.exec(h);
    if (!m) continue;
    let id = "";
    try { id = String((JSON.parse(atob(m[1])) as { id?: unknown }).id ?? ""); } catch { continue; }
    if (!/^\d+$/.test(id)) continue;
    add(a, document.querySelector(`[data-elementor-type="popup"][data-elementor-id="${id}"]`), "elementor-popup");
  }
  for (const el of document.querySelectorAll("a[aria-controls][aria-expanded], button[aria-controls][aria-expanded], [role=button][aria-controls][aria-expanded]")) {
    const ids = (el.getAttribute("aria-controls") ?? "").trim().split(/\s+/);
    if (ids.length === 1 && ids[0]) add(el, document.getElementById(ids[0]), "controls");
  }
  return out;
}
```

   Node side keeps only openers under a part root and targets under none (`web.parts` roots, as `partsOf` gives them;
   the parts are known from the design width's reading, so each range's call receives the root paths). A target
   already shown at load isn't an opened box (a hidden part inside a part stays elementor-map's). The opener clicked at
   a range is the first one shown there (`getClientRects().length`).
4. Commit "site-menu task 2 (AC1): the capture reads what each opener opens".

**Task 3 — a closed `details` pastes its hidden content (AC5, unit half).** RED `test/unit/site-opens.test.ts` "a
closed details pastes its hidden content": hand-made code (version 3) with a part holding `details` (shown) › `summary`
(shown) + `div` (shown `[]`) › two `a` with words; `siteParts(cap, { text: "rich" })` holds both links. RED on base
(the hidden `div` is left out by `buildTree`). GREEN: `tree.ts` `visit`: `const under = hiddenOk ||
!!opts.pasteHidden?.has(path) || n.tag === "details";`, and `convert.ts` `scan` the same. Commit.

**Task 4 — the converter's open (AC2).**
1. RED `test/unit/site-opens.test.ts` "a box an opener opens pastes as an Offcanvas its openers toggle": hand-made
   capture (in `test/fixtures/site-opens-code.ts`, built like `test/fixtures/site-page-code.ts`): header part with two
   opener `a`s (action hrefs), page part with words; `opens: [cover pop-up with closer and entrance, drawer]`; assert
   for `siteParts(cap, { text: "rich" })` and `siteParts(cap, { text: "rich", elementor: true })`:
   - header payload roots (`parent === 0`): the part root, then one `offcanvas`; the page payload: its root, then the
     drawer's `offcanvas` only if its first opener is in the page (the fixture puts it in the footer: the footer's);
   - the Offcanvas: `settings.direction === "right"`, no `closeOn` (both), `noScrollBody: true`, `_cssClasses` matching
     `/^home__open-[a-z0-9]{4}$/`, global classes `[site-offcanvas]`; children: Content (`_hidden._cssClasses ===
     "brx-offcanvas-inner"`, `label "Content"`, `deletable: false`, `cloneable: false`) whose one child is R's element
     (its classes start with `site-reset-pqgx`), and Backdrop (`"brx-offcanvas-backdrop"`, no children);
   - both openers' elements: `_interactions` deep-equal `[{ id: <6 letters>, trigger: "click", action:
     "toggleOffCanvas", offCanvasSelector: ".<marker>" }]`; the closer's too; nothing else gets `_interactions` but
     site-motion's;
   - R's class custom CSS holds `pointer-events: none`; its children's `pointer-events: auto`; the entrance class has no
     `animation-name`; the Offcanvas `_cssCustom` holds `.brx-open`, `.brx-closing … reverse`, `transition-duration:
     0.75s` and the reduced-motion block, naming the renamed keyframes (`home-…fadeinright` as `motionOf` names them);
   - the drawer: `direction: "left"`, `closeOn: "esc"`, no pointer-events rules;
   - the template's links: a same-host link → its path; `tel:` kept;
   - notes: none containing "opens nothing"; `payloadProblems(payload)` is `[]` for every part;
   - the same capture twice gives byte-identical payloads.
   RED on base: no `offcanvas` element.
2. GREEN: `src/core/site/opens.ts`, the `SHARED_CSS` entry, `prepare`'s `opened` option, `payloadOf`'s reset on
   `p.root`, `parts.ts` wiring, `links.ts` (`opens` reason, new note words). Commit.

**Task 5 — Bricks shapes (AC7 GREEN).** Make Task 1's shapes test pass against Task 4's output; commit both.

**Task 6 — old captures unchanged (AC6).**
1. Guard `test/unit/site-opens-old.test.ts` "a capture without opens pastes as before": the AC2 capture with `opens`
   deleted, and `test/fixtures/site-page-code.ts`'s capture: no `offcanvas`, no `toggleOffCanvas` Interaction, the
   reset on each part root only, every element and class as on base (the builder writes, before Task 2, the base
   payloads' sha256 per part for these two hand-made captures into the test as literals, generated by a script run on
   a `git archive` of `fd1986dc`, and the head must match them once the note's words are swapped back), and the one
   note "a menu or pop-up button opens nothing: capture again with this build so the capture reads what it opens" for
   the action link. RED for the note's words on base. The named-only half (`F2B_SITE_MENU_BDRY=
   /home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, story-time pin, runs only when named): `siteParts` with
   `--elementor` on that capture equals `/home/justin/f2b-test/paste-el3/{header,page,footer}.json` byte for byte
   but the note (the builder records the base run's sha256 of each part in the ledger first).
2. `test/web/site-check-opens.test.ts` "site:check passes with opened boxes": `npm run site:check` on the AC1 fixture
   capture (`tools/site-check.ts` as `test/web/site-check-cli.test.ts` drives it) ends "OK", and its report lists the
   same rows as with `opens` deleted (the closed Offcanvas takes no room and isn't measured).
3. GREEN: `site-page-check.ts` skips elements under `.brxe-offcanvas`. Commit.

**Task 7 — the renderer and the browser proof (AC3, AC4, AC5 browser half).**
1. `test/browser/render.ts`: the Offcanvas and toggleOffCanvas printing and Bricks' scripts (Architecture). A unit
   guard `test/unit/render-offcanvas.test.ts` "renders an Offcanvas and its opener as Bricks prints them" (string
   checks on `renderPage`'s HTML: `class="brxe-offcanvas`, `data-direction="right"`, `data-brx-toggle-offcanvas="true"`,
   `tabindex="0"`, `"target":"offcanvas"` in `data-interactions`).
2. RED `test/web/site-opens-proof.test.ts` (as `site-motion-proof.test.ts` is built: `captureSite` on `site-menu`,
   `siteParts(cap, { text: "rich" })`, `renderSitePaste(pastePictures(…), head, HOSTILE_THEME, { motion: true })`):
   - "every opener opens its box as on the site, within 2 px": for each width in `cap.web.widths` and 300: open the
     fixture site and the header paste; click the ☰ shown (by its site path / paste id from `sources`); wait for both
     to finish opening (`finishAll`); `openedRows` → worst ≤ 2 px for every element under R, every word, every link's
     `href` equal to the site's rewritten as `siteLink` does; then Escape → both closed; reopen; click at (2, 2) → both
     closed; reopen; click the × → both closed; Tab from the page top reaches the paste's ☰ (`tabTo`), Enter opens;
     the dialog (pop-up 78): opened by its page link, Escape closes, a click at (2, 2) leaves both open; the drawer:
     opened by "Contact", Escape and its × close, an outside click leaves it open on both.
   - "the panel opens and closes with the site's own animation": open the paste with animations held (`holdAnimation`
     from `lib/motion-check.ts`); the entrance element's running animation is the renamed fadeInRight, 0.75 s, the
     site's timing function; at 50 % its opacity and transform equal the site's at 50 % (`values`) within 0.02 / 1 px;
     closing: `brx-closing` present while the reversed animation runs, and the Offcanvas closed once it ends; under
     `prefers-reduced-motion: reduce` no animation runs and it opens at once.
   - "the Services list opens as on the site": click "Services" in both → its three links show, within 2 px.
   - With the menu closed, `checkPage` on the three parts: within 2 px at every width (unchanged).
   RED on base: no Offcanvas. GREEN: Tasks 2–6 plus the renderer. `F2B_SITE_OPENS_OUT`: site | paste pictures of the
   open menu at 1440, 1024, 768, 390. Commit.

**Task 8 — named-only B-Dry conversion (AC8's pre-check).** `test/web/site-opens-bdry.test.ts` "Justin's bdryswi.com
capture pastes the menu pop-up and its two openers" (skips unless `F2B_SITE_MENU_CAPTURE` names a capture with `opens`):
`siteParts(cap, { text: "rich", elementor: true })`: the header paste holds one Offcanvas whose subtree holds the words
Services, Foundation Repair … Exterior Drainage, About Us, Service Areas, Warranty, Contact Us, Get Your Estimate and a
`tel:8124362379` link; both ☰ elements carry the Interaction naming its marker; the page paste holds the hotspots'
Offcanvases (Q2 A) opened by their links; `payloadProblems` clean. Commit.

**Task 9 — HANDOFF and the paste check.** `docs/HANDOFF.md`: a new top section "A site's ☰ and pop-up links open as on
the site (site-menu, website importer; build <at merge>; paste check <id> owed)" (what changed, proofs, files, tests,
⭐ rulings Q1–Q6 not yet confirmed, known limits, follow-ups) and its end-of-run entry. Paste check steps (one action
each): 1. `npm run capture -- https://bdryswi.com/` (pass the human check if asked); 2. `npm run site --
~/Downloads/<capture> ~/Downloads/bdry-paste --elementor`; 3. paste the page as before (staging-fit's steps; Import
classes: Accept); 4. Bricks → Settings → Custom code → Regenerate code signatures; 5. open `/homev2/?f2b=<random>` at
1440: click the ☰ → the menu slides in from the right over the dim; click Services → its 7 links; press Escape → it
closes; open it, click the dim → it closes; open it, click × → it closes; 6. the same at 1024, 768 and 390 (phone: the
round ☰); 7. click About Us → staging's /about-us/; 8. click each hotspot → its pop-up; 9. Tab to the ☰ with the
keyboard and press Enter → it opens. Commit.

**Close:** `npm run check`, `npm run test:web`, `npm run test:browser`, `npm run corpus` (no width worse than base),
the ledger. Status `ready-for-review`.

## Overlaps with the other five jobs (build side by side; merge order)

- **staging-fit (and its capture job staging-fit-capture):** fixes the capture's 768–991 styleless read; Justin
  re-captures after it. Shared files: `src/web/capture.ts` (both add steps to `readOpened`; this job's call is the
  last line before `return`), possibly `src/web/session.ts`. **Merge staging-fit-capture first**; this job rebases
  (AC8 needs the fixed capture anyway). No `web.code.version` bump here, so no version clash.
- **site-native-structure:** may change which Bricks element an opener or a panel element becomes. This job keys on
  site paths, not element names: the Interaction goes on whatever element the opener's path became; if it becomes a
  Bricks `toggle`, write `toggleSelector` instead (Bricks refuses the Interaction on a Toggle); a Bricks `button`
  takes the Interaction as is. R's subtree is converted by the same `prepare`, so native-structure's choices apply
  inside the panel too. Shared files: `convert.ts`, `parts.ts`, `kinds.ts`, `tree.ts` (Task 3's one line). Either
  order; the second rebases (expected conflicts in `prepare`'s options and `payloadOf`).
- **site-faq:** `elementor-accordion.ts` and the accordion's renderer branch. The menu's Services list is an Elementor
  *nested* accordion (`details`), not in `ACCORDION_WIDGETS` (`elementskit-accordion`, `accordion`), so untouched; if
  site-faq adds `nested-accordion`, the list becomes a Bricks Accordion and Task 3's `details` rule simply no longer
  meets it there (AC5's fixture keeps a plain `details`). Shared: `test/browser/render.ts` (the Bricks script line,
  `bricksScript([...])`: both add a call and a ready flag; keep both).
- **site-slider:** Swiper → Bricks Slider in `web.sliders`; the menu panel's background slideshow is made by
  Elementor's script only when the pop-up opens and isn't in `web.sliders` (read from the page at load), so it pastes
  as read (one photo). Shared: `render.ts`, `capture.ts` (sliders reader) — rebase only.
- **site-reviews:** no overlap (embeds).
- **Merge order recommended:** staging-fit-capture → staging-fit → site-native-structure → site-faq / site-slider →
  site-menu (or site-menu before native-structure: both rebase cleanly by keying on paths).

## Bricks samples needed

- **Offcanvas** (missing from `reference/bricks/`; researched candidate in Task 1 meanwhile) and **a Div with an
  Interaction Click → Toggle offcanvas** (the click-open shape; `cta-button-interactions.json` holds only
  `startAnimation`). One copy covers both (Q3's steps).

## Risks and limits

- The capture's time grows: one small code reading per opened box per range (B-Dry: 5 boxes × 16 ranges, each a few
  dozen elements) plus the close proofs at the design width; timings are recorded per range (`opens <range>`).
- A site's own pop-up script must run in the capture; a site whose opener needs a hover or a scroll first, or whose box
  is fetched by AJAX on click, is read if it shows within 3 s, else named ("a pop-up its link opens didn't show").
- Elementor's exit animation other than the entrance reversed (`exit_animation` naming another) plays the entrance
  backwards: a follow-up.
- An opener whose box lies inside its own part (a theme's in-header mobile menu toggled by class) isn't this job's:
  named in the notes as before (follow-up: read that open state as a state look, as site-motion reads hover).
- The menu's Services chevron keeps its closed drawing when open (Q5 A).
- B-Dry proofs are live only (bot check; the stand-in has no scripts).

## Completion contract

Builder: every AC's test named on one plan line, RED on base and GREEN on head recorded in the ledger with commands;
one picture per AC (site | paste of the open menu; a terminal capture for AC1, AC2, AC6, AC7); `npm run check` and
`npm run corpus` green; no `BUILD` bump; nothing pushed; status `ready-for-review` with the head SHA and
`skill_lessons`.
