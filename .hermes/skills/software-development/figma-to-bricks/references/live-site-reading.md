# Reading a live website (website importer, compare tool, live probes)

Read-only GETs of public pages, through the repo's Chrome driver (`test/browser/chrome.ts`). Never log in, never write.

## Access
- A site may start answering automated Chrome with a bot check ("Checking your browser…"), as bdryswi.com did on
  2026-10-29 after a day of agent probes. Hiding the automation flag is refused as bot-check circumvention: stop
  loading that site and hand the live check to Justin (allow-list the capture or pause the check). A bot page can pass
  a naive "page loaded" check: look for its title and tiny element count (web-capture).

## Writing readers
- Write in-page readers as typed, self-contained TS functions sent with `Runtime.evaluate` as `(${fn})(args)`: Node's
  type stripping keeps `fn.toString()` valid JS; the function must not close over imports or outer variables
  (web-capture planner).
- `CSS.getMatchedStylesForNode` lists matched rules in cascade order (specificity, then source order): the last normal
  declaration, then the last `!important` one, wins. It returns only rules matching now: read once per width range.
  Shorthands (`gap`) come without longhands and values behind `var()`: resolve, then expand. `computedStyleMap()`
  keeps a unitless line-height as a number and an unset top/left as `auto`, where `getComputedStyle` gives px
  (web-capture).
- A list of "facts that changed" (switch points, drift checks) misses whatever isn't on the list: width-only,
  min-height-only and flex-basis-only media queries must count (web-capture review 1).

## What counts as shown
- Hidden is more than `display: none`: `visibility: hidden` (closed dropdowns, megamenus, popups) and screen-reader
  boxes hidden with the old `clip: rect(…)` (Bricks' `.skip-link` is 20×10 with padding, not 1×1) are not visible
  layers (web-capture review 1).
- `documentElement.scrollWidth` stays wider than the window when html/body has `overflow-x: hidden|clip`, though nobody
  can scroll: a sideways-scroll check also reads the window's effective overflow-x (html's, else body's when html's is
  visible) (web-compare review 1).
- Lazy pictures load only after a scroll-through; a resize differs from a fresh load at some widths (fixed boxes at
  767, widths at 390 on bdryswi.com): load each range fresh (web-capture planner).

## Hover, focus and motion
- To read a hover/focus end state with `CSS.forcePseudoState`, first finish the target's transitions and stop its
  animations (`el.getAnimations({subtree:true})` → `finish()`): injecting `*{transition:none!important}` alone loses to
  a site's own more specific `!important` transition (OneTap), and without either it reads mid-transition (Elementor
  "grow" read 1.0038 instead of its end scale). Read duration/easing separately; Elementor hover animations also fire
  on `:focus` (website-importer probe, web-compare).
- A freeze that only stops transform tracks and slider APIs misses carousels that slide by `scrollLeft` on an
  `overflow:hidden` wrapper (Trustindex); and `scrollIntoView` scrolls every clipping ancestor, so record and restore
  scroll offsets around it (web-compare noise floor, review 1).

## Mapping into the Snapshot
- Serialising an inline SVG with its computed paint (a fingerprint or a vector): write paint only on parts drawn in
  place, never on a `<symbol>` or a `<use>` target (the instance would take the target's inline style and lose the
  use's inherited paint), and declare `xmlns:xlink` when the markup uses `xlink:` or the standalone SVG won't parse
  (web-compare fixer 1).
- Frame names made from slugs go through normalise's `pageUrl`, which sends any name starting with "home" to `/`:
  `/home-inspections/` would link home. Name own-page frames so only the real home matches (web-capture review 1).
