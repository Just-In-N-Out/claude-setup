# Website importer: a live website → a Bricks paste, through the same plugin (proposal)

Proposal only (brainstorm): no build, no repo change. Planner: Opus 5.5 xhigh, 2026-10-29, read from `main` at
`dea6296` (build `2026-10-29.1`). Brief: `~/.hermes/plans/figma-to-bricks/briefs/website-importer-planner.md`, Justin's
request: `briefs/website-importer-brainstorm-prompt.md`, his five answers: in the brief (binding).
Evidence (probes, saved pages, shots): `~/.hermes/plans/figma-to-bricks/evidence/website-importer/planner/`.

**Goal:** any live website a client owns becomes a Bricks paste through the plugin's existing back half, page by page,
keeping the site's own layout at every screen width, so every plugin rule and fix applies to websites too.

---

## Questions for Justin (⭐ = my recommendation)

Your five answers are already built in (straight to Bricks; the site's own layout at every width in one copy; command +
panel; widgets embedded or rebuilt; page by page with the header and footer once). These are the choices left.

1. **What goes in the first version?**
   - **A ⭐ The page itself first:** layout at every screen width, pictures, fonts, links, header/footer pastes, embeds
     and maps (5 jobs). Hovers, entrance animations, sliders, accordions, forms, flip boxes and pop-ups come right
     after, as the second milestone (5 more jobs). The first version is the foundation they all stand on, and it can
     already be checked against bdryswi.com at every width.
   - B Everything bdryswi.com's Home needs in one first version (about 10 jobs before you can try anything).
2. **The plugin's own additions for Figma designs** (the call-to-action lift and fade-in, the photo-card zoom, the 13px
   and 15px label minimums, the even space between sections, full-width buttons on phones). On a copied website:
   - **A ⭐ Off.** The copy shows the site's own look, hovers and motion, nothing added. (The website rules stay: the
     keyboard focus ring and "less motion" for visitors who ask for it.)
   - B On wherever the site has nothing of its own (a button with no hover gets the plugin's lift).
3. **Screen widths where the old site and Bricks switch at different places.** Elementor switches to its tablet layout
   at 1024px and bdryswi.com also has a "laptop" layout from 1025 to 1366px; Bricks switches at 991, 767 and 478.
   - **A ⭐ Keep Bricks' three switch points.** From 992 to 1024 the copy shows the desktop layout, squeezed smoothly,
     where the old site already shows its tablet layout; from 1025 to 1366 likewise. The panel names every part that
     looks different there. Nothing to set up in Bricks.
   - B Add the site's own switch points to Bricks (Bricks → Settings → custom breakpoints, per site) and make the plugin
     write for them. Closest match, but a bigger job, a setting on every client site, and Bricks' handling of a pasted
     breakpoint it doesn't know is unproven.
   - C Write the in-between widths as custom CSS on each element. Exact, but much less editable in Bricks.
4. **The site's own phone-only and desktop-only copies.** bdryswi.com's Home has 34 boxes that show only on some
   screens (its services are flip boxes on desktop but different orange cards on laptops, tablets and phones).
   - **A ⭐ Keep both copies, each shown only where the old site shows it.** As on the old site, editing one copy
     doesn't change the other.
   - B Keep only the desktop copy and adapt it (loses the site's own phone design).
5. **Fonts that fail on the old site.** bdryswi.com's Roboto faces fail to load today (its 600 weight has no working
   copy at all), so visitors see a fake bold.
   - **A ⭐ Measure and paste with the real font** (Google's Roboto 600): the copy looks as the site was designed; a
     few lines may wrap differently from what the old site shows today.
   - B Copy what visitors see now (measured with the fallback font).
6. **Overlays the site adds on top of every page** (bdryswi.com has an accessibility button and panel, a reCAPTCHA
   badge, a sticky copy of its header; other sites have cookie bars and chat bubbles).
   - **A ⭐ Left out and listed in the panel.** Site-wide extras like chat go in once, in Bricks → Settings → Custom
     code, not in every page.
   - B Kept in the page paste.
7. **Copying only sites your clients own.**
   - **A ⭐ The command asks once per website ("Is this your client's own site? y/n") and remembers.**
   - B No check.
8. **A ready-made Elementor → Bricks plugin exists** (Bricks Migration Engine, $39–169 one-time, free for 3 pages; its
   own claims: breakpoints, Elementor's entrance animations, hovers, sliders, forms, pop-ups, header/footer). It needs
   admin access and Elementor running on the same WordPress install, so it can't work from an address, and only does
   Elementor.
   - **A ⭐ Build our importer anyway** (any website, any builder, from its address, and every plugin fix applies to
     it). If you have admin on an Elementor client site, try its free 3 pages once as a comparison; nothing waits on
     it.
   - B Try it first and decide after.
   - C Skip it.

---

## The recommendation in three lines

1. **Approach A:** a command reads the live site in Chrome at 13 screen widths and writes one capture file shaped like
   the plugin's own debug file; the plugin's existing back half turns it into the Bricks paste.
2. **The site's own layout at every width** reaches Bricks through one new fact recorded per box per screen size and
   one new rule that writes it; the plugin's phone rules then only fill what the site didn't say.
3. **First version:** 5 pipeline jobs in 2 waves (a compare tool, the capture, per-width layout, the panel, embeds and
   maps), proven on bdryswi.com's Home at 1920/1440/1024/767/390; motion and widgets follow as 5 more jobs.

A 300-line spike already ran bdryswi.com's Home through the unchanged plugin: 405 Bricks elements, no errors, the
desktop recognisably right (section "Evidence" below).

---

## What you'd do (the walkthrough)

**Is it an application?** No new app. It is one command that lives in the plugin's project folder, plus the Figma
panel you already use. You (or Claude) give the command the page's address; you don't copy-paste anything from the
site.

1. **Capture the page.** In a terminal in the plugin folder (or ask Claude: "capture bdryswi.com's home page"):
   `npm run capture -- https://bdryswi.com/`
   - The first time for a site it asks: "Is bdryswi.com your client's own site? (y/n)".
   - You see one line per step: `Reading bdryswi.com at 13 widths… 1920 ✓ 1440 ✓ … 360 ✓`, `Pictures 31/31`,
     `Fonts: Roboto 400 500 600 700 (Google)`, `Parts: header, page, footer`, `Widgets: 1 reviews widget (embed), 1 map`,
     `Left out: accessibility button, reCAPTCHA badge`.
   - It writes `bdryswi-com-home.f2b-capture.json` to your Downloads folder (about 10–40 MB: the pictures are inside)
     and a check page `bdryswi-com-home-check.html` with the old site and the copy side by side at each width.
   - It takes about 3–5 minutes (probe 1: 15–23 seconds a width).
2. **Open the plugin in Figma** (any Figma file; nothing is drawn in it). Drag the capture file onto the panel. The
   panel shows: `Website: bdryswi.com, Home. Parts: header, page, footer.` and a choice **Paste: Page / Header / Footer**.
3. **First page of a site: the header and footer once.**
   - Choose **Header**, press **Convert and copy**, paste into your Bricks header template, save.
   - Choose **Footer**, Convert and copy, paste into the footer template, save.
   - The panel now remembers (per WordPress site) that this site has its header and footer: the two ticks turn on.
4. **The page.** Choose **Page**, Convert and copy, paste into the page in Bricks, save. Pictures go to WordPress,
   picture descriptions, fonts and page links work exactly as they do for Figma designs today.
5. **After pasting**, as today: Bricks → Settings → Custom code → **Regenerate code signatures** (embeds such as the
   reviews widget), **LiteSpeed → Purge All**, and the panel's list tells you which widget accounts must allow the new
   site's address (e.g. Trustindex).
6. **Later pages of the same site:** capture, drop, **Page**, Convert and copy, paste. The header and footer are left
   out by themselves.

**What you get back:** the same thing as today: a Bricks paste on your clipboard, with the panel's notes (what was left
out, which widgets need a step, where the site and the copy differ).

---

## 1. Approaches compared

Research read on 2026-10-29 (sources in the "Sources" list at the end).

| What you want | **A: our importer** (site → capture file → plugin) | **B: website → Figma tool, then the plugin** | **C1: Bricks Migration Engine** (Elementor → Bricks) | **C2: Bricks' own "HTML & CSS to Bricks"** (2.3+) |
|---|---|---|---|---|
| Works from the address of any site | **Yes**, any builder | Yes | No: admin access, Elementor active on the same install | No: you paste HTML and CSS |
| Desktop layout | Yes (spike: recognisable at 1440) | Yes, often messy layers on complex CSS | Yes (vendor: "up to about 90%") | Partly |
| The site's tablet and phone layouts in one copy | **Yes** (measured at 13 widths) | No: each width is a separate unmatched import; the plugin pairs only a desktop and a phone frame, as two copies (your answer 2 says no) | Yes (vendor: breakpoints mapped) | Only media queries at exactly 991/767/478 |
| Hovers | Yes (milestone 2) | html.to.design: hover as variants (optional) | Yes (vendor) | Into custom CSS |
| Entrance animations | Yes, as Bricks Interactions (milestone 2) | **Lost** | Yes (vendor: 36 animations) | Lost |
| Sliders, accordions, flip boxes, pop-ups | Yes, as the plugin's widgets (milestone 2) | Lost (a picture of one state) | Sliders, forms, tabs, pop-ups (vendor) | Lost |
| Pictures, fonts, alt text, links to your new pages | Yes, the panel's existing uploads, fonts, alttext.ai and page matching | Yes through the panel, after Figma | Converts in place on the old site's own install (a copy of the site is needed to move it) | Manual |
| Your plugin's rules and fixes apply | **Yes, all of them** | Yes | No | No |
| Third-party widgets | Original embed code in a Code element | Lost | Review list / placeholders | Scripts as an unsigned Code element |
| Cost | Our build: about 10 pipeline jobs | html.to.design free: 10 imports a month; PRO $12–18/month | $39 / $79 / $169 | Included |

**Why A:** it is the only route that works from an address, on any builder, and keeps the per-width layout, hovers and
animations Justin ranked highest, while every rule and fix in the plugin applies to websites too (your 2026-10-29 rule:
every change goes into the plugin). B can't carry what matters most: animations and sliders are lost and each width is
a separate frame. The plugin already meets B's output in the wild: a map and a form in your Contact page were page
captures in Figma, which needed special rules (`normalise/mosaic.ts`, `style/shares.ts` "two equal columns"). C1 is the
strongest shortcut, but only for Elementor sites where you have admin access, and its claims are untested (question 8).
C2 is weaker than the plugin's own emitter.

---

## 2. How the importer reads a site

### In plain words

The command opens the page in Chrome (the same headless Chrome the plugin's tests already drive), the way a visitor's
browser would, at each screen width. It scrolls the whole page so every lazy picture loads, waits for fonts, stops
sliders on their first slide and lets entrance animations finish. Then it writes down, for every box on the page: where
it is, how it lays out its children (in a row, in a column, in a grid), its colours, borders, corners and shadows, its
words with their font and links, and its pictures (downloaded, full size). It does that at every width and records what
changes. It reads the header and footer templates too (the hand capture missed them; they are in the page, probe 1).

Websites wrap everything in many invisible boxes (bdryswi.com's Home is 1,436 boxes). The command folds a box that only
wraps one other box of the same size and paints nothing: the spike turned 1,436 boxes into 320 layers.

For Elementor sites a small Elementor reader adds what the page says about itself: its switch widths, which template is
the header, footer and pop-ups, its entrance animations with their speed, its sliders' timing. Other sites get the same
capture without those extras.

### For the planner (technical)

**Front half, new: `src/web/`** (Node only, never bundled into Figma). Two halves so most of it is testable without
Chrome:
- `src/web/read/` — the in-page reader (a function serialised into `Runtime.evaluate`) returning raw facts per element
  and per width: rect, computed style subset, text runs with line boxes (`Range.getClientRects`), picture sources
  (`currentSrc`, largest `srcset` candidate, CSS `background-image`, `<picture>`), inline SVG markup, links, open shadow
  roots walked, `display:contents` flattened.
- `src/web/map/` — pure: raw facts → Figma-shaped `SNode`s (unit-tested from saved raw-fact fixtures).
- `src/web/capture.ts` — orchestrates: launch Chrome over CDP (`test/browser/chrome.ts` moves to a shared
  `src/web/cdp.ts` or is imported as is), visit each width, freeze, read, download pictures and fonts, write the file.
- `tools/capture.ts` + npm script `capture`. Typecheck boundary: `tsconfig.sandbox.json` keeps `src/web` out of the
  Figma bundle (it uses `node:crypto`, `node:fs`, `node:http`).

**Freezing before reading** (each one was a lesson of the hand copy or a probe):
- Scroll through in 60%-of-window steps, then set every `img.loading = "eager"` and await `complete` (probe 1: 6 shown
  pictures were empty before the scroll, 0 after; lazy backgrounds went from 4 to 23 at 1440 and 28 at 390).
- Move the mouse and wheel once, and again near every empty third-party placeholder (Trustindex waits for a first input
  and fills only within 300px of the window: memory `bdry-home-copy`).
- Read each animated element's animation first, then remove the hidden-until-animated state and finish animations
  (`document.getAnimations().forEach(a => a.finish())`, Elementor's `elementor-invisible`): probe 1 found 2 of 5
  entrance-hidden boxes still hidden after a full scroll.
- Disable transitions (`*{transition:none!important}`) before forcing `:hover`/`:focus` through CDP
  `CSS.forcePseudoState`, or the end state is read mid-transition (probe 1: a "grow" hover read as scale 1.0038 after
  50 ms of a 0.3 s transition).
- Stop sliders on their first real slide (Swiper/Splide/Slick instances, else an overflow-hidden track of transformed
  slides); record their slides and timing first.
- Leave out fixed overlays that are not the header (accessibility widgets, chat, cookie bars, badges): by computed
  `position: fixed` outside the header/footer parts, listed in the file's notes, never by class name.

**Widths read:** 1920, 1440 (the design width W), 1366, 1200, 1024, 992, 991, 768, 767, 479, 478, 390, 360: every Bricks
tier's top and bottom, the AC widths and the common Elementor laptop/tablet switch points. Probe 1: 15–23 s a width
(load, scroll, waits), walking all boxes takes 16–45 ms and about 0.5 MB of raw facts a width.

**Web page → Snapshot nodes** (the Snapshot stays Figma-shaped, so normalise and every later stage run unchanged):

| Web | Snapshot (Figma's names) | Notes |
|---|---|---|
| `display:flex` row/column | `FRAME`, `layoutMode` HORIZONTAL/VERTICAL, `itemSpacing` (column-/row-gap), `layoutWrap`, `counterAxisSpacing`, padding, `primaryAxisAlignItems` (justify-content), `counterAxisAlignItems` (align-items) | Only when children sit where auto layout puts them (in order, even gaps, no main-axis margins); else `layoutMode: NONE` and the plugin's own free-frame inference (`normalise/infer.ts`, proven on GRO) |
| `display:grid` | Figma grid (`layoutMode: GRID`, `gridColumnCount`, `gridColumnSizes`, gaps, spans) | The schema already has the grid props |
| block flow | VERTICAL auto layout when stacked with even gaps (margins → gaps), else NONE | |
| child sizing | `layoutSizingHorizontal/Vertical` FILL / HUG / FIXED | Decided across widths: a box that tracks its parent's width is FILL, one that equals its content HUG, one that stays the same FIXED (one width can't tell; the spike's 390 sideways scroll came from this) |
| `position:absolute` | `layoutPositioning: ABSOLUTE`, `constraints` from which of left/right/top/bottom are set (both → STRETCH, `left:50%` + translate → CENTER, % → SCALE) | Declared values from CDP `CSS.getMatchedStylesForNode` |
| boxed content (e.g. 1140 wide, centred) | inner frame `maxWidth` | `understand/section.ts` already turns a centred narrower content box into the Container's max width |
| text element | `TEXT`, `characters`, `text.segments` per styled run (font family, style from weight, size, line height, letter spacing, colour, `textCase` from text-transform, underline, `hyperlink`), `textAutoResize` HUG vs HEIGHT, `textAlignHorizontal`, `absoluteRenderBounds` = ink | `<br>` → line break; whitespace collapsed as the browser does |
| text lines | `text.svg` written from line boxes (one `<tspan>` per line at its x/baseline) | Every reader of Figma's text SVG (rag, headline marker, broken words) works unchanged |
| `<img>`, CSS background, `<picture>` | `IMAGE` fill, `scaleMode` from object-fit / background-size (crop → `imageTransform`), `imageHash` = SHA-1 of the bytes (as Figma's), `images[hash]` = natural size | Bytes downloaded by Node, largest candidate (a CDN reader strips resize parameters, e.g. Jetpack's `i0.wp.com/…?w=500`) |
| inline `<svg>`, `.svg` image | `VECTOR` + `vector.svg` (currentColor resolved) | |
| icon fonts, canvas, CSS the plugin can't draw (filters, clip-path, complex gradients) | a `node:<id>` render: the element's own screenshot | Same asset kind Figma uses for rendered layers |
| background colour, gradients, borders (per side), radii, box-shadow, opacity, blend mode, overflow | `fills` (SOLID / GRADIENT_*), `strokes` + per-side weights (INSIDE), corner radii, `effects`, `opacity`, `blendMode`, `clipsContent` | The spike skipped gradients: "Our Services" came out white on white |
| `<a href>` box / words | Open-link reaction (`ON_CLICK` → `URL`) / run `hyperlink` | Links to the old site's own pages become site paths (`/contact/`), so the panel's page matching sends them to your new pages; outside links, `tel:`, `mailto:` unchanged |
| `:hover` / `:focus` styles | a component set (default + hover variant) and `ON_HOVER` → `CHANGE_TO` with the transition's duration and easing | The plugin's hover machinery then decides CSS hover vs states (milestone 2) |
| entrance animation | new `web.entrance` (name, duration, delay, once, easing) → normalise → Bricks Interaction | Milestone 2; needs one Bricks sample |
| slider | a component set, one variant per slide, `AFTER_TIMEOUT` (Swiper delay) → `CHANGE_TO` next (speed) | Feeds `normalise/carousel.ts` as Figma does; Swiper's delay starts after the change ends, as Figma's does |
| accordion (`<details>`, builder accordions) | items with their answers as hidden layers | How `understand/accordion.ts` reads a designer's FAQ |
| flip box (builder flip widget, or 3D `rotateY` + `backface-visibility`) | front/back variants + hover + a `flip` annotation | The spike captured flip boxes as their back face |
| hotspot opening a card / pop-up | `OPEN_OVERLAY`, Manual position, the card's content | Milestone 2 |
| third-party widget (script or iframe from another host) | new `web.embed` (its original snippet from the served HTML) → Code element | `reference/bricks/code-element.json` |
| Google Maps iframe | the scene's `map` (its place from the embed address) | `normalise/maps.ts` already makes a live map from a captured one |
| `<form>` | new `web.form` (fields, types, labels, required, options) → Bricks Form | `understand/form.ts` reads drawn shapes today; it reads the recorded fields first (milestone 2) |

**Lost or approximated:** JavaScript behaviour the plugin has no widget for (counters, tabs until the Tabs sample,
filters), scroll-linked effects (parallax: kept still and listed), video backgrounds (video addresses kept as the plugin's
video path), canvas/WebGL (a picture), anything behind a login.

**Builder readers** (`src/web/readers/`): small, each keyed on a builder or library, never on a site.
- Elementor: `elementorFrontendConfig.responsive` (switch widths: bdryswi.com has mobile 767, tablet 1024, laptop 1366,
  widescreen 2400), `data-elementor-type` = header / wp-page / footer / popup, `data-settings` (`_animation`,
  per-device `_animation_tablet`, `_animation_delay` ms; duration class `animated-slow` 2 s / default 1.25 s /
  `animated-fast` 0.75 s), carousel settings, flip-box and hotspot widgets, pop-up templates (printed after the footer).
- Libraries: Swiper, Splide, Slick (slides and timing), Animate.css/AOS (entrance names).
- Generic fallback for every fact: landmarks (`header`, `footer`, `main`), computed `display` per width, CSS
  `@keyframes` on the element, `:hover` rules.

---

## 3. The site's own layout at every width (answer 2) against the architecture

### In plain words

The command records, for every box, how it looks at each screen size. A new step in the plugin reads those records and
writes the site's own values into Bricks' tablet and phone settings. Where the site said nothing (widths between the
ones measured, boxes the plugin adds itself, Bricks' own quirks), the plugin's existing phone rules fill in as they do
today. Where the site and a plugin rule disagree, the site wins.

### For the planner (technical)

1. **Recorded fact, earlier stage.** The capture diffs each node's raw facts per width against the design width and
   stores only what changes, per Bricks tier, on the node: `SNode.web.at[tier]` (layout direction, wrap, gap, padding,
   grid columns, order, width mode/size, height, font size/line height/letter spacing, text align, placed offsets,
   `hidden`). Normalise turns it into a typed `SceneNode.site?: SiteLooks`; IR nodes keep it through `src`. No later
   stage edits it.
2. **One rule writes it:** `src/core/adapt/rules/site.ts` (`id: "site.tiers"`, decision "The old site's own layout at
   every width (Justin, 2026-10-29, answer 2)"), last in `RULES`. For each IR node whose `src.site` has a tier value it
   writes the style through `out.element(n, tier, style)` with the plugin's own `Style` keys, explicitly at every tier
   where the value differs from the tier above (the cascade rule: a tier going back to the designed value writes it).
   Sizes still go through the layout plan where the plan owns them (a FILL box stays `flex: 1`; only measured fixed
   sizes are written).
3. **The site wins, by an engine gate, not only by `overrides`.** `overrides` makes the overriding value stand where
   both write, but a generative rule writing a narrower tier where `site.tiers` wrote nothing (because the site's value
   equals the tier above) would leak through, and the engine's "narrower write undoes" check flags it. So the engine
   gets one change: on a measured page (`Scene.web` present), a write by any other rule to a `node|tier|prop` the site
   measured is dropped and recorded as a decision `yielded: site.tiers`. `site.tiers` also lists every generative rule
   it can meet in `overrides` (belt and braces for the collision test).
4. **Phone-only copies are not made where the site has its own phone layout.** `understand/phone.ts` `planPhones`
   (phone sliders, the hero's buttons band, intro buttons) skips measured nodes; the spike's paste made 2 phone sliders
   the site doesn't have.
5. **Tier mapping** (with question 3 A):

| Bricks tier | Applies | Written from the site at | Checked at |
|---|---|---|---|
| base (desktop) | 992+ (exact at W = 1440) | 1440 | 1920, 1440 |
| fluid (W down to 992) | the plugin's clamp, exact at W | nothing of its own: the plugin's clamp slides from the 1440 value toward the tablet value (J2 decides how `space.ramp`/`type.ramp` take the site's tablet value as their end) | 1366, 1200, 1024, 992 |
| tablet_portrait | 768–991 | 991 | 991, 768 |
| mobile_landscape | 479–767 | 767 | 767, 479 |
| mobile_portrait | ≤478 | 390 (478 where 390 and 478 differ in layout, not size) | 478, 390, 360 |

   - A site switch point inside a Bricks tier (bdryswi.com's theme also switches at 921 and 544) shows as two different
     measurements in one tier. The rule takes the tier's top value when it still fits at the tier's bottom width, else
     the bottom value, and the panel names the part ("the site changes at 921px, Bricks at 991px").
   - 992–1024 and 1025–1366 (the site's tablet and laptop layouts, which Bricks doesn't have): the desktop layout,
     squeezed by the plugin's fluid clamp, checked for no sideways scroll and no cut-off words; named in the panel.
6. **Where the site and the plugin disagree:**
   - Measured layout, sizes, spacing, type and visibility: **the site**.
   - The plugin's Figma-only additions (question 2): off on imports, by a `Scene.web` check in each (CTA motion,
     showcase zoom, label minimums, section rhythm, CTA full width, phone copies).
   - Bricks' quirks the plugin already handles (every element capped at its parent's width, Blocks wrapping from 767
     down, `_alignSelf: stretch`, flex-basis in px): **the plugin**, unchanged.
   - Website rules (no `main`/`header`/`footer` tags, headings from structure, focus ring, reduced motion, whole-hundred
     font weights, no link to a picture file): **the plugin**, unchanged.
   - A site that itself scrolls sideways or has tiny text at some width: copied as it is (the design is never
     resized), and the panel names it.
7. **Gaps the plugin fills:** widths between measurements (the fluid clamp), boxes the plugin creates (Containers,
   bands, hover copies, slides), properties the capture doesn't measure (balance/pretty wrapping, tap areas,
   `nowrap` release below W), widths under 360.

---

## 4. The panel opening a capture file (answer 3)

### In plain words

The panel learns one new thing: you can drop a capture file on it instead of selecting frames. From there it does what
it does today.

### For the planner (technical)

**New:**
- The drop handler (`src/ui/main.ts`, today: font files only) tells a capture file (`.f2b-capture.json`, a Snapshot with
  `source: "web"`) from fonts, plus an "Open capture…" button.
- The panel keeps the capture's picture bytes and renders (`web.pictures`, `web.renders`) and sends the plugin only the
  snapshot without them: `{ type: "convertCapture", snapshot, part, inlinePictures }`. The plugin runs the same
  `resultOf()` it runs for a Figma selection (so plugin = replay byte for byte, as `plugin-convert.test.ts` pins today)
  and posts `result`. The panel then feeds `run.add(item)` with `PictureItem`s built from the file
  (`fill:<hash>` → bytes, `svg:<id>` → the SVG already in the asset, `node:<id>` → the stored render) instead of
  Figma's `exportPictures`.
- **Paste: Page / Header / Footer**: the capture's roots are tagged by part; the panel converts only the chosen part's
  roots. After the header and footer pastes are copied for a WordPress site, that site's header/footer ticks turn on
  (the ticks are already remembered per WordPress site since 2026-10-23), so later pages leave them out.
- A capture names its source address; the panel shows it, and the site check never matches a page link to the *old*
  site.

**Works unchanged:** WordPress uploads (AVIF/WebP, the upload cache by picture), picture descriptions and alttext.ai,
Google Fonts, the site's font library (fonts a capture carries are offered as if dropped), page-link matching
(`site-pages.ts`), the palette file, lists, videos lookup, the clipboard and "Copy again", every note.

**Changed meaning:** "Show" (zoom Figma to a picture's layer) is hidden for capture pictures; descriptions typed for a
capture are saved by picture (`hash:`) in the open Figma file, as photos are today.

**Debug path:** a capture file *is* a debug file: `npm run replay`, `snap`, `inspect`, `wraps`, `trace` and the corpus
take it as they take Figma's. A new `npm run compare -- <capture> <url>` puts the paste beside the live site at each
width (the first version's oracle, job J0).

---

## 5. What the plugin already does, and what is new

| Feature | Reused as is | New work |
|---|---|---|
| Sections, Container, bands, gutters, wide screens | ✓ | — |
| Fluid desktop, layout plan | ✓ | — |
| Phone rules | as gap fillers only | engine gate, `planPhones` skip (J2) |
| Header/footer ticks, room under the header | ✓ | parts read from the capture, not guessed (J1) |
| Buttons, CTA recognition | ✓ (Bricks Buttons by shape) | CTA motion off on imports (J2) |
| Call and email links, page links | ✓ | old-site links → site paths (J1) |
| Live maps | ✓ | place from the iframe address (J4) |
| Sliders that play by themselves | ✓ | slides + timing from Swiper/Elementor (J7) |
| FAQ accordions | ✓ | answers recorded as hidden layers (J7) |
| Flip cards | ✓ | front/back from the flip widget (J9) |
| Photo hotspots | ✓ | the overlay card from the hotspot / pop-up (J9) |
| Hover vs states | ✓ | hover variants from forced `:hover` (J5) |
| Motion | scroll-linked Figma Motion | entrance by the clock, once → Bricks Interaction (J6) |
| Headline marker (drawn circle) | ✓ | from Elementor's animated headline (later) |
| Forms | Bricks Form emitter | fields read from the `<form>` (J8) |
| Third-party widgets | Code element sample | embed snippet from the served HTML (J4) |
| Fonts to WordPress | ✓ | font files carried in the capture (J3) |
| Section rhythm, label minimums | off on imports | — |

---

## 6. The hard parts and limits

- **Third-party widgets** (reviews, chat, booking): their original embed code goes in a Code element where the widget
  sits (answer 4); you regenerate code signatures, and some accounts must allow the new domain. In the capture they
  often aren't there yet: they wait for a first mouse move or for scrolling near them, so the capture wakes them.
- **Forms** become the plugin's Bricks Form (answer 4); reCAPTCHA and the form's own email settings are set in Bricks
  afterwards. In the first version a form is listed and kept as its drawing only.
- **Fonts:** the capture records each font the words use and whether it loaded (probe 1: bdryswi.com's Roboto
  400/500/600/700 faces from its own server all fail; ADLaM Display fails too). It measures with the face the paste
  will load (question 5). Fonts on Google need nothing; other fonts' files travel in the capture and go to your site's
  font library.
- **Pictures:** full size, downloaded by the command (the panel can't fetch another site's files); lazy pictures
  loaded by scrolling first; the largest `srcset` file, not the phone-sized one (at 390 the browser picks smaller
  `srcset` files: 15 pictures by probe 1's rough check).
- **JavaScript-driven content:** what the page shows after loading and scrolling is captured; behaviour the plugin has
  no widget for is listed.
- **Device-only copies:** kept, each where the site shows it (question 4). bdryswi.com shows 15 of its 34 at 1440, 25
  at 1200–1366, 18 at 768–1024 and 21 on phones (probe 2).
- **Cookie banners, chat bubbles, accessibility widgets:** left out and listed (question 6).
- **Other builders:** the generic reader works on any site. Wix and Squarespace pages are deeply nested and often
  absolutely placed, so more lands in the plugin's free-frame inference; Webflow and plain HTML are cleaner than
  Elementor. Each needs a corpus capture before it's called supported.
- **Sites that block headless browsers** (bot protection) or need a login: not in scope; the command says so.
- **Only your clients' own sites** (question 7). The capture keeps the address and the date.
- **The old site keeps changing:** checks compare against a saved capture and saved live shots, so a site edit doesn't
  fail a test.

---

## 7. The first version (proposed): bdryswi.com's Home

**Scope (question 1 A):** jobs J0–J4 below. bdryswi.com's header, Home and footer captured at 13 widths; the Bricks
paste of each part with the site's own layout at each width, pictures with bytes, fonts, links, the reviews widget as its
embed code, the map as a live map. Hovers, entrance animations, the hero slider, flip boxes, the hotspot pop-ups, the FAQ
and forms come through as their first visible state and are listed as "not rebuilt yet" (milestone 2).

**How it's proven:** `npm run compare` renders the paste (with the capture's own pictures) and loads the live site at
1920/1440/1024/767/390 (plus 991 and 478 for the Bricks tiers), freezing both the same way, pairing sections by the
capture's source path. Every test also runs on generic local test sites (`test/fixtures/web/*`: plain HTML with their
own media queries, lazy pictures, a failing font, a fixed overlay, a header/footer pair, a device-only copy), so nothing
is tuned to bdryswi.com.

### Proposed acceptance criteria

- AC1 (proposed): Given a site address, when `npm run capture -- <url>` runs, then it writes one capture file that
  `loadSnapshot` reads, holding the page's header, page and footer as separate tagged parts (from the page's landmarks or
  builder templates), its measurements at the 13 widths, and the bytes of every picture shown at any width, including
  pictures that load only when scrolled into view. Test: `test/web/capture-file.test.ts` (generic fixture site);
  bdryswi.com run: 0 shown pictures without bytes, parts header/page/footer.
- AC2 (proposed): Given a page with fixed overlays outside its header (an accessibility button, a cookie bar, a badge),
  when it is captured, then none of them is in any part and each is listed in the capture's notes with its size. Test:
  `test/web/capture-overlays.test.ts`.
- AC3 (proposed): Given a capture, when it is replayed twice, then both pastes are byte-identical, the conversion has no
  rule collisions and passes `assertPayload`, and the plugin's conversion of the same capture equals the replay byte for
  byte. Test: `test/unit/web-replay.test.ts` (plus a capture case in `test/unit/plugin-convert.test.ts`).
- AC4 (proposed): Given bdryswi.com's Home and the fixture sites, when the paste is compared with the live page at 1920
  and 1440, then every top section's height is within 3% (or 24px) of the live one, every word the live section shows
  appears once in the paste, every picture keeps its shape (±1%), and nothing scrolls sideways. Test:
  `test/web/compare-desktop.test.ts` (fixtures; bdryswi.com report saved as evidence).
- AC5 (proposed): Given the same pages, when compared at 991, 767, 478 and 390, then every measured box lays out its
  children as the site does at that width (row or stack, the same number of columns), every top section's height is
  within 5% (or 32px), the words shown and hidden match the site's at that width, and nothing scrolls sideways. Test:
  `test/web/compare-tiers.test.ts`.
- AC6 (proposed): Given a site that switches layout above 991px (Elementor's 1024, a laptop layout), when compared at 1024
  and 1200, then the paste shows the desktop layout with no sideways scroll, no cut-off words and all of the desktop's
  words, and the panel's notes name each part the site shows differently there. Test: `test/web/compare-between.test.ts`.
- AC7 (proposed): Given a measured page, when it is adapted, then no rule other than `site.tiers` writes a property the
  site measured at that tier (each such write is recorded as yielded), no phone-only copy is made of a measured node,
  and a Figma design converts byte-identically to before. Test: `test/rules/site-tiers.test.ts` (with a mutation check:
  removing the engine gate fails it) and the corpus byte-identity receipt.
- AC8 (proposed): Given widths the capture didn't measure (1100, 880, 600, 320), when the paste is rendered, then nothing
  scrolls sideways and no words are cut off on the fixture sites and bdryswi.com. Test: `test/web/compare-gaps.test.ts`.
- AC9 (proposed): Given a page whose font face fails to load, when captured, then the capture lists each face the words
  use with its load state, measures with the working face it names (question 5), and the paste asks for the same
  families in whole-hundred weights. Test: `test/web/capture-fonts.test.ts`.
- AC10 (proposed): Given links to the site's own pages, to other sites, to phone numbers and emails, when captured and
  converted, then the site's own pages become site paths that the panel's page check matches, the others stay as they
  are, and no link points at a picture file. Test: `test/web/capture-links.test.ts`.
- AC11 (proposed): Given a third-party widget and a Google Maps embed on a page, when captured and converted, then the
  widget is a Code element holding its original embed code at its place and listed with its two steps, and the map is
  the plugin's live map of the same place. Test: `test/web/capture-embeds.test.ts`.
- AC12 (proposed): Given a capture file dropped on the panel, when Page, Header or Footer is converted, then only that
  part's elements are in the paste, every picture comes from the file (none from Figma), uploads and notes work as for a
  Figma conversion, and after the header and footer are copied the site's two ticks are on for the next capture. Test:
  `test/unit/panel-capture.test.ts` (the panel modules with the test environment, `test/fixtures/panel.ts`).
- AC13 (proposed) (live): Given the three pastes of bdryswi.com's Home made through the panel on the B-Dry staging site,
  when Justin opens the saved page at desktop, tablet and phone sizes, then it looks like bdryswi.com at each size apart
  from what the panel listed. Test: Justin's paste check (next free HANDOFF id), with the compare report beside it.

---

## 8. Jobs, order and size

Each job is one full pipeline run (planner → builder → reviews → verifier → auditor). Plan for several review rounds
each: the recent header and after-FAQ jobs ran 6–7, every round finding real edge cases.

**Milestone 1, the first version (5 jobs, 2 waves):**

| Job | What | Touches | Wave |
|---|---|---|---|
| J0 compare | `tools/site-compare.ts`, fixture sites, the per-width oracle (AC4–AC6, AC8 checks) | `tools/`, `test/web/`, `test/fixtures/web/` | 1 |
| J1 capture core | `src/web/` reader and mapper at every width, pictures, fonts state, parts, overlays, links, the `web` schema fields, replay of captures (AC1–AC3, AC9, AC10) | `src/web/`, `src/core/snapshot/schema.ts`, `tools/capture.ts` | 1 (with J0) |
| J2 per-width layout | `SceneNode.site`, `site.tiers` rule, engine gate, `planPhones` skip, Figma-only additions off on imports (AC5–AC8) | `src/core/normalise`, `src/core/adapt`, `src/core/understand/phone.ts` | 2 |
| J3 panel | capture drop/open, pictures from the file, Page/Header/Footer, ticks per site, capture fonts (AC12) | `src/ui/`, `src/plugin/main.ts`, `src/shared/messages.ts` | 2 |
| J4 embeds and maps | embed snippets → Code element, maps from iframes (AC11) | `src/web/`, `src/core/normalise/maps.ts`, `src/core/emit` | 2 |

**Milestone 2 (5 jobs):** J5 hover and focus states; J6 entrance animations by the clock (Bricks Interactions; needs
your Interaction sample, below); J7 sliders and accordions; J8 forms; J9 flip boxes, hotspots and pop-ups. J5, J6 and J7
can run side by side once J2 is merged (they touch different stages); J8 and J9 after.

**Later, only if you want them:** your own switch points per site (question 3 B), Elementor's animated headline as the
plugin's marker, readers for Wix / Squarespace / Webflow with a corpus capture each.

**What you'd need to supply (milestone 2 only):** one Bricks sample: any element with an Interaction "Enter viewport →
Start animation (fadeInUp), run once", copied as JSON (the plugin never writes Bricks keys from memory). The Nav
(Nestable) sample already owed for the phone menu applies to imported headers too.

**The three stopped plugin jobs** (entrance timing, colourless borders, frozen picture sizes: you said test the plugin
first): once J1 and J2 are in, a real plugin conversion of bdryswi.com exists, so each suspicion can be proved or
dropped from a real paste.

**Next step after your answers:** the main session dispatches the J0 and J1 planners side by side (each in its own
copy, Full pipeline, with this proposal and the evidence folder in their briefs); J2–J4 planners start when J1's capture
format is merged.

---

## 9. Keeping it general: every place a rule could key on one site

| Temptation (from bdryswi.com) | How it's avoided |
|---|---|
| Template ids 32 / 9 / 35, widget data-ids | Parts come from `data-elementor-type` values or landmarks; ids are kept only as debug labels, never read by a rule |
| Class names (`ops-section`, `onetap-*`, `e-con`) | Overlays by computed `position: fixed` outside the parts; layout by computed style; the Elementor reader keys on Elementor's documented attributes, not a site's classes |
| Breakpoints 1024 / 767 / 1366 | Read from the page (`elementorFrontendConfig`, media queries) for notes only; layout from measuring at fixed widths |
| The Trustindex key, Google Maps embed, reCAPTCHA | Third-party by script/iframe host ≠ page host; a known-widgets table may name them, never decide |
| Jetpack's `i0.wp.com` resize addresses | A CDN reader keyed on the CDN; the fallback is the largest `srcset` candidate |
| Roboto failing from one host | Any face whose `document.fonts` status is `error` |
| Texts ("Schedule An Inspection"), colours, pixel sizes | Never read by a rule; tests use generic fixture sites |
| One site's look in the oracle | Every AC runs on the fixture sites; bdryswi.com is the live acceptance run, as the corpus files are |
| Tuning to one capture | A corpus folder of captures (`corpus/web/`: bdryswi.com plus a plain-HTML and another-builder site you own) joins `npm run corpus`, so a change can't get worse on the others |

---

## 10. Risks

- **The capture-to-Snapshot mapping is the biggest unknown.** The spike shows the back half takes it; fidelity depends
  on deciding FILL/HUG/FIXED across widths. J1's plan should start with that table and a probe on 3 sites.
- **Measured values against the plugin's own model:** the plugin's Container and gutters (64/36/16) differ from a
  site's own padding; J2 writes the site's padding on the section's frame and lets the Container's gutter be the
  difference, which needs probing at every tier.
- **The engine gate is an architecture change** to `adapt/engine.ts` (all rules pass through it); Figma conversions
  must stay byte-identical (AC7's receipt).
- **Bricks Interactions** for entrance animations rest on one sample you supply (milestone 2).
- **Headless Chrome differs from a real browser** (fonts on the machine, GPU): the probe needed the CPU profile
  (`--disable-software-rasterizer --use-gl=disabled`) for screenshots on the Windows desktop.
- **Capture files are large** (pictures inside); the panel holds them in memory once, the plugin never gets the bytes.
- **Old sites drift:** compare against saved captures; re-capture on purpose.

---

## Evidence (probes run for this proposal)

All read-only (public pages, the repo's code imported, nothing written to the repo, WordPress or the clipboard). Chrome
for Testing 156 through `scripts/chrome-cpu.sh`, Node 22.23.3.

- **Probe 1** (`scripts/probe-read.ts` → `probe1/report.json`, `probe1/top-1440.png`, `top-390.png`): bdryswi.com at
  1440 and 390.
  - The header (template 32, 78px / 96px on phones), the page (9) and the footer (35, 34 widgets) are all in the page
    and readable at both widths.
  - Elementor's switch widths are on the page: mobile 767, tablet 1024, laptop 1366, widescreen 2400; the theme adds
    921 and 544.
  - Lazy pictures: 6 shown-but-empty pictures before scrolling, 0 after; lazy backgrounds 4 → 23 (1440) / 28 (390).
  - 5 entrance animations (fadeIn 1, fadeInUp 2, fadeInLeft 2), 2 still hidden after a full scroll.
  - Fonts: Roboto 400/500/600/700 and ADLaM Display faces fail (status `error`); 53 texts use Roboto 600 with no
    working face.
  - Fixed overlays: an accessibility toggle and panel, a reCAPTCHA badge, a fixed copy of the header.
  - Hover through CDP works (button background → rgb(0, 71, 116), "grow" scale), but end states need transitions off.
  - Declared CSS values with their media conditions are readable (CDP `CSS.getMatchedStylesForNode`); Elementor's are
    `var()` chains.
  - Cost: 15–23 s a width; walking 1,436 boxes takes 16–45 ms.
  - The Trustindex widget never appeared in this headless run (no `cdn.trustindex.io` script loaded), so its wake-up
    needs the steps in memory `bdry-home-copy`.
- **Probe 2** (`scripts/probe-hidden.ts` → `probe1/hidden.json`): 34 device-only boxes; shown 15 at 1920/1440, 25 at
  1366/1200, 18 at 1024–768, 21 at 767–390; 23 / 22 / 28 top sections at desktop / tablet / phone.
- **Spike** (`scripts/spike-snapshot.ts` → `spike2/`: `snapshot.json`, `bricks.json`, `bricks.html`, `log.txt`,
  `live-*.png`, `paste-*.png`, side by side `sbs-1440.png`, `sbs-390.png`): one width (1440), flex → auto layout, text
  runs, pictures, SVG, borders, shadows, links; no gradients, hovers, motion, per-width values or fonts.
  - 1,436 boxes → 320 Snapshot nodes (read in 55 ms) → the unchanged `convert()` in 159 ms → 405 Bricks elements (20
    sections, 81 texts, 33 headings, 37 pictures, 2 phone sliders), **0 rule collisions, 1 warning, `assertPayload`
    passed**; custom CSS on 137 of 405 elements.
  - Heights: 1440 paste 8,835 vs live 8,612 (+2.6%); 1024: 12,672 vs 11,982.
  - Desktop (`sbs-1440.png`): hero, the 60-years band, the map section and the service boxes recognisably right. Misses
    that the plan covers: gradients (the "Our Services" band's words white on white), flip boxes captured as their back,
    the header's bar dropped with the fixed copy, the animated "60 Years" as a stand-in, font metrics.
  - Phones (`sbs-390.png`): 767 and 390 scroll sideways (2,251px and 1,120px wide) and miss the site's own phone design,
    which swaps in different boxes: one desktop capture plus the plugin's phone rules can't make the site's phone
    layout. That is why answer 2's per-width measuring is needed.

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
