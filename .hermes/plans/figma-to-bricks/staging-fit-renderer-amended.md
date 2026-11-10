# staging-fit-renderer: the website checks see what real Bricks shows (plan, 2026-11-09)

Job C of the staging-fit umbrella (`~/.hermes/plans/figma-to-bricks/staging-fit.md`). Planned against main `fd1986dc`
(Build 2026-11-09.3). **Order: beside `staging-fit-capture`** (runs in parallel, other files); before
`staging-fit-cancels`, whose proofs it sharpens. Website importer rules: one real-bug review, edge cases to follow-ups.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index `README.md`).

## Amendments (planner, 2026-11-09; a fresh verifier or auditor reads this first)

Every changed line below carries *(amendment N)*. The text before these amendments is
`git show b512ec6a:docs/plans/2026-11-09-staging-fit-renderer.md` (branch `staging-fit-renderer-fix1`, base `fd1986dc`),
byte for byte the first approved copy `evidence/staging-fit-renderer/plan-approved.md`. No criterion is added, removed,
renumbered or retagged; every test name a criterion cites is unchanged. The amendments follow review 1
(`evidence/staging-fit-renderer/review-1/review.json`, on `f32ed6c2`) and fixer 1 (`60af39eb` to `b512ec6a`, receipts
`evidence/staging-fit-renderer/fixer-1/`): the tests at `b512ec6a` already hold the new expectations, and only this
text was behind. The supporting tests named here are cited by no criterion: a verifier or auditor runs each beside the
cited test of the line it supports and names its log in that row's evidence (`ac-check.sh` proves only the cited one).

- **Amendment 1 (review 1's R1-1, P2; the main session's rule in the fixer's brief, replacing the builder's "named and
  skipped"):** an element the published page holds in another's place is no longer "a named exception the checks
  skip". `site:live` names it (`differs`, "not the paste's element") and compares it as every other element, with the
  capture and with the renderer's drawing; the run fails (exit 1, "its box is … px from the capture's at <width>
  (FAIL)") unless its box agrees with the capture's within 2 px at a width where the capture holds a box of it ("its
  box agrees with the capture's"); one the capture holds no box of at the widths read fails too (the fixer's reading);
  nothing is left out of either comparison. Why: on a page like today's staging (three flip faces drawn 386×300 where
  the paste has a 50×50 icon) the run printed OK and exited 0. Changed: the R5 criterion (the line of the fourth
  criterion), Task 5, and the live criterion (the line of the fifth: a swapped element is no excuse there). The cited
  test of the fourth criterion is unchanged and still proves the first half (a turned face measures 50×50 in the
  renderer and in Bricks' printed page: R5 is no 3D measurement difference); its second half is proved by the
  supporting test:
  `test/web/site-live.test.ts` › "site:live names an element the page holds in another's place and fails unless its box agrees with the capture's"
  and, for the fold over the widths (the worst difference and its width, whatever the order):
  `test/unit/site-measure-watched.test.ts` › "a watched element keeps its worst difference and the width it was at, whatever the order"
  What that site:live test asserts at `b512ec6a`: a 386×300 box in a heading's place exits 1, `report.ok` false, the
  element in `differs` with `ok` false, its worst over 100 px at 1440, the width's worst element that one, the line
  ending "(FAIL)", no "left out" anywhere, and the renderer comparison false naming the same element; the same swap
  drawn 1 px apart exits 0, named, `ok` true, compared at 1 width, "its box agrees with the capture's (within 2 px at 1
  width)"; as many elements compared as on the faithful page at each width, with the capture and with the drawing;
  read only at 390, where the capture holds no box of it, exits 1 ("the capture holds no box of it at the widths read
  (FAIL)"); the faithful page names nothing; an element the paste doesn't have exits 1 ("not mapped"); the paste twice
  exits 2 with one plain line.
- **Amendment 2 (Justin's standing rule "Never write to any WordPress site; GET/read only"; review 1's R1-3 and the
  WebSocket half of R1-4):** "GET only" was true of the tool's own request, not of its Chrome: the published page's
  scripts sent POSTs and beacons as for any visitor. Now `site:live`'s Chrome can only read
  (`tools/lib/read-only.ts`): every request of the browser (the page, a frame of another site, a worker) that isn't a
  GET, HEAD or OPTIONS is refused before it leaves, WebSockets (whatever isn't http or https) go to a dead end of the
  tool's own, and `report.json` `readOnly` (`requests`, `sockets`) and one printed line ("Read only: refused N
  requests that weren't GET, HEAD or OPTIONS, and WebSockets to M hosts") list them. Changed: Question 2's answer A,
  Task 2, the site:live criterion (the line of the second criterion), the last risk. Its price (HANDOFF "Known
  limits"): a page that fetches part of itself by POST is read without that part; WebTransport and WebRTC aren't held
  (follow-ups). The cited test of the second criterion asserts it at `b512ec6a` (its stand-in page runs scripts that
  read and try to write from the page, a frame of another site and a worker: the seven reads arrive, nothing but
  GET/HEAD/OPTIONS reaches the published site, six refused writes and two WebSocket hosts are named). The same test
  also asserts, as at the reviewed head or sharpened by fixer 1 without a change of rule: exit 0 within 2 px with every
  part found, every element mapped and the old site asked for nothing; one section 5 px right exits 1 naming it, the
  renderer line FAIL by the same 5 px; a missing footer alone exits 1, named; the published site's own file naming the
  old site is asked of the published site; what the page asks the old site for and the capture doesn't hold is
  refused and listed, what only the drawing asks for isn't; a page without the paste exits 2 with one plain line.
  Supporting tests:
  `test/unit/read-only.test.ts` › "holdRequests pauses every request of the browser, refuses and notes what isn't a read, and gives reads to the caller's rule"
  `test/unit/read-only.test.ts` › "deadEnd answers a SOCKS5 connection with no, notes who it was for, and sends only what isn't http(s) there"
- **Amendment 3 (review 1's R1-2, P2):** the old site's host was made unreachable with a wildcard that also caught a
  published page on a name under it (a capture of `growithgro.com` pasted on `…staging.growithgro.com`: "The page
  couldn't be read"). Now the published page's own host is always reachable (`EXCLUDE <its host>` in Chrome's resolver
  rules); the old site's own name and every other name under it still resolve to nothing. Changed: Question 2's
  answer A, Task 2, the site:live criterion (the line of the second criterion). Supporting test (its own test in the
  cited test's file, so the cited test doesn't run it):
  `test/web/site-live.test.ts` › "site:live reads a page published under the old site's host, and nothing else under that host"
- **Receipts that still encode the old expectations** (all under `evidence/staging-fit-renderer/`; sorted by
  `git show <head>:test/web/site-live.test.ts | grep -c "leaves it out"`: 1 at `1991e231`, `eb59608e`, `0f72a12f` and
  `f32ed6c2`, 0 from `60af39eb` on; and `grep -c '"GET only"'`: 1 up to `f32ed6c2` and `60af39eb`, 0 from `227dbeac` on):
  - Amendment 1, the old test "…and leaves it out" passing, the line "not the paste's element (left out)", `notCounted`
    1 at 1440 and one element fewer in the renderer comparison, where a swapped page now exits 1 or is named and
    compared: `builder/ac4/live-head.log` (`6e47a6ab`), `builder/ac4/red-task4head.log`,
    `builder/cont/ac4/green-head-site-live.log` and `builder/cont/ac4/red-task4head.log`, `builder/cont/ac2/green-head.log`
    and `builder/cont/gates/head/test_web_site-live.test.ts.log` (`0f72a12f`, whole-file runs listing the old test),
    `builder/cont/takeover/green-worktree-uncommitted.log` and `red-ed3a.log`, the terminal shots
    `builder/cont/shots/ac2-terminal.png` and `ac4-terminal.png` (their text beside them in `terminal/`),
    `review-1/tests.log` and `review-1/probe1.log` (the finding's own evidence: `/swapped-big/` exit 0),
    `fixer-1/red/r1-1-red.tap` (the RED, old behaviour by design), `fixer-1/flake/rev-1.tap` to `rev-4.tap` (runs of
    `f32ed6c2`). `fixer-1/gates/summary.txt` and `files-compare*.txt` show the expected difference by name: the old test
    "base ok head -", the new one "base - head ok". Mutants `M9` ("the element left out at 1440") and `M10` ("the
    element left out of the renderer comparison") in `builder/cont/mutants/` died on assertions that no longer exist:
    fixer 1's run (`fixer-1/mutants/`, 45 mutants) replaces them; `M7`, `M8`, `M16`, `M20`, `M33` died on the faithful
    page's exit code, an unchanged assertion, and stay valid.
  - Amendment 1, the dry runs on staging, measured with the 8 swapped Code elements left out of both comparisons:
    `builder/ac5/dry2/run.log`, `builder/cont/ac5/dry3.log` and `dry3/`, `builder/cont/shots/ac5-dry-terminal.png`, and
    HANDOFF's "Proof" numbers taken from them. On `b512ec6a` the same page has those elements compared: each of the
    three flip faces (386×300 where the paste has 50×50) fails the run, named; the dry run wasn't repeated (no agent
    loads the live site in a fix round).
  - Amendment 2, the old assertion `served.every(GET)` on a page that ran no script (it couldn't fail): every green
    site-live log up to `f32ed6c2` (`builder/ac2/try1.log` to `try3.log`, `builder/cont/ac2/green-head.log`, the
    builder's gate log and mutant controls above); none of the builder's mutants died on it. Now the page runs scripts
    and the refused writes are named (`fixer-1/red/get-only-red.tap`, `fixer-1/green/get-only-try2.tap`).
  - Amendment 3 has no earlier receipt (the case wasn't tested before `c01c53e2`): `review-1/probe2.log` shows the old
    failure, `fixer-1/red/r1-2-red.tap` and `fixer-1/green/r1-2-green.tap` the fix.
  - Not behaviour, for the next fix or finish pass: `test/browser/render-site-flip-face.test.ts`'s header comment (line
    7) still says site:live "names such an element and leaves it out".

## Questions (⭐ = the standing auto-go's answer)

1. **Which Bricks the checks draw.** ⭐ **A:** follow the target site's version: add Bricks 2.4.2's served
   `frontend-light-layer.min.css` (B-Dry staging runs 2.4.2; darksalmon 2.3.9) to `reference/bricks/frontend-2.4.2/` with its
   SHA256, and a `--bricks 2.3.9|2.4.2` choice, default the newest sample. B: keep 2.3.9 only.
2. **Reading the published page.** ⭐ **A:** a new `npm run site:live` that reads a published page logged out
   (*(amendment 2)* read only: its own request is a GET, and its Chrome refuses every request that isn't a GET, HEAD or
   OPTIONS and every WebSocket, listing them in the report; was "GET only"), never reaches the old site (its host to
   NOTFOUND, *(amendment 3)* and every name under it but the published page's own host, which is always reachable; its
   pictures from the capture's bytes), maps paste elements by structure and reports like site:check. B: keep the ad-hoc
   evidence script.

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
   and shots. Read-only, never logs in. *(amendment 2)* Its Chrome only reads (`tools/lib/read-only.ts`): CDP Fetch on
   the browser refuses every request that isn't a GET, HEAD or OPTIONS (the page's, a frame's, a worker's), what isn't
   http(s) (a WebSocket) goes to a SOCKS dead end of the tool's own, and `report.json` `readOnly` and one printed line
   list what was refused. *(amendment 3)* The old site's host and every name under it resolve to nothing, except the
   published page's own host (`EXCLUDE <its host>`).
3. site:check `--whole`: header + page + footer in one page as pasted; pictures of other hosts the capture holds bytes
   for are served from them, others named "not drawn" and not counted as box differences.
4. `reference/bricks/frontend-2.4.2/frontend-light-layer.min.css` (GET from staging, SHA256SUMS line) and `--bricks`
   (Q1 A) for `renderSitePaste`/site:check/site:live.
5. R5: a minimal repro; fix the renderer or *(amendment 1)* have site:live name the element the page holds in another's
   place and compare it as every other element, a failure unless its box agrees with the capture's within 2 px (was
   "or record a named exception site:live and site:check skip"; site:check never reads the published page, so it has
   nothing to name).
6. HANDOFF section (rulings Q1 A, Q2 A not yet confirmed), ledger.

## Acceptance criteria (all proposed)

- AC1 (proposed): the renderer prints class control CSS as Bricks does: a fixture class used by a Div and a Heading, with `_typography:mobile_landscape` and an inline-element rule from its parent, draws the same font size and box at 600 as a page built from Bricks' printed shape (`.cls.brxe-div`); named-only, `jojdce` at 767 in the renderer is 236.2×47; RED on main.
  Test: `test/browser/render-class-selectors.test.ts` › "a class's control CSS carries the element's brxe class as Bricks prints it"
- AC2 (proposed): `npm run site:live` on a local fixture server that prints a pasted section the way Bricks 2.4.2 does (no ids, classes on elements) maps every element and reports within 2 px; moving one element 5 px makes it fail; a page without the paste stops with a plain line. *(amendment 2)* Its Chrome only reads: the published page's own scripts' GET, HEAD and OPTIONS requests go out (from the page, a frame of another site and a worker), every other request (a POST, PUT, DELETE, a beacon) is refused before it leaves and no WebSocket connects, and `report.json` `readOnly` and one printed line list what was refused. *(amendment 3)* A page published on a name under the old site's host is read as any other, while the old site's own name and every other name under it stay unreachable (supporting test, in the Amendments list).
  Test: `test/web/site-live.test.ts` › "site:live maps a Bricks-printed page and measures it against the capture"
- AC3 (proposed): site:check `--whole` draws header, page and footer in one page and agrees with the per-part runs on a fixture; a picture of another host the capture holds is drawn at its own size (named-only: `nvwzkg` 20×20).
  Test: `test/web/site-check-cli.test.ts` › "--whole draws the parts together and other hosts' pictures from the capture"
- AC4 (proposed): R5 is explained in HANDOFF with its repro, and the renderer and staging agree on `umnxgl` at 1440 or *(amendment 1)* the difference is named and counted, never skipped: where the published page holds another element in a paste element's place (R5's cause), `site:live` names it (`differs`, "not the paste's element") and compares it as every other element, with the capture and with the renderer's drawing, and the run fails (exit 1) unless its box agrees with the capture's within 2 px at a width where the capture holds a box of it; nothing is left out of either comparison (supporting test, in the Amendments list). Was: "or the difference is a named exception the checks skip".
  Test: `test/browser/render-site-flip-face.test.ts` › "a turned flip-box face measures as Bricks draws it"
- AC5 (proposed) (live): after Justin's re-paste (following staging-fit-capture's re-capture), `npm run site:live` against the logged-out staging page agrees with the renderer's `--bricks 2.4.2` drawing within 2 px at every capture width, apart from the other jobs' widgets. *(amendment 1)* An element the page holds in another's place is no exception: it is compared with the drawing as every other element, so where its box is more than 2 px from the drawing's the line `Renderer (Bricks 2.4.2) against the page:` says FAIL and this check isn't met (Justin sends the report and a Copy JSON of one such element).
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
- `site:live` reads a third-party staging site: *(amendment 2)* read only (its own request a GET; from its Chrome only
  GET, HEAD and OPTIONS leave, no WebSocket; was "GET only"), logged out, `?f2b=` cache-buster, never the old site. A
  page that fetches part of itself by POST is read without that part (`readOnly.requests` names the refused call);
  WebTransport and WebRTC aren't held (follow-ups).
