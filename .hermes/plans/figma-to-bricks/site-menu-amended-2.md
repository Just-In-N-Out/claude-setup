# site-menu (website importer): what a site's ☰ and pop-up links open becomes a working Bricks Offcanvas

Planner: Opus 5.5 (high), 2026-11-09. Base: main `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3).
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-menu/planner/` (scripts `nodes.mjs`, `popup27.mjs`,
`paste-burger.mjs`, `widgets.mjs`; Bricks sources `offcanvas-2.2.php`, `offcanvas-2.2.min.css`, `interactions-2.2.php`;
live copies `offcanvas-darksalmon-2.3.9.min.css`, `offcanvas-bdry-staging-2.4.2.min.css`,
`bricks-bdry-staging-2.4.2.min.js`; `popup27.html` (the saved template); `base-unit.log`; `SHA256SUMS`).
Pipeline: Full. Website importer rules apply (one real-bug review per job, edge cases to follow-ups).
Since the moves onto main (stacks 6 and 13, fixer 6) the branch sits on main `11e885fda5d08863a5875f939085350c007ac732` [amended A10]
(Build 2026-11-10.8): that commit is the base of every base-against-head check; `fd1986dc` is where the job was planned. [amended A10]

## Amendments

2026-11-10, planner (Opus 5.5, high; wording only: no acceptance criterion added, removed or renumbered, every cited
test name kept). Set against head `4dd1a2755937da00b28bd7cf8cdf18ab0f1552fe` (branch `site-menu-fix4`, on main
`3cfc54ac`; review 5 clean) and its real output, the offline B-Dry dry run
`evidence/site-menu/fixer-4/bdry-dryrun/final-c7b01781/` (both routes: the header's menu Offcanvas with Content and
Backdrop, the page's three hotspot Offcanvases with Content alone and `closeOn: "esc"`, every part's root carrying the
two Remove attribute Interactions, each hotspot carrying Toggle offcanvas then Set attribute). The pre-amendment text is
the approved copy `evidence/site-menu/plan-approved.md`, byte for byte `git show 4dd1a275:docs/plans/2026-11-09-site-menu.md`
(sha256 `57ffed8e…7e10`). Every changed line carries **[Amendment N]**.

1. A box whose clicks outside its panel reach the page (review 1's R1-3, fixed by fixer 1; review 2's R2-1, fixed by
   fixer 2; review 2's R2-4 names the lines): such a box (`CodeOpen.through`: a pop-up without an overlay, whose root
   may cover the window but takes no clicks, or a drawer that is only its panel) pastes an Offcanvas with the Content
   Block only, `closeOn` `"esc"` or `"none"`; where the site closes it on a click outside it, it closes through Bricks
   Interactions on every part's root (Click → Remove attribute `class` `brx-open`, acting only on its open boxes: the
   selector names `.<marker>.brx-open`, review 2's R2-1) and on its openers (Click → Set attribute
   `data-site-opening`). Any opened root but a cover's takes its own clicks (`pointer-events: auto`). Lines: the
   acceptance criteria for the shape (the Offcanvas's Blocks, its sample shape), "How the Offcanvas is built",
   "Openers", Task 4's bullets.
2. The `CodeOpen` type as the head has it (review 2's R2-4; the continuation builder's dry-run fix, HANDOFF "An
   Elementor pop-up is no one element"): `target` is an ARIA box's path or an Elementor pop-up's own id
   (`elementor-popup:<id>`), and the type gains `through` and `motion` (the entrance animation as it played: the paste
   plays that). Lines: the type, the capture criterion's field list, "The motion".
3. A closed `details` (review 1's R1-1, fixed by fixer 1; review 2's R2-4): its content is read while it is open (one
   details at a time, by its `open` attribute alone, every details put back as it was), and the open reading's elements
   replace its content's, so the paste holds the look it has open. Lines: the closed-details criterion, "A closed
   `details`", "Nothing changes where nothing opens", and the older-captures criterion (an older capture's closed
   `details` pastes its hidden content too: the builder's own, the header of `test/unit/site-opens-old.test.ts`).
4. Which page load proves a box's close (review 1's R1-2, fixed by fixer 1): the design width's when an opener shows
   there, else the widest range's where one does; a bare `#` inside an opened box stays `#`. Lines: the general rule,
   the new section "Where a box's close is proven", the Architecture's `readOpens`, `capture.ts` and `links.ts` bullets.
5. What the capture may press, and the press guard (review 1's R1-5; review 2's R2-2 and R2-3, fixer 2; review 3's
   R3-1 and R3-4, fixer 3; review 4's R4-1, R4-3 and R4-4 with Justin's "Fix the new window gap", fixer 4; review 5
   clean): the new section "What the capture may press, and the press guard", as the head has it. A write to another
   site is failed, listed apart and never counted against a press: fixer 2's ruling, upheld by review 3's R3-2, **to be
   confirmed with Justin**. What the reviews left open in normal use is under "Risks and limits".
6. Other lines the head makes false (reviews 1–5's P3s and HANDOFF's site-menu section, "builder's ruling" and "not yet
   confirmed" lines, set against each criterion): the `site-offcanvas` text and where it lives (`opens.ts`
   `OFFCANVAS_CSS`, added only to a part holding a box, never `SHARED_CSS`); the motion CSS (the closing animation under
   a second name, `<name>-out`; the played animation); an opener that is a link stays a link with `href="#"`, and a
   capture with `opens` whose box wasn't read has a note of its own (the builder's; the converter criterion's test
   asserts the link); `src/core/emit/payload.ts` changes too (the Content Block's `deletable`/`cloneable`); the
   capture criterion's last clause (`web.code.keyframes` also holds the boxes' own: the plan's own `assembleOpens` and
   that criterion's test since the builder); Task 2's `openersOf` block is superseded by the head's; Task 3's and Task
   8's cited test names, which the approved copy wraps over two lines, are put whole on one line ("a closed details
   pastes its hidden content" and "Justin's bdryswi.com capture pastes the menu pop-up and its two openers": both were
   already whole on their criteria's own lines).

**Receipts made before these amendments that encode an old expectation** (sorter
`~/.cache/smn-pa/sorter.sh <heads>`, a `git show <head>:<file> | grep -c '<marker line>'` per column, run on every
head the site-menu evidence names; 0 = old, ≥1 = new; columns `shp1` (`theirKids.slice(0, 1)` in
`test/unit/bricks-shapes.test.ts`), `det2` (`contentOpen(reading` in `src/web/read/code.ts`), `thr3` (`isThrough` in
`src/core/site/opens.ts`), `open4` (`.brx-open:not([` in `opens.ts`), `prv5` (`leftToProve` in
`src/web/read/opens.ts`), `frm7` (the form test in `openers.ts`), `sw8`/`win9` (the worker bypass on the page / on a
press-opened window in `src/web/press-guard.ts`); and `test/fixtures/web/sites/site-menu/style.css`'s
`:not([open])` rules):
- the shape test's builder receipt `evidence/site-menu/builder/ac7/green-head.log` (stamped `HEAD=f6576e34 dirty=11`:
  it ran the next commits' uncommitted test, so it is sorted by its log, which passes the two-Block assertion
  `2681b812`'s file holds, `shp1` 0) asserts Content and Backdrop under every Offcanvas; from `e68ef01a` (fixer 1) the
  footer drawer's Offcanvas holds Content alone (`shp1` 1). It holds for its own tree only; the verifier re-runs it on
  the new head.
- the builder's capture, browser-proof and closed-details receipts (`builder/ac1/` at `3dac1758`, `builder/ac3/` at
  `7705ceb2`, `builder/ac5/` at `afd12931`) ran on the fixture before R1-1's closed-state rule (0 `:not([open])` rules;
  3 from `71c075c5` on) and before the open reading (`det2` 0; 2 from `71c075c5`): their assertions are unchanged, but
  they don't prove the amended closed-details criterion (the look a `details`' content has open).
- the converter criterion's builder receipt (`builder/ac2/` at `7705ceb2`): since then the cited test gained one
  assertion (an opener outside the parts is no opener of the paste, its fixture that opener) and its file one more
  test; its other assertions are unchanged, so the receipt holds for what it asserted; the drawer's Content-alone shape
  is the shape criterion's (above).
- every receipt before `82367a5b` (`frm7` 0) ran a capture that presses some controls inside a form (fixer 1 left
  out only a form's buttons and inputs; before it, none) with no press guard; before `3099a2ff` (`sw8` 0) the guard
  could be bypassed by the page's service worker, and before `b870a7a6` (`win9` 0) by a window a press opens: none of
  those heads' receipts is a receipt for the amended press rule.

**Second amendment, 2026-11-10 (night)**, planner (Fable 5.2, high; wording only: no acceptance criterion added, removed [amended A7, A8, A9, A10, A11]
or renumbered, every cited test name kept and whole on one line). Set against head [amended A7, A8, A9, A10, A11]
`058ec3ea04203d4793e862b1f882c7a1fdbb7695` (branch `site-menu-fix7`, on main `11e885fda5d08863a5875f939085350c007ac732`, [amended A7, A8, A9, A10, A11]
Build 2026-11-10.8; reviews 8 and 9 found the head right: R8-1 closed, the rest P3s in [amended A7, A8, A9, A10, A11]
`evidence/site-menu/follow-ups.md`) and its code, not the ledger's words: `src/web/socket-gate.ts`, [amended A7, A8, A9, A10, A11]
`src/web/press-guard.ts`, `src/web/capture.ts` (`launchCaptureChrome`), `src/web/read/opens.ts`, [amended A7, A8, A9, A10, A11]
`src/web/read/tracker.ts`, `src/core/site/media.ts` (`madeInOpen`), `tools/lib/site-upload/pictures.ts` (`uploadList`), [amended A7, A8, A9, A10, A11]
`src/core/snapshot/web.ts` (`CodeOpen.makers`), `test/unit/capture-chrome.test.ts`. Amendments 1–6 above are A1–A6; [amended A7, A8, A9, A10, A11]
these are A7–A11. The pre-amendment text is the approved copy holding A1–A6 (`evidence/site-menu/plan-approved.md` [amended A7, A8, A9, A10, A11]
until this one is installed, sha256 `1b1c470b…cdac`; the orchestrator moves it aside as `plan-approved-v2-A1-A6.md`). [amended A7, A8, A9, A10, A11]
The first approved text is `plan-approved-v1-before-amendments.md` (sha256 `57ffed8e…7e10`), byte for byte [amended A7, A8, A9, A10, A11]
`git show 058ec3ea:docs/plans/2026-11-09-site-menu.md`: the in-repo plan was never amended. Every line this amendment [amended A7, A8, A9, A10, A11]
changes or adds ends with its tag, `[amended A<n>]`; the fenced blocks under "For the merge finisher" hold text to be [amended A7, A8, A9, A10, A11]
copied as it stands and carry no tag (the lines that lead into them do). [amended A7, A8, A9, A10, A11]

- A7, sockets (fix pass 6; review 7's R7-2; Justin, 2026-11-10, "Block sockets (Recommended)", [amended A7]
  `evidence/site-menu/review-7/justin.json`): every Chrome a capture starts goes through one launch [amended A7]
  (`launchCaptureChrome`), and its WebSockets pass a socket gate in the capture's own process, shut while the capture [amended A7]
  presses. Lines: the paragraph after "Nothing changes where nothing opens", the press section's first lines, its new [amended A7]
  **Sockets** bullet, its undo list, the Architecture's new bullet, the first criterion's Supporting line, "Risks and [amended A7]
  limits" (the worker bullet, F6-1, F6-3, the cost). [amended A7]
- A8, whose a refused socket is (fix pass 7; review 8's R8-1; Justin, 2026-11-10, "Fix it (Recommended)", [amended A8]
  `evidence/site-menu/review-8/justin.json`; review 9 measured what stays): a refusal counts against a press only when [amended A8]
  that pressing page's own sessions reported the socket. Lines: the press section's **How a refusal is charged** [amended A8]
  bullet, the first criterion's Supporting line, "Risks and limits" (F6-2 as narrowed, F6-5, F7-1 with review 9's [amended A8]
  rates, F7-2, F7-3, R8-3, R8-4, R9-1 … R9-4, R9-6). [amended A8]
- A9, the pictures of an opened box (fix pass 6; review 7's R7-1 with stack 13's S13-1; Justin, 2026-11-10, "Upload [amended A9]
  them too (Recommended)", `evidence/site-menu/review-7/justin.json`): `CodeOpen.makers`, the rule `madeInOpen`, the [amended A9]
  capture's own press under a source name the tracker skips, no address on both of `site:upload`'s lists. Lines: the [amended A9]
  new section "The pictures of an opened box", the lines under the `CodeOpen` type, the Architecture's new bullet, the [amended A9]
  first and second criteria's Supporting lines, "Risks and limits" (F6-4, F6-6, R8-2). [amended A9]
- A10, where this job meets the jobs merged or queued since it was planned (stacks 6 and 13, the moves onto main; [amended A10]
  no behaviour beyond what reviews 6 and 7 found right): the base is main `11e885fd`; stack 13's joins with [amended A10]
  site-media-upload and staging-fit-cancels are named as supporting tests of the second criterion; the join with [amended A10]
  site-one-command (unmerged) is spelled out for whichever job merges second. Lines: the title block's base lines, the [amended A10]
  second criterion's Supporting line, "Overlaps" (three new bullets). [amended A10]
- A11, for the merge finisher: the exact lines for site-media-upload's records (its HANDOFF section's Q3 A, the repo [amended A11]
  `CLAUDE.md` decision bullet, its merged plan's Q3 and an Also line under its upload-list criterion) and this job's [amended A11]
  own records that review 9 found untrue or short (HANDOFF's IPv6 words and F7-1's rate; a code comment and a unit [amended A11]
  test's input are named for the fix of R9-2, not edited). Lines: the new last section. [amended A11]

**Receipts made before A7–A9 that encode an old expectation** (sorter [amended A7, A8, A9]
`evidence/site-menu/planner-amend-2/sorter.sh <heads>`, a `git show <head>:<file> | grep -c '<marker line>'` per column, [amended A7, A8, A9]
its output `sorter.out` beside it: the 233 commits the site-menu evidence and ledger name; 0 = old, ≥1 = new; columns [amended A7, A8, A9]
`sock7` (`gate.shut(true)` in `src/web/press-guard.ts`), `lcc7` (`launchCaptureChrome` in [amended A7, A8, A9]
`test/unit/capture-chrome.test.ts`), `mk9` (`export function madeInOpen` in `src/core/site/media.ts`), `prs9` [amended A7, A8, A9]
(`export const PRESS_SOURCE` in `src/web/read/opens.ts`), `clm8` (`private claim(` in `press-guard.ts`), `stl8` [amended A7, A8, A9]
(`const SETTLE_MS` there), `rep8` (the case named "a refused socket no pressing page reported blames no press" in [amended A7, A8, A9]
`test/unit/web-press-guard.test.ts`), `blob8` (`Atomics.wait(` in `test/web/press-guard-sockets.test.ts`)): [amended A7, A8, A9]
- every receipt of a head with `sock7` 0 (all before `24150304`, which was `b638d4f0` before the last move onto main: [amended A7, A8, A9]
  the builder's, fixers 1–5's, stacks 6 and 13's, review 7's head `efd50486`) ran a press guard that held no WebSocket [amended A7, A8, A9]
  (fixer 6's RED on `efd50486`: 5 handshakes and 7 messages reached the fixture's servers): none is a receipt for the [amended A7, A8, A9]
  amended press rule. The seven criteria's cited tests are unchanged from `efd50486` to the head (their files byte for [amended A7, A8, A9]
  byte, but `test/web/capture-opens.test.ts`, which gained one test, 20 lines added and none changed; of the 28 test [amended A7, A8, A9]
  and tool files they import, three changed: `test/fixtures/web/serve.ts` now answers WebSocket handshakes, and the [amended A7, A8, A9]
  site-menu fixture opens none; `test/browser/chrome.ts` gained `launchChrome`'s `sockets` option, off for a test's [amended A7, A8, A9]
  own Chrome; `test/web/lib/site-page-check.ts` a comment, from control-weight on main), so an earlier green log holds [amended A7, A8, A9]
  for what it asserted on its own tree and its own base (the head sits on main's Builds 2026-11-10.7 and .8 too); the [amended A7, A8, A9]
  verifier runs each on the head. [amended A7, A8, A9]
- fix pass 6's guard receipts (`sock7` 1, `clm8` 0: `24150304` … `86fc5546`, and the logs stamped `HEAD=efd50486 [amended A7, A8, A9]
  dirty=11…13` that ran its uncommitted change: `fixer-6/unit-guard.log`, `unit-socket-gate.log`, [amended A7, A8, A9]
  `green-sockets-web.log`, `guards-all.log`; also `quick-units.log`, `own-chrome-web.log`, `gates/units.out`, [amended A7, A8, A9]
  `gates/web-capture-opens-guards.out`) encode the old charging: a refused socket counted against every page pressing [amended A7, A8, A9]
  at that moment (review 8's R8-1). Two of that pass's unit cases were changed by fix pass 7 (they now send the page's [amended A7, A8, A9]
  own report before the refusal): their fix-pass-6 logs are receipts of the old rule. That nothing reached a server [amended A7, A8, A9]
  (0 handshakes, 0 messages) is the same assertion before and after. [amended A7, A8, A9]
- `clm8` 1, `stl8` 0 (`54a3cd53`, `8b0d9fbe`, `637a6574`; `fixer-7/green-beat-capture.log`, [amended A7, A8, A9]
  `green-press-guard-sockets.log`, `green-unit-guard.log`): a message on a socket of no known address could still take [amended A7, A8, A9]
  another pressing page's refusal (fixer 7's own RED, `fixer-7/red-unit-settle.log`); from `4b1ef76c` it claims only [amended A7, A8, A9]
  what is left. The gates of fix pass 7 (`fixer-7/gates/`, stamped `4b1ef76c`) ran the rule as the head has it. [amended A7, A8, A9]
- `test/web/press-guard-sockets.test.ts` before `2a438c7b` (`blob8` 0; `fixer-7/gates/web-3-press-guard-sockets.log` [amended A7, A8, A9]
  too): its new-worker clause was a race (mutant N11 survived 1 run of 3, then 2 of 3); only the logs of `2a438c7b` or [amended A7, A8, A9]
  the head (`fixer-7/green-press-guard-sockets-blob-1.log` … `-3.log`) prove that a worker a press starts waits until [amended A7, A8, A9]
  it is watched. [amended A7, A8, A9]
- the launch pin (`lcc7` 0 before `7094a7d4`, which was `3563abf7` before the last move): the case of [amended A7, A8, A9]
  `test/unit/capture-chrome.test.ts` pinned `launchChrome(…)` in `tools/capture.ts`; it now pins [amended A7, A8, A9]
  `launchCaptureChrome(…)` there, and after the join with site-one-command pins it in `tools/lib/capture-run.ts` [amended A7, A8, A9]
  ("Overlaps"). [amended A7, A8, A9]
- the pictures (`mk9` 0 before `6c06bfd5`, which was `a6f5cccc`): stack 13's receipts and its meet probe list every [amended A7, A8, A9]
  picture under a pop-up's script-made root as another company's (S13-1); `prs9` 0 (before `44abbc32`, which was [amended A7, A8, A9]
  `a136b262`): the capture's own press read as code with no file, so on B-Dry's stand-in every pop-up element's [amended A7, A8, A9]
  makers were `popup.js` plus `about:inline-code` and its pictures stayed. [amended A7, A8, A9]
- the other logs of `fixer-6/` stamped `HEAD=<sha> dirty=N` (`b638d4f0`, `a6f5cccc`, `3563abf7`, `44abbc32`, [amended A7, A8, A9]
  `bef1b0d8`, `ef868ab3`) held the next commit's change: each is sorted by what its log shows, not by its stamp. [amended A7, A8, A9]

## Questions (⭐ = taken under the standing auto-go unless Justin says otherwise)

- **Q1 Which Bricks parts?**
  - ⭐ **A:** Bricks' **Offcanvas** holds the site's own opened panel, and the site's own ☰ element (its exact drawing,
    unchanged) opens it through a Bricks **Interaction** (Click → Toggle offcanvas). Bricks' own script opens, closes,
    traps focus, makes the ☰ focusable (`tabindex="0"`, `aria-expanded`) and handles Escape and the dim.
  - B: Nav (Nestable) and its mobile menu (Bricks' own ☰ bars; the site's panel layout, photo and dim are lost; it
    is built for a row of links, not a panel holding a logo, an accordion and a button).
  - C: Offcanvas opened by a Bricks Toggle element (Bricks' bars or an icon font, not the site's drawing).
- **Q2 Which openers?**
  - ⭐ **A:** every link or button inside the page's parts that opens a box lying outside them: a page builder's pop-up
    link (Elementor's `#elementor-action…popup:open`) and any `aria-controls` toggle. On bdryswi.com: both ☰ (pop-up
    27, the menu) and the four other pop-up links of the page (hotspots → 1453, 1458, 1542; a button → 1731). One code
    path; nothing names a menu.
  - B: only the header's ☰.
- **Q3 The Offcanvas sample** (`reference/bricks/` has none: CLAUDE.md "Waiting on the user: Bricks samples").
  - ⭐ **A:** build now on a researched candidate `reference/bricks/offcanvas.json` (Bricks 2.2 GPL source
    `offcanvas.php` / `interactions.php`, the 2.4.3 schema, the 2.3.9 and 2.4.2 front-end CSS and JS read from Justin's
    sites; Task 1), as nav-nested was built; Justin's own copy replaces it when he sends it.
  - B: wait for his copy first.
  - Either way, the copy wanted (one action each): in Bricks, Add element → **Offcanvas**; add a **Div**, open its
    Interactions, add one: Trigger **Click**, Action **Toggle offcanvas**, Offcanvas CSS selector `.my-menu`; give the
    Offcanvas the class `my-menu` (Style → CSS → CSS classes); select both → right-click → **Copy**; paste the text to me.
- **Q4 Opening and closing motion.**
  - ⭐ **A:** the site's own: the panel plays the site's opening animation (its keyframes, duration and easing:
    bdryswi.com's fadeInRight, 0.75 s) each time it opens, and the same animation backwards as it closes; under
    reduced motion it opens and closes at once.
  - B: Bricks' slide from the side (0.2 s).
- **Q5 The menu's "Services" list** (an Elementor nested accordion: `details`/`summary`).
  - ⭐ **A:** kept as the site's `details`: it opens and closes with the browser's own behaviour and its seven links
    are pasted (the hidden content of a closed `details` pastes). Its chevron keeps the closed drawing while open
    (follow-up: the nested-accordion conversion, which overlaps site-faq).
  - B: a Bricks Accordion (Nestable) (needs the nested-accordion conversion first).
- **Q6 How it closes.**
  - ⭐ **A:** as the capture proves the site does: Escape and/or a click outside the panel (each only when the site's
    does), and the site's own × (any control in the opened box that the capture proved closes it).
  - B: Bricks' defaults always (dim click + Escape).

## Playback (plain words)

1. Justin pasted bdryswi.com's whole home (`--elementor`, Build 2026-11-09.3) on B-Dry staging `/homev2/`.
2. On bdryswi.com, the orange ☰ at the top right opens the site's menu: a panel slides in from the right over a dim,
   holding the logo, "Services" (opens to 7 service links), About Us, Service Areas, Warranty, Contact Us, the phone
   number and "Get Your Estimate".
3. In the paste the ☰ does nothing (screenshot `images/3.png`). He wants the importer to understand that a ☰ (and any
   such action) opens something, and to build it as working Bricks parts, at every width, with the site's links.
4. General rule wanted: whatever a part's link or button opens on the old site opens the same way in the paste.

## What the site does (proof)

- Both ☰ are Elementor Icon widgets (`a99df50` in the desktop bar, the phone bar's twin) whose link is
  `#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3DeyJpZCI6IjI3IiwidG9nZ2xlIjpmYWxzZX0%3D` = open pop-up
  `{"id":"27","toggle":false}` (`nodes.mjs` on Justin's capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`):
  - `body/div:0/header:0/div:0/div:2/div:1/div:0/div:0/a:0` (an `a` holding `i.icon.icon-menu-11`, an ElementsKit
    glyph), shown 768 and up;
  - `body/div:0/header:0/div:1/div:2/div:0/div:0/a:0` (`i.icon-menu-circle`), shown 991 and down.
  - The page part holds four more pop-up links: hotspots `…/div:13/div:0/div:1/div:0/div:0/a:0..2` → 1458, 1453, 1542;
    a button `…/div:13/div:0/div:1/div:2/div:0/div:0/a:0` → 1731.
- Pop-up 27 is a hidden child of `<body>` (`popup27.mjs` on the saved 2026-10-29 home,
  `evidence/web-code-proof/inputs/bdry-2026-10-29/home.html`, 12,383 bytes): `div[data-elementor-type=popup]
  [data-elementor-id=27]` with settings `entrance_animation: fadeInRight`, `exit_animation: fadeInRight`, duration
  0.75, `a11y_navigation: yes`; inside: an `article` container (background slideshow of one photo, a mountains shape
  divider, a 64vh minimum height, a navy gradient overlay), a spacer, the logo (link home), a nested accordion
  (`details#e-n-accordion-item-3520` "Services" → Foundation Repair, Basement Waterproofing, Crawlspace Repair, Basement
  Windows, Egress Windows, Sump Pump, Exterior Drainage), heading links About Us, Service Areas, Warranty, (a heading
  hidden at every width), Contact Us, a phone icon `tel:8124362379`, a button "Get Your Estimate" → /contact-us/.
  **It holds no WPForms form** (`grep -c wpforms popup27.html` = 0; the staging-fit note read 20,000 characters, past
  the template's end into pop-up 1458).
- When opened, Elementor Pro's script moves the template into a dialog it builds,
  `div#elementor-popup-modal-27.dialog-widget.dialog-lightbox-widget.elementor-popup-modal` › `.dialog-widget-content
  .animated` › `.dialog-message` (+ `.dialog-close-button`), styled only by rules that need that dialog (home.html's
  inline CSS): `#elementor-popup-modal-27{background-color:#00000042;justify-content:flex-end;align-items:center;
  pointer-events:all}`, `.dialog-message{width:25vw;height:auto}` (40vw ≤1024, 85vw ≤767), `.dialog-widget-content
  {animation-duration:.75s;border-radius:20px;box-shadow:2px 8px 23px 3px rgba(0,0,0,.2)}`, `.dialog-close-button
  {display:flex;top:1%;right:1%;font-size:24px}` (css1.css: `[data-elementor-type=popup]:not(.elementor-edit-area)
  {display:none}`, `.elementor-popup-modal.dialog-type-lightbox{display:flex;pointer-events:none…}`). So the panel's
  look exists only once a visitor opens it: reading the hidden template can't give it.

## What the paste does (proof)

- Today's header paste (`paste-burger.mjs` on `/home/justin/f2b-test/paste-el3/header.json`): both ☰ `a`s are plain
  Divs (`home__call-us__inner-efra`, `home__section__inner-zjfw`) with no link and no interaction; the paste holds no
  pop-up content at all. `notes.txt`: "a menu button opens nothing yet: its link was the page builder's pop-up action
  (the menu job)".
- Staging (`evidence/staging-fit/planner/staging/homev2-2.html`, logged-out GET): `<div class="brxe-div
  home__call-us__inner-efra">` with no `data-interactions`; no `brxe-offcanvas` on the page. (Class Interactions do
  print there: entrances show `data-interactions` on `home__over-oakj` etc., so Bricks 2.4.2 on staging prints a
  pasted class's or element's Interactions.)

## Root cause (file:line)

1. **The capture never has the opened panel.** `src/web/code.ts:42` drops every never-shown child of `<body>`
   (`if (!shown.length && (parentOf(path) === "body" || …)) continue;`, comment lines 4–6: "pop-up templates stay
   out"), and no step of `src/web/capture.ts` (`readOpened`, lines 149–226) ever opens anything, so the dialog
   Elementor builds on a click is never read; `capture.ts:393-397` `popups()` records pop-ups raw (this capture: `[]`).
2. **The converter drops the action.** `src/core/site/links.ts:19` returns `{ none: "action" }` for any
   `#elementor-action` link and `links.ts:32` names it "opens nothing yet"; `src/core/site/kinds.ts:66-69` makes an `a`
   whose link is left off a plain Div. No code in `src/` emits an Offcanvas or a click Interaction
   (`grep -rli offcanvas src` → nothing).

## The general rule

> **What a part's link or button opens on the old site opens the same way in the paste.** The capture presses every
> opener (a page builder's pop-up link, an `aria-controls` toggle) whose box lies outside the page's parts, lets the
> page's own script open it, reads the opened box's code at every range (as the page's code is read), proves how it
> closes (its own × , Escape, a click outside) and puts it back. The paste holds one Bricks **Offcanvas** per opened
> box, in the part of its first opener, holding the site's opened box as the site's code (its own classes, per-range
> rules, pictures and links), and every opener (and every proven ×) carries a Bricks Interaction **Click → Toggle
> offcanvas** naming it. The panel plays the site's own opening animation, and closes as the site does. Keyed on page
> builders' and ARIA's own markers and on what the page does when pressed, never on a site.
> It never presses anything inside a form or tied to one, and nothing a press does may write to a site or leave the
> page (the press guard, below); how a box closes is proven in the design width's page load when an opener shows there,
> else in the widest range's where one does. **[Amendments 4, 5]**

Nothing changes where nothing opens: a capture with no opener, and every older capture (no `opens` field), pastes byte
for byte as on main except the action note's wording and a closed `details` (its hidden content pastes; a new capture
reads it while it is open) **[Amendment 3]**; Figma designs are untouched (only `src/web/` and `src/core/site/`
change, plus the snapshot type and two optional fields of `BricksElement` in `src/core/emit/payload.ts`, `deletable`
and `cloneable`, written only when set: the Offcanvas's Content Block) **[Amendment 6]**.

Since fix pass 6 four files outside those folders change too, none on a Figma design's path: the launch [amended A7]
(`test/browser/chrome.ts` `launchChrome`'s `sockets` option, off unless asked for; `tools/capture.ts` and [amended A7]
`tools/capture-serve.ts`, which launch through `launchCaptureChrome`) and `tools/lib/site-upload/pictures.ts` [amended A7]
(`uploadList` never lists an address as both going up and staying). And one thing changes where nothing opens: every [amended A7]
Chrome a capture starts sends its WebSockets through the socket gate from its first page load (open, the gate passes [amended A7]
each connection on to its host as Chrome would, the launch's host rules kept; a page load with nothing to open never [amended A7]
shuts it); http and https requests go straight, as before. No paste changes by it. [amended A7]

### What the capture may press, and the press guard **[Amendment 5]**

Reviews 1–5 refined what the capture may press, and reviews 7–9 what the guard holds (WebSockets); this is the rule [amended A7]
as the head `058ec3ea` has it (`src/web/readers/openers.ts`, `src/web/press-guard.ts`, `src/web/read/opens.ts`, [amended A7]
`src/web/socket-gate.ts`). [amended A7]
- **By markup.** An opener is a link whose address starts with Elementor's pop-up action
  (`#elementor-action:action=popup:open&settings=…`, encoded or not, as Elementor's own handler takes it: another page's address ending in the
  action is never pressed), or an `a`, `button` or `[role=button]` with `aria-controls` and `aria-expanded` (a link
  among them only with no real address: none, `#…` or `javascript:`). The controls inside an opened box that may close
  it are its shown links with no real address (none, `#…`, `javascript:`, a page builder's action), its buttons and its
  `[role=button]` elements. **Nothing inside a form, or tied to one by `form=`, is ever pressed, whatever its tag**, as
  an opener or inside an opened box. The click outside a box lands on its own dim (a cover that takes clicks), else on
  a point of the page whose topmost element is no link, button, field, label, `summary`, `[role=button]`, `[onclick]`
  or `[tabindex]`.
- **By what a press does, whatever the markup.** From a page load's first press to its last, every request that isn't
  a GET, HEAD or OPTIONS, and every page load of its main frame or of a window a press opens, is failed before it
  leaves: CDP Fetch on a second session of the page's tab (beside the kept page's own) and, for what the presses make
  (a window, a frame), on the browser target. For the guard's span the page's service worker is bypassed
  (`Network.setBypassServiceWorker` on that session); the frames of other sites and the page's service worker already
  running when it starts, and the frames of other sites nested inside those frames, are attached with a Fetch of their
  own (their writes failed as the page's, their reads go on); a window a press opens (`window.open`, a `target=_blank`
  link, a window that one opens in turn) waits, auto-attached, and bypasses the worker before its first request, so
  its page load is failed and named. A frame or worker that doesn't answer being held within 5 s is named in the page load's notes (`the capture
  couldn't hold <address> beside the page while it pressed …`), never waited for.
- **Sockets** (Justin, 2026-11-10, "Block sockets"; fix pass 6). CDP Fetch never sees a WebSocket, and neither [amended A7]
  `Network.setBlockedURLs` nor a per-address network rule stops one (fixer 6's probe on Chrome 156, recorded in [amended A7]
  `socket-gate.ts`'s header). So every Chrome a capture starts is started by one launch, `launchCaptureChrome` [amended A7]
  (`src/web/capture.ts`: `captureSite`'s own Chrome, `npm run capture`'s and the importer helper's), which gives it a [amended A7]
  **socket gate** (`src/web/socket-gate.ts`): a SOCKS5 end on 127.0.0.1 in the capture's own process that Chrome sends [amended A7]
  everything but http and https through, and that passes each connection on to its host as Chrome itself would, [amended A7]
  applying the launch's own `--host-resolver-rules` (MAP, EXCLUDE, `~NOTFOUND`: the offline stand-in reaches no outside [amended A7]
  host through it). The press guard shuts the gate when a page load's guard starts (before its first press) and opens [amended A7]
  it again when the last page load of that browser still pressing has stopped (after its last press): page loads read [amended A7]
  side by side share the one gate. Shut, a new socket, whoever opens it (the page, a frame of any site, a worker [amended A7]
  already running or new, a window a press opens), is refused before its host hears of it (no handshake); a socket [amended A7]
  already open that sends anything is cut before those bytes leave (it closes as a lost connection; the page may open [amended A7]
  it again once the gate is open); what a host sends on an open socket still comes in. Each attempt is named as the [amended A7]
  other stopped writes are (`a WebSocket to <host>:<port>`, `a message on a WebSocket already open to <host>:<port> [amended A7]
  (cut before it left)`): one a pressing page made to its own site counts against the press it falls in; one to [amended A7]
  another site goes in the "sent to another site" note and is never counted against a press. An `EventSource` is an [amended A7]
  http GET: Fetch sees it and it passes as a read. WebTransport and WebRTC data channels are not held (UDP, no [amended A7]
  request). A Chrome the capture didn't start (a caller's own `browser`: the tests', the offline B-Dry dry runs) has no [amended A7]
  gate: nothing stops its sockets, and one the page opens during a press is named as not stopped (`the capture [amended A7]
  couldn't stop <n> WebSocket… the page opened while it pressed (…): its Chrome wasn't started with the capture's [amended A7]
  socket gate, so what they sent isn't known`). [amended A7]
- **How a refusal is charged** (Justin, 2026-11-10, "Fix it"; fix pass 7, review 8's R8-1). The gate sees only a host [amended A8]
  and a port, never which page asked. A refusal counts against a press only when that pressing page's own sessions [amended A8]
  reported the socket: its second session (the page and its same-site frames), each frame and worker the guard holds [amended A8]
  beside it (a dedicated worker already running reports too; a frame or worker started meanwhile waits, attached, until [amended A8]
  it is held and watched) and each window a press opened (`Network.webSocketCreated` for a new socket, [amended A8]
  `Network.webSocketFrameSent` for a message). A report and a refusal are paired by kind (a new connection, or a [amended A8]
  message) and by address (host and port), within 2 s of each other, in either order (Chrome tells the one and the [amended A8]
  gate the other, on two paths). A report whose socket's address is known claims its refusal at once; a message on a [amended A8]
  socket whose address the page's sessions never saw (opened before they were watched) claims only a refusal no [amended A8]
  known-address report claimed, when the press reads what it tried or 250 ms later, the oldest first. A socket cut at [amended A8]
  its first message claims that one refusal, however many messages the page had queued on it. A claimed refusal is [amended A8]
  recorded as any stopped write is (to the page's own site: against the press; to another site: apart). A refusal no [amended A8]
  pressing page claims blames no press and is listed apart in the page load's notes (`the capture stopped <n> [amended A8]
  WebSocket attempts while it pressed that no page it was pressing reported as its own (…): nothing was sent, and no [amended A8]
  press is blamed for them`): another window of the capture reading the site meanwhile, or the page's own socket [amended A8]
  sending between the gate shutting and its sessions being watched, before any press. A page with a frame or worker [amended A8]
  whose reports couldn't be switched on within 5 s (or were refused) is charged every refusal that no known-address [amended A8]
  report claims as it arrives while that page presses, each saying so (`… (whose, not known: the capture couldn't [amended A8]
  watch a frame or worker of this page)`), and that child is named as not held. A message on a socket the page itself [amended A8]
  opened before it pressed is the page's own, whoever sent it (Chrome's report of a message names no initiator): it [amended A8]
  counts against the press it falls in (the limit F7-1). [amended A8]
- **A press that tried something counts for nothing:** never an opener (the box's next opener shown there is pressed
  instead; such an opener is no opener at any width), never a closer, never a proven Escape or outside close, and the
  capture's notes name it (`the capture stopped what pressing <path> tried (…): nothing was sent and the page stayed, and
  the press counts for nothing in the paste`). What a press tried is what was failed from the press until its effect was
  waited for and 300 ms more in the page's own time, then one DevTools round trip.
- **A write to another site** than the page's (one site: the same host without `www.`, or one under the other) is
  failed as well, listed apart (named once per page load: `the capture stopped <n> requests the page sent to another
  site while it pressed (…): nothing was sent`) and never counted against a press. Fixer 2's ruling, upheld by review
  3's R3-2 (bdryswi.com runs Google Tag Manager, whose batched reports would otherwise make random presses count for
  nothing): **to be confirmed with Justin.**
- **Everything is undone when the guard stops:** both Fetch interceptions off, the service worker bypass off again (the
  rest of the capture reads the page as served), auto-attach off (Chrome detaches what it attached), the windows the
  presses opened closed, the socket gate open again (once no page load of the browser is pressing: a socket connects [amended A7]
  and sends as before). Requests before the first press and after the last, and the "I am human" check, are untouched; [amended A7]
  so are sockets while no page load of the browser is pressing. [amended A7]

### Where a box's close is proven **[Amendment 4]**

- Each page load lists the boxes it can open (an opener inside a part shown there, its box outside every part and
  hidden at load) before pressing anything. How a box closes (Escape, a click outside it, each control in it that may
  close it, reopening between) is proven once: in the design width's page load when one of its openers shows there, else
  in the widest range's page load where one does (the page loads in plan order, the design width's first, then widest
  first; `leftToProve`). A page load that doesn't prove a box shuts it with Escape. `closers` and `closeOn` are that
  proof's; a box no page load proved keeps `closeOn {esc: true, outside: true}` and no closers.
- A close is waited for as long as the box's played animation lasts (at least 1.5 s; its duration and delay, at most
  10 s, plus 0.75 s).
- A link with no address of its own inside an opened box (a bare `#`, as written or as the capture read it: the captured
  page's own address with an empty hash) stays `#` in the paste, proven closer or not; a part's own bare `#` pastes as
  on main (`/#`: a follow-up).

### How the Offcanvas is built (Bricks 2.2 `offcanvas.php`, 2.3.9 `bricks.min.js`, 2.4.2 CSS; Task 1 cites each)

```
offcanvas            parent 0, right after the part's root; settings { direction?, closeOn?, noScrollBody?,
                     ariaLabel?, _cssClasses: "<page>__open-<4>" }; global class site-offcanvas;
                     _cssCustom: the open/close motion (below)
├ block "Content"    _hidden._cssClasses "brx-offcanvas-inner"  (Bricks positions it; site-offcanvas makes it a
│ │                  full-window, see-through, click-through layer that doesn't slide); deletable false, cloneable false
│ └ R …              the site's opened box R (a body child) and its subtree, converted by prepare() exactly as a part
│                    is (R takes the reset class and what <body> passed down; --elementor folds its widgets too)
└ block "Backdrop"   _hidden._cssClasses "brx-offcanvas-backdrop" (see-through; it catches the outside click); only for
                     a box whose clicks outside its panel don't reach the page: none for a through box (below)
```
**[Amendment 1]** (the tree's Content and Backdrop lines)

- **Why a second root and not inside the part's root:** `site-reset-pqgx` (`classes.ts:26`) is `all: revert` on the
  part root and everything under it, which would cancel Bricks' offcanvas CSS (printed in `@layer bricks` on staging:
  `post-155.min.css`), as it cancels the accordion's (`site-accordion`). Outside the reset, Bricks' own CSS works; R
  gets the reset itself. Bricks expects an Offcanvas in a header: its 2.4.2 `frontend-light-layer.min.css` holds
  `#brx-header.brx-sticky:has(.brxe-offcanvas.brx-open){transition:none}`.
- **`site-offcanvas`** (a global class of fixed text, `OFFCANVAS_CSS` in `src/core/site/opens.ts`, added to a part's
  classes only when the part holds a box, never in `SHARED_CSS`; unlayered and written at 0,4,0, so it beats Bricks'
  layered rules and Bricks 2.3.9's unlayered direction rules (0,3,0); closed, the inner draws nothing, since Bricks
  hides a closed Offcanvas by visibility alone; Bricks' `.brx-open .brx-offcanvas-inner{transform:translate(0)!important}`
  still applies, harmlessly; the site's box gives itself its pointer events, below) **[Amendment 6]**:

```css
.brxe-offcanvas.site-offcanvas[data-direction] > .brx-offcanvas-inner { top: 0; right: 0; bottom: 0; left: 0; width: auto; height: auto; transform: none; background-color: transparent; display: block; overflow: visible; pointer-events: none; }
.brxe-offcanvas.site-offcanvas:not(.brx-open):not(.brx-closing) > .brx-offcanvas-inner { display: none; }
.brxe-offcanvas.site-offcanvas > .brx-offcanvas-backdrop { background: none; }
```

- **A cover root** (R covers the whole window when open: Elementor's dialog) keeps its own paint (the site's dim) and
  lets clicks through to Bricks' backdrop: R's class gets `pointer-events: none`, R's element children
  `pointer-events: auto` (written into their states before the blocks, so they print per range like every site value).
  Any other root (an ARIA drawer that is itself the panel) gets `pointer-events: auto` on its own class (the inner
  passes none down). **[Amendment 1]**
- **A box whose clicks outside its panel reach the page** (`CodeOpen.through`: a pop-up without an overlay, whose root
  may cover the window but takes no clicks, or a drawer that is only its panel; a capture without `through` counts a
  box as such when it isn't a cover) **has no Backdrop**: Bricks' Backdrop would take every click, and on the site a
  click beside such a box is a click on the page. Its `closeOn` is `"esc"` when Escape closes it, else `"none"`. Where
  the site also closes it on a click outside it (`closeOn.outside`: Elementor's dialog, `hide.onOutsideClick`), Bricks'
  own Interactions do, since Bricks closes on an outside click only through a Backdrop:
  - every part's root (header, page and footer alike) carries Click → Remove attribute `class` = `brx-open` with the
    selector `.<marker>.brx-open:not([data-site-opening])` (every such box's marker, comma-separated: only open boxes,
    review 2's R2-1, since taking a class off a closed box still writes it and Bricks' script then runs its close steps
    on it), then Click → Remove attribute `data-site-opening` on `.<marker>`, both with "Disable: preventDefault" on (a
    link in the part is still followed);
  - each opener of such a box carries, after its Toggle offcanvas, Click → Set attribute `data-site-opening="true"` on
    `.<marker>`, so the root leaves the box it has just opened (a Bricks `toggle` opener gets no mark).
  **[Amendment 1]**
- **Settings from the capture:** `direction` the window side the panel touches at the design width (right / left /
  top / bottom; none: unset); `closeOn` from what closed it: Escape and outside → unset (Bricks' default
  backdrop-esc), Escape only → `"esc"`, outside only → `"backdrop"`, neither → `"none"` (a box with a Backdrop; a box
  whose clicks outside reach the page: `"esc"` or `"none"`, above **[Amendment 1]**); `noScrollBody: true` when the
  page stopped scrolling while it was open; `ariaLabel` R's or the panel's own `aria-label`, else the first opener's,
  else unset (Bricks prints "Offcanvas").
- **The motion (Q4 A):** the element in R whose declared `animation-name` plays when opened (the capture names it,
  `entrance`) keeps no animation in its own rules; the animation is the one the capture saw play (`CodeOpen.motion`:
  its name, duration, timing and delay; its keyframes in `web.code.keyframes`, as the browser held them when the box's
  rules no longer name them: Elementor's script takes the class off once it has played), else the one the entrance's
  own rules name; the Offcanvas's `_cssCustom` carries (after class naming, as `withLooks` does) **[Amendments 2, 6]**:

```css
#brxe-<id> > .brx-offcanvas-inner { transition-duration: <dur>; }
#brxe-<id>.brx-open <entrance selector> { animation: <name> <dur> <timing> <delay> both; }
#brxe-<id>.brx-closing <entrance selector> { animation: <name>-out <dur> <timing> 0s reverse both; }
@keyframes <name> { the site's frames }
@keyframes <name>-out { the same frames }
@media (prefers-reduced-motion: reduce) { #brxe-<id> > .brx-offcanvas-inner { transition-duration: 0s; } #brxe-<id>.brx-open <entrance selector>, #brxe-<id>.brx-closing <entrance selector> { animation: none; } }
```

  (`<name>` the renamed keyframes; the closing runs under a second name because CSS restarts an animation only when its
  name changes. **[Amendment 6]**)

  Bricks reads the inner's `transition-duration` to time the close (`bricks.min.js` 2.3.9 `bricksOffcanvas`: `r=1e3*
  parseFloat(getComputedStyle(n).transitionDuration)`), so the closing animation finishes before `brx-closing` goes.
  `<entrance selector>` is the entrance element's class with its `where.self` (convert.ts `whereOf`); keyframes as
  site-motion pastes them (`motionOf` names, `css.keyframes`). Without an entrance: no rules but the
  `transition-duration: 0s` pair (opens at once, as a site with no animation).
- **Openers:** each opener's element (by its site path, whatever element it became) gets
  `_interactions: [{ id: shortId("interaction:open:" + target + ":" + path), trigger: "click", action: "toggleOffCanvas",
  offCanvasSelector: ".<marker>" }]` on its own settings (its class is unchanged, so no class name moves); an opener that
  is a link stays a link (`tag: "a"`, link `#`: Bricks' Interaction prevents it, and a keyboard's Enter presses it as on
  the site), and an opener of a box that closes on an outside click reaching the page also carries the Set attribute
  Interaction above **[Amendments 1, 6]**. Bricks'
  PHP then adds `target: "offcanvas"`, `data-brx-toggle-offcanvas="true"`, `tabindex="0"`, `aria-expanded="false"`,
  `aria-label="Open"` (`interactions-2.2.php:546-652`). If another job makes the opener a Bricks `toggle` element,
  Bricks refuses this Interaction on it (`interactions-2.2.php:548`): write `toggleSelector: ".<marker>"` instead.
  Each proven closer in R gets the same Interaction (inside an open Offcanvas it closes it). Nothing else gets
  `_interactions` but site-motion's and, where a box closes on an outside click reaching the page, every part's root
  (its two Remove attribute ones, above). **[Amendment 1]**
- **The link note:** an action link that opens a box the capture read is an opener (above), no longer "left off"; only a
  capture without `opens` (older) keeps the note, reworded: "a menu or pop-up button opens nothing: capture again with
  this build so the capture reads what it opens". A capture with `opens` whose box for such a link wasn't read (it
  didn't show within 3 s, or the link sits inside a sentence) says instead "a menu or pop-up button opens nothing: the
  capture couldn't open what it opens (it didn't show when pressed, or the link sits inside a sentence)". **[Amendment 6]**
- **A closed `details`** anywhere in a part or an opened box pastes its never-shown content (the browser shows it once
  opened): `buildTree` (and `prepare`'s scan) treat every `details` node's subtree as pasted (Q5 A). The capture reads
  that content while the details is open (review 1's R1-1: a page builder hides a closed item's content once more by a
  rule that holds only while it is closed, `.e-n-accordion-item:not([open]) .e-con { display: none }`, which read closed
  would paste as the content's own `display: none`): one details at a time, it and every closed details above it opened
  by the `open` attribute alone (no click: the page's handlers don't run), then every details of the page put back as it
  was (the closed ones first, so a `name` group's open one stays); the open reading's elements, facts and declarations
  replace its content's (everything under it but its summary), while whether each shows and the looks a state gives stay
  as the page loaded (`src/web/readers/details.ts`, `read/code.ts` `contentOpen`). So the paste holds the look it has
  once opened, and the browser's own closed state hides it. **[Amendment 3]**

### The pictures of an opened box [amended A9]

Justin, 2026-11-10, "Upload them too" (review 7's R7-1, stack 13's S13-1): an Elementor pop-up's root is made by [amended A9]
Elementor's script, so until fix pass 6 every picture inside a pop-up counted as "another company's script drew it": [amended A9]
`site:upload` left the site's own menu pictures on the old site, and B-Dry's logo was listed both as going up and as [amended A9]
staying. [amended A9]
- **The capture records who made each script-made element of an opened box:** `CodeOpen.makers` [amended A9]
  (`src/core/snapshot/web.ts`; optional, no version change): for each script-made element under the box's root (a path [amended A9]
  step holding `~`; the root too), the script files on the stack that made it, innermost first, as the tracker read [amended A9]
  them (the page's own inline code reads as the page's address; `about:inline-code`: code that belongs to no served [amended A9]
  file; `about:stack-cut`: a stack read only in part). Served elements have no entry. A capture made before this has [amended A9]
  no `makers`. [amended A9]
- **The rule** (`src/core/site/media.ts` `madeInOpen`; `convert.ts` asks it only inside an opened box, a part's own [amended A9]
  elements keep `madePath`: any `~` step): a picture inside an opened box counts as another company's only when some [amended A9]
  script-made step on its path, from the box's root down to the element that shows it, (a) had a file of another site [amended A9]
  on its stack (one site: the capture's host without `www.` and its port, or a host under the other; so a widget that [amended A9]
  draws through the site's own jQuery is still another's), (b) was made by code with no file, (c) has a stack read [amended A9]
  only in part, or (d) has no record (an empty one too). Served steps need no maker. So a pop-up's own Images and CSS [amended A9]
  pictures (`background-image`, `background`, `mask-image`, `-webkit-mask-image`) are the site's own: `site:upload` [amended A9]
  lists them with their part's (the part's own uses first, so its alt wins; each file once), and with the media map [amended A9]
  the Offcanvas shows the library's. An older capture (no `makers`) keeps every picture under a script-made step of a [amended A9]
  box as another's, as before: capture again. [amended A9]
- **Where a picture's file lives is no part of the rule:** a picture on another host that the site's own markup shows [amended A9]
  (a partner badge in the pop-up's served template) goes up when the capture holds its file, inside a box as outside [amended A9]
  (site-media-upload's Q3 A as merged). [amended A9]
- **The capture's own press is no one's code:** the capture presses in the page under the script name [amended A9]
  `f2b-capture-press.js` (`src/web/read/opens.ts` `PRESS_SOURCE`, through `Session.run`'s `source`), and the tracker [amended A9]
  (`src/web/read/tracker.ts` `PRESS`) counts a frame of that name neither as a file nor as code with no file, so what a [amended A9]
  click handler makes at once was made by the page's own files alone (before, every element of the B-Dry stand-in's [amended A9]
  pop-ups read `popup.js` plus `about:inline-code` and stayed another's). [amended A9]
- **No address is on both lists** (`tools/lib/site-upload/pictures.ts` `uploadList`): an address that goes up shows [amended A9]
  the library's picture wherever the paste names it (the media map is by address), so it is never also listed as [amended A9]
  staying (a widget's copy of a file the site shows too). [amended A9]

## Acceptance criteria (proposed)

- AC1 (proposed): Given the generic fixture `site-menu` (a header ☰ in each bar opening an Elementor-style pop-up, a page link opening a centred Elementor-style dialog, a footer `aria-controls` button opening a left drawer), when captured, then `web.code.opens` lists three boxes, each with its openers, its root, its closers, `closeOn`, `cover`, `side`, `noScroll`, its entrance path and the animation that played there (`motion`) **[Amendment 2]** and the ranges it was read at, and its nodes hold the opened subtree's code per range (the panel's message 25vw / 40vw / 85vw by range); every other field of `web.code` equals a capture made with openers ignored, but `keyframes`, which also holds the boxes' own **[Amendment 6]**. Test: `test/web/capture-opens.test.ts` "the capture reads what each opener opens"
  - Supporting (Amendments 2–5; never a report's cited test): `test/web/capture-opens.test.ts` "a closed details' content is read with the look it has open"; `test/web/site-opens-more.test.ts` "a box whose only opener shows on phones is proven in the page load that opens it" and "the capture's click outside a box lands on nothing a click follows"; `test/unit/web-opens-read.test.ts` "how a box closes is the design width's proof, else the widest range's that proved it", "the entrance a box played reaches web.code.opens as it played" and "only a shown opener inside a part whose hidden box lies outside the parts is pressed"; every test of `test/web/capture-opens-guards.test.ts` and `test/unit/web-press-guard.test.ts` (the press guard). Since fix passes 6 and 7 (never a report's cited test): `test/unit/socket-gate.test.ts` (both tests); `test/web/press-guard-sockets.test.ts` "a refused socket counts against the pressing page that made it; another tab's attempts blame no press and are listed apart"; the three new cases of `test/web/capture-opens-guards.test.ts`: "a press opens no WebSocket and sends nothing on one", "the capture's own Chrome opens no WebSocket and sends nothing on one while it presses" and "a socket another page of the site keeps busy while the capture presses blames no press: every box keeps its openers"; the fourteen socket cases of `test/unit/web-press-guard.test.ts` (from "while a page presses, its browser's socket gate is shut; a refused socket is named, its own site's against the press" to "a socket cut at its first message claims one refusal, however many messages the page queued on it"); `test/web/capture-opens.test.ts` "an opened box records the script that made each of its script-made elements"; and the one existing case this job changes, `test/unit/capture-chrome.test.ts` "npm run capture launches the Chrome findChrome finds and prints the helper's line when it finds none (amendment 2)" (web-code-page's launch pin: it follows the launch, `launchCaptureChrome(…)` in `tools/capture.ts` on this head and in `tools/lib/capture-run.ts` once joined with site-one-command: "Overlaps"). [amended A7, A8, A9]
- AC2 (proposed): Given hand-made code with one cover pop-up (two openers, a closer, an entrance) and one drawer, when converted with `siteParts` (with and without the Elementor step), then each part holding an opener pastes one Offcanvas root right after its own root, shaped as `reference/bricks/offcanvas.json` (the cover pop-up's Content and Backdrop Blocks with Bricks' hidden classes; the drawer, whose clicks outside its panel reach the page, has no Backdrop, as the shape criterion checks **[Amendment 1]**; the marker class, direction, closeOn, noScrollBody), the site box under Content with the reset on its root and every link rewritten as the part's are, every opener and closer carrying the Toggle offcanvas Interaction naming the marker (a link opener staying a link, `href="#"` **[Amendment 6]**), no "opens nothing" note, and `payloadProblems` clean. Test: `test/unit/site-opens.test.ts` "a box an opener opens pastes as an Offcanvas its openers toggle"
  - Supporting (Amendments 1, 2, 4; never a report's cited test): `test/unit/site-opens-through.test.ts` "a box with no cover that takes clicks has no Backdrop, and closes on a click outside it where the site's does", "a part's root carries no Interaction where no box closes on a click outside it without a cover" and "a link with no address of its own inside an opened box stays a bare #"; `test/unit/site-links-bare.test.ts`; `test/unit/site-opens.test.ts` "the panel plays the entrance the capture saw play, whatever its own rules still name"; `test/web/site-opens-more.test.ts` "a pop-up without an overlay leaves the page its clicks, and a click outside closes it as on the site", "a click on a page whose boxes are closed writes nothing on them: the page stays, a field keeps the focus" and "the phone menu's × closes it, and no link without an address becomes the page's". Since stack 13 and fix pass 6 (never a report's cited test): `test/unit/site-made-in-open.test.ts` "an opened box's element is the site's own only when every script-made step on its way was made by the site's files"; the four tests of `test/unit/site-opens-own-pictures.test.ts`: "an opened box's own pictures go up once with the page's; another company's in a box stay; none is on both lists", "a part lists its own pictures before its boxes', each once (the alt rule reads them in this order)", "a capture made before the capture recorded who made a box's elements: its script-made pictures stay, as before" and "with a map, the pop-up's own pictures are the library's in the Offcanvas; another company's keep their address"; `test/unit/site-upload-opens.test.ts` (a dry run and a run against the 127.0.0.1 stand-in, each with and without the Elementor step); stack 13's joins: the three tests of `test/unit/site-opens-media.test.ts` and `test/unit/site-opens-no-revert.test.ts` "an opened box's dropped declarations print as bounded runs, with no revert". [amended A9, A10]
- AC3 (proposed): Given the `site-menu` fixture captured and pasted (rich), rendered with Bricks 2.3.9's own offcanvas CSS and script and its Interactions, at every width the capture read and at 300, a click on the ☰ shown there opens the menu, and once both finish opening every element of the opened panel is within 2 px of the fixture site's opened pop-up and its links match the site's; Escape, a click outside and the × close it as on the site (the dialog ignores the outside click, as its site does); Tab reaches the ☰ and Enter opens it; the drawer and the dialog likewise. Test: `test/web/site-opens-proof.test.ts` "every opener opens its box as on the site, within 2 px"
- AC4 (proposed): Given the same paste, when the menu opens, then the panel plays the site's opening animation (its renamed keyframes, 0.75 s, the site's easing) and, when it closes, the same animation backwards before Bricks hides it; under reduced motion it opens and closes at once. Test: `test/web/site-opens-proof.test.ts` "the panel opens and closes with the site's own animation"
- AC5 (proposed): Given a closed `details` in an opened box or a part, when captured and pasted, then its content is read while that details is open (one details at a time, by its `open` attribute, every details put back as it was) and that open reading's elements replace its content's, so its hidden content is pasted with the look it has open **[Amendment 3]** and, clicked in the paste, it opens and shows its links as on the site. Test: `test/unit/site-opens.test.ts` "a closed details pastes its hidden content" (+ the fixture's "Services" in AC3's test)
  - Supporting (Amendment 3; never a report's cited test): `test/web/site-opens-proof.test.ts` "the Services list opens as on the site" (the fixture's lists hidden while closed by a `:not([open])` rule, as Elementor's nested accordion) and "a closed details in a part opens as on the site"; `test/web/capture-opens.test.ts` "a closed details' content is read with the look it has open"; `test/web/details-open.test.ts` "the closed details of the page are listed in document order, a closed root with them" and "one details opens with every closed details above it, and every details is put back as it was"; `test/unit/web-details-open.test.ts` "a closed details' content takes the open reading; the details, its summary and what shows stay as first read" and "content that showed while its details was closed keeps showing".
- AC6 (proposed): Given a capture without `opens` (every capture made before this build: the fixtures' saved captures and Justin's 11-09 bdryswi.com capture), when converted, then every paste is byte for byte main's but the action note's new wording (and a closed `details`' hidden content, which pastes since this build **[Amendment 3]**); and the page parts of a capture with `opens` measure as before (`site:check` passes on the fixture, the closed Offcanvas taking no room). Test: `test/unit/site-opens-old.test.ts` "a capture without opens pastes as before" (named-only B-Dry: `F2B_SITE_MENU_BDRY=<capture>`; site:check: `test/web/site-check-opens.test.ts` "site:check passes with opened boxes")
- AC7 (proposed): The Offcanvas candidate sample `reference/bricks/offcanvas.json` and Bricks' offcanvas CSS `reference/bricks/frontend-2.3.9/el-offcanvas.min.css` (byte copy of Justin's darksalmon 2.3.9 file, sha256 `fa02fbfd…b9be`) are in the repo with their sources in `reference/bricks/README.md`, and every emitted Offcanvas matches the sample's shape: its Content and Backdrop Blocks, or its Content Block alone for a box whose clicks outside its panel reach the page (Bricks' Backdrop is the Block it lets be deleted, "delete to disable") **[Amendment 1]**. Test: `test/unit/bricks-shapes.test.ts` "an emitted Offcanvas has the sample's shape"
- AC8 (proposed) (live): Justin captures bdryswi.com with this build (after staging-fit-capture is merged), runs `npm run site`, pastes the page on B-Dry staging `/homev2/`, and at 1440, 1024, 768 and 390 the ☰ opens the menu from the right over the dim with the logo, "Services" (opens to its 7 links), About Us, Service Areas, Warranty, Contact Us, the phone and "Get Your Estimate", the links go to staging's own pages, and the ×, Escape and a tap outside close it; the hotspots open their pop-ups. Paste check `<site-menu id at merge>`. Test: `test/web/site-opens-bdry.test.ts` "Justin's bdryswi.com capture pastes the menu pop-up and its two openers" (named-only: `F2B_SITE_MENU_CAPTURE=<his new capture>`, checks the conversion before his paste)

The plain route and Figma designs: byte-identical (AC6; `test/unit/site-figma-unchanged.test.ts` and `npm run corpus`
stay green). The capture's existing fields: unchanged (AC1's last clause), but a closed `details`' content, read while
it is open (AC5), and `web.code.keyframes`, which also holds the boxes' own **[Amendments 3, 6]**.

## Current context

- Base tally: `node --test "test/unit/**/*.test.ts"` on `fd1986dc`: 3453 tests, 3384 pass, 0 fail, 69 skipped, 34 s
  (`base-unit.log`). The builder records `npm run test:web`, `npm run test:browser` and `npm run corpus` on the base
  before Task 2 (the ledger).
- Machine: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR=~/.cache/smm-b/tmp` (≤38 characters,
  its own); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome; one `bash <file>` per
  Bash call; heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. The worktree's
  `node_modules` has no `.bin`: link `node_modules/.bin/tsc -> ../typescript/bin/tsc` and
  `node_modules/.bin/esbuild -> ../esbuild/bin/esbuild` (untracked) or run them by path (testing-pitfalls).
- **Never load bdryswi.com.** The B-Dry proofs are the named-only conversion of Justin's next capture (AC8) and his
  live paste; the saved 2026-10-29 stand-in has no scripts, so its pop-ups never open.
- Bricks facts read for this plan (all cited in Task 1's README section):
  - Offcanvas (2.2 `offcanvas.php`): settings `direction` (top/right/bottom/left, default left → `data-direction`),
    `effect`, `closeOn` (`backdrop`/`esc`/`none`, unset = both → `data-close-on`), `noScrollBody` (`data-no-scroll`),
    `noAutoFocus`, `scrollToTop`, `openByDefault`, `ariaLabel` (default "Offcanvas"), `width`/`height`,
    `transitionDuration`; nestable children: Block "Content" `_hidden._cssClasses: "brx-offcanvas-inner"` (`deletable:
    false`, `cloneable: false`; Bricks' default holds a Basic Text and a close Toggle, the plugin writes the site's
    box instead) and Block "Backdrop" `_hidden._cssClasses: "brx-offcanvas-backdrop"` ("delete to disable"). Prints
    `<div class="brxe-offcanvas …" aria-label data-direction [data-close-on] [data-no-scroll]>` + children.
  - CSS: 2.3.9 (darksalmon) byte-identical to 2.2's; 2.4.2 (B-Dry staging) adds only
    `--brx-offcanvas-direction:initial`; staging prints element CSS inside `@layer bricks` (`post-155.min.css`).
  - Interactions (2.2 `interactions.php`): action `toggleOffCanvas` with `offCanvasSelector`; not allowed on a `toggle`
    element; the element then gets `data-brx-toggle-offcanvas`, `tabindex="0"`, `aria-expanded`, `aria-label`. 2.3.9
    and 2.4.2 `bricks.min.js`: `case"toggleOffCanvas"` → `bricksUtils.toggleAction(e,{selector})`; `bricksOffcanvas()`
    closes on the backdrop click and Escape per `data-close-on`, focuses the first focusable, restores focus to the
    opener (`[data-interaction-id][data-brx-toggle-offcanvas]`).
- Capture code paths: `codeFacts` (`src/web/read/code-facts.ts:132-171`) visits every body child; `readCode`
  (`src/web/read/code.ts:77`) reads them all; `assembleCode` (`src/web/code.ts:30`) encodes per range.

## Architecture (files)

Capture (`src/web/`):
- `src/web/readers/openers.ts` (new, in-page): `openersOf(helpers)` lists `{ opener, target, how }`: every
  `a[href*="elementor-action" i]` whose decoded hash is `action=popup:open&settings=<base64 JSON with id>` → target
  `[data-elementor-type="popup"][data-elementor-id="<id>"]`; every `a, button, [role=button]` with `aria-controls` and
  `aria-expanded` whose controlled element exists; `opener` and `target` as `pathOf` paths. `openIt(arg)`,
  `shutIt(arg)`, `openedRoot(arg)`, `facts(arg)` (below).
- `src/web/read/opens.ts` (new, Node side): `readOpens(s, range, parts, { probe })` per range, after every other
  reading of that page load: for each target outside every part root whose opener (inside a part) shows at this width:
  `el.click()` on that opener; wait until the target shows (≤ 3 s; else a note and skip); finish R's finite animations
  (`R.getAnimations({ subtree: true })`, `.finish()`, as the capture reads animations at their end); R = the target's
  ancestor that is a child of `<body>` (or the target itself); `readCode(s, range, { root: R path })`; with `probe`
  (the design width's range only): `cover` (R's rect equals the window within 1 px), `side`, `noScroll`
  (`document.scrollingElement` can't scroll while open but could before, or `overflow: hidden` on html/body
  appeared), then the close proofs in order, reopening between them: Escape (`Input.dispatchKeyEvent` keyDown/keyUp
  "Escape"), a click outside (cover: at R's corner pixel (2, 2) via `Input.dispatchMouseEvent`; else at the window's
  far side from the panel), each candidate closer (`a, button, [role=button]` under R with no address: `href`
  missing, `#…`, `javascript:` or an action); closed = the target no longer shows within 1.5 s. Last: shut it (the
  first closer, else Escape, else leave it: it is the page load's last step).
  **[Amendments 4, 5]** At the head: `probe` is the boxes a page load proves (the design width's when an opener shows
  there, else the widest range's where one does: "Where a box's close is proven"); a close is waited for as long as the
  played animation lasts; the click outside and the closers are as "What the capture may press" says, and every press
  of a page load runs under the press guard (`src/web/press-guard.ts`), its stopped presses named.
- `src/web/read/code-facts.ts` and `src/web/read/code.ts`: an optional `root` (a path): visit only that element
  (`findPath`) instead of every body child; the body context is read as before.
- `src/web/code.ts`: `assembleOpens(rangeIds, readings)` → `CodeOpen[]` (each open's nodes encoded as `assembleCode`
  does; a range with no reading takes the nearest read range's, wider first, as `encode`'s undefined does), their
  `@keyframes` merged into `web.code.keyframes` by the same rule.
- `src/web/capture.ts`: `readOpened` calls `readOpens` last for the ranges other than the design width's (each proving
  the boxes no page load before it could open **[Amendment 4]**); the design
  width's runs (with `probe`) after the renders, just before `captureSite` returns, and the result is set as
  `snapshot.web.code.opens` (`[]` when nothing opens). Pictures the opened boxes show (their `img` `src`, `url()` in
  `background-image`) join the download list. Timings `opens <range>`.
- `src/core/snapshot/web.ts`: `WebCode.opens?: CodeOpen[]` (absent: an older capture; no `version` bump, so no clash
  with other jobs' capture changes). **[Amendment 2]** The type as the head has it (`git show
  4dd1a275:src/core/snapshot/web.ts`); the approved text's block follows it, superseded:

```ts
// site-menu: a box a part's link or button opens, read open at each range where an opener shows. Its nodes are keyed by
// their paths while it is open (root's subtree), encoded as web.code.nodes are (widest range full, then changes)
export interface CodeOpen {
  target: string;                       // the box the openers name: an ARIA-controlled element's path as served; an Elementor pop-up's own
                                        // id, "elementor-popup:<id>" (its template leaves the page once Elementor's script runs)
  root: string;                         // the opened box's top element, a child of <body> (its path while open)
  how: "elementor-popup" | "controls";
  openers: string[];                    // paths of the openers inside the parts, document order
  closers: string[];                    // paths under root the capture proved close it (in the design width's page load when an
                                        // opener shows there, else the widest range's where one does)
  closeOn: { esc: boolean; outside: boolean };
  cover: boolean;                       // root covers the whole window while open (its own paint is the dim)
  through?: boolean;                    // a click outside its panel reaches the page under it (no cover that takes clicks: a pop-up
                                        // without an overlay, a drawer); absent (a capture before review 1's fix): as !cover
  side: "left" | "right" | "top" | "bottom" | null;
  noScroll: boolean;                    // the page stops scrolling while it's open
  entrance: string | null;              // the element under root whose declared animation plays as it opens
  motion?: { name: string; duration: string; timing: string; delay: string };   // that animation as it played (its
                                        // @keyframes are web.code.keyframes[name]): the page's script may take its class off once it ends
  read: string[];                       // ranges it was read at
  nodes: Record<string, CodeNode>;      // root's subtree
}
```

  At head `058ec3ea` the type holds one more optional field (`git show 058ec3ea:src/core/snapshot/web.ts`): [amended A9]
  `makers?: Record<string, string[]>`, each script-made element under `root` (a `~` step, `root` too) → the script [amended A9]
  files on the stack that made it, innermost first; absent in an older capture ("The pictures of an opened box"). [amended A9]

  The approved copy's block (superseded):

```ts
// web-code (site-menu): a box a part's link or button opens, read open at each range where an opener shows
export interface CodeOpen {
  target: string;                       // the box the openers name, as served (Elementor: the pop-up template; ARIA: the controlled element)
  root: string;                         // the opened box's top element, a child of <body> (its path while open)
  how: "elementor-popup" | "controls";
  openers: string[];                    // paths of the openers inside the parts, document order
  closers: string[];                    // paths under root the capture proved close it (design width)
  closeOn: { esc: boolean; outside: boolean };
  cover: boolean;                       // root covers the whole window while open (its own paint is the dim)
  side: "left" | "right" | "top" | "bottom" | null;
  noScroll: boolean;                    // the page stops scrolling while it's open
  entrance: string | null;              // the element under root whose declared animation plays as it opens
  read: string[];                       // ranges it was read at
  nodes: Record<string, CodeNode>;      // root's subtree, encoded as web.code.nodes (widest full, then changes)
}
```

Converter (`src/core/site/`):
- `src/core/site/opens.ts` (new, pure, ≤300 lines): `opensOf(capture)` (the opens whose first opener lies in a part);
  `openView(capture, open)` (a capture whose `web.code.nodes` = `open.nodes`, everything else shared); `offcanvasTree(
  open, prepared, ids)` (the three Bricks elements as `TreeNode`s with `site: false`, R re-parented under Content);
  `openerInteraction(marker, open, path)`; `openMotionCss(id, open, …)`; `OPEN_NOTE`.
- `src/core/site/classes.ts`: `SHARED_CSS["site-offcanvas"]` (the text above). **[Amendment 6]** At the head:
  `src/core/site/opens.ts` `OFFCANVAS_CSS`, added as the class `site-offcanvas` to a part holding a box;
  `classes.ts` is unchanged.
- `src/core/site/convert.ts`: `prepare` gains `opened?: { cover: boolean; entrance: string | null }` (R's and its
  children's pointer events; the entrance's animation kept out of its rules and out of `entranceOf`); `payloadOf` puts
  the reset on the prepared root's own element (`t.path === p.root`) instead of every `parent === 0` element.
- `src/core/site/parts.ts`: after preparing the parts, prepares each open's R (`prepare(openView(…), open.root, o,
  pr)`), names its classes in the same pass (base `<page>__open-<k>` for R, `<page>__open-<k>__<role>` below; scope
  `site-open-<k>`), appends its Offcanvas content after the part's own content and its classes after the part's,
  writes the openers' and closers' Interactions on their elements, and the motion `_cssCustom` once the names are
  known.
- `src/core/site/links.ts`: `siteLink(href, finalUrl, opened?)`: an action link whose box was read returns
  `{ none: "opens" }` with no note; the `action` note's new words. **[Amendments 4, 6]** At the head: `prepare`'s
  link (`convert.ts`, its `extra.openers`) writes an opener's link as `#`; `links.ts` gains `bareHash` (a bare `#` in an
  opened box stays `#`), `UNOPENED_NOTE` and the `action` note's new words; `siteLink` is unchanged.
- **[Amendments 3, 5]** New at the head: `src/web/readers/details.ts` (a closed details opened and put back),
  `read/code.ts` `contentOpen`, `src/web/press-guard.ts` (the press guard), `src/web/read/open-pictures.ts`,
  `src/core/site/open-paste.ts` (the boxes prepared, pasted and wired); `assembleOpens` lives in `read/opens.ts`, and
  `prepare`'s sixth argument `extra` (`openers`, `open`, `ids`) stands for `opened`.
- New at the head since fix passes 6 and 7: `src/web/socket-gate.ts` (`socketGate(args)` → `{ args, shut, refused, [amended A7, A9]
  close }`; `hostRules`, `mapped`); `src/web/capture.ts` `launchCaptureChrome` (`launchChrome` with `sockets: true`, [amended A7, A9]
  `test/browser/chrome.ts`: the gate's switches added to the launch's, the gate kept as `Page.gate` and closed with the [amended A7, A9]
  browser), called by `captureSite` when no `browser` is given, by `tools/capture.ts` and by `tools/capture-serve.ts`; [amended A7, A9]
  `src/web/press-guard.ts` (the gate shut and opened in `sync`; `listen`, `report`, `claim`, `settle`; `PressWatch` [amended A7, A9]
  gains `loose()` and `unclaimed()`); `src/web/read/opens.ts` (`PRESS_SOURCE`, the two socket notes, `makers` through [amended A7, A9]
  `assembleOpens`); `src/web/readers/openers.ts` (`OpenedFacts.makers`); `src/web/cdp.ts` and `src/web/session.ts` [amended A7, A9]
  (`run`'s `source`); `src/web/read/tracker.ts` (`PRESS`); `src/core/site/media.ts` (`madeInOpen`), `convert.ts` [amended A7, A9]
  (`PrepareExtra.open.makers`, `another`), `open-paste.ts` (hands a box's `makers` on); [amended A7, A9]
  `tools/lib/site-upload/pictures.ts` (`uploadList`'s kept filter). [amended A7, A9]
- `src/core/site/tree.ts`: `buildTree` treats a `details` node as `pasteHidden`.

Tests and tools:
- `test/fixtures/web/sites/site-menu/` (new): `index.html`, `style.css`, `popup.js` (the Elementor-style pop-up
  behaviour as Elementor Pro's front end does it: build the dialog, move the template in, add `animated <entrance>`,
  close by its × (`a.dialog-close-button[role=button][aria-label=Close]`, no href), Escape, a click on the dim unless
  `prevent_close_on_background_click`, the exit animation reversed, `overflow: hidden` on body while open when
  `prevent_scroll`), `drawer.js` (an `aria-controls` button toggling `is-open` on `aside#drawer`, a body child; its
  × inside; Escape closes; no outside close).
- `test/browser/render.ts`: prints `offcanvas` as Bricks 2.2/2.3.9 does (root attributes above; children as Blocks);
  prints a `toggleOffCanvas` Interaction as Bricks' PHP does (`target: "offcanvas"` added, `data-interactions`,
  `data-interaction-id`, `data-brx-toggle-offcanvas="true"`, `tabindex="0"`, `aria-expanded="false"`,
  `aria-label="Open"` unless set); with `bricksCss` and an offcanvas in the payload: `el-offcanvas.min.css` and Bricks'
  own `bricksOffcanvas()` and `bricksInteractions()` (ready flag `__f2bOffcanvasReady`).
- `test/web/lib/site-page-check.ts`: elements under a `.brxe-offcanvas` are not measured as page boxes (hidden at
  load); `test/web/lib/opens-check.ts` (new): `openedRows(browser, capture, partPaste, open, width)` opens both pages
  and compares every paste element under the Offcanvas to its site element (sources) by box, words and link.
- `tools/site.ts` prints each part's Offcanvas count with its notes ("opens: 1 box (2 openers)").

## Tasks (test-first; commit after each passing task, explicit files; never `CLAUDE.md`)

**Task 0 — plan copy and ledger.** Copy this approved plan to `docs/plans/2026-11-09-site-menu.md`; start
`.superpowers/sdd/2026-11-09-site-menu/progress.md`; run and record the base `npm run test:web`,
`npm run test:browser`, `npm run corpus` tallies. Commit "site-menu task 0: the approved plan copied into docs/plans".

**Task 1 — the Offcanvas candidate (AC7).**
1. Fetch read-only (one plain call each; never write to a site): `https://darksalmon-badger-335429.hostingersite.com/
   wp-content/themes/bricks/assets/css/elements/offcanvas.min.css?f2b=<random>` → `reference/bricks/frontend-2.3.9/
   el-offcanvas.min.css`; check its sha256 is `fa02fbfd3350a849c7d42dc07aea6648e7f8452cb0cb73f5103978c7130bb9be` and add
   it to `SHA256SUMS`. (The planner's copies are in the evidence folder.)
2. Write `reference/bricks/offcanvas.json` (Bricks' clipboard shape, as `nav-nested.json`): an Offcanvas with
   `settings: { direction: "right", _cssClasses: "my-menu" }`, its Content Block (`label "Content"`, `deletable:
   false`, `cloneable: false`, `_hidden._cssClasses "brx-offcanvas-inner"`) holding one Basic Text, and its Backdrop
   Block (`label "Backdrop"`, `_hidden._cssClasses "brx-offcanvas-backdrop"`), then a Div whose `_interactions` is
   `[{ "id": "abcdef", "trigger": "click", "action": "toggleOffCanvas", "offCanvasSelector": ".my-menu" }]`; ids 6
   lowercase letters, `parent`/`children` consistent, `"source": "bricksCopiedElements"`, `"version": "2.3.9"`.
3. `reference/bricks/README.md`: section "`offcanvas.json` (built from Bricks' code, NOT copied from Justin's Bricks;
   2026-11-09)" citing `offcanvas-2.2.php` lines 20–64 and 155–236, `interactions-2.2.php` lines 196–200, 307–318,
   546–552, 621–652, the 2.4.3 schema keys, the CSS copies and the JS functions (`bricksOffcanvas`,
   `bricksOffcanvasClose`, `toggleAction`, `case"toggleOffCanvas"`); "Still wanted": his own copy (Q3's steps).
   CLAUDE.md is the finisher's (pending file).
4. RED: `test/unit/bricks-shapes.test.ts` "an emitted Offcanvas has the sample's shape" — fails until Task 5 emits one
   (import `siteParts` on the AC2 hand-made code; assert the emitted Offcanvas's child names, `_hidden` classes,
   `label`s, `deletable`/`cloneable` on Content, and every settings key appears in the sample or in
   `evidence/…/schema-2.4.3/offcanvas.json`'s keys copied into the test as a list). Commit the sample, CSS and README;
   the test joins Task 5's commit.

**Task 2 — the capture reads what an opener opens (AC1).**
1. Fixture `test/fixtures/web/sites/site-menu/` (generic; nothing from B-Dry but the shape of Elementor's markup):
   - header: bar A (shown ≥768) with a logo `img`, a phone `a[href^=tel]` and ☰ A (`a.elementor-icon` holding an inline
     svg of three bars, href `#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3D<base64 of {"id":"77","toggle":
     false}>`); bar B (shown ≤767) with ☰ B (a `span`-drawn ☰, same href);
   - page: a section with words and a "Details" link opening pop-up 78 (`{"id":"78","toggle":false}`);
   - footer: words and `button#drawer-open[aria-controls=drawer][aria-expanded=false]` "Contact";
   - body children: pop-up 77 (`div.elementor.elementor-77.elementor-location-popup[data-elementor-type=popup]
     [data-elementor-id=77][data-elementor-settings='{"entrance_animation":"fadeInRight","exit_animation":
     "fadeInRight","prevent_scroll":"yes"}']` holding a logo link, `details` "Services" with three links, three
     heading links, a `tel:` icon link and a button link), pop-up 78 (a centred dialog with words and one link,
     `prevent_close_on_background_click: "yes"`, entrance `fadeIn`), `aside#drawer` (a 320px panel against the left,
     hidden until `.is-open`, a CSS transition, its own × `button[aria-label=Close]`).
   - `style.css`: Elementor's dialog rules as css1.css writes them (`.dialog-type-lightbox{position:fixed;height:100%;
     width:100%;bottom:0;left:0;z-index:9999}`, `.elementor-popup-modal{display:flex;pointer-events:none;…}`,
     `.elementor-popup-modal .dialog-widget-content{background-color:#fff;max-height:100%;overflow:visible;…}`,
     `.elementor-popup-modal .dialog-close-button{position:absolute;…}`), the pop-ups' own
     `#elementor-popup-modal-77{background-color:#00000042;justify-content:flex-end;align-items:center;
     pointer-events:all}`, `#elementor-popup-modal-77 .dialog-message{width:25vw;height:auto}` (40vw ≤1024, 85vw ≤767),
     `.dialog-widget-content{animation-duration:.75s;border-radius:20px}`, `@keyframes fadeInRight` and `fadeIn`
     (animate.css's frames), `.animated{animation-fill-mode:both}`, `.fadeInRight{animation-name:fadeInRight}`;
     the drawer's rules.
   - `popup.js`: on a click of any `a[href*="elementor-action"]`, decode, build `div#elementor-popup-modal-<id>
     .dialog-widget.dialog-lightbox-widget.dialog-type-buttons.dialog-type-lightbox.elementor-popup-modal`
     › `div.dialog-widget-content.dialog-lightbox-widget-content.animated` › (`div.dialog-header`,
     `div.dialog-message.dialog-lightbox-message` › the template, `a.dialog-close-button[role=button][tabindex=0]
     [aria-label=Close]` with an svg ×), the first time; later opens show it again; add the entrance class; Escape
     (keyup) and a click whose target is the dim (the wrapper itself) close it unless prevented; closing plays the
     exit animation with `animation-direction: reverse`, then `display: none` on the wrapper. `drawer.js` likewise.
2. RED `test/web/capture-opens.test.ts` "the capture reads what each opener opens": `captureSite({ url: fx.site +
   "/", fontSource: standIn(fx), browser, shots: false })`; assert `cap.web.code.opens.length === 3`; for pop-up 77:
   `openers` = both ☰ paths (via `pathOf` on the live fixture), `how: "elementor-popup"`, `cover: true`, `side:
   "right"`, `noScroll: true`, `closeOn {esc: true, outside: true}`, `closers` = the × path, `entrance` = the
   `.dialog-widget-content` path, `read` = every range; its `.dialog-message` node's `width` is `25vw` at the widest
   range and changes to `40vw` and `85vw` at the ranges holding 1024 and 767; every link of the template is a node
   with its `href`; `keyframes.fadeInRight` exists; pop-up 78: `closeOn {esc: true, outside: false}`, `side: null`;
   the drawer: `how: "controls"`, `cover: false`, `side: "left"`, `closeOn {esc: true, outside: false}`, closer its
   ×. Then a second capture with `opens: false` (a test-only `CaptureOptions.opens` flag): every `web.code` field but
   `opens` is deep-equal to the first's (the page's own reading untouched). RED on base: `opens` is undefined.
3. GREEN: `src/web/readers/openers.ts`, `src/web/read/opens.ts`, the `root` option (code-facts.ts, code.ts),
   `assembleOpens` (code.ts), the calls in capture.ts, `CaptureOptions.opens?: boolean` (default true), the type in
   `src/core/snapshot/web.ts`, `docs/specs/web-capture.md` "The site's own code" gains `opens`. The in-page parts
   (self-contained, sent with `Runtime.evaluate`, helpers `pathOf`, `findPath` as code-facts does):

```ts
// Runs in the page (site-menu): every opener whose box the page's own script opens on a click, keyed on a page
// builder's own marker (Elementor's pop-up action link) or ARIA's (aria-controls + aria-expanded), never on a site.
export interface OpenerFact { opener: string; target: string; how: "elementor-popup" | "controls" }
export function openersOf(_: unknown, helpers: { pathOf: (el: Element) => string | null }): OpenerFact[] {
  const out: OpenerFact[] = [];
  const add = (el: Element, target: Element | null, how: OpenerFact["how"]) => {
    const o = helpers.pathOf(el), t = target && helpers.pathOf(target);
    if (o && t) out.push({ opener: o, target: t, how });
  };
  for (const a of document.querySelectorAll("a[href]")) {
    let h = a.getAttribute("href") ?? "";
    try { h = decodeURIComponent(h); } catch { /* as written */ }
    const m = /#elementor-action:action=popup:open&settings=([A-Za-z0-9+/=]+)/i.exec(h);
    if (!m) continue;
    let id = "";
    try { id = String((JSON.parse(atob(m[1])) as { id?: unknown }).id ?? ""); } catch { continue; }
    if (!/^\d+$/.test(id)) continue;
    add(a, document.querySelector(`[data-elementor-type="popup"][data-elementor-id="${id}"]`), "elementor-popup");
  }
  for (const el of document.querySelectorAll("a[aria-controls][aria-expanded], button[aria-controls][aria-expanded], [role=button][aria-controls][aria-expanded]")) {
    const ids = (el.getAttribute("aria-controls") ?? "").trim().split(/\s+/);
    if (ids.length === 1 && ids[0]) add(el, document.getElementById(ids[0]), "controls");
  }
  return out;
}
```

   **[Amendments 2, 5]** Superseded at the head by `src/web/readers/openers.ts`'s own `openersOf`: the action matched
   only where the address starts with it, nothing inside a form or tied to one, an `aria-controls` link with a real
   address never pressed, a pop-up named by its id (`elementor-popup:<id>`) and looked up by selector each time; the
   opener pressed at a range is the first shown there whose press tries nothing.
   Node side keeps only openers under a part root and targets under none (`web.parts` roots, as `partsOf` gives them;
   the parts are known from the design width's reading, so each range's call receives the root paths). A target
   already shown at load isn't an opened box (a hidden part inside a part stays elementor-map's). The opener clicked at
   a range is the first one shown there (`getClientRects().length`).
4. Commit "site-menu task 2 (AC1): the capture reads what each opener opens".

**Task 3 — a closed `details` pastes its hidden content (AC5, unit half).** RED `test/unit/site-opens.test.ts`
"a closed details pastes its hidden content" **[Amendment 6: the name whole on one line]**: hand-made code (version 3) with a part holding `details` (shown) › `summary`
(shown) + `div` (shown `[]`) › two `a` with words; `siteParts(cap, { text: "rich" })` holds both links. RED on base
(the hidden `div` is left out by `buildTree`). GREEN: `tree.ts` `visit`: `const under = hiddenOk ||
!!opts.pasteHidden?.has(path) || n.tag === "details";`, and `convert.ts` `scan` the same. Commit.

**Task 4 — the converter's open (AC2).**
1. RED `test/unit/site-opens.test.ts` "a box an opener opens pastes as an Offcanvas its openers toggle": hand-made
   capture (in `test/fixtures/site-opens-code.ts`, built like `test/fixtures/site-page-code.ts`): header part with two
   opener `a`s (action hrefs), page part with words; `opens: [cover pop-up with closer and entrance, drawer]`; assert
   for `siteParts(cap, { text: "rich" })` and `siteParts(cap, { text: "rich", elementor: true })`:
   - header payload roots (`parent === 0`): the part root, then one `offcanvas`; the page payload: its root, then the
     drawer's `offcanvas` only if its first opener is in the page (the fixture puts it in the footer: the footer's);
   - the Offcanvas: `settings.direction === "right"`, no `closeOn` (both), `noScrollBody: true`, `_cssClasses` matching
     `/^home__open-[a-z0-9]{4}$/`, global classes `[site-offcanvas]`; children: Content (`_hidden._cssClasses ===
     "brx-offcanvas-inner"`, `label "Content"`, `deletable: false`, `cloneable: false`) whose one child is R's element
     (its classes start with `site-reset-pqgx`), and Backdrop (`"brx-offcanvas-backdrop"`, no children);
   - both openers' elements: `_interactions` deep-equal `[{ id: <6 letters>, trigger: "click", action:
     "toggleOffCanvas", offCanvasSelector: ".<marker>" }]`; the closer's too; nothing else gets `_interactions` but
     site-motion's (true of this capture: no box in it closes on an outside click reaching the page; where one does,
     every part's root and that box's openers carry the outside-close Interactions, `test/unit/site-opens-through.test.ts`)
     **[Amendment 1]**;
   - R's class custom CSS holds `pointer-events: none`; its children's `pointer-events: auto`; the entrance class has no
     `animation-name`; the Offcanvas `_cssCustom` holds `.brx-open`, `.brx-closing … reverse`, `transition-duration:
     0.75s` and the reduced-motion block, naming the renamed keyframes (`home-…fadeinright` as `motionOf` names them);
   - the drawer: `direction: "left"`, `closeOn: "esc"`, its root `pointer-events: auto` (the inner passes none down),
     Content alone (no Backdrop: its outside clicks reach the page) **[Amendment 1]**;
   - the template's links: a same-host link → its path; `tel:` kept;
   - notes: none containing "opens nothing"; `payloadProblems(payload)` is `[]` for every part;
   - the same capture twice gives byte-identical payloads.
   RED on base: no `offcanvas` element.
2. GREEN: `src/core/site/opens.ts`, the `SHARED_CSS` entry, `prepare`'s `opened` option, `payloadOf`'s reset on
   `p.root`, `parts.ts` wiring, `links.ts` (`opens` reason, new note words). Commit.

**Task 5 — Bricks shapes (AC7 GREEN).** Make Task 1's shapes test pass against Task 4's output; commit both.

**Task 6 — old captures unchanged (AC6).**
1. Guard `test/unit/site-opens-old.test.ts` "a capture without opens pastes as before": the AC2 capture with `opens`
   deleted, and `test/fixtures/site-page-code.ts`'s capture: no `offcanvas`, no `toggleOffCanvas` Interaction, the
   reset on each part root only, every element and class as on base (the builder writes, before Task 2, the base
   payloads' sha256 per part for these two hand-made captures into the test as literals, generated by a script run on
   a `git archive` of `fd1986dc`, and the head must match them once the note's words are swapped back), and the one
   note "a menu or pop-up button opens nothing: capture again with this build so the capture reads what it opens" for
   the action link. RED for the note's words on base. The named-only half (`F2B_SITE_MENU_BDRY=
   /home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, story-time pin, runs only when named): `siteParts` with
   `--elementor` on that capture equals `/home/justin/f2b-test/paste-el3/{header,page,footer}.json` byte for byte
   but the note (the builder records the base run's sha256 of each part in the ledger first).
2. `test/web/site-check-opens.test.ts` "site:check passes with opened boxes": `npm run site:check` on the AC1 fixture
   capture (`tools/site-check.ts` as `test/web/site-check-cli.test.ts` drives it) ends "OK", and its report lists the
   same rows as with `opens` deleted (the closed Offcanvas takes no room and isn't measured).
3. GREEN: `site-page-check.ts` skips elements under `.brxe-offcanvas`. Commit.

**Task 7 — the renderer and the browser proof (AC3, AC4, AC5 browser half).**
1. `test/browser/render.ts`: the Offcanvas and toggleOffCanvas printing and Bricks' scripts (Architecture). A unit
   guard `test/unit/render-offcanvas.test.ts` "renders an Offcanvas and its opener as Bricks prints them" (string
   checks on `renderPage`'s HTML: `class="brxe-offcanvas`, `data-direction="right"`, `data-brx-toggle-offcanvas="true"`,
   `tabindex="0"`, `"target":"offcanvas"` in `data-interactions`).
2. RED `test/web/site-opens-proof.test.ts` (as `site-motion-proof.test.ts` is built: `captureSite` on `site-menu`,
   `siteParts(cap, { text: "rich" })`, `renderSitePaste(pastePictures(…), head, HOSTILE_THEME, { motion: true })`):
   - "every opener opens its box as on the site, within 2 px": for each width in `cap.web.widths` and 300: open the
     fixture site and the header paste; click the ☰ shown (by its site path / paste id from `sources`); wait for both
     to finish opening (`finishAll`); `openedRows` → worst ≤ 2 px for every element under R, every word, every link's
     `href` equal to the site's rewritten as `siteLink` does; then Escape → both closed; reopen; click at (2, 2) → both
     closed; reopen; click the × → both closed; Tab from the page top reaches the paste's ☰ (`tabTo`), Enter opens;
     the dialog (pop-up 78): opened by its page link, Escape closes, a click at (2, 2) leaves both open; the drawer:
     opened by "Contact", Escape and its × close, an outside click leaves it open on both.
   - "the panel opens and closes with the site's own animation": open the paste with animations held (`holdAnimation`
     from `lib/motion-check.ts`); the entrance element's running animation is the renamed fadeInRight, 0.75 s, the
     site's timing function; at 50 % its opacity and transform equal the site's at 50 % (`values`) within 0.02 / 1 px;
     closing: `brx-closing` present while the reversed animation runs, and the Offcanvas closed once it ends; under
     `prefers-reduced-motion: reduce` no animation runs and it opens at once.
   - "the Services list opens as on the site": click "Services" in both → its three links show, within 2 px.
   - With the menu closed, `checkPage` on the three parts: within 2 px at every width (unchanged).
   RED on base: no Offcanvas. GREEN: Tasks 2–6 plus the renderer. `F2B_SITE_OPENS_OUT`: site | paste pictures of the
   open menu at 1440, 1024, 768, 390. Commit.

**Task 8 — named-only B-Dry conversion (AC8's pre-check).** `test/web/site-opens-bdry.test.ts`
"Justin's bdryswi.com capture pastes the menu pop-up and its two openers" **[Amendment 6: the name whole on one line]**
(skips unless `F2B_SITE_MENU_CAPTURE` names a capture with `opens`):
`siteParts(cap, { text: "rich", elementor: true })`: the header paste holds one Offcanvas whose subtree holds the words
Services, Foundation Repair … Exterior Drainage, About Us, Service Areas, Warranty, Contact Us, Get Your Estimate and a
`tel:8124362379` link; both ☰ elements carry the Interaction naming its marker; the page paste holds the hotspots'
Offcanvases (Q2 A) opened by their links; `payloadProblems` clean. Commit.

**Task 9 — HANDOFF and the paste check.** `docs/HANDOFF.md`: a new top section "A site's ☰ and pop-up links open as on
the site (site-menu, website importer; build <at merge>; paste check <id> owed)" (what changed, proofs, files, tests,
⭐ rulings Q1–Q6 not yet confirmed, known limits, follow-ups) and its end-of-run entry. Paste check steps (one action
each): 1. `npm run capture -- https://bdryswi.com/` (pass the human check if asked); 2. `npm run site --
~/Downloads/<capture> ~/Downloads/bdry-paste --elementor`; 3. paste the page as before (staging-fit's steps; Import
classes: Accept); 4. Bricks → Settings → Custom code → Regenerate code signatures; 5. open `/homev2/?f2b=<random>` at
1440: click the ☰ → the menu slides in from the right over the dim; click Services → its 7 links; press Escape → it
closes; open it, click the dim → it closes; open it, click × → it closes; 6. the same at 1024, 768 and 390 (phone: the
round ☰); 7. click About Us → staging's /about-us/; 8. click each hotspot → its pop-up; 9. Tab to the ☰ with the
keyboard and press Enter → it opens. Commit.

**Close:** `npm run check`, `npm run test:web`, `npm run test:browser`, `npm run corpus` (no width worse than base),
the ledger. Status `ready-for-review`.

## Overlaps with the other five jobs (build side by side; merge order)

- **staging-fit (and its capture job staging-fit-capture):** fixes the capture's 768–991 styleless read; Justin
  re-captures after it. Shared files: `src/web/capture.ts` (both add steps to `readOpened`; this job's call is the
  last line before `return`), possibly `src/web/session.ts`. **Merge staging-fit-capture first**; this job rebases
  (AC8 needs the fixed capture anyway). No `web.code.version` bump here, so no version clash.
- **site-native-structure:** may change which Bricks element an opener or a panel element becomes. This job keys on
  site paths, not element names: the Interaction goes on whatever element the opener's path became; if it becomes a
  Bricks `toggle`, write `toggleSelector` instead (Bricks refuses the Interaction on a Toggle); a Bricks `button`
  takes the Interaction as is. R's subtree is converted by the same `prepare`, so native-structure's choices apply
  inside the panel too. Shared files: `convert.ts`, `parts.ts`, `kinds.ts`, `tree.ts` (Task 3's one line). Either
  order; the second rebases (expected conflicts in `prepare`'s options and `payloadOf`).
- **site-faq:** `elementor-accordion.ts` and the accordion's renderer branch. The menu's Services list is an Elementor
  *nested* accordion (`details`), not in `ACCORDION_WIDGETS` (`elementskit-accordion`, `accordion`), so untouched; if
  site-faq adds `nested-accordion`, the list becomes a Bricks Accordion and Task 3's `details` rule simply no longer
  meets it there (AC5's fixture keeps a plain `details`). Shared: `test/browser/render.ts` (the Bricks script line,
  `bricksScript([...])`: both add a call and a ready flag; keep both).
- **site-slider:** Swiper → Bricks Slider in `web.sliders`; the menu panel's background slideshow is made by
  Elementor's script only when the pop-up opens and isn't in `web.sliders` (read from the page at load), so it pastes
  as read (one photo). Shared: `render.ts`, `capture.ts` (sliders reader) — rebase only.
- **site-reviews:** no overlap (embeds).
- **Merge order recommended:** staging-fit-capture → staging-fit → site-native-structure → site-faq / site-slider →
  site-menu (or site-menu before native-structure: both rebase cleanly by keying on paths).
- **Since this plan was written:** staging-fit-capture, site-faq, site-reviews, site-slider, staging-fit-renderer, [amended A10]
  site-media-upload, staging-fit-cancels, panel-embed-code and control-weight are merged (main `11e885fd`, Build [amended A10]
  2026-11-10.8) and this branch sits on them (stacks 6 and 13, fixer 6's two moves); site-native-structure is not on [amended A10]
  main. Where they meet this job, each with its test: a media map and an opened box (`site-opens-media`), bounded runs [amended A10]
  in an opened box (`site-opens-no-revert`), site-slider's goldens regenerated for this job's header note (fixer 5). [amended A10]
- **site-media-upload (merged, Build 2026-11-10.5):** this job changes one statement of its tool [amended A10]
  (`tools/lib/site-upload/pictures.ts`: the kept filter) and narrows what its Q3 A leaves on the old site: the site's [amended A10]
  own pictures inside a box the capture opened go up ("The pictures of an opened box"). Its merged plan, its HANDOFF [amended A10]
  section and the `CLAUDE.md` decision bullet still say script-made pictures are left: the lines to write are under [amended A10]
  "For the merge finisher". Its upload guards (`tools/site-upload.ts`, `guard.ts`, `ask.ts`, `scrub.ts`, `stop.ts`, [amended A10]
  `sent.ts`) are untouched by this job. [amended A10]
- **site-one-command (unmerged, review-clean, being rechecked): the launch and its pin, joined in either order** (the [amended A10]
  same join as its plan's "Overlaps with unmerged jobs", `evidence/site-one-command/plan-approved.md`, its A3). This [amended A10]
  job starts every capture's Chrome through `launchCaptureChrome` (`src/web/capture.ts`), which adds the socket gate, [amended A10]
  and its commit `7094a7d4` points the launch-line case of `test/unit/capture-chrome.test.ts` at [amended A10]
  `launchCaptureChrome(…)` in `tools/capture.ts`. site-one-command moves that launch out of `tools/capture.ts` into [amended A10]
  `tools/lib/capture-run.ts` (`captureRun`, shared by `npm run capture` and `npm run site:import`) and rewrites the [amended A10]
  same case. `capture-run.ts` is a new file, so git shows no conflict there: the swap must be made by hand, or [amended A10]
  `capture` and `site:import` lose the socket gate with every test green (the gap review 8's R8-3 names for the [amended A10]
  helper). Whichever job merges second makes the joined tree this: [amended A10]
  - `tools/lib/capture-run.ts` imports `launchCaptureChrome` from `../../src/web/capture.ts` (not `launchChrome` from [amended A10]
    `test/browser/chrome.ts`) and calls `launchCaptureChrome({ path: chrome.path, args: chrome.args, visible })`, [amended A10]
    exactly once; [amended A10]
  - `tools/capture.ts` and `tools/site-import.ts` call only `captureRun`: no launcher import, no launch of their own; [amended A10]
  - `test/unit/capture-chrome.test.ts` keeps site-one-command's case under its unchanged title, with its [amended A10]
    `capture-run.ts` assertion naming `launchCaptureChrome\(\{ path: chrome\.path, args: chrome\.args, visible \}\)`, [amended A10]
    one assertion that `capture-run.ts` imports `launchCaptureChrome` from `../../src/web/capture.ts`, and its [amended A10]
    `doesNotMatch(/launch\w*Chrome\(/)` for both commands' files; [amended A10]
  - `tools/capture-serve.ts` (the helper) keeps its own `launchCaptureChrome(…)` call, as on this head. [amended A10]
  site-menu first: site-one-command's rebase conflicts in `tools/capture.ts` (take its `captureRun` call, drop the [amended A10]
  `launchCaptureChrome` name from the import there) and in the test (take its case, then the join above). site-one-command first: [amended A10]
  this job's move conflicts in `tools/capture.ts` (its launch line is gone: port `launchCaptureChrome` into [amended A10]
  `capture-run.ts`) and in the test (keep site-one-command's case, then the join). The check after the join, either [amended A10]
  way: `git grep -n -E 'launch(Capture)?Chrome\(' -- tools/capture.ts tools/site-import.ts` prints nothing; [amended A10]
  `git grep -c 'launchCaptureChrome(' -- tools/lib/capture-run.ts` prints `tools/lib/capture-run.ts:1`; the case [amended A10]
  passes; and this job's socket tests (`socket-gate`, `web-press-guard`, `press-guard-sockets`, and [amended A10]
  `capture-opens-guards`, whose own-Chrome case captures with the Chrome the capture starts) and site-one-command's [amended A10]
  capture-equality criterion pass on the joined head. A join that resolved conflicts gets a fresh review of them [amended A10]
  before the verifier runs. [amended A10]

## Bricks samples needed

- **Offcanvas** (missing from `reference/bricks/`; researched candidate in Task 1 meanwhile) and **a Div with an
  Interaction Click → Toggle offcanvas** (the click-open shape; `cta-button-interactions.json` holds only
  `startAnimation`). One copy covers both (Q3's steps).

## Risks and limits

- The capture's time grows: one small code reading per opened box per range (B-Dry: 5 boxes × 16 ranges, each a few
  dozen elements) plus the close proofs at the design width; timings are recorded per range (`opens <range>`).
- A site's own pop-up script must run in the capture; a site whose opener needs a hover or a scroll first, or whose box
  is fetched by AJAX on click, is read if it shows within 3 s, else named ("a pop-up its link opens didn't show").
- Elementor's exit animation other than the entrance reversed (`exit_animation` naming another) plays the entrance
  backwards: a follow-up.
- An opener whose box lies inside its own part (a theme's in-header mobile menu toggled by class) isn't this job's:
  named in the notes as before (follow-up: read that open state as a state look, as site-motion reads hover).
- The menu's Services chevron keeps its closed drawing when open (Q5 A).
- B-Dry proofs are live only (bot check; the stand-in has no scripts).
- **[Amendment 5]** What the reviews left open in normal use (HANDOFF's site-menu "Deferred" holds the rest):
  - a window a page's handler opens after the guard has let go of the page (later than the last press's grace) is no
    longer held and loads (review 3's R3-3 class; fixer 4);
  - a dedicated worker already running when the guard starts (the page's or a frame's) has no Fetch, so it sends the [amended A7]
    http requests a press asks it to (review 3's R3-4, review 4's R4-4); its WebSockets pass the gate like any other; [amended A7]
  - a frame of another site added inside a frame after the guard starts (a new embed's inner frame, a held frame's new
    child after it navigates) isn't held: its writes reach its own site (review 5's R5-1); one a press adds that
    doesn't answer within 5 s isn't named (R5-2);
  - GETs pass by design: a write-like GET (`/cart/add?id=1`) or a pop-up plugin's open beacon (Popup Maker's image GET
    on each open) reaches the site and may count the capture's opens in its stats (review 3's R3-4);
  - the guard's cost: about 30 % more capture time (the fixture 19 s → 25 s, the B-Dry stand-in 521 s → 686 s; each
    press waits 300 ms of page time and a round trip, and every request goes through Node while the guard is on;
    review 3's R3-5); the closed `details` and box readings cost one more small reading each per range (review 2's
    R2-6);
  - also named in HANDOFF: a control whose handler shows `alert`/`confirm`/`print` stalls the capture (R1-4); a
    same-site report on every click makes every opener count for nothing (R3-2); a write started more than 300 ms after
    its press is charged to the next press (R3-3); a box whose content only the service worker has reads as the server
    answers while the guard holds (R4-2); after a close by a click outside, Bricks gives the focus back to the opener
    (the page scrolls to it), a click on an in-page anchor link doesn't close such a box, and a click in Bricks' own
    header or footer template doesn't either (R2-7).
- Sockets and the pictures of an opened box: what fix passes 6 and 7 and reviews 8 and 9 left open (each in `evidence/site-menu/follow-ups.md` under its id; with the gate, the guard itself held in every probe: nothing a press opened or sent on a socket reached a server): [amended A8]
  - F6-1: WebTransport and WebRTC data channels are not held while the capture presses (UDP, no request; no local proof without an HTTP/3 server; `site:live` has the same limit). An `EventSource` is a GET and passes as a read. [amended A7]
  - F6-2 (narrowed by fix pass 7): the gate serves the whole browser, so while one page load presses, the sockets of the page loads read beside it (`--windows`, 4 by default) are refused and cut too; since fix pass 7 they blame no press and are listed apart (review 9: 5 runs of 5 at 4 windows). [amended A8]
  - F6-3: a socket already open is cut when it sends anything while the gate is shut, a pong answering its server's ping included: a chat widget's live connection may close once and connect again after the presses. [amended A7]
  - F6-4: a picture the site's own script makes through a library another host serves (jQuery from a CDN) has another site's file on its stack and stays on its old address (the safe side). [amended A9]
  - F6-5 (a test, not the rule): the two service-worker cases of `test/web/capture-opens-guards.test.ts` compare two captures' boxes and fail under load on an entrance's `animation-name` read `null`, `undefined` or `fadeInRight` (seen at load 18, 37, 50 and, on the base `86fc5546`, 52; both pass alone at load 30). [amended A8]
  - F6-6 (a test gap): in `test/fixtures/site-opens-pictures.ts` the photo drawn "through the site's jQuery" sits inside the vendor-made widget, so that clause is pinned by `site-made-in-open` alone (mutant M3 is killed there, not by `site-opens-own-pictures`). [amended A9]
  - F7-1 (accepted; the http guard's same-site timer class): a message on a socket of the page's own site (the same host, or one under the other) that the page opened before it pressed counts against the press it falls in, whoever sent it; and the gate is shut for a page load's whole press span, so each such beat is cut and each reconnect is a new refused socket of that page. Review 9, the site-menu fixture with a same-host socket the page beats on: every 2 s at 4 windows, a pop-up lost its only opener to its own page's beat in 3 runs of 5; every 15 s at 4 windows, a press was blamed in 2 runs of 3 (the proof of the click outside only: no box and no paste changed), at 1 window in 0 of 3; every 25 s at 1 window, a press was blamed in 3 runs of 3 and a box lost its only opener in 2 of 3; a client that connects again 1–2 s after a cut (as Socket.IO does) at 1 window: 2 and 3 presses blamed and the drawer's opener lost in 1 run of 2 (at 4 windows no press blamed, 2 runs of 2). The base `86fc5546` loses the same way (the drawer's opener, 1 run of 1): no regression. A socket to another site never costs a press, so third-party chat widgets (Tawk, Intercom, Crisp) are not affected. [amended A8]
  - F7-2: a page with a frame or worker whose `Network.enable` isn't answered within 5 s (or is refused) is charged every refusal no known-address report claims while it presses ("whose, not known…", the child named as not held), so its openers can be lost to another window's sockets as before fix pass 7; not seen on any fixture or on the B-Dry stand-in. [amended A8]
  - F7-3: two pressing pages that each send, at the same moment, on a socket opened before their sessions were watched (no known address) may have their two refusals swapped; each page is still blamed exactly once. [amended A8]
  - R9-1: a socket a press starts through a SharedWorker is refused (0 connections reached review 9's counting server) but no session of the page reports it (shared workers are never attached), so it blames no press and is listed apart; the base `86fc5546` counted it against the press. [amended A8]
  - R9-2: a socket to an IPv6 literal (`ws://[::1]:9555/`) is refused but never claimed: Chrome's SOCKS5 client names the host as a name without brackets (`::1`, `2001:db8::1`), `hostKey` can't parse that, and the refusal's address (`::1:9555`) never equals the report's (`[::1]:9555`); it blames no press, where the base counted it. Three places on the head say otherwise ("the gate's IPv6 in full, the report's shortened"): HANDOFF's site-menu section (line 356 at `058ec3ea`), the comment at `src/web/press-guard.ts:88`, and the input at `test/unit/web-press-guard.test.ts:237`, a bracketed full form real Chrome never sends ("For the merge finisher"). [amended A8]
  - R9-3: a worker inside a window the press opened isn't watched (only that window's own session is), so a socket it opens is refused but blames no press; the base counted it. [amended A8]
  - R9-4: a report and its refusal pair only within 2 s, and Chrome's per-renderer throttle delays a new socket once that renderer has had many failed ones: after about 70 refused sockets in one tab, refusals came 271, 1811 and 3517 ms after `new WebSocket`, and the 3517 ms one was refused but not claimed (it blamed no press; the base counted it while the press was still reading). [amended A8]
  - R8-2: the capture's press runs under the fixed source name `f2b-capture-press.js`, which the tracker skips, so a page script that gives itself that name (`//# sourceURL=`) drops out of every stack. What it can reach: a served vendor file's floating box went from "not proven" to that file's own served tag pasted (the file alone draws nothing). What it can't: no tracker, tag manager or inline code reaches a paste this way, and in an opened box the name only removes frames, so a picture counts as the site's own only if the files left are the site's. Only a page written to evade the capture; a random name per capture would close it. [amended A9]
  - R8-3 (a test gap): no test pins that the helper's route (`tools/capture-serve.ts:47`, the Figma panel's captures) launches through `launchCaptureChrome`: were it to go back to `launchChrome`, every test stays green and the panel's captures press with no socket gate (their sockets only named as not stopped). [amended A8]
  - R8-4: a Chrome without the gate names only the sockets created during a press; a message on a socket opened at load leaves and no note names it (review 8's probe: 20 frames reached the server). Every route Justin runs has the gate; only a caller's own Chrome (the tests', the offline dry runs) has none. [amended A8]
  - R9-6 (a test, seen once, cause unknown): the service-worker case of `test/web/capture-opens-guards.test.ts` that answers every request failed once on "no window or tab of the capture is left open" (one tab still listed after `captureSite` returned, the load falling from 34 to 14); three reruns on the head passed. [amended A8]
  - The cost: the gate adds no wait to a press (only sockets pass through it). The site-menu fixture by the capture's own Chrome: 21.5–22.1 s before fix pass 6 and 21.2–22.1 s after (3 captures each); around fix pass 7 at load 25–31: 22.8, 26.3 and 29.6 s on its base, 32.8, 29.1 and 26.6 s on the head (the ranges overlap); review 9's fixture with another site's frame, a worker and a worker's worker at 4 windows: 25, 28 and 32 s on the base, 24, 26 and 24 s on the head. The offline B-Dry stand-in: 482 s before fix pass 6, 529 and 609 s after (load 6.7 against 9.7 and 12.6), 738 s on the head at load 30–50 and 578 s in review 9's run; every run the same five boxes, 0 requests that aren't a GET, 0 socket handshakes. [amended A7, A8]

## Completion contract

Builder: every AC's test named on one plan line, RED on base and GREEN on head recorded in the ledger with commands;
one picture per AC (site | paste of the open menu; a terminal capture for AC1, AC2, AC6, AC7); `npm run check` and
`npm run corpus` green; no `BUILD` bump; nothing pushed; status `ready-for-review` with the head SHA and
`skill_lessons`.

## For the merge finisher: site-media-upload's records [amended A11]

Checked against the head's `uploadList` (`tools/lib/site-upload/pictures.ts`) and `madeInOpen` [amended A11]
(`src/core/site/media.ts`): a use is left as "another company's script drew it" when its `made` is true; inside an [amended A11]
opened box `made` is `madeInOpen`'s answer (true only for a script-made step with another site's file on its stack, [amended A11]
code with no file, a stack read in part, or no record), outside a box it is any `~` step, as merged; a `data:` [amended A11]
picture is left before either is asked; and `kept` drops every address that also goes up. Nothing below is code. Each [amended A11]
fenced block is the text to write, as it stands. [amended A11]

1. `docs/HANDOFF.md`, the section "A scanned page's pictures go to WordPress's media library (site-media-upload, …)", [amended A11]
   the bullet that starts `  - Q3 A:` (5 lines: 482–486 on main `11e885fd`, 858–862 on this branch's head). Replace the [amended A11]
   whole bullet with: [amended A11]

```text
  - Q3 A: every picture the site's own markup shows in the paste (each Image's picture; each CSS `background-image`,
    `background`, `mask-image`, `-webkit-mask-image` picture whose file the capture holds), one file once by its bytes
    wherever it shows (a CDN's sizes of one file are one file). Left on their addresses, named in the summary: pictures
    another company's script drew (`~` paths), **except the site's own pictures inside a box the capture opened** (a
    menu or pop-up: every script-made step on the picture's path made by the site's own files alone, `CodeOpen.makers`
    and `media.ts` `madeInOpen`; Justin, 2026-11-10, "Upload them too", built by site-menu), a live widget's code, Code
    elements' markup, pictures already inside the paste (`data:`). An address that goes up is never also listed as
    staying. A capture made before site-menu's build keeps every script-made picture of an opened box on its address
    (capture again).
```

2. `CLAUDE.md` in the main folder (never committed; if writing it is refused, the same lines go in [amended A11]
   `~/.hermes/plans/figma-to-bricks/site-menu-claude-md-pending.md`), "Decisions the user made", the bullet "**A scanned [amended A11]
   page's pictures go to WordPress from the command line**": its fourth line is [amended A11]

```text
  picture the site's own markup shows, each file once, script-made ones and `data:` left (Q3 A); no file in the
```

   Replace that one line with these three (the bullet's other seven lines stay as they are): [amended A11]

```text
  picture the site's own markup shows, each file once, script-made ones and `data:` left, **except the site's own
  pictures inside a box the capture opened** (every script-made step made by the site's own files; Justin, 2026-11-10,
  "Upload them too"); an address that goes up is never also listed as staying (Q3 A); no file in the
```

3. `docs/plans/2026-11-10-site-media-upload.md` (merged and accepted: records only; no criterion's sentence, id, live [amended A11]
   tag or cited test name changes, and no added line starts with a criterion's id). Three edits. [amended A11]
   (a) At the end of its Amendments list, after the item that starts `- A7, other lines the head made false or stale`: [amended A11]

```text
- A8 (2026-11-10, after the merge, from site-menu's fix pass 6; Justin, "Upload them too"): Q3 A leaves script-made
  pictures on their addresses except the site's own inside a box the capture opened (a menu or pop-up), and the upload
  list never names an address as both going up and staying. Lines: Q3, and an Also line under the upload-list
  criterion. The criterion's sentence was checked against it and stands; its cited test is unchanged.
```

   (b) In its question 3 ("**Which pictures go up.**"), the two lines [amended A11]

```text
   slides, closed answers). Left on their addresses, each named in the summary: pictures another company's script drew
   (review widgets' stars and avatars: `~` paths), a live widget's own code, Code elements' markup (inline SVG, video
```

   become [amended A11]

```text
   slides, closed answers). Left on their addresses, each named in the summary: pictures another company's script drew
   (review widgets' stars and avatars: `~` paths) **[A8]** except the site's own pictures inside a box the capture
   opened (a menu or pop-up whose every script-made step was made by the site's own files: site-menu; Justin,
   2026-11-10, "Upload them too"; an address that goes up is never also listed as staying), a live widget's own code,
   Code elements' markup (inline SVG, video
```

   (c) Under its upload-list criterion, right after its `Test:` line (the one naming [amended A11]
   `test/unit/site-upload-pictures.test.ts`), one new line: [amended A11]

```text
  Also **[A8]** (site-menu's fix pass 6; supporting, never the cited test): inside a box the capture opened the site's own pictures go up, each file once, another company's stay, and no address is on both lists: `test/unit/site-opens-own-pictures.test.ts` "an opened box's own pictures go up once with the page's; another company's in a box stay; none is on both lists"; the rule case by case: `test/unit/site-made-in-open.test.ts` "an opened box's element is the site's own only when every script-made step on its way was made by the site's files"; the command, a dry run and a run against the 127.0.0.1 stand-in: `test/unit/site-upload-opens.test.ts`.
```

4. This job's own records, which review 9 found untrue or short (`docs/HANDOFF.md`, site-menu's section; lines as at [amended A11]
   `058ec3ea`). They are docs, but a commit of them on the branch moves the head `ac-check.sh` accepts: they go in the [amended A11]
   finisher's after-merge commit on main (with the BUILD bump), as items 1 and 3 do. [amended A11]
   (a) Line 356, the words [amended A11]

```text
address (written one way: the gate's IPv6 in full, the report's shortened); a report of a known address claims first,
```

   become [amended A11]

```text
address (host and port; a socket to an IPv6 literal is never paired, because Chrome's SOCKS5 client names it without
  brackets: it is refused, listed apart and blames no press, review 9's R9-2); a report of a known address claims first,
```

   (b) After the words `every other window's beat listed apart; follow-up F7-1).` (line 372) add: [amended A11]

```text
Review 9 measured more on the same fixture: a 2 s beat at 4 windows cost a pop-up its only opener in 3 runs of 5 (its
  own page's beat); a 15 s beat at 4 windows blamed a press in 2 runs of 3 (the click-outside proof only, no box or
  paste changed); a 25 s beat at 1 window blamed a press in 3 runs of 3 and cost a box its only opener in 2 of 3; a
  client that connects again 1–2 s after a cut, at 1 window, had 2 and 3 presses blamed and lost the drawer's opener in
  1 run of 2. The base loses the same way; a socket to another site never costs a press.
```

   (c) In that section's Deferred list, one line for each limit of "Risks and limits" above that it doesn't hold yet [amended A11]
   (R8-2, R8-3, R8-4, R9-1, R9-2, R9-3, R9-4, R9-6), in the words used there. [amended A11]
   (d) `docs/specs/web-capture.md`, the bullet "**opens (site-menu, …)**" (line 404 at `058ec3ea`) names neither [amended A11]
   `makers` nor the socket gate; add at its end: [amended A11]

```text
  Each box also records who made its script-made elements (`makers`: path → the script files on the stack that made
  it, innermost first; `about:inline-code` code with no file, `about:stack-cut` a stack read in part; the capture's
  own press, run as `f2b-capture-press.js`, is no one's code), and every press runs under the press guard, the socket
  gate of the capture's Chrome shut meanwhile (`src/web/press-guard.ts`, `src/web/socket-gate.ts`).
```

   (e) `docs/plans/2026-11-09-site-menu.md` is still the first approved text (never amended in the repo): copy the [amended A11]
   approved plan as installed (`evidence/site-menu/plan-approved.md`, holding A1–A11) over it in the same commit. [amended A11]
   (f) Not edited (code; they go with the fix of R9-2): the comment at `src/web/press-guard.ts:88` ("the gate's IPv6 [amended A11]
   in full, a report's address shortened") and the input at `test/unit/web-press-guard.test.ts:237` [amended A11]
   (`[0000:0000:0000:0000:0000:0000:0000:0001]`: real Chrome tells the gate `::1`). [amended A11]
5. Offered, beyond site-media-upload's lines: a standing rule for `CLAUDE.md` "Working in this repo", since a tool that [amended A11]
   launches a capture's Chrome another way loses the gate with every test green (R8-3, and the join above): [amended A11]

```text
- **Every Chrome a capture starts launches through `launchCaptureChrome`** (`src/web/capture.ts`; site-menu, Justin,
  2026-11-10, "Block sockets"): it adds the socket gate (`src/web/socket-gate.ts`) the press guard shuts while the
  capture presses a page's menu and pop-up buttons. `launchChrome` alone starts a Chrome with no gate: its sockets
  during a press are only named as not stopped.
```
