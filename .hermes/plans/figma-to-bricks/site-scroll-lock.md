# site-scroll-lock: every website-importer paste locks sideways scrolling (Mini)

Planner: Fable 5.2 high, 2026-11-11. Base: `main` at Build 2026-11-11.3, `02481763`. The builder copies this file to
`docs/plans/2026-11-11-site-scroll-lock.md`. Planner evidence (proofs, the test files, the patches):
`~/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/planner/` (called `<P>` below).

## Playback

1. Justin wants every page the website importer pastes to stop moving sideways, on phones above all, without adding
   his rule by hand in WordPress → Appearance → Additional CSS each time.
2. His rule is `html, body { max-width: 100%; overflow-x: hidden; }`. He chose **"Use clip instead"**: the paste locks
   with `overflow-x: clip`, because `hidden` can stop a sticky header from sticking.
3. So: every paste `npm run site`, `site:upload` and `site:import` write carries that lock once, proven in the test
   renderer at 390 with a too-wide element, a Bricks sticky header and a plain sticky bar.

## Questions (⭐ = the answer the builder takes under the standing auto-go)

- **Q1. Do the Figma plugin's own pastes get the lock too?** ("and all" could mean that.)
  - ⭐ **A. No: the website importer's pastes only.** Figma pastes stay byte for byte as before. Why: he asked for
    "the website importer that scans"; Figma pastes are already checked for sideways scroll (the corpus lint fails on
    it), and a lock there would hide such a bug instead of showing it. It is a small follow-up job if he wants it.
  - B. Yes, Figma pastes too (its own job: the Figma route has no page-wide class yet).
  - Note: a capture opened in the **Figma panel** ("website route") is converted by the Figma converter
    (`src/plugin/capture.ts:1-4`: "runs the same resultOf() a selection runs"), so it writes no site paste of its own and
    follows this answer: with A it stays as before.
- **Q2. Old browsers that don't know `clip`** (Safari before 16.0, September 2022; every current browser knows it):
  - ⭐ **A. They get his own `hidden` rule** (what he asked for as the fallback): locked sideways, but on those old
    phones a `position: sticky` header can scroll away, exactly as with his Additional CSS today. Browsers that know
    `clip` never apply it (`@supports not (overflow-x: clip)`), so sticky is safe everywhere else.
  - B. Lock only the window there (`hidden` on html alone): sticky keeps working, but a finger can still drag the page
    sideways (proven in Chrome's phone mode: the page moved 365–397px; `<P>/forms.txt` "rejected fallback").
  - C. Nothing for old browsers.
- **Q3. The class's name.** ⭐ **A. `site-scroll-lock-<4 letters>`**, one of the plugin's own names like
  `site-reset-<4>` (named after its rules, the same on every page, so a site's pages share one copy and Bricks never
  asks to import it twice). B. Under the page's name (`home__site-scroll-lock`): one more class per pasted page.

## What I found (file:line)

- **Where page-wide CSS already lives in a site paste:** the reset class. `src/core/site/classes.ts:27-29` makes
  `site-reset-<4>` (`versioned`, named after its rules); `src/core/site/convert.ts:414-431` (`payloadOf`) writes it first
  in the class list and first on the paste's root element, then `rootClasses` (today only the font class, `site-fonts`,
  whose custom CSS is bare `@font-face` rules: `src/core/site/parts.ts:124,128`).
- **Every code-route paste goes through `payloadOf`:** the three parts (`parts.ts:128`, used by `npm run site`,
  `tools/lib/site-upload/flow.ts:51` for `site:upload` and `site:import`, `site:check`, `site:live`), one section
  (`convert.ts:449`, `--section`/`--path`), and an opened box's root (`open-paste.ts:43`, which passes no
  `rootClasses`).
- **Bricks prints a class's custom CSS as written** (`reference/bricks/README.md:223`, "A class's custom CSS stays as
  written"), so a rule that names no class survives. Read on B-Dry staging's saved page (Bricks 2.4.2,
  `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/staging/css/inline-2.css`): the reset's rule is printed
  exactly as the paste wrote it, and so are the font class's bare `@font-face` rules and classes' `@keyframes`. The
  renderer does the same (`test/browser/render-order.ts:40-41`). `%root%` isn't needed and isn't used.
- **One copy per page:** the three parts share one class table (`parts.ts:123`), so the lock has the same id, name and
  settings in header.json, page.json and footer.json; Bricks keeps one class and never asks "Import classes" about it.
  On that staging page three roots carried the reset and its rule is printed **once**. Pasted into three places (Header
  template, page, Footer template) Bricks may print it up to three times: harmless, it is the same rule with the same
  values. `tools/lib/site-whole.ts:6-10` (the whole-page paste) keeps each class once by id.
- **Bricks' sticky header** (`reference/bricks/frontend-2.4.2/frontend-light-layer.min.css`, README:204-208):
  `#brx-header.brx-sticky{position:fixed…}` and, with "sticky on scroll", `#brx-header.brx-sticky.on-scroll{position:sticky}`.
- **The panel's website route and Figma designs** never touch `src/core/site/` (only `src/ui/capture.ts:7` imports one
  line-maker from it), so they can't change.

## The proof: clip, not hidden (`<P>/forms.ts`, `<P>/forms.txt`, `<P>/forms.json`)

The repo's renderer (`renderPage`, Bricks 2.4.2's own front-end CSS, the hostile Theme Style, Chrome over CDP) at
390×800, a paste under a Bricks header, holding a plain `position: sticky` bar, an 800px-wide element in the flow and
(second run) a 700px one placed absolutely at 300px. Each form was a class's custom CSS, as the paste will carry it.
Sideways attempts: a script's `scrollTo(300, 0)`, then a finger's swipe (phone mode) or a wheel (mouse). Then 1000px down.

| Form | Page width | Moves sideways | Sticky Bricks header 1000px down | Sticky bar |
|---|---|---|---|---|
| none (today's paste) | 800–1001 | yes (wheel 300px, finger 384–396px) | at top | sticks |
| `hidden` on html, body (his Additional CSS) | 390 | no | **rode off (−1000)**; the fixed form stays | **rode off (−940)** |
| `clip` on html, body | 390 | no | at top | sticks |
| **planned: `clip` + `@supports not` → `hidden`** | 390 | no | at top | sticks |
| `clip` on html only, or on body only | 800–1001 | finger still moves it 373–393px | at top | sticks |
| `hidden` on html only (Q2 B) | 800–1001 | finger still moves it 365–397px | at top | sticks |

So `hidden` on both makes the body a scroll container (`overflow-y` computes to `auto`) and both sticky ones ride off;
`clip` on both locks the page and keeps them; and it must be on **both** html and body. In Chrome the planned rule
computes `clip`/`clip` (the `@supports not` block isn't applied). Not provable here: a real browser without `clip`.

## The fix

One new class, the plugin's own, named after its rules: **`site-scroll-lock-<4>`**, custom CSS exactly

```
html, body { max-width: 100%; overflow-x: clip; }
@supports not (overflow-x: clip) { html, body { overflow-x: hidden; } }
```

second in every paste's class list (right after the reset) and second on the root element of each part's paste and of
a one-section paste; never on another element, never on an opened box's root. Three source files, as in
`<P>/02-source.patch` (sha256 `34e293c6…87a65`; applies to the base with `git apply -p1`):

- `src/core/site/classes.ts`, after `RESET_CSS` (line 29):
  ```ts
  const LOCK = versioned("site-scroll-lock", () => "html, body { max-width: 100%; overflow-x: clip; }\n@supports not (overflow-x: clip) { html, body { overflow-x: hidden; } }");
  export const LOCK_NAME = LOCK.name;
  export const LOCK_CSS = LOCK.css;
  ```
  with the comment in the patch (why clip, why both, the fallback, where it sits).
- `src/core/site/convert.ts`: import `LOCK_CSS, LOCK_NAME`; above `siteToBricks` add
  `export const lockClass = (classId: Map<string, string>): GlobalClass => ({ id: classId.get(LOCK_NAME)!, name: LOCK_NAME, settings: { _cssCustom: LOCK_CSS } });`;
  in `siteToBricks` name it in `classIdsOf([RESET_NAME, LOCK_NAME, …])` and pass `[lockClass(classId)]` as `payloadOf`'s
  `rootClasses`.
- `src/core/site/parts.ts`: import `LOCK_NAME` and `lockClass`; `classIdsOf([RESET_NAME, LOCK_NAME, fontsName, …])`;
  `payloadOf(…, [lockClass(classId), ...(fontsFor[i] ? [fontsClass] : [])])`.

`payloadOf` itself doesn't change: an opened box's root (`open-paste.ts:43`) passes no `rootClasses`, so it gets no lock.
No change to the capture, the tools, the panel, the Figma converter or `test/browser/render.ts`.

**What the lock does not do (for Justin, one line):** it hides what sticks out past the right edge, it doesn't fix the
element that is too wide, so that part is cut off instead of scrolling. `site:check` still names such an element when
it is wider than on the old site (it compares each element's box, and the lock changes no box: the 800px element still
measures 800px in the test). Nothing in the importer reported "the page scrolls sideways" before, and nothing does now.

**His Additional CSS rule must come out** once the paste carries the lock: left in, its `hidden` can still win over the
paste's `clip` (same weight, whichever prints later) and the sticky header would ride off. It is step 1 of the live check.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): every website paste (header, page, footer and one section alone; the code route and `--elementor`; rich and basic text; both picture modes) holds exactly one `site-scroll-lock-<4>` class whose custom CSS is exactly the rule above, second in its class list right after the reset, listed second on its root element and on no other element nor an opened box's root; the three parts hold it with one id, the whole-page paste holds it once, and a site holding one part's classes is never asked about it. Test: `every website paste carries the sideways lock once, on its root` (`test/unit/site-scroll-lock.test.ts`).
- AC2 (proposed): at 390 in the test renderer (Bricks 2.4.2's CSS) the whole-page paste holding an 800px element in the flow and a 700px one placed absolutely past the right edge has nothing to scroll sideways (`scrollWidth` 390), and after a script's sideways scroll, a finger's swipe (touch screen) and a wheel (mouse) `scrollX`, the body's `scrollLeft` and `visualViewport.pageLeft` are all 0; the same paste with the lock class taken out moves at least 100px; the 800px element still measures 800px. Test: `at 390 a paste wider than the screen never moves sideways` (`test/web/site-scroll-lock.test.ts`).
- AC3 (proposed): 1000px down that page, Bricks' sticky header (both forms: `brx-sticky`, and `brx-sticky on-scroll`) and the site's own `position: sticky` header are at the window's top (top 0); with his `hidden` rule in the lock's place Bricks' on-scroll header and the site's sticky header ride off. Test: `a sticky header and a sticky bar still stick under the lock` (`test/web/site-scroll-lock.test.ts`).
- AC4 (proposed): Figma designs (the repo's four real files) and the Figma panel's website route (the hand-made captures, every part, both picture modes) paste byte for byte as the base's, and hold no lock. Test: `Figma designs and the panel's website route paste byte for byte as the base tree's` (`test/unit/site-scroll-lock-base.test.ts`, named only: `F2B_BASE_TREE`).
- AC5 (proposed): a website paste differs from the base's only by the lock: with the lock class and its id on the root taken out, every paste of the hand-made and saved fixture captures (the whole page in all eight variants, every section alone on both routes; 198 pastes) is byte for byte the base's. Test: `a website paste without its lock is byte for byte the base tree's` (`test/unit/site-scroll-lock-base.test.ts`, named only: `F2B_BASE_TREE`).
- AC6 (proposed) (live): Justin takes his rule out of Additional CSS, writes the pastes again with this build, re-pastes on B-Dry staging, and on his phone the page doesn't move sideways and the header still sticks when he scrolls down. Paste check **3dz**. Test: `Justin's own check on his phone (paste check 3dz)`.

How each was proven on the prototype (base tree `02481763` + `<P>/02-source.patch` + the tests):
AC1 green (`<P>/unit-green.txt`), red on the base with "one lock class (none)" (`<P>/unit-red.txt`); AC2 and AC3 green
(`<P>/web-green.txt`), red on the base with "the whole page holds one lock class" (`<P>/web-red.txt`); AC4 and AC5
green against the base tree (`<P>/base-green.txt`, "198 pastes compared"); base against itself, AC4 passes (it is a
"nothing changed" check) and AC5 fails with "one lock" (`<P>/base-on-base.txt`).

The live check's steps (for the hand-over, one action each):
1. WordPress → Appearance → Customize → Additional CSS: delete the `html, body { max-width: 100%; overflow-x: hidden; }` lines, Publish.
2. In the terminal: `npm run site -- <your bdryswi capture> <outDir> --elementor` (or `npm run site:import …` as usual).
3. Paste header.json, page.json and footer.json on B-Dry staging as before; Save.
4. On your phone, open the page: drag it left and right (it must not move), then scroll down (the header must stay).

## Touched files

Source (3): `src/core/site/classes.ts`, `src/core/site/convert.ts`, `src/core/site/parts.ts`.

New tests (4 files, written and proven by the planner; copy them as they are, sha256 in `<P>/sha256.txt`):
- `<P>/tests/scroll-lock.ts` → `test/web/lib/scroll-lock.ts` (`isLock`, `unlocked`, `unlockedParts`: a paste without its lock)
- `<P>/tests/site-scroll-lock.test.ts` → `test/unit/site-scroll-lock.test.ts` (AC1, and the rule's text)
- `<P>/tests/site-scroll-lock.web.test.ts` → `test/web/site-scroll-lock.test.ts` (AC2, AC3)
- `<P>/tests/site-scroll-lock-base.test.ts` → `test/unit/site-scroll-lock-base.test.ts` (AC4, AC5; skipped unless `F2B_BASE_TREE` is set)

Existing tests that pin a paste's classes (14 unit tests fail with the source change alone; all pass with
`<P>/03-pins.patch`, sha256 `861e6a61…fd8354`, `git apply -p1`; full list with the failing test names:
`<P>/pins.md`):
- `test/web/lib/class-names.ts`: `PLUGIN` also allows `scroll-lock-[a-z]{4}` (fixes 5 tests in `site-class-names`,
  `site-elementor-names`, `site-motion`).
- `test/unit/site-css.test.ts`, `test/unit/site-elementor-widgets.test.ts`, `test/unit/site-text.test.ts`: the lock is
  the second class; the shared classes follow it.
- `test/unit/site-motion-old.test.ts`, `test/unit/site-opens-old.test.ts`, `test/unit/site-slider-unchanged.test.ts`,
  `test/unit/site-text.test.ts` (the proof's golden): compare the paste **without its lock** (`unlocked`) with the old
  golden, so they still say "as before, but for the lock".
- `test/fixtures/site-no-revert-main.json`: made again on this tree with `node tools/site-no-revert-golden.ts .`
  (CLAUDE.md's rule for a job that changes site pastes on purpose); `test/unit/site-no-revert.test.ts` then passes
  unchanged (proven on the prototype).
- Named-only story pins of older jobs (`F2B_STORY_PINS`, `F2B_SITE_MOTION_OLD`, `F2B_SITE_MENU_BDRY`,
  `F2B_UNCHANGED_SUMS`, `F2B_INLINE_OWN_CAPTURES`) are left as they are: they don't run by default.

## Tasks (one commit each, on the story's branch; test first)

0. Start: copy this plan to `docs/plans/2026-11-11-site-scroll-lock.md`, open the ledger
   (`.superpowers/sdd/2026-11-11-site-scroll-lock/progress.md`), run `npm run check` and `npm run corpus` on the
   untouched branch. Base tally (planner, base tree): unit suite 3698 tests, 3619 pass, 0 fail, 79 skipped.
1. RED: add the four new test files (paths above). Run
   `node --test test/unit/site-scroll-lock.test.ts` → fails with "one lock class (none)";
   `node --test --test-concurrency=1 test/web/site-scroll-lock.test.ts` → fails with "the whole page holds one lock class".
   Commit.
2. GREEN: the source change (`<P>/02-source.patch` or the lines above). The same two commands pass (2 and 2);
   `npm run typecheck` passes. Commit.
3. Pins: apply `<P>/03-pins.patch`, then `node tools/site-no-revert-golden.ts .` (after the commit of task 2, so the
   file names that commit). `npm run check` passes: planner's prototype tally 3702 tests, 3621 pass, 0 fail, 81
   skipped (`<P>/unit-proto-updated.tap`). Commit.
4. Base receipts for AC4 and AC5: a base tree (`git archive <merge-base with main> | tar -x -C <short folder>`,
   `ln -s <worktree>/node_modules <short folder>/node_modules`), then
   `F2B_BASE_TREE=<short folder> node --test test/unit/site-scroll-lock-base.test.ts` → 2 pass, "198 pastes compared".
5. Gates: `npm run check`, `npm run corpus`, `npm run test:web`, `npm run test:browser`. One screenshot per AC in the
   evidence folder: for AC2 the page at 390 after the swipe without and with the lock, for AC3 1000px down with the
   lock and with `hidden` (a throwaway script using the web test's `made()` and `open()` with `page.screenshot()`);
   a terminal capture of the run for AC1, AC4 and AC5. If a web or browser test outside this plan's list fails only
   because the paste now holds the lock, update it the same way (the lock is second; or compare `unlocked`) and name
   it in the ledger; anything else is a stop.
6. Docs & records: a `docs/HANDOFF.md` section "A website paste never scrolls sideways (site-scroll-lock, website
   importer; paste check 3dz owed)" (what changed in plain words, the clip-not-hidden proof table, Q1–Q3 as "not yet
   confirmed", what the lock doesn't do, "take the rule out of Additional CSS", the limits below), check **3dz** in
   "End-of-run check list", and the ledger; for the finisher's CLAUDE.md lines: the Status line, `site-scroll-lock-<4>`
   added to the plugin's own class names in "Code-method class names…", and one standing rule ("a website paste locks
   sideways scroll with `clip` on html and body, never `hidden`: hidden on both makes the body a scroll container and
   sticky headers ride off").

Mini escalation: if the fix needs more than these 3 source files or a design decision, stop with
`status: stopped`, `stop_reason: escalate to full`.

## Limits and risks (for HANDOFF "Deferred")

- Content past the right edge is cut off, not fixed (by design; see above).
- Browsers without `clip` (Safari before 16) get `hidden`: locked, but a sticky header can scroll away there (Q2).
  Not proven on such a browser.
- A real phone isn't Chrome's phone mode: AC6 is the proof on his phone.
- Printed once per page is read from one staging page holding all three parts; in three separate places Bricks may
  print the rule more than once (harmless).
- The lock is page-wide: it also applies to whatever else is on a page holding a pasted part (that is the request).
- The planner ran the site web tests on the prototype only partly (see the report); the builder's task 5 runs them all.

## Machine notes for the agents

WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; a short `TMPDIR` (about 24 characters, e.g.
`~/.cache/ssl-<role>/t`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start
by its own profile's PIDs, never `pkill -f`. Chrome doesn't always answer a sideways `mouseWheel` nothing takes: race it
with a timer (the web test does). A command that dies with SIGTERM/143/137/"Killed" may be an earlyoom kill: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Never load
bdryswi.com, B-Dry staging or any live site; never run `site:upload`/`site:import` against a real site.
