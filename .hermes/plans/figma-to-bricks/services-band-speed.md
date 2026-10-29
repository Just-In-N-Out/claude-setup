# B-Dry Home: "Our Services" band moves at bdryswi.com's pace (Mini, paste only)

Planner: Opus 5.5 xhigh, 2026-10-29. Brief: `~/.hermes/plans/figma-to-bricks/briefs/services-band-speed-planner.md`.
Planner probes and saved copies: `~/.hermes/plans/figma-to-bricks/evidence/services-band-speed/planner/`.
Evidence for this job: `~/.hermes/plans/figma-to-bricks/evidence/services-band-speed/`.
**No plugin change:** the builder works only in `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/` (new),
reading a repo copy for the payload checks, as v4 did. Nothing is committed to the repo and `BUILD` is not bumped.

## Questions (⭐ = taken under the auto-go)

1. **Which animations does this job change?**
   - A ⭐ The "Our Services" band only: its desktop/phone copy and its tablet copy, with their headings. The 60 Years
     band has the same cause and becomes its own job (found_else 1).
   - B The Services band and the 60 Years band together.
2. **How should the band's entrance play?**
   - A ⭐ As on bdryswi.com: by the clock, once, when the band first comes into the window, through Bricks' own
     Interaction "Enter viewport → Start animation". The CTA fade-in already uses a Bricks Interaction on this site,
     and Bricks 2.3.9's code on the staging site runs `enterView` with `runOnce`.
   - B Keep CSS only and stretch the scroll range. It still follows the scroll, so it can't be 1.25 s or 2 s.
   - C A small script in a Code element. Justin would have to run Regenerate code signatures after every paste.
3. **bdryswi.com's band background slowly shimmers (8 s). Ours is a still gradient. Should ours shimmer too?**
   - A ⭐ Yes, through its own class `home-shimmer`: a copy of the header's `header-shimmer`, which already matches
     bdryswi.com. It stands still under reduced motion, which bdryswi.com doesn't do.
   - B Yes, by putting the header's `header-shimmer` class on the band. That's one class, but the Home part then
     depends on the header part.
   - C No: only the entrance changes.
4. **The tablet heading:** bdryswi.com plays it at Elementor's normal speed (1.25 s), and the desktop/phone heading at
   "slow" (2 s). Ours share one class.
   - A ⭐ Match both: the tablet heading gets its own 1.25 s class.
   - B Both headings at 2 s.
5. **Class names:**
   - A ⭐ New names (`home-enter-up`, `home-enter-left`, `home-enter-left-slow`, `home-shimmer`). Bricks then asks no
     "Import classes" question, and the classes already on the site stay as they are.
   - B Keep `home-fade-in-up`/`home-fade-in-left` with new settings. Bricks then asks "Import classes" (CONFLICT), and
     Justin must click **Accept**. **Reject** silently keeps the fast version (`reference/bricks/README.md:83-89`).

## Playback

On the page Justin pasted (staging `/homev2/`, page 155; `/homev3/` is a 404), when he scrolls down to the blue
"Our Services" bar:
1. The bar rises into place.
2. The white "Our Services" heading slides in from the left.

Both moves happen much faster than on bdryswi.com. On bdryswi.com, the bar rises over 1.25 s and the heading slides
over 2 s, once, when the bar comes into view, and its blue background keeps shimmering slowly (8 s a round). Ours
should play at the same pace and shimmer the same way, with reduced motion still respected. Justin pastes one file,
with the header and the whole Home page as now.

## Root cause (evidence)

**What Justin pasted:** `C:\Users\Admin\Downloads\bdry-home-with-header.json`, sha256 `9070659e…7e53`.
- It is exactly `header-v1/header-paste.json` followed by `v4/home-paste-v4.json`: `content` concatenated, and the
  header's classes followed by Home's (no shared names). The file is compact `JSON.stringify` with the keys `content,
  source, sourceUrl, version, globalClasses` (`planner/combined-recipe.mjs`: all true).
- The live homev2 page carries the same CSS (`planner/staging-homev2.html`: the band's section is
  `class="brxe-section home-fade-in-up"`, its h3 is `home-fade-in-left`).

| | bdryswi.com (live 2026-10-29 = capture 10-26) | Ours (pasted file) |
|---|---|---|
| Band, desktop/phone | `84acbe9`, Elementor `fadeInUp`, normal speed = **1.25 s** | `zyjlcu`, class `home-fade-in-up` (`uvxiyg`) |
| Heading on it | `df1e234` `fadeInLeft` + `animated-slow` = **2 s** | `vpoodx`, class `home-fade-in-left` (`omkykf`) |
| Band, tablet | `b1abc0f` `fadeInUp` **1.25 s**, no `bg` | `cisqjr`, `home-fade-in-up` |
| Heading on it | `f0c765d` `fadeInLeft` normal = **1.25 s** | `mfgteo`, `home-fade-in-left` (2 s fallback) |
| Timing | default `ease`, no delay, 1 play, normal direction (`frontend.min.css`: `.animated{animation-duration:1.25s}`, `.animated.animated-slow{animation-duration:2s}`) | **Chrome/Edge:** `animation: … auto linear both; animation-timeline: view(); animation-range: entry 10% cover 35%` |
| When it plays | once, by the clock, when the element first enters the window (`elementor-invisible` until then) | **Chrome/Edge:** follows the scroll position, finishing after about a third of a window of scrolling (≈340 px at 900 px tall, ≈400 px at 1080), so a few wheel notches (≈0.5 s), linear, and backwards when scrolling up. **Other browsers:** the 1.25 s/2 s clock starts at page load, long before the band is reached. |
| Keyframes | `fadeInUp` from `opacity:0; translate3d(0,100%,0)`; `fadeInLeft` from `translate3d(-100%,0,0)` (animate.css) | the same moves (`translate: 0 100%` / `-100% 0`) |
| Background | class `bg`: `.bg:after` `shimmerGradient` **8 s linear infinite**, `background-size: 200% 200%`, keyframes `100% 100% → 0% 0% → 100% 100%`, the -120deg gradient (no reduced-motion rule) | **still:** the same gradient frozen in `zyjlcu._cssCustom`, no `::after`, no animation |
| Reduced motion | `.animated{animation:none!important}`; the shimmer keeps moving | `animation: none !important` (kept) |

**Sources:**
- bdryswi.com: `planner/bdryswi-home-live.html` and `live-anim-lib.mjs`, fetched from bdryswi.com's
  `elementor/assets/css/frontend.min.css` and `lib/animations/styles/fadeIn{Up,Left}.min.css`.
- The source's animations, element by element: `planner/source-anims.mjs`.
- Ours: `planner/classes.mjs` on the pasted file.

**Where it came from:** the hand-built v1 paste already had these classes (`home-paste-v1.json`: `home-fade-in-up`
and 3 `animation-range` lines).
- v1 wrote Elementor's clock entrances in the plugin's Figma-Motion form: `src/core/emit/motion.ts:26-29`, scroll-linked,
  `entry 10% cover 35%`, for entrances below the first screen.
- The plugin never converted this band: it comes from the Elementor capture, not from Figma. So the fix goes **in the
  paste only**.

**The same animation elsewhere on our page:**
- **Header shimmer:** `header-shimmer` (`hivnhp`, only on `hqtggc`). Its gradient, `200% 200%`, keyframes and
  **8 s linear infinite** equal bdryswi.com's header `.bg` (`9d2ab99`). It already matches, so it stays unchanged.
- **60 Years band** (`qtcqzq`, class `home-fade-in`): the same scroll-linked cause. bdryswi.com's `facad50` is `fadeIn`
  1.25 s on entry. Out of scope (Q1A); see found_else.

**Bricks facts the fix relies on** (read in the staging site's public Bricks 2.3.9 files, no login; copies in
`planner/`):
- **`bricks.min.js`** (sha256 `628ecaeb…adf02`):
  - `case"enterView"` → `new BricksIntersect({… once: t.runOnce, rootMargin, threshold})`.
  - `startAnimation`:
    - sets `style.animationDuration` from `animationDuration`;
    - adds `brx-animated` and `data-animation`;
    - Bricks' animation function adds `brx-animate-<type>`;
    - the attribute `data-interaction-hidden-on-load` is removed.
- **`animate.min.css`** (sha256 `8c647b66…cbe`):
  - `.brx-animated{animation-duration:1s;animation-fill-mode:both}`; no timing function is set, so the default `ease`
    applies.
  - `[data-interaction-hidden-on-load]{opacity:0}`.
  - `fadeInLeft` keyframes are the same as Elementor's.
  - Under `prefers-reduced-motion: reduce`, `.brx-animated{animation-duration:1ms!important}`.
- **How a class's interactions reach the page:** homev2 prints them on the element, with `data-interaction-hidden-on-load="1"`:
  the CTA `cta-motion`, in `staging-homev2.html`, and `reference/bricks/README.md:366-371`.
- **Not yet proven:** `enterView` and `runOnce` are not in a captured sample (`cta-button-interactions.json` has
  `contentLoaded`). AC9 (live) checks the round trip.

## The fix (paste v5, built from v4 + header-v1; v3/v4/header never edited)

`v5/scripts/build-v5.ts` reads `v4/home-paste-v4.json` and `header-v1/header-paste.json`. It changes only the
following, and writes `v5/home-paste-v5.json` and the combined `v5/bdry-home-with-header-v5.json`, built by the proven
recipe above.

**Four new global classes.** Ids are 6 lowercase letters, stable (derived from the name), and unique against every id
in both pastes. Interaction ids are 6 letters too. `trigger: "enterView"` and `action: "startAnimation"` apply to all
three entrance classes, with no `animationDelay`:

| Class | `animationType` | `animationDuration` | Also |
|---|---|---|---|
| `home-enter-up` | `fadeInUp` | `1.25s` | `runOnce: true` |
| `home-enter-left-slow` | `fadeInLeft` | `2s` | `runOnce: true` |
| `home-enter-left` | `fadeInLeft` | `1.25s` | `runOnce: true` |
| `home-shimmer` | – | – | `_cssCustom` below |

- **The three entrance classes:** each `_interactions` holds one entry: `{id, trigger, action, animationType,
  animationDuration, runOnce}`. Each also gets a `_cssCustom` with only `@media (prefers-reduced-motion: reduce) {
  .<name> { animation: none !important; } }`, as the plugin does for `cta-motion` (`src/core/emit/settings.ts:210`).
- **`home-shimmer`:** `_cssCustom` is the header's `header-shimmer` CSS with both names (class and `@keyframes`)
  changed to `home-shimmer`. That means `position: relative; z-index: 1` on the band and a `::after` with `inset: 0;
  z-index: -1; pointer-events: none`, plus:
  - the same -120deg gradient;
  - `background-size: 200% 200%`;
  - `animation: home-shimmer 8s linear infinite`;
  - keyframes `100% 100% → 0% 0% → 100% 100%`;
  - `animation: none` under reduced motion.

**Element class lists** (nothing else on any element changes; `zyjlcu` keeps its own gradient underneath):

| Element | `_cssGlobalClasses` |
|---|---|
| `zyjlcu` (band, desktop/phone) | `[home-enter-up, home-shimmer]` |
| `vpoodx` (its heading) | `[home-enter-left-slow]` |
| `cisqjr` (tablet band) | `[home-enter-up]` (no shimmer, as bdryswi.com's tablet band) |
| `mfgteo` (tablet heading) | `[home-enter-left]` |

**`globalClasses`:**
- `home-fade-in-up` (`uvxiyg`) and `home-fade-in-left` (`omkykf`) are no longer used, so they leave the payload.
  They stay on the site untouched.
- The four new classes take their place, in the order `home-enter-up`, `home-shimmer` (where `uvxiyg` was), then
  `home-enter-left-slow`, `home-enter-left` (where `omkykf` was).
- Every other class is untouched.

## Acceptance criteria (all proposed; Justin gave none)

The tests live in `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/test/`.
- **Arguments:** each takes the paste path as an argument, so the verifier can run it on the old file (the Downloads
  file) and on v5.
- **Measuring bdryswi.com:** `v5/scripts/measure-source.ts` measures it read-only in headless Chrome (`?f2b=<random>`,
  `CHROME_PATH` per the desktop memory note) and writes `v5/checks/source-timing.json`. It reads:
  - each element's `getAnimations()`: name, duration, delay, easing, iterations, direction;
  - the `::after` shimmer's animation and its computed `background-size`;
  - the scroll position at which each animation starts.
- **The Bricks runtime harness** (`v5/test/bricks-harness.ts`):
  - It loads Bricks' real `bricks.min.js` and `animate.min.css` (copied into `v5/fixtures/bricks/` with the sha256
    above).
  - It prints the band's elements from the paste the way Bricks prints a class interaction: `data-interactions`,
    `data-interaction-id`, `data-interaction-hidden-on-load="1"`, `body.bricks-is-frontend`, as on homev2's CTA. The
    class and element CSS comes from the paste, behind a 2000 px spacer.
  - If Bricks' runtime won't start with a minimal `window.bricksData`, the builder stops and reports. It never
    hand-rolls an imitation of Bricks.

The ACs:
- AC1 (proposed): At 1440 wide the band rises with `fadeInUp` in 1250 ms and its heading slides with `fadeInLeft` in 2000 ms (`ease`, no delay, 1 play, normal direction), equal to `source-timing.json`'s `84acbe9`/`df1e234`. Test: `v5/test/band-motion.test.ts` › "desktop band and heading enter at bdryswi.com's timing".
- AC2 (proposed): At 900 wide the tablet band rises in 1250 ms and its heading slides in 1250 ms (`ease`, no delay, 1 play), equal to `source-timing.json`'s `b1abc0f`/`f0c765d`. Test: `v5/test/band-motion.test.ts` › "tablet band and heading enter at bdryswi.com's timing".
- AC3 (proposed): The desktop/phone band's `::after` runs `home-shimmer` for 8000 ms, `linear`, infinite, `background-size: 200% 200%`, with keyframes and gradient equal to bdryswi.com's `.bg:after`; the tablet band has no shimmer, as on bdryswi.com. Test: `v5/test/band-motion.test.ts` › "band shimmer equals bdryswi.com's at 1440 and 390, none at 900".
- AC4 (proposed): The entrance waits for the band: it stays invisible and still while the band is out of view, starts once it enters the window, and keeps the same duration whether the test scrolls slowly or jumps there; scrolling back up and down again doesn't replay or reverse it. Test: `v5/test/band-motion.test.ts` › "entrance plays once by the clock on entering the window".
- AC5 (proposed): With `prefers-reduced-motion: reduce` emulated, the band and heading end in place and fully visible within 100 ms of entering the window, with no slide, and the shimmer's background stays still. Test: `v5/test/band-motion.test.ts` › "reduced motion: no entrance motion, no shimmer, band visible".
- AC6 (proposed): Nothing else changes. In the combined file, the 7 header elements, all 7 header classes and 267 of 271 elements are JSON-identical to the pasted Downloads file, in the same order. `zyjlcu`, `vpoodx`, `cisqjr` and `mfgteo` differ only in `_cssGlobalClasses`. `globalClasses` differ only by the swap above. The top-level keys are equal. `home-paste-v5.json` is the same check against v4. Test: `v5/test/paste-diff.test.ts` › "only the four class lists and the class swap differ".
- AC7 (proposed): The paste stays valid. `payloadProblems` is empty for both files. Every element and class id is unique. No new class name or id clashes with the site's own classes (memory note list) or with the classes the previous paste put on the site, so `bricksPaste` reports no "Import classes" conflict against a site holding the Downloads file's classes. The combined file is compact JSON with the same key order. Test: `v5/test/paste-valid.test.ts` › "v5 pastes with no problem and no class conflict".
- AC8 (proposed) (live): Justin empties homev2, pastes `bdry-home-with-header-v5.json` and saves. Scrolling to "Our Services" beside bdryswi.com in another tab, the bar rises and the heading glides in at the same unhurried pace, once, and the blue background shimmers as slowly as bdryswi.com's; on a phone the same. Test: `v5/checks/live-check-steps.md` › "3bs: Services band side by side with bdryswi.com".
- AC9 (proposed) (live): After that paste, Bricks has kept the Interactions. Read over HTTP with `?f2b=`, homev2's band section and both headings carry `data-interactions` with `enterView`, `runOnce` and the durations above, and the band carries `home-shimmer`. Test: `v5/scripts/read-live.ts` › "live homev2 band carries enterView interactions and home-shimmer".

## Tasks (builder)

1. **Measure the source.** Write and run `v5/scripts/measure-source.ts` (read-only) at 1440, 900 and 390. Record
   `checks/source-timing.json` plus shots: the band before, during and after its entrance, and the shimmer at
   t = 0, 2, 4 and 6 s.
2. **Write the failing tests first.** Copy the Bricks files into `v5/fixtures/bricks/`, then write
   `bricks-harness.ts`, `band-motion.test.ts`, `paste-diff.test.ts` and `paste-valid.test.ts` (imports from a repo
   copy as `v4/test/after-faq-paste.test.ts` does). Run them on the Downloads file: AC1–AC5 must fail there,
   scroll-linked or without a shimmer. Record the logs in `v5/checks/`.
3. **Build v5.** Write `v5/scripts/build-v5.ts` and produce both files. Run every test on v5 until green. Take one
   shot per AC: frames of the band from v5 beside bdryswi.com's, the reduced-motion frame, and a terminal capture for
   AC6/AC7.
4. **Write the live steps.** `v5/checks/live-check-steps.md` (paste check **3bs**): empty homev2, paste, save, then
   view beside bdryswi.com on a laptop and a phone. Also write `v5/scripts/read-live.ts` for AC9; it runs only after
   Justin pastes.
5. **Docs & records.**
   - **Manifest:** `v5/manifest.json`, as v4's: input files with their sha256, outputs, node and Chrome versions,
     every script, test, check and shot with its sha256.
   - **Downloads:** copy the combined file to `C:\Users\Admin\Downloads\bdry-home-with-header-v5.json`, a new name.
     Never overwrite the existing file.
   - **No HANDOFF entry and no BUILD bump:** there is no plugin change.
   - **For the main session:** the finisher's report gives the lines for the B-Dry memory note: v5 is current
     (sha256, 271 elements, what changed, check 3bs owed), and the 60 Years band is offered as a follow-up. The main
     session saves them.

## Touches

- New: `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/`, containing:
  - the two pastes: `home-paste-v5.json` and `bdry-home-with-header-v5.json`;
  - `manifest.json`;
  - `scripts/`, `test/`, `fixtures/bricks/`, `checks/` and `shots/`.
- `C:\Users\Admin\Downloads\bdry-home-with-header-v5.json` (new file).
- Read only: `v4/`, `header-v1/`, the repo copy (`src/core/emit/payload.ts`, `test/fixtures/bricks-paste.ts`),
  bdryswi.com and staging over HTTP.
- No repo source, no `docs/`, no CLAUDE.md, no memory edits by agents.

## Rulings (the ⭐ answers, not yet confirmed by Justin)

- **Reduced motion:** bdryswi.com keeps shimmering under reduced motion; ours stands still, as the header's already
  does.
- **Fallback:** where Bricks' script doesn't run (held back by a cache plugin, or the editor), Bricks keeps the
  element hidden until it does. The CTAs on this site behave the same way.
- **Breakpoints:** Elementor's tablet starts at 1024 and Bricks' at 991. Between 992 and 1024, ours shows the
  desktop band where bdryswi.com shows the tablet one. This is unchanged from v1.
