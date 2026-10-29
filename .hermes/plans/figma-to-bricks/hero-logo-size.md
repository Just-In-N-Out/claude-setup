# hero-logo-size: the hero's "BDry" logo is smaller than bdryswi.com's (B-Dry Home paste)

Mini plan, 2026-10-29. Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/hero-logo-size/planner/`
(`live.json` = both live heroes measured on every slide in headless Chrome at 1920, 1440, 1366, 1024, 991, 768, 767,
478, 390, read with `table.mjs`; `live-<site>-<width>.png` shots at 1920/1440/390; `measure-live.ts` re-runs it;
`post-155.min.css` = staging's live CSS for homev2, copied from the fee-band-photo planner).

## Questions (⭐ = taken under Justin's "go with the recommended")

1. **Where does the file Justin pastes go?** (same question and answer as the fee-band-photo plan)
   - A ⭐ A new file `C:\Users\Admin\Downloads\bdry-home-with-header-v5.json` (header + whole Home, as he pastes now);
     the old `bdry-home-with-header.json` stays as it is.
   - B Overwrite `C:\Users\Admin\Downloads\bdry-home-with-header.json`.
   - C Evidence folder only; Justin is told the path.
2. **How does this job land with the other four (`services-band-speed`, `sixty-years-marker`, `fee-band-photo`,
   `quote-button-hover`)?**
   - A ⭐ One shared v5 built from v4, as the fee-band-photo plan's Q2 A sets it up: each job writes only its own edit
     module `bdry-paste/v5/edits/<job>.ts` (`{ job, ids, apply(home) }`, asserting the v4 values it replaces);
     `v5/scripts/build-v5.ts` applies every module in name order to v4, stops if two modules touch the same element
     id or class, and joins header-v1. This job's module touches only the three logo images `gqsjwu`, `pcttcw`,
     `ntbufo` and no class, so it can't clash with the others (fee band `dchafl`'s elements; the services band's
     class lists; the 60-years band; the consultation band's button).
   - B One version per job in landing order (v5, v6, …).
3. **Measuring showed other hero differences from bdryswi.com that the logo doesn't cause** (listed in `found_else`:
   slide 3's extra 25px above its buttons on desktop; 992–1024 wide still showing the desktop band and 68px heading;
   the tablet band at 71.3% instead of 716px from 768 to ~950; the phone hero 900px tall instead of the window's
   height; slide 1's phone buttons 24px closer together). Fix them here?
   - A ⭐ No: this job changes only the three logos. Each other difference becomes its own small job if Justin wants
     it (they touch the band, heading, buttons rows and slide heights: different parts).
   - B Yes, fold them in (about 12 more elements and the slider's phone height; recommend Full then).

## Playback

In the B-Dry Home paste's hero slider (basement photo, blue "BDry" logo top left, the navy band "Basement Contractors
in Southwest Indiana / The Tri-State's Waterproofing Experts", the two buttons under it), the logo is much smaller than
on bdryswi.com. Make it the same size and in the same place as bdryswi.com's on all three slides at every width, phones
included, so the band and buttons move down exactly as bdryswi.com's do; nothing else changes. Deliver it in a new
paste version built from v4 + the header, as the one file Justin pastes.

## Root cause (measured live on both sites, same widths, every slide)

**The plugin did not size this logo; no plugin code changes.** The three logos are v1's hand-built elements: v1
`home-paste-v1.json` (sha256 `51b05cd9…`) already holds, three times, `"_width":"271px"`, `"_width:tablet_portrait":
"366px"`, `"_width:mobile_landscape":"57%"`. v3 grafted the plugin's slider around v2's inner slides unchanged
(`bdry-paste/v3/scripts/build-v3.ts:65-68`: each inner slide keeps its children), and v4 and the pasted Downloads file
(sha256 `9070659e…7e53` = header-v1 + v4) carry them as they were:

| slide | image element | settings in v4 (`home-paste-v4.json`, sha256 `0a9c9d07…`) |
|---|---|---|
| 1 (Tri-State) | `gqsjwu` [Logo] in `nddmod` [Logo row] | `_width 271px`, `:tablet_portrait 366px`, `:mobile_landscape 57%`, `_margin {left 80}`, `:mobile_landscape {left 0, bottom 12}` |
| 2 (Helping) | `pcttcw` in `ddngmu` | same widths; `:mobile_landscape {left 0, bottom -2}` |
| 3 (Protecting) | `ntbufo` in `jokccj` | same widths; `:mobile_landscape {left 0, bottom -2}` |

Each slide carries its own logo (media 132 `home-01-image.avif`, 500×191). Bricks renders it as a bare
`<img class="brxe-image" width="500" height="191">` whose size is set only by that `_width` (no figure, no cap beyond
`max-width:100%`, height auto): live `post-155.min.css` offsets 8003/8076/8131 show
`#brxe-jubqxq {width: 271px; margin-left: 80px}`, `{width: 366px}`, `{width: 57%; …}` (Bricks renamed the ids).

**bdryswi.com's logo is fluid, ours is frozen.** Elementor (`bdry-source/home.html` line 247, inline CSS) sizes the
logo widget at 66.198% of its row with 80px left padding and the picture at a share of what's left:
`.elementor-element-0564d68{width:…66.198%}`, `> .elementor-widget-container{padding:0 0 0 80px}`,
`img{width:32%}`; `@media(max-width:1024px)` `img{width:64%}`; `@media(max-width:767px)` widget `60%`, padding 0,
`img{width:100%}`, row centred (the same rules for `8da3072`, `cd887dc` on slides 2 and 3). The row's content is the
window less 40px (slide padding 10 + row padding 10 each side; ours has the same two paddings). So:

- W > 1024: logo width = ((W − 40) × 0.66198 − 80) × 0.32
- 768 ≤ W ≤ 1024: ((W − 40) × 0.66198 − 80) × 0.64
- W ≤ 767: (W − 40) × 0.60, centred; height always width × 191/500.

v1 froze the 1440 value (271px) and the 1024 value (366px), mapped Elementor's ≤1024 tier to Bricks' ≤991 tier, and
wrote 57% instead of 60% on phones. Measured (logo w×h, left edge x, from the slide's left; same on all 3 slides):

| W | bdryswi.com | ours (v4 live) | after the fix (formula) |
|---|---|---|---|
| 1920 | 372.6×142.3, x 100 | 271×103.5, x 100 | 372.6×142.3 |
| 1440 | 271×103.5, x 100 | 271×103.5 | 271×103.5 |
| 1366 | 255.3×97.5, x 100 | 271×103.5 | 255.3×97.5 |
| 1024 | 365.7×139.7, x 100 | 271×103.5 | 365.7×139.7 |
| 991 | 351.7×134.3, x 100 | 366×139.8 | 351.7×134.3 |
| 768 | 257.2×98.3, x 100 | 366×139.8 | 257.2×98.3 |
| 767 | 436.2×166.6, x 165.4 | 414.4×158.3, x 176.3 | 436.2×166.6 |
| 478 | 262.8×100.4, x 107.6 | 249.7×95.4, x 114.2 | 262.8×100.4 |
| 390 | 210×80.2, x 90 | 199.5×76.2, x 95.3 | 210×80.2 |

Justin's screenshots are a ~1920-wide window: bdryswi's logo 372.6×142.3 ("about 360×140") against our 271×103.5; the
slide's column is centred (`justify-content: center`), so the 38.8px taller logo moves the band and buttons down 19.4px
and the logo up 19.4px on bdryswi.com (band top 452.2 vs ours 432.8 on slide 1). Everything else around the logo
already follows the same rules: the band starts the same distance below the logo on every slide at every width (10px on
slide 1, 30px on slides 2–3; 22/28px on phones), so the band and buttons land where bdryswi.com's do as soon as the
logo has its size, except where a `found_else` difference (Q3) already moves them today.

## The fix (paste data only; v3, v4 and header-v1 are never edited in place)

Edit module `bdry-paste/v5/edits/hero-logo-size.ts` (`job: "hero-logo-size"`, `ids: ["gqsjwu","pcttcw","ntbufo"]`).
For each of the three images, first assert the v4 values (`_width 271px`, `_width:tablet_portrait 366px`,
`_width:mobile_landscape 57%`, no `_cssCustom`), then set:

- `_width`: `calc((66.198% - 80px) * 0.32)` (Bricks writes text controls as given; the plugin already emits `calc()`
  widths. `%` is the Logo row's content box, as Elementor's is the row's.)
- `_width:tablet_portrait` (≤991): `calc((66.198% - 80px) * 0.64)`
- `_width:mobile_landscape` (≤767, cascades to upright phones): `60%`
- new `_cssCustom` for the 992–1024 windows Bricks' tiers miss, naming only the element's own id:
  `@media (min-width: 992px) and (max-width: 1024px) {\n#brxe-<id> {\n  width: calc((66.198% - 80px) * 0.64);\n}\n}`
  This is v1's own proven pattern: v4 `ylenpi` carries `@media (min-width: 992px) and (max-width: 1366px)
  {#brxe-ylenpi {padding…}}` beside its `_padding` control, and the live CSS writes an element's control rule, then
  its custom CSS, then its tier rules (`post-155.min.css` offsets 78488 → 78681 → 78743 for `#brxe-lbvogy`), so the
  bounded rule overrides the desktop control at equal specificity and never meets the ≤991 rule.

Nothing else changes: margins, the Logo rows, the band, the buttons, the slider's settings (autoplay, interval 7500,
speed 2500, arrows, `height: auto`), slide min-heights (997/826/846, phones 900) and every class stay as in v4. The
slides' heights don't change: after the fix every slide's column stays well under its min-height (at most about 600px
against 997 on desktop and tablets, about 400px against 900 on phones), so the centred column only shifts.

## Tasks

1. **Oracle and calibration.** Copy the planner's `measure-live.ts` and `table.mjs` into
   `bdry-paste/v5/hero-logo-size/scripts/` and re-measure bdryswi.com read-only (`?f2b=<random>`, CPU Chrome wrapper
   per the desktop memory note) at 2560×1440, 1920×1080, 1440×900, 1366×768, 1024×768, 991×768, 768×1024, 767×1024,
   478×900, 390×844 into `v5/hero-logo-size/oracle/bdryswi-hero.json` (per slide: logo box, band box, buttons row,
   first button). Check every logo width against the formulas above (±1px); stop and report if they disagree. Then
   render v4 with `v4/test/render-lib.ts` (F2B_REPO = your worktree) at the same sizes and compare with the planner's
   live staging numbers (`planner/live.json` "ours@W"); record in `v5/hero-logo-size/checks/calibration.json` any
   point where the renderer differs from live staging by more than 1px (those points are then judged on deltas only).
2. **Tests first** in `v5/hero-logo-size/test/` (`hero-logo-render.test.ts`, `hero-logo-paste.test.ts`; a run script
   like `v4/scripts/run-tests.sh`). Run them on v4 and keep the failing log in `v5/hero-logo-size/checks/` (AC1 must
   fail at 2560, 1920, 1366, 1024, 991, 768, 767, 478, 390 and pass at 1440; AC2 must fail at 767, 478, 390).
3. **Edit module + build.** Write `v5/edits/hero-logo-size.ts`. If `v5/scripts/build-v5.ts` doesn't exist yet, write
   it as Q2 A says (v4 + every `v5/edits/*.ts` in name order, disjoint ids and classes or stop, header-v1 joined
   exactly as today's Downloads file: content = header content + home content; classes = header's, then home's whose
   id and name the header lacks; same top-level keys and compact JSON), with `--only <job>` writing a check copy
   (`v5/hero-logo-size/home-paste.json` and `…/bdry-home-with-header.json`). If it exists, use it unchanged. Never
   write in `v3/`, `v4/` or `header-v1/`.
4. **Green + shots.** All tests pass on the check copy and on the full v5. One shot per AC: the hero's top-left crop,
   ours beside bdryswi.com, for each slide at 1920, 1440, 1366, 1024, 767, 390 (`v5/hero-logo-size/shots/`); a
   terminal capture for the paste checks.
5. **Live step.** Add this job's step to `v5/checks/live-check-steps.md` (one numbered action at a time: empty homev2,
   paste `bdry-home-with-header-v5.json`, save, open beside bdryswi.com on a wide screen and a phone, compare the
   logo on each slide) and keep `measure-live.ts` ready for AC10.
6. **Docs & records.** `v5/manifest.json`: inputs (v4 `0a9c9d07…`, header-v1 `f48783e5…`) with sha256, the edit
   modules applied with the element ids and keys each changes (this one: `gqsjwu`/`pcttcw`/`ntbufo`: `_width`,
   `_width:tablet_portrait`, `_width:mobile_landscape`, `_cssCustom`), outputs' sha256, node/Chrome versions, test
   logs. The Downloads copy (Q1 A) with sha256 equal to the evidence copy. For the main session (agents don't edit
   memory): one proposed line for the B-Dry memory note's paste status (v5 = v4 + which edits, path, sha256, live
   checks owed).

## Acceptance criteria (all proposed; ±2px unless named)

Widths W = 2560, 1920, 1440, 1366, 1024, 991, 768, 767, 478, 390 at the oracle's window heights, rendered with the v4
render-lib unless `(live)`; "every slide" = slides 1, 2 and 3, each measured from its own slide box.

- AC1 (proposed): the logo's rendered width and height equal bdryswi.com's (oracle) on every slide at every W. Test: `hero-logo-render.test.ts › logo size matches bdryswi on every slide at every width`
- AC2 (proposed): the logo's left edge equals bdryswi.com's on every slide at every W (100px above 767; centred on phones). Test: `hero-logo-render.test.ts › logo left edge matches bdryswi on every slide at every width`
- AC3 (proposed): the logo keeps its shape: width/height within 0.5% of 500/191, no `object-fit` crop, not clipped by any ancestor, every W. Test: `hero-logo-render.test.ts › logo keeps its shape`
- AC4 (proposed): the band and buttons follow the logo: on every slide at every W, band top − logo bottom equals bdryswi.com's, and against v4 the logo top moves up and the band top and first button top move down by half the logo's height change (±1px; the centred column), nothing else in the slide moving. Test: `hero-logo-render.test.ts › band and buttons move with the logo as on bdryswi`
- AC5 (proposed): where only the logo differed before (slides 1–2 at 1920, 1440, 1366; every slide at 991; slides 2–3 at 478×900), the logo, band and first-button tops equal bdryswi.com's (points in `calibration.json` judged by AC4 only). Test: `hero-logo-render.test.ts › hero tops match bdryswi where only the logo differed`
- AC6 (proposed): the slider is unchanged: its settings and every slide's settings are JSON-equal to v4's, and each slide's rendered height equals v4's (±0.5px) at every W. Test: `hero-logo-render.test.ts › slider and slide heights unchanged`
- AC7 (proposed): nothing else in the paste changes: `home-paste-v5.json`'s content equals v4's element for element, in order, except `gqsjwu`, `pcttcw`, `ntbufo` (and ids owned by the other jobs' edit modules); those three differ only in `_width`, `_width:tablet_portrait`, `_width:mobile_landscape` and the new `_cssCustom`, with the values in "The fix"; `globalClasses` gain or lose nothing from this module. Test: `hero-logo-paste.test.ts › only the three logos change`
- AC8 (proposed): the paste stays valid: the repo's `payloadProblems` (`src/core/emit/payload.ts:52`) finds nothing in the combined file, element and class ids are unique, no class name is one of the site's own (`section`, `container`, `h1`–`h4`, `text1`, `cta-btn-orange`, `flip-box`, `flip-inner`, `flip-front`, `flip-back`, `circle`, `line`, `horizontal`, `text-blue`, `yellow-h2`), each logo's `_cssCustom` names only its own `#brxe-` id, and `source`/`sourceUrl`/`version` equal v4's. Test: `hero-logo-paste.test.ts › combined paste is valid`
- AC9 (proposed): one file holds the header and the whole Home: `bdry-home-with-header-v5.json` content = header-v1 content + `home-paste-v5.json` content, classes joined as today's Downloads file, and the Downloads copy's sha256 equals it. Test: `hero-logo-paste.test.ts › combined file is the header plus the whole Home`
- AC10 (proposed) (live): after Justin empties homev2, pastes `bdry-home-with-header-v5.json` and saves, a read-only probe of staging shows the logo's width, height and left edge within ±2px of bdryswi.com's on every slide at 1920, 1440, 1366, 1024, 767 and 390, and band top − logo bottom equal to bdryswi.com's. Test: `measure-live.ts › live hero logo matches bdryswi on staging`

## Touches

Evidence only (no repo source, no BUILD bump, no plugin change):
`~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/` (`edits/hero-logo-size.ts`; `scripts/build-v5.ts` only if
first; `hero-logo-size/{oracle,scripts,test,checks,shots}/`; `home-paste-v5.json`; `bdry-home-with-header-v5.json`;
`manifest.json`; this job's step in `checks/live-check-steps.md`) and
`C:\Users\Admin\Downloads\bdry-home-with-header-v5.json`. Reads: v4, header-v1, the repo's renderer
(`test/browser/render.ts`), Chrome harness (`test/browser/chrome.ts`) and `payloadProblems`.
