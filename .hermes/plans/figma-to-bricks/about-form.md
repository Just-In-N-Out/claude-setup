# about-form: the About Us page holds no form; what its paste draws wrong is a column that breaks in two on phones

Planner (Fable 5.2 high), Mini, 2026-11-16. Base: main `1d9a1f63` (Build 2026-11-15.7). Plan only: no source, test or commit changed.
Evidence (scripts, logs, pictures): `~/.hermes/plans/figma-to-bricks/evidence/about-form/planner/`.

## Questions (⭐ = taken under the standing auto-go)

- **Q1. Which thing did Justin mean by "the form on the right of the About Us page"?** His About Us scan holds no form at all (proof below), so nothing of forms-wpforms or the Bricks Form rule ran or failed.
  - ⭐ **A.** Build now the fix for the one thing the About paste draws differently from bdryswi.com: from 767 px down, "Who We Are" puts its paragraphs to the right of the heading, cut off at the screen's edge (563 px off; the home page's same kind of section stacks right). Ask Justin for a screenshot when he is back; if he meant the ☰ drawer (the only box that comes in from the right), that is offcanvas-wave's; if the photo on the right, photo-box-image's.
  - B. Build nothing until his screenshot.
- **Q2. How to fix the column break?**
  - ⭐ **A.** The fold still makes one element of the text widget (shallow tree, as a Bricks builder would), and the merged element no longer carries the body's "100% of my holder" height. In B-Dry's two scans 9 classes lose that one value and nothing else changes (About 4, home 5).
  - B. Refuse the fold as rule N does (its N4): every text widget of two or more paragraphs keeps an extra box. More boxes for the same drawing.

## Playback

Justin scanned bdryswi.com's home and About Us in the importer app (Build 2026-11-15.7), pasted both on B-Dry staging and said the form on the right of the About Us page looks different from the home page's. The home paste holds the WPForms form (form 1756, a Shortcode element in a pop-up); the About paste names no form.

## Finding 1: there is no form on the About Us page (not a bug of the form rules)

All read from his files, copied to `~/.cache/abf-pl/`; base's conversion of the About scan is byte for byte his `page.json` (`cmp` equal).

1. **The scan:** `web.forms: []`, `web.popups: []`; the capture file holds the text `wpforms` 0 times (home: 3207) and `1731` (the form's pop-up) only inside a box's numbers.
2. **The page as the site drew it at 1440** (`about-page-site-1440-capture.png`, the scan's own picture): "About Us", "Who We Are" (text left, a photo right), "BDry Is Now Proudly Owned…" (text left, a picture right). No form.
3. **The only `<form>` in the scan** is the accessibility toolbar's (plugin accessibility-onetap, `body/nav:0/…/form:0`, a floating box); it is in neither page's paste.
4. **Boxes a button opens:** About has 1 (`elementor-popup:27`, the ☰ drawer, coming in from the right, 4 header openers). Home has 5: 27, three small pop-ups and **1731, the form**, opened only by the home page's own link "Schedule Your Inspection Today!". The About page's buttons are plain links: "Get A Quote" and "Get Your Free Quote" go to `/contact-us/`, "Schedule A Free Inspection" to `#Leakage`.
5. **The pastes:** About's `header.json`, `page.json`, `footer.json` hold 0 Form elements, 0 Shortcode elements, 0 `wpforms`; home's `page.json` holds the one Shortcode.
6. **Why the WPForms pick took nothing:** it reads WPForms' own markup, a box with `wpforms-container` around `form.wpforms-form` (`src/core/site/wpform-read.ts:52`), walked by `wpformPicks` (`src/core/site/wpform.ts:65-72`) from `src/core/site/convert.ts:308-313`. The About scan has no such box, so there was nothing to take. Neither the capture nor the paste is at fault here.

What is "on the right" of the About paste, then: the photo beside "Who We Are" (0 px off at 1440), the ☰ drawer (offcanvas-wave's job), and on phones the paragraphs pushed to the right of their heading (Finding 2).

## Finding 2 (a bug): from 767 px down "Who We Are" breaks into two columns

`site:check --whole --elementor --bricks 2.4.2` on his About scan, offline (`about.log`): the page part is 0 px off at every width from 768 up and **563.42 px off at 767** (468 at 672, 373 at 577, 275 at 479, 203.58 at 390 and below): the heading shrinks to its words and the paragraphs start beside it and run off the screen (`about-who-we-are-390-main.png`). The home page part shows no such break (`home.log`: 0.67–1.58 px from 767 down but three widths at 41.6).

**Root cause, proven:**
- Elementor gives every widget's holder `height: 100%` (`.e-con > .elementor-widget > .elementor-widget-container`). On the site that reads the widget box, whose height is automatic, so it changes nothing.
- A text editor with two paragraphs folds its widget box and its holder into one element, the holder being the body. The fold rules count a wrapper's `height: 100%` as neutral (`src/core/site/elementor-fold.ts:83` `NEUTRAL_SIZE`) and never look at the body's sizes (`:209` `if (i === body) continue;`), and `merge` copies every declaration of the body onto the merged element (`:280-288`, `m[k] = v`). So the pasted Box carries `height: 100%` where the widget box had none (`about-us__who-we__box-…`: `_height: 100%`).
- That Box now sits where the widget box sat: an item of the column. The column is stretched by its row (so the browser treats its height as known) and Elementor makes it `flex-wrap: wrap` from 767 down. The 100% now reads the column's height, heading plus text no longer fit, and the wrapping column starts a second column.
- One change at a time in the drawn page (`column-probe2.log`): the text box at `height: auto` stacks as the site (text under the heading, 370 wide, 830 tall); the column at `nowrap` stacks too; the heading's inner box at `auto` changes nothing.
- The smallest page that shows it (`minimal.html`, `minimal-probe.log`): site markup stacks; the holder as the item with `height: 100%` goes beside its heading; without the height it stacks; with the column not stretched (`align-self: flex-start`, as B-Dry home's "Signs of A Basement Leak" column) it stacks, which is why home is fine.
- Rule N already refuses this for plain wrappers (`src/core/site/fold-boxes.ts:10-12`, N4: a percentage height "on the site against W's auto height, after a fold against W's parent's"); the Elementor fold has no such guard.

**The class of pages:** any Elementor page where a widget's body is its holder (a text editor of two or more paragraphs, a list, an html block) beside another widget in a column that is stretched or has a set height: on phones (Elementor's default wrap) it breaks into two columns; in a column with a set height or a taller neighbour the box takes the whole column and pushes what follows it down.

**The fix (general, one place):** in `merge`, a folded body's `height: 100%` or `max-height: 100%` is not copied: it only said "as tall as my holder", and the merged element is that holder now. The widget box's own height (copied just above, `:276`) stays the merged element's. A body's own px height, an element nothing folds into, and rule N's folds (its W's 100% is the widget box's side, kept) are untouched.

**Prototype (a scratch export of main, `prototype.diff`, 4 lines):**
- About, whole page, 34 widths (`proto-about.log`): the page part 0–0.49 px at every width (563.42 before); header and footer numbers per width the same as main's.
- Home, page part, 45 widths (`proto-home.log`): every width's number equal to main's.
- Pastes (`paste-delta.txt`): About 4 classes (header 2, page 1, footer 1) and home 5 (2, 2, 1) differ, each only by a 100% height gone; element and class counts, `notes.txt` and `structure.txt` the same.
- Unit suite, 4054 tests (`base-unit.log`, `proto-unit.log`): the same 6 failures on the clean export of main and on the prototype (all from the export having no git and no corpus files); "pastes without an Elementor slider are byte-identical" and the no-revert pin pass with no golden made again.
- The planned unit test (`ac1-test.ts.txt`): fails on main with `'100%'` where `undefined` is expected (`ac1-base.log`), passes on the prototype (`ac1-proto.log`).

## Acceptance criteria (all proposed: the report gave none)

- AC1 (proposed): Given a widget whose folded body declares `height: 100%` or `max-height: 100%` under a widget box with no height of its own, the merged element carries neither at any range; a widget box's own height (100% or px), a body's own px height and an element nothing folds into keep theirs. Test: `test/unit/site-elementor-fold.test.ts` "a body as tall as its holder folds without that height: the merged element is the holder".
- AC2 (proposed): Given a generic Elementor page whose row stretches a column that wraps on phones and holds a heading and a two-paragraph text editor, the paste drawn as Bricks draws it has every element within 2 px of the site at every width the capture read and at 300, the text under its heading; on main the text is more than 100 px off on phones. Test: `test/web/site-elementor-holder-height.test.ts` "a text editor as tall as its holder stays under its heading in a column that wraps on phones".
- AC3 (proposed): Pastes with no folded body that is 100% of its holder are byte for byte main's: the saved pins of the fixture sites and hand-made captures pass with no golden made again. Test: `test/unit/site-slider-unchanged.test.ts` "pastes without an Elementor slider are byte-identical".
- AC4 (proposed): On B-Dry's two scans (offline, named-only), against a clean export of main: About's page part is within 2 px at each of its 34 widths; every other part's number per width (About header and footer, home page) equals main's; exactly 4 classes of About's pastes and 5 of home's differ, each only by a 100% height or max-height gone; element counts, class counts, notes and structure equal. Test: `test/web/site-holder-height-bdry.test.ts` "B-Dry's About page stacks on phones and only holder heights leave the two pastes".
- AC5 (live): Justin remakes the About Us pastes from his saved scan (the importer app's "Make pastes again" or `npm run site`), pastes About Us on B-Dry staging and at phone width "Who We Are" shows its paragraphs under the heading at full width, as on bdryswi.com; he also says which thing "the form on the right" was. Paste check **3ez**.

## Tasks (builder: test first, one commit per task, each green)

1. **Red for the unit rule.** Append the test in `evidence/about-form/planner/ac1-test.ts.txt` to `test/unit/site-elementor-fold.test.ts` and add `import { merge } from "../../src/core/site/elementor-fold.ts";` after the fixture import. Run `node --test test/unit/site-elementor-fold.test.ts`: 15 pass, 1 fails with `'100%'` where `undefined` is expected. Any other failure: stop.
2. **The fix** in `src/core/site/elementor-fold.ts` (apply `apply-prototype.mjs`'s two edits by hand): above `const AXIS = { x:` add `const HOLDER_FILL = /^(max-)?height$/;` with its comment; in `merge`, right after `if (MARGIN.test(k) || (ITEM.test(k) && !parentFlex) || sized.includes(k)) continue;` add `if (body > 0 && HOLDER_FILL.test(k) && v.trim() === "100%") continue;` with the comment of `prototype.diff`. Same command: 16 pass. Then `npm run check`.
3. **The drawn fixture.** New generic site `test/fixtures/web/sites/elementor-holder-height/` (`index.html`, `style.css`), modelled on `elementor-stretch` (same base rules, `.elementor-widget-container { height: 100%; }`): one boxed parent container whose inner is a row from 768 up and `flex-wrap: wrap` below; two child containers of `width: 50%` (100% below 768), each `display: flex; flex-direction: column; gap: 20px` and `flex-wrap: wrap` below 768, with no `align-self` (the row stretches them); the first holds a heading widget and a text-editor widget with two `<p>`; the second holds only a background colour and `min-height: 250px`. New `test/web/site-elementor-holder-height.test.ts`, the harness of `test/web/site-elementor-stretch.test.ts` with the fixture's name (launchOffline, offlineFetch, captureFixture, the Elementor step on, compare every element at every width read and at 300, tolerance 2). Prove red: `git stash` is forbidden, so `git checkout HEAD~1 -- src/core/site/elementor-fold.ts`, run the test (the text more than 100 px off at the phone widths), then `git checkout HEAD -- src/core/site/elementor-fold.ts` (green). **Stop** and report if the fixture is not red on the old source: its four load-bearing parts are a stretched column, the column wrapping at that width, two items in it, and a body that is its widget's holder.
4. **The B-Dry receipt test** `test/web/site-holder-height-bdry.test.ts`, skipped unless `F2B_ABOUT_CAPTURE`, `F2B_HOME_CAPTURE` and `F2B_BASE_TREE` (a `git archive` export of main `1d9a1f63` with `node_modules` linked) are set, its output folder from `F2B_HOLDER_OUT` (never a fixed folder). It converts both scans in both trees (`siteParts`, the Elementor step on) and asserts AC4's counts with the comparison of `paste-delta.mjs`; it runs `tools/site-check.ts <capture> --whole|--part page --elementor --bricks 2.4.2 --no-shots` in both trees and compares the printed per-width numbers. Chrome through the tool's own offline rule; run it under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` (a runner script). The scans: copies of `~/Downloads/bdryswi-com-about-us/` and `~/Downloads/bdryswi-com-home/` (read-only there).
5. **Suites.** `npm run check`, `npm run corpus` (Figma side: expected unchanged), and `node --test --test-concurrency=1` on `test/web/site-elementor-*.test.ts` and any other web test that pastes with the Elementor step. The `falsified:` controls of `test/web/site-elementor-proof.test.ts` are part of that run (the project skill, testing-pitfalls: run them after a merge rule changes). A sum that moves is expected only where a fixture's folded body is 100% of its holder: make it again on this tree and name each in the ledger; anything else moving is a stop.
6. **Docs & records.** HANDOFF section "about-form" (no form on About; the holder-height rule; the three things on the right; paste check 3ez; follow-ups below), the ledger, and for the finisher one Status line in CLAUDE.md.

## Touched files

`src/core/site/elementor-fold.ts` (the only source file), `test/unit/site-elementor-fold.test.ts`, `test/web/site-elementor-holder-height.test.ts` (new), `test/fixtures/web/sites/elementor-holder-height/` (new), `test/web/site-holder-height-bdry.test.ts` (new, named-only), `docs/HANDOFF.md`, the ledger.

**Shared with jobs in flight:** `src/core/site/elementor-fold.ts` and `test/unit/site-elementor-fold.test.ts` with fewer-kept-boxes (paused); nothing with photo-box-image (`photo-box.ts`, `convert.ts` are not touched); offcanvas-wave, short-class-names and clean-values share no file, but 9 classes of the two B-Dry scans (2 of each header paste among them) get a new id as their settings lose one value, so B-Dry sums those jobs made before this merge move by those classes.

## Risks and what this does not cover

- A body with a percentage height other than 100% under an automatic widget box still lands on the merged element (not seen on B-Dry; follow-up).
- The web suite beyond the fold tests was not run on the prototype; task 5 runs it.
- If Justin meant the drawer or the photo, AC5's second half says so and this job still fixed a real phone defect of his page.

## Found on the way (not this job; for the main session)

- **The ☰ drawer differs between the two pastes** (`drawer-diff.txt`): the About scan read the drawer's sliding box without `overflow: hidden` (home's has it: the site's own stylesheets differ per page), and About was pasted without the upload, so its drawer photo is the old site's address, home's the library's. For offcanvas-wave.
- **Footer 20 px off at every width on both pages on main** (`about.log`: `footer:0/div:9/div:1/div:1/div:0/ul:0/li:1` 20.01 px, `footer:0/div:8` 20 px), unchanged by the prototype. Not looked into.
- **Home page part on main** (`home.log`): 2.26 px at most widths, 6.53–6.93 at 1025–1366, 42.91 at 1008, 41.6 at 480, 412 and 403, one element missing at 878. Unchanged by the prototype. Not looked into.
- The drawing asked for of "both forms" was not made: About has none; home's is inside a pop-up `site:check` draws closed.

## Report contract

Builder stops at `ready-for-review` with the head, the ledger, AC4's log folder, one picture per AC (About at 390 before and after for AC2 and AC4; terminal captures for AC1 and AC3), `found_else` and `skill_lessons`.
