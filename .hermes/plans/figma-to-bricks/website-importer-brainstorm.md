# Website importer: a live website → a one-to-one Bricks copy, through the same plugin (proposal, amended)

Proposal (brainstorm), no build and no repo change. Planner: Opus 5.5 xhigh, 2026-10-29, read from `main` at `dea6296`
(build `2026-10-29.1`). Brief: `~/.hermes/plans/figma-to-bricks/briefs/website-importer-planner.md` (with **Amendment
1**, Justin's final answers). Justin's request: `briefs/website-importer-brainstorm-prompt.md`.
Evidence (probes, saved pages, shots): `~/.hermes/plans/figma-to-bricks/evidence/website-importer/planner/` (the first
version of this proposal is kept there as `website-importer-brainstorm-v1.md`).

**Goal (Justin, 2026-10-29):** "The most important thing is that this implementation works so it can get every page and
turn it into a one-on-one copy." Any live website a client owns becomes, page by page, a Bricks paste that looks and
moves like the old site at every screen width, made by the plugin's own back half so every plugin rule and fix applies
to websites too.

**Amendment 1 changes** (from the first version of this proposal): question 3 is now C (exact at every width: the paste
carries its own CSS for the site's in-between ranges); question 6 now keeps the floating extras, once per site with the
footer; milestone 2 is committed and built straight after milestone 1; the proof covers several pages and a
non-Elementor site; between measured widths the copy follows the site's own stretchy sizes; motion and hover timings are
read exactly and compared; forms are styled like the old form. Wave one (J0, J1) has brief-ready sections in §11.

---

## Justin's answers (final, 2026-10-29)

The first round (binding): straight to Bricks; the site's own layout at every width in one copy; command + panel;
widgets embedded or rebuilt (forms → the plugin's Bricks Form, maps → the plugin's map); page by page, with the header
and footer as their own pastes once.

The second round (Amendment 1), chosen for the most faithful one-to-one copy:

| # | Question | Answer |
|---|---|---|
| 1 | What goes first | Layout first (milestone 1), then milestone 2 (hovers, entrance animations, sliders and accordions, forms, flip boxes, hotspots, pop-ups) built straight through: one job list, nothing optional |
| 2 | The plugin's Figma-only additions on imports | **Off**: a faithful copy; only invisible website rules stay |
| 3 | Widths where the site and Bricks switch differently | **C: exact at every width**: the paste carries its own CSS for those ranges (bdryswi.com's 992–1024 tablet and 1025–1366 laptop layouts), no setup on the new site |
| 4 | The site's device-only copies | Keep both, each shown where the site shows it |
| 5 | Fonts that fail on the old site | The real face (a failed font's fallback differs per visitor, so there is no single fallback look) |
| 6 | Floating extras (chat, accessibility button, cookie bar, badges, floating call buttons) | **Kept, once per site with the footer part**, so they show on every page: third-party ones as their original embed code, the site's own floating elements rebuilt; listed in the panel |
| 7 | Ownership check | The command asks once per website and remembers |
| 8 | Bricks Migration Engine | Build our importer anyway; an optional free 3-page comparison if you have admin on an Elementor client site |

**My rulings inside these answers (not yet confirmed; each is named again where it applies):**
- R1. A floating extra that is a WordPress plugin's own widget (its files come from `/wp-content/plugins/<name>/`, not
  from the page builder, e.g. bdryswi.com's accessibility button and panel) is listed as "install <name> on the new
  site", not rebuilt: a copy of its look without the plugin would be a button that does nothing.
- R2. Answer 2's "invisible website rules stay" means: the keyboard focus ring, reduced motion where the site already
  honours it, whole-hundred font weights, no `main`/`header`/`footer` tags of the plugin's own, no link to a picture
  file. Everything the plugin adds that changes what a visitor sees (balanced/pretty line wrapping, tap areas that grow
  a box, the label minimums, section rhythm, CTA motion and full-width phone buttons, photo-card zoom, phone-only
  copies) is off on imports.
- R3. Pop-ups (Elementor pop-ups, hotspot pop-ups) are their own parts, like the header and footer: the panel offers
  "Paste: Pop-up <name>" for a Bricks pop-up template, and the trigger on the page opens it (milestone 2, J10).

---

## The recommendation in three lines

1. **Approach A:** a command reads the live site in Chrome at every width where the site changes (its own switch points,
   both sides) plus the Bricks and check widths, and writes one capture file shaped like the plugin's debug file; the
   plugin's existing back half turns it into the Bricks paste.
2. **Exact at every width:** the site's own values reach Bricks through a recorded per-width fact on every box and one
   rule that writes it: into Bricks' own tablet/phone settings where the site switches where Bricks does, and as the
   paste's own range CSS where it switches elsewhere, with the site's stretchy sizes (%, vw, vh, clamp, fr) kept in
   between; the plugin's own phone rules only fill what the site didn't say.
3. **11 pipeline jobs in 4 waves:** milestone 1 (6 jobs: compare tool, capture, per-tier layout, ranges and stretchy
   sizes, panel, embeds/maps/floating extras), then milestone 2 (5 jobs: hover, motion, sliders and accordions, forms,
   flip boxes/hotspots/pop-ups), proven on every page of bdryswi.com and on two non-Elementor sites.

A 300-line spike already ran bdryswi.com's Home through the unchanged plugin: 405 Bricks elements, no errors, the
desktop recognisably right (section "Evidence").

---

## What you'd do (the walkthrough)

**Is it an application?** No new app. It is one command in the plugin's project folder, plus the Figma panel you
already use. You (or Claude) give the command the page's address; you don't copy anything from the site.

1. **Capture a page.** In a terminal in the plugin folder (or ask Claude: "capture bdryswi.com's contact page"):
   `npm run capture -- https://bdryswi.com/contact-us/`
   - The first time for a site it asks: "Is bdryswi.com your client's own site? (y/n)".
   - `npm run capture -- https://bdryswi.com/ --list` lists the site's pages (from its sitemap, else its menu links);
     `--all` captures them one after another.
   - You see one line per step: `Switch points found: 1366 1024 921 767 544`, `Reading at 24 widths… ✓`,
     `Pictures 31/31`, `Fonts: Roboto 400 500 600 700 (Google)`, `Parts: header, page, footer`,
     `Floating: accessibility button (WordPress plugin "onetap": install it), reCAPTCHA badge (with the form)`,
     `Widgets: 1 reviews widget (embed), 1 map, 1 form`.
   - It writes `bdryswi-com-contact-us.f2b-capture.json` to your Downloads folder (10–40 MB: the pictures are inside)
     and a check page with the old site and the copy side by side at each width. About 5 minutes a page.
2. **Open the plugin in Figma** (any file; nothing is drawn in it). Drag the capture file onto the panel. The panel
   shows `Website: bdryswi.com, Contact us. Parts: header, page, footer.` and **Paste: Page / Header / Footer** (plus
   any pop-ups).
3. **First page of a site: the header and footer once.** Choose **Header**, **Convert and copy**, paste into your
   Bricks header template, save. Same for **Footer** (it also carries the site's floating extras: chat, call buttons,
   embeds that show on every page). The panel then remembers, per WordPress site, that the header and footer are done:
   its two ticks turn on.
4. **The page.** Choose **Page**, Convert and copy, paste into the page, save. Pictures go to WordPress, picture
   descriptions, fonts and page links work as they do for Figma designs today.
5. **After pasting**, as today: **Regenerate code signatures** (embeds), **LiteSpeed → Purge All**, and the panel's
   list: which widget accounts must allow the new site's address (e.g. Trustindex), which WordPress plugins to install
   (R1), the header template's sticky setting with its value, and the form's reCAPTCHA keys.
6. **Later pages:** capture, drop, **Page**, Convert and copy, paste. Header and footer are left out by themselves.

**What you get back:** the same as today: a Bricks paste on your clipboard and the panel's notes.

---

## 1. Approaches compared

Research read on 2026-10-29 (sources at the end).

| What you want | **A: our importer** | **B: website → Figma tool, then the plugin** | **C1: Bricks Migration Engine** | **C2: Bricks' "HTML & CSS to Bricks"** (2.3+) |
|---|---|---|---|---|
| Works from the address of any site | **Yes**, any builder | Yes | No: admin access, Elementor active on the same install | No: pasted HTML/CSS |
| Desktop layout | Yes (spike: recognisable at 1440) | Yes, often messy layers on complex CSS | Yes (vendor: "up to about 90%") | Partly |
| The site's layout at every width, one copy | **Yes**: measured at every switch point, exact ranges, stretchy sizes | No: each width a separate frame; the plugin pairs only a desktop and a phone frame, as two copies | Breakpoints mapped (vendor) | Only queries at exactly 991/767/478 |
| Hovers with their timing | Yes (J6) | html.to.design: hover variants, no timing | Yes (vendor) | Custom CSS |
| Entrance and running animations | Yes, timing read exactly (J7) | **Lost** | 36 entrance animations (vendor) | Lost |
| Sliders, accordions, flip boxes, pop-ups, forms | Yes, as the plugin's widgets (J8–J10) | Lost | Sliders, forms, tabs, pop-ups (vendor) | Lost |
| Pictures, fonts, alt text, links to the new pages | The panel's existing uploads, fonts, alttext.ai, page matching | Through the panel after Figma | Converts in place on the old install | Manual |
| Your plugin's rules and fixes apply | **Yes** | Yes | No | No |
| Cost | ~11 pipeline jobs | html.to.design $12–18/month | $39 / $79 / $169 | Included |

**Why A:** it is the only route that works from an address on any builder and keeps per-width layout, hovers and
animations, with every plugin fix applying to websites (your 2026-10-29 rule). B loses animations and sliders and gives
one frame per width. The plugin already meets B's output: the Contact page's map and form were page captures in Figma
and needed special rules (`normalise/mosaic.ts`, `style/shares.ts` "two equal columns"). C1 is Elementor-only, needs
admin and is untested; C2 is weaker than the plugin's own emitter.

---

## 2. How the importer reads a site

### In plain words

The command opens the page in headless Chrome, as a visitor's browser would. It first finds every screen width where
the site changes its layout (from the site's own style rules, checked by looking at both sides of each width). Then, at
each of those widths and at Bricks' and the check widths, it scrolls the whole page so every lazy picture loads, waits
for fonts, stops sliders on their first slide and lets entrance animations finish, and writes down every box: where it
is, how it lays out its children, its colours, borders, corners and shadows, its words with font and links, its
pictures (downloaded, full size), and the sizes the site wrote in stretchy units (a 5% padding, a 100vh hero, a font
that grows with the window). It reads the header and footer templates (the hand capture missed them; they are in the
page, probe 1) and the floating extras. It folds boxes that only wrap one other box (the spike: 1,436 boxes → 320
layers). For Elementor sites a small reader adds what the page says about itself (its switch widths, which template is
the header, footer and each pop-up, its animations with their exact speed, its sliders' timing); other sites get the
same capture without those extras, plus readers for common libraries.

### For the planner (technical)

**Front half, new: `src/web/`** (Node only, never in the Figma bundle; `tsconfig.sandbox.json` keeps it out):
- `src/web/read/`: the in-page reader (a function serialised into `Runtime.evaluate`) returning raw facts per element:
  rect, a computed-style subset, text runs with line boxes (`Range.getClientRects`), picture sources (`currentSrc`, the
  largest `srcset` candidate, CSS `background-image`, `<picture>`), inline SVG, links, open shadow roots walked,
  `display:contents` flattened. Plus authored values through CDP `CSS.getMatchedStylesForNode` (below).
- `src/web/map/`: pure: raw facts → Figma-shaped `SNode`s; unit-tested from saved raw-fact fixtures, no Chrome.
- `src/web/capture.ts`: orchestrates CDP (the project's own client, `test/browser/chrome.ts`, moved to a shared module
  or imported), widths, freezing, downloads, the file. `tools/capture.ts`, npm script `capture`.

**Switch points (answer 3 C):** collect every `min-width`/`max-width` boundary of the page's media queries (CSSOM, plus
CDP for stylesheets the page can't read; probe 1 found about 50 distinct boundaries on bdryswi.com, from Elementor and the
Astra theme), measure each boundary's two sides (`b` and `b+1` for `max-width: b`), and keep the boundaries where any
recorded fact changes: those are the site's real switch points (bdryswi.com: Elementor's 1366/1024/767 and the theme's
921/544 are candidates). The capture widths are the union of those pairs, the design width W = 1440, 1920, the Bricks
tier edges (992/991, 768/767, 479/478) and the check widths (390, 360). Full page loads at the main widths; viewport
resizes for boundary pairs, spot-checked against a fresh load.

**Stretchy sizes (Amendment 1):** for the lengths the plugin writes (padding, margin turned gap, gap, width/max-width/
min-width of fixed-or-capped boxes, height/min-height, font size, line height, letter spacing, placed offsets, grid
tracks) the capture keeps, per range between switch points, the site's authored winning value when it is stretchy:
`%`, `vw`/`vh`/`svh`/`dvh`, `clamp()`/`min()`/`max()`/`calc()`, `auto`, `fr`. Rules:
- `var()` is resolved with the element's computed custom properties at that width (Elementor's values are `var()`
  chains, probe 1).
- `rem` and `em` become px (`rem` from the old site's root size, `em` from the element's font size): the new Bricks
  site's root size differs, so a copied `rem` would change size.
- `%` is kept only when its containing block is the same box in the paste; when folding changed the containing block,
  the value is re-based (fitted as `calc(a% + b px)` of the new parent from two measured widths).
- Every kept value is verified: its computed px at the range's two ends and middle must equal the site's measurement
  (±0.5px); otherwise the capture falls back to a piecewise-linear fit (`calc(a·100vw + b px)` per range) and notes it.

**Freezing before reading** (each one a lesson of the hand copy or a probe):
- Scroll through in 60%-of-window steps, set every `img.loading = "eager"` and await `complete` (probe 1: 6 shown
  pictures empty before the scroll, 0 after; lazy backgrounds 4 → 23 at 1440 and 28 at 390).
- Move the mouse and wheel once, and again near every empty third-party placeholder (Trustindex waits for a first input
  and fills only within 300px of the window: memory `bdry-home-copy`; probe 1 never saw it load without this).
- Record each animated element's animation first (milestone 2 reads it), then finish animations and remove the
  hidden-until-animated state (probe 1: 2 of 5 entrance-hidden boxes still hidden after a full scroll).
- Disable transitions before forcing `:hover`/`:focus` through CDP `CSS.forcePseudoState` (probe 1: a "grow" hover read
  as scale 1.0038, 50 ms into its 0.3 s transition); read the transition's own timing separately.
- Stop sliders on their first real slide (Swiper/Splide/Slick instances, else an overflow-hidden track of transformed
  slides), after recording slides and timing.

**Parts and floating extras (answers 5 and 6):** parts come from builder templates (`data-elementor-type` header /
wp-page / footer / popup) or landmarks (`header`, `main`, `footer`). Floating extras: every `position: fixed` (or sticky)
box outside the header, at any width. Each is classified by structure and source, never by class name:
- third-party: its script or iframe comes from another host → its original embed snippet (from the served HTML) goes in
  the **footer** part as a Code element;
- WordPress plugin widget: its files come from `/wp-content/plugins/<name>/` other than the page builder's → listed (R1);
- the site's own: built with the page builder → rebuilt as a fixed element in the **footer** part (stacking: the
  plugin's floating layers, z 90);
- a sticky header (or a fixed copy of it that appears on scroll) belongs to the **header** part: the sticky setting is a
  Bricks template setting the panel names with its value; a copy that appears on scroll is rebuilt with milestone 2's
  interactions (J10).

**Web page → Snapshot nodes** (Figma-shaped, so normalise and every later stage run unchanged):

| Web | Snapshot (Figma's names) | Notes |
|---|---|---|
| `display:flex` | `FRAME`, `layoutMode` H/V, `itemSpacing`, `layoutWrap`, `counterAxisSpacing`, padding, `primaryAxisAlignItems`, `counterAxisAlignItems` | Only when children sit where auto layout puts them (order, even gaps, no main-axis margins); else `layoutMode: NONE` and the plugin's free-frame inference (`normalise/infer.ts`, proven on GRO) |
| `display:grid` | Figma grid (`gridColumnCount`, `gridColumnSizes`, gaps, spans) | `fr` tracks kept as stretchy values |
| block flow | VERTICAL auto layout when stacked with even gaps (margins → gaps), else NONE | |
| child sizing | `layoutSizingHorizontal/Vertical` FILL / HUG / FIXED | Decided across widths (a box that tracks its parent is FILL, one equal to its content HUG, a constant one FIXED); the spike's 390 sideways scroll came from deciding at one width |
| `position:absolute` | `layoutPositioning: ABSOLUTE`, `constraints` from which of left/right/top/bottom are set (both → STRETCH, `left:50%` + translate → CENTER, % → SCALE) | Authored values via CDP |
| boxed content | inner frame `maxWidth` | `understand/section.ts` turns a centred narrower content box into the Container's max width |
| text | `TEXT`, `characters`, `text.segments` per styled run (family, style from weight, size, line height, letter spacing, colour, `textCase`, underline, `hyperlink`), `textAutoResize`, align, `absoluteRenderBounds` = ink | `<br>` → a line break, whitespace as the browser collapses it |
| text lines | `text.svg` written from line boxes (one `<tspan>` per line at its x/baseline) | Every reader of Figma's text SVG works unchanged |
| `<img>`, CSS background, `<picture>` | `IMAGE` fill, `scaleMode` from object-fit / background-size (crops → `imageTransform`), `imageHash` = SHA-1 of the bytes, `images[hash]` = natural size | Bytes downloaded by Node, full size (a CDN reader strips resize parameters such as Jetpack's `i0.wp.com/…?w=500`) |
| inline `<svg>`, `.svg` image | `VECTOR` + `vector.svg` (currentColor resolved) | |
| icon fonts, canvas, CSS the plugin can't draw | a `node:<id>` render (the element's screenshot) | The asset kind Figma uses for rendered layers |
| colours, gradients, borders per side, radii, shadows, opacity, blend, overflow | `fills` (SOLID / GRADIENT_*), `strokes` + side weights (INSIDE), radii, `effects`, `opacity`, `blendMode`, `clipsContent` | The spike skipped gradients: "Our Services" came out white on white |
| links | Open-link reaction / run `hyperlink` | Links to the old site's own pages become site paths (`/contact-us/`), matched to your new pages by the panel; others unchanged |
| device-only boxes | the node, with `hidden` per range | bdryswi.com Home: 34 (probe 2) |
| `:hover`/`:focus` | a component set (default + hover variant), `ON_HOVER` → `CHANGE_TO` with the exact transition | The plugin's hover machinery decides CSS hover vs states (J6) |
| entrance and running animations | new `web.motion` (keyframes, duration, delay, easing, trigger, once/repeat, per range) | Bricks Interactions / typed keyframes (J7) |
| sliders | a component set, one variant per slide, `AFTER_TIMEOUT` (delay) → `CHANGE_TO` next (speed) | Feeds `normalise/carousel.ts`; Swiper's delay starts after the change ends, as Figma's does (J8) |
| accordions | items with their answers as hidden layers | How `understand/accordion.ts` reads an FAQ (J8) |
| forms | new `web.form` (fields, types, labels, placeholders, required, options) and every field's measured look | Bricks Form styled like the old form (J9) |
| flip boxes, hotspots, pop-ups | front/back variants + hover + a `flip` annotation; `OPEN_OVERLAY` Manual; pop-up parts | (J10) |
| third-party widgets, maps | `web.embed` (original snippet) → Code element; a Google Maps iframe → the scene's `map` | (J5) |

**Lost or approximated:** JavaScript behaviour the plugin has no widget for (counters, filters; tabs until the Tabs
sample), parallax and scroll-linked effects (kept still and listed), canvas/WebGL (a picture), anything behind a login.

**Builder readers** (`src/web/readers/`), each keyed on a builder or library, never a site:
- Elementor: `elementorFrontendConfig.responsive` (bdryswi.com: mobile 767, tablet 1024, laptop 1366, widescreen 2400),
  `data-elementor-type`, `data-settings` (`_animation`, per-device `_animation_tablet`/`_mobile`, `_animation_delay` ms;
  duration classes `animated-slow` 2 s / default 1.25 s / `animated-fast` 0.75 s), carousel settings, flip-box,
  hotspot and animated-headline widgets, pop-up templates and triggers (printed after the footer).
- Bricks (the plugin's own output and other Bricks sites): `data-interactions`, Splide sliders.
- Libraries: Swiper, Splide, Slick, Animate.css, AOS.
- Generic fallback for every fact: landmarks, computed `display` per width, CSS `@keyframes` and `transition` on the
  element, `:hover` rules.

---

## 3. Exact at every width (answers 2 and 3) against the architecture

### In plain words

For every box, the capture records how it looks between each pair of the site's switch points. A new rule in the plugin
writes those values: into Bricks' own tablet and phone settings where the site switches where Bricks does (Elementor's
767 is also Bricks' 767), and as the paste's own CSS for the ranges Bricks doesn't have (bdryswi.com's 992–1024 tablet
and 1025–1366 laptop layouts, its theme's 921 and 544). Between switch points the copy follows the site's own stretchy
sizes, so in-between widths match too. Where the site said nothing (boxes the plugin adds, Bricks' own quirks), the
plugin fills in. The site wins every disagreement. The price is editability: values in range CSS are edited in the
element's Custom CSS, not in Bricks' controls.

### For the planner (technical)

1. **Recorded fact, earlier stage.** `SNode.web.ranges`: the site's ranges `[min, max]` (from the switch points), and per
   range only what differs from the design width W's range: layout direction, wrap, gap, padding, grid tracks, order,
   width mode/size, height, font size/line height/letter spacing, text align, placed offsets, `hidden`, each value px or
   a verified stretchy value. Normalise types it as `SceneNode.site?: SiteLooks`; IR nodes keep it through `src`; no
   later stage edits it.
2. **The style model gains site ranges.** Today's tiers are `fluid | tablet_portrait | mobile_landscape |
   mobile_portrait`. A measured page adds typed range layers `{ min, max }` (`Layers.ranges`), written only by adapt rules
   and serialised once by emit into `_cssCustom` under a media query made in `src/shared/breakpoints.ts` (a new
   `rangeMedia(min, max)`, the only place media queries are written). Collision checks cover ranges.
3. **One rule writes it:** `src/core/adapt/rules/site.ts` (`site.tiers`, decision "the old site's own layout at every
   width, exact (Justin, 2026-10-29, answers 2 and 3C)"), last in `RULES`. Per measured node and property:
   - a site range that equals a Bricks tier (`≤767` = `mobile_landscape`) → that tier's Bricks control key;
   - a site range above 991 (992–1024, 1025–1366, ≥ 2400) → range CSS; Bricks prints the desktop control rule, then
     custom CSS, then the tier rules, so range CSS above 991 wins over the desktop control at equal specificity (skill
     pitfall, from the hero-logo-size planner's staging CSS);
   - a site switch inside a Bricks tier (921 inside 768–991, 544 inside 479–767) → that property is written for that
     whole tier as range CSS only (no tier control for it), because the tier rule prints after custom CSS and would win;
   - the design width's own value stays the base control value; a range going back to it writes it explicitly.
4. **The site wins, by an engine gate.** On a measured page (`Scene.web` present), a write by any other rule to a
   `node|tier-or-range|prop` the site measured is dropped and recorded as `yielded: site.tiers` (`overrides` alone lets
   a narrower write leak through where `site.tiers` wrote nothing because the value didn't change). This covers the
   `fluid` tier too: the plugin's own clamp is replaced by the site's stretchy values on measured properties.
5. **No plugin phone copies of measured nodes:** `understand/phone.ts` `planPhones` skips them (the spike's paste made 2
   phone sliders the site doesn't have). The site's own device-only copies stay, each `hidden` where the site hides it.
6. **The plugin's visible Figma-only behaviours are off on imports** (R2), each by a `Scene.web` check in its own module.
7. **What the plugin still owns:** Bricks quirks (every element capped at its parent's width, Blocks wrapping from 767
   down, `_alignSelf: stretch`, flex-basis in px), deterministic ids, payload safety, the invisible website rules. Boxes
   the plugin creates (Containers, bands, hover copies, slides) and widths under the narrowest measured get the plugin's
   own rules (gap filling). A site that itself scrolls sideways or uses tiny text at some width is copied as it is and
   named in the panel.
8. **The test renderer must print as Bricks does.** `test/browser/render.ts` prints element custom CSS after all
   settings CSS; live Bricks 2.3.9 prints desktop controls, custom CSS, then tier rules. The compare tool renders in
   Bricks' order (J0), and a live paste round trip proves the range CSS (AC28).
9. **Figma conversions don't change:** every new path runs only when `Scene.web` exists; corpus files convert
   byte-identically (AC12).

---

## 4. The panel opening a capture file (answer 3)

### In plain words

The panel learns to take a capture file instead of selected frames. From there it does what it does today.

### For the planner (technical)

**New:**
- The drop handler (`src/ui/main.ts`, today font files only) tells a capture file (`.f2b-capture.json`, a Snapshot with
  `source: "web"`) from fonts; plus an "Open capture…" button.
- The panel keeps the capture's picture bytes and renders (`web.pictures`, `web.renders`) and sends the plugin only the
  snapshot without them: `{ type: "convertCapture", snapshot, part, inlinePictures }`. The plugin runs the same
  `resultOf()` it runs for a selection (plugin = replay byte for byte, as `plugin-convert.test.ts` pins today) and posts
  `result`; the panel feeds `run.add(item)` with `PictureItem`s built from the file (`fill:<hash>` → bytes, `svg:<id>` →
  the SVG in the asset, `node:<id>` → the stored render) instead of Figma's `exportPictures`.
- **Paste: Page / Header / Footer / Pop-up <name>**: the capture's roots are tagged by part; only the chosen part's roots
  are converted. The footer part carries the floating extras. After the header and footer are copied for a WordPress
  site, that site's header/footer ticks turn on (ticks are remembered per WordPress site since 2026-10-23).
- The capture's source address is shown, and the site check never matches a page link to the *old* site.
- Fonts the capture carries (non-Google files) are offered to the site's font library as if dropped.

**Works unchanged:** WordPress uploads (AVIF/WebP, the upload cache), picture descriptions and alttext.ai, Google Fonts,
the site's font library, page-link matching (`site-pages.ts`), the palette file, lists, videos, the clipboard, "Copy
again", every note. "Show" (zoom Figma to a picture's layer) is hidden for capture pictures; typed descriptions are saved
by picture (`hash:`) in the open Figma file, as photos are today.

**Debug path:** a capture file *is* a debug file: `npm run replay`, `snap`, `inspect`, `wraps`, `trace` and the corpus
take it. `npm run compare -- <capture> <url>` puts the paste beside the live site at every width (J0).

---

## 5. What the plugin already does, and what is new

| Feature | Reused | New work (job) |
|---|---|---|
| Sections, Container, bands, gutters, wide screens | ✓ | — |
| Layout plan, fluid desktop | ✓ (gap filling only on imports) | site ranges, stretchy values (J3) |
| Phone rules | gap filling only | engine gate, `planPhones` skip (J2) |
| Header/footer ticks | ✓ | parts read from the capture, not guessed (J1); Page/Header/Footer choice (J4) |
| Buttons by shape | ✓ | CTA motion and full width off on imports (J2) |
| Call and email links, page links | ✓ | old-site links → site paths (J1) |
| Live maps | ✓ | place from the iframe address (J5) |
| Code element (embeds) | ✓ sample | snippets from the served HTML, floating extras (J5) |
| Hover vs states | ✓ | hover variants with exact timing (J6) |
| Motion | scroll-linked Figma Motion | by the clock, once/repeat, exact timing, Bricks Interactions; running keyframes; drawn headline as the plugin's marker (J7) |
| Sliders that play by themselves, FAQ accordions | ✓ | slides/timing from Swiper/Splide/Elementor; answers as hidden layers (J8) |
| Bricks Form | ✓ emitter | fields from `<form>`, styled like the old form (J9) |
| Flip cards, photo hotspots | ✓ | from flip/hotspot widgets; pop-up parts and triggers; scroll-revealed floating copies (J10) |
| Fonts to WordPress | ✓ | font files carried in the capture (J4) |

---

## 6. The hard parts and limits

- **Range CSS and editability:** exact in-between ranges live in each element's Custom CSS (answer 3 C), so they are
  edited there, not in Bricks' controls. Values that line up with Bricks' tiers stay in its controls.
- **Stretchy values:** `var()` chains, `rem` against a different root size, and `%` against a folded parent each need the
  conversions in §2; every kept value is checked against the measurement.
- **Third-party widgets:** original embed code in a Code element (answer 4); you regenerate code signatures and some
  accounts must allow the new domain. They often load only after a first input, so the capture wakes them.
- **WordPress plugin widgets** (R1): listed with the plugin to install, not faked.
- **Forms:** the plugin's Bricks Form, styled like the old form; reCAPTCHA and email settings are set in Bricks
  afterwards (listed).
- **Fonts:** each face's load state is recorded (probe 1: bdryswi.com's own Roboto 400/500/600/700 and ADLaM Display
  faces all fail); the capture measures with the face the paste loads (answer 5). Non-Google font files travel in the
  capture to the site's font library.
- **Pictures:** full size, downloaded by the command (the panel can't fetch another site's files); lazy ones loaded by
  scrolling; the largest `srcset` file (at 390 the browser picks smaller files: 15 pictures by probe 1's rough check).
- **Pop-ups:** Bricks pop-ups are templates, so each pop-up is its own paste (R3) and its trigger opens it.
- **JavaScript-driven content:** what shows after loading and scrolling is captured; behaviour without a plugin widget
  is listed.
- **Other builders:** the generic reader works on any site; each builder in the corpus gets a reader only where the
  generic one falls short (Wix and Squarespace place more boxes absolutely; plain HTML and Bricks are clean).
- **Bot protection or a login:** out of scope; the command says so.
- **The old site keeps changing:** tests compare against saved captures and saved live shots.

---

## 7. How it's proven: pages, sites and the oracle

**The oracle (J0):** `npm run compare` renders the paste in Bricks' CSS order (with the capture's own pictures) and loads
the live page, freezing both the same way, at: 1920, 1440, every site switch point's two sides, the Bricks tier edges
(992/991, 768/767, 479/478), 390, 360, and in-between widths (the middle of every range, plus 1100, 880, 600, 430, 340,
320). It pairs boxes by their words and picture hashes (sections by order and first words) and reports, per width: each
section's height, each matched box's position and size, row-or-stack arrangement, words shown and hidden, sideways
scroll, cut-off words, picture shapes, font faces used; and (milestone 2) the timing table: every hover and focus change
(properties, end values, duration, delay, easing), every animation (keyframes, duration, delay, easing, trigger,
once/repeat), every slider (interval, speed, loop, pause), read on both sides.

**Pages, chosen by rule (no hardcoding):** every published page the site lists in its sitemap (`/wp-sitemap.xml`,
`/sitemap.xml`, `/sitemap_index.xml`), else every page its header menu links to, up to 20. bdryswi.com has 14 published
pages (REST, 2026-10-29): home, about-us, contact-us, foundation-repair, basement-waterproofing, crawlspace-repair,
exterior-drainage, basement-windows, egress-windows, sumppump, service-areas, warranty, privacy-policy,
terms-conditions. Live checks (Justin's) take Home plus the two pages the compare report lists first when ordered by
number of sections, most first.

**Sites, chosen by rule:** the capture labels each site's builder from the page itself (generator meta, body classes,
asset paths). The proof needs bdryswi.com (Elementor) plus at least one owned site whose label is not Elementor.
Candidates (2026-10-29, public GET):
- **growithgro.com**: GRO's own site, hand-built JavaScript, no WordPress or builder (no generator, no body classes):
  the generic reader alone.
- **darksalmon-badger-335429.hostingersite.com**: your live Bricks 2.3.9 site, built by this plugin (`wp-theme-bricks`,
  `brx-body`): a round trip (Figma → plugin → Bricks → capture → plugin → Bricks should match itself).

Ownership is confirmed through the command's own prompt (answer 7). The corpus list (`corpus/web.json`, captures kept
out of git like `corpus/out/`) names the sites; no code does. Generic local fixture sites (`test/fixtures/web/`) carry
every unit and browser test.

---

## 8. Acceptance criteria (proposed)

Each AC has one named test. "Live site reports" run the compare tool against the real sites and are saved as evidence;
the named test is the generic-fixture test that pins the behaviour.

### Milestone 1 (layout, pictures, fonts, links, parts, embeds, maps, floating extras)

- AC1 (proposed): Given a site address, when `npm run capture -- <url>` runs, then it writes one capture file that
  `loadSnapshot` reads, holding the page's header, page and footer as tagged parts (from builder templates or
  landmarks), its measurements at every capture width, and the bytes of every picture shown at any width, lazy ones
  included. Test: `test/web/capture-file.test.ts`.
- AC2 (proposed): Given a page whose media queries switch at widths that are not Bricks' (e.g. 1024, 921, 544), when
  captured, then the capture lists exactly the boundaries where something on the page changes and measures both sides
  of each; boundaries that change nothing are left out. Test: `test/web/capture-switch-points.test.ts`.
- AC3 (proposed): Given boxes sized in `%`, `vw`, `vh`, `clamp()`, `fr`, `auto`, `max-width` and `rem` (some through
  `var()`), when captured, then each range records the site's own stretchy value (`var()` resolved, `rem`/`em` in px,
  `%` re-based where its parent was folded) and each recorded value reproduces the measured px at its range's ends and
  middle (±0.5px). Test: `test/web/capture-stretchy.test.ts`.
- AC4 (proposed): Given fixed boxes outside the header (a third-party chat bubble, a WordPress plugin's button, the
  site's own floating call button, a cookie bar), when captured, then each is in the footer part only, classed
  third-party / WordPress plugin / own, with its embed snippet or plugin name, and none is in the page part. Test:
  `test/web/capture-floating.test.ts`.
- AC5 (proposed): Given links to the site's own pages, other sites, phone numbers and emails, when captured and
  converted, then own pages become site paths the panel's page check matches, the rest stay as they are, and no link
  points at a picture file. Test: `test/web/capture-links.test.ts`.
- AC6 (proposed): Given a page whose font face fails, when captured, then the capture lists every face the words use with
  its load state, measures with the working face it names, and the paste asks for the same families in whole-hundred
  weights. Test: `test/web/capture-fonts.test.ts`.
- AC7 (proposed): Given a capture, when replayed twice, then the pastes are byte-identical, the conversion has no rule
  collisions and passes `assertPayload`, and the plugin's conversion equals the replay byte for byte. Test:
  `test/unit/web-replay.test.ts` (plus a capture case in `test/unit/plugin-convert.test.ts`).
- AC8 (proposed): Given every page of bdryswi.com, one non-Elementor site and the fixture sites, when compared at 1920 and
  1440, then every section's height is within 1% (or 8px) of the live one, every matched box within 4px, every word the
  live page shows appears once, pictures keep their shape (±1%), and nothing scrolls sideways that doesn't on the site.
  Test: `test/web/compare-desktop.test.ts`; live site reports saved.
- AC9 (proposed): Given the same pages, when compared at every site switch point's two sides and at 991, 767, 478, 390
  and 360, then every measured box lays out its children as the site does (row or stack, same columns), every section is
  within 2% (or 12px), every matched box within 4px, the words shown and hidden match the site's at that width, and
  nothing scrolls sideways that doesn't on the site. Test: `test/web/compare-widths.test.ts`.
- AC10 (proposed): Given the same pages, when compared at in-between widths (the middle of every range, plus 1100, 880,
  600, 430, 340 and 320), then every matched box is within 2% of the width (or 6px) of the live one and every section
  within 3%: the site's stretchy sizes hold between switch points. Test: `test/web/compare-between.test.ts`.
- AC11 (proposed): Given a page whose site switches at 992–1024 and 1025–1366 (no Bricks tier there), when the paste is
  rendered in Bricks' CSS order at 1000, 1024, 1025, 1200 and 1366, then it shows the site's own layout for that range
  (AC9's tolerances), written as range CSS with both a min and a max width; a property the site changes inside a Bricks
  tier is written for that tier as range CSS only. Test: `test/browser/site-ranges.test.ts`.
- AC12 (proposed): Given a measured page, when adapted, then no rule other than `site.tiers` writes a property the site
  measured at that tier or range (each such write is recorded as yielded), no plugin phone copy is made of a measured
  node, the plugin's visible Figma-only behaviours are off (R2), and every Figma corpus file converts byte-identically to
  before. Test: `test/rules/site-tiers.test.ts` (with a mutation check: removing the engine gate fails it) and the corpus
  byte-identity receipt.
- AC13 (proposed): Given a third-party widget, a Google Maps embed and floating extras, when captured and converted, then
  the widget is a Code element with its original snippet at its place, the map is the plugin's live map of the same
  place, the footer paste holds the floating extras once (own ones rebuilt, fixed as on the site; third-party ones as
  snippets), and the panel lists each with its steps (R1's plugins to install). Test: `test/web/capture-embeds.test.ts`.
- AC14 (proposed): Given a capture dropped on the panel, when Page, Header or Footer is converted, then only that part's
  elements are in the paste, every picture comes from the file, uploads and notes work as for Figma, and after the
  header and footer are copied the site's ticks are on for its next capture. Test: `test/unit/panel-capture.test.ts`.
- AC15 (proposed) (live): Given the header, footer and three bdryswi.com pages (Home plus the two the compare report lists
  first) pasted through the panel on the B-Dry staging site, when Justin opens them at desktop, laptop, tablet and phone
  sizes, then each looks like bdryswi.com at that size apart from what the panel listed. Test: Justin's paste check
  (next free HANDOFF id) beside the compare report.
- AC16 (proposed) (live): Given one page of the non-Elementor site pasted on a test page of the staging site, when Justin
  opens it at the same sizes, then it looks like the source apart from what the panel listed. Test: Justin's paste
  check.

### Milestone 2 (motion, hover, widgets, forms)

- AC17 (proposed): Given elements whose look changes on hover or focus, when the paste is compared, then each changes the
  same properties to the same end values (colours exact, sizes ±1px, transforms ±0.01) with the same duration, delay and
  easing (exact), on mouse and on keyboard focus as the site does. Test: `test/web/compare-hover.test.ts`.
- AC18 (proposed): Given entrance animations, when compared, then each plays the same keyframes (start opacity and
  transform), duration, delay and easing (exact), on the same trigger (page load, or entering view at the same offset),
  once or repeating as the site does, per range where the site sets them per device, and stands still under reduced
  motion where the site does (the B-Dry "too fast" class: Elementor's 2 s / 1.25 s / 0.75 s classes come through
  exactly). Test: `test/web/compare-entrance.test.ts`.
- AC19 (proposed): Given running animations (a shimmer background, a drawn headline circle, a pulse), when compared, then
  each has the same keyframes, duration, easing, iteration count and start trigger. Test:
  `test/web/compare-running.test.ts`.
- AC20 (proposed): Given sliders, when compared, then each is a Slider (Nestable) with the same slides in order, the same
  interval and speed (the site's delay + change, mapped as for Figma), loop, pause on hover and interaction, arrows and
  dots where the site draws them, and slides per view per range. Test: `test/web/compare-sliders.test.ts`.
- AC21 (proposed): Given accordions, when compared, then each has the same items, the same initially open item(s), the
  same one-open-at-a-time behaviour, icon change and open/close timing. Test: `test/web/compare-accordion.test.ts`.
- AC22 (proposed): Given a form, when compared at every capture width, then it is a Bricks Form with the same fields
  (type, label, placeholder, required, options, order), every field, label and button box within 2px (or 1%) of the
  site's, and the same colours, borders, radii, fonts and button hover; the panel lists the steps the form needs (email,
  reCAPTCHA keys). Test: `test/web/compare-form.test.ts`.
- AC23 (proposed): Given flip boxes, when compared, then each turns the same way with the same duration and easing on the
  same trigger, and both faces match the site's at every capture width. Test: `test/web/compare-flip.test.ts`.
- AC24 (proposed): Given hotspots and pop-ups, when compared, then each trigger (hover, click, page load, time, scroll,
  exit) opens the same content at the same place with the same timing; each pop-up is its own paste choice and its
  trigger opens it. Test: `test/web/compare-popups.test.ts`.
- AC25 (proposed): Given floating copies that appear on scroll (a sticky header's copy), when compared, then each appears
  at the same scroll offset with the same timing. Test: `test/web/compare-scroll-reveal.test.ts`.
- AC26 (proposed) (live): Given the milestone 2 pastes on the staging site, when Justin checks hovers, animations,
  sliders, accordions, the form, flip boxes and pop-ups on desktop and an iPhone, then they behave as on bdryswi.com.
  Test: Justin's paste check.
- AC27 (proposed) (live): Given a pasted Bricks Interaction "Enter viewport → Start animation" and a pop-up trigger, when
  saved and copied back from Bricks, then Bricks keeps their keys (round trip). Test: Justin's round-trip check against
  his Interaction sample.
- AC28 (proposed) (live): Given a paste with range CSS (992–1024, 1025–1366 and a mid-tier range), when saved on the
  staging site, then Bricks keeps the custom CSS and the saved page shows the site's layout in each range (read with
  `?f2b=` past the cache). Test: the compare tool run against the saved staging page.

---

## 9. Jobs, order and size

One job list, nothing optional. Each job is one full pipeline run (planner → builder → reviews → verifier → auditor);
plan for several review rounds each (the header and after-FAQ jobs ran 6–7).

| Job | What | Touches | ACs | Wave |
|---|---|---|---|---|
| **J0 compare tool** | The oracle: paste vs live at every width and in between, in Bricks' CSS order; timing table reader; compare fixtures | `tools/site-compare.ts`, `test/web/lib/`, `test/browser/render.ts` (an option), `test/fixtures/compare/` | oracle for AC8–AC11, AC17–AC25 | 1 |
| **J1 capture core** | `src/web/` reader and mapper, switch points, stretchy values, every-width facts, pictures, fonts, parts, floating extras recorded, links, the `web` schema fields, replay of captures, page listing | `src/web/`, `src/core/snapshot/`, `tools/capture.ts`, `test/web/`, `test/fixtures/web/` | AC1–AC7 | 1 |
| J2 per-tier layout | `SceneNode.site`, `site.tiers` for Bricks tiers, engine gate, `planPhones` skip, R2 off on imports | `src/core/normalise`, `src/core/adapt`, `src/core/understand/phone.ts`, style purpose classes | AC9, AC12 | 2 |
| J4 panel | capture drop/open, pictures from the file, Page/Header/Footer/Pop-up, ticks per site, capture fonts | `src/ui/`, `src/plugin/main.ts`, `src/shared/messages.ts` | AC14 | 2 |
| J5 embeds, maps, floating extras | snippets → Code element, maps from iframes, floating extras into the footer part, R1 list | `src/web/`, `src/core/normalise/maps.ts`, `src/core/emit` | AC13 | 2 |
| J3 ranges and stretchy sizes | range layers in the style model, `rangeMedia`, emit into `_cssCustom`, stretchy values written, fluid replaced | `src/shared/breakpoints.ts`, `src/core/style/types.ts`, `src/core/adapt`, `src/core/emit` | AC10, AC11, AC28 | 3 (after J2) |
| J6 hover and focus | hover variants with exact timing | `src/web/`, `src/core/normalise/hover.ts`, style states | AC17 | 3 |
| J8 sliders and accordions | slides/timing, answers as hidden layers, per-range slides per view | `src/web/`, `normalise/carousel.ts`, `understand/accordion.ts` | AC20, AC21 | 3 |
| J7 motion | entrance by the clock (Bricks Interactions), running keyframes, drawn headline → the plugin's marker | `src/web/`, `normalise/keyframes.ts`, `normalise/draws.ts`, `emit/motion.ts` | AC18, AC19, AC27 | 4 |
| J9 forms | fields from `<form>`, Bricks Form styled like the old one | `src/web/`, `understand/form.ts`, `emit/form.ts` | AC22 | 4 |
| J10 flip, hotspots, pop-ups | flip widgets, hotspot cards, pop-up parts and triggers, scroll-revealed floating copies | `src/web/`, `normalise/overlays.ts`, `understand/flip.ts`, emit | AC23–AC25 | 4 |

Waves keep two or three jobs running at a time on different stages (the project's rule): **1** J0 ∥ J1; **2** J2 ∥ J4 ∥ J5
(after J1 merges); **3** J3 ∥ J6 ∥ J8 (J3 after J2); **4** J7 ∥ J9 ∥ J10. Live checks AC15/AC16 after J3; AC26–AC28 after
wave 4. Each milestone 2 job covers Elementor, the generic reader and the corpus's non-Elementor sites.

**What Justin supplies (by wave 4):** one Bricks sample: any element with an Interaction "Enter viewport → Start
animation (fadeInUp), run once" plus one with "Show pop-up" on click, copied as JSON (the plugin never writes Bricks keys
from memory). The Nav (Nestable) sample already owed for the phone menu applies to imported headers too.

**The three stopped plugin jobs** (entrance timing, colourless borders, frozen picture sizes): once J1 and J2 are in, a
real plugin conversion of bdryswi.com exists, so each suspicion can be proved or dropped from a real paste.

---

## 10. Keeping it general: every place a rule could key on one site

| Temptation (from bdryswi.com) | How it's avoided |
|---|---|
| Template ids 32 / 9 / 35, widget data-ids | Parts from `data-elementor-type` values or landmarks; ids only as debug labels |
| Class names (`ops-section`, `onetap-*`, `e-con`) | Floating extras by computed `position` and source host/path; layout by computed style; the Elementor reader keys on Elementor's documented attributes |
| Switch widths 1366 / 1024 / 921 / 767 / 544 | Found from each page's media queries and confirmed by a change on both sides; never a constant |
| The Trustindex key, Maps, reCAPTCHA | Third-party by script/iframe host ≠ page host; a known-widgets table may name them, never decide |
| Jetpack's `i0.wp.com` resize addresses | A CDN reader keyed on the CDN; fallback: the largest `srcset` candidate |
| Roboto failing from one host | Any face whose `document.fonts` status is `error` |
| Texts, colours, pixel sizes | Never read by a rule; tests use generic fixture sites |
| Which pages and sites prove it | Pages from each site's sitemap or menu by rule; sites by detected builder from an owned-sites list; the corpus list names them, no code does |
| Tuning to one capture | `corpus/web.json` captures (bdryswi.com's pages, growithgro.com, the plugin-made Bricks site) join `npm run corpus`, so a change can't get worse on the others |

---

## 11. Wave one: brief-ready sections

Both jobs run in parallel in their own copies (`claude -w`), Full pipeline, Opus 5.5 xhigh. They share no files: J0
compares two web pages and never reads a capture; J1 makes captures and never compares. Both read this proposal (§2, §7,
§8) and the evidence folder.

**Common to both:**
- **Skills:** the project skill `figma-to-bricks` (its `references/testing-pitfalls.md` and
  `references/rendering-validation.md` before any browser measurement), `engineering-best-practices`,
  `implementation-planning` (planner), `test-driven-development` (builder).
- **Machine:** the Windows desktop (WSL). Browser gates need `CHROME_PATH` set to a wrapper that runs
  `~/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer --use-gl=disabled` (screenshots stall
  otherwise), `TMPDIR` outside the session scratchpad (`~/.cache/<job>-<role>/tmp`), and a browser run counts only when
  it says `skipped 0` (memory `corpus-paths-on-desktop`). The planner's probe scripts in
  `evidence/website-importer/planner/scripts/` show the setup working.
- **Never:** keying on bdryswi.com's ids, classes, texts, colours or widths; writing to any live site (GET only); the
  user's debug files.
- **Live reads allowed:** bdryswi.com and the two candidate non-Elementor sites, GET only, `?f2b=<random>` past caches.

### J0: the compare tool (the oracle)

**Goal:** one command, `npm run compare -- <left> <right> [--widths …]`, that loads two web pages (a live URL, a local
fixture page, or a Bricks paste rendered by the repo's renderer in Bricks' own CSS order) at a list of widths, freezes
both the same way, pairs what they show, and reports where they differ, so every later job proves "looks and moves like
the old site" with numbers instead of eyes.

**Why first:** every importer AC (AC8–AC11, AC17–AC25) is measured with it; building it before the capture keeps the
oracle independent of the thing it judges.

**Inputs:** `<left>`/`<right>`: an `http(s)` URL, a local `.html` file, or a `bricks.json` payload (rendered with
`test/browser/render.ts` and an optional pictures map). Widths: a list, or a named set: 1920, 1440, the Bricks edges
992/991/768/767/479/478, 390, 360 and the in-between set 1100/880/600/430/340/320 (the site's own switch points join in
wave 2 through a capture; J0 takes a plain list).

**Freezing (both sides alike):** scroll through, eager pictures awaited, a first mouse move and wheel, transitions and
animations finished or disabled for the layout pass, entrance-hidden boxes shown, sliders on their first real slide,
fixed overlays recorded separately (not paired with page content).

**Pairing:** sections by order and first words; boxes by their words (whitespace and case as shown) and pictures by
content hash (or natural size + source name for live pictures); unmatched boxes listed. No site ids or class names.

**Report** (`report.json`, side-by-side PNGs per width, a summary line per width, an exit code against thresholds): page
height and width, sideways scroll, each section's height, each matched box's position and size, each group's arrangement
(row / stack / columns), words shown on one side only, cut-off words, picture shape, fonts used (family, weight, loaded).
**Timing table** (built now, used in milestone 2): for every element with a `:hover`/`:focus` rule, the changed
properties, end values (read with transitions off) and the transition's duration, delay and easing; for every CSS
animation, its name, keyframes, duration, delay, easing, iteration count and trigger; on a Bricks paste, its
`_interactions` (trigger, action, animation type, duration, delay, run once) read from the payload.

**Bricks' CSS order:** an opt-in option on the repo renderer to print desktop control rules, then element custom CSS,
then tier rules (live Bricks 2.3.9's order); the compare tool always uses it. The renderer's default stays as it is
(existing browser tests unchanged); whether to switch the default is a follow-up.

**ACs for the J0 plan** (its own numbering; each serves the proposal's ACs):
- J0-AC1: Given two identical fixture pages, when compared at the default widths, then every metric is within its
  tolerance and the exit code is 0. Test: `test/web/compare-identical.test.ts`.
- J0-AC2: Given a page and a copy with one deliberate difference each (a section 20px taller at 767 only, a row that
  stacks at 991 where the original doesn't, a word hidden at 390, a picture squashed 5%, a box 10px off at 1100, a
  sideways scroll at 360), when compared, then each difference is reported at exactly its width and element, and nothing
  else is. Test: `test/web/compare-differences.test.ts`.
- J0-AC3: Given a fixture with hover rules, transitions and CSS animations, and a copy that changes one duration, one
  easing and one end colour, when the timing tables are compared, then exactly those three are reported. Test:
  `test/web/compare-timing.test.ts`.
- J0-AC4: Given a Bricks payload with element custom CSS under a min+max media range and a tier control for the same
  property, when rendered with the Bricks-order option, then the computed values follow live Bricks 2.3.9's print order
  (custom CSS beats the desktop control, a tier rule beats custom CSS), and without the option the renderer's output is
  byte-identical to today's. Test: `test/browser/render-bricks-order.test.ts`.
- J0-AC5: Given a Bricks payload with `_interactions`, when compared with a page whose animation has the same type,
  duration, delay, trigger and once, then the timing table matches; changing any one of them is reported. Test:
  `test/web/compare-interactions.test.ts`.
- J0-AC6 (live run, evidence only): bdryswi.com Home compared with itself (two loads) reports no differences beyond
  documented noise (sliders, the reviews widget), which sets the noise floor for later ACs. Test: the saved report.

**Files it owns:** `tools/site-compare.ts`, `test/web/lib/` (freeze, pair, measure, timing, report), the
`test/web/*.test.ts` above, `test/fixtures/compare/` (pairs of generic pages), an opt-in option in
`test/browser/render.ts`, `package.json` (`compare` and `test:web` scripts), its `docs/HANDOFF.md` section, its plan and
ledger. Nothing in `src/`.

**Hands to wave 2:** a stable `compare(left, right, widths) → report` API and CLI; documented tolerances and the noise
floor; the Bricks-order renderer option; the timing table format milestone 2 fills.

### J1: the capture core

**Goal:** `npm run capture -- <url>` writes one capture file (a Snapshot with `source: "web"`) of one page of any site:
its header, page and footer parts; every box as a Figma-shaped node; its facts at every capture width including the
site's own switch points; its stretchy values; every picture's bytes; its fonts' state; its floating extras recorded;
links to its own pages as site paths. `npm run replay`, `inspect` and `snap` take the file and the plugin converts it
without errors. No adapt changes: J1 records, J2/J3 write.

**What the plan covers** (from §2): CDP orchestration (reuse `test/browser/chrome.ts`); freezing; switch-point discovery
(media boundaries, both sides, keep where facts change); reading at every width (full loads at the main widths, resizes
for boundary pairs, spot-checked); raw facts → `SNode` mapping (flex/grid/block, sizing decided across widths, absolute
constraints, wrappers folded, text runs and `text.svg` from line boxes, pictures, SVG, renders for what can't be drawn,
paints, borders, shadows, links); stretchy values (authored winners via `CSS.getMatchedStylesForNode`, `var()` resolved,
`rem`/`em` → px, `%` re-based, each verified at its range's ends and middle); parts; floating extras classified
(third-party / WordPress plugin / own) and recorded on the footer part; device-only boxes' `hidden` per range; fonts
(each face's state; failing faces measured with the working face, e.g. the same family from Google); picture bytes
(largest candidate; CDN resize parameters stripped by a CDN reader; SHA-1 hash); `--list` and `--all` (pages from the
sitemap, else header menu links); the ownership prompt remembered per host; the Elementor reader for parts and switch
widths (animations and widgets are recorded raw for milestone 2, not mapped).

**Schema additions** (`src/core/snapshot/schema.ts`; `loadSnapshot` accepts them; Figma files unchanged):
`Snapshot.source: "v2" | "v1" | "web"`; `Snapshot.web?: { url, title, capturedAt, tool, designWidth, widths,
switchPoints, builder, parts, pictures (hash → mime, base64, source URL, alt), renders (node id → PNG), fonts, floating,
notes }`; `SNode.web?: { part?, ranges?, stretchy?, hiddenIn?, source: { tag, path } }`. The exact field list is the J1
plan's first decision, written into `docs/specs/web-capture.md` (in git) so wave 2 builds against it.

**First probes for the J1 planner:** run the spike (`evidence/website-importer/planner/scripts/spike-snapshot.ts`) on the
three candidate sites; measure how many boxes get FILL/HUG/FIXED right at 1440 vs 390 when decided across widths; list
bdryswi.com's real switch points with the both-sides method; try `CSS.getMatchedStylesForNode` + `var()` resolution on
bdryswi.com's hero and a heading (probe 1 shows the chains).

**ACs for the J1 plan:** the proposal's AC1–AC7 (tests named there), on generic fixture sites (`test/fixtures/web/`:
responsive basics with switch points at 1024/921/544 and stretchy units, lazy pictures, a failing font, floating extras
of all three kinds served from a second local origin, header/footer landmarks and builder-style templates, a device-only
copy, links of every kind), plus a live run on every bdryswi.com page and the two candidate sites saved as evidence (0
shown pictures without bytes; parts found; switch points listed).

**Files it owns:** `src/web/**`, `tools/capture.ts`, `src/core/snapshot/schema.ts` and `load.ts` (additive), the
`replay`/`inspect` tools only where they must accept `source: "web"`, `test/web/capture-*.test.ts`,
`test/unit/web-replay.test.ts`, `test/fixtures/web/**`, `docs/specs/web-capture.md`, `package.json` (`capture` script),
`tsconfig.sandbox.json` (keeps `src/web` out of the Figma bundle), its `docs/HANDOFF.md` section, its plan and ledger.
Not `src/core/normalise|understand|style|adapt|emit` (wave 2), not `src/ui` (J4).

**Hands to wave 2:** the capture format (spec + types); a capture of every bdryswi.com page and of the candidate sites
(outside git, listed in `corpus/web.json`); the fixture sites for J2–J5's tests; and the list of facts J2 (per-tier
layout), J3 (ranges and stretchy values), J4 (panel: parts, pictures, renders, fonts) and J5 (embeds, maps, floating
extras) read.

---

## 12. Risks

- **The capture-to-Snapshot mapping is the biggest unknown.** The spike shows the back half takes it; fidelity depends on
  deciding FILL/HUG/FIXED across widths and on stretchy values (J1's first probes).
- **Range CSS** adds Custom CSS to many elements (answer 3 C's price) and must hold in Bricks' print order; proven by
  J0's renderer option and AC28's live round trip.
- **The engine gate and range layers are architecture changes** (`adapt/engine.ts`, the style model, `breakpoints.ts`);
  Figma conversions must stay byte-identical (AC12).
- **Resize vs reload:** sites that rebuild on resize (sliders, Elementor handlers) may differ from a fresh load; J1
  spot-checks resizes against loads.
- **Bricks Interactions and pop-up triggers** rest on Justin's samples (wave 4).
- **Headless Chrome vs a real browser:** fonts on the machine and GPU; on the Windows desktop screenshots need the CPU
  profile (`--disable-software-rasterizer --use-gl=disabled`).
- **Large capture files:** the panel holds the pictures once; the plugin never gets the bytes.
- **Old sites drift:** compare against saved captures; re-capture on purpose.

---

## Evidence (probes run for this proposal)

All read-only (public pages; the repo's code imported, nothing written to the repo, WordPress or the clipboard). Chrome
for Testing 156 through `scripts/chrome-cpu.sh`, Node 22.23.3.

- **Probe 1** (`scripts/probe-read.ts` → `probe1/report.json`, `probe1/top-1440.png`, `top-390.png`), bdryswi.com at 1440
  and 390:
  - The header (template 32, 78px; 96px on phones), the page (9) and the footer (35, 34 widgets) are in the page at both
    widths.
  - Elementor's switch widths on the page: mobile 767, tablet 1024, laptop 1366, widescreen 2400; the stylesheets hold
    about 50 distinct width boundaries (the Astra theme adds 921 and 544).
  - Lazy pictures: 6 shown-but-empty before scrolling, 0 after; lazy backgrounds 4 → 23 (1440) / 28 (390).
  - 5 entrance animations (fadeIn 1, fadeInUp 2, fadeInLeft 2); 2 still hidden after a full scroll.
  - Fonts: Roboto 400/500/600/700 and ADLaM Display faces fail (`error`); 53 texts use Roboto 600 with no working face.
  - Fixed boxes: an accessibility toggle and panel (a WordPress plugin, OneTap), a reCAPTCHA badge, a fixed copy of the
    header.
  - Hover through CDP works (button background → rgb(0, 71, 116), "grow" scale; Elementor's grow also fires on focus),
    but end states need transitions off.
  - Authored values with their media conditions are readable (CDP `CSS.getMatchedStylesForNode`); Elementor's are
    `var()` chains.
  - Cost: 15–23 s a width; walking 1,436 boxes takes 16–45 ms.
  - The Trustindex widget never loaded in this run, so its wake-up needs the steps in memory `bdry-home-copy`.
- **Probe 2** (`scripts/probe-hidden.ts` → `probe1/hidden.json`): 34 device-only boxes; shown 15 at 1920/1440, 25 at
  1366/1200 (the laptop layout shows the phone-style service cards, not the flip boxes), 18 at 1024–768, 21 at 767–390;
  23 / 22 / 28 top sections at desktop / tablet / phone.
- **Spike** (`scripts/spike-snapshot.ts` → `spike2/`: `snapshot.json`, `bricks.json`, `bricks.html`, `log.txt`,
  `live-*.png`, `paste-*.png`, `sbs-1440.png`, `sbs-390.png`; `spike1/` is the first run, before sections were split by
  part): one width (1440), flex → auto layout, text runs, pictures, SVG, borders, shadows, links; no gradients, hovers,
  motion, per-width values or fonts.
  - 1,436 boxes → 320 Snapshot nodes (read in 55 ms) → the unchanged `convert()` in 159 ms → 405 Bricks elements (20
    sections, 81 texts, 33 headings, 37 pictures, 2 phone sliders), **0 rule collisions, 1 warning, `assertPayload`
    passed**; custom CSS on 137 of 405 elements.
  - Heights: 1440 paste 8,835 vs live 8,612 (+2.6%); 1024: 12,672 vs 11,982.
  - Desktop (`sbs-1440.png`): hero, the 60-years band, the map section and the service boxes recognisably right. Misses
    the plan covers: gradients (the "Our Services" band white on white), flip boxes captured as their back, the header
    bar dropped with the fixed copy, the animated "60 Years" as a stand-in, font metrics.
  - Phones (`sbs-390.png`): 767 and 390 scroll sideways (2,251px and 1,120px wide) and miss the site's own phone design:
    one desktop capture plus the plugin's phone rules can't make it, which is why answer 2's per-width measuring is
    needed.
- **Builders and pages** (public GET, 2026-10-29): bdryswi.com's generator "Elementor 4.3.5; features: e_font_icon_svg,
  additional_custom_breakpoints", Astra theme, 14 published pages (REST); growithgro.com: no generator, no WordPress
  ("GRO — paid advertising for local service businesses"); darksalmon-badger-335429.hostingersite.com: WordPress 7.0.8,
  `wp-theme-bricks brx-body`.

## Sources (research, read 2026-10-29)

- html.to.design docs: `html.to.design/docs/free-features`, `/docs/capturing-mobile-version`, `/docs/pro-plan`,
  `/blog/new-feature-import-hover-effects`; Figma forum 2026-07-21 (`forum.figma.com/…/56218`).
- Builder.io: `builder.io/blog/html-to-design` (2025-08-06); `github.com/BuilderIO/html-to-figma` ("moved").
- Figma: `help.figma.com/hc/articles/9067379354135` (Chrome extension capture, beta, about 2026-06-11);
  `developers.figma.com/docs/figma-mcp-server/code-to-canvas/`.
- Bricks: `academy.bricksbuilder.io/builder/features/html-css-to-bricks.md` (HTML & CSS to Bricks, 2.3);
  `bricksbuilder.io/release/bricks-2-4/`; `academy.bricksbuilder.io/article/responsive-editing/` (custom breakpoints).
- Bricks Migration Engine: `builtforbricks.com/plugins/bricks-migration-engine/` (v1.9.1, 2026-10-28; vendor claims).
- Elementor: `core/breakpoints/manager.php`, `frontend/handlers/global.js` (GitHub `main`); elementor.com live markup.
