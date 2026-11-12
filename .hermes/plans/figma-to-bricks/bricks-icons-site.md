# bricks-icons-site: a scanned site's drawn icons become Bricks' Icon element (the website importer half of bricks-icons)

Planner: bricks-icons, plan amendment 1 (Fable 5.2, high), 2026-11-12. This is Milestone 2 of the job bricks-icons, split
into its own job so that Milestone 1 (the Figma plugin) can be accepted and merged first. Nothing here is new scope:
the rule, the criteria, the tasks and the ⭐ answers are the ones Justin approved on 2026-11-11 ("go with
recommended") in `~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md`, whose text before the split
is `git show c78fa0cf:docs/plans/2026-11-11-bricks-icons.md` (sha256 `fc7b50c5…0356a1`). What this plan adds is marked
**(new here)**: what Milestone 1's fix round settled, two facts read in Bricks' own code, and what moved on `main`.
**Pipeline: Full recommended**, as approved for the whole job (it changes the one uploader that writes to WordPress).
Website importer rules apply (repo CLAUDE.md: one real-bug review, edge cases to follow-ups).
**Base: `main` once three build commits are on it:** site-no-div, site-shared-styles and bricks-icons (Milestone 1).
Today (2026-11-12) `main` is `4f8b6116`, Build 2026-11-11.10; none of the three is merged. media-clickable (Build
2026-11-11.4) and media-avif-alt (2026-11-11.10) are merged. Every importer file:line below is from
`site-native-structure-stack6` (`2a38027f`), where the proof ran: Task 1 re-reads each on the real base.
Evidence of the plan (scripts, outputs, Bricks' source): `~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/planner/`
(called `<planner>` below; `README.md` there lists every file). This job's own evidence:
`~/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/`.
Plan copy for the repo: `docs/plans/2026-11-12-bricks-icons-site.md` (the builder copies this file there in Task 0).

## Playback

1. In your own Bricks pages an icon is Bricks' **Icon** element. Today the website importer pastes a site's drawn
   icon (an `<svg>`) as a Code element labelled "SVG".
2. You want the importer to paste those icons as Icon elements, so the Structure panel reads "Icon" and you can
   recolour and resize one in Bricks, for every scanned site. The Figma plugin's half is the job bricks-icons.
3. Each icon must still look exactly as on the old site, at every width. Where that can't be proven, or where its file
   isn't in your media library, the icon stays as it is today.

## Questions: none new. The answers already given (⭐, Justin's "go with recommended", not yet confirmed)

The numbers are bricks-icons' own, so HANDOFF and the audit keep pointing at the same questions.

- **Q1. Which Bricks icon.** ⭐ **A: the Icon element showing the drawing as an SVG file from the media library.** It is
  how you build it yourself and it shows the drawing itself, so it is 1:1. Not Bricks' icon fonts (a site's own icon
  font is another font: B-Dry's glyphs are ElementsKit's), not Bricks' SVG element (no sample).
- **Q4. Which site icons.** ⭐ **A: the site's own `<svg>` drawings, and only with `--svg`** (the files must go up as
  SVG; WordPress takes SVG only once Bricks → Settings → SVG uploads or a plugin allows it). Icons a site draws with an
  icon font (`<i class="…">`) stay Blocks labelled "Icon" with the site's own font, as site-no-div makes them. B: swap
  a site's Font Awesome glyph for Bricks' own Font Awesome: only 1:1 when the versions match; a later job.
- **Q5. Where a site icon's look lives.** ⭐ **A: on its class, like every importer element** (colour, size, hover). The
  Icon's own Fill and Size boxes stay empty in Bricks; typing a colour there still recolours it. B: move the colour
  into the Icon's own control (breaks "one class per look", which site-shared-styles builds on).
- **Q6. File names in your media library.** ⭐ **A: `icon-<8 letters>.svg`**, the letters from the drawing itself, so
  the same drawing on two pages is one file. B: named after the words next to it.
- **Q7. Hover.** ⭐ **A: unchanged.** A site icon's hover colour stays on its class. B: hover as the Icon's own `:hover`
  colour control: no sample shows Bricks keeps it; later.
- **Q8. Order.** ⭐ **A:** the importer half builds after site-no-div and site-shared-styles merge. Since amendment 1 of
  bricks-icons it is this job, with its own plan and acceptance.

## What this job stands on

### Bricks' Icon element (proven for bricks-icons, not from memory)

| Source | What it shows |
|---|---|
| `reference/bricks/icon-svg.json` and README "Icon" (in the repo once Milestone 1 merges; cut from Justin's `staff-card.json`, Bricks 2.3.12) | `{"name":"icon","children":[],"settings":{"icon":{"library":"svg","svg":{"id":414,"filename":"right-arrow-2.svg","url":"https://…/right-arrow-2.svg"},"height":"26","width":"26"}}}` |
| Bricks 2.2 `includes/elements/base.php` L4135-4238 `render_icon` (`<planner>/bricks-2.2/base.php`) | an SVG icon prints only when `icon.svg.id` is set: it reads the media file, refuses a file from another host whose name differs, and prints the file's own `<svg>`. No id: nothing prints |
| the same file, L4245-4281 `render_svg` **(new here)** | everything before the first `<svg ` is dropped; the first `id="…"` text inside the root tag is removed (so `data-id="x"` would lose its value: see rule 1); the element's `id` is written at a fixed place after `<svg `; the element's classes are written **first inside the root's own `class="…"` when it has one**, else as a new attribute. A root's own classes therefore stay, after Bricks' |
| Bricks 2.2 `includes/assets.php` L1783-1786, L2596-2640 | the icon control's `width`, `height`, `strokeWidth`, `stroke`, `fill` print as CSS on the element's root (`#brxe-<id>`) |
| `reference/bricks/frontend-2.3.9/` and `frontend-2.4.2/frontend-light-layer.min.css` | `svg.fill *{fill:inherit}`, `svg.stroke *{stroke:inherit}`, `svg:not([width]){min-width:1em}`, `svg:not([height]){min-height:1em}`, `[class*=brxe-]{max-width:100%}` |
| Live darksalmon 2.3.9 page CSS (`evidence/site-slider/planner/bricks-assets/ds-post-68.min.css`) and Bricks 2.2 `icon.min.css` | `.brxe-icon{font-size:60px}svg.brxe-icon{font-size:inherit}` in `@layer bricks` |

What only a live paste can confirm (the live criterion): that 2.3.9 and 2.4.2 print an SVG Icon as 2.2's code does.

### What bricks-icons (Milestone 1) leaves on `main` for this job

Read on its head `c78fa0cf`; Task 1 re-reads each after its merge.

- `emit/payload.ts` `payloadProblems`: an `icon` element holds no children and its `icon.library` is `"svg"` with an
  `svg` object. This job's Icons pass it as they are.
- `test/browser/render-icon.ts`: `iconHtml` (the file's `<svg>` with the element's id and classes on its root, the
  root's own id dropped; the file is read from a `data:` address only), `iconCss` (the control's CSS on the root),
  `ICON_SITE_CSS` (Bricks' icon rules in `@layer bricks`, used when the page is drawn with Bricks' real CSS:
  `opts.bricksCss` set), `holdsIcon`. `render.ts` calls them.
- The Figma plugin's own Icon code (`understand/icon.ts`, `model/icon-svg.ts`, `style/icon.ts`, `emit/icons.ts`) is
  **not** used here: its rule is for a drawing recoloured by the Fill or Stroke control (one flat colour); a site
  Icon carries no colour control (Q5 A), so a drawing of several colours is fine.

### Rules carried over from Milestone 1's fix round (new here; review 1's R1-1 and R1-2, review 2's notes)

Milestone 1's first build gave each Icon a fixed `min-width` floor and an `aspect-ratio`. Review 1 showed the floor
kept a 24 px icon a 24 px box after its Width was typed as 12 in Bricks. Fix round 1 replaced them. This job keeps to
what it settled:

1. **An Icon's own controls stay in charge.** Nothing this job writes may out-weigh a Width, Height, Fill or Stroke
   typed in the Icon's own boxes in Bricks. Bricks prints those on `#brxe-<id>`, which out-weighs a class, so the
   class's custom CSS (Q5 A) already gives way. A site's own `!important` is the site's and stays (a recorded limit).
2. **This job writes no box rule for an Icon by default.** Milestone 1 needs two because an `<img>` became an
   `<svg>`. Here the element was an `<svg>` and is the same `<svg>`, in the same parent (a flat Code element's wrapper
   makes no box), and the proof measured 0 without any. So: never a fixed `min-width` floor and never an
   `aspect-ratio` written for an Icon. If Task 1's re-run or the look test shows an Icon squeezed in a row or held at
   its file's height, the only remedies are Milestone 1's two shapes, at no more weight than the site's own rules:
   `overflow: clip` where the site sets no overflow on the svg, and `height: auto` under `:where(.<its class>)`.
   Each one written is proven by a mutant (Milestone 1's `aspect-ratio` was dead: its mutant survived). Anything else:
   stop and report. `overflow: clip` needs Safari 16; if it is written, HANDOFF names that limit.
3. **Browser tests run under Bricks' own print order** (the Bricks 2.4.2 and 2.3.9 looks). The renderer's default look
   prints an Icon's control after the tier rules (review 2, R2-1), and off the site route it shows the svg as a block
   (R2-2); neither reaches a page drawn with Bricks' real CSS.
4. **The fixture holds the shapes that caught Milestone 1:** an svg in a row too narrow for its words (the squeeze),
   one with no height of its own (its shape follows its width), and one wider than its box (Bricks caps every
   `brxe-` element at its parent's width; the svg inside a Code element was not one).

## The rule

With a media map that holds its file, a site's `<svg>` that today pastes as a Code element becomes an Icon when:

1. Its kept markup (`CodeNode.html`) is one `<svg` whose root starts `<svg ` and has a `viewBox`; it holds no
   `<script`, `<foreignObject`, `<style`, and no `<use` or `url(#` (a second copy's ids); its root's `id`, when it has
   one, is named nowhere inside. **(New here, from `render_svg`:)** once that `id` is dropped, the root tag holds no
   other `id="` text (a `data-id="…"` on the root would be cut by Bricks): such a drawing stays a Code element.
2. It is the site's own: not on a script-made path of another company (`madePath` / `madeInOpen`, the pictures' own
   rule, `site/media.ts`), not a live widget's, and not a drawing another step already folds (an Elementor button's
   icon, a slider's arrows: `elementor-button.ts`, `slider-look.ts` stay as they are).
3. The media map holds a library file for exactly that markup (`SiteMedia.drawings[markup]`).

Everything else stays as site-no-div makes it: a Code element labelled "SVG", a font glyph a Block labelled "Icon".

**Assumed from the two plans this job builds on** (Task 1 checks each on the real base): site-no-div Q7 A (a site svg
is a flat Code element labelled "SVG", its class's rules on `> :first-child`; a font glyph is a Block labelled "Icon";
"site-icons" is named there as this later job); site-no-div's labels (`labels.ts`: Bricks' own elements take none);
site-shared-styles' grouping (elements that draw alike may share one class: an svg's class is shared only with other
svgs, or Task 1 stops) and its palette (a class's `fill` may be a palette colour: unchanged here, the rule moves with
the class).

## What is built

- **`src/core/site/icons.ts`** (new): the rule; `drawingFile(markup)`: the file that goes up (the markup, its root
  `id` dropped, `xmlns` added when missing); the Icon's settings `{ icon: { library: "svg", svg: { id, filename, url } } }`.
  Pure, the language's built-ins only (`src/core` runs in Figma's sandbox).
- **`kinds.ts`**: before the Code choice, `ctx.icon?.(n, path)` → `{ name: "icon", settings, place: "outer",
  shared: [], own: true }`: the svg is the element's root, so its class names it (`.cls { … }`, where the Code
  element's was `.cls > :first-child { … }`) and `site-flat` is not needed. **All of the class's rules stay custom
  CSS in this job** (the split that `place === "inner"` takes in `convert.ts`), exactly what the proof measured;
  controls are site-controls' job.
- **`convert.ts`**: lists each drawing the paste shows (`Prepared.drawings`, `SiteResult.drawings`: markup, path,
  made), as it lists pictures; `librarySource` counts a drawing too (the paste then names the site, so Bricks reads
  the file there); notes per part: "N of the site's drawings are Bricks Icons (files in your media library)", and
  without files "N drawings can be Bricks Icons: run site:upload or site:import with --svg".
- **`media.ts`**: `SiteMedia.drawings?: Record<string, MediaPicture>`, keyed by the markup as the capture holds it
  (exact, no hash in core); absent: as before.
- **Upload (`tools/lib/site-upload/pictures.ts`, `flow.ts`, `summary.ts`)**: with `--svg`, `uploadList` adds one item
  per distinct drawing (`svg: drawingFile(markup)`, `bytes: null`, name `icon-<first 8 of its fingerprint>`, no alt),
  `mediaMap` writes `drawings`; the list shown before the typed `yes` counts them ("N drawings as SVG files");
  `--dry-run` sends nothing; without `--svg` none goes and the summary says how many would. The standing rule holds:
  the uploader only adds media items, on the typed site, after the typed `yes`. A site that refuses SVG leaves them
  Code elements, named. **(New here, since media-avif-alt is on `main`:)** a drawing is never re-encoded and never
  sent to alttext.ai. Both already hold for an item with `svg` set and no `bytes` (`format.ts` `served("svg")`,
  `alt-ai.ts` `wantsWords`); the upload test asserts it.
- **Renderer / checks:** Milestone 1's Icon branch on the site route. Two additions: the Icon's file is found by its
  address in a table the test passes (address → markup; tests never fetch, and a media-library address is no `data:`
  one), and **(new here)** `iconHtml` follows `render_svg` for a root that has its own `class`: Bricks' classes go
  first inside it (Milestone 1's drawings never have one, so its own tests don't change).

## Proven (`<planner>/boxes-site-*.json`, `scripts/boxes-site-icons.ts`, scratch tree of `2a38027f`)

The B-Dry stand-in capture (`evidence/site-native-structure/inputs/standin-capture-b2435de.json`) pasted as today and
with each svg Code element swapped for an Icon (class on the root), drawn at 1440, 1024, 768 and 390 with Bricks
2.4.2 and 2.3.9 over the hostile theme: with `--elementor` 12 icons (page 6, footer 6), plain route 14 (page 8,
footer 6): **every element's box equal (worst 0), each icon's computed fill, colour, font size and display equal,
each icon's pixels equal (0 of 255)**. Justin's own scan holds 44 svgs (36 shown) and 20 font glyphs
(`<planner>/site-icons-justin-capture.txt`). The swap there is the proof script's own; the job makes the Icon in the
conversion. The proof ran before site-no-div, site-shared-styles and Milestone 1 existed: Task 1 runs it again.

## Acceptance criteria (all **proposed**; approved with bricks-icons as its eighth to twelfth)

The ids are new, the wording is the approved one. Two phrases changed with the split: "the base's" now reads "the
`main` this job starts from", and "by M2" reads "by this job".

- AC1 (proposed): With a media map holding its file, a site's own svg drawing is an Icon whose class names the svg
  itself; without a file, or where rule 1 or 2 refuses it (a drawing with a `<use>`, a script-made one, a font glyph),
  it is the Code element or Block site-no-div makes, and the part's notes count both.
  Test: `test/unit/site-icons.test.ts` › "a site's own svg with a library file is an Icon; without one, or refused by the rule, it stays as it was, and the notes count each"
- AC2 (proposed): `site:upload` and `site:import` with `--svg` list each distinct drawing once before the typed yes,
  send it once as `icon-<8 letters>.svg`, and write it into media.json; `--dry-run` sends nothing; without `--svg`
  no drawing goes and the summary says how many would; a second run sends none again; a site that refuses SVG leaves
  them Code elements, named (against `test/fixtures/wp-standin.ts` only).
  Test: `test/web/site-upload-icons.test.ts` › "a scanned page's drawings go up once as SVG files with --svg, never without it, and never twice"
- AC3 (proposed): With the map, the paste draws as the paste without it: every element's box within 0.5 px, and each
  icon's computed fill, colour and font size and its pixels equal, at 1440, 1024, 768 and 390 with Bricks 2.4.2 and
  2.3.9, on the fixture site and (named-only) the B-Dry stand-in, plain route and `--elementor`.
  Test: `test/web/site-icons-look.test.ts` › "a site drawing as an Icon draws exactly as its Code element did, Bricks 2.4.2 and 2.3.9"
- AC4 (proposed): Every paste made without a media map, or with a map that holds no drawing, is byte for byte the
  `main` this job starts from (the head site-no-div, site-shared-styles and bricks-icons left), and the Figma plugin's
  pastes are untouched by this job.
  Test: `test/unit/site-icons-pin.test.ts` › "without a drawing in the media map every site paste is the base's, byte for byte"
- AC5 (proposed) (live): Justin runs `site:import` with `--svg` on bdryswi.com and pastes on B-Dry staging: the
  site's drawn icons are Icon elements in the Structure panel and look as on the old site on desktop, tablet and phone.

## Tasks

One commit a task, each green (`npm run check`), test first (`test-driven-development`). Ledger:
`.superpowers/sdd/2026-11-12-bricks-icons-site/progress.md`, committed with each task. Every check's log folder comes
from a flag or a variable, never one shared folder.

**Ready or gated.** The whole job is gated on its base (Task 0's first check). No task below carries finished code:
the files it edits are being changed by two jobs that are not merged, so Task 1 is a bounded re-read with stop
conditions, and Tasks 2–5 are written against what it finds. The rule, the outputs and the tests are fixed here.

0. **The gate, then the base's numbers.** `git log --oneline main | grep -E '^[0-9a-f]+ Build .*\((site-no-div|site-shared-styles|bricks-icons)\)'`
   must print three lines; with fewer, stop: the job can't start. Then, before any change: `npm run corpus` (keep its
   numbers); the unit, web and browser suites by test name (`CHROME_PATH` set); the pin's sums on the base tree
   (`test/fixtures/site-icons-main.json`: sha256 of each site paste the pin test makes, written by a small script run
   on a `git archive` of the base, as `tools/site-no-revert-golden.ts` does). Copy this plan to
   `docs/plans/2026-11-12-bricks-icons-site.md`.
1. **Re-read the base.** Open `kinds.ts`, `convert.ts`, `media.ts`, `labels.ts`, `tools/lib/site-upload/*`,
   `test/browser/render.ts` and `render-icon.ts` on the real base. Rerun `<planner>/scripts/boxes-site-icons.ts` on it
   first: it must still read 0. Stop and report when: a shared class now carries both an svg and another element (the
   script throws: the class split is site-shared-styles'); the script reads a moved box (then the section "Rules
   carried over", point 2, names the only remedies); or `payloadProblems` refuses the Icon this plan writes.
2. **`site/icons.ts`** (the rule, `drawingFile`) with unit tests, and **`media.ts`** `drawings`. Each refusal of rules
   1 and 2 has its own case, the `data-id` root among them. RED: the module doesn't exist (an import error is the
   expected red for a new pure helper; its behaviour tests are the ones that count).
3. **`kinds.ts` + `convert.ts`**: the Icon choice, the class on the root, `drawings` listed, notes, `librarySource`.
   The first criterion's test runs on a fixture capture (site-no-div adds a plain fixture site with an svg icon and a
   font glyph: reuse it, or add one; add a drawing with a `<use>`, one with a root id, a script-made one). RED on the
   base: the test passes a map with `drawings`, which the base ignores, so it fails on "no Icon" (an assertion).
4. **Upload**: `uploadList`, `mediaMap`, `pick`, the summary lines; the second criterion's test against
   `wp-standin.ts` (`allowSvg` on and off, the record at a temporary path), asserting too that no drawing is
   re-encoded or sent to the alttext.ai stand-in. Agents never run it against a live site.
5. **Renderer on the site route and the look test** (the third criterion), on a fixture with the shapes of "Rules
   carried over", point 4, under the Bricks 2.4.2 and 2.3.9 looks only. Beside it, a supporting test in the same
   file: "an Icon's Width, Height and Fill typed in Bricks beat its class" (the control set in the paste, the box and
   the colour read in Chrome; a site rule with `!important` is the named exception). Then the pin for the fourth
   criterion (`F2B_STORY_PINS=1`, a story pin: after the merge it would fail the next job that changes site pastes on
   purpose; sums from Task 0). Prove the look test can fail: with the class left on `> :first-child` it must.
6. **The gates.** `npm run check`, `npm run test:web` and `test:browser` by name against Task 0, `site:check --all` on
   the stand-in with and without `--elementor` for Bricks 2.4.2 and 2.3.9 (unchanged: `site:check` passes no media
   map), `npm run corpus` (the Figma side: equal to Task 0's), and `test/unit/site-no-revert.test.ts` (this job
   writes no `revert`).

### Docs & records (the finisher, at the merge)

- Plan copied to `docs/plans/2026-11-12-bricks-icons-site.md`; ledger moved to
  `docs/plans/2026-11-12-bricks-icons-site-ledger.md` before the final premerge commit.
- `docs/HANDOFF.md`: a new section above the previous top heading with the rulings (Q1, Q4–Q8 ⭐ "not yet
  confirmed"), the counts on the stand-in and on Justin's scan, the limits below, and the paste check owed with the
  next free id at the merge (check main and every branch's HANDOFF); its entry at the top of "End-of-run check list".
- `BUILD` bumped at the merge; main `CLAUDE.md` Status: the build line and one line for the feature; **standing rule
  to extend:** bricks-icons' "Bricks' Icon prints an SVG only from the media library…" gains "the importer makes
  Icons only with `--svg`, for a drawing whose file the media map holds".
- `reference/bricks/README.md` "Icon": the two `render_svg` facts of this plan (a root's own `class` is kept after
  Bricks'; the first `id="` text in the root tag is cut).

## Blast radius and shared files

| Job | Shared files | How they meet |
|---|---|---|
| bricks-icons (Milestone 1; before this job) | `test/browser/render.ts`, `render-icon.ts`, `emit/payload.ts`, `reference/bricks/README.md` | this job uses its Icon branch and its payload check, and adds the file table and the root-`class` case to `iconHtml` |
| site-no-div (before this job) | `kinds.ts`, `convert.ts`, `labels.ts`, `test/browser/render.ts` | its Q7 A defers exactly this ("site-icons"); this job replaces its Code "SVG" where a file exists; an Icon takes no label (Bricks' own name) |
| site-shared-styles (before this job) | `classes.ts`, `convert.ts`, `controls.ts` | an Icon's class stays custom CSS; if it shares a class between an svg and another element, Task 1 stops |
| media-clickable, media-avif-alt (on `main`) | `site/media.ts`, `tools/lib/site-upload/*`, `src/ui/uploader.ts` | this job adds `drawings` beside `pictures` and one more kind of item; a drawing skips the AVIF step and alttext.ai |
| importer-parity | `kinds.ts` (names, forms, video, nav) | an icon-only link's `aria-label` is that job's; the Icon sits inside the link unchanged |
| site-menu-motion, site-sticky-header, site-scroll-lock | none of the icon files | no overlap |

Order: **after** site-no-div, site-shared-styles and bricks-icons (Milestone 1) are on `main`; before or after
importer-parity and site-controls, whichever comes second rebases.

## Risks, limits and what is not in this job (each named in HANDOFF)

- **Bricks 2.3.9 / 2.4.2 printing an SVG Icon** is read from 2.2's code (the CSS is equal in 2.3.9): the live
  criterion is the proof. If a live paste shows otherwise, the fallback is today's output (no `--svg`).
- **A site that changes SVG files on upload** (a sanitiser plugin) prints its own version: the live check sees it.
- **A drawing's own class names stay on its root** in the file, as they are in today's Code element's markup.
- **Not Icons:** a site's font glyphs (Q4 A), a drawing with a `<use>`, a `url(#…)`, a script, a style or a
  `foreignObject`, a script-made or widget drawing, an Elementor button's icon, a slider's arrows.
- **Hover as the Icon's own control** (Q7 B) and **Bricks' SVG element** (set aside under Q1): later jobs, each needs a sample.
- A site's `!important` on an icon's size or colour beats a value typed in the Icon's own boxes.
- The panel's website route (a capture through the Figma converter) makes no Icons.

## Report contract

Builder, reviewer, verifier and auditor return `verdict`, `ac_status` (one row per criterion above, the live one as
owed to Justin), `shots[]` (one picture per criterion: the stand-in's icons as Code elements and as Icons at 1440 and
390, a terminal capture for the unit and upload ones), and `skill_lessons[{skill, lesson, evidence, enforce}]`,
ending with `MAIN SESSION: check and save these skill_lessons now.` Builders, reviewers and fixers first read
`~/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`. Agents never run
`site:upload` or `site:import` against a live site, never ask for or hold Justin's password, and never load
bdryswi.com or a staging site.
