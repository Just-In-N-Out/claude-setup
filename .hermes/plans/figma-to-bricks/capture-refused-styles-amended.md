# capture-refused-styles: a site whose protection turns the scan away partway is passed again, or named (plan, 2026-11-10; amended 2026-11-11)

A bug, **Mini pipeline** (Justin's choice; it stays Mini: one rule of about ten lines in four files, a request log, two
lines of wording). **Base: main `11e885fda5d08863a5875f939085350c007ac732`** (Build 2026-11-10.8, control-weight on top
of `7ec16d60`, where the probes ran; `git diff 7ec16d60 11e885fd` touches no file this plan reads, changes or tests:
`src/web`, `tools`, `test/browser`, `test/web` but `lib/site-page-check.ts`, the fixtures the tests import, `src/ui`,
`src/core/snapshot` and `package.json` are byte for byte the same; only `BUILD`'s value and the site converter moved, and
no planned test reads either). Website importer rules: one real-bug review, edge cases to follow-ups. Evidence and every probe:
`~/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/planner/` (index `notes.md`; scripts and scratch trees
in `~/.cache/capture-refused-styles-planner/`). The builder copies this file to
`docs/plans/2026-11-10-capture-refused-styles.md` as Task 0.

## Amendments (2026-11-11, after the builder stopped at `60f1cea5`, code final at `993d80b4`; every changed line is tagged)

The builder's branch `capture-refused-styles-build` holds Tasks 0–8 of the approved plan. The work below goes on that
branch, from `60f1cea5`; nothing done so far is undone. Evidence of this amendment: `planner/amend/` (`summary.txt`).

- A1 [amended A1] The "refused on the way" line and its log, after a saved capture, are triggered only by a refused file
  the page asks for itself (a stylesheet, script, font, picture or media file of the site's own host), never by the page
  itself (a check met and passed) or by Chrome's own requests (a check page's `/favicon.ico`, type "Other"). The log,
  whenever it is written, still records every refused request with its kind. `human-check.test.ts` "AC3 after the pass
  every load stays in the Chrome that passed, which closes at the end" stays unchanged and passes. AC6 and AC8 amended.
- A2 [amended A2] AC3's speed clause: its proof is the paired, interleaved time ratio pooled over every site and mode (the
  median of 30 head/base ratios at most 1.10), with the per-address request counts as a hard clause; the old per-site
  "median of 3 within 15 % and 1 s" is gone (load on the shared desktop swung one tree 17 s to 70 s inside one run).
- A3 [amended A3] New rule and AC10: a page load whose own stylesheets the site refused, every one of them (401, 403,
  429), is the site turning the capture away, never its dead links: it is read again asking the site, and still refused
  the capture stops with the refusal line and the log (it was saved styleless with exit 0, `Switch points found: none`).
- A4 [amended A4] M05 (the search made again after a stylesheet wait answered from the kept page) is closed by a test on
  AC1's line: "AC1 the switch-point search made again after a stylesheet wait asks the site for its page".
- A5 [amended A5] The builder's deviations are taken into the plan: `capture-unreachable.test.ts` "R1-2 --all: …" expects
  AC5's words (AC5's Also); `test/unit/capture-asked.test.ts` proves the log's privacy and first bytes (AC2's Also).
- A6 [amended A6] Base `11e885fd` (named above since the first amendment of the base line; unchanged).

[amended] Receipts of this amendment (scratch trees: `993d80b4` as built, the same plus this amendment's code, and a clean
`11e885fd`; `planner/amend/summary.txt`): on `993d80b4` AC10 fails (exit 0, `Switch points found: none`, one range read
styleless: `bhead-new.tap`; the planner reproduced it on the edge fixture, every stylesheet 403 from the start:
`head-first-refused-w4.json`, `320-up` sheets `error/403/0`), and the human-check AC3 listing fails as the builder found;
with the amendment AC10, the AC1 search test, AC2, AC6 and human-check's AC3 pass (`amend-new.tap`,
`amend-ac2-ac6.tap`, `amend-human-check.tap`); M05 applied to the amended tree fails the AC1 search test (`page load 3
asked ["/phone.css", …]`: `m05-search.tap`); on `11e885fd` both new tests fail (`red2-new.tap`). The amendment's code is
`amend-src.diff` and `amend-tools.diff` (against `993d80b4`). AC3's amended proof, on the amended tree against `11e885fd`
at load 27–32 (`ac3-amended.tap`, `ac3-amended.load`, 24 min): **passes**, every round equal, every address asked no
more often (edge 67 against 69 and 95 against 99; the folder fixtures 420/435/480/445 alike), the pooled median of 30
paired ratios **1.065**. The per-site tables show single pairs far off both ways (base 115 s against head 24 s in one
edge pair; head 72–75 s against base 20 s in two kept-page pairs of `basic` and `code-page`); a probe alternating
`basic` 4 rounds a tree with kept pages found no head-only cost (head 17.0–34.8 s, base 20.9–47.7 s, the slow ones'
extra time outside the timed steps: `slow-basic.log`), and the builder's 6-round `code-page` probe had the head faster
(`builder/timing/code-page-r6.log`). The verifier runs AC3 at the lowest load it can and reads the per-site tables: a
site and mode whose 5 ratios are all above 1.10 fails the test (its second assertion; none did in this run: each
site and mode had a pair at or under 1.10).

## Questions (⭐ = recommended; with no reply the builder takes the ⭐ answers)

1. **When the site's check comes back partway through a scan** (its pass runs out after a few minutes). ⭐ **A:** the
   range that lost a stylesheet is loaded again (after its 30 s wait, as now) **asking the site for its page itself** in
   the same window, so the site's check meets a real page load and is passed the way a person's browser passes it: by
   itself, or by Justin pressing "I am human" again in the window if the site asks for a press. B: never ask again; stop
   with the plain line at once. *Trade-off: A may ask Justin to press "I am human" once more partway through a scan; B
   never finishes a scan of a site that re-checks.* **This is a decision for Justin only in that sense:** nothing changes
   for sites that don't re-check.
2. **Reusing a stylesheet's bytes the site gave earlier in the run** when it later refuses that address. ⭐ **B: no.** The
   site that turned the stylesheet away also turns its scripts, fonts and pictures away (one pass covers every request:
   the hosting company documents that suspicious visits get 403 for everything), so reused CSS would hide a page read
   without its scripts. A: reuse them, saying so in the capture (changes what a capture is).
3. **A site that still refuses after the tries.** ⭐ **A:** stop with one plain line saying who refused what (the
   stylesheet's whole address, its status, the server's name, the refusal page's title) and what to do (wait a few
   minutes and run again; ask the site's owner to let this computer through or to switch the bot protection off while
   scanning), plus a log file of everything the site refused beside where the capture would go. B: also keep the ranges
   that were read for a later run to finish (a resumable capture: a new file format and a new command; not Mini).
4. **Pacing** (waiting longer or slowing down when refused). ⭐ **B: no change.** The real runs show the refusal is not
   a request-count limit (one window failed after fewer page loads than four windows), the host documents no rate limit,
   and a burst-limit fixture is already captured cleanly by the base. A: back off longer.
5. **No-store stylesheets** (a site that forbids caching its CSS): Chrome's DevTools then asks the site for each
   stylesheet's text again while a range is read, and a refusal there silently reads that range's code as longhands
   (probe below). ⭐ **B: a named follow-up**, not this job: bdryswi.com's evidence doesn't show it (its design width's code
   read normally on 11-09 while other loads were refused). A: also re-read such a range (a second rule, not Mini).
6. [amended A3] **A site that refuses every stylesheet from the first page load on.** ⭐ **A:** the capture is turned away
   (AC10's line and log) when every one of the page's own stylesheet links was refused in a page load and stays refused
   in its tries; one refused file among others that load keeps today's rule (a dead link, captured as visitors see it).
   B: keep saving it styleless (today: exit 0, nothing flags it). *Trade-off: a site that forbids every one of its own
   stylesheets to everyone (none known) can't be captured; it would look unstyled to every visitor anyway.*

## Playback (plain words)

1. On 2026-11-10 (Build 2026-11-10.7) Justin ran `npm run capture -- https://bdryswi.com/` twice. Both times he passed
   the site's "I am human" check in the window, the switch points were found, and then the capture stopped:
   `The page loads for widths 769–834 px never got the site's stylesheet https://bdryswi.com/_jb_static/ (answered 403)
   in 3 tries … Press Capture to try again.` With `--windows 1` it stopped the same way, at 1025–1366 px.
2. So there is no clean scan of that site to paste, upload or measure, and the one-command job (site-one-command) stops
   at its scan step the same way.
3. The terminal also told him to "Press Capture", a button that exists only in the Figma panel.

## Root cause

**Proven (code and local fixtures):**

- **R1. Once a page is kept for a kind of visitor, no later page load of the run asks the site for its page again, not
  even a retry.** capture-speed answers every later page load of a kind with the first good answer, inside the tab
  (`src/web/session.ts:173-179` `opts.store.turn(…)` → `answerFrom`; `src/web/replay.ts:62-77` `turn` returns the kept
  answer whenever one exists). A range that lacked a stylesheet is loaded again by `openStyled`
  (`src/web/styled.ts:186-218`: `o.open()` at line 194 for every try) through the same `openRange` →
  `openSession(…, store)` (`src/web/capture.ts:130-141`, `263-268`, `313-316`), so the two retries are answered from the
  kept page too. Only the page's own stylesheets, scripts, fonts and pictures still go to the site.
- **Reproduced on a local fixture** whose protection gives a pass that lasts a few seconds and can be earned only by a
  page load (a 403 "Checking your browser…" page that passes itself; every request without a fresh pass answered 403):
  the base stops with Justin's exact line, `… never got the site's stylesheet http://127.0.0.1:…/_jb_static/ (answered
  403) in 3 tries …`, at **901–1024** with 4 windows and at **1025–1200, the second range read**, with 1 window (Justin's
  `--windows 1` stopped at 1025–1366, also the second range). With every page load asking the site
  (`F2B_REPLAY=0`, as before capture-speed) the same fixture is captured cleanly (`base-expiry8-w4.json`,
  `base-expiry8-w1.json`, `base-expiry8-w4-askall.json`; Cacheable-but-Vary sheets: `base-vary-expiry8-w4.json`).
- **The other shapes the brief named, all survived by the base** (`base-cookie-w4.json`, `base-query-w4.json`,
  `base-count-w4.json`, `base-count-w1.json`):
  - a stylesheet refused without the cookie the page answer sets: every window sends it (one Chrome profile per launch,
    `test/browser/chrome.ts:335`; windows are `Target.createTarget newWindow` in its one browser context, `chrome.ts:264`;
    0 stylesheet requests without the cookie);
  - a stylesheet refused without its query: Chrome always asks `/_jb_static/??aaa111` (0 bare requests). **The query is
    dropped only in the printed line and the comparison key**: `src/web/styled.ts:57` `key: href.split("#")[0].split("?")[0]`
    (bdryswi's two bundles `/_jb_static/??f330d6c538` and `/_jb_static/??4794e1e2b5` share the key `/_jb_static/`);
  - a burst limit (403 once more than 6 stylesheet requests arrive within 2 s): 14 refused, read again alone, clean.
- **Chrome's HTTP cache is on** (nothing calls `Network.setCacheDisabled`): a stylesheet cacheable for a year is asked
  **once per scan** (2 requests in 8 page loads); one sent `no-store` is asked **twice per page load** (the page's own
  request plus DevTools' `CSS.enable` asking for its text again: 32 in 8); one cacheable but `Vary: Cookie`, beside a
  script that changes a cookie on each load, 10 in 8 (`none-*.json`).
- **The fix's rule, prototyped** (`proto1-R1.diff`: a retry asks the site for the page and its new good answer replaces
  the kept one): the fixture is captured **byte for byte equal** to a capture of the same fixture that refuses nothing,
  with 4 and with 1 window (`r1-vary-expiry8-w4.json`, `r1-vary-expiry8-w1.json`); a fixture that refuses nothing is
  captured byte for byte as the base captures it (`r1-vary-none-w4.json`, `p2-none-w4.json`).

**Evidence from Justin's own runs (read only), which the fixture shape follows:**

- 2026-11-07 (Build 2026-11-07.1, every range asked the site for its page, one after another, 44 min): "I am human" 5
  times in one scan, and the 1024-1024 and 769-834 page loads read a 403 page that reloaded itself
  (`~/Downloads/bdryswi-com-home.f2b-capture.json` notes; code read in 154 ms and 37 ms). **The site checks the same
  browser again partway through a scan, cookies held.**
- 2026-11-09 (capture-speed's build, 4 windows, kept pages; `~/f2b-test/bdryswi-com-home.f2b-capture.json`): the second
  batch of desktop ranges (922-991, 835-921, 769-834, 768-768: answered from the kept desktop page) holds a styleless
  reading (19,754 / 277 / 11 / 0 declarations against a styled run's differences; 1,291 shown elements against 1,120);
  the **first phone range, 601-767, whose page load asked the site** (the first of its kind), and every phone range
  after it are styled again. A page load that asks the site renews what a kept-page load can't.
- 2026-11-10: 4 windows stop at the seventh range read; 1 window at the second. One window made fewer page loads before
  failing than four did, so it is not a count of requests; both are a few minutes after the pass.
- The one read Justin allowed: `/_jb_static/` answered by `server: nginx`, `host-header: WordPress.com`, `x-ac: … _atomic_dca
  MISS`, `vary: Cookie` (`one-read-headers.txt`). The host's documentation: WordPress.com's defensive mode shows
  "Checking your browser…" and can be switched on for 1 hour to 7 days by the owner (Hosting Dashboard → Settings →
  Security → Defensive mode) or by the host's staff during an attack (then the owner can't switch it off)
  (https://wordpress.com/support/defensive-mode/); the same company's VIP docs: "Suspicious visits return a 403
  Forbidden HTTP status code", a browser solves the default challenge by itself, an interactive one needs a press,
  clients that can't run JavaScript get 403, and only logged-in users, an `Authorization` header or search crawlers skip
  it (https://docs.wpvip.com/security-controls/defensive-mode/). Neither documents how long a pass lasts or a rate limit.

**Suspicions (only Justin's next run proves them; AC9 and the log of AC6 are how):**

- S1 (strong): bdryswi.com's host gives a pass that runs out a few minutes after it was earned (or re-checks a visitor
  every few minutes), and only a page load meeting the check can earn a new one. Then, since capture-speed, every
  request after that moment (the stylesheets first, because they are the one thing the capture checks) is answered 403
  until the run ends, and the retries, answered from the kept page, can never meet the check.
- S2: the bundles are cacheable but vary by cookie (the `vary: Cookie` above; the site was asked for them again on later
  page loads, which a cached file wouldn't be). The log records each stylesheet's headers to settle it.
- S3 (weak, ruled out as the cause above): a request-count limit.

## How often one scan asks the site (base, from the code and the fixture logs)

- **Page itself:** the switch-point search's page load, then one per kind of visitor (desktop, phone) for a public site
  (kept page); a page load meeting a check adds the check page plus the page again. On bdryswi.com: about 2–4 page
  requests a scan (11-07's build: 17 or more). The retries add none today (R1): that is the bug.
- **Each stylesheet:** once per page load that hasn't it in Chrome's cache: the search's, the design width's and one
  per range (16 ranges on bdryswi.com: up to about 18 page loads, plus 2 retries per range that lacked it), and DevTools
  asks again for its text where Chrome kept none (no-store: twice per page load). A person resizing a browser asks once.
- **Windows:** one Chrome, one profile, one cookie jar and one cache for every window (and for the person's pass);
  pacing: up to 4 page loads opening together, a range that lacked a stylesheet loaded again alone after 30 s, then 30 s,
  each try the same address with the same cookies.

## Acceptance criteria (proposed; each test name is whole on its line)

- AC1 (proposed): on a local fixture whose check comes back partway (a pass of 8 s or 5 s that only a page load can earn), the capture ends clean with 4 windows and with 1, and equals a capture of the same fixture that refuses nothing; test `test/web/capture-refused.test.ts` › "AC1 a site whose check comes back partway is captured as one that never refused".
  Also [amended A4]: `test/web/capture-refused.test.ts` › "AC1 the switch-point search made again after a stylesheet wait asks the site for its page".
- AC2 (proposed): on a fixture that keeps refusing its stylesheets, `npm run capture` exits 1 with one `Failed:` line naming who refused what (whole address with its query, HTTP status, the server's name, the refusal page's title) and what to do in the command's own words, a `What the site answered:` line naming the log file (each refused request's address, status, headers without cookies, first 300 bytes; the scan's page loads asked and kept), and no capture file; test `test/web/capture-refused.test.ts` › "AC2 a site that keeps refusing stops the command with what answered and what to do".
  Also [amended A5]: `test/unit/capture-asked.test.ts` › "AC2 the log keeps no cookie, no Authorization header and no secret-looking query value" and `test/unit/capture-asked.test.ts` › "AC2 the log keeps only the site's own refusals, the first 300 bytes of each".
- AC3 (proposed) [amended A2]: a site that refuses nothing (the edge fixture open, `basic`, `code-page`; kept pages on and off) is captured byte for byte as the base captures it in every round (timings, capturedAt and build aside); over the rounds the head asks each address of the site no more often than the base (per address, summed); and it is no slower: in 5 rounds per site and mode, base and head back to back with the order alternating, the median of all 30 paired head/base time ratios is at most 1.10, and no site and mode has all 5 of its ratios above 1.10; test `test/web/capture-refused-same.test.ts` › "AC3 a site that refuses nothing is captured as before, as often asked and as fast".
- AC4 (proposed): the panel's helper route passes the same returning check and, on a site that keeps refusing, fails with the same line in the panel's words ("press Capture to try again", nothing about `npm run`); test `test/web/capture-refused.test.ts` › "AC4 the panel's helper route passes the check again and stops in the panel's words".
- AC5 (proposed): the command's other stop lines end with what to type (`Run npm run capture -- <address> again.`) while the panel's errors keep their words; test `test/web/capture-refused.test.ts` › "AC5 the command's stop lines say what to type, the panel's keep its words".
  Also [amended A5]: `test/web/capture-unreachable.test.ts` › "R1-2 --all: an unreachable page prints its one line and no later page is tried" (the command's words, the panel's text unchanged).
- AC6 (proposed) [amended A1]: a capture in which the site refused one of the page's own files (a stylesheet, script, font, picture or media file of its own host) still saves its file and prints `The site refused N requests on the way (HTTP 403); what it answered: <log>` (N: every refused request the log holds, of any kind); a capture whose only refusals were check pages and Chrome's own requests prints no such line and writes no log; test `test/web/capture-refused.test.ts` › "AC6 a capture the site refused on the way leaves the log of what it refused beside its file".
  Also [amended A1]: `test/web/human-check.test.ts` › "AC3 after the pass every load stays in the Chrome that passed, which closes at the end" (unchanged: its `--out` folder holds exactly the two captures).
- AC7 (proposed): nothing hides the automation: Chrome's switches, `navigator.webdriver` and the user agent are as before; test `test/web/human-check.test.ts` › "AC5 nothing hidden: visible flags, webdriver and user agent as the plain launch's".
- AC8 (proposed) [amended A1]: the gates pass as on the base: `npm run check`, and the web suites named in Task 9 with the base's tallies by test name (`human-check` 7 pass + 1 skipped, unchanged); test `npm run check` plus the Task 9 list.
- AC9 (proposed) (live): Justin's own `npm run capture -- https://bdryswi.com/` on the desktop ends with a capture `npm run capture:check` calls `ok`, or with the plain refusal line and its log file naming what refused it; test: Justin's run (paste check 3dw).
- AC10 (proposed) [amended A3]: a site that refuses every one of its own stylesheets from the first page load on stops `npm run capture` with exit 1, the refusal line of AC2 (the command's words), its `What the site answered:` log and no capture file, where it was saved styleless with exit 0; test `test/web/capture-refused.test.ts` › "AC10 a site that refuses every stylesheet from the first page load stops the command with the refusal line".

**RED on base** (the three test files applied alone to a clean `git archive` of `7ec16d60`, byte for byte the base's
files on `11e885fd`; receipt `red-base-all.tap`, 0 of 5 pass): AC1 throws `The page loads for widths 768–900 px never
got the site's stylesheet http://127.0.0.1:…/_jb_static/ (answered 403) in 3 tries …`; AC2's `Failed:` line is the old
`The page loads for widths 901–1024 px never got … Press Capture to try again.`; AC4's helper job ends `failed` where
`done` is wanted; AC5's line ends `Press Capture to try again.`; AC6 exits 1 (no capture). AC3 is a regression guard
(green on base by construction). **GREEN of the rule alone:** AC1 passes on base + `proto1-R1.diff` (`green-proto1-ac1.tap`,
107 s). **GREEN of the whole plan:** every planned test on the planner's full prototype (base + Tasks 2–6 exactly as the
code below): AC1, AC2, AC5, AC6 pass (`green-pfull-all.tap`; AC4 there failed on a fixture counter bug, since fixed:
`set({ after })` now counts from the set), AC4 and AC6 pass again with the fixed fixture (`green-pfull-ac4.tap`), and AC4
stays RED on base with it (`red-base-ac4.tap`). AC3 on the prototype against a base export at the same build passes
(`ac3-pfull-vs-base.tap`: 3 sites, kept pages on and off, 3 interleaved rounds, byte for byte, as often asked, within the
margin; a first run against the `11e885fd` export differed only in `build`, which the test now leaves aside:
`ac3-pfull-vs-base2.tap`).

## Approach (the general rule, nothing keyed on a site or a host)

1. **A retry asks the site.** When a page load lacked a stylesheet the reference applied, each later try of that range
   (and of the design width, and the search again after a stylesheet wait) is a page load **asking the site for its
   page**, never the kept page; its new good answer replaces the kept one for its kind. Everything else is as today: the
   30 s waits, "alone", 3 tries, the check rules (a check the person must press waits in the window as at the start).
2. **Who refused what.** One recorder per capture (`src/web/asked.ts`) watches each page load's own-site requests
   (Network events; a stylesheet's answer body read at Fetch's Response stage, the only place Chrome still has it:
   `fetch-refused-sheet-body.txt`, `events-refused-sheet.txt`) and counts page loads asked and kept. When the capture
   stops because a stylesheet was **refused** (401, 403 or 429), the line names the host, the whole address, the status,
   the server, the refusal page's title, the tries and what to do. A 503 (a server fault) keeps the old line.
3. **The command's words.** `npm run capture` turns "press Capture to try again" into `run npm run capture -- <address>
   again` in every stop line it prints; the panel and the helper keep theirs. The command writes the log
   `<out>/<name>.f2b-refused.json` when the capture failed with something refused, or when the site refused any request
   but the page itself on the way, and names it in one line.
   [amended A1] "Anything but the page itself" is exactly: a refused request of the kinds the page asks for itself,
   `Stylesheet`, `Script`, `Font`, `Image` or `Media`, of the site's own host (the recorder's `type`, as `lost.ts` names
   them). The page's own refusals (`Document`: a check met and passed) and everything else (`Other`: Chrome's own
   `/favicon.ico` of a check page; `Fetch`, `XHR`, `Ping`: a script's calls) never trigger the line or the log after a
   saved capture; when the log is written (that trigger, or a failed capture with anything refused) it holds every
   refused request of every kind, so Justin's run still shows the check pages and the favicon.
4. [amended A3] **A page turned away from the start.** In `openStyled`, a page load that lacks nothing the reference
   applied but whose own stylesheet links (the page's origin; switched-off alternates aside) are at least one and were
   **all** answered 401, 403 or 429 counts as lacking the first of them (`answered 403`): it is read again asking the site
   (A's rule), and still so after the tries the capture stops with AC2's refusal line and the log. The design width's
   page load goes through `openStyled`, so a site refusing from its very first page load stops there. One refused file
   among stylesheets that load keeps today's rule (refused in two loads apart it is the site's own dead link).

## Files and conflicts with the jobs beside it

- `src/web/replay.ts` (turn's `fresh`; the stylesheet Response-stage pattern), `src/web/session.ts` (options `fresh`,
  `requests`), `src/web/styled.ts` (`open(fresh)`, the error fields, `SiteRefused`, `refusedText`), `src/web/capture.ts`
  (four call lines, the recorder, the stop conversion), `src/web/discover.ts` (options `fresh`, `requests`), new
  `src/web/asked.ts`, `tools/lib/capture-pages.ts` (`one()`'s first lines, its two failure lines, one line after
  `Took`, `PagesOptions.again`), new `tools/lib/capture-refused.ts`; tests and the
  fixture `test/fixtures/web/edge-site.ts` (new); `test/web/capture-styled-ranges.test.ts` (its three CLI lines'
  last sentence).
- **site-menu** (`site-menu-fix6`) changes `src/web/capture.ts` at other lines (imports, `CaptureOptions.opens`,
  `launchCaptureChrome`, the `Got` type, the opens readings) and `test/fixtures/web/styled-site.ts`: this job keeps out of
  both (its own fixture; its capture.ts lines are `openRange`, `openDesign`'s and a range's `open`, `search`/`searchAgain`
  and the final `catch`). A rebase may meet the imports and `CaptureOptions` (both add lines there): keep both.
- **site-one-command** (`site-one-command-build`) turns `one()` in `tools/lib/capture-pages.ts` into `capturePage` and
  moves the launch into `tools/lib/capture-run.ts`: this job's command-side code lives in its own
  `tools/lib/capture-refused.ts`, called from three lines of `one()`'s body, so whichever merges second moves those three
  lines into `capturePage`; `site:import` then gets the fix (it is in `src/web/`), the log and the words through
  `capturePage` (its own command in place of `npm run capture` is its job's choice: `PagesOptions.again`, below).
- **footer-icon-list** (`src/web/read/code*.ts`): not touched.

## Tasks (test first; one commit a task, each green but where said)

Commands below run in the copy with `export PATH=/home/justin/.local/node-v22.23.3/bin:$PATH`,
`TMPDIR=/home/justin/.cache/crs-b/t1`, `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`, each Chrome run
under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

0. Copy this plan to `docs/plans/2026-11-10-capture-refused-styles.md`; start the ledger
   `.superpowers/sdd/2026-11-10-capture-refused-styles/progress.md`; `npm run check` and `npm run corpus` before Task 1
   (keep the numbers).

1. **The fixture and the tests, RED.** Add `test/fixtures/web/edge-site.ts`, `test/web/capture-refused.test.ts` and
   `test/web/capture-refused-same.test.ts` exactly as in "Test code" below. Run
   `node --test --test-concurrency=1 test/web/capture-refused.test.ts`: AC1, AC2, AC4, AC5 and AC6 fail as the RED
   receipt says (on the base the AC1 capture throws `UnstyledRange … (answered 403) in 3 tries`). Commit "capture-refused
   tests (RED)" (the one commit that is red).

2. **The rule (AC1).** `src/web/replay.ts`: `turn(kind: Kind, fresh = false)`; `if (a && !fresh) return { answer: a };`
   (a fresh turn waits for a turn already asking, then asks; `keep` already replaces the kept answer). `session.ts`:
   `SessionOptions` gains `fresh?: boolean` (comment: "a page load asking the site for its page even when one is kept for
   its kind: a range read again after it lacked a stylesheet (capture-refused-styles)") and
   `opts.store.turn(opts.phone ? "phone" : "desktop", opts.fresh === true)`. `styled.ts`: `StyledOpen.open: (fresh:
   boolean) => Promise<Session>` and `first ?? await o.open(n > 0)`. `capture.ts`: `openRange(r, inWindow, fresh =
   false)` passing `fresh` to `openSession`; `openDesign`'s `open: async (fresh) => { const s = await openRange(r, false,
   fresh); …`; a range's `open: async (fresh) => await openRange(r, windows > 1, fresh) as Session`;
   `const search = (fresh = false) => discover(…, { …, fresh })` and in the `SearchAgain` catch `await searchAgain(e.wait
   > 0)` with `searchAgain(fresh = false)` calling `search(fresh)`; `discover.ts`: `DiscoverOptions.fresh?: boolean`
   passed to its `openSession`. (Exactly `proto1-R1.diff` plus the search's two lines.) AC1 green; run
   `capture-styled-ranges`, `capture-styled-loads`, `capture-replay`, `human-once` (they count page loads). Commit.

3. **The recorder.** New `src/web/asked.ts` (Code below). `session.ts`: `SessionOptions.requests?: SiteRequests`; after
   `s.offs.push(watch.off);`, `if (opts.requests) s.offs.push(await opts.requests.watch(page, host));`; at the top of each
   pass of the load loop (after `watch.reset();`) `opts.requests?.pageLoad(!!kept);`; `answerFrom(page, kept,
   opts.requests?.sheet)` and `recordTo(page, (a) => { heard = a; opts.requests?.answered(a); }, opts.requests?.sheet)`.
   `replay.ts`: the stylesheet hook (Code below). `capture.ts`: `CaptureOptions.requests?: SiteRequests`, `const requests
   = opts.requests ?? new SiteRequests(opts.url);` above `search`, passed to `openSession` in `openRange` and to
   `discover`; `discover.ts`: `DiscoverOptions.requests` to its `openSession`. AC3 must stay green here (run it:
   `F2B_BASE_TREE=<a git archive of 11e885fd with node_modules linked> node --test test/web/capture-refused-same.test.ts`).
   Commit.

4. **The line (AC2's and AC4's text).** `styled.ts`: the error fields and `refusedText`, `SiteRefused`, `refusalOf` (Code
   below). `capture.ts`: the outer `catch (e) { closing = true; throw e; }` (after the kept loads' check) becomes
   `catch (e) { closing = true; throw refusalOf(e, requests, typed); }`. AC4 green. Commit.

5. **The command's words and log (AC2, AC5, AC6).** New `tools/lib/capture-refused.ts`; `tools/lib/capture-pages.ts`
   `one()` as in Code below. In `test/web/capture-styled-ranges.test.ts`, the three CLI cases' expected last sentence
   `Press Capture to try again\\.` becomes `Run npm run capture -- ${literal(fx.site + "/")} again\\.` (the `RANGE_LINE`
   helper and the search case's `line` take the site, as `SHEET` is filled in now). AC2, AC5, AC6 green. Commit.

6. **The panel's words stay** (no code): `src/web/helper/job.ts` shows `e.message`, the panel's words, unchanged; AC4
   proves it. The tests that pin `e.message` (`capture-retry`, `capture-styled-loads`, `web-styled-open`, `human-check`,
   `human-reload`) stay as they are.

7. **The other suites.** Run Task 9's list; a test pinning a page-load or stylesheet count that the rule changes only
   when something was refused is the expected kind; anything else: stop and report (never weaken it).

8. **Docs & records.** HANDOFF section above the top `## ` heading ("A site's check that comes back partway is passed
   again (capture-refused-styles, website importer; build set at the merge; paste check 3dw owed)") and its end-of-run
   entry at the top of "End-of-run check list" (3dw: AC9); the ledger; the known limit (Question 5) and follow-ups;
   BUILD left alone; CLAUDE.md lines for the finisher (Status line; and the standing rule "A page load retried after it
   lacked a stylesheet asks the site for its page itself, never the kept page (capture-refused-styles)" beside the
   "Website captures" decisions).

9. **Gates (AC8).** [amended A1] (Run again after Tasks 10–13.) `npm run check`; `npm run corpus` (no file worse); web suites, each alone:
   `capture-refused`, `capture-styled-ranges`, `capture-styled-loads`, `capture-replay`, `capture-retry`, `capture-lost`,
   `capture-steady`, `capture-unreachable`, `capture-windows`, `capture-cli`, `capture-person-front`, `human-check`,
   `human-once`, `human-reload`, `helper-capture`, `helper-windows`; AC3 named. Base tallies (a clean export of `11e885fd`,
   2026-11-10, `tallies-base2/summary.txt`, every file exit 0, no failure): `capture-styled-ranges` 10 pass,
   `capture-styled-loads` 6, `capture-replay` 3, `capture-retry` 5, `capture-lost` 3, `capture-steady` 9,
   `capture-unreachable` 2, `capture-windows` 2, `capture-cli` 6, `capture-person-front` 2, `human-check` 7 pass + 1
   skipped (the opt-in visible window, `F2B_VISIBLE_CHROME=1`), `human-once` 3, `human-reload` 6, `helper-capture` 1,
   `helper-windows` 1; `npm run check` 3538 + 2 pass, 0 fail. The head's tallies must equal these by test name, plus
   `capture-refused`'s 5 (AC3 named only).

10. [amended A1] **The trigger** (on the branch, from `60f1cea5`). In `tools/lib/capture-refused.ts`, `refusedLine`'s
    condition `requests.refused.some((r) => r.type !== "Document")` becomes `requests.refused.some((r) =>
    PAGE_OWN.has(r.type))` with `const PAGE_OWN = new Set(["Stylesheet", "Script", "Font", "Image", "Media"]);` and its
    comment (Code, "Amendment code"). RED first: `human-check.test.ts` "AC3 after the pass every load stays in the Chrome
    that passed, which closes at the end" fails on `993d80b4` (its `--out` listing holds `-home.f2b-refused.json`:
    `builder/probes/check-all-log.log`); GREEN after. AC6 and AC2 stay green. Commit.

11. [amended A3] **The first-load rule.** Append the two new tests (Test code, "Amendment tests") to
    `test/web/capture-refused.test.ts`; AC10 fails on `993d80b4` (exit 0, a styleless capture), the AC1 search test
    passes there (Task 2's rule) and fails with M05 applied. Then `turnedAway` in `src/web/styled.ts` and its three
    lines in `openStyled` (Code, "Amendment code"). AC10 green; AC1–AC6 and `capture-styled-ranges`,
    `capture-styled-loads` green (a 503 dead link is still captured as it is: their "dead in every load" cases). Commit.

12. [amended A2] **AC3's new proof.** Replace `test/web/capture-refused-same.test.ts` with the amended file (Test code);
    run it once against a clean export of `11e885fd` (`F2B_BASE_TREE`), about 60 captures, 20–45 min on the desktop.
    Record its printed tables and the pooled median in the ledger. Commit.

13. [amended A5] **Records.** HANDOFF: the trigger's wording, the first-load rule (Q6) and its limit; the ledger: the
    amendment, M05 closed by the AC1 search test (re-run M05 against it: it must fail), the receipts. Commit.

## Code

The whole change is the planner's prototype, proven by the GREEN run above: **`pfull-src.diff` and `pfull-tools.diff`**
in the evidence folder (`git apply -p1` from the repo root; the builder may type it task by task instead, but the result
is these bytes plus Task 8's docs). The new files and blocks, in full:

### `src/web/asked.ts` (new)

```ts
// What one capture asked the site and what the site refused (capture-refused-styles): the page loads that asked the
// site for its page and those answered from the kept page (replay.ts), the site's own requests by kind (asked, from
// Chrome's cache, refused), and every refused one: its whole address (a secret-looking query value hidden), status,
// response headers without cookies, and the first 300 bytes of its answer where Chrome still has them (a stylesheet's,
// read at Fetch's Response stage; the page's own, as the tab heard it). Refused: an error answer that isn't "missing"
// (not 404 or 410). The site's own: the typed host or a host one of its page loads went to, www. aside (as lost.ts).
import type { Page } from "../../test/browser/chrome.ts";
import type { Answer } from "./replay.ts";
import { BUILD } from "../shared/build.ts";

export interface RefusedRequest { at: number; url: string; type: string; status: number; headers: Record<string, string>; body: string | null }
export type SheetHook = (q: { url: string; status: number; headers: Array<{ name: string; value: string }>; body: string | null }) => void;

const bare = (h: string) => h.toLowerCase().replace(/^www\./, "");
const PRIVATE_HEADER = /^(set-cookie|cookie|authorization|proxy-authorization)$/i;
const SECRET = /token|key|sig|secret|pass|auth|session|nonce|code/i;
export const refusing = (status: number): boolean => status >= 400 && status !== 404 && status !== 410;

// an address as the log keeps it: a secret-looking query value hidden (a combined file's ??list kept as it is)
export function logged(url: string): string {
  try {
    const u = new URL(url);
    if (u.search.startsWith("??")) return url;
    for (const k of [...u.searchParams.keys()]) if (SECRET.test(k)) u.searchParams.set(k, "…");
    return u.href;
  } catch {
    return url;
  }
}

export class SiteRequests {
  readonly address: string;
  readonly started = Date.now();
  readonly loads = { asked: 0, kept: 0 };
  readonly requests: Record<string, { asked: number; cached: number; refused: number }> = {};
  readonly refused: RefusedRequest[] = [];
  private readonly hosts: string[];
  constructor(address: string) { this.address = address; this.hosts = [new URL(address).host]; }

  private own(url: string): boolean { try { const h = bare(new URL(url).host); return this.hosts.some((x) => bare(x) === h); } catch { return false; } }
  private kind(type: string) { return (this.requests[type] ??= { asked: 0, cached: 0, refused: 0 }); }
  private add(url: string, type: string, status: number, headers: Record<string, string>, body: string | null): void {
    this.refused.push({ at: Date.now() - this.started, url: logged(url), type, status, headers: Object.fromEntries(Object.entries(headers).filter(([k]) => !PRIVATE_HEADER.test(k))), body });
    this.kind(type).refused++;
  }

  pageLoad(kept: boolean): void { if (kept) this.loads.kept++; else this.loads.asked++; }

  // the page's own answer as the tab heard it (replay.ts recordTo): an error answer's first bytes
  answered(a: Answer): void {
    if (!refusing(a.status)) return;
    const r = [...this.refused].reverse().find((x) => x.type === "Document" && x.url === logged(a.url) && x.body === null);
    if (r) r.body = Buffer.from(a.body, "base64").toString("utf8").slice(0, 300);
  }

  // a stylesheet's answer at Fetch's Response stage (replay.ts): the page's own request and DevTools' asking for its text
  readonly sheet: SheetHook = (q) => {
    if (!this.own(q.url) || !refusing(q.status)) return;
    this.add(q.url, "Stylesheet", q.status, Object.fromEntries(q.headers.map((h) => [h.name.toLowerCase(), h.value])), q.body === null ? null : q.body.slice(0, 300));
  };

  // one page load's tab: its own-site requests counted, every refused one but a stylesheet's (the sheet hook has those)
  async watch(page: Page, typedHost: string): Promise<() => void> {
    if (!this.hosts.includes(typedHost)) this.hosts.push(typedHost);
    const types = new Map<string, string>();
    const offs = [
      page.on("Network.requestWillBeSent", (q: { requestId: string; type?: string; request: { url: string } }) => {
        if (q.type === "Document") { try { const h = new URL(q.request.url).host; if (!this.hosts.includes(h)) this.hosts.push(h); } catch { /* not an address */ } }
        if (!this.own(q.request.url)) return;
        types.set(q.requestId, q.type ?? "Other");
        this.kind(q.type ?? "Other").asked++;
      }),
      page.on("Network.requestServedFromCache", (q: { requestId: string }) => { const t = types.get(q.requestId); if (t) this.kind(t).cached++; }),
      page.on("Network.responseReceived", (q: { requestId: string; type?: string; response: { url: string; status: number; headers: Record<string, string> } }) => {
        const type = types.get(q.requestId) ?? q.type ?? "Other";
        types.delete(q.requestId);
        if (type === "Stylesheet" || !this.own(q.response.url) || !refusing(q.response.status)) return;
        this.add(q.response.url, type, q.response.status, Object.fromEntries(Object.entries(q.response.headers).map(([k, v]) => [k.toLowerCase(), v])), null);
      }),
    ];
    return () => { for (const o of offs) o(); };
  }

  // the log the command writes (tools/lib/capture-refused.ts)
  toJSON(): object {
    return { address: this.address, build: BUILD, startedAt: new Date(this.started).toISOString(), loads: this.loads, requests: this.requests, refused: this.refused };
  }
}
```

### `src/web/replay.ts` (appended; `answerFrom(page, a, sheets?: SheetHook)` and `recordTo(page, heard, sheets?: SheetHook)` call `if (sheetAnswer(page, q, sheets)) return;` first in their listener and add `...(sheets ? [SHEETS] : [])` to their `Fetch.enable` patterns; `import type { SheetHook } from "./asked.ts";`)

```ts
// capture-refused-styles: every stylesheet's answer is paused once at Fetch's Response stage (the only place Chrome still
// holds a refused one's body) and told to the hook; true when q was such an answer (it is let go on at once)
const SHEETS = { urlPattern: "*", resourceType: "Stylesheet", requestStage: "Response" };
function sheetAnswer(page: Page, q: Paused, sheets: SheetHook | undefined): boolean {
  if (!sheets || q.resourceType !== "Stylesheet" || (q.responseStatusCode === undefined && !q.responseErrorReason)) return false;
  void (async () => {
    const status = q.responseStatusCode ?? 0;
    // an error answer's body is read before it goes on (afterwards Chrome drops it)
    const body = status >= 400 ? await bodyOf(page, q.requestId).catch(() => null) : null;
    sheets({ url: q.request.url, status, headers: q.responseHeaders ?? [], body });
    await page.cdp("Fetch.continueResponse", { requestId: q.requestId }).catch(() => page.cdp("Fetch.continueRequest", { requestId: q.requestId }).catch(() => undefined));
  })();
  return true;
}
async function bodyOf(page: Page, requestId: string): Promise<string> {
  const b = await page.cdp<{ body: string; base64Encoded: boolean }>("Fetch.getResponseBody", { requestId });
  return b.base64Encoded ? Buffer.from(b.body, "base64").toString("utf8") : b.body;
}
```

### `src/web/styled.ts` (appended; `import type { SiteRequests } from "./asked.ts";`)

`UnstyledRange` gains `readonly sheet: Lack; readonly loads: number; readonly span: Pick<WebRange, "min" | "max">;`, set
in its constructor (`this.sheet = sheet; this.loads = loads; this.span = { min: r.min, max: r.max };`); `UnstyledSearch`
`readonly sheet: Lack; readonly loads: number;`. Every message is unchanged byte for byte.

```ts
// capture-refused-styles Q3 A: a stylesheet the site answered with a refusal (the protection's own statuses), not a
// fault (a 503 keeps its old line): who refused what, and what a person can do (the panel's words; the command swaps
// its "press Capture to try again" for what to type: tools/lib/capture-refused.ts)
const REFUSAL = /^answered (401|403|429)$/;
const titleOf = (body: string | null): string => (body ? /<title[^>]*>([^<]{1,80})<\/title>/i.exec(body)?.[1].trim() ?? "" : "");
export const refusedText = (host: string, url: string, status: string, server: string, title: string, where: string, loads: number) =>
  `${host} turned the capture away: it answered the stylesheet ${url} with HTTP ${status}${server ? ` (${server})` : ""}${title ? `, "${title}"` : ""}, ${where} in ${loads} tries, the last asking the site for its page again, so nothing was captured. Wait a few minutes and press Capture to try again; if it keeps happening, ask the site's owner to let this computer through, or to switch its bot protection off while you capture.`;

export class SiteRefused extends Unstyled {
  constructor(message: string) {
    super(message);
    this.name = "SiteRefused";
  }
}

// a stop because a stylesheet was refused becomes SiteRefused, named from the run's own record of the answer (its whole
// address, server, title); anything else is returned as it is
export function refusalOf(e: unknown, requests: SiteRequests, host: string): unknown {
  const lack = e instanceof UnstyledRange && e.loads > 0 ? { sheet: e.sheet, loads: e.loads, where: `on the page loads for widths ${widthsOf(e.span)} px` }
    : e instanceof UnstyledSearch ? { sheet: e.sheet, loads: e.loads, where: "on the page load that finds where the page changes" } : null;
  if (!lack || !REFUSAL.test(lack.sheet.why)) return e;
  const key = (u: string) => u.split("#")[0].split("?")[0];
  const r = [...requests.refused].reverse().find((x) => x.type === "Stylesheet" && key(x.url) === lack.sheet.key);
  return new SiteRefused(refusedText(host, r?.url ?? lack.sheet.key, lack.sheet.why.slice("answered ".length), r?.headers.server ?? "", titleOf(r?.body ?? null), lack.where, lack.loads));
}
```

### `tools/lib/capture-refused.ts` (new)

```ts
// `npm run capture`'s side of capture-refused-styles: its stop lines say what to type (the panel's "press Capture to
// try again" becomes "run <command> again"), and the log of what the site refused, written beside where the capture
// goes when the capture failed with something refused or the site refused anything but the page itself on the way.
import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import type { SiteRequests } from "../../src/web/asked.ts";
import { captureName } from "../../src/web/pages.ts";

export const cliWords = (message: string, again: string): string =>
  message.replace(/\b([Pp])ress Capture to try again/g, (_m, p: string) => `${p === "P" ? "R" : "r"}un ${again} again`);

const logPath = (out: string, url: string) => join(out, captureName(url).replace(/\.f2b-capture\.json$/, "") + ".f2b-refused.json");

// the log, when the site refused anything in the run; its path, else null
export function writeRefused(out: string, url: string, requests: SiteRequests): string | null {
  if (!requests.refused.length) return null;
  mkdirSync(out, { recursive: true });
  const file = logPath(out, url);
  writeFileSync(file, JSON.stringify(requests, null, 1));
  return file;
}

// after a saved capture: one line when the site refused anything but the page itself on the way
export function refusedLine(out: string, url: string, requests: SiteRequests): string | null {
  if (!requests.refused.some((r) => r.type !== "Document")) return null;
  const file = writeRefused(out, url, requests)!;
  const n = requests.refused.length;
  const statuses = [...new Set(requests.refused.map((r) => r.status))].sort().join(", ");
  return `The site refused ${n} request${n === 1 ? "" : "s"} on the way (HTTP ${statuses}); what it answered: ${file}`;
}
```

### `tools/lib/capture-pages.ts` `one()`: its first lines; `requests` added to `run.capture({ … })`; after the `Took` line `const refused = refusedLine(o.out, url, requests); if (refused) print.log(refused);`; the two `print.error(\`Failed: ${url}: ${e.message}\`)` of `HumanCheckFailed`/`PageUnreachable` and `Unstyled` become `fail(e.message)`; `PagesOptions` gains `again?: string`

```ts
  print.log(`Capturing ${url}`);
  // capture-refused-styles: what the site refused (the log), and the command a person types to run this again
  const requests = new SiteRequests(url);
  const again = o.again ?? `npm run capture -- ${o.url}`;
  const fail = (message: string) => {
    print.error(`Failed: ${url}: ${cliWords(message, again)}`);
    const file = writeRefused(o.out, url, requests);
    if (file) print.error(`What the site answered: ${file}`);
  };
```

### Amendment code [amended A1, A3]

`tools/lib/capture-refused.ts`: above `refusedLine`, and its first line:

```ts
// the kinds a page asks for itself (lost.ts's, the page aside): Chrome's own requests (a check page's /favicon.ico is
// "Other") and the page itself (a check met and passed) never trigger the line; the log, when written, keeps them all
const PAGE_OWN = new Set(["Stylesheet", "Script", "Font", "Image", "Media"]);

// after a saved capture: one line when the site refused one of the page's own files on the way (amendment A1)
export function refusedLine(out: string, url: string, requests: SiteRequests): string | null {
  if (!requests.refused.some((r) => PAGE_OWN.has(r.type))) return null;
```

`src/web/styled.ts`: in `openStyled`, right after `missing = unstyledLoad(got.sheets, [...(o.seen?.() ?? []), ...tries], reference);`

```ts
      // capture-refused-styles amendment A3: a page load whose own stylesheets the site refused, every one of them, is
      // the site turning the capture away, never its dead links (even when the reference was turned away alike)
      const turned = missing.length ? null : turnedAway(got.sheets, got.s.finalUrl);
      if (turned) missing = [turned];
```

and, appended:

```ts
// capture-refused-styles amendment A3: the site's own stylesheet links (the page's origin; switched-off alternates left
// out) when there is at least one and the site refused every one (401, 403, 429): the first, as a lacking sheet
const REFUSED_STATUS = new Set([401, 403, 429]);
export function turnedAway(sheets: WebSheets, pageUrl: string): Lack | null {
  const originOf = (u: string): string | null => { try { return new URL(u).origin; } catch { return null; } };
  const own = sheets.links.filter((l) => !l.disabled && originOf(l.key) !== null && originOf(l.key) === originOf(pageUrl));
  if (!own.length || !own.every((l) => REFUSED_STATUS.has(l.status))) return null;
  return { key: own[0].key, why: `answered ${own[0].status}` };
}
```

## Test code

The three files, byte for byte as the RED and GREEN runs used them, are kept in the evidence folder:
`~/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/planner/plan-code/test/` (`fixtures/web/edge-site.ts`,
`web/capture-refused.test.ts`, `web/capture-refused-same.test.ts`); copy them into the copy's `test/`. What they hold:
the fixture's protection modes (`open`, `recheck` with `passMs`, `refuse` with `after`, `fail`) and its two combined
stylesheets at one path told apart by their query (cacheable for a year, `Vary: Cookie`, beside a script that sets a
cookie on each load: the shape bdryswi.com's evidence points to, S2); AC1 asserts that the site really turned stylesheet
requests away in each case (a run with no refusal proves nothing) and compares whole captures (`timeless`); AC2–AC6 are
as their AC lines say; AC3 runs only with `F2B_BASE_TREE`.

### Amendment tests [amended A2, A3, A4]

Appended to `test/web/capture-refused.test.ts` (it already imports everything they use):

```ts
// amendment A4 (M05): the switch-point search made again after a stylesheet wait asks the site for its page, never the
// kept page. The styled fixture's stylesheet fails in the 1st page load only (the search's); its phone page links
// /phone.css, so a page load's kind shows in what it asked. The design width's first load is answered from the kept
// page (the search's HTML: its stylesheet fails again), read again asking the site (load 2, styled), and the search is
// then made again: asking the site, it is page load 3 and a desktop one; answered from the kept page, load 3 would be
// the first phone range's.
test("AC1 the switch-point search made again after a stylesheet wait asks the site for its page", { skip: chromeSkip, timeout: 600000 }, async () => {
  const fx = await serveStyledSite({ answer: (load) => (load === 1 ? "fail" : "ok"), phone: "own" });
  try {
    await local(() => captureSite({ url: fx.site + "/", fontSource: noFonts, shots: false, windows: 4, retryMs: [2000, 2000], styleRetryMs: [1000, 1000] }));
    const third = fx.asked.filter((a) => a.load === 3).map((a) => a.sheet);
    assert.ok(third.length > 0 && third.every((s) => s === "/style.css"), `page load 3 asked ${JSON.stringify(third)}; every request: ${fx.asked.map((a) => `${a.load} ${a.sheet} ${a.answer}`).join(", ")}`);
  } finally {
    await fx.close();
  }
});

// amendment A3: a site that refuses every one of its own stylesheets from the first page load on (no load ever gets
// one) is turned away, never captured styleless as if the stylesheets were dead links
test("AC10 a site that refuses every stylesheet from the first page load stops the command with the refusal line", { skip: chromeSkip, timeout: 600000 }, async () => {
  const fx = await serveEdgeSite({ mode: "refuse", after: 0 });
  const dir = mkdtempSync(join(tmpdir(), "f2b-ref0-"));
  try {
    const out = join(dir, "out");
    const r = await cli([fx.url, "--owned", "--out", out, "--no-shots"], cliEnv(dir, fx.url));
    assert.equal(r.code, 1, r.out + r.err);
    const failed = r.err.split("\n").filter((l) => l.startsWith("Failed: "));
    assert.equal(failed.length, 1, r.err);
    assert.match(failed[0], new RegExp(`^Failed: ${literal(fx.url)}: ${literal(fx.host)} turned the capture away: it answered the stylesheet ${literal(fx.url)}_jb_static/\\?\\?(aaa111|bbb222) with HTTP 403 \\(nginx\\), "Checking your browser…", on the page loads? (for widths \\d+(–\\d+| and wider)? px|that finds where the page changes) in 3 tries, the last asking the site for its page again, so nothing was captured\\. Wait a few minutes and run npm run capture -- ${literal(fx.url)} again; if it keeps happening, ask the site's owner to let this computer through, or to switch its bot protection off while you capture\\.$`));
    assert.match(r.err, /^What the site answered: .+\.f2b-refused\.json$/m);
    assert.deepEqual(existsSync(out) ? readdirSync(out).filter((f) => f.endsWith(".f2b-capture.json")) : [], [], "no capture file");
  } finally {
    rmSync(dir, { recursive: true, force: true });
    await fx.close();
  }
});
```

`test/web/capture-refused-same.test.ts`, replaced whole:

```ts
// capture-refused-styles AC3 (named only: F2B_BASE_TREE=<a git archive of the base commit, with node_modules linked>),
// amendment A2: a site that refuses nothing is captured byte for byte as the base captures it in every round (timings,
// capturedAt and build aside); over the rounds the head asks each address of the site no more often than the base
// (per address, summed); and it is no slower: in 5 rounds per site and mode, base and head back to back with the order
// alternating (so load on a shared machine falls on both sides of a pair), the median of all paired head/base time
// ratios is at most 1.10, and no site and mode has every one of its pairs above 1.10. The tables are printed.
import { test } from "node:test";
import assert from "node:assert/strict";
import { hasChrome } from "../browser/chrome.ts";
import { serveEdgeSite } from "../fixtures/web/edge-site.ts";
import { serveFixture } from "../fixtures/web/serve.ts";
import { standIn } from "../fixtures/web/capture.ts";
import { firstDifference, noFonts, timeless } from "../fixtures/web/human-helpers.ts";
import { captureSite } from "../../src/web/capture.ts";

const BASE = process.env.F2B_BASE_TREE;
const ROUNDS = 5;
const median = (xs: number[]) => { const s = [...xs].sort((a, b) => a - b); const m = Math.floor(s.length / 2); return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2; };
const counts = (urls: string[]) => { const m = new Map<string, number>(); for (const u of urls) m.set(u, (m.get(u) ?? 0) + 1); return m; };

test("AC3 a site that refuses nothing is captured as before, as often asked and as fast", { skip: !BASE || !hasChrome() ? "named only: F2B_BASE_TREE" : false, timeout: 5400000 }, async (t) => {
  const base = (await import(`${BASE}/src/web/capture.ts`)).captureSite as typeof captureSite;
  const edge = await serveEdgeSite({ mode: "open" });
  const basic = await serveFixture("basic");
  const page = await serveFixture("code-page");
  const ratios: number[] = [];
  try {
    // every address the site was asked, in order (the edge fixture's log; the folder fixtures' own list)
    const sites = [
      { name: "edge", url: edge.url, fonts: noFonts, asked: () => edge.log.map((l) => l.url) },
      { name: "basic", url: basic.site + "/", fonts: standIn(basic), asked: () => [...basic.requests] },
      { name: "code-page", url: page.site + "/", fonts: standIn(page), asked: () => [...page.requests] },
    ];
    for (const replay of ["local", undefined]) {
      for (const s of sites) {
        const ms: Record<string, number[]> = { base: [], head: [] };
        const asked: Record<string, string[]> = { base: [], head: [] };
        for (let round = 0; round < ROUNDS; round++) {
          const got: Record<string, unknown> = {};
          const order = round % 2 === 0 ? [["base", base], ["head", captureSite]] as const : [["head", captureSite], ["base", base]] as const;
          for (const [name, capture] of order) {
            if (replay) process.env.F2B_REPLAY = replay; else delete process.env.F2B_REPLAY;
            const before = s.asked().length;
            const t0 = Date.now();
            try {
              // the build number aside too: a base export older than the copy carries another BUILD
              got[name] = { ...timeless(await capture({ url: s.url, fontSource: s.fonts, shots: false })), build: null };
            } finally {
              delete process.env.F2B_REPLAY;
            }
            ms[name].push(Date.now() - t0);
            asked[name].push(...s.asked().slice(before));
          }
          assert.equal(firstDifference(got.head, got.base), null, `${s.name} (F2B_REPLAY=${replay ?? "unset"}), round ${round + 1}`);
          ratios.push(ms.head[round] / ms.base[round]);
        }
        const b = counts(asked.base), h = counts(asked.head);
        const more = [...h].filter(([u, n]) => n > (b.get(u) ?? 0)).map(([u, n]) => `${u} ${n} against ${b.get(u) ?? 0}`);
        assert.deepEqual(more, [], `${s.name} (F2B_REPLAY=${replay ?? "unset"}): addresses the head asked more often than the base`);
        t.diagnostic(`${s.name} F2B_REPLAY=${replay ?? "unset"}: ms base ${ms.base} head ${ms.head}; ratios ${ms.head.map((x, i) => (x / ms.base[i]).toFixed(2))}; requests base ${asked.base.length} head ${asked.head.length}`);
        // a slow-down of one site and mode the pooled median could hide: every one of its pairs slower than the margin
        const own = ms.head.map((x, i) => x / ms.base[i]);
        assert.ok(own.some((r) => r <= 1.10), `${s.name} (F2B_REPLAY=${replay ?? "unset"}): every pair slower than 1.10 (${own.map((r) => r.toFixed(2))})`);
      }
    }
    t.diagnostic(`paired ratios (${ratios.length}): ${ratios.map((r) => r.toFixed(2)).join(" ")}; median ${median(ratios).toFixed(3)}`);
    assert.ok(median(ratios) <= 1.10, `the median of every paired head/base time ratio is ${median(ratios).toFixed(3)} (${ratios.map((r) => r.toFixed(2)).join(" ")})`);
  } finally {
    await edge.close();
    await basic.close();
    await page.close();
  }
});
```

## Risks

- A site whose check needs a press now asks the person again partway (Question 1): the waiting line shows in the
  terminal as at the start; nothing is pressed for him.
- The Response-stage stylesheet pattern pauses every stylesheet answer once (one DevTools round trip): AC3 measures it.
- A fresh retry on a site that serves another page each time (a rotating banner) replaces the kept page: the later
  ranges read the new one, as they would read it from the site.
- Known limit (Question 5): no-store stylesheets refused while a range is read (DevTools' own re-request of their text)
  still give that range's code as longhands, unseen. Follow-up with the probe (`p2-expiry8-w4.json` vs
  `base-none-w4.json`: `1201-up` `border` lost).
- The log holds addresses and the site's answers, never request headers or cookies; a query value whose name looks like
  a secret is hidden.
- [amended A3] Limits of the first-load rule: a site whose stylesheets all live on another host (a CDN) that refuses them
  isn't covered (they aren't the page's own); a capture saved before this build styleless that way isn't flagged by
  `capture:check` (none of bdryswi.com is known: Justin's 11-10 runs stopped); a check page whose own scripts or
  pictures the site refuses prints the "refused on the way" line after the pass (true, and harmless).
- [amended A2] AC3's timing can still fail on a desktop loaded so unevenly that most pairs fall on a spike on the head's
  side; it is never retried until green: a failure is reported with its table and the load (`uptime`) at the time.

## Completion

Builder stops at `ready-for-review` with every AC's receipt in the ledger (a terminal capture for each, none being
visual), AC3's base export path and its three-run table, and Task 9's tallies against the base's.
