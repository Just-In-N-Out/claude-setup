# staging-fit-capture: a website capture never keeps a range read without the site's styles (plan, 2026-11-09)

Job A of the staging-fit umbrella (`~/.hermes/plans/figma-to-bricks/staging-fit.md`). Planned against main `fd1986dc`
(Build 2026-11-09.3). **Order: first** (it is why tablets break); `staging-fit-renderer` runs beside it (other files);
`staging-fit-cancels` starts after this job merges. Website importer rules: one real-bug review, edge cases to follow-ups.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index `README.md`).

## Questions (⭐ = the standing auto-go's answer)

1. **A range whose page load lacks the design width's styles.** ⭐ **A:** wait for its pending stylesheets (≤ 15 s), then
   read that range again in a fresh page load **alone** (outside the side-by-side batch), at most 2 more tries 30 s apart;
   if it still lacks them, **stop the capture** with one plain line naming the widths and the stylesheet that didn't
   arrive. B: keep going and mark the range unread (its paste then copies the neighbouring range: wrong there). C: save it
   as today.
2. **Captures already saved with such a range.** ⭐ **A:** `npm run site`, `npm run site:check`, `npm run capture:check`
   and the panel refuse them (exit 2: "the capture read 768–991 from a page without its styles: capture again"). B: warn
   and paste anyway.

## Playback

Justin's paste of bdryswi.com on B-Dry staging looks right on desktop and wrong at tablet widths: at 990 the header shows
twice, the hero's three slides stand one under another, "View Our Services" is nearly invisible; on phones the hero
buttons lose their colour. Zoomed out in the Bricks editor it looks fine. He asked whether the capture is right: at
768–991 it is not.

## Root cause (R1, proved)

- `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` `web.code`: range 922-991 drops **18,895** declarations its
  wider neighbour holds (keeps 859); 601-767 adds **20,211** back; every other range changes ≤ 456. The hero container
  `.e-con` (`body/div:0/div:0/div:0/div:0/main:0/article:0/div:0/div:0/div:0`) has every property `null` at 922-991.
- The capture's boxes agree: at 991/957/922 the page is laid out 1024 px wide, header 244 tall with both header bars
  shown, hero 3534 tall (997 at 1024, 900 at 767), page 17,588 (9,116 at 1024); 1,291 shown nodes at the four tablet
  ranges vs 1,120–1,198 elsewhere (Elementor's `elementor-hidden-*` and `.collapse{display:none}` lost); `timings` `code`
  8–13 s there vs 30–36 s elsewhere.
- The site is not like that: its served home of 2026-10-29 drawn with its CSS keeps the hero at 997 and the page as wide
  as the window at every tablet width; even Jetpack Boost's critical CSS alone keeps it (`probe-critical/result.txt`).
- Why the site sent no styles can't be proved without loading bdryswi.com (forbidden). Facts: the four tablet ranges were
  one side-by-side batch (`src/web/capture.ts:58` `WINDOWS = 4`, `inOrder`); the site's CSS is Jetpack `_jb_static`
  bundles behind `media="not all"` + `onload` swaps; its host refused one of its own font files with HTTP 403 in this
  capture.
- **Our defect:** a range's page load is read whatever stylesheets it got: `src/web/session.ts:189-194` accepts the load on
  the load event, fonts and a document status; `src/web/capture.ts:149-177` (`readOpened`) checks only the status (`:155`)
  before reading boxes (`:172`) and code (`:177`). Nothing downstream (`npm run site`, `site:check`, `capture:check`)
  notices a range that lost most declarations, and `blocksOf` (`src/core/site/blocks.ts:23-36`) turns the loss into 7,392
  `revert`s in the paste's `max-width: 991px` blocks (`reverts.ts`). The Bricks editor at 100% draws a 990-wide canvas
  (inside that block); zoomed out its canvas is wider: Justin's clue.
- Effects in the paste (evidence `measure/summary.txt`, `measure/sections-1440-957-390.txt`, `probe2/probe3.json`):
  duplicate header and stacked slides at 768–991; the hero buttons' paint lost on phones (an inline-element rule the
  styleless read created, cancelled with `revert` at 767: the general guard is `staging-fit-cancels`); the FAQ's stuck
  open look (all answers "shown" in those ranges: the site-faq job's evidence).

## Tasks

1. `src/web/styled.ts` (new; in-page reader + pure compare): every `link[rel~=stylesheet]` (href without query, `media`
   now, `sheet` present, rule count or "cross-origin"), every `<style>` (id or index, rule count), stylesheet resource
   entries (`responseStatus`, failed). Pending = a link whose `sheet` is null, or whose media is a deferral (`not all`,
   `print`) with an `onload`/`data-media` swap.
2. `src/web/capture.ts` / `session.ts`: the design width's load is the reference list. Every other range's load, before
   `s.full()`: poll every 500 ms up to 15 s while a sheet is pending; then compare. Missing = a reference sheet absent,
   not applied, answered ≥ 400, or with < 50% of its rules. On missing: close that load, wait 30 s, open the range alone
   (not in the batch), up to 2 more tries (Q1 A); still missing → throw the plain error naming widths and sheet (no
   capture file). Save each range's summary as optional `web.code.sheets[range]`.
3. `src/core/site/styled-ranges.ts` (new, pure) `unstyledRanges(capture)`: a range whose code drops ≥ 40% of the
   declarations its wider neighbour holds while a narrower range restores ≥ 80% of them, or (with `web.code.sheets`)
   lacks a reference sheet. Pin thresholds with the tests below.
4. `tools/site.ts`, `tools/site-check.ts`, `tools/capture-check.ts`, the panel's capture convert path (`src/ui/`): refuse a
   flagged capture (exit 2 / one plain line naming the widths), Q2 A.
5. HANDOFF section (rulings Q1 A, Q2 A not yet confirmed), ledger, paste check for Justin's re-capture and re-paste.

## Acceptance criteria (all proposed)

- AC1 (proposed): a fixture site whose stylesheet answers 503 to its 2nd–4th page loads (or holds a `media="not all"` swap 20 s) is captured with every range styled: the saved capture's code and boxes at the tablet anchors equal a clean capture's within 0.5 px; RED on main (main saves the styleless reading).
  Test: `test/web/capture-styled-ranges.test.ts` › "a range whose stylesheet failed is read again"
- AC2 (proposed): when the stylesheet never arrives, the capture stops with one plain line naming the widths and the stylesheet, exits 1 and writes no capture file.
  Test: `test/web/capture-styled-ranges.test.ts` › "a range that never gets its styles stops the capture"
- AC3 (proposed): `unstyledRanges` flags exactly 922-991, 835-921, 769-834 and 768-768 on `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (named-only, skipped without the file) and nothing on a clean generic fixture capture or any `corpus/` capture.
  Test: `test/unit/site-styled-ranges.test.ts` › "a range read without the site's styles is flagged and clean captures are not"
- AC4 (proposed): `npm run site -- <flagged capture> --all` and `npm run site:check -- <flagged capture> --all` exit 2 with the line naming the widths (generic fixture capture with one range's declarations removed); a clean capture runs as before; RED on main.
  Test: `test/web/site-cli.test.ts` › "a capture with a styleless range is refused"
- AC5 (proposed): Figma conversions and every paste of a clean capture are byte-identical to main (corpus, replay, site route both routes and picture modes).
  Test: `test/unit/site-styled-ranges.test.ts` › "clean captures convert byte for byte as on main"
- AC6 (proposed) (live): Justin re-captures bdryswi.com with this build; the new capture has no flagged range; after his re-paste of its `--elementor` whole paste on staging, at 990 one header and one hero slide show and on phones both hero buttons keep their gradient and white words; a later agent re-measures the logged-out staging page (staging-fit-renderer's `npm run site:live`, or `evidence/staging-fit/planner/measure/measure.ts` until it exists) within 2 px of the capture at 768–991, apart from script-styled boxes and the other jobs' widgets.
  Test: `npm run site:live -- <new capture> https://bdry.staging.growithgro.com/homev2/ --elementor` › report.json (live)

## Overlaps

- `staging-fit-renderer` (parallel): touches `test/browser/`, `test/web/lib/`, `tools/site-check.ts` (a different part:
  drawing, not refusing); rebase the `tools/site-check.ts` hunk with care.
- `staging-fit-cancels` (after): `src/core/site/blocks.ts`; this job doesn't touch it.
- site-faq, site-slider, site-menu, site-reviews, site-native-structure (other planners): a re-capture after this job
  changes what they read for bdryswi.com (FAQ open item, tablet slides); their fixtures are unaffected.

## Risks

- The saved capture can't be repaired; Justin captures again (about 7 min, his allow-listed visible Chrome).
- A site that never loads some stylesheet in any load is compared against the design width's own load: never flagged.
- The wait adds time only while a sheet is pending.
