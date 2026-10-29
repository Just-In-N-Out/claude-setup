# B-Dry Home paste: the "60 Years" band moves as on bdryswi.com (sixty-years-marker), plan

Mini pipeline (the paste only: no plugin code, no BUILD, no repo commit). Planner 2026-10-29, read from `main` at
`dea6296` (build `2026-10-29.1`, headline-marker merged). Evidence and probes:
`~/.hermes/plans/figma-to-bricks/evidence/sixty-years-marker/` (`planner/`: `probe-band.ts`, `probe-source.ts`,
`probe-geometry.ts` + `geometry.txt`, `live-home.html` = bdryswi.com today, `elementor-frontend.min.css` from
bdryswi.com, `live-ours.html` + `live-post-155.css` = our homev2 today). Builder, verifier and auditor folders go
beside `planner/`. Sister job: `services-band-speed` (`../services-band-speed.md`), whose Bricks Interaction approach
and `home-enter-*` class naming this plan reuses.

## Questions for Justin (the build takes the ⭐ answers unless he says stop)

1. **How does the circle's drawing come in?**
   - A ⭐ **An exact copy of bdryswi.com's drawing:** the same pen stroke, drawn by a tiny script once as the heading
     comes into view, over the same time. One extra click after pasting (Bricks → Settings → Custom code →
     **Regenerate code signatures**); until then, and in the Bricks editor, the circle shows whole and still, as today.
   - B The plugin's own headline-marker output, CSS only, no extra click. It differs from bdryswi.com in four visible
     ways: it draws **as you scroll** (not by the clock), **un-draws when you scroll back up** and redraws, sweeps
     **round the middle** (the pen's last pass over the top shows at the start, not the end), and keeps one stroke
     weight on phones (bdryswi.com's thins).
   - C Change the plugin so a marker below the first screen draws once by the clock as it comes in, then splice its
     output (a Full job; the plugin's Q2B, which waits on a working Bricks Interaction sample).

   Why A: Justin's ask is a match with bdryswi.com, and the plugin's output can't match it without reversing its own
   rulings Q2A/Q3A/Q5A (see "Why not the plugin's output"). A Bricks Interaction can start the draw, but not put the
   pen's svg in the words, so the script stays. The plugin feature keeps its own live check 3br in Figma.
2. **The band's own fade-in** (folded in at the coordinator's request; it is the same scroll-linked cause
   services-band-speed fixes):
   - A ⭐ bdryswi.com's: a 1.25 s fade, once, by the clock, when the band enters the window, through Bricks' own
     Interaction (Enter viewport → Start animation `fadeIn`, run once), class `home-enter`, as services-band-speed.
   - B Keep today's fade that follows the scroll.

## Justin's answers

(none yet: Justin said "whatever the planner says, go with the recommended", so 1A 2A.)

## Playback

1. On bdryswi.com, under the hero, the navy band says "Over **60 Years** Of Trusted Waterproofing And Foundation
   Repair"; "60 Years" is orange and bolder. The band fades in once as it comes into view, and a red hand-drawn circle
   **draws itself** around "60 Years".
2. On our B-Dry Home paste (staging `bdry.staging.growithgro.com/homev2/`) the circle is there but **never draws**: it
   sits whole and still from the start. The band's fade also follows the scroll (fast, and backwards when scrolling up)
   instead of playing once by the clock.
3. Make both match bdryswi.com (the circle's look, when it starts, how fast, once or again, and for visitors who ask
   for less motion), add no motion bdryswi.com lacks, and hand the integrator one edit module so this lands in the
   next paste version together with services-band-speed.

## Root cause (evidence)

**bdryswi.com** (capture `bdry-source/home.html`, re-read live today `planner/live-home.html`: same settings):
- Band `facad50`: `data-settings {"background_background":"classic","animation":"fadeIn"}`, no duration or delay key;
  Elementor's `frontend.min.css` (`planner/elementor-frontend.min.css`): `.animated{animation-duration:1.25s}` (timing
  `ease`), `@media (prefers-reduced-motion:reduce){.animated{animation:none!important}}`. It is `elementor-invisible`
  until it enters the window, then plays once.
- Widget `ee3f565` (Elementor Pro Animated Headline, an `h3`): `headline_style: highlight`, `marker: circle`,
  `highlighted_text: "60 Years"`, `highlight_animation_duration: 1200`, **no `loop` key** (Elementor drops only empty
  settings from `data-settings`, so loop is off: it plays **once**).
- Handler (`evidence/headline-marker/planner/animated-headline-handler.js`): `activateScrollListener()` →
  `scrollObserver({offset: "0px 0px -100px"})` on the `h3`; when it is 100px inside the window, `initHeadline()` →
  `addHighlight()` (appends `<svg viewBox="0 0 500 150" preserveAspectRatio="none"><path d="M325,18C228.7-8.3,…"/>`
  inside the words' wrapper) + `activateHighlightAnimation()` (adds `e-animated`), then `deactivateScrollListener()`.
- CSS (`evidence/headline-marker/planner/widget-animated-headline.min.css`): the svg `position:absolute; left/top:50%;
  width/height: calc(100% + 20px); transform: translate(-50%,-50%); overflow: visible`; the path `fill:none; opacity:0;
  stroke-dasharray: 0 1500; transition: .3s`; `.e-animated` path `animation: elementor-headline-dash forwards;
  animation-duration: var(--animation-duration, 1.2s)` (timing `ease`), keyframes `0% {opacity:1; stroke-dasharray:0
  1500} to {opacity:1; stroke-dasharray:1500 1500}`; reduced motion → `animation-duration: 0s`. Words over the stroke
  (`.elementor-headline-dynamic-text{z-index:1}`). Page CSS: path `stroke:#E73A3A; stroke-width:5px` (viewBox units,
  so it scales with the box, unevenly).
- **Measured timing** (`planner/probe-geometry.ts` → `geometry.txt`): the path is **1279.1** viewBox units long, so the
  dash (0 → 1500 over 1.2s `ease`) completes the circle at **≈667ms**; the last ~0.53s shows nothing new.

**Ours.** The band is identical in v4 (`evidence/bdry-paste/v4/home-paste-v4.json`, sha256 `0a9c9d07…3324`) and in
the file Justin pasted (`C:\Users\Admin\Downloads\bdry-home-with-header.json`, sha256 `9070659e…7e53`): checked
element by element. Live as `#brxe-hvqbtl`/`#brxe-yasfxe` in `post-155.min.css`.
- Section `qtcqzq` "60 Years band" has global class `home-fade-in` (class id `pyrkhm`, used by this section only):
  `animation: home-fade-in-opacity 1.25s ease 0s both`, then `@supports (animation-timeline: view())` switches to
  `auto linear both; animation-timeline: view(); animation-range: entry 10% cover 35%`. So in Chrome/Edge it follows
  the scroll (linear, about a third of a window of scrolling, backwards on scroll up); elsewhere the 1.25 s clock runs
  from page load, long before the band is reached. (The coordinator's fact is right; `pyrkhm` is the class id.)
- Heading `kkxfhy`: `Over <span class="home-marker">60 Years</span> Of …`; its custom CSS draws **the same path as a
  still background** on `.home-marker::after` (`left/top:-10px; width/height:calc(100% + 20px)`, `stroke='%23E73A3A'
  stroke-width='5'`). Nothing animates it.
- Why: v1 built the circle still on purpose (memory `bdry-home-copy`: it "stays still in the first paste; each becomes
  a plugin feature") and built every entrance as a scroll-linked class; v3 spliced only the slider, flip boxes and dots,
  v4 only the after-FAQ sections, and headline-marker merged after that (`2026-10-29.1`).
- **No other motion:** the heading's `translate: 0 6px` is bdryswi.com's still `translateY 6px`.

**Why not the plugin's output** (option 1B; it can't match without plugin changes that reverse rulings):
- When: a draw below the first screen is tied to scrolling: `src/core/style/motion.ts:113` (`onLoad: box.y <
  FIRST_SCREEN`, 900; the band is at y≈1075) and `src/core/emit/motion.ts:27` (`entry 10% cover 35%`), so it also
  reverses when scrolled back up (bdryswi.com: once, by the clock). Q2A.
- How: a mask sweep round the centre, `src/core/style/marks.ts:22` (conic gradient), not a dash along the pen. R9.
- Weight: `vector-effect: non-scaling-stroke` keeps one weight (Q5A); bdryswi.com's scales with the box.

## The fix: one edit module, v4 Home in, edited Home out

`~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/edits/sixty-years-marker.ts`: a pure function from the v4
Home JSON to the edited JSON (no file or network access), touching only these. It first checks each element and class
it changes equals v4's and throws if not.

1. **Band `qtcqzq`:** `_cssGlobalClasses` `["pyrkhm"]` → `[<home-enter id>]`; `children` gains the Code element's id
   at the end. Nothing else on it changes.
2. **New global class `home-enter`** (services-band-speed's scheme: id 6 lowercase letters derived from the name,
   unique against every id in v4 and `header-v1/header-paste.json`; its interaction id 6 letters too):
   `_interactions: [{id, trigger: "enterView", action: "startAnimation", animationType: "fadeIn",
   animationDuration: "1.25s", runOnce: true}]` (no delay), `_cssCustom` only `@media (prefers-reduced-motion:
   reduce) { .home-enter { animation: none !important; } }`. Same keys and shape as services-band-speed's three
   `home-enter-*` classes, so the integrator sees one pattern.
3. **`globalClasses`:** `home-fade-in` (`pyrkhm`) leaves the payload (no longer used; it stays on the site untouched)
   and `home-enter` takes its place (index 2). Every other class is untouched.
4. **Heading `kkxfhy`'s `_cssCustom`: its current text kept byte for byte as the prefix**, these rules appended (every
   selector under `#brxe-kkxfhy`, which Bricks rewrites on paste):
   - `.home-marker { isolation: isolate; }` (the words paint over the stroke, as bdryswi.com's `z-index:1` words);
   - `.home-marker.home-marker-ready::after { display: none; }` (the script's svg replaces the still ring);
   - `.home-marker svg` = bdryswi.com's box (`position:absolute; left:50%; top:50%; width:calc(100% + 20px);
     height:calc(100% + 20px); transform:translate(-50%,-50%); overflow:visible`) plus `z-index:-1;
     pointer-events:none`;
   - `.home-marker svg path { fill:none; stroke:#E73A3A; stroke-width:5px; opacity:0; stroke-dasharray:0 1500;
     transition:.3s; }`;
   - `.home-marker.home-marker-drawn svg path { animation: home-marker-dash 1.2s ease forwards; }` with
     `@keyframes home-marker-dash` = Elementor's (`0% {opacity:1; stroke-dasharray:0 1500} 100% {opacity:1;
     stroke-dasharray:1500 1500}`);
   - `@media (prefers-reduced-motion: reduce) { … .home-marker-drawn svg path { animation-duration: 0s; } }`.
   The heading's `text` and its words' look (`.home-marker`: colour, 600, -0.4px) don't change.
5. **One new Code element** (shape: `reference/bricks/code-element.json` and the plugin's own Code elements,
   `src/core/emit/elements.ts:98-104`: `executeCode: true`, `javascriptCode`; no `signature`/`user_id`/`time`), the
   band's last child, id derived as the class ids are. Its script, by class only (never an element id): for each
   `.home-marker`, append the svg with **bdryswi.com's exact path** (`aria-hidden="true" focusable="false"`, viewBox
   `0 0 500 150`, `preserveAspectRatio="none"`), add `home-marker-ready`, observe the span's heading with
   `IntersectionObserver` (`rootMargin: "0px 0px -100px 0px"`); on the first intersection add `home-marker-drawn` and
   disconnect (once). No IntersectionObserver → leave the still ring. No `<!--`/`-->` in it.

Without the script (editor, before code signatures, script off) the circle is today's still ring. The band's fade is
independent of the circle, as on bdryswi.com (the band starts on entry, the circle 100px later).

**Job-only preview** in `v5/sixty-years-marker/`: `home-preview.json` (the edit applied to v4) and
`with-header-preview.json` (header-v1 + it, joined by services-band-speed's proven recipe,
`evidence/services-band-speed/planner/combined-recipe.mjs`), plus the tests, shots and `manifest.json`. **The
integrator** (a later agent) writes `build-v5.ts` and joins every job's edit into the one file Justin pastes; this job
never writes `build-v5.ts` or the final file.

**Rulings (planner's, under 1A 2A; not yet confirmed):** R1 the still ring stays as the no-script fallback; R2 the
script observes the heading, as Elementor observes its `h3`; R3 the circle's start is a script, not a Bricks
Interaction, because the svg needs the script anyway; R4 words over the stroke as bdryswi.com (today's still ring
paints over them); R5 the band fade by Bricks' Interaction with services-band-speed's class pattern; R6 `home-fade-in`
leaves the payload, not the site.

## Acceptance criteria (all proposed; Justin gave none)

Tests in `v5/sixty-years-marker/test/`, each taking the paste path as an argument (the verifier runs them on v4 and on
`home-preview.json`). Renders: v4's `test/render-lib.ts` (repo Chrome over CDP, `CHROME_PATH` per the desktop memory
note). If `renderPage` doesn't run a Code element's `javascriptCode`, the test adds that exact script to the served
page. The band fade runs in **services-band-speed's Bricks runtime harness** (`v5/test/bricks-harness.ts`: the real
`bricks.min.js` and `animate.min.css`, sha-checked; if it isn't there yet, build it to that plan's spec, never an
imitation of Bricks). bdryswi.com is read live in the same Chrome (read only, `?f2b=<random>`). Its Roboto 600 doesn't
load (memory), so compare each page's circle to its own words, never absolute widths. Timing: seek each page's own
animations (`getAnimations()`, `currentTime`), not timers.

- AC1 (proposed): Once the script runs, the circle draws round "60 Years" as bdryswi.com's: hidden until the heading's top is 100px inside the window (±1px of scroll), then the same path `d`, colour `#E73A3A`, 5px stroke and box (words +10px each side) drawing in the same order, with stroke-dasharray at 0/150/300/450/600/667/900/1200ms within 1 unit of bdryswi.com's (whole by ≈667ms). Test: `v5/sixty-years-marker/test/circle.render.test.ts › draws like bdryswi.com: same trigger, path, order and timing at 1440x900`
- AC2 (proposed): The circle draws once: scrolling up past the band and back down never hides or redraws it, and it never loops. Test: `v5/sixty-years-marker/test/circle.render.test.ts › draws once and stays drawn after scrolling away and back`
- AC3 (proposed): With reduced motion the circle stays hidden until the same trigger, then shows whole at once and still (as bdryswi.com); with no script (editor, before code signatures) the band's pixels equal v4's (the still ring). Test: `v5/sixty-years-marker/test/circle.render.test.ts › reduced motion shows it whole at once; no script keeps the still ring`
- AC4 (proposed): The circle fits every screen: at 1440, 1024, 767, 390 and 320 the svg box is the words' box +10px each side, "60 Years" stays on one line, the words paint over the stroke, the page never scrolls sideways, and the stroke crosses other words' letter boxes no more than bdryswi.com's does at that width. Test: `v5/sixty-years-marker/test/circle.render.test.ts › the circle fits 60 Years at 1440, 1024, 767, 390 and 320`
- AC5 (proposed): The band fades in as bdryswi.com's `facad50`: in the Bricks harness at 1440 and 390 it stays hidden until it enters the window, then plays `fadeIn` once over 1250 ms `ease` with no delay, never replays or reverses on scrolling away and back, and under reduced motion shows at once with no animation; equal to bdryswi.com measured in Chrome. Test: `v5/sixty-years-marker/test/band-fade.test.ts › the 60 Years band fades in once like bdryswi.com's facad50`
- AC6 (proposed): The band's layout doesn't change: once its fade ends, at 1440, 1024, 767 and 390 the band's height and the heading's lines and position equal v4's within 0.5px. Test: `v5/sixty-years-marker/test/circle.render.test.ts › the band's layout is unchanged`
- AC7 (proposed): The edit touches only its own parts: the module is pure (same input → byte-identical output, input not mutated), and its output deep-equals v4 except `qtcqzq`'s `_cssGlobalClasses` and `children`, `kkxfhy`'s `_cssCustom` (v4's text as its exact prefix), the new Code element, and `globalClasses` with `pyrkhm` replaced by `home-enter` in place. Test: `v5/sixty-years-marker/test/edit.test.ts › the edit changes only the 60 Years band's own parts`
- AC8 (proposed): The paste stays valid and clash-free: `payloadProblems` (`src/core/emit/payload.ts`) gives nothing new against v4; ids unique against v4 and header-v1, parents and children agree; `home-enter` and the Code element ids are derived and free; no class name shared with the site's (`bdry-home-copy` list) or the header's; the `home-enter` class has services-band-speed's interaction keys; every kkxfhy rule sits under `#brxe-kkxfhy`; the script names no element id and holds no `<!--`/`-->`; the Code element has the sample's keys without signature fields; the with-header preview parses with header-v1's classes then Home's. Test: `v5/sixty-years-marker/test/edit.test.ts › the edited paste is valid and clash-free`
- AC9 (live) (proposed): After the integrator's v5 is pasted into homev2 and Regenerate code signatures is run, Justin watches the band beside bdryswi.com: it fades in once as it comes in and the circle draws itself the same way, once; with Windows' Animation effects off both appear at once; the editor shows the still ring; Bricks kept the `home-enter` interaction. Test: `live: Justin pastes v5 and watches the 60 Years band beside bdryswi.com`

On v4, AC1–AC3 and AC5 fail (still ring; scroll-linked fade); AC4, AC6–AC8 are checks that hold on both.

## Tasks

1. **Tests first:** `edit.test.ts` (AC7, AC8) against a stub module; `circle.render.test.ts` (AC1–AC4, AC6) and
   `band-fade.test.ts` (AC5) against bdryswi.com and v4; see AC1–AC3 and AC5 fail on v4.
2. **The edit module** (`v5/edits/sixty-years-marker.ts`) as "The fix" says; write the two previews; all ACs pass.
   One screenshot per AC (AC1: frames at 0/300/667ms beside bdryswi.com's; AC4: the five widths; AC5: frames of the
   band at 0/600/1250ms; AC7/AC8: the terminal run).
3. **Docs & records:** `v5/sixty-years-marker/manifest.json` (v4 and header-v1 shas, the module's sha, both
   previews' shas, counts, Chrome/Node versions, test results); the report gives the integrator the module path and its
   declared targets (`qtcqzq`, `kkxfhy`, the new Code element, class `pyrkhm` → `home-enter`) and gives the main
   session the memory line for `bdry-home-copy` ("v5 edit sixty-years-marker: the 60 Years band fades in once and its
   circle draws as bdryswi.com (script: Regenerate code signatures after pasting); live check AC9 owed"). No plugin
   change, so no HANDOFF, BUILD or repo commit.

## Touches

`~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/edits/sixty-years-marker.ts` and
`~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/sixty-years-marker/` (tests, previews, shots, manifest);
`v5/test/bricks-harness.ts` only if services-band-speed hasn't made it (to its spec). Read only: v4, header-v1, the
repo (renderer, payload checks, Code sample), bdryswi.com, homev2. Never: `build-v5.ts`, the final paste, Downloads.

## Not in this job (found_else)

- The plugin's marker can't reproduce a timed, once-only draw below the first screen (scroll-linked, reverses on scroll
  up; `style/motion.ts:113`, `emit/motion.ts:27`), sweeps round the middle (`style/marks.ts:22`) and keeps one weight:
  a plugin follow-up (Q2B) needing a Bricks Interaction sample. Medium.
- None else for the integrator: v4's only scroll-linked entrance classes are `home-fade-in` (this band only) and
  `home-fade-in-up`/`-left` (services-band-speed's four elements only), so with both jobs in none is left.
