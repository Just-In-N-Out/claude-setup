# site-sticky-header: a scanned header that stays at the top on the old site stays at the top in the paste

Mini pipeline, a bug. Website importer (code route: `npm run site`, `site:upload`, `site:import`). Base: `main` at Build
2026-11-11.3 (`02481763`). The builder copies this file to `docs/plans/2026-11-11-site-sticky-header.md`.
Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/planner/` (called `<planner>` below).

## Playback

1. On bdryswi.com the header stays at the top of the window while you scroll. In your paste on B-Dry staging (Bricks
   2.4.2) it scrolls away with the page.
2. You pasted `header.json` at the top of the page itself, above `page.json` (what `site:import`'s own "Next steps"
   tell you to do), not into a Bricks Header template. You don't know whether staging's Additional CSS holds
   `html, body { overflow-x: hidden }`.
3. You want this fixed for every scanned site whose header stays put, as a Mini job.

## Questions (⭐ = the answer the builder takes under the standing auto-go)

- **Q1. Where must the header paste work?** ⭐ **A: in both places, with nothing to turn on in Bricks.** Pasted at the
  top of the page (your way), or into a Header template: one small class on the header's root keeps it at the top in
  either. You leave Bricks' "Sticky header" setting off. B: only in the page; in a Header template you turn on Bricks'
  Sticky header yourself (Bricks' version is fixed to the window and takes no room, so it covers the top of the page).
- **Q2. How does it stay: CSS `position: sticky`, or fixed to the window with a spacer script?** ⭐ **A: sticky.** It
  is what the Figma plugin's own header bar already uses, it keeps the header's own room at every width with no
  script (so nothing to sign, and Bricks' editor shows the page right), and it sits under the admin bar. B: fixed plus
  a spacer script, as the old site's page builder does it (needs "Regenerate code signatures", and the editor would
  show the header over the page's top).
- **Q3. `html, body { overflow-x: hidden }` in Additional CSS** (it stops every sticky box from sticking).
  ⭐ **A: the header's class overrules it where the header is**: html and body cut sideways overflow with `clip`
  instead of `hidden`. The page still can't scroll sideways, and the header stays whether or not that rule is in your
  Additional CSS: you don't need to check or remove anything. B: leave your rule alone and tell you to remove it by
  hand.
- **Q4. The look a site switches to after a scroll** (a smaller logo, a shadow, another colour). ⭐ **A: not copied,
  and the notes say so.** The capture reads the page in one state, so it holds one look. (B-Dry's bars look the same
  before and after a scroll.) B: a later job reads the page again after a scroll.
- **Q5. A header the old site keeps at the top only on some screen sizes** (say, on desktops but not on phones).
  ⭐ **A: the paste keeps it at every width.** The capture records that a bar stays, not at which widths. (B-Dry's
  stays at every width.) B: a later job, if a site of yours needs it.

## Root cause (proven)

**How the old site keeps it.** bdryswi.com's header holds two bars, one for desktops and tablets and one for phones.
Each is an Elementor container with Elementor Pro's sticky setting: the served page has `"sticky":"top"` in the
container's `data-settings`
(`~/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/inputs/bdry-2026-10-29/home.html`, `data-id="9d2ab99"`).
The site's CSS gives the bar only `position: relative`. Elementor's script then writes `position: fixed; top; width`
into the bar's `style` and puts a hidden copy of the bar under it to hold its room.

**What the capture records** (`~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`, read with
`<planner>/inspect-header.mjs` and `inspect-position.mjs`; output `<planner>/header-capture.txt`):
- The site's own code for the bar says `position: relative; z-index: 99`. The script's values are left out on purpose
  and only named: `scripted: ["margin-bottom","margin-top","position","top","width"]`
  (`src/web/read/code.ts:146`, "a script's writes left out, named in scripted"; `src/core/snapshot/web.ts:62`).
- The hidden copies are there as `body/div:0/header:0/div~0` and `div~1` (`visibility: hidden`).
- The capture does know the bars stay: both bars' layers are marked `web.position: "fixed"` (`w2` the desktop bar,
  `w19` the phone bar), written by `src/web/assemble.ts:106-110` and `src/web/map/node.ts:92` ("a part's own fixed
  content").

**What the paste writes** (`~/Downloads/bdry-test/paste/header.json`, read with `<planner>/inspect-paste.mjs`):
- Root Div `home__site-header-cbvj`: no position at all.
- The two bars (`home__call-us-pwwd`, `home__section-exbp`): `position: relative; z-index: 99` in their custom CSS.
- The hidden copies are dropped: `src/core/site/widgets.ts:21` (`HIDDEN_COPY`), noted by `src/core/site/convert.ts:164`
  ("left out: 2 hidden copies a script made (a sticky bar's spacer, …)").
- Nothing in `src/core/site/` reads `web.position` or `scripted` to keep the bar anywhere, and `notes.txt` says nothing
  about it. (Only the older panel route does: `src/core/snapshot/capture-part.ts:55-57` prints "turn on Sticky header
  in the template's settings", which is no help for a header pasted in the page.)

So the paste is an ordinary header in the page's flow. Nothing is broken in Bricks: the paste simply never asks to
stay.

**Drawn and scrolled** (`<planner>/repro.ts`, log `<planner>/repro.log`, numbers `<planner>/repro.json`): your own
`header.json` + `page.json` + `footer.json`, drawn in one page as Bricks 2.4.2 prints them (`renderSitePaste`, all
three inside `<main id="brx-content">`), at 1440 and 390, scrolled 1200 px:

| Case | Header bar's top after the scroll |
|---|---|
| A. Your paste as it is (Build 2026-11-11.3) | −1200: scrolls away |
| B. The same with `html, body { overflow-x: hidden }` | −1200: scrolls away |
| C. The fix's sticky rule on the header's root | 0: stays |
| D. C with `html, body { overflow-x: hidden }` printed after | −1200: scrolls away (the body became a scroll container) |
| E. C plus the fix's `clip` guard, with that Additional CSS | 0: stays, no sideways scroll |
| F. C with site-scroll-lock's `html, body { overflow-x: clip }` alone | 0: stays, no sideways scroll |
| G. C with site-scroll-lock's rule, then the Additional CSS | −1200: the later `hidden` wins |
| H. C plus the guard, the scroll lock and the Additional CSS | 0: stays |
| I. Your paste as it is, header inside a Header template (`#brx-header`) | −1200: scrolls away |
| J, K. The fix, header inside a Header template (K: with the Additional CSS) | 0: stays |

The same at both widths. Cases D and G are why the fix carries its own guard (Q3).

## The fix

**Rule (general, for every scanned site).** When the capture marks a layer of the header part as fixed to the window
(`web.position: "fixed"`) and the site's own code fixes none of those layers (no `position: fixed` or `sticky` among
their declarations in any range: a script keeps them there), the header paste's root takes one class of the plugin's
own. Nothing else in any paste changes. A header the site's own CSS keeps (`position: fixed` or `sticky` in its code)
already pastes with that code and is left as before. A header that scrolls away on the site is left as before.

**The class**, named `<page>__site-stay-<4 letters>` (under the page's name like every importer class; the letters are a
fingerprint of its rules, `classes.ts` `versioned`, so a later change of the rules gets a new name and Bricks never
asks about it). Its custom CSS, with `N` the class name:

```css
.N.N { position: sticky; top: var(--wp-admin--admin-bar--height, 0px); z-index: 100; }
#brx-header:has(.N) { position: sticky; top: var(--wp-admin--admin-bar--height, 0px); z-index: 100; }
html:root, html:root > body { overflow-x: clip; }
```

- Line 1, pasted in the page: the root sticks inside Bricks' `<main id="brx-content">`, which is as tall as the page.
  The three declarations are the Figma plugin's own sticky bar (`src/core/style/style.ts:99`) and the standing
  "sticky header (100)" level. The class is named twice so the reset's `all: revert` and the root's own class (one
  class each) never outweigh it, whatever order Bricks prints classes in. Position, top and z-index are never class
  controls on this route (`src/core/site/controls.ts`), so no `.cls.brxe-div` control rule competes.
- Line 2, pasted in a Header template: Bricks' `<header id="brx-header">` is only as tall as the header, so nothing
  can stick inside it; the header element itself sticks where it holds the class. Bricks 2.4.2's own front-end CSS
  uses `:has()` on `#brx-header` too (`reference/bricks/frontend-2.4.2/frontend-light-layer.min.css`,
  `#brx-header.brx-sticky.slide-up:not(:has(…))`). The paste can't turn on Bricks' own Sticky header: that is a
  template setting, not part of a paste, and `reference/bricks/` holds no sample of it.
- Line 3, the guard: `overflow-x: hidden` on html and body makes the body a scroll container that never scrolls, and
  a sticky box then rides away with the page (cases D, G). `clip` makes no scroll container and still stops sideways
  scrolling. `html:root` and `html:root > body` outweigh a plain `html, body` rule wherever it is printed.

**Proven on Justin's own scan** (`<planner>/bdry-parts.ts`; `bdry-parts-base.json` against `bdry-parts-proto.json`):
his capture converted by a clean export of `02481763` and by the prototype, on the code route and with `--elementor`.
The header's root goes from 3 classes to 4 (`home__site-stay-jdkr`) and its notes gain the one line; with that class
taken off, the header paste hashes the same as main's; the page and footer pastes hash the same as main's.

**What Justin does in Bricks:** nothing new. He pastes `header.json` at the top of the page as before (or into a
Header template, Sticky header off), Accepts "Import classes", saves.

**Not in this job (named in HANDOFF):**
- The look after a scroll (Q4) and per-width staying (Q5).
- A bar that only starts staying after a scroll (a strip above it scrolls away first): the capture reads the page at
  its top and marks nothing, so it pastes in flow as today.
- A header the site's own CSS keeps with `position: sticky`, pasted into a Header template: it still needs Bricks'
  Sticky header there (in the page it stays by its own CSS).
- The Figma panel's website route keeps its "turn on Sticky header" line.
- Logged in on a phone, the header may rest one admin bar's height below the top while scrolled (WordPress lets its
  admin bar scroll away on small screens but keeps the height variable; from WordPress's own admin-bar CSS as I know
  it, not re-read here). Bricks' own sticky header and the Figma plugin's bar use the same `top`. Logged out, or in a
  private window, it is at the top: AC9 is checked that way on the phone.
- Safari before 16 doesn't know `clip`: there the header scrolls away only if Additional CSS holds the `hidden` rule.

### Source (complete; both pieces ran in the prototype)

New file `src/core/site/stay.ts`: copy `<planner>/proto/stay.ts` byte for byte (sha256 in `<planner>/proto/SHA256SUMS`).
Its exports: `stayClass(page): { name, css }`, `STAY_NOTE`, `headerStays(capture): boolean`.

`src/core/site/parts.ts`: apply `<planner>/proto/parts.patch` (`patch -p1 < …` in the copy; 3 hunks, 5 edits), then check
`npm run typecheck` (the prototype: 0 errors under both configs):
1. import `{ headerStays, STAY_NOTE, stayClass }` from `./stay.ts`;
2. before `classId`: `const stay = parts.some((x) => x.part === "header") && headerStays(capture) ? stayClass(page) : null;`
   and add `...(stay ? [stay.name] : [])` right after `RESET_NAME` in the `classIdsOf([...])` list;
3. after `fontsClass`: a `rootClasses(i)` helper giving the stay class (header part only) and then the fonts class;
4. `payloadOf(p, nameOf[i], settingsOf, classId, rootClasses(i))`;
5. `if (stay && parts[i].part === "header") notes.push(STAY_NOTE);` just before the version 1 note.

No other source file changes. `siteToBricks` (one section), the opened boxes, `tools/` and `src/web/` are untouched.

**One saved fixture's sums change by design.** `test/unit/site-slider-unchanged.test.ts` holds one sha256 per variant
of four saved fixture captures. One of them, `code-page`, is a site whose script keeps its header at the top, so its
eight sums (`test/fixtures/site-slider-base/site.code-page.sha256.json`) change; the other three sites' sums and all
seven hand-made captures' goldens stay (the prototype's whole unit suite: only those eight miss).
`<planner>/proto/remake-code-page-sums.ts` first proves, variant by variant, that with the class off the header's
class table and root and the note off its notes the pastes hash to the sums the file holds (main's), and only then
writes the file (`<planner>/proto/remake-code-page-sums.log`: all eight "the same as the file's sum"; the file it
wrote: `<planner>/proto/site.code-page.sha256.json`).

## Where this meets site-scroll-lock (running now)

- **Shared files:** `src/core/site/parts.ts` (the same two lines: the `classIdsOf([...])` name list and the root
  classes handed to `payloadOf`), and maybe `docs/HANDOFF.md`. site-scroll-lock also edits `src/core/site/classes.ts`
  and `src/core/site/convert.ts`, which this job doesn't touch. Its planner's prototype
  (`~/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/planner/prototype.patch`) adds a class
  `site-scroll-lock-<4>` on every part's root: `html, body { max-width: 100%; overflow-x: clip; }` plus
  `@supports not (overflow-x: clip) { html { overflow-x: hidden; } }`.
- **Whoever merges second** keeps both in `parts.ts`: the name list holds `RESET_NAME`, the lock's name, then the stay
  name; the root classes are the lock, then the stay class (header only), then the fonts class.
- **They meet:** the lock's rule alone keeps sticky working (case F) but loses to a `hidden` rule printed after it
  (case G); this job's guard outweighs both (case H). AC2's test draws the header with the lock's rule, with the
  Additional CSS rule, and with both, so it holds on either merge order. The guard repeats the lock's `clip` at a
  higher weight; the repeat is harmless.

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a scanned page whose header a script keeps at the top of the window, when its header, page and footer pastes are drawn together in the page as Bricks 2.3.9 and 2.4.2 print them at 1440, 768 and 390 (code route and `--elementor`) and the page is scrolled 600 px, then the header's bar is at the window's top before and after the scroll, nothing covers it, and the page starts right under the header.
  Test: `test/web/site-sticky-header.test.ts` › "a header a script keeps at the top stays at the top when pasted in the page"
- AC2 (proposed): Given the same pastes, when `html, body { max-width: 100%; overflow-x: hidden; }` is printed after the paste's CSS (alone, and after site-scroll-lock's rule), or site-scroll-lock's rule alone is, then the header still stays at the top after the scroll and the page doesn't move sideways.
  Test: `test/web/site-sticky-header.test.ts` › "the header stays with overflow-x hidden on html and body in the site's Additional CSS"
- AC3 (proposed): Given the same pastes with the header's elements inside Bricks' `<header id="brx-header">` (a Header template), when the page is scrolled 600 px, then the header stays at the top with Bricks' Sticky header off, with it on, and with that Additional CSS; with Sticky header off the page starts right under the header.
  Test: `test/web/site-sticky-header.test.ts` › "the header stays when pasted into a Header template"
- AC4 (proposed): Given a capture that marks a header bar as fixed to the window while the site's own code doesn't fix it, when it is converted (rich text, basic text, `--elementor`), then the header paste's root, and no other element, holds one class named `<page>__site-stay-<4 letters>` whose custom CSS is exactly the three rules above (no `revert`, no `!important`, no `display`), and the header's notes hold one line saying the header stays at the top.
  Test: `test/unit/site-sticky-header.test.ts` › "a header a script keeps at the top takes one class on its root, and one note"
- AC5 (proposed): Given that capture and the same capture without the mark, when both are converted, then the page and footer pastes and their notes are identical, and the header pastes are identical once that class is taken off the class table and the root, and that note off the notes.
  Test: `test/unit/site-sticky-header.test.ts` › "a kept header's pastes differ from the same page's unkept pastes by that class and that note alone"
- AC6 (proposed): Given a capture that marks nothing, and a capture whose marked bar the site's own code fixes (`position: fixed`), when each is converted, then no paste holds the class or the note and every paste equals the paste of the same capture without the mark.
  Test: `test/unit/site-sticky-header.test.ts` › "a header nothing keeps, and one the site's own CSS keeps, paste as before"
- AC7 (proposed): Given a fixture site whose own CSS fixes its header bars and one whose header is in the page's flow, when each is captured, pasted and drawn as in AC1, then neither paste holds the class or the note, the CSS-fixed header is at the top after the scroll as before, and the in-flow header scrolls away as on its site.
  Test: `test/web/site-sticky-header.test.ts` › "a header the site's own CSS keeps, and one that scrolls away on the site, paste as before"
- AC8 (proposed): Every saved golden holds: the hand-made captures and the saved fixture sites paste byte for byte as main did, except the saved `code-page` site (a header a script keeps), whose eight sums change by exactly that class and that note (`remake-code-page-sums.ts` proves it before writing them); `test/fixtures/site-no-revert-main.json` is unchanged in the diff; `npm run check` and `npm run corpus` pass, so Figma designs convert as before.
  Test: `test/unit/site-slider-unchanged.test.ts` › "pastes without an Elementor slider are byte-identical"
- AC9 (proposed) (live): Justin converts his bdryswi.com scan again with the new build, pastes `header.json`, `page.json` and `footer.json` into an emptied page on B-Dry staging and saves; on a desktop and on his phone (logged out or in a private window on the phone) the header stays at the top of the window while he scrolls the whole page, and the page doesn't move sideways.

## Tests and commands

Machine (WSL): `export PATH=/home/justin/.local/node-v22.23.3/bin:$PATH TMPDIR=$HOME/.cache/<short>/t1
CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
- Unit: `node --test test/unit/site-sticky-header.test.ts` (under a second).
- Chrome: `node --test test/web/site-sticky-header.test.ts` (about 3.5 minutes: three fixture captures, then 108 drawn
  pages). It loads only the repo's local fixture sites.
- Gates: `npm run check`, `npm run corpus`.
- Nobody loads bdryswi.com, B-Dry staging or any live site. `<planner>/repro.ts` shows how Justin's saved pastes are
  drawn with every address replaced and no host resolved, if a reviewer wants to see his own page.

## Touched files

- `src/core/site/stay.ts` (new, about 50 lines)
- `src/core/site/parts.ts` (5 small edits)
- `test/unit/site-sticky-header.test.ts` (new)
- `test/web/site-sticky-header.test.ts` (new)
- `test/fixtures/site-slider-base/site.code-page.sha256.json` (its eight sums, made again by the helper)
- `tools/site-sticky-header-sums.ts` (new: the helper, copied from `<planner>/proto/remake-code-page-sums.ts`, kept
  out of `test/fixtures` as `tools/site-no-revert-golden.ts` is, since unit tests import every module there)
- `docs/HANDOFF.md`, `docs/plans/2026-11-11-site-sticky-header.md` and its ledger

## Tasks (test first; one commit a task)

1. **Copy the plan** to `docs/plans/2026-11-11-site-sticky-header.md`; start the ledger in
   `.superpowers/sdd/2026-11-11-site-sticky-header/progress.md`; run `npm run corpus` once and note its tally.
2. **RED, unit.** Copy `<planner>/proto/site-sticky-header.unit.test.ts` to `test/unit/site-sticky-header.test.ts`
   (byte for byte; check its sha256). Run `node --test test/unit/site-sticky-header.test.ts`. Expected on base: 1 fail
   (the first test: "one class named home__site-stay-…", 0 found), 2 pass (they say nothing else changes, which is
   true before the fix too). The planner's run on a clean export of `02481763`: `# pass 2`, `# fail 1`.
3. **RED, Chrome.** Copy `<planner>/proto/site-sticky-header.web.test.ts` to `test/web/site-sticky-header.test.ts`.
   Run it (`CHROME_PATH` set; it captures three fixture sites, allow about 6 minutes; run it in the background or with a
   long timeout, never under a 2-minute cap). Expected on base: the first three tests fail ("the bar is at the
   window's top before (0) and after the scroll (-600)"), the fourth passes. The planner's run on a clean export of
   `02481763`: `# pass 1`, `# fail 3` (`<planner>/proto/web-test-base.log`).
4. **GREEN.** Add `src/core/site/stay.ts` and apply the `parts.ts` patch. Run both test files: all pass (the planner's
   prototype run: unit `# pass 3`; Chrome `# pass 4`, 195 s, `<planner>/proto/web-test.log`). Commit source and tests
   together.
5. **The saved fixture's sums.** With the fix in, `node --test test/unit/site-slider-unchanged.test.ts` fails naming
   exactly the eight `code-page …` variants (the planner's prototype run). Copy
   `<planner>/proto/remake-code-page-sums.ts` to `tools/site-sticky-header-sums.ts` and run
   `node tools/site-sticky-header-sums.ts "$PWD" --write`: it must print "the same as the file's sum" for all eight
   and write the file (if any line says NOT, stop: something else changed). The test then passes. Commit the helper
   and the sums together, saying in the message why they changed.
6. **Prove the tests can fail** (mutation-testing-discipline is not required: no guard; three quick mutants, each
   reverted): write line 1 with the class named once (the unit test's CSS assertion fails); drop line 2 (the Header
   template test fails); drop line 3 (the Additional CSS test fails); make `headerStays` return true for every capture
   (the "paste as before" tests fail).
7. **Regression family.** `npm run check`; `npm run corpus` (same tally as task 1); the tests that paste the same
   fixture: `node --test --test-concurrency=1 test/web/site-page-proof.test.ts test/web/site-cli.test.ts
   test/web/site-check-cli.test.ts` (the code-page header now holds one more class and one more note; if one of them
   pins the header's class count or its notes, update that pin and say so in the ledger). Run the unit suite with
   nothing else heavy running: `test/unit/site-upload-cli.test.ts` "AC11 a run stopped half-way …" kills a run
   half-way by the clock and failed once in the planner's run beside two Chrome runs (it passes alone, 9 of 9).
   The planner's prototype runs: those three Chrome files `# tests 21, # pass 20, # fail 0, # skipped 1` (the skip is
   named-only; `<planner>/proto/regress.log`); the whole unit suite `# tests 3701, # pass 3620, # skipped 79` with only
   the eight sums of task 5 and that clock test missing (`<planner>/proto/unit-suite.txt`). `npm run corpus` and the
   build were not run by the planner (the fix touches nothing the Figma converter imports). `git diff --stat main` must
   not list `test/fixtures/site-no-revert-main.json`.
8. **One screenshot per AC** into the evidence folder: for the three Chrome ACs and AC7 a shot at 1440 and 390 after
   the scroll (header at the top); for the unit ACs and AC8 a terminal capture of the run.
9. **Docs & records:** a HANDOFF section at the top ("A scanned header that stays at the top stays in the paste",
   site-sticky-header: the rule, the three CSS lines and why each, the ⭐ answers as not yet confirmed, the "Not in this
   job" list as follow-ups, where it meets site-scroll-lock, paste check AC9 with Justin's steps) and the ledger.
   Stop at `ready-for-review`.

**Mini stop rule:** if the fix needs more source than `stay.ts` and `parts.ts`, or a capture change, stop with `status:
stopped`, `stop_reason: escalate to full`.

## Justin's steps for the live check (the finisher prints these with the real build number)

1. In a terminal in `~/Documents/FigmaToBricksV2`:
   `npm run site -- ~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json ~/Downloads/bdry-test/paste --elementor --media ~/Downloads/bdry-test/paste/media.json`
   (no new scan and no upload: it converts the scan you already have).
2. On B-Dry staging, open the page with Bricks and delete what is on it.
3. Paste `header.json`, then `page.json`, then `footer.json` (Import classes: Accept each time). Save.
4. Bricks → Settings → Custom code → Regenerate code signatures. Purge the cache.
5. Open the page on a desktop and scroll to the bottom: the header stays at the top. Do the same on your phone in a
   private window; also try to drag the page sideways: it doesn't move.

## Risks and trade-offs

- `:has()` needs Chrome 105, Safari 15.4, Firefox 121 (only the Header template case uses it); `clip` needs Safari 16.
- The root becomes a stacking level of 100. A page part the old site itself draws above its header (B-Dry's page holds
  nine `z-index: 9999` rules) still paints above it, as on the old site, where the bar's level was 99.
- The existing 1:1 checks measure boxes from each part's root with the page at its top, where a sticky root is where a
  static one was; task 7 runs them.
- This is Mini-sized: one new 50-line module, five small edits in one file, one saved fixture's sums made again, no
  capture change, no design decision beyond the ⭐ answers. No reason to go Full.
