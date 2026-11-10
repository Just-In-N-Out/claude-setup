# capture-speed: `npm run capture` of a live site in minutes, not 40 (Full plan, website importer)

## Amendments

1. 2026-11-08, Justin ("Count per look, speed later (Recommended)"; site-motion fixer 4,
   `evidence/site-motion/fixer-3/justin-ac8.json`): site-motion's states reading (`src/web/read/code-states.ts`
   `readStates`) asks each listed element again under forced `:hover` and under forced focus at the design width, so
   "asked at most once" now counts per page state: the normal state and each forced hover/focus pass. At most one ask
   per element per state; "only where needed" is the normal state's. The capture is unchanged; asking fewer elements in
   the forced passes is a speed follow-up (`evidence/site-motion/follow-ups.md`). AC8's line below is marked.
2. 2026-11-10, planner, **to be confirmed with Justin** (site-menu review 2's R2-5, after site-menu review 1's R1-1 and
   its fixer 1: neither the code nor the test is the wrong side; `evidence/site-menu/review-2/review.json`): site-menu's
   capture reads a closed `<details>`' content while that details is open (`src/web/readers/details.ts`,
   `src/web/read/code.ts` `readCode`/`contentOpen`: one details at a time, by its `open` attribute, every details put
   back), so its own elements are asked once more in that state. An opened closed `details` is one more look, as a
   forced hover is since Amendment 1: the test's spy counts asks per page state (each opening its own, `details <n>`,
   from `openDetails` to `restoreDetails`); the normal state's asks are still compared with what the page needs and
   never twice per element; on the `asks` fixture each page load opens its one closed details exactly once, with one to
   four asks, all of that details' own elements (the details, its summary, its answer and the answer's paragraph). The capture's
   normal-state asks are unchanged. AC8's line below is marked. The pre-amendment text is
   `git show 4dd1a275:docs/plans/2026-11-07-capture-speed.md` (the same at main `2879e496`); the approved copy
   `evidence/capture-speed/plan-approved.md` predates Amendment 1. **Receipts:** capture-speed's own AC8 receipts
   (`evidence/capture-speed/verifier/ac8-e455130.log`, `auditor/ac8-e455130.log`, the gates' `capture-matched-once`
   logs and the auditor's mutants `m8a`–`m8d`, all at `e455130b`) ran a capture that opens no closed details and a test
   that counts no such state; they hold for that head (and for main `2879e496`, the same). The sorter
   `git show <head>:src/web/read/code.ts | grep -c 'contentOpen(reading'` (the open reading) beside
   `git show <head>:test/web/capture-matched-once.test.ts | grep -c whileOpen` (the amended count): 0/0 on `e455130b`
   and main `2879e496`; 2/0 on site-menu's `71c075c5`–`3c911792` (the reading without the amended count: the old test
   counts the opened details' asks in the normal state and fails, "asks 992-up: asked twice in the normal state",
   `evidence/site-menu/fixer-1/files-ab9027b2/test_web_capture-matched-once.test.ts.log`); 2/4 from site-menu's
   `dbfb16dd` to `4dd1a275`. The mutants' receipts stay valid: the assertions they failed on are unchanged.

Branch: the planner's copy `worktree-agent-a6e3169462bc325a8` holds only this plan; the builder works in its own copy
from local `main` (Build 2026-11-07.1, `9b248818`, or newer). Evidence:
`~/.hermes/plans/figma-to-bricks/evidence/capture-speed/` (`planner/` holds the probes, their scripts and receipts).
bdryswi.com is never loaded by any agent: its page comes from the saved 2026-10-29 files (the stand-in) and from the
capture files Justin made; its live run is Justin's (AC11).

**Out of bounds:** `src/core/`, `src/plugin/`, `src/shared/`, `src/ui/` (Figma conversions must stay byte for byte);
`src/core/site/` and `tools/site*.ts` (the code method's paste: nothing there changes, the pastes stay the same because
the capture stays the same); the main folder; any WordPress site. **Hard rule (CLAUDE.md):** nothing hides that the
browser is automated: no new user agent, no navigator patch, no stealth script, no flag that hides automation, and no
code that clicks, types into or solves a check. The capture only waits, reads, and loads the page again; Justin presses
"I am human" himself.

**Parallel jobs to know about:** elementor-map (`worktree-agent-a93c32bbf9bbc5ed4`, being merged) changes
`src/web/code.ts` `assembleCode` (hidden children kept): it changes captures, so AC1/AC2 always compare with the very
`main` the branch sits on (rebase first, then make the base tree). site-motion (planner running now) may add keyframe
reading to the capture: a reader of its own that asks DevTools for matched styles should go through Task 3's `askAll`
(one ask per element), so the later of the two rebases and checks. web-capture-steady (parked since 2026-11-04, branch `web-capture-steady-build`, two
commits built, not merged) is folded in here (Q4).

## Questions for Justin (the build takes the ⭐ answers under the standing auto-go)

1. **Read several widths at once?** The capture reads the site's width ranges (16 on bdryswi.com) one after another,
   each in a fresh page load: about 2½ minutes each.
   - A ⭐ Up to **4 Chrome windows** read ranges side by side (each its own fresh page load, as today). On your screen,
     during a capture that needed the "I am human" window, up to four more windows open and close by themselves.
     `npm run capture -- <address> --windows 1` keeps today's one-at-a-time.
   - B One window, one range at a time (today's pace for that part).
2. **Ask the site for the page once per kind of visitor?** Today every range loads the page from the site again (17
   page loads for bdryswi.com's home), and the site's bot check came back 5 times and refused 4 loads.
   - A ⭐ The first good page load with the desktop agent and the first with the phone agent are kept; every later page
     load of the same kind is answered with that same page, inside the capture's own Chrome. The site is asked for the
     page twice instead of 17 times (plus the one download of the page as served, as today); its styles, scripts and
     pictures load as before (Chrome's cache serves what it may). Nothing about the visitor changes (same tab, agent,
     cookies).
   - B Every range asks the site again (today).
3. **A page load that fails** (an error page with nothing to press, a 403, a lost connection):
   - A ⭐ Watch it for 10 s (a late "I am human" button counts as a check; you press it), then load it again in the same
     window; a second time after 30 s; then, in the "I am human" window, wait for you (web-capture-steady's rule: you
     can reload it there yourself), and invisibly read it with its note as today. A lost connection is loaded again
     after 10 s and 30 s, then the capture stops with one plain line ("… couldn't be reached …: check the connection and
     press Capture to try again"), never reading Chrome's own "No internet" page as the site.
   - B Read it at once with its note (today), so the capture ends "Not the page itself".
4. **web-capture-steady** (parked since 2026-11-04; two of its commits are built: a later width that meets the check
   again waits for you, and a reload that lands back on the page itself is the page, your 2026-11-04 ruling):
   - A ⭐ Folded in here (its two commits taken as they are, reviewed with this job); its branch is then retired.
   - B Left parked: a 403 at the phone widths keeps being read as the range.
5. **Tell you how long it took?**
   - A ⭐ One line after the file line: `Took 7 min 40 s: switch points 1 min 45 s, 16 ranges in 4 windows 5 min 20 s,
     pictures 30 s, renders 3 s`.
   - B Nothing new.

## Playback (what Justin saw, 2026-11-07)

1. `npm run capture -- https://bdryswi.com/` (Build 2026-11-07.1) took 30–40 minutes. Its file
   (`~/Downloads/bdryswi-com-home.f2b-capture.json`, read only) records its own phase times: switch points 104.6 s,
   ranges 2,333.8 s (38.9 min), pictures 215.8 s, renders 3.4 s: **44 min** in all.
2. "I am human" came up 5 times: every range loads the page from the site again, and the site re-checks.
3. Five ranges hold no real page. 1024-1024 and 769-834 read a 403 page that reloaded itself (code reading 0.15 s and
   0.04 s; 36 and 5 shown elements against 1,069–1,198 in every real range; body font `"Helvetica Neue",
   HelveticaNeue, Helvetica, Arial`, which no real range shows). 361-393 and 320-360 read 17 elements in 0.24–0.26 s
   **with no note at all**: Chrome's own "No internet" page after the wifi dropped (body `color: rgb(95, 99, 104);
   font: 15px sans, Arial`, Chrome's error-page style; `web.code.context`). 394-412 "reloaded itself" (its code looks
   real: 1,188 elements). 11 pictures timed out (30 s each, twice, through the browser after the check).
4. He wants the capture much faster, the check asked once, and no range read from an error page.

## Where the minutes go (measured)

All offline or from saved files; no site was loaded. Receipts, scripts and logs:
`~/.hermes/plans/figma-to-bricks/evidence/capture-speed/planner/`. The desktop was shared with other agents' jobs during
every probe (load average 17–23 on 24 threads at 21:28), so absolute times are pessimistic; ratios measured in one run
are the reliable part.

**Live bdryswi.com captures (each file's own `web.timings`, read only):**

| capture | build | ranges | switch points | ranges read | of which code reading | pictures | renders | total |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04 06:27 (no code reading) | 2026-11-04.3 | 15 | 101.8 s | 996.1 s | – | 21.1 s | 3.0 s | **18.7 min** |
| 2026-11-05 00:12 (code v1) | 2026-11-04.7 | 16 | 127.8 s | 2,770.4 s | 1,320.5 s (88 s a range) | 14.7 s | 3.1 s | **48.6 min** |
| 2026-11-07 20:24 (Justin, code v2) | 2026-11-07.1 | 16 | 104.6 s | 2,333.8 s | 928.3 s (77 s a real range, 12 of 16) | 215.8 s | 3.4 s | **44.3 min** |

The code reading alone added ~30 minutes between 11-04 and 11-05. The 11-07 run also holds 5 person checks and the wifi
drop (the pictures' 216 s are 11 browser downloads timing out at 30 s, twice).

**The saved B-Dry page offline (the stand-in), `main` 9b248818, profiled** (`profile.mjs`: every DevTools command
timed by tab and phase through a wrapper on the driver's connection; `analyze.mjs`; `standin-analysis.txt`): **2,241 s
= 37.4 min**, 12 ranges, 38 widths, 852 code nodes:

| phase | total | per range | file:line |
|---|---|---|---|
| switch-point search | 60.3 s | – | `src/web/discover.ts:66-77` (every-property reads 33.5 s, quick facts 7.5 s, 157 resizes 3.5 s) |
| **authored values**: `CSS.getMatchedStylesForNode` for every shown box, one at a time | **725.8 s** | 49–104 s (637–689 asks) | `src/web/capture.ts:141` → `src/web/read/authored.ts:68-72` |
| **code reading**: the same DevTools call for every element and inline element, one at a time | **1,354.7 s** | 98–140 s (1,377 asks) | `src/web/capture.ts:143` → `src/web/read/code.ts:61,70,88` |
| page load + freeze | 55.0 s | 2.5–6.4 s | `src/web/session.ts:114-128`, `src/web/freeze.ts:118-153` |
| fonts, full reading, light readings at the other widths | 38.3 s | 2–9 s | `capture.ts:138-151` |
| pictures, the rest | ~6 s | | |

**93% of the capture is one DevTools call, `CSS.getMatchedStylesForNode`:** 24,474 calls, 2,058.7 s, mean 84 ms (p50
76, p90 123), each answer ~626 KB. `bench.mjs` (`bench-standin.json`), on one frozen B-Dry tab at 1440:

- **92% of every answer is the `inherited` list** (each ancestor's full matched rules and inline style, nearest first;
  the element's own rules are 5.6%). An answer costs with its depth: 34 ms / 266 KB at depth 2, 150 ms / 1.17 MB at
  depth 24 (`bench3-standin.json`). Node's `JSON.parse` of a 513 KB answer: 1.7 ms (not the cost).
- **Sending several at once barely helps:** 300 asks one at a time 27.8 s; 4 in flight 24.2 s; 16 in flight 24.4 s
  (−13%; Chrome answers one tab's commands in turn). Same answers (sha1).
- **Windows read side by side:** a second and a fourth Chrome window (`Target.createTarget` `newWindow`) each draw 62
  frames a second, `visible`, at the same time; 300 asks in each of 2 windows at once 39.7 s (1.4× one window's
  throughput), in each of 4 windows 63.5 s (**1.75×**), under the shared load above. Four B-Dry windows: 3.3 GB
  resident (16 processes, shared pages counted in each).
- **An element's own matched rules are in every descendant's answer:** for 40 sampled elements with children, their
  own `matchedCSSRules` and inline style are byte-identical to the `inherited` entry of a descendant's answer (40/40,
  `bench3`). Of the code reading's 1,377 elements, 465 have no listed child, 39 draw `::before`/`::after`, 155 carry an
  attribute that may style them (`width`, `height`, `dir`, `fill`, `type`…: `attributesStyle`, which `inherited`
  lacks): **546 must be asked; the other 831 come from a descendant's answer**, every one covered. `bench5.mjs` runs
  Task 3's `askPlan` text pulled from this plan and asks every element too: at 1440 and at 390 on B-Dry, 827 of the
  831 derived elements are byte-identical to their own answers; the 4 others sit in the FAQ's `<details>`, whose
  browser-made shadow tree puts a slot in the flat-tree chain (10 answers there list one ancestor more than
  `parentElement` counts). With the plan's final text (`<details>` and the other browser shadow hosts never derived
  across, plus the chain guard): **547 asked, 803 derived and byte-identical (803/803), 27 guarded and asked
  themselves** (`bench5c-standin-1440.json`): ~578 asks a range with `<body>` and the self-check. The own asks took
  40–44 s at 1440 (80 ms each, under the shared load). `code-page` at 390: 56 of 106 asked, 50/50 identical.
- Authored values and the code reading ask the same elements at the same width (`bench4.mjs`): every authored element
  but `<body>` is one the code reading asks right after (B-Dry at 1440: 660 authored, 659 of them among the code
  reading's 1,377; `code-page` at 390: 86, 85 among 106).

**Page loads and the bot check** (`bench2.mjs`, `bench2-*.json`): a range's page load answered from the first load's
recorded top document (`Fetch.enable` at the Response stage to record, `Fetch.fulfillRequest` to answer) sends **no
page request** to the server and reads the same (full reading and code facts equal to a plain network load's, on the
`code-page` fixture with its scripts and on the B-Dry stand-in; one stand-in run's first load drew a 9,451 px page
against 8,835 for both later loads, the network control as much as the answered one: a slow first font, not the
answer). A refused connection: `Page.navigate` answers `errorText` `net::ERR_CONNECTION_REFUSED`, the load event still
fires, `goto` resolves (`test/browser/chrome.ts:166` ignores `errorText`) and the tab holds `chrome-error://chromewebdata/`
with status 0: the capture reads Chrome's error page as the range with **no note** (`capture.ts:123` notes only ≥ 400) —
exactly 11-07's 361-393 and 320-360.

**The run-to-run baseline:** two stand-in captures by the same capture code on different days differ only in the
site's port (`web.host`, and two picture ids hashed from addresses that hold it): capture files are deterministic when
both are made of the same server (`capdiff.mjs`; `test/web/capture-stable.test.ts` pins it for one fixture).

**Fixed waits are small:** the freeze's minimums (quiet 0.5 s, entrances 1 s, 0.1 s; `freeze.ts:134,143,151`), 60 ms
per resize (`discover.ts:51`, `freeze.ts:167`), the phone's scroll gesture (≤ 0.8 s a step, `freeze.ts:182`: 4.5 s a
phone range) add up to about a minute of the stand-in's 37; they keep the capture faithful, and stay.

## Root causes (file:line)

- **RC1, the dominant one:** every element's matched rules are asked of DevTools **twice per range, one at a time**:
  `authoredValues` for each shown box (`authored.ts:68-72`), then `readCode` for every element and inline element
  (`code.ts:61-96`), and each answer carries every ancestor's rules (~600 KB, ~84 ms). 2,037 asks a range on B-Dry.
- **RC2:** the ranges are read one after another (`capture.ts:186-196`), each a fresh page load (`capture.ts:105` →
  `session.ts:94`), though each range's tab is its own renderer and Chrome draws side-by-side windows at full speed.
- **RC3:** every range asks the site for the page again (`session.ts:114`; the search's load `discover.ts:35`; 17 page
  loads for bdryswi.com's home, plus `servedHtml`, `capture.ts:154`), so a site that re-checks visitors after a few
  loads asks the person again and again (5 times on 11-07) and refuses some loads (403).
- **RC4:** a failed load is read as the range: a 403 with nothing to press is returned as the page (`session.ts:120,127`
  wait only for `isHumanCheck`; `capture.ts:122-123` only notes it), and a lost connection reads Chrome's own error
  page with no note at all (`chrome.ts:166`, `capture.ts:123`). web-capture-steady (parked) fixed the late-button and
  settled-reload halves of this on its branch.

## What cuts the most time, ranked (each keeps the capture, so the pastes stay byte for byte)

1. **Ask each element once, and only where needed** (Task 3; RC1): the code reading asks only the elements (547 on
   B-Dry, plus 27 the guard sends back) that have no listed child, draw a pseudo-element, carry a styling attribute or
   sit in or across a shadow tree, takes every other
   element's rules from a descendant's `inherited` entry (proved identical above), and hands the authored values their
   declarations from the same answers; 4 asks in flight. **2,037 → ~550 asks a range**: the asks' time a range from
   ~170 s to ~45 s on the stand-in (measured 40–44 s for the 546; deeper elements cost more each). Guarded at run time:
   an answer whose ancestor list doesn't match the element's parent chain gives nothing (its dependants are asked), and
   a few derived elements are also asked and compared in every page load; any difference (another Chrome version) and
   that page load asks every element as today.
2. **Ranges side by side in up to 4 windows** (Tasks 2, 7; RC2): ×1.75 measured under load (more on an idle desktop),
   the design width's range included; counted in the ranges' order, so the file is the same.
3. **The page kept per kind of visitor** (Task 6; RC3): 2 page requests to the site instead of 17; later loads take
   ~3 s instead of 16 s on the stand-in (more on a live network); the bot check meets the capture once per kind.
4. **Failed loads loaded again in the same window** (Tasks 4, 5; RC4): no range read from an error page; at most 40 s
   more for a load that fails twice.
5. **The time line** (Task 8): so Justin sees where his minutes went.

**Projection** (from the measured costs; Task 9 measures it): the stand-in from 37.4 min to **about 6–8 min** under
today's shared load (search 1 min, 12 ranges × (45–55 s asks + 8 s rest) / 1.75, pictures); bdryswi.com's home from
44 min to **about 7½–10 min** (search 1¾ min, 16 ranges × ~46 s / 1.75–2.5, one check, pictures). What stays: the
switch-point search (1–2 min) and the per-range freeze and light readings. Without item 1, items 2–4 alone would leave
the stand-in at ~20 min: the asks are the minutes.

## Acceptance criteria (all **proposed**: the brief gives none; "go" approves them)

"The same capture" below means: the two capture files are equal byte for byte as `JSON.stringify` writes them, apart
from `web.timings` and `web.capturedAt` (the existing rule of `test/web/capture-stable.test.ts` AC9 and
`test/fixtures/web/human-helpers.ts` `timeless`), with both captures made of the same server (same port) in one test
run. "The base" is the `main` commit the branch sits on, as a `git archive` tree with `node_modules` linked
(`F2B_BASE_TREE`).

- **AC1** (proposed): **every fixture site captures as before.** For each offline fixture site under
  `test/fixtures/web/sites/` that a capture test captures (Task 0 lists them), the head's capture with its defaults (4
  windows, the page kept per kind, Task 3's asks, failed loads tried again) is the same capture as the base's — test
  `test/web/capture-speed-same.test.ts` › "AC1 every fixture site captures as it did before" (named-only:
  `F2B_BASE_TREE`). Default run, no base needed: › "AC1 four windows capture what one window does" (the head with
  `windows: 4` and `windows: 1`, fixtures `many-ranges` and `code-page`).
- **AC2** (proposed): **the saved B-Dry page captures and pastes as before.** The saved bdryswi.com home served offline
  (web-code-page AC9's stand-in) captured by the head is the same capture as the base's, and `npm run site`'s
  `header.json`, `page.json`, `footer.json`, `sources-*.json` and `notes.txt` from the two captures are byte-identical
  — test `test/web/capture-speed-bdry.test.ts` › "AC2 the saved B-Dry page captures and pastes exactly as before"
  (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, `F2B_BASE_TREE`). And web-code-page's own
  `test/web/site-page-bdry.test.ts` (AC9, AC17, AC18: within 2 px at every width) passes on the head.
- **AC3** (proposed): **much faster on the saved B-Dry page.** In the same test run as AC2, the head's capture of the
  stand-in takes **at most a third of the base's** capture time and **under 12 minutes** (the base: 37.4 min measured
  2026-11-07 on this desktop; the planner's projection for the head: about 7–8 min under the agents' usual load) — test
  `test/web/capture-speed-bdry.test.ts` › "AC3 the saved B-Dry page captures in under a third of the time" (named-only,
  as AC2), writing both times and the head's `web.timings` to the evidence folder.
- **AC4** (proposed): **the site is asked for the page once per kind of visitor.** A capture asks the server for the
  page itself (a page load) once with the desktop agent and once with the phone agent, whatever the number of ranges
  (base: once for the switch-point search and once per range); every other range reads the same page; a site that
  answers phones with another page keeps its phone page in the phone ranges and its desktop page in the desktop ranges
  — test `test/web/capture-replay.test.ts` › "AC4 one page load per kind of visitor" and › "AC4 a site with its own
  phone page keeps it".
- **AC5** (proposed): **a failed page load is loaded again in the same window.** A range whose page load the site
  answers with a 403 and nothing to press, once, and one whose connection drops, once, are each loaded again in the same
  tab and read from the real page: no ANSWERED or RELOADED note, `notThePage` empty, the same readings as a site that
  never failed; a reload of its own that lands back on the page itself is the page (Justin's 2026-11-04 ruling, no note);
  one that lands on another address, a log-in or a check keeps its note; a site that keeps refusing is read with its
  ANSWERED note after 3 page loads (invisible capture); a connection that stays down ends the capture with
  `PageUnreachable`'s one line after 3 tries, never with Chrome's error page read as a range — test
  `test/web/capture-retry.test.ts` (five named cases) plus web-capture-steady's `test/web/capture-steady.test.ts` (its
  AC1, AC2) and `test/web/human-reload.test.ts` AC4 (its last assertion flipped to "no RELOADED note").
- **AC6** (proposed): **"I am human" at most once per kind of visitor.** On the check stand-in whose pass holds for two
  page loads (it checks again after), the head's capture asks the person once (the base: twice); with the pass tied to
  the agent's kind (`bindUa`) once per kind (twice); every range is read from the real page — test
  `test/web/human-once.test.ts` › "AC6 the check is asked once when the pass holds" and › "AC6 once per kind of
  visitor".
- **AC7** (proposed): **ranges read side by side, at most N windows.** With `windows: N` (default 4; `npm run capture
  -- <address> --windows <n>`), at most N ranges are loaded or waiting to be counted at once, each but the design
  width's in its own Chrome window of the one browser (so a pass and cookies hold), and every such window draws frames
  while it is read; `windows: 1` loads one range at a time in tabs, as today; the importer helper uses the
  default — test `test/web/capture-windows.test.ts` › "AC7 every window draws while it's read" and › "AC7 at most N
  ranges in hand, at least two at once", `test/unit/web-in-order.test.ts` (the scheduler), `test/web/capture-cli.test.ts`
  › "AC7 --windows".
- **AC8** (proposed): **each element's matched rules asked at most once, and only where needed.** In a range's page
  load DevTools' `CSS.getMatchedStylesForNode` is called only for the elements that need their own answer (no listed
  child element, a drawn `::before`/`::after`, an attribute that may style it, a shadow tree; plus what the authored
  values need beyond the code reading, and `SELF_CHECK` asks), never twice for one element, 4 in flight (**amended
  2026-11-08, Amendment 1:** asked at most once per page state (normal, each forced hover/focus pass; site-motion's
  states reading), Justin: "Count per look, speed later (Recommended)"; "only where needed" counts the normal state's
  asks; **amended 2026-11-10, Amendment 2, to be confirmed with Justin:** a closed `details` opened to read its content
  (site-menu) is one more page state: on the `asks` fixture exactly one opening per page load, with one to four asks,
  all of that details' own elements); every other
  element's rules come from a descendant's answer; the capture is the same as one that asks every element
  (`F2B_ASK_ALL=1`); a self-check difference makes that page load ask every element, and the capture is still the same
  — test `test/web/capture-matched-once.test.ts` › "AC8 each element is asked once, and only where needed", › "AC8 the
  capture is the same as asking every element", › "AC8 a derived answer that differs makes the page load ask every
  element".
- **AC9** (proposed): **the command says how long it took.** `npm run capture` prints, right after each `File:` line,
  `Took <total>: switch points <t>, <n> ranges in <w> windows <t>, pictures <t>, renders <t>` — test
  `test/web/capture-cli.test.ts` › "AC9 the command says how long the capture took" and `test/unit/web-took.test.ts`.
- **AC10** (proposed): **nothing hidden, nothing else changed.** web-human-check's
  `test/web/human-check.test.ts` › "AC5 nothing hidden: visible flags, webdriver and user agent as the plain launch's"
  passes unchanged (its source scan covers the new files); the five real files replay byte-identically
  (`test/unit/plugin-convert.test.ts` and Task 0's replay receipts); `npm run check` passes; `npm run test:web` and
  `npm run test:browser` pass every test that passes on the base (by name, Task 0's tally); `npm run corpus` equals
  the base; `git diff --stat main...HEAD -- src/core src/plugin src/shared src/ui` is empty.
- **AC11** (proposed) (live): **bdryswi.com's home in under 10 minutes.** Justin's `npm run capture --
  https://bdryswi.com/` on the desktop after the merge prints `Took …` under 10 minutes (44 min on 2026-11-07), asks "I
  am human" at most once per kind (at most twice), prints no "Not the page itself" line, and `npm run site:check --
  <file> --all` lists every width (no range skipped) — Justin's own run; no agent loads the site.

## Tasks

**Environment (WSL desktop):** `PATH=/home/justin/.local/node-v22.23.3/bin:$PATH`, `TMPDIR=/home/justin/.cache/cspd-b/tmp`
(≤ 38 characters; never a session scratchpad), `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One
Chrome job of your own at a time; every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0 …`, the B-Dry named tests under `MemoryMax=6G` (five B-Dry pages at once: "Risks", Memory).
SIGTERM/143/137/"Killed" may be earlyoom:
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. Write scripts with Write and run `bash <file>`;
git add/diff/commit as separate plain calls; no redirects or heredocs in commands (testing-pitfalls). The worktree's
`node_modules` may lack `.bin`: `node node_modules/typescript/bin/tsc --noEmit -p .` and `-p tsconfig.sandbox.json`, or
link `.bin/tsc`. Commit after each passing task (`git commit -m "capture-speed …"`; `git diff --cached --name-only`
never lists CLAUDE.md; no BUILD bump; no push). Ledger: `.superpowers/sdd/2026-11-07-capture-speed/progress.md`.
Evidence: `E=~/.hermes/plans/figma-to-bricks/evidence/capture-speed/builder/`. The planner's probe scripts are in
`~/.hermes/plans/figma-to-bricks/evidence/capture-speed/planner/` (`profile.mjs`, `analyze.mjs`, `bench.mjs`,
`bench2.mjs`, `capdiff.mjs`): reuse them for receipts.

### Task 0: rebase, base tree, base tally

1. `git log --oneline HEAD..main`: rebase on local `main` first (elementor-map may have landed; its `src/web/code.ts`
   change alters captures, so every "as before" in this plan is against that `main`).
2. Base tree: `git archive -o ~/.cache/cspd-b/base.tar <main sha>` (its own call), `mkdir -p ~/.cache/cspd-b/base`,
   `tar -xf ~/.cache/cspd-b/base.tar -C ~/.cache/cspd-b/base`, `ln -s
   /home/justin/Documents/FigmaToBricksV2/node_modules ~/.cache/cspd-b/base/node_modules`. This is `F2B_BASE_TREE`.
3. Base gates, in that tree, each its own receipt in `E/base/`: `npm run check` (tally); `npm run test:web` file by
   file with TAP (`node --test --test-reporter=tap <file>`; names and pass/fail per file: the base tally AC10 compares
   by name); `npm run test:browser`; `npm run corpus`; the five replays (`npm run replay`, as earlier plans' Task 0).
4. The fixture sites the capture tests capture, for AC1: `grep -ho 'captureFixture("[a-z-]*"\|serveFixture("[a-z-]*"'
   test/web/*.test.ts | sort -u` (plus `many-ranges`, Task 7). Write the list in the ledger.
5. AC8's base counts: run the planner's `profile.mjs` on the `code-page` fixture in the base tree (about 15 s; `node
   profile.mjs <tree> <out> code-page`) and `analyze.mjs`: per range session, the `authored` and `code`
   `CSS.getMatchedStylesForNode` counts (planner: 86 + 106 a range, 3 ranges). Record them. (The planner's `bench5.mjs`
   runs Task 3's `askPlan` text straight from this plan: `code-page` at 390, 56 of 106 asked, the 50 others' rules
   byte-identical to their own answers; the B-Dry stand-in at 1440, 547 of 1,377 asked, 803 derived and identical, 27
   guarded; `bench5c-*.json`.)

### Task 1: the Chrome driver: windows, events, a failed navigation (`test/browser/chrome.ts`)

All additive; every current caller keeps working.

1. RED `test/web/capture-windows.test.ts` › "AC7 every window draws while it's read": open two pages with
   `browser.newPage({ window: true })`; `Browser.getWindowForTarget` gives each its own `windowId` (RED on the base:
   `newPage` takes no option, both are tabs of one window); load `serveFixture("basic")` in each and count
   `requestAnimationFrame` callbacks over 1 s in both at the same time (each ≥ 20, `document.visibilityState ===
   "visible"`). Planner's probe: in this headless Chrome (156) a background tab drew 60 frames too, so the frame count
   is a regression check, not the RED; windows matter in the visible "I am human" run, where a background tab is hidden.
2. `Browser.newPage(o: { window?: boolean } = {})`: `Target.createTarget` with `{ url: "about:blank", ...(o.window ? {
   newWindow: true } : {}) }`.
3. `Connection.on(method, sessionId, fn)` → returns an `off()`; the message handler calls every listener of
   `"<session> <method>"` after the one-shot waiters (a listener that throws is caught and ignored); `Page.on(event, fn)`
   wraps it with the page's session. (The capture needs `Fetch.requestPaused` for every request of a page load, Task 6;
   `next()` is one-shot.)
4. `Page.goto` returns `Promise<string>`: `Page.navigate`'s `errorText` ("" when none). Planner's probe (bench2,
   below): a refused connection answers `errorText` and still fires the load event, so `goto` resolves and the tab holds
   Chrome's error page. Callers that ignore the value are unchanged.
5. GREEN; also `test/web/human-check.test.ts` › "AC5 nothing hidden…" (the pinned `chromeArgs` list is untouched: no
   flag is added anywhere). Commit.

### Task 2: the scheduler (`src/web/in-order.ts`, pure)

```ts
// Ranges read side by side (capture-speed Q1 A): work() on each item, at most `at` items in hand at once (started and
// not yet handed to use()), and use() on each result in the items' order, one at a time, so what is counted (notes,
// pictures, readings) comes out as if read one by one. at = 1 is exactly one after another: an item starts only once the
// one before it is used. The first failure, whichever item it comes from, ends it at once (the others' failures are
// kept quiet); nothing new starts after it. No Chrome here.
export async function inOrder<T, R>(items: T[], at: number, work: (item: T) => Promise<R>, use: (item: T, got: R) => Promise<void>): Promise<void> {
  let failure: { e: unknown } | null = null;
  let fail: (e: unknown) => void = () => {};
  const failed = new Promise<never>((_, reject) => { fail = reject; });
  failed.catch(() => undefined);
  const started: Array<Promise<R>> = [];
  const start = (i: number): void => {
    const p = work(items[i]);
    p.catch((e) => { if (!failure) { failure = { e }; fail(e); } });
    started.push(p);
  };
  const most = Math.max(1, Math.floor(at));
  let next = 0;
  for (let k = 0; k < items.length; k++) {
    while (!failure && next < items.length && next < k + most) start(next++);
    if (failure) throw (failure as { e: unknown }).e;
    const got = await Promise.race([started[k], failed]);
    await use(items[k], got);
  }
}
```

RED/GREEN `test/unit/web-in-order.test.ts` (the file's three tests, each with fake work of timed promises): "results
are used in the items' order whatever order they finish in"; "never more than `at` in hand, and at = 1 never overlaps"
(a counter incremented at start and decremented in use: max ≤ at; with at = 1, start(k+1) happens after use(k));
"the first failure ends it at once and nothing new starts" (item 3 of 8 fails while 1 and 2 are still running: rejects
before they finish; no work starts for 5–8). RED: the module doesn't exist (an import failure is a valid RED for a new
pure module; say so in the ledger). Commit.

### Task 3: each element's matched rules asked once, and only where needed (AC8)

Files: `src/web/cdp.ts`, new `src/web/read/matched.ts`, `src/web/read/code.ts`, `src/web/read/authored.ts`,
`src/web/session.ts`, `src/web/capture.ts` (the order of two calls), new fixture `test/fixtures/web/sites/asks/`, new
`test/web/capture-matched-once.test.ts`.

**What it does.** DevTools' `CSS.getMatchedStylesForNode` answers for one element its own matched rules, inline and
attribute styles and pseudo-elements, **and every ancestor's matched rules and inline style** (`inherited`, nearest
parent first; 92% of the answer). So an element's own rules are already in each descendant's answer (planner, this
plan's own `askPlan` text on B-Dry: 803 of 803 derived elements byte-identical to their own answers, 27 more caught by
the guard). In each page state the capture asks DevTools only for the listed elements that need their own answer,
4 in flight, and takes every other listed element's rules from a descendant's answer; the code reading's answers also
give the authored values their declarations, so no element is asked twice.

An element is **asked itself** when any of these holds (decided in the page, `askPlan`):
- no listed element has it as its parent (a leaf of the list; words boxes' inline elements are listed, so a `p` whose
  `<a>` is listed is not a leaf);
- the reader needs its pseudo-elements (the code reading: it draws `::before` or `::after`), which `inherited` lacks;
- it has an attribute outside `SAFE` (it may have an `attributesStyle`, which `inherited` lacks: `width`, `height`,
  `dir`, `hidden`, `align`, `bgcolor`, SVG presentation attributes, form attributes, anything unknown);
- it isn't in the document's own tree (`getRootNode() !== document`), is slotted (`assignedSlot`) or is a shadow host,
  or a descendant chain to it crosses one (`inherited` follows the flat tree there);
- (tests only, `F2B_ASK_ALL=1`) always.

Every other listed element takes `{ matchedCSSRules, inlineStyle }` from the `inherited` entry at its place in the
parent chain of the **first** element asked itself (in list order) that has it as an ancestor. **Guards:** an own answer
whose `inherited.length` isn't its parent-element count up to `<html>` gives nothing (its dependants are asked
themselves); and in every page state the first `SELF_CHECK = 3` derived elements are asked too and compared (JSON of
`matchedCSSRules` and of `inlineStyle` when it has properties): one difference and every listed element of this
reading is asked itself (as the base does, once each).

1. RED `capture-matched-once.test.ts` (fixtures `code-page` and the new `asks`: an `img` with `width`/`height`, a `td
   align`, a `div dir="rtl"` holding words, a `[hidden]` box, a parent drawing `::before` with listed children, nested
   inline elements in a sentence, an open shadow root with a slot and slotted children, a `<details>` (open and closed)
   with a summary and nested content (the browser's own shadow tree: B-Dry's FAQ), a `<select>` with options, a `style`
   attribute on an ancestor of a leaf, a CSS rule on `div > p` and a `:has()` rule on a parent):
   - "AC8 each element is asked once, and only where needed": a spy on the connection (`browser.conn.send`, as
     `profile.mjs`) counts `CSS.getMatchedStylesForNode` per range session: equal to the page's own-ask count (the
     plan's `own` + the elements the chain guard sends back + `<body>` for the authored values + `SELF_CHECK`), which
     the test works out with `askPlan` and one ask per own element on a fresh page load at the range's anchor
     (`code-page` has no guarded element: planner's probe, 56 own at 390); and below the base's (code-page: 192 a
     range).
   - "AC8 the capture is the same as asking every element": `timeless` capture equal to the same fixture's with
     `F2B_ASK_ALL=1` (both fixtures).
   - "AC8 a derived answer that differs makes the page load ask every element": with `F2B_ASK_BREAK=1` (tests only: the
     self-check's comparison sees a changed copy) the asks per range equal `F2B_ASK_ALL`'s and the capture is still the
     same.
   RED on the base: the counts (192 on code-page), and `askPlan` doesn't exist.
2. `cdp.ts`: `NodeRef = { nodeId: number; backendId: number }`; `nodesOf(page, expression): Promise<NodeRef[]>` (today's
   `nodeIdsOf` body, keeping each backend id; the `DOM.describeNode` calls sent `FLIGHT` at a time through
   `inFlight(items, at, work)`, results in order); `nodeIdsOf` goes (its two callers move to `nodesOf`). Extend
   `MatchedStyles` with `inherited?: Array<{ inlineStyle?: unknown; matchedCSSRules?: Array<{ rule: CssRule; matchingSelectors: number[] }> }>` and
   `pseudoElements?`.
3. `read/matched.ts`:

```ts
// One DevTools matched-styles ask per element per page state, and only where its own answer is needed (capture-speed):
// DevTools answers an element's own rules and, for every ancestor, its matched rules and inline style (`inherited`,
// nearest parent first), so a listed element with a listed child takes its rules from the first descendant asked
// itself (planner: byte-identical, 803 of 803 on B-Dry). Asked itself: a leaf of the list, an element whose pseudo-elements
// or attribute styles are needed (`inherited` lacks them), anything in or across a shadow tree. Guards: an answer whose
// `inherited` doesn't match its parent chain gives nothing; the first SELF_CHECK derived elements are asked as well and
// compared, and one difference asks every element (another Chrome may list ancestors otherwise). FLIGHT asks at once
// (inOrder: at most FLIGHT answers held), each answer cut to its element's own parts as it arrives.
import type { Session } from "../session.ts";
import { matchedStyles, type MatchedStyles, type NodeRef } from "../cdp.ts";
import { inOrder } from "../in-order.ts";

export const FLIGHT = 4;
export const SELF_CHECK = 3;
// an element's own parts of an answer (what the code reading and the authored values read)
export type Own = Pick<MatchedStyles, "matchedCSSRules" | "inlineStyle" | "attributesStyle" | "pseudoElements">;
export interface AskPlan { own: boolean[]; from: Array<[number, number] | null>; chain: number[] }

// in the page: for the elements on window[Symbol.for(key)], who is asked itself, where the others' rules are found
// ([index of the element asked, place in its parent chain: 0 its parent]) and each element's parent-element count up
// to <html>. Self-contained: it runs in the page.
export function askPlan(args: { key: string; pseudo: boolean; all: boolean }): AskPlan {
  // a path not found (null) is no element: never asked (its NodeRef is 0), never a source
  const els = (window as unknown as Record<symbol, Array<Element | null>>)[Symbol.for(args.key)] ?? [];
  const SAFE = /^(class|id|style|role|href|target|rel|title|alt|src|srcset|sizes|loading|decoding|fetchpriority|tabindex|name|for|itemprop|itemscope|itemtype|itemid|lang|xmlns(:.*)?|aria-.*|data-.*|on.*)$/i;
  const at = new Map<Element, number>();
  els.forEach((e, i) => { if (e && !at.has(e)) at.set(e, i); });
  const parented = new Set<number>();
  for (const e of els) { const p = e?.parentElement; if (p && at.has(p)) parented.add(at.get(p)!); }
  // a shadow tree, the page's own or the browser's (a <details> slots its children into its own: DevTools' `inherited`
  // then lists the slot too, planner's probe on B-Dry's FAQ): never derived across
  const UA_HOST = /^(DETAILS|SELECT|VIDEO|AUDIO|INPUT|TEXTAREA|METER|PROGRESS|OBJECT|MARQUEE)$/;
  const shadowy = (e: Element) => e.getRootNode() !== document || !!(e as HTMLElement).assignedSlot || !!(e as HTMLElement).shadowRoot || UA_HOST.test(e.tagName);
  const draws = (e: Element, p: string) => { const c = getComputedStyle(e, p).content; return !!c && c !== "none" && c !== "normal"; };
  const chain = els.map((e) => { let n = 0; for (let p = e?.parentElement; p; p = p.parentElement) n++; return n; });
  const own = els.map((e, i) => !!e && (args.all || !parented.has(i) || shadowy(e) || [...e.attributes].some((a) => !SAFE.test(a.name))
    || (args.pseudo && (draws(e, "::before") || draws(e, "::after")))));
  const from: AskPlan["from"] = els.map(() => null);
  els.forEach((e, d) => {
    if (!e || !own[d]) return;
    let depth = 0;
    for (let p = e.parentElement; p; p = p.parentElement, depth++) {
      if (shadowy(p)) break;
      const i = at.get(p);
      if (i !== undefined && !own[i] && !from[i]) from[i] = [d, depth];
    }
  });
  // nothing derived without a source: asked itself
  els.forEach((e, i) => { if (e && !own[i] && !from[i]) own[i] = true; });
  return { own, from, chain };
}

const ownParts = (m: MatchedStyles): Own => ({ matchedCSSRules: m.matchedCSSRules, inlineStyle: m.inlineStyle, attributesStyle: m.attributesStyle, pseudoElements: m.pseudoElements });

// every listed element's own parts (null: not an element, or DevTools didn't answer), each asked at most once
export async function askAll(s: Session, refs: NodeRef[], plan: AskPlan): Promise<Array<Own | null>> {
  const out: Array<Own | null> = refs.map(() => null);
  const own = [...plan.own];
  const derived = (i: number, m: MatchedStyles, d: number): Own | null => {
    const e = m.inherited?.[plan.from[i]![1]];
    return e && (m.inherited?.length ?? -1) === plan.chain[d] ? { matchedCSSRules: e.matchedCSSRules, inlineStyle: e.inlineStyle } : null;
  };
  const askOwn = async (list: number[]): Promise<void> => {
    const by = new Map<number, number[]>();   // element asked → the elements it gives rules to
    plan.from.forEach((f, i) => { if (f && !own[i]) { const l = by.get(f[0]) ?? []; l.push(i); by.set(f[0], l); } });
    await inOrder(list, FLIGHT, (d) => matchedStyles(s.page, refs[d].nodeId), async (d, m) => {
      if (!m) return;
      out[d] = ownParts(m);
      for (const i of by.get(d) ?? []) out[i] = derived(i, m, d);
    });
  };
  await askOwn(own.map((o, i) => (o ? i : -1)).filter((i) => i >= 0 && refs[i].nodeId > 0));
  // the guard: derived elements whose source gave nothing are asked themselves
  const missed = refs.map((r, i) => (!out[i] && !own[i] && r.nodeId > 0 ? i : -1)).filter((i) => i >= 0);
  // the self-check: the first derived elements asked as well
  const sample = plan.from.map((f, i) => (f && !own[i] && out[i] ? i : -1)).filter((i) => i >= 0).slice(0, SELF_CHECK);
  let same = true;
  await inOrder(sample, FLIGHT, (i) => matchedStyles(s.page, refs[i].nodeId), async (i, m) => {
    const a = out[i]!, b = m ? ownParts(m) : null;
    const inline = (x: Own | null) => ((x?.inlineStyle as { cssProperties?: unknown[] } | undefined)?.cssProperties?.length ? JSON.stringify(x!.inlineStyle) : "");
    if (process.env.F2B_ASK_BREAK === "1" || !b || JSON.stringify(a.matchedCSSRules ?? []) !== JSON.stringify(b.matchedCSSRules ?? []) || inline(a) !== inline(b)) same = false;
    if (b) { out[i] = b; own[i] = true; }
  });
  const rest = same ? missed : refs.map((r, i) => (!own[i] && r.nodeId > 0 ? i : -1)).filter((i) => i >= 0);
  await inOrder(rest, FLIGHT, (i) => matchedStyles(s.page, refs[i].nodeId), async (i, m) => { out[i] = m ? ownParts(m) : null; own[i] = true; });
  return out;
}
```

   (The builder checks the exact `inlineStyle` shape an own answer has when the element has no inline style, and keeps
   `declsOf`'s result the same for both: the self-check compares an empty inline style as "".)
4. `code.ts` `readCode`: `const refs = await nodesOf(s.page, 'window[Symbol.for("f2b.code")]')`; `const plan = await
   s.run<AskPlan>(askPlan, [{ key: "f2b.code", pseudo: true, all: process.env.F2B_ASK_ALL === "1" }])`; `const answers =
   await askAll(s, refs, plan)`; today's loop over the facts reads `answers[at]` and `answers[inlineAt[k]]` instead of
   `await matchedStyles(…)` (the `own.see(r)` calls stay in the loop); everything after it is unchanged. Before it
   returns, for every listed element with an answer, it stores the authored declarations
   (`authoredDecls(answer)`, below) in `s.declared` (a `Map<backendId, Decl[]>` on the session, cleared by `resize()`),
   and drops `answers`. `askAll` counts its asks on the session (`s.asks`); `capture.ts` writes `timings["asks " +
   r.id]` beside `timings["code " + r.id]` (timings are outside "the same capture", so the file stays the same).
5. `authored.ts`: export `authoredDecls(m: Own): Decl[]` = today's `cascade([...(m.matchedCSSRules ?? []).filter((r) =>
   r.rule.origin === "regular").map((r) => declsOf(r.rule.style.cssProperties)), declsOf(m.inlineStyle?.cssProperties)])`;
   `authoredValues`: `nodesOf` for its paths; each path's declarations from `s.declared.get(backendId)` when there.
   When the code reading ran (`s.declared` not empty), the rest are asked directly, `FLIGHT` at a time (on the B-Dry
   page and `code-page`: `<body>` alone); without it (`code: false`, the importer helper's captures) the whole list
   goes through `askPlan` (key `"f2b.els"`, `pseudo: false`) and `askAll`, so the helper's captures get faster too.
   The var() asks and `settle` unchanged.
6. `capture.ts` (lines 141–144): the code reading first, then the authored values (the page doesn't change between the
   two: neither changes the DOM; the code reading's `delete window[Symbol.for("f2b.code")]` touches no element).
7. GREEN AC8; then `capture-stable`, `capture-code`, `capture-code-page`, `capture-looks`, `capture-stretchy` (the
   authored values' users), `site-page-proof` (AC7 of web-code-page, the fixture paste 1:1). The planner's `profile.mjs`
   on the stand-in for the ledger: asks a range ~578 (from 2,037), the asks' time a range ~45 s (from ~170). Commit.

### Task 4: fold in web-capture-steady (Q4 A)

1. `git cherry-pick 638545b6 3b78b6c5` (branch `web-capture-steady-build`: the check stand-in's `recheck`/`landing`
   modes, `waitsForPerson`, `passwordFields`, the settled document and Justin's 2026-11-04 landing rule in
   `openSession`, `test/web/capture-steady.test.ts`). `src/web/session.ts`, `src/web/human.ts` and
   `test/fixtures/web/check-site.ts` haven't changed on `main` since its base `ea504778` (`git log ea504778..main --
   <those files>` is empty at planning time), so it applies cleanly; drop its `.superpowers/sdd/…steady…` ledger file
   from the commit if it conflicts (keep ours).
2. From the steady plan (`git show web-capture-steady:docs/plans/2026-11-04-web-capture-steady.md`), build what its two
   commits left out: its AC3 (a self-passing 200 re-check: no RELOADED note), AC4 (`human-reload.test.ts` AC4's last
   assertion flips to "no RELOADED note"), AC5 (a reload landing elsewhere, on a log-in or on a check keeps the note) as
   that plan's Task 3 tests say; its AC6 (the command finds Chrome) is already on `main`.
3. Run `test/web/capture-steady.test.ts`, `test/web/human-reload.test.ts`, `test/web/human-check.test.ts`. Commit
   ("capture-speed: web-capture-steady folded in (…)"). Steady's follow-ups F1–F6
   (`~/.hermes/plans/figma-to-bricks/evidence/web-capture-steady/follow-ups.md`) carry into this job's `follow-ups.md`.

### Task 5: a failed page load is loaded again in the same window (AC5)

Files: `src/web/human.ts`, `src/web/session.ts`, `test/fixtures/web/check-site.ts`, new
`test/web/capture-retry.test.ts`.

1. The stand-in: `CheckSiteOptions` gains `refuse?: { kind: "desktop" | "phone"; times: number }` (the first `times`
   page loads of that agent kind (requests for a `PAGES` path whose Accept has `text/html`) answer `403` with `REFUSED`:
   a heading "Access denied", one line, nothing to press, no link; logged as answer `"refused"`) and `drop?: { kind;
   times }` (the same page loads get `req.socket.destroy()`, logged as `"dropped"`).
2. RED `capture-retry.test.ts` (mode `"open"`, invisible capture, `shots: false`, fonts `noFonts`):
   - "AC5 a 403 with nothing to press, once, is loaded again and read": `refuse: { kind: "phone", times: 1 }` → no
     ANSWERED/RELOADED note, `notThePage` empty, 2 ranges, and `timeless(snapshot)` equals a capture of a stand-in with
     no refusal (same server: `site.mode`-style switch, or a second `serveCheckSite` and the origin made the same as
     `capdiff.mjs` does).
   - "AC5 a dropped connection, once, is loaded again and read": `drop: { kind: "phone", times: 1 }`, the same checks.
   - "AC5 a site that keeps refusing is read with its note after three page loads": `refuse: { kind: "phone", times:
     99 }` → the ANSWERED note for the phone range, exactly 3 phone page loads in the log, and the time spent waiting
     ≤ 45 s (10 + 30 + loads).
   - "AC5 a connection that stays down ends with one plain line": `drop: { kind: "phone", times: 99 }` → `captureSite`
     rejects with `PageUnreachable` and its exact text; the snapshot of Chrome's error page is never returned.
   - "AC5 Chrome's error page is never read as a range" (unit-sized, no site): `openSession` on a 127.0.0.1 port
     nothing listens on (the planner's probe used 59999: `net::ERR_CONNECTION_REFUSED`; avoid Chrome's unsafe ports
     such as 9) with the retry waits set to `[50, 50]` rejects with `PageUnreachable`.
   RED on the base: the first two read the refusal/error page (ANSWERED note, or no note at all for the drop), the
   last two return a capture.
3. `human.ts`:

```ts
// a refusal: an error answer that links to no other page of the site and shows nothing to press (yet): a bot check's
// "access denied", a check whose button comes later, a server busy for a moment (capture-speed Q3 A)
export function isRefusal(f: CheckFacts): boolean {
  return f.status >= 400 && f.ownLinks === 0 && f.controls === 0;
}
// how long a refused page load is watched before it is loaded again (each try once); a lost connection waits the same
export const RETRY_MS = [10000, 30000];

export const unreachableText = (host: string, why: string) => `${host} couldn't be reached (${why}), so nothing was captured. Check the connection and press Capture to try again.`;
// the page couldn't be loaded at all (no connection, the server gone): the capture stops with its one line
export class PageUnreachable extends Error {
  readonly host: string;
  constructor(host: string, why: string) { super(unreachableText(host, why)); this.host = host; }
}

// Watches a refused page for up to ms, every half second, sending it nothing: "check" once it shows something a person
// can press (a check whose button came late: isHumanCheck), "page" once another document that is no refusal has
// stayed QUIET_MS (it let itself through), else "same"
export async function watchRefusal(page: Page, host: string, ms: number): Promise<"check" | "page" | "same"> {
  const end = Date.now() + ms;
  let first: number | null = null;   // the refused document (its time origin)
  let calm = null as { origin: number; since: number } | null;
  while (Date.now() < end) {
    const now = await bounded(page.evaluate<TabNow>(TAB_NOW), READ_MS).catch(() => null);
    if (now && now.ready === "complete") {
      first ??= now.origin;
      const facts = await bounded(page.evaluate<{ ownLinks: number; controls: number }>(`(${checkFacts.toString()})(${JSON.stringify(host)})`), READ_MS).catch(() => null);
      if (facts) {
        const f = { status: now.status, reloaded: now.type === "reload", ...facts };
        if (isHumanCheck(f)) return "check";
        if (now.origin !== first && !isRefusal(f)) {
          if (calm?.origin !== now.origin) calm = { origin: now.origin, since: Date.now() };
          else if (Date.now() - calm.since >= QUIET_MS) return "page";
        }
      }
    }
    await sleep(500);
  }
  return "same";
}
```

4. `session.ts` `openSession` (on top of Task 4's version): `SessionOptions.retryMs?: number[]` (default `RETRY_MS`;
   tests pass short ones); a counter `refused` for this session. Right after `const nav = await page.goto(…)` and the
   first `Doc` reading:
   - `nav` not empty (Chrome's error page): `refused < waits.length` → `await sleep(waits[refused++])`, `continue`;
     else `throw new PageUnreachable(host, nav)`.
   - the facts say `isRefusal({ status: d0.status, reloaded: d0.type === "reload", … })` and `refused <
     waits.length`: `const turned = await watchRefusal(page, host, waits[refused++])`; `"check"` → `await meet()`
     (stop mode: `HumanCheckNeeded`, as today); then `continue` (load again) in every case.
   - only then today's (Task 4's) `meets(…)` rule: so in the window a refusal that outlasts both tries waits for the
     person (steady's Q1 A), and invisibly it is read with its ANSWERED note (today).
   The same `nav` rule applies to the loads `meet()` makes after a pass.
5. Existing tests that capture a refusing page on purpose (`capture-not-the-page.test.ts`, `human-check.test.ts` AC1's
   `challenge` case, any found by `grep -l 'challenge\|status.txt' test/web/*.test.ts`) pass `retryMs: [100, 100]` (via
   `captureFixture`/`captureSite` options, the CLI test through `F2B_RETRY_MS=100,100` read in `tools/capture.ts`, tests
   only) so they stay quick; their assertions are unchanged.
6. GREEN; `capture-steady`, `human-reload`, `human-check`, `capture-not-the-page`, `capture-cli`. Commit.

### Task 6: the page kept per kind of visitor (AC4, AC6)

Files: new `src/web/replay.ts`, `src/web/session.ts`, `src/web/discover.ts`, `src/web/capture.ts`,
`test/fixtures/web/check-site.ts`, new `test/web/capture-replay.test.ts`, new `test/web/human-once.test.ts`.

1. The stand-in: `phonePage?: true` (a phone agent's page load of `/` gets the real page with the title "Stand-in
   phone home" and the words "Words for phones.") and `passFor?: number` (a pass holds for that many page loads, per
   agent kind with `bindUa`; a page load is a request for a `PAGES` path whose Accept has `text/html`, so the browser's
   served-HTML download doesn't count; the next page load answers the check again; a trusted click on the check, heard
   through `/heard`, starts a new count).
2. RED `capture-replay.test.ts`:
   - "AC4 one page load per kind of visitor": `serveFixture("code-page")` (3 ranges, one of them a phone range):
     requests for `/` during the capture: the head 3 (the desktop page load, the phone page load, the served-HTML read
     `servedHtml` keeps), the base 5 (search + 3 ranges + served HTML); every range's `web.code.context` and readings
     present; `timeless` capture equal to the same capture with `F2B_REPLAY=0` (tests only: no store).
   - "AC4 a site with its own phone page keeps it": `serveCheckSite({ mode: "open", phonePage: true })`: the phone
     range's words are "Words for phones.", the desktop range's "Words on the page itself."; one page load per kind in
     `site.log`.
   RED `human-once.test.ts` (the helper job, `passedCapture`):
   - "AC6 the check is asked once when the pass holds": `{ mode: "check", passFor: 2 }` → one waiting line, one
     `agents` entry; every range real (no ANSWERED/RELOADED, `notThePage` empty, title "Stand-in home"). Base: 2 waits.
   - "AC6 once per kind of visitor": `{ mode: "check", bindUa: true, passFor: 2 }` → two waits (desktop, then phone).
3. `src/web/replay.ts`:

```ts
// The page as the first good page load of each kind of visitor got it (capture-speed Q2 A): later page loads of the
// same kind (the desktop agent's, the phone agent's) are answered with it inside the tab, so the site is asked for the
// page once per kind instead of once per range, and a site that checks a visitor again after a few page loads meets the
// capture once. Only the page's own document at its address: everything the page asks for itself (styles, scripts,
// pictures, frames) goes out as before. Nothing about the visitor changes: the tab, its agent and its cookies are the
// same. One store per capture (captureSite makes it).
import type { Page } from "../../test/browser/chrome.ts";

export type Kind = "desktop" | "phone";
export interface Answer { url: string; status: number; headers: Array<{ name: string; value: string }>; body: string }   // body: base64

// what a page load may do: load from the answer kept, or load from the site and keep what it answered (end() always)
export type Turn = { answer: Answer } | { keep: (a: Answer) => void; end: () => void };

export class PageStore {
  private answers = new Map<Kind, Answer>();
  private busy = new Map<Kind, Promise<void>>();
  // one page load of a kind asks the site at a time: the others wait for it and then load from what it kept
  async turn(kind: Kind): Promise<Turn> {
    for (;;) {
      const a = this.answers.get(kind);
      if (a) return { answer: a };
      const b = this.busy.get(kind);
      if (!b) break;
      await b;
    }
    let done!: () => void;
    this.busy.set(kind, new Promise<void>((ok) => { done = ok; }));
    return { keep: (a) => { this.answers.set(kind, a); }, end: () => { this.busy.delete(kind); done(); } };
  }
}

const DROPPED = /^(set-cookie|content-encoding|content-length|transfer-encoding)$/i;

type Paused = { requestId: string; frameId?: string; request: { url: string; method: string }; responseStatusCode?: number; responseHeaders?: Array<{ name: string; value: string }> };

// the tab's main frame (its id stays for the tab's life, about:blank included)
async function mainFrame(page: Page): Promise<string> {
  const { frameTree } = await page.cdp<{ frameTree: { frame: { id: string } } }>("Page.getFrameTree");
  return frameTree.frame.id;
}

// the tab answers its own top document from a (the site isn't asked); every other request goes on. Every paused
// request is answered, or the page stalls.
export async function answerFrom(page: Page, a: Answer): Promise<void> {
  const main = await mainFrame(page);
  const headers = a.headers.filter((h) => !DROPPED.test(h.name));
  page.on("Fetch.requestPaused", (q: Paused) => {
    const mine = q.frameId === main && q.request.method === "GET" && q.request.url === a.url;
    const go = mine
      ? page.cdp("Fetch.fulfillRequest", { requestId: q.requestId, responseCode: a.status, responseHeaders: headers, body: a.body })
      : page.cdp("Fetch.continueRequest", { requestId: q.requestId });
    go.catch(() => page.cdp("Fetch.continueRequest", { requestId: q.requestId }).catch(() => undefined));
  });
  await page.cdp("Fetch.enable", { patterns: [{ urlPattern: "*", resourceType: "Document", requestStage: "Request" }] });
}

// the tab tells heard() what the site answered for its top document (a 2xx: status, headers, body), each time
export async function recordTo(page: Page, heard: (a: Answer) => void): Promise<void> {
  const main = await mainFrame(page);
  page.on("Fetch.requestPaused", (q: Paused) => {
    void (async () => {
      const status = q.responseStatusCode ?? 0;
      try {
        if (q.frameId === main && q.request.method === "GET" && status >= 200 && status < 300) {
          const b = await page.cdp<{ body: string; base64Encoded: boolean }>("Fetch.getResponseBody", { requestId: q.requestId });
          heard({ url: q.request.url, status, headers: q.responseHeaders ?? [], body: b.base64Encoded ? b.body : Buffer.from(b.body).toString("base64") });
        }
      } catch { /* not kept: the next load of this kind asks the site */ }
      await page.cdp("Fetch.continueResponse", { requestId: q.requestId }).catch(() => page.cdp("Fetch.continueRequest", { requestId: q.requestId }).catch(() => undefined));
    })();
  });
  await page.cdp("Fetch.enable", { patterns: [{ urlPattern: "*", resourceType: "Document", requestStage: "Response" }] });
}
```

   (The planner's `bench2.mjs` is this, recorded from a network load and answered in a second tab: readings equal, no
   page request. Its probe didn't filter by frame: the builder checks `frameId === main` on the first navigation,
   else keys on the target id, which Chrome uses as the main frame's id.)
4. `session.ts`: `SessionOptions.store?: PageStore`. In `openSession`, before the loop: `const turn = opts.store ?
   await opts.store.turn(opts.phone ? "phone" : "desktop") : null`; with an answer: `await answerFrom(page,
   turn.answer)` and the loop's `goto` goes to `turn.answer.url` (the address the first load landed on); with a keep:
   `await recordTo(page, (a) => { heard = a; })`. Where `openSession` returns the session: when `turn` has `keep`, the
   load is good (no check met since the last load, `s.status < 400`, not `s.reloaded`) and `heard?.url === s.finalUrl`
   → `turn.keep(heard)`. A `finally` calls `turn.end()` (kept or not, thrown or not).
5. `discover.ts` takes `store` through `DiscoverOptions` (the search's page load is the first desktop one); `capture.ts`
   makes one `PageStore` per `captureSite` (unless `F2B_REPLAY=0`, tests only) and passes it to the search and every
   range. `servedHtml` stays as it is (the human-check AC3 test pins its browser download).
6. GREEN AC4, AC6; then `human-check`, `human-reload`, `capture-steady`, `capture-retry`, `capture-stable`,
   `capture-code-page`. Commit.

### Task 7: ranges side by side (AC1 default run, AC7)

Files: `src/web/capture.ts`, `src/web/session.ts` (`SessionOptions.window`), `tools/capture.ts`,
`tools/lib/capture-pages.ts`, new fixture `test/fixtures/web/sites/many-ranges/`, `test/web/capture-windows.test.ts`,
new `test/web/capture-speed-same.test.ts`, `test/web/capture-cli.test.ts`.

1. Fixture `many-ranges/index.html`: a header, three sections and a footer whose CSS has six `max-width` media queries
   (1200, 1024, 900, 767, 600, 420: a column count, a padding, a font size, a display each), so the capture has seven
   ranges; generic words; `<meta name=viewport content="width=device-width">`.
2. RED `capture-windows.test.ts` › "AC7 at most N ranges in hand, at least two at once": capture `many-ranges` with
   `windows: 3` and a spy on `Target.createTarget`/`Target.closeTarget` (open targets over time) and on each range
   session's first `Page.navigate` and last command: at most 3 range sessions + the design width's open at once, at
   least two range sessions' spans overlap, and `timeless` equal to the `windows: 1` capture (› "AC1 four windows
   capture what one window does" in `capture-speed-same.test.ts`: `windows: 4` vs `windows: 1` for `many-ranges` and
   `code-page`). RED: `windows` doesn't exist, ranges never overlap.
3. `capture.ts`: `CaptureOptions.windows?: number` and `export const WINDOWS = 4`. Split today's `readRange` (lines
   104–184) into:
   - `loadRange(r, inWindow)`: the page load and every reading, nothing counted: returns `{ s, read, mine, shots, floats
     }` or `"search again"` (the design width's rule, unchanged). For a range that isn't the design width's, with
     shots on, it pictures every unexpressible box the design width doesn't show and no widget holds (the
     `rangeShots`/`shotsHere` checks move to `done`), keeping `{ path, file: Download | null, failed: string | null }`
     per box in order (`failed`: the note `shot()` would have written; pass a collecting `note` to `shot`).
   - `done(r, got)`: in order: each kept shot not already in `rangeShots` is added (a failed one adds its note after
     the range's own notes, as `rnote` did), then `got.mine` and those notes go through `note` (the range's notes first,
     then its shot notes, de-duplicated as `rnote` did), `rangeFacts.push(...floats)`, `readings[r.id] = read`,
     `opts.onRange?.(r, read)`, and the range's session dropped unless it's the design width's.
   - `loadRange` is two steps, `openRange(r, inWindow)` (the page load; the design width's "search again" rule is decided
     here, right after it) and `readOpened(s, r)` (every reading). The loop: open the design width's range in a tab
     (today's search-again loop, unchanged, around `openRange`); then `inOrder(plan.order, windows, work, done)` where
     the design width's work is `readOpened` on that session (a cut read is read again in a fresh load, as
     `readAgain` does today) and every other range's is `readAgain(typed, () => openRange(r, windows > 1).then((s) =>
     readOpened(s, r)))`. So the design width's readings overlap the first windows. A range that isn't the design
     width's waits for the design width's range to be counted (`wCounted`, a promise `done` resolves) only before its
     shot step (it needs `readings[wRange.id]` and `embedded`); nothing else of it waits.
   - `let closing = false` set first in the `finally`; `loadRange` closes a session that opens after it and throws.
   - With `windows > 1`, once the design width's range is counted, open one `about:blank` tab in its window (closed in
     the `finally`): in the visible "I am human" window today the next range's tab covers the design width's tab,
     which then draws nothing until `ws.front()`; keep it that way there (in headless Chrome 156 a background tab still
     draws, planner's probe, so headless captures don't depend on it).
   `session.ts`: `SessionOptions.window?: boolean` → `browser.newPage({ window: opts.window })`.
4. `tools/capture.ts`: `--windows <n>` (an integer ≥ 1, else usage, exit 2); `PagesOptions.windows`;
   `capture-pages.ts` passes it to `run.capture`; the usage line names it. The helper (`tools/capture-serve.ts`) keeps
   the default.
5. RED/GREEN `capture-cli.test.ts` › "AC7 --windows": `--windows 0` and `--windows x` exit 2 with the usage line;
   `--windows 2` captures `many-ranges` with exit 0.
6. GREEN; then the whole `npm run test:web` once (every capture test now reads with 4 windows). Commit.

### Task 8: the time line (AC9)

1. RED `test/unit/web-took.test.ts`: `tookLine(totalMs, timings, ranges, windows)` (new, `tools/lib/took.ts`) gives
   `Took 7 min 40 s: switch points 1 min 45 s, 16 ranges in 4 windows 5 min 20 s, pictures 30 s, renders 3 s`; one
   range: `1 range in 1 window`; under a minute: `42 s`; missing renders (`--no-shots`): no renders part.
2. `capture-pages.ts` `one()`: measure `run.capture`'s whole time (human waits included) and print `tookLine(…)` right
   after the `File:` line (from `snapshot.web.timings` and `ranges.length`).
3. RED/GREEN `capture-cli.test.ts` › "AC9 the command says how long the capture took" (the line right after `File:`,
   matching the shape). Commit.

### Task 9: the proofs against the base (AC1 named, AC2, AC3, AC10)

1. `test/web/capture-speed-same.test.ts` › "AC1 every fixture site captures as it did before" (named-only,
   `F2B_BASE_TREE`): for each Task 0 fixture, one server; `await import(join(F2B_BASE_TREE, "src/web/capture.ts"))`'s
   `captureSite` and the head's, each with a fresh `launchChrome()` and the fixture's usual options (`fontSource:
   standIn(fx)`, `shots` as its tests use); `timeless` equal, else the first differing path (`firstDifference`).
2. `test/web/capture-speed-bdry.test.ts` (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`,
   `F2B_BASE_TREE`, optional `F2B_CAPTURE_SPEED_EVIDENCE`): build the stand-in once (`buildStandIn`), serve it, launch
   Chrome with web-code-page's `OFFLINE` host rules for each capture; capture with the base (shots off, as
   `site-page-bdry.test.ts` does) and time it; capture with the head and time it; AC2: the same capture, and
   `siteParts(…, { text: "rich" })` payloads of both written with `tools/site.ts`'s writer are byte-identical (run `node
   tools/site.ts <file> <dir>` on both saved files, compare every file); AC3: the time assertion; write both times and
   the head's phase table (`web.timings`) to the evidence folder.
3. Run `test/web/site-page-bdry.test.ts` on the head (AC2's 2 px clause).
4. AC10 gates on the head: `npm run check`; `npm run test:web` file by file (names vs Task 0); `npm run test:browser`;
   `npm run corpus`; the five replays (`cmp` with the base's); `git diff --stat main...HEAD -- src/core src/plugin
   src/shared src/ui` empty. Commit the receipts' summary in the ledger.

### Task 10: records

- `docs/HANDOFF.md`: a new top section "Capturing a site in minutes (capture-speed, website importer; build …)": what
  changed in plain words (windows, the page kept per kind, failed loads tried again, the time line), the ⭐ answers
  taken, the measured times (this plan's table, then the head's), the files, the tests per AC, web-capture-steady folded
  in, follow-ups. Status line for CLAUDE.md through the finisher (`…-claude-md-pending.md` if refused).
- `docs/specs/web-capture.md` "How it reads a page": ranges read in up to `windows` windows, counted in order; the page
  kept per kind; a refused or failed load tried again; `PageUnreachable`.
- `follow-ups.md` (evidence folder): steady's F1–F6, plus "Not done here" under "Risks" below.

### Task 11 (only if AC3 fails after Task 9): the design width's readings during the search

If the head's stand-in time misses AC3: start the design width's page load as soon as the search's page load is good
(its answer is kept, Task 6) and read its anchor (fonts, full, authored, code) in its own tab while the search resizes
through its boundaries; its light readings and everything else wait for the switch points. Ask the orchestrator first:
it changes the order of page loads (the notes still come out in order).

## Risks, trade-offs, what is left out

- **Windows on Justin's screen.** In the "I am human" run the windows are real (Q1). On the Mac, a window fully covered
  by another may be marked hidden by Chrome's occlusion tracking, and a hidden window draws no frames (the freeze's
  scroll waits then run slower, lazy pictures may load later). No flag is added for it (the AC5 pin of `chromeArgs`
  stays); if a visible Mac capture differs from an invisible one, `--windows 1` is the way back and a follow-up can
  place the windows side by side (`Target.createTarget` takes `left`/`top`). The desktop's WSLg windows were not seen
  to occlude in any earlier job.
- **Memory.** Four B-Dry windows measured 3.3 GB resident (each process's shared pages counted again; the cgroup's
  real use is lower), and the capture holds five pages (the design width's and four windows): the B-Dry named tests
  run under `systemd-run … -p MemoryMax=6G` (the WSL cap is 20 GB; watch earlyoom); the fixture tests stay under 4G. In
  Node, `askAll` holds at most `FLIGHT` whole answers (each ~600 KB of JSON) and keeps only each element's own parts
  (~5% of an answer) until the code reading has read them; the planner's own probe ran Node out of its 2 GB heap by
  keeping 900 whole answers, so never keep whole answers.
- **Another Chrome.** That an ancestor's `inherited` entry equals its own answer is proved on this desktop's Chrome
  for Testing 156 only. Justin's Mac runs his own Chrome: the chain guard and the per-page-load self-check fall back to
  asking every element (as today, once each) if a Chrome lists ancestors otherwise, so a capture there is slower, never
  different. The fallback is silent in the file (no note: the file must stay the same); `web.timings` gets an
  `asks <range>` count so a slow capture can be told apart.
- **CPU-bound waits.** The freeze's limits (45 s scroll budget, 6 s entrances, 8 s reveal check) are limits, not
  sleeps; four windows share the CPU (24 threads here, fewer on the Mac), so on a slow machine a limit can bite where it
  didn't (a later lazy picture, an "unchecked" note). AC1/AC2 prove it doesn't on this desktop; `--windows` lowers it.
- **The page kept per kind** assumes the site answers the same page to every load of one agent (true for a cached
  WordPress page; a page with a per-load nonce or a rotating quote now reads the same in every range, which only makes
  the ranges agree). A site answering phones its own page keeps it (AC4's second case). Its styles, scripts and
  pictures are still asked by each load (Chrome's cache answers what it may), so a site whose bot check also refuses
  those files can still refuse; Task 5 handles the page load, not its files.
- **Left out on purpose (rejected):** one page load resized through every width (web-capture Q1 B: scripts lay out
  differently; 36 boxes differed at 390 on bdryswi.com); fewer widths or merged ranges (changes the capture and the
  paste); reading the code once and only geometry per width (a range's matched rules come only from that width's media
  state; working them out ourselves would re-implement the cascade and risk the 1:1 paste); a cheaper DevTools call (none
  returns matched rules without the inherited ones); anything that hides automation.
- **Not done here (follow-ups):** the pictures phase still downloads 4 at a time with a 30 s browser timeout tried twice
  (216 s on 2026-11-07 with the wifi down, 15–21 s otherwise: small once the network is up); the switch-point search
  itself (60 s on the stand-in, 105–128 s live; 56% of it the every-property reads, `read/every-fact.ts`) is unchanged;
  `servedHtml` still downloads the page once more (human-check AC3 pins it).

## The plan's own code, checked

Every fenced block of this plan was pulled out of this file by a script and checked (scripts in the evidence folder;
their paths point at the planner's scratchpad and `~/.cache/cs-p`: edit before reuse): Task 2's `inOrder` runs and
passes its three named behaviours and `tsc --strict` (`check-inorder.mjs`); Task 3's `askPlan` typechecks
(`check-inorder.mjs`) and, run in the page by `bench5.mjs` on `code-page` and the B-Dry stand-in, gives the derived
rules byte-identical to the own answers (above); Task 3's `matched.ts` typechecks against the cdp.ts additions it names
(`check-matched.mjs`); Task 5's `human.ts` block typechecks appended to `src/web/human.ts` (`check-human.mjs`); Task 6's
`replay.ts` typechecks with Task 1's `Page.on` (`check-replay.mjs`). Not run: the RED tests (they need the code they
test), the `capture.ts` split (described, not pasted).

## Completion contract

The builder stops at `ready-for-review` with: every task committed on its branch, the ledger committed, receipts in
`E/` (base tally, per-AC RED and GREEN logs, the stand-in times and phase table, the five replays' `cmp`), and a report
naming per AC its test, RED/GREEN and evidence path. Reviews (repo CLAUDE.md, website importer: one fresh review, real
bugs only; a second only to check a major fix), the verifier, the blind auditor and `ac-check.sh` follow; AC11 is
Justin's live run, owed after the merge (`READY FOR THE USER`).
