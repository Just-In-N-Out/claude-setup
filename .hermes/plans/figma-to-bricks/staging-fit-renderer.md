# staging-fit-renderer: the website checks see what real Bricks shows (plan, 2026-11-09)

Job C of the staging-fit umbrella (`~/.hermes/plans/figma-to-bricks/staging-fit.md`). Planned against main `fd1986dc`
(Build 2026-11-09.3). **Order: beside `staging-fit-capture`** (runs in parallel, other files); before
`staging-fit-cancels`, whose proofs it sharpens. Website importer rules: one real-bug review, edge cases to follow-ups.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index `README.md`).

## Questions (⭐ = the standing auto-go's answer)

1. **Which Bricks the checks draw.** ⭐ **A:** follow the target site's version: add Bricks 2.4.2's served
   `frontend-light-layer.min.css` (B-Dry staging runs 2.4.2; darksalmon 2.3.9) to `reference/bricks/frontend-2.4.2/` with its
   SHA256, and a `--bricks 2.3.9|2.4.2` choice, default the newest sample. B: keep 2.3.9 only.
2. **Reading the published page.** ⭐ **A:** a new `npm run site:live` that reads a published page logged out (GET only),
   never reaches the old site (its host to NOTFOUND, its pictures from the capture's bytes), maps paste elements by
   structure and reports like site:check. B: keep the ad-hoc evidence script.

## Playback

Our checks said the paste matched; Justin's staging page doesn't. I measured each paste element three ways, (a) the
capture, (b) the renderer's drawing of `whole.json`, (c) the logged-out staging page, at 48 widths + 300
(`measure/`). Apart from the styleless capture (staging-fit-capture), (b) and (c) disagree in ways that make the checks
wrong both ways.

## Root causes (proved)

- **R3: class control CSS selectors.** Staging prints every global class's control CSS as `.cls.brxe-<element>` (all 343
  control blocks in `staging/css/inline-2.css`: `brxe-div` 200, `brxe-heading` 63, `brxe-image` 39, `brxe-block` 24,
  `brxe-text` 14, `brxe-accordion-nested` 3), specificity 0,2,0; custom CSS stays as written (0,1,0). The renderer prints
  `.cls` (`test/browser/render-order.ts:14-25`, `test/browser/render.ts:105-127` `settingsCss`). Proof: hero button
  `jojdce` at 767 is 164.7×38.6 in the renderer and 236.2×47 on staging (= the capture): an inline rule (0,2,0) beats the
  `_typography:mobile_landscape` control only in the renderer; also `amotgo` 258.5×38.6 vs 370.2×46, and the "There are
  many things" section at 390 1791 vs 1828 (= capture) (`measure/look.ts`, `measure/sections-1440-957-390.txt`).
- **R4: what site:check draws.** It renders each part alone (`tools/site-check.ts`), in a Chrome that reaches no host but
  127.0.0.1 and Google Fonts (`tools/lib/site-chrome.ts`), so pictures of other hosts the capture holds draw as alt boxes
  (`nvwzkg` 65.8×35.6 vs 20×20 on staging and in the capture); it never measures the published page; it draws Bricks
  2.3.9's front-end CSS (`reference/bricks/frontend-2.3.9/`) while staging serves 2.4.2's (`themes/bricks/style.css`
  "Version: 2.4.2"; its `frontend-light-layer.min.css` differs: `--bricks-input-height`, `.bricks-button:where(…)`,
  `.brx-media-unavailable`; `staging/css/`).
- **R5 (open):** flip-box face icons `umnxgl`/`oavutc` measure 50×50 in the renderer and the capture but 386×300 on staging
  at ≥ 1025, with every section height equal (likely a 3D-turned face measured differently).
- Context: site:check on the saved capture already fails (`sitecheck/report.json`).

## Tasks

1. Renderer: a global class's control CSS prints as `.cls.brxe-<name>` once per element name that uses the class, in
   Bricks' order (render-order.ts, settingsCss); record the rule in `reference/bricks/README.md` "Class selectors" with
   the staging evidence.
2. `tools/site-live.ts` + `npm run site:live -- <capture> <url> [--elementor] [--widths …] [--out dir]`: GET the page
   logged out (`?f2b=<random>`), stop with a plain line on a login page or when the paste's root classes aren't there,
   answer the old site's and its CDN's picture requests from the capture's bytes (CDP Fetch at Request stage, as
   `evidence/staging-fit/planner/measure/measure.ts`), map the paste's elements by structure (paste tree vs each node's
   nearest `brxe-` descendants, in order; report mismatches), measure and compare like site:check, write `report.json`
   and shots. Read-only, never logs in.
3. site:check `--whole`: header + page + footer in one page as pasted; pictures of other hosts the capture holds bytes
   for are served from them, others named "not drawn" and not counted as box differences.
4. `reference/bricks/frontend-2.4.2/frontend-light-layer.min.css` (GET from staging, SHA256SUMS line) and `--bricks`
   (Q1 A) for `renderSitePaste`/site:check/site:live.
5. R5: a minimal repro; fix the renderer or record a named exception site:live and site:check skip.
6. HANDOFF section (rulings Q1 A, Q2 A not yet confirmed), ledger.

## Acceptance criteria (all proposed)

- AC1 (proposed): the renderer prints class control CSS as Bricks does: a fixture class used by a Div and a Heading, with `_typography:mobile_landscape` and an inline-element rule from its parent, draws the same font size and box at 600 as a page built from Bricks' printed shape (`.cls.brxe-div`); named-only, `jojdce` at 767 in the renderer is 236.2×47; RED on main.
  Test: `test/browser/render-class-selectors.test.ts` › "a class's control CSS carries the element's brxe class as Bricks prints it"
- AC2 (proposed): `npm run site:live` on a local fixture server that prints a pasted section the way Bricks 2.4.2 does (no ids, classes on elements) maps every element and reports within 2 px; moving one element 5 px makes it fail; a page without the paste stops with a plain line.
  Test: `test/web/site-live.test.ts` › "site:live maps a Bricks-printed page and measures it against the capture"
- AC3 (proposed): site:check `--whole` draws header, page and footer in one page and agrees with the per-part runs on a fixture; a picture of another host the capture holds is drawn at its own size (named-only: `nvwzkg` 20×20).
  Test: `test/web/site-check-cli.test.ts` › "--whole draws the parts together and other hosts' pictures from the capture"
- AC4 (proposed): R5 is explained in HANDOFF with its repro, and the renderer and staging agree on `umnxgl` at 1440 or the difference is a named exception the checks skip.
  Test: `test/browser/render-site-flip-face.test.ts` › "a turned flip-box face measures as Bricks draws it"
- AC5 (proposed) (live): after Justin's re-paste (following staging-fit-capture's re-capture), `npm run site:live` against the logged-out staging page agrees with the renderer's `--bricks 2.4.2` drawing within 2 px at every capture width, apart from the other jobs' widgets.
  Test: `npm run site:live -- <capture> https://bdry.staging.growithgro.com/homev2/ --elementor --bricks 2.4.2` › report.json (live)

## Overlaps

- `staging-fit-capture` (parallel): both touch `tools/site-check.ts` (it adds a refusal; this job adds `--whole`,
  pictures and `--bricks`): the second to merge rebases that file.
- `staging-fit-cancels` (later): its proofs run on this job's renderer.
- site-native-structure: R3 means a native element's own CSS meets the class's controls at 0,2,0.
- Every existing browser and site proof re-runs on the new selectors; a proof that passed only because of `.cls` is a
  real finding, reported, not tuned away.

## Risks

- Changing selectors can move existing renderer receipts (Figma route too, since `renderPage` is shared): run the browser
  suites and the corpus; Figma payloads themselves don't change (renderer only).
- `site:live` reads a third-party staging site: GET only, logged out, `?f2b=` cache-buster, never the old site.
