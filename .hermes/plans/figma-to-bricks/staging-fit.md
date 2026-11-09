# staging-fit: the website importer's paste on tablets and phones (plan, 2026-11-09)

Planner: staging-fit (Opus 5.5). Main `fd1986dc` (Build 2026-11-09.3). Evidence:
`~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index: its `README.md`). Website importer rules apply
(one real-bug review per job, edge cases to follow-ups). Scope after the 2026-11-09 split: the widths (Justin's notes 5
and 7) and the renderer gaps; the ☰ menu, hero slider, reviews widget, FAQ and native structure are other planners' jobs
(see "For the other jobs" at the end).

## Questions (⭐ = the answer the standing auto-go takes)

1. **A range whose page load lacks the design width's styles** (job A). ⭐ **A:** wait for its stylesheets, then try a
   fresh page load of that range alone (twice); if it still lacks them, **stop the capture** with one plain line naming
   the widths and the stylesheet that didn't arrive. B: keep going and mark the range unread (its paste copies the
   neighbouring range, wrong at those widths). C: save it as today.
2. **Old captures with a styleless range** (job A). ⭐ **A:** `npm run site`, `site:check` and the panel refuse such a
   capture (exit 2: "the capture read 768–991 from a page without its styles: capture again"). B: warn and paste anyway.
3. **How a narrower range drops a declaration a wider one set** (job B). ⭐ **A:** never `revert`: each range's own
   declarations go in a block bounded by both its widths (`@media (min-width: …) and (max-width: …)`), as the FAQ's open
   look already does, so nothing cancels another rule (website pastes change bytes; Figma and plain-route pastes
   byte-identical). B: keep `revert`, only stop inline-element rules from cancelling (narrower fix). Job A alone removes
   B-Dry's cancels; job B is the general guard (61 cancels remain in correctly read ranges).
4. **Which Bricks the checks draw** (job C). ⭐ **A:** the renderer follows the target site's Bricks version (staging runs
   **2.4.2**, darksalmon 2.3.9): add Bricks 2.4.2's served `frontend-light-layer.min.css` to `reference/bricks/` and a
   `--bricks <version>` choice, default the newest sample. B: keep 2.3.9 only.
5. **Order.** ⭐ **A:** job A first (it is why tablets break), job C beside it (other files: `test/`, `tools/`), job B
   after A merges; then Justin re-captures bdryswi.com and re-pastes (the saved capture can't be repaired).

## Playback

Justin pasted the importer's whole-page paste (`/home/justin/f2b-test/paste-el3/whole.json`, `--elementor`, from the
2026-11-09 capture of bdryswi.com) into B-Dry staging. Desktop looks fine. At tablet widths (his screenshot at 990, Bricks
editor 100%) the header shows twice (the site's desktop bar and its phone bar), the hero's three slides stand one under
another, "View Our Services" is nearly invisible; on phones the hero buttons lose their colour (plain words on the
photo). Zoomed out in the editor (the canvas then lays the page out wider) it "works fine". He asked whether the capture
is right: **it is not, at 768–991**.

## What I measured

Three things per element, from each part's root, at all 48 capture widths + 300 (`measure/`): (a) the capture's boxes,
(b) the renderer's drawing of `whole.json` (site:check's way: Bricks' front-end CSS, hostile theme, capture pictures),
(c) the real staging page (logged out, `https://bdry.staging.growithgro.com/homev2/?f2b=<random>`, served HTML saved,
all 1112 paste elements mapped by structure, 0 mismatches). Plus probes of paint and rules, the offline 2026-10-29 served
site, and `npm run site:check --all --elementor` on the saved capture.

### Differences over 2 px, worst first (top 10)

| # | Where | Widths | Capture (a) | Renderer (b) | Staging (c) | Cause |
|---|---|---|---|---|---|---|
| 1 | Page: every section, hero first (3 slides stacked) | 768–991 | hero 3534 tall, page 17,588, 1024 wide at 991 | hero 3452, page 16,156 | hero 3452, page 16,777, page 1024 wide | R1 |
| 2 | Footer: reviews section ("Facebook") | 768–991 | 7700 tall | 7662 | 3774 | R1 (+R4 pictures) |
| 3 | Header: both header bars shown (desktop + phone) | 768–991 | 126+78 | 138+79 | 138+79 | R1 |
| 4 | Hero buttons lose background and colour (link blue `rgb(0,0,238)`, no gradient) | 300–767 | gradient, `#fff` (every range) | lost | lost | R2 (from R1) |
| 5 | Hero buttons' size (`jojdce`, `efuxkc`, `fejqvd`) | 300–767 | 236.2×47 | 164.7×38.6 | 236.2×47 | R3 |
| 6 | "There are many things…" section height | 390 (phones) | 1828 | 1791 | 1828 | R3 |
| 7 | "There are many things" button row (`amotgo`) | 300–767 | 370.2×46 | 258.5×38.6 | 370.2×46 | R3 |
| 8 | FAQ: first answer closed, first title stuck orange (section 571 vs 595) | all | first answer open | closed | closed | R1 (→ site-faq job) |
| 9 | Flip-box face icons (`umnxgl`, `oavutc`) | ≥1025 | 50×50 | 50×50 | 386×300 (section heights equal) | R5 (unexplained) |
| 10 | Footer picture `nvwzkg` | all | 20×20 | 65.8×35.6 (alt box) | 20×20 | R4 |

At desktop (≥992) and phones the page's sections are otherwise equal in (b) and (c) to the pixel
(`measure/sections-1440-957-390.txt`). `site:check` on this capture already **fails** (`sitecheck/report.json`): header 24 px
and page sections 146–209 px at 768–991, and "missing" boxes at every width (hero slide parts, the reviews' script-made
avatars): the brief's "within ~2 px" is not today's result.

## Root causes (proved)

**R1: the capture read 768–991 from a page without its styles, and nothing noticed.**
- `web.code` of `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`: range 922-991 drops **18,895** declarations
  the next wider range had (keeps 859) and 601-767 adds **20,211** back; every other range changes ≤ 456. The hero
  container `.e-con` (`…/article:0/div:0/div:0/div:0`) has every property `null` at 922-991 (display, flex-direction,
  box-sizing, width…), restored at 601-767.
- Boxes agree: at 991/957/922 the page is laid out **1024 px wide** (overflowing), header 244 tall with both bars shown,
  hero 3534 (vs 997 at 1024 and 900 at 767), page 17,588 (vs 9,116 at 1024). Shown nodes 1,291 at the four tablet
  ranges vs 1,120–1,198 elsewhere (Elementor's `elementor-hidden-*` and `.collapse{display:none}` lost: all five FAQ
  answers "shown" there). `timings`: `code` 8–13 s at the tablet ranges vs 30–36 s elsewhere (fewer rules matched).
- The real site isn't like that: bdryswi's served home of 2026-10-29 with its CSS keeps the hero at 997 and the page
  1024→768 wide at every tablet width (`probe-critical/result.txt`, "full"); even Jetpack Boost's critical CSS alone
  keeps the hero at 997, so the tablet loads had (nearly) no stylesheet at all.
- Why the site sent no styles to those four loads can't be proved without loading bdryswi.com (forbidden). Facts: the
  four tablet ranges were read side by side as one batch (`src/web/capture.ts:58` `WINDOWS = 4`, `inOrder`); the site
  serves its CSS as Jetpack Boost `_jb_static` bundles behind `media="not all"` + `onload` swaps (served HTML
  2026-10-29), on WordPress.com hosting that refused one of its own font files with HTTP 403 in this very capture.
- **Our defect:** a range's page load is read whatever stylesheets it got. `src/web/session.ts:189-194` accepts the load
  on the load event, fonts and a document status; `src/web/capture.ts:149-177` (`readOpened`) checks only the status
  (`:155`) and reloads, then reads boxes (`:172`) and code (`:177`). No check compares the load's stylesheets with the
  design width's, and nothing downstream (site, site:check, capture:check) notices a range that lost most declarations.
- Effect in the paste: `blocksOf` (`src/core/site/blocks.ts:23-36`) turns every dropped declaration into `revert` in the
  `@media (max-width: 991px)` blocks (**7,392** `revert`s there, `reverts.ts`), then puts them back at 767: from 768 to 991
  Bricks shows the unstyled site (both headers, slides stacked, buttons unpainted). The Bricks editor at 100% draws the
  canvas 990 wide (inside that block); zoomed out its canvas is laid out wider, so the page looks right: Justin's clue.

**R2: a narrower range's `revert` beats the element's own class (the phone buttons).** In the unstyled tablet read the
hero's button link was an inline element inside a words box, so the wrapper's class got an inline-element rule
`.home__protecting-your__inner-dwzn > :nth-child(1)` (`src/core/site/classes.ts:99-100`, `:130`) at `max-width: 991px`,
and at `max-width: 767px` that rule writes `background-image: revert; color: revert; font-size: revert…` (0,2,0). It
beats the link's own class `.home__protecting-your__inner-fisl` (0,1,0: gradient, `#fff`), and `revert` rolls back the
whole author origin, so the link gets the browser's link blue and no background (`probe2/probe3.json`, renderer; the
same on staging, `probe2/staging.json`). 128 of the 132 `revert`s in the 767 block are such rules. With R1 fixed these
rules disappear for B-Dry, but the mechanism is general: any `revert` cancel also cancels a lower-specificity rule the
paste writes for the same element (another class's inline rule, an open look's `.acc > .brx-open .cls`), and outside the
broken ranges the paste still writes 61 cancels (1024 and 1366 blocks).

**R3: the renderer prints a class's control CSS as `.cls`; Bricks prints `.cls.brxe-<element>`.** Staging's served class
CSS (`staging/css/inline-2.css`): all 343 control blocks are `.home__….brxe-div {…}` (`brxe-heading`, `-image`,
`-block`, `-text`, `-accordion-nested` too), custom CSS as written. `test/browser/render-order.ts:14-25` and
`render.ts:105-127` (`settingsCss`) use `.${g.name}`. So in the renderer the inline rule above (0,2,0) also beats the
link's `_typography:mobile_landscape` control (font-size 23px) and the button shrinks to 164.7×38.6, while live Bricks
keeps the control (0,2,0, printed later) and draws 236.2×47, as the site does (`measure/look.ts` rows `jojdce`,
`amotgo`). The checks therefore misjudge the real paste both ways.

**R4: the checks draw only part of what the visitor gets.** site:check renders each part alone, in a Chrome that reaches
no host but 127.0.0.1 and Google Fonts (`tools/lib/site-chrome.ts`), so pictures of other hosts (Trustindex's
`cdn.trustindex.io`) draw as alt boxes (`nvwzkg` 65.8×35.6 vs 20×20); it never measures the published page; and it
draws Bricks 2.3.9's front-end CSS (`reference/bricks/frontend-2.3.9/`) while staging runs **Bricks 2.4.2**
(`themes/bricks/style.css`; its `frontend-light-layer.min.css` differs: `--bricks-input-height`,
`.bricks-button:where(…)`, `staging/css/`).

**R5 (open): flip-box face icons** `umnxgl`/`oavutc` measure 50×50 in the renderer and the capture but 386×300 on
staging at ≥1025, with every section height equal: likely a 3D-turned face measured differently; job C explains it.

## Job A, staging-fit-capture: a capture never keeps a styleless range (first)

Files: `src/web/session.ts`, `src/web/capture.ts`, new `src/web/styled.ts` (pure check + in-page reader), new pure
`src/core/site/styled-ranges.ts`, `tools/site.ts`, `tools/site-check.ts`, `tools/capture-check.ts`, the panel's capture
path (`src/ui/` where a capture file is read for Convert).

Tasks:
1. In-page reader (`styled.ts` `sheetsOf`): every `link[rel~=stylesheet]` (href, `media` now, `sheet` present, rule
   count or "cross-origin"), every `<style>` (id, rule count), and the `performance` resource entries of stylesheets
   (`responseStatus`, failed). Pending: a link whose `sheet` is null or whose media is a deferral (`not all`, `print`) with
   an `onload`/`data-media` swap.
2. Design width's load: its list is the reference. Every other range's load, before `s.full()`: wait (≤ 15 s, polling
   500 ms) until no stylesheet is pending; then compare. Missing = a reference sheet (by href without query, or `<style>`
   id) absent, not applied, answered ≥ 400, or with < 50% of its rules. On missing: close that load, wait 30 s, open a
   fresh page load of that range **alone** (outside the side-by-side batch), at most 2 tries (Q1 A); still missing →
   throw a plain error: "The 768–991 widths came without the site's styles (…/_jb_static/??f330d6c538 didn't load) after
   3 tries: capture again later." Record each range's sheet summary in `web.code.sheets[range]` (new, optional field).
3. Pure detector `unstyledRanges(capture)`: a range whose code drops ≥ 40% of the declarations its wider neighbour holds
   while a narrower range restores ≥ 80% of them, or (with `web.code.sheets`) that lacks a reference sheet. Thresholds
   pinned by tests on B-Dry (flags exactly 922-991, 835-921, 769-834, 768-768) and on every corpus capture (flags none).
4. `npm run site`, `npm run site:check`, `npm run capture:check` and the panel refuse a flagged capture (exit 2, Q2 A),
   naming the widths.
5. HANDOFF section + ledger; a paste check for Justin's re-capture and re-paste.

ACs (all **proposed**):
- **AC1 (proposed):** a fixture site whose stylesheet answers 503 to its 2nd–4th page loads (or holds a `media="not all"`
  swap 20 s) is captured with every range styled: the saved capture's code and boxes at the tablet anchors equal a clean
  capture's (≤ 0.5 px). Test `test/web/capture-styled-ranges.test.ts` "a range whose stylesheet failed is read again";
  RED on main (main saves the styleless reading).
- **AC2 (proposed):** when the sheet never arrives, the capture stops with the plain line naming the widths and the sheet,
  exit 1, no capture file. Same file, "a range that never gets its styles stops the capture".
- **AC3 (proposed):** `unstyledRanges` flags exactly 922-991, 835-921, 769-834, 768-768 on
  `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (named-only, skipped without it) and nothing on a generic
  clean fixture capture and every `corpus/` capture. Test `test/unit/site-styled-ranges.test.ts`.
- **AC4 (proposed):** `npm run site -- <flagged capture> --all` and `npm run site:check -- <flagged capture> --all` exit 2
  with the line naming the widths; a clean capture runs as before. Test `test/web/site-cli.test.ts` "a capture with a
  styleless range is refused" (generic fixture capture with one range's declarations removed); RED on main.
- **AC5 (proposed):** Figma conversions and every existing paste of a clean capture are byte-identical (`npm run
  corpus`, `npm run replay` on the corpus, `test/web/site-*` suites unchanged).
- **AC6 (proposed) (live):** Justin re-captures bdryswi.com with this build; the new capture has no flagged range; its
  `--elementor` whole paste on staging (logged out, read by job C's `site:live`) is within 2 px of the capture at
  768–991 for header, page and footer, except boxes a script styles and the other jobs' widgets; at 990 one header and
  one hero slide show; on phones both hero buttons keep their gradient and white words.

## Job B, staging-fit-cancels: no per-range rule cancels another (after A)

Files: `src/core/site/blocks.ts` (`blocksOf`, `blocksOfStates`), `src/core/site/classes.ts` (`rules`, `customCss`),
`src/core/site/elementor-accordion.ts` `lookCss` (already bounded: reuse its "run of kept ranges with min and max"),
`test/browser/render.ts` unchanged.

Tasks: 1. `blocksOf` writes, per property, one block per run of ranges with the same value, bounded by the run's own
min and max width (`@media (min-width: A) and (max-width: B)`; the widest run unbounded above, the narrowest below);
a range without the property gets nothing (no `revert`). 2. Bricks controls (`controls.ts`) keep their tier keys as now
(a control's value at a tier still cascades: keep a control only where its runs are nested as Bricks' tiers cascade, else
leave the property in custom CSS). 3. Inline-element rules and state rules use the same runs. 4. Re-run the B-Dry
proofs (site-elementor-*, site-page-bdry, site-motion-bdry) and the corpus.

ACs (**proposed**):
- **AC7 (proposed):** generic fixture: a link that is an inline word at 768–991 (`display: inline` there) and its own
  painted button elsewhere: the paste at 600 keeps the button's background and colour (computed style equals the
  site's). Test `test/web/site-range-cancels.test.ts` "a narrower range never reverts another rule"; RED on main
  (`rgb(0,0,238)`, no background).
- **AC8 (proposed):** no website paste of the corpus captures or the B-Dry capture contains `revert` outside
  `site-reset` (grep test over `siteParts` output, both routes, both picture modes): `test/unit/site-no-revert.test.ts`.
- **AC9 (proposed):** every existing site proof stays within its tolerance (site-code-proof, site-elementor-proof,
  site-page-proof, site-motion-proof, B-Dry named-only ones); Figma conversions byte-identical (`npm run corpus`,
  replay); website pastes, plain and `--elementor`, change bytes only where a range drops a declaration (HANDOFF says so,
  Q3 A).

## Job C, staging-fit-renderer: the checks see what Bricks shows (beside A)

Files: `test/browser/render-order.ts`, `test/browser/render.ts` (`settingsCss`), `test/web/lib/site-check.ts`,
`tools/site-check.ts`, `tools/lib/site-chrome.ts`, new `tools/site-live.ts` (+ `npm run site:live`),
`reference/bricks/frontend-2.4.2/` (Q4 A), `reference/bricks/README.md`.

Tasks:
1. Control CSS of a global class prints as `.cls.brxe-<name>` once per element name using the class (live 2.4.2 print,
   `staging/css/inline-2.css`; record the rule in `reference/bricks/README.md` "Class selectors").
2. `npm run site:live -- <capture> <url> [--elementor] [--widths …]`: read a published page logged out (GET only),
   map the paste's elements by structure (as `measure/measure.ts` does: no ids are printed for most elements), answer the
   old site's pictures from the capture's bytes and refuse its host, compare to the capture like site:check, write
   `report.json` and shots. This is how a later agent re-measures staging after Justin's re-paste.
3. site:check: `--whole` draws header + page + footer in one page as pasted; pictures on other hosts the capture holds
   bytes for are served from them (else named "not drawn", not counted as a box difference).
4. `--bricks 2.3.9|2.4.2` front-end CSS (Q4 A), from a GET of staging's file with its SHA256 in `SHA256SUMS`.
5. Explain R5 (flip-box face icons) with a minimal repro; fix the renderer or record a named exception.

ACs (**proposed**):
- **AC10 (proposed):** the renderer prints class control CSS as Bricks does: a fixture class used by a Div and a Heading
  with `_typography:mobile_landscape` and an inline-element rule from its parent: the renderer's font size at 600 equals
  the one in a page made of staging's saved print (`staging/css/inline-2.css` shape). Test
  `test/browser/render-class-selectors.test.ts`; RED on main. Named-only: `jojdce` at 767 in the renderer is 236.2×47.
- **AC11 (proposed):** `site:live` on a local fixture server printing a pasted section the way Bricks 2.4.2 prints it
  (no ids, classes on elements) maps every element and reports ≤ 2 px; moving one element 5 px fails. Test
  `test/web/site-live.test.ts`.
- **AC12 (proposed):** site:check `--whole` draws one page and its report equals the per-part runs for a fixture; a
  picture of another host the capture holds is drawn at its size (`nvwzkg` 20×20, named-only). Test
  `test/web/site-check-cli.test.ts` additions.
- **AC13 (proposed):** R5 explained in HANDOFF with its repro; renderer and staging agree on `umnxgl` at 1440, or the
  difference is a named exception site:live skips. Test in `test/browser/render-site-*.test.ts` (whichever repro needs).
- **AC14 (proposed) (live):** after Justin's re-paste, `npm run site:live` against staging reports the staging page's
  boxes within 2 px of the renderer's at every width (renderer ≙ Bricks), apart from the other jobs' widgets.

## Risks and notes

- The saved capture can't be repaired: its tablet code is lost. Justin must capture bdryswi.com again (about 7 min) once
  job A merges; his allow-listed visible Chrome passes its check (web-human-check).
- Job A's wait adds up to 15 s per range only when a sheet is pending; a site that never loads one stylesheet in any
  load (a blocked ad CSS) is compared against the design width's load, so it is never flagged.
- Job B changes every website paste's CSS text (not its look): the existing B-Dry and corpus proofs are its net.
- Live Bricks is 2.4.2 on staging and 2.3.9 on darksalmon; samples in `reference/bricks/` are 2.3.9.
- Not a fault of the paste: staging prints its own footer template (`#brx-footer`) after the paste; the page's 570 px
  taller document at 1440 is that template.
- The FAQ questions' underline Justin saw is not on the front end (`text-decoration-line: none` on every question at
  1440/684/390, `probe2/staging.json`): an editor-only look for the site-faq job to check.

## For the other jobs (forward)

- **site-faq:** the stuck open look is R1: at the four styleless tablet ranges every answer was "shown"
  (`.collapse{display:none}` lost), so `elementor-accordion.ts:57` found several open items (`several`, `open: null`):
  no `expandItem`, no `.brx-open` look, item 0's look stayed on its own classes (`row-jniz` vs `row-xejn`). On the staging
  front end Bricks' `bricksAccordion` runs: a click on item 3 opens it (`brx-open`, `aria-expanded=true`, answer block)
  but item 0 stays orange (`probe2/staging.json` "afterClick"; renderer identical). A re-capture after job A fixes it; a
  hardening (decide the open item at the design width's range when ranges disagree) is the site-faq job's. Underline:
  front end shows none.
- **site-slider:** hero = Elementor `n-carousel` (`elementor-element-1a9321c`, Swiper): `data-settings` autoplay yes,
  autoplay_speed 5000, speed 2500, pause_on_hover yes, pause_on_interaction yes, infinite yes, arrows yes, no pagination,
  1 slide per view at every tier, spacing 10 px; `web.sliders[0]` lists its 3 slides. At 768–991 its slides stack only
  because of R1.
- **site-menu:** the ☰ is Elementor icon widget `a99df50` whose link was `#elementor-action:action=popup:open&settings=`
  base64 `{"id":"27","toggle":false}`; popup 27 (`data-elementor-type="popup"`, entrance and exit `fadeInRight`, 0.75 s)
  holds a services accordion (n-accordion), page links, the phone number, "Get Your Estimate" and a WPForms form
  (`popup27.py`, offline 2026-10-29 HTML). The capture has `popups: []`; no Offcanvas/Toggle sample in `reference/bricks/`.
- **site-reviews:** Trustindex isn't in the capture's `web.embeds` (only the Google map is), and the code route
  (`src/core/site/`) never reads `web.embeds`: it copies the script-made markup (`convert.ts:136` note). Staging has no
  Trustindex plugin (no `wp-content/plugins/…trustindex…` in its page); the paste's pictures come from
  `cdn.trustindex.io`. site:check counts the reviews' script-made avatars as "missing" at every width.
- **site-native-structure:** today's paste is div 624, block 93, image 153, heading 51, text 158, code 16, container 16,
  accordion-nested 1, no section/button/icon (`whole.json`); staging prints class control CSS as `.cls.brxe-<element>`,
  so a native element's own Bricks CSS and the class's controls meet at (0,2,0) (R3).
