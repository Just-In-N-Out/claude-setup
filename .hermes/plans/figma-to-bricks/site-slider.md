# site-slider (website importer): a site's slider pastes as Bricks' Slider (Nestable) and plays like the site

Planner: site-slider planner, 2026-11-09. Base: main `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3).
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-slider/planner/` (scripts and their outputs; bdryswi.com
never loaded; staging and darksalmon read with GETs only).

## Questions (the standing auto-go takes the ⭐ answers)

- **Q1. Which pastes get the working slider?**
  - **A ⭐ The Elementor route (`--elementor`), for every Elementor widget holding a slider the capture lists**
    (`web.sliders`: Elementor's Nested Carousel, Image/Media/Testimonial Carousel, Slides, Loop Carousel all use
    Swiper). Its settings come from Elementor's own widget settings, which every capture already keeps
    (`data-settings`), so Justin's saved capture works without a new capture. The plain route stays byte-identical,
    with your 2026-11-06 "Keep all its slides" static slider.
  - B. Both routes. A slider that isn't in an Elementor widget would also convert, but its timing would have to come
    from the slider library itself. Today's capture cuts that record at 60 keys and loses autoplay, loop, effect,
    navigation and pagination (`src/web/readers/libraries.ts:84`). So B needs a capture change and a new capture, and
    it rewrites your 2026-11-06 ruling's tests on the plain route.
- **Q2. How the slides glide.**
  - **A ⭐ On the site's own timing curve:** the row's own `transition-timing-function`, or `ease` when the site sets
    none, as Swiper does. That is one CSS line on the slider's class
    (`.<cls> > .splide__track > .splide__list { transition-timing-function: … !important }`), because Splide writes
    its curve inline.
  - B. Splide's default curve (`cubic-bezier(0.25, 1, 0.5, 1)`). At 2.5 s it visibly starts faster and settles
    longer than the site.
- **Q3. The arrows.**
  - **A ⭐ The site's own drawing, place, size and colour.** Bricks' arrows (`arrows: true`) are used, but their
    look comes from the site's arrow elements as custom CSS on the slider's class: each arrow's own declarations per
    range, and its SVG as a CSS mask in its colour, with Splide's default SVG hidden. Bricks' "Prev/Next arrow" icon
    controls stay empty.
  - B. Bricks' own arrow icon (Splide's chevron) in the site's colour and size at the site's place, editable in the
    slider's Arrow controls. The chevron is drawn a little differently from the site's.
- **Q4. A slider that shows a different number of slides, or a different gap, at some widths.**
  - **A ⭐ Bricks' per-breakpoint keys** (`perPage:<bp>`, `gap:<bp>`), using the site's value at each Bricks tier's
    widest width (991/767/478). The switch happens at Bricks' widths, and the note names the site's own widths.
    `gap:<bp>` is proven (`card-row-and-phone-slider.json`). `perPage:<bp>` isn't: it waits for the "Slider with
    slides per view changed for phones" sample (README "Still wanted"). Live data-splide printing of `height:<bp>` under
    `breakpoints` (darksalmon home, 2026-11-09) shows Bricks prints per-breakpoint options that way.
  - B. One value, the design width's, with a note.

B-Dry's hero needs none of Q4: it shows 1 slide with a 10 px gap at every width.

## Playback (what Justin asked)

1. On B-Dry staging (`/homev2/`, pasted from `whole.json` of build 2026-11-09.3 with `--elementor`), the hero slider
   (basement photo, "The Tri-State's Waterproofing Experts", ‹ › arrows) stands still. Its arrows do nothing.
2. At 990 in the Bricks editor its three slides show stacked, one under another (images/9.png).
3. He wants a site's slider (Elementor's carousels / Swiper and the like) to become Bricks' Slider (Nestable). It
   should show one slide at a time and play like the site at every width: its slides, autoplay timing, transition,
   arrows, dots and pause on hover.

## What the site does (capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, build 2026-11-09.1)

- `web.sliders[0]` is a Swiper (`library: "swiper"`). Its root is
  `…/article:0/div:0/div:0/div:0/div:0/div:0/div:0`, the `.e-n-carousel.swiper` element. It lists 3 real slides,
  `…/div:0/div:{0,1,2}`, and the loop copies `div~0`/`div~1` are script-made (`evidence/…/sliders.txt`, `tree.txt`).
- It sits in Elementor widget `1a9321c`, `elementor-widget-n-carousel`, whose `data-settings` is in the capture's
  marks (`settings.txt`). The settings are: `speed 2500`, `autoplay "yes"`, `autoplay_speed 5000`,
  `pause_on_hover "yes"`, `pause_on_interaction "yes"`, `infinite "yes"`, `arrows "yes"`, no `pagination`,
  `slides_to_show(_tablet/_mobile) "1"`, `image_spacing_custom 10px`.
- Swiper's own params as captured: `speed 2500`, `spaceBetween 10`, `slidesPerView 1`, and breakpoints 0/767/1024/1366/2400,
  all at 1 per view. The record stops after 55 keys (`libraries.ts:84` `.slice(0, 60)` on the params' entries,
  functions and elements dropped), so `autoplay`, `loop`, `effect`, `navigation` and `pagination` are missing from it.
- The arrows are `elementor-swiper-button-prev/next` Divs (role button) beside the swiper root inside the widget's
  holder. Each holds Elementor's chevron SVG (`viewBox 0 0 1000 1000`, `fill hsla(0,0%,93.3%,.9)`, 1em), 25 × 25,
  at the slider's left and right edge, about the middle (`boxes.txt`).
- The timing: Swiper 8.4.5's autoplay (`evidence/…/swiper/autoplay8.js:104-118, 133-146, 191-195`) starts its delay
  only at the slide's `transitionend` (`waitForTransition`, default true). So one slide stays still for 5000 ms and
  then slides for 2500 ms: a new move starts every 7500 ms. Splide counts its `interval` from a move's start
  (README "interval … Splide counts it from a change's start"), so Bricks' interval is 7500.
- In the capture's 768–991 ranges the page was read with no styles (staging-fit's finding,
  `/tmp/claude-1000/sf-forward.txt`). 922–991 drops 1,141 nodes' declarations (`ranges.mjs` output), the swiper row's
  `display:flex`/`overflow:hidden` among them. That is why the slides stack at 990. Job staging-fit-capture fixes the
  capture.

## What the paste does (proof)

- `whole.json` has **no `slider-nested`**. The widget's 82 elements are 60 Div, 13 Block, 3 Image, 3 Heading, 1 Text
  and 2 Code (`paste.txt`).
  - The swiper root, its row and its slides are plain Divs and Blocks with the captured Swiper CSS (`row-vpfc`
    overflow hidden, `row-funi` flex with `transform: translate3d(0px,0,0)`).
  - The arrows are Divs with an SVG, and nothing is bound to them.
  - Under `@media (max-width: 991px)` the row's class reverts `display`/`transform` (`row-funi … display: revert`,
    the styleless range), so the slides stack.
- Staging's saved page `evidence/staging-fit/planner/staging/homev2-2.html` has `brxe-slider-nested` 0 times.
- `notes.txt`: "kept as page code: nested-carousel 1a9321c".

## Root cause (file:line)

1. **No slider is ever made on the site route.**
   - `src/core/site/elementor-fold.ts:276-277`: a widget with no `BODIES` entry, which includes nested-carousel, is
     "kept as page code".
   - `src/core/site/widgets.ts:10,23-27` keeps every real slide in place and leaves out only the loop copies: "(the
     Bricks Slider is a later job)".
   - The code route pastes no scripts, so nothing moves the row and nothing listens on the arrows.
2. **Stacked at 768–991:** the styleless capture reading (staging-fit-capture). A native slider no longer depends on
   the captured Swiper CSS: Splide lays the slides out, so one slide shows even from today's capture.
3. Hidden traps the fix must cover. Each is proven, and none is visible to today's checks:
   - **(a) The reset cancels Splide's CSS.** Bricks prints Splide's CSS inside `@layer bricks`: `splide-layer.min.css`
     (2.3.9 and staging's 2.4.2 are byte-identical, `bricks-assets/`, sha256 3874131…) and the slider's element block
     in `post-<id>.min.css` (darksalmon `ds-post-10.min.css`). The site route's unlayered reset
     (`src/core/site/classes.ts:26`, `all: revert`) cancels all of it: the track's `overflow:hidden`, the list's flex
     row, the arrows' places, the dots. This is the trap `site-accordion` already fixes for the accordion
     (`classes.ts:148-153`).
   - **(b) The renderer can't see that.** `test/browser/render.ts:347-350` loads Splide's core CSS from jsdelivr
     unlayered and mounts `new Splide(e)` itself. It uses neither Bricks' layered CSS nor `bricksSplide()`, so
     `bricksData.splideInstances` stays empty and nothing can pause it.
   - **(c) A playing paste moves under `site:check`.** `site:check` holds nothing still on the paste side
     (`test/web/lib/site-check.ts`; only `test/web/lib/sliders.ts` `stopSliders` knows `bricksData.splideInstances`).
     So a paste that plays would move between readings.

## The rule (general; Elementor's own markers and Swiper's record only, never a site's ids, words or class names)

On the Elementor route, an Elementor widget whose subtree holds the root of a `web.sliders` record with 2 or more real
slides becomes one **Slider (Nestable)**, as long as all its slides are children of one element (the row) under the
root:

- **Structure.** The library root becomes the `slider-nested` element (its own class; `bare` settings). The row and
  every element between the root and the row are left out, because Bricks prints `splide__track`/`splide__list`
  itself. Each real slide becomes a **Block** in order, holding what it holds today. The loop copies stay out as now.
  - The root's other children are left out and named: they would become slides inside Bricks' list. Script-made ones
    (`~`, e.g. Swiper's live region) are named in one line.
  - The site's arrow and dot elements (Swiper/Elementor's framework classes `swiper-button-prev|next`,
    `elementor-swiper-button-prev|next`, `swiper-pagination`, read from marks) are left out. Bricks' arrows and dots
    replace them.
  - The widget's own wrappers stay as today (not folded; site-native-structure may fold them later).
  - A vertical slider (`direction: vertical`), a slider within a slider, slides under two parents, or 1 real slide:
    kept as today, with a note saying why.
- **Settings** (Bricks' keys and value types from `reference/bricks/slider-autoplay-documented.json` and
  `slider-nested-schema.json`; number controls as strings).
  - **Where each value comes from:** Swiper's captured params where present (`speed`, `spaceBetween`,
    `slidesPerView`, `breakpoints`, `direction`). Elementor's widget settings for the rest: `autoplay`,
    `autoplay_speed`, `pause_on_hover`, `pause_on_interaction`, `infinite`, `arrows` or `navigation` (both / arrows /
    dots / none), `pagination` (bullets…), `effect` or `transition` (slide / fade), and `speed` or `transition_speed`
    when the params lack it.
  - The builder reads each widget type's keys and defaults from Elementor's source, not from memory: core
    `includes/widgets/image-carousel.php` and `assets/dev/js/frontend/handlers/` on GitHub (GPL). For Pro widgets, use
    the keys visible in a capture's `data-settings`, and if a key is missing, leave Bricks' default and name it.
  - `height: "auto"` (CLAUDE.md, never `autoHeight`); `gap` = the site's spacing (B-Dry `"10"`).
  - **Autoplay:** `autoplay: true`; `interval` = delay + speed when Swiper waits for the transition (default, true for
    Elementor); `speed` = the move's ms; `pauseOnHover` = the site's pause on hover; `pauseOnFocus` = the same
    (keyboard users get what mouse users get, as the Figma route's R4). For B-Dry: interval `"7500"`, speed `"2500"`,
    both pauses true.
  - **Loop:** loop → Bricks' default type (key unset); not looping → `type: "slide"`, `rewind: true` (Swiper's
    autoplay returns to the first slide; `type: "slide"` is printed live on darksalmon); fade → `type: "fade"`,
    `rewind: true` (as the Figma route).
  - **Per view and gap:** per view `perPage` (written only when it isn't 1) and gap per Q4.
  - **Controls:** `arrows: true` when the site shows arrows; `pagination: true` when it shows bullets (fraction and
    progress bar pagination become dots, named).
  - **Not written** (Bricks' defaults kept, as on the Figma route): `keyboard`, `direction`, `perMove`, `start`.
- **Look (custom CSS on the slider's class, after naming, as the accordion's open look is appended).**
  - **The arrows (Q3 A).** Each Bricks arrow takes the site arrow's own declarations per kept range at
    `.<cls> > .splide__arrows > .splide__arrow--prev|next`. Their place values are copied only when the arrow's
    containing block has the slider root's box at every captured width (B-Dry: holder = root at every measured width);
    otherwise Bricks' default places are used, named. The drawing is the site's SVG markup as a `mask` in
    `currentColor` on `::before`, sized as the site's SVG is, with the Splide SVG hidden. The previous arrow's
    transform is the site's own, so Bricks' `scaleX(-1)` flip (layered, and beaten by unlayered CSS) never mirrors
    the site's left chevron.
  - **The dots:** the site's bullet and active bullet declarations on `.splide__pagination__page` and `.is-active`,
    and the bullets' row place on `.splide__pagination`.
  - **The glide (Q2 A):** the row's timing function, as above.
- **Splide restored under the reset:** a new shared class **`site-slider-<4>`**, named after its rules
  (`classes.ts versioned`, like `site-reset-<4>`), on every pasted slider.
  - It holds Bricks' `splide-layer.min.css` rules, scoped `:where(.site-slider-<4>)…`. At weight (0,1,0), printed
    right after the reset, they beat the reset, and the site's own classes printed later beat them. It also holds the
    button resets Bricks' front end gives arrows and dots (border 0, transparent background), which `all: revert`
    turns back into UA buttons.
  - Bricks' element block (slide centring, previous-arrow flip) is **not** restored: the slide keeps the site's own
    look.
  - The constant is generated text, and a unit test proves it equals the scoped transform of the byte copy in
    `reference/bricks/frontend-2.3.9/`, so a Bricks upgrade can't drift unseen.
- **Notes**, one per slider:
  - "<widget> <id>: Bricks' Slider (Nestable), N slides, plays every X s (pauses under the mouse)".
  - When the site stopped for good after a click (`pause_on_interaction`): "after a visitor uses its arrows the old
    site stopped playing; Bricks plays on (Bricks has no such setting)".
  - What was left out.
- **Unchanged:** the plain route (Q1 A), every paste without a slider, and the Figma route (no file under
  `src/core/{understand,style,adapt,emit}` or `src/plugin` changes).

Reduced motion: Splide 4.1.4's own `reducedMotion` (autoplay paused, speed 0) applies as in any Bricks slider. This is
a ruling, not yet confirmed.

## Acceptance criteria (all proposed)

- **AC1 (proposed):** On the Elementor route, a captured Elementor carousel pastes as one `slider-nested` at its
  Swiper root's place. It holds exactly its real slides as Blocks in order, with no row element, no loop copy, no
  site arrow or dot element, and one note naming it. The plain route still pastes the same capture byte-identically.
  Test: `test/web/site-elementor-slider.test.ts` "a captured Elementor carousel pastes as one Slider (Nestable)
  holding its own slides" (generic fixture `test/fixtures/web/sites/elementor-slider/`; RED on main: no
  `slider-nested`).
- **AC2 (proposed):** The settings are as the rule says for both fixture carousels:
  - **Nested carousel:** loop, autoplay delay 600 + speed 300 → `interval "900"`, `speed "300"`, `pauseOnHover` and
    `pauseOnFocus` true, `arrows` true, `gap "10"`.
  - **Image carousel:** fade, dots, `navigation "dots"`, no hover pause → `type "fade"`, `rewind` true,
    `pagination` true, `arrows` unset.

  Each table row of Elementor settings maps to the expected Bricks settings, and every written key and value type is
  valid in `slider-nested-schema.json`. Test: `test/unit/site-slider.test.ts` "Elementor's carousel settings become
  Bricks' slider settings" (RED on main: the module doesn't exist).
- **AC3 (proposed):** In the site renderer, now running Bricks' own `splide-layer.min.css`, Splide 4.1.4,
  `bricksSplide()` and the slider element block, the fixture's paste does three things:
  - At 1440, 991, 767, 390 and 300 it shows exactly one slide inside the slider's frame at rest, and the first slide's
    box is within 2 px of the site's first slide.
  - It moves to slide 2 within interval ± 250 ms and stays still while the pointer is over it.
  - Next shows slide 2, and Previous on slide 1 shows the last slide.

  Test: `test/web/site-elementor-slider.test.ts` "the pasted slider shows one slide, plays on the site's timing,
  pauses under the mouse and its arrows move it" (RED on main).
- **AC4 (proposed):** Under the site reset, the Bricks parts of a pasted slider compute what they compute in a plain
  Bricks page without the reset: the track's `overflow`, the list's `display`/`flex-wrap`, the slide's `flex-shrink`,
  the arrows' `position`/`border`/`background`, the dots' `display`/`position`. Without `site-slider-<4>` the test
  fails, and the class's text equals the scoped `reference/bricks/frontend-2.3.9/splide-layer.min.css`. Tests:
  `test/web/site-slider-reset.test.ts` "Splide's own CSS survives the site reset" (RED on main: the parts revert) and
  `test/unit/site-slider.test.ts` "site-slider restores exactly Bricks' splide-layer rules, scoped".
- **AC5 (proposed):** At every capture width of the fixture, each pasted arrow's drawing box is within 2 px of the
  site's arrow SVG box. A pixel at the chevron's ink matches the site's colour (±8 per channel), and the previous
  arrow points left (its ink's leftmost column is in the drawing's left half, as on the site). Test:
  `test/web/site-elementor-slider.test.ts` "the slider's arrows are the site's, where the site draws them" (RED on
  main).
- **AC6 (proposed):** The image carousel's dots appear: one per real slide, the active one in the site's active
  colour and the others in the site's colour, and their row's box within 2 px of the site's bullets' row at 1440 and
  390. Test: `test/web/site-elementor-slider.test.ts` "the slider's dots look like the site's" (RED on main).
- **AC7 (proposed):** `site:check` holds every paste slider on its first slide before reading. The fixture's
  `site:check --all --elementor` passes at every width with the slider playing, and fails when that hold is removed
  (mutant). Test: `test/web/site-check-settle.test.ts` "a pasted slider is held on its first slide while site:check
  reads" (RED on main: slide 2 in place after the interval).
- **AC8 (proposed):** Nothing else changes.
  - Every plain-route paste of the site fixtures (`pageCode`, `elementorCode`, `elementorBand`, the code-page site
    with its two Swipers) and every Elementor-route paste of a fixture with no slider is byte-identical to main's
    goldens, written in task 0 from main `fd1986dc`.
  - `npm run corpus` and `npm run replay` of the root debug file are byte-identical to main.
  - The class-name checks (`test/web/lib/class-names.ts` `bareNames`/`sharedNames`) pass with `site-slider-<4>`
    allowed.

  Test: `test/unit/site-slider-unchanged.test.ts` "pastes without an Elementor slider are byte-identical" (passes on
  main by construction; its mutant: the slider step run on the plain route fails it).
- **AC9 (proposed):** B-Dry, named-only (`F2B_BDRY_CAPTURE=/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`).
  - The `--elementor` whole paste has exactly one `slider-nested` (the hero) holding 3 Blocks, with settings
    `autoplay true, interval "7500", speed "2500", pauseOnHover true, pauseOnFocus true, arrows true, gap "10",
    height "auto"` and no `type`/`perPage`. The two `elementor-swiper-button` Divs are gone, and the pause-on-interaction
    note is present.
  - Rendered at the capture's 48 widths, exactly one of the three slide headings shows inside the hero frame, 768–991
    included.
  - Outside 768–991, the first slide's heading and buttons are within 2 px of today's paste.
  - `site:check --all --elementor` on the saved capture gives no new failing row against main's report, except inside
    the hero slider's subtree.

  Test: `test/web/site-slider-bdry.test.ts` "B-Dry's hero is one Slider (Nestable) of 3 slides playing every 7.5 s"
  (RED on main).
- **AC10 (proposed) (live):** Justin re-pastes the `--elementor` whole page on `https://bdry.staging.growithgro.com/homev2/`
  (after staging-fit-capture's re-capture if it has merged).
  - On the live page (and in the editor at 990) the hero shows one slide at a time at 1440, 990, 767 and 390. It
    slides to the next every 7.5 s with a 2.5 s glide, pauses under the mouse, and its ‹ › arrows move it, looking
    like the site's.
  - A later agent may also read the page logged out with `?f2b=<random>`: `data-splide` holds `autoplay:true,
    interval:7500, speed:2500, pauseOnHover:true`, the slider has `is-initialized`, and one slide is in view.

## Tasks (test-first; commit after each passing task; ledger `.superpowers/sdd/site-slider/progress.md`)

0. **Setup.**
   - Copy this plan to `docs/plans/2026-11-09-site-slider.md`.
   - Run `npm run corpus` (baseline).
   - Write AC8's goldens from main: the plain-route and no-slider Elementor-route pastes of the site fixtures, as
     `test/fixtures/site-slider-base/*.json`, the same way as `site-motion-base`.
1. **Bricks' Splide in the reference and the renderer (AC4 RED first).**
   - Add byte copies to `reference/bricks/frontend-2.3.9/` from `evidence/…/bricks-assets/`: `splide-layer.min.css`,
     `splide.min.js` (Bricks' copy of Splide 4.1.4) and `el-slider-nested.min.css` (the slider block of darksalmon's
     `post-10.min.css`). Record their SHA256SUMS lines, plus a README paragraph naming the source and the 2.4.2
     match.
   - `renderPage` in site mode (`bricksCss`): print those layered, run `bricksSplide` from `bricks.min.js` (with
     `bricksData.splideInstances` and `i18n` prev/next strings), and keep today's jsdelivr path for Figma pages.
   - Write `site-slider-reset.test.ts` and see it RED.
2. **`src/core/site/elementor-slider.ts` (AC1, AC2 units RED first).**
   - Recognise the slider, give the picks (root → `slider-nested` with shared `site-slider-<4>` and `bare`; slides →
     `block`), the leave-outs, the settings from Elementor + Swiper, and the notes.
   - The `site-slider` CSS constant in `src/core/site/slider-css.ts`, generated and tested against the reference copy.
   - Hook into `foldElementor` beside the accordion branch: count it as mapped, and remove the row from the root's
     children in the folded nodes, as `fold` rewrites children.
   - Add to `SHARED_CSS` and allow it in `class-names.ts`.
3. **The look (AC5, AC6 RED first).** The arrows' and dots' CSS and the glide line (Q2/Q3), appended to the slider's
   class after naming (`convert.ts`, as `lookCss` for accordions), with the containing-block check.
4. **Generic fixture `elementor-slider` (AC1, AC3, AC5, AC6).**
   - Two `main` sections (testing-pitfalls: a lone section breaks `sectionsOf`).
   - (1) An `elementor-widget-n-carousel` with 3 slides holding `data:` background pictures and headings, Elementor
     arrows with inline chevron SVGs, `data-settings` with autoplay 600/300, pause on hover, infinite.
   - (2) An `elementor-widget-image-carousel` with fade, dots, `navigation "dots"`, no hover pause.
   - A small script gives each `.swiper` a Swiper-like instance: `params` with speed, spaceBetween, slidesPerView and
     breakpoints; `slides`; `slideTo`; `autoplay.stop`. It also adds loop copies and script-made bullets, as
     `code-page/slider.js` does.
   - Capture it in the test, convert with `--elementor`, render, and assert.
5. **`site:check` holds paste sliders (AC7)** in `test/web/lib/site-check.ts` `settle`/reading: pause and `go(0)`
   every `bricksData.splideInstances`, the same code as `test/web/lib/sliders.ts`. Write the mutant.
6. **B-Dry named-only (AC9)** and AC8's unchanged test; the full gates (`npm run check`, browser site tests file by
   file, `npm run corpus`, mutants per `mutation-testing-discipline` under `systemd-run … MemoryMax=4G`, B-Dry under
   8G).
7. **Records.** The HANDOFF section (the rule, rulings Q1–Q4 not yet confirmed, the pause-on-interaction ruling, the
   reduced-motion ruling, known limits), paste check `<site-slider id at merge>` for AC10 with steps in the end-of-run
   list, and the ledger.

## Proof widths

The capture's 48 widths, plus 300 (one width under the narrowest; testing-pitfalls) and the laptop widths
1300/1200/1100 for the arrows' place.

## Overlaps with the other five jobs (merge order)

- **staging-fit / staging-fit-capture (merge first).**
  - It fixes the 768–991 styleless reading. Until it merges, AC9 asserts one slide in view at 768–991 but not 2 px
    there.
  - It may also change the renderer's Bricks model (2.4.2 prints class controls as `.cls.brxe-<el>`, 0,2,0) in
    `test/browser/render.ts` / `test/web/lib/site-check.ts`, the same files as tasks 1 and 5. Rebase this job onto
    it; the slider's CSS is custom CSS, so control weight doesn't touch it.
  - Their capture files (`src/web/…`) aren't touched here under Q1 A.
- **site-faq:** shares the insertion points `elementor-fold.ts` (widget branches), `classes.ts SHARED_CSS`,
  `convert.ts` (appended looks) and the renderer's Bricks script list (`bricksAccordion` + `bricksSplide`). These are
  small textual conflicts; keep each widget in its own module.
- **site-menu:** the same insertion points (it may add an Offcanvas/popup emitter and a Bricks script). Same advice.
- **site-reviews:** Trustindex isn't a `web.sliders` record (it scrolls by `scrollLeft`). If that job makes the
  reviews a Bricks slider, it should reuse this job's settings writer, `site-slider-<4>` restore class and renderer
  support rather than write its own. Merge this job first in that case.
- **site-native-structure:** it may change which element the widget's wrappers become (Section/Block/Div folds). This
  job's slider stays at the Swiper root's place with Block slides either way. If native-structure folds the widget's
  box and holder into the slider, the slider's class gains their declarations, and the arrows' containing-block check
  then compares against the folded root. Nothing in the settings changes. If it changes what a slide's content
  becomes, the slides still hold it.
- Shared files touched by this job: `src/core/site/{elementor-fold,classes,convert,widgets}.ts` (small hooks), new
  `src/core/site/{elementor-slider,slider-css}.ts`, `test/browser/render.ts`, `test/browser/render-slider.ts`,
  `test/web/lib/{site-check,class-names}.ts`, `reference/bricks/frontend-2.3.9/` (new files only).

## Bricks samples

- Not needed to build. `slider-autoplay-documented.json` (schema 2.4.3 + live `data-splide`) covers every key written.
  `type: "slide"` is printed live on darksalmon (2026-11-09, `bricks-assets/ds-home.html`).
- Wanted (already in README "Still wanted"): Justin's own Slider (Nestable) copy with Autoplay, Interval 7500, Speed
  2500, Pause on hover and focus, Arrows and Gap 10, and one with "Items to show" changed for phones (Q4 A's
  `perPage:<bp>`).

## Risks

- **Arrow places:** B-Dry's measured arrow top (549 at 1440 in a hero 78–997) doesn't match a naive reading of
  `calc(50% − 15px)` + `translate(-50%)` (510), so the arrows' containing block may be the widget box, not the root.
  AC5 catches any shift. If the boxes differ, the rule falls back to Bricks' places, named.
- **Splide `visibility: hidden` until mounted** (restored with the rest): a page whose Splide never mounts shows no
  slider. That is Bricks' own behaviour.
- **The editor:** Bricks runs Splide in the editor, so the editor shows one slide. This is AC10's live check.
- **Follow-up:** the slider-library record's 60-key cut (`libraries.ts:84`) and Q1 B for non-Elementor sliders.
