# Reading a live website (website importer, compare tool, live probes)

Read-only GETs of public pages, through the repo's Chrome driver (`test/browser/chrome.ts`). Never log in, never write.

## Access
- A site may start answering automated Chrome with a bot check ("Checking your browser…"), as bdryswi.com did on
  2026-10-29 after a day of agent probes. Hiding the automation flag is refused as bot-check circumvention: stop
  loading that site and hand the live check to Justin (allow-list the capture or pause the check). A bot page need not
  reload itself, so it can pass a naive "page loaded" check: read the document's status
  (`performance.getEntriesByType('navigation')[0].responseStatus`) and treat a page with no builder template or
  landmark, no link and under ~20 layers as not the site's page; decide from structure, never from its words
  (web-capture fixer 1). The plugin-made Hostinger site can stop answering for about a minute after several
  back-to-back 16-width compares ("didn't finish loading within 60s"): keep those runs, confirm with one curl and
  re-run into new folders (web-compare amendment-1 builder).

## Writing readers
- Probe pages need `<meta name=viewport content="width=device-width">`; without it the phone ranges lay the page out at 980px (web-capture verifier 2).
- Don't tokenise words per text node: the plugin's own markup splits `(800) 457-3160.`, `50+`, `100%` into pieces;
  glue pieces with no space between them whose drawings touch (in any ground-truth script too). A whitespace-only text
  node between flex or grid items is never drawn (Elementor's counter: `98` `%` on their own source lines), so test it
  with a Range client rect before letting it end a word (web-compare review 6). A word-by-word
  ground truth compares all four edges of each word's Range rect (left and top alone call a letter-spaced word alike)
  and includes pictures' boxes. Don't measure places
  from structural section tops: space given as margin on one page and padding on the other moves every section top
  while no word moves; measure from the first matched words unless both pages paint the section (web-compare
  amendment 1).
- Write in-page readers as typed, self-contained TS functions sent with `Runtime.evaluate` as `(${fn})(args)`: Node's
  type stripping keeps `fn.toString()` valid JS; the function must not close over imports or outer variables
  (web-capture planner).
- `CSS.getMatchedStylesForNode` lists matched rules in cascade order (specificity, then source order): the last normal
  declaration, then the last `!important` one, wins. It returns only rules matching now: read once per width range.
  A shorthand through `var()` (`padding: 40px var(--side)`, `gap: var(--g)`, `font`, `grid-template`, `grid`) is listed
  with its longhands after it, each with an EMPTY value: skip empty values or they wipe it, then resolve and expand
  every shorthand that sets a longhand you read (web-capture verifier, fixer 10). A size the site set whose computed
  value stays an expression (`min(92%, 980px)`) sizes the content box under `content-box`: never check it against the
  border-box width (probe content-box/border-box twins); a value the capture makes up (a box with no width of its own)
  must still reproduce the border box. A `%` is of the grid area for a grid item and
  of the padding box for a placed box, not the parent's content box: probe a grid child and a placed box too
  (web-capture review 10). `computedStyleMap()` keeps a unitless
  line-height as a number and an unset top/left as `auto`, where `getComputedStyle` gives px (web-capture).
- The face a word draws with comes from CSS font matching, not an exact weight/style key: a 700 run in a family that
  declares 400/600 uses 600, and an italic with no italic face is synthesised. Probe font readers with an undeclared
  weight and an italic run, faces loaded and failing, and compare the ink width with the fallback's (web-capture
  verifier). Chrome matches on descriptors only: a picked face that failed is drawn with the next family, never another
  face of the family; Google lists a family's unicode-range subsets latin last, so read a descriptor group's status as
  loaded, else failed, else first (web-capture fixer 9).
- Before turning a silent fallback into a note, capture the live homes with and without it and count the notes: a flood
  shows the wrong base or non-binding cases at once (plugin-made home 30 → 211, one per Bricks `max-width: 100%`); fix
  the rule the flood shows, not the note (web-capture fixer 9). Count on a fluid-type probe too (body text inheriting a
  `clamp()` size, buttons padded in em), with ids on every element as Bricks writes them and without: homes that set
  every size per class in px hid a 2 → 118 flood (web-capture review 10). Decide a note inside the helper that knows
  whether the site set a value, not at each caller (fixer 10).
- A list of "facts that changed" (switch points, drift checks) misses whatever isn't on the list: width-only,
  min-height-only and flex-basis-only media queries must count (web-capture review 1). Compare sizes as the site set
  them (`computedStyleMap()`: `50%`, `auto`, `1fr 2fr`, `min(100%, 1140px)`), not drawn px, so text wrapping never makes
  a switch point; count a length as drift only when its step across the boundary equals a neighbouring step (±0.75px),
  since a 50% column that becomes 100% changes on both sides yet really jumps there (web-capture fixer 1). Any fixed
  list misses something: compare every computed property (`computedStyleMap`, minus a short named skip list: custom
  properties, animation/transition timing, cursor, and properties that draw nothing: scroll-margin/padding/snap,
  overscroll-behavior, tap-highlight colour, text-size-adjust, whose inherited values flag every box) where the quick
  list finds nothing; all ~479 properties cost ~0.7 s per 864 elements, so keep b+1 in the page and re-read only what
  differs. Time it on a page with ~30 mostly empty boundaries and ~1500 elements, not the corpus homes (2–5
  boundaries): it took bdryswi-like discovery from 19.5 s to 75.9 s (web-capture fixer 3, review 4). Reusing the
  last width's reading spares only a boundary right under another empty one (82 → 73 s there): count shared widths
  in the candidate list before estimating a reuse saving (web-capture fixer 4).

## What counts as shown
- Fixed boxes the design width hides (a phone-only "Call now" bar, a header's phone-only fixed bar) must be read from the ranges that show them: collecting floating boxes only from the design width's reading drops them silently. Probe floating and fixed clauses with a fixed box shown only at 767 and below and one shown only above (web-capture verifier 3, V3-F1). Build such a box from the range that shows it (the design width's range has no rect: `sizingOf` throws), and measure every window-relative test (the backdrop's half-the-window) against that range's window, or a phone-only dim layer becomes an "own" extra; compare base and head floating lists on the live homes (wave-1 fixer 12).
- Hidden is more than `display: none`: `visibility: hidden` (closed dropdowns, megamenus, popups) and screen-reader
  boxes hidden with the old `clip: rect(…)` (Bricks' `.skip-link` is 20×10 with padding, not 1×1) are not visible
  layers (web-capture review 1). But the capture reads after its freeze scrolls back to the top, so reveal-on-scroll
  content that hides itself again off screen is `visibility: hidden` then: probe a reveal that toggles both ways
  before changing what counts as shown (web-capture review 2). Bricks Interactions hide entrance content with opacity,
  not visibility (`:not(.brx-animated)[data-interaction-hidden-on-load]`, `.brx-animated[data-animation*=In]`), start
  after `setTimeout(delay)` and then wait for the box to come into view once: a scroll-through faster than the delay
  leaves every plugin `cta-motion` button below the first screen at opacity 0. Probe Bricks pages with Bricks' own
  rules from the site's `frontend-light-layer.min.css` (web-capture review 5). A Bricks Interaction's load fade-in
  can race a reader's load reading, so its trigger (load/scroll) or duration reads differently between two loads of
  the same page (web-compare fixer 4: 2 timing findings in a self-compare of the plugin-made home), so a noise-floor run that happened to read them alike mutes nothing: take as the noise file a self-compare report that holds the variation, and say so (web-compare fixer 6). The race varies in either of two fields, trigger (load → scroll) or duration (1000 → 1500): a noise key that includes the field mutes only the one its floor read (web-compare review 8). Undoing them takes
  more than one pass: Bricks arms a box (`.brx-animated` + an "In" `data-animation`) after its timers and re-arms an
  `enterView` box each time it re-enters view, so remove the marks and keep a MutationObserver on `data-animation`/`class`
  removing them again; lift `data-interaction-hidden-on-load` only when the box's own `contentLoaded`/`enterView`
  animation targets it (a hover or click overlay keeps it). Bricks' hide rules sit in `@layer bricks`, so a box's own
  opacity beats them (web-capture fixer 5). Never send `bricks/animation/end/<id>` to run chained "Animation end"
  steps: it also runs what the end sets off (a class opening a panel, a hide, a pop-up). Let the first screen play in
  a bounded wait at the top (still 1 s, 6 s cap; finite opacity/visibility/transform/filter/clip-path animations and
  transitions counted through their delay, plus inline opacity/visibility tweens). Count only what can be seen
  ending: a finite animation longer than the wait's time left (a 20 s Ken Burns zoom) doesn't hold it and is finished
  at its end anyway; give the wait a floor of one still spell. Never count a box's opacity turns to
  call it a loop: any threshold N is beaten by a finite entrance with N turns (a word swap and a restarted fade turn
  twice, a bounce 6 times, a flicker 17; a two-turn rule read a swap intro at 0.575). Wait for every inline
  opacity/visibility change and accept that an endless pulse or blink holds the wait to its cap, with a note that the
  page was still moving (web-capture review 8, fixer 8). Test such a reader on motion
  started after it attaches, not only at load, or it never sees a tween's first write (web-capture review 7, fixer 7).
  Show chained steps below the first screen from
  the marks (the step's animationId, or the box's own last earlier startAnimation). The freeze's own scroll-through
  still fires Bricks' scroll-offset triggers (`bricksScrollInteractions`) (web-capture review 6, fixer 6). Probe Interactions with the site's own
  `bricks.min.js` and `bricksData` served locally (GET the theme file), not a reduced copy, on painted boxes
  (web-capture review 6).
- A page whose body is its scroller (html's overflow not visible, body overflow-y auto/scroll with a set height, e.g.
  `html,body{height:100%;overflow-x:hidden}`): the window never scrolls, so `window.scrollTo`/`scrollY` do nothing,
  lazy loaders fire only when body scrolls, and a wheel event scrolls body unseen. Scroll `document.body` and take the
  page height from it (web-compare fixer 2). Move any page scroller with `scrollTo({top, behavior: "instant"})`:
  under the site's `scroll-behavior: smooth` a plain `scrollTop` assignment only starts an async scroll (web-capture
  fixer 3). Don't find a body scroller with a small test move at all: `scroll-snap-type: y` snaps a 1px move back, so
  body reads as not scrolling and the page as one window tall; decide from html's overflow, body's overflow-y and its
  scrollHeight, or move it to its far end (web-capture review 4). With `mandatory` snapping and no snap area at the
  top, Chrome rests the scroller at its first snap area from the load on and snaps every `scrollTo(0)` back there:
  turn snapping off for the page load (`* { scroll-snap-type: none !important }`, which draws nothing) before the
  first scroll (web-capture fixer 4).
- Parts from landmarks: many sites have `<header>` and `<footer>` but no `<main>` (Divi, older themes, plain div
  pages), or only a footer: probe those shapes (web-capture review 2), each with a phone-only box between the parts,
  and twin pages differing by one tag (`<footer>` vs `<div>`, with or without `<main>`): parts built from boxes shown
  at the design width lose it (web-capture review 3).
- `documentElement.scrollWidth` stays wider than the window when html/body has `overflow-x: hidden|clip`, though nobody
  can scroll: a sideways-scroll check also reads the window's effective overflow-x (html's, else body's when html's is
  visible) (web-compare review 1). The same holds for clipping: body's computed overflow goes to the viewport when
  html's is visible, so a reader collecting clip ancestors must not treat body as a clip box, or `html,body{height:100%}`
  plus `body{overflow-x:hidden}` drops every word below the first screen (web-compare review 2).
- Lazy pictures load only after a scroll-through; a resize differs from a fresh load at some widths (fixed boxes at
  767, widths at 390 on bdryswi.com): load each range fresh (web-capture planner). A probe page with no media query is
  captured as one range, so the phone path (touch wake, phone layout) never runs on it: give phone probes a switch
  point at 767 (web-capture review 8).

## Hover, focus and motion
- To read a hover/focus end state with `CSS.forcePseudoState`, first finish the target's transitions and stop its
  animations (`el.getAnimations({subtree:true})` → `finish()`): injecting `*{transition:none!important}` alone loses to
  a site's own more specific `!important` transition (OneTap), and without either it reads mid-transition (Elementor
  "grow" read 1.0038 instead of its end scale). Read duration/easing separately; Elementor hover animations also fire
  on `:focus` (website-importer probe, web-compare).
- A freeze that only stops transform tracks and slider APIs misses carousels that slide by `scrollLeft` on an
  `overflow:hidden` wrapper (Trustindex); and `scrollIntoView` scrolls every clipping ancestor (carousels, sideways
  scrollers: their first item can land past the page edge and be dropped), so scroll only the page's own scroller (the window, or body when body is the scroll container: "only the window"
  never moves a body-scroller page; web-capture review 3) and put it back, or record and
  restore every scroll offset (web-compare review 1, web-capture fixer 2).
- Never move the CDP mouse onto a page you read. Chrome moves `:hover` onto whatever a programmatic scroll brings under
  a resting pointer after ~100 ms (opening hover dropdowns), and once the pointer has been on the page a leave can't be
  avoided: one leave both opens exit-intent pop-ups (Bricks `mouseleaveWindow`, jQuery `mouseleave` bound as
  mouseout, window and side-edge checks) and hides cursor rings and pointer glows, so no park or held leave reads it
  right. To wake first-input loaders send only a `mouseWheel` with no `mouseMoved` before it: it arrives as a trusted
  wheel while Chrome keeps the pointer's place unknown (no enter, move, `:hover` or later leave) (web-capture fixers
  2, 6 and 7, review 7). Libraries listen page-wide for good: Splide (Bricks' Slider Nestable) binds `touchstart mousedown` and `keydown`
  on the document, Swiper (Elementor's carousels, Bricks' legacy Carousel/Slider) `pointermove` on desktops, and
  jQuery's delegated `mouseenter`/`mouseover` handlers a native `mouseover`, so a page-wide "listens for first input"
  check fires on ordinary slider and menu pages with nothing missing. Read a live page's handlers with
  `DOMDebugger.getEventListeners` before fixing such a check's event list; for an inline `<script>` its
  line/column count the HTML document's lines (0-based), so read the page's HTML there, not
  `Debugger.getScriptSource` (web-capture fixer 8, review 9). List what is hidden at the scroll position the reader reads from (the top), not where the
  scroll-through left the window. A test of a hover step must put the target where the scroll really reaches it, or
  its mutant survives (web-capture fixer 2, hover-probe.txt).

## Mapping into the Snapshot
- On a website capture `site.tiers` owns every measured layer (`Rule.owns`), so another rule's write never reaches the paste and is recorded in `adapt(...).yielded`: a test proving a plugin rule's targeting on a capture reads `decisions` plus `yielded`, not the paste (stack-1, embeds AC6).
- Judge an importer layout job on every real capture on hand (home, contact, gallery), not one home page: measure `document.documentElement.scrollWidth` of head and base pastes at ~15 widths incl. 768 and 320; when nothing sits past the window yet the page is wider, list elements with `scrollWidth > clientWidth` (a Bricks Block with a fixed height wraps its overflow into a second column from 767 down). A 'view' that shallow-copies a node with a range's box leaves its children at design-width coordinates, so every parent/child geometry helper misfires (web-tiers review 1: `overflowsY` turned 104 min heights into fixed heights). Fixing the view changes what the style helpers see (`labelRoom` then read a site's spanning block of words as spare room): re-run AC10's J0 compare after any view change; units passed while it failed by 165px (web-tiers fixer 1). J1 records no box for a layer hidden in a range, so the view keeps its desktop box: any box-vs-layers check through a range must skip or place hidden layers; probe with a layer hidden in the range and a normalise-made group (web-tiers verifier 2). A "skip measured layers" guard that reads only the node's own `src.measured` misses rows normalise infers inside a box J1 reads as layout NONE (`<id>~y<n>`, no `measured`, measured items): check the items too, and prove such ACs on the real demo captures (web-tiers auditor: a phone slider of the Gallery's photos).
- Served markup can differ from the live page: an API script builds a frame from an empty placeholder (YouTube's player in Elementor's Video widget), a lazy loader swaps `src` (`about:blank` + `data-lazy-src`/`data-src`), and a site's script reveals fixed boxes kept at `opacity:0; pointer-events:none` (letsgro.ai's dot nav). Probe all three before pasting served markup or promising a rebuilt box shows (web-embeds review 1, R1-1–R1-3). Business sites also name third-party hosts in data (Yoast's `application/ld+json` `sameAs`, analytics data layers): only scripts the browser runs as JavaScript count as a widget's script, and a host-guessing rule counts an inline script only when it loads or calls the host (web-embeds fixer 2).
- A capture range is read at its anchor (the middle, 880 for 768–991) while compares and real tablets read the tier's edge (991), so anchor px drift there: px grid tracks that fill the grid become `fr`, a `max-width: 100%` stored as px is no cap, and a range's own CSS width (`calc(…vw …)`) is written as CSS. Diagnose by saving the capture in the live test and comparing the paste's rects with the capture's `web.boxes` at the compare width (web-tiers AC14: 104 → 45 findings at 991).
- A site fact mapped as a Figma annotation (an `img alt` → `alt:`/`decorative`) outranks the panel's saved description in `normalise/notes.ts`, and the uploader's `syncAlts` writes it back to WordPress: any imported value the user can edit needs a test that the edit survives a re-conversion (web-panel review 1, 29 of 31 photos lost a typed description).
- Serialising an inline SVG with its computed paint (a fingerprint or a vector): write paint only on parts drawn in
  place, never on a `<symbol>` or a `<use>` target (the instance would take the target's inline style and lose the
  use's inherited paint), and declare `xmlns:xlink` when the markup uses `xlink:` or the standalone SVG won't parse
  (web-compare fixer 1). An inline SVG serialised alone also loses what its `<use>`s and `url(#id)` paints point to
  outside it (a page-wide sprite of `<symbol>`s, a shared gradient): copy those ids into its `<defs>`, following what
  they point to in turn. Chrome draws a sprite file (`sprite.svg#id`) only from the page's own origin, never from
  another, so don't fetch a cross-origin one from Node (web-compare fixer 2). Tests of lost SVG paint need a saturated
  colour: a thin #333 icon is within the hasher's colour tolerance of black.
- Frame names made from slugs go through normalise's `pageUrl`, which sends any name starting with "home" to `/`:
  `/home-inspections/` would link home. Name own-page frames so only the real home matches (web-capture review 1).
