# B-Dry Home paste: the "60 Years" circle draws itself, as on bdryswi.com (sixty-years-marker), plan

Mini pipeline (the paste only: no plugin code, no BUILD, no repo commit). Planner 2026-10-29, read from `main` at
`dea6296` (build `2026-10-29.1`, headline-marker merged). Evidence and probes:
`~/.hermes/plans/figma-to-bricks/evidence/sixty-years-marker/` (`planner/`: `probe-band.ts`, `probe-source.ts`,
`probe-geometry.ts` + `geometry.txt`, `live-home.html` = bdryswi.com today, `live-ours.html` + `live-post-155.css` =
our homev2 today). Builder, verifier and auditor folders go beside `planner/`.

## Questions for Justin (the build takes the ⭐ answers unless he says stop)

1. **How does the drawing come in?**
   - A ⭐ **An exact copy of bdryswi.com's drawing:** the same pen stroke, drawn by a tiny script once as the band
     comes into view, over the same time. One extra click after pasting (Bricks → Settings → Custom code →
     **Regenerate code signatures**); until then, and in the Bricks editor, the circle shows whole and still, as today.
   - B The plugin's own headline-marker output, CSS only, no extra click. It differs from bdryswi.com in four visible
     ways: it draws **as you scroll** (not by the clock), **un-draws when you scroll back up** and redraws, sweeps
     **round the middle** (the pen's last pass over the top shows at the start, not the end), and keeps one stroke
     weight on phones (bdryswi.com's thins).
   - C Change the plugin so a marker below the first screen draws once by the clock as it comes in, then splice its
     output (a Full job; the plugin's Q2B, which waits on a working Bricks Interaction sample).

   Why A: Justin's ask is a match with bdryswi.com, and the plugin's output cannot match it without reversing its own
   rulings Q2A/Q3A/Q5A (Root cause, "Why not the plugin's output"). The plugin feature itself is merged and keeps its
   own live check 3br in Figma; this paste doesn't depend on it.

## Justin's answers

(none yet: Justin said "whatever the planner says, go with the recommended", so 1A.)

## Playback

1. On bdryswi.com, under the hero, the navy band says "Over **60 Years** Of Trusted Waterproofing And Foundation
   Repair"; "60 Years" is orange and bolder, and a red hand-drawn circle **draws itself** around those two words when
   the band comes into view.
2. On our B-Dry Home paste (staging `bdry.staging.growithgro.com/homev2/`) the circle is there but **never draws**: it
   sits whole and still from the moment the page loads.
3. Make ours draw like bdryswi.com's (the circle, its look, when it starts, how fast, once or again, and for visitors
   who ask for less motion), and make sure our band has no motion bdryswi.com lacks. Deliver one file with the header
   and the whole Home page, as Justin pastes it now, and land it together with the "Our Services" speed fix
   (services-band-speed) in one next paste version.

## Root cause (evidence)

**bdryswi.com** (capture `bdry-source/home.html`, re-read live today `planner/live-home.html`: same settings):
- Widget `ee3f565` (Elementor Pro Animated Headline, an `h3`) in band `facad50`: `headline_style: highlight`,
  `marker: circle`, `highlighted_text: "60 Years"`, `highlight_animation_duration: 1200`, **no `loop` key** (Elementor
  drops only empty settings from `data-settings`, so loop is off: it plays **once**).
- Handler (`evidence/headline-marker/planner/animated-headline-handler.js`): `activateScrollListener()` →
  `scrollObserver({offset: "0px 0px -100px"})` on the `h3`; when it is 100px inside the window, `initHeadline()` →
  `addHighlight()` (appends `<svg viewBox="0 0 500 150" preserveAspectRatio="none"><path d="M325,18C228.7-8.3,…"/>`
  inside the words' wrapper) + `activateHighlightAnimation()` (adds `e-animated`), then `deactivateScrollListener()`.
- CSS (`evidence/headline-marker/planner/widget-animated-headline.min.css`): the svg `position:absolute; left/top:50%;
  width/height: calc(100% + 20px); transform: translate(-50%,-50%); overflow: visible`; the path `fill:none; opacity:0;
  stroke-dasharray: 0 1500; transition: .3s`; `.e-animated` path `animation: elementor-headline-dash forwards;
  animation-duration: var(--animation-duration, 1.2s)` (timing `ease`), keyframes `0% {opacity:1; stroke-dasharray:0
  1500} to {opacity:1; stroke-dasharray:1500 1500}`; `@media (prefers-reduced-motion: reduce)` → `animation-duration:
  0s`. Words over the stroke (`.elementor-headline-dynamic-text{z-index:1}`, plain text `position:relative;
  z-index:1`). Page CSS: path `stroke:#E73A3A; stroke-width:5px` (viewBox units, so it scales with the box, unevenly).
- **Measured timing** (`planner/probe-geometry.ts` → `geometry.txt`): the path is **1279.1** viewBox units long, so the
  dash (0 → 1500 over 1.2s `ease`) completes the circle at **≈667ms**; the last ~0.53s shows nothing new.
- The band itself fades in (`facad50` `"animation":"fadeIn"`); the heading has a still `translateY 6px`.

**Ours** (the file Justin pasted, `C:\Users\Admin\Downloads\bdry-home-with-header.json`, sha256 `9070659e…7e53`, 271
elements, 24 classes; live as `#brxe-yasfxe` in `post-155.min.css`):
- Section `qtcqzq` "60 Years band" → heading `kkxfhy` with `Over <span class="home-marker">60 Years</span> Of …`; its
  custom CSS draws **the same path as a still background** on `.home-marker::after` (`left/top:-10px;
  width/height:calc(100% + 20px)`, `stroke='%23E73A3A' stroke-width='5'`). Nothing animates it.
- Why: v1 built it still on purpose (memory `bdry-home-copy`: the circle, slider, flip boxes and dots "stay still in the
  first paste; each becomes a plugin feature"); v3 spliced in only the slider, flip boxes and dots (`v3/manifest.json`),
  v4 only the after-FAQ sections, and headline-marker merged after that (`2026-10-29.1`), so the band was never redone.
- **No stray motion:** the band's only motion is `home-fade-in` on the section (class `pyrkhm`, used by this band
  only), which is bdryswi.com's `fadeIn`; `translate: 0 6px` is its still `translateY 6px`. (Ours fades as you scroll
  where Elementor's plays by the clock: every v1 fade does that; `found_else`, not this job.)

**Why not the plugin's output** (option B; it can't match without plugin changes that reverse rulings):
- When: a draw below the first screen is tied to scrolling: `src/core/style/motion.ts:113` (`onLoad: box.y <
  FIRST_SCREEN`, 900; the band is at y≈1075) and `src/core/emit/motion.ts:27` (`entry 10% cover 35%`), so it also
  reverses when scrolled back up (bdryswi.com: once, by the clock). Q2A.
- How: a mask sweep round the centre, `src/core/style/marks.ts:22` (conic gradient), not a dash along the pen. R9.
- Weight: `vector-effect: non-scaling-stroke` keeps one weight (Q5A); bdryswi.com's scales with the box.

## The fix (1A): an exact copy, in the paste only

Two additions to the pasted file, nothing else:

1. **Heading `kkxfhy`'s custom CSS: its current text kept byte for byte as the prefix**, these rules appended (every
   selector under `#brxe-kkxfhy`, Bricks rewrites its own id on paste):
   - `.home-marker { isolation: isolate; }` (the words paint over the stroke, as bdryswi.com's `z-index:1` words);
   - `.home-marker.home-marker-ready::after { display: none; }` (the script's svg replaces the still ring);
   - `.home-marker svg` = bdryswi.com's svg box (`position:absolute; left:50%; top:50%; width:calc(100% + 20px);
     height:calc(100% + 20px); transform:translate(-50%,-50%); overflow:visible`) plus `z-index:-1;
     pointer-events:none`;
   - `.home-marker svg path { fill:none; stroke:#E73A3A; stroke-width:5px; opacity:0; stroke-dasharray:0 1500;
     transition:.3s; }`;
   - `.home-marker.home-marker-drawn svg path { animation: home-marker-dash 1.2s ease forwards; }` with
     `@keyframes home-marker-dash` = Elementor's (`0% {opacity:1; stroke-dasharray:0 1500} 100% {opacity:1;
     stroke-dasharray:1500 1500}`);
   - `@media (prefers-reduced-motion: reduce) { … .home-marker-drawn svg path { animation-duration: 0s; } }`.
   Words, colour, weight and letter-spacing stay as `.home-marker` has them; the heading's `text` doesn't change.
2. **One new Code element** (shape: `reference/bricks/code-element.json` and the plugin's own Code elements,
   `src/core/emit/elements.ts:98-104`: `executeCode: true`, `javascriptCode`; no `signature`/`user_id`/`time`), the
   band section's last child, id a hash of a stable key moved on if taken (as `v3/scripts/build-v3.ts` `newId`). Its
   script, by class only (never an element id): for each `.home-marker`, append the svg with **bdryswi.com's exact
   path** (`aria-hidden="true" focusable="false"`, viewBox `0 0 500 150`, `preserveAspectRatio="none"`), add
   `home-marker-ready`, observe the span's heading with `IntersectionObserver` (`rootMargin: "0px 0px -100px 0px"`);
   on the first intersection add `home-marker-drawn` and disconnect (once). No IntersectionObserver → leave the still
   ring. No `<!--`/`-->` in it.

Without the script (Bricks editor, before code signatures, script off) the page is exactly today's: the still ring.

**Rulings (planner's, under 1A; not yet confirmed):** R1 the still ring stays as the no-script fallback; R2 the
script observes the heading, as Elementor observes its `h3`; R3 a Code element, not a Bricks Interaction (no
proven sample for an enter-view class); R4 words over the stroke as bdryswi.com (today's still ring paints over
them); R5 the band's scroll-linked fade stays.

## One next paste version with services-band-speed (v5)

- **Base:** the file Justin pasted, copied read-only to `evidence/bdry-paste/v5/base/bdry-home-with-header.json`
  (check sha256 `9070659ed92e6bb85aa794735d72e66fdc779cf62f8c69348021606284907e53` first; stop if it differs).
- **One step file per job** in `evidence/bdry-paste/v5/steps/`: this one `sixty-years-marker.ts` exporting `targets`
  (element ids and class ids it may change or add: `kkxfhy`, `qtcqzq`'s `children`, the new Code element; no class)
  and `apply(paste)`, which first checks each target equals the base and throws if not.
- **`evidence/bdry-paste/v5/scripts/build-v5.ts`** (whoever gets there first creates it; the other job reuses it
  unchanged): applies every step file present in name order, refuses two steps declaring one target, writes
  `v5/bdry-home-with-header-v5.json` and `v5/manifest.json` (base sha, each step's sha, output sha, counts). Today's
  services band (`zyjlcu`, classes `home-fade-in-up`/`home-fade-in-left`) shares nothing with this band.
- **Tests** in `v5/test/`: each job's AC6 reads every present step's `targets`, so the second job to land reruns
  both jobs' tests on the combined file. Final copy to `C:\Users\Admin\Downloads\bdry-home-with-header-v5.json` (new
  name; never overwrite the old file).

## Acceptance criteria (all proposed; Justin gave none)

Renders: v4's `test/render-lib.ts` (repo Chrome over CDP, `test/browser/chrome.ts`). If `renderPage` doesn't run a
Code element's `javascriptCode`, the test adds that exact script to the served page. bdryswi.com is read live in the
same Chrome (read only, `?f2b=<random>`). Its Roboto 600 doesn't load (memory), so compare each page's circle to its
own words, never absolute widths. Check timing by seeking each page's own path animation (`getAnimations()`,
`currentTime`), not by timers.

- AC1 (proposed): Once the script runs, the circle draws round "60 Years" as bdryswi.com's: hidden until the heading's top is 100px inside the window (±1px of scroll), then the same path `d`, colour `#E73A3A`, 5px stroke and box (words +10px each side) drawing in the same order, with stroke-dasharray at 0/150/300/450/600/667/900/1200ms within 1 unit of bdryswi.com's (whole by ≈667ms). Test: `v5/test/sixty-years-marker.render.test.ts › draws like bdryswi.com: same trigger, path, order and timing at 1440x900`
- AC2 (proposed): It draws once: scrolling up past the band and back down never hides or redraws it, and it never loops. Test: `v5/test/sixty-years-marker.render.test.ts › draws once and stays drawn after scrolling away and back`
- AC3 (proposed): With reduced motion it stays hidden until the same trigger, then shows whole at once and still (as bdryswi.com); with no script (editor, before code signatures) the band's pixels equal the base file's (the still ring). Test: `v5/test/sixty-years-marker.render.test.ts › reduced motion shows it whole at once; no script keeps today's still ring`
- AC4 (proposed): It fits every screen: at 1440, 1024, 767, 390 and 320 the svg box is the words' box +10px each side, "60 Years" stays on one line, the words paint over the stroke, the page never scrolls sideways, and the stroke crosses other words' letter boxes no more than bdryswi.com's does at that width. Test: `v5/test/sixty-years-marker.render.test.ts › the circle fits 60 Years at 1440, 1024, 767, 390 and 320`
- AC5 (proposed): The band's layout and other motion don't change: at those widths the band's height and the heading's lines and position equal the base file's within 0.5px, and the section's fade is the base's. Test: `v5/test/sixty-years-marker.render.test.ts › the band's layout and fade are unchanged`
- AC6 (proposed): Nothing else in the paste changes: deep-equal and byte-equal to the base except kkxfhy's `_cssCustom` (base text as its exact prefix), qtcqzq's `children` (one id added at the end), the new Code element, and the targets other present steps declare. Test: `v5/test/sixty-years-marker.paste.test.ts › nothing else in the paste changes`
- AC7 (proposed): The paste stays valid and clash-free: JSON parses; `payloadProblems` (`src/core/emit/payload.ts`) gives nothing new against the base; ids unique, parents and children agree; no new global class; every kkxfhy rule sits under `#brxe-kkxfhy`; the script names no element id and holds no `<!--`/`-->`; the Code element has the sample's keys without signature fields. Test: `v5/test/sixty-years-marker.paste.test.ts › the paste is valid and clash-free`
- AC8 (live) (proposed): After pasting v5 into homev2 and running Regenerate code signatures, the circle draws itself beside bdryswi.com the same way, once; with Windows' Animation effects off it appears whole; the editor shows the still ring. Test: `live: Justin pastes v5 and watches the band beside bdryswi.com`

Old file (base) on AC1–AC3: fails (still ring, no draw); AC4–AC7 are checks that hold on both.

## Tasks

1. **Base and step skeleton:** copy the base (sha check), write `v5/steps/sixty-years-marker.ts` (`targets`, `apply`)
   and `v5/scripts/build-v5.ts` if missing. Write AC6/AC7's tests first; they fail until the step exists.
2. **Render tests first (AC1–AC5)** against bdryswi.com and the built file; see AC1–AC3 fail on the base.
3. **The step:** the CSS rules and the Code element above; build v5; all of AC1–AC7 pass. One screenshot per AC
   (AC1: frames at 0/300/667ms beside bdryswi.com's; AC4: the four widths + 320; AC6/AC7: the terminal run).
4. **Combined:** if `v5/steps/services-band-speed.ts` exists, rebuild and rerun both jobs' tests on the combined file.
5. **Docs & records:** `v5/manifest.json` (base sha, step shas, output sha, counts, Chrome/Node versions, which steps
   are in); copy to Downloads as `bdry-home-with-header-v5.json`; the report hands the main session the memory line
   for `bdry-home-copy` ("v5: v4 + header (as pasted) + the 60 Years circle drawing as bdryswi.com (script; Regenerate
   code signatures after pasting) [+ services-band-speed], live check AC8 owed"). No plugin change, so no HANDOFF,
   BUILD or repo commit.

## Touches

`~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/` (base copy, `steps/sixty-years-marker.ts`,
`scripts/build-v5.ts` shared, `test/sixty-years-marker.{paste,render}.test.ts`, the v5 file, `manifest.json`, shots),
`C:\Users\Admin\Downloads\bdry-home-with-header-v5.json`. Read only: the repo (renderer, payload checks, Code
sample), bdryswi.com, homev2.

## Not in this job (found_else)

- The plugin's marker can't reproduce a timed, once-only draw below the first screen (scroll-linked, reverses on scroll
  up; `style/motion.ts:113`, `emit/motion.ts:27`), sweeps round the middle (`style/marks.ts:22`) and keeps one weight:
  a plugin follow-up (Q2B) needing a Bricks Interaction sample. Medium.
- Every v1 entrance fade (`home-fade-in*`) is scroll-linked where Elementor's plays by the clock on entry. Low.
- Today's still ring paints over the words' edges (no z-index); fixed here only when the script runs. Low.
