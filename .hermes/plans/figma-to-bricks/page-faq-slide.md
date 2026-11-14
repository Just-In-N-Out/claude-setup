# page-faq-slide: a page's FAQ opens and slides in Bricks as it does on the site (plan, 2026-11-13)

Planner: page-faq-slide (Fable 5.2, high). Pipeline: **Full**. Website importer rules apply (repo CLAUDE.md: one
real-bug review per job, edge cases to follow-ups).
**Base: `main` once these have merged:** site-no-div, site-shared-styles, plugin-parity, importer-parity,
shared-palette **and native-widgets** (this job reuses its Accordion parts; order below). Today `main` is `7f54b0a5`
(Build 2026-11-12.3). Every importer file:line below is from `importer-parity-build` `48fe133c` (the newest importer
head, tasks 12 to 15 landed; the planner's tree `~/.cache/pfs-pl/ip`); native-widgets is approved and not built, so its
parts are cited from its plan (`~/.hermes/plans/figma-to-bricks/evidence/native-widgets/plan-approved.md`). The builder
re-reads every line on its real base before editing (Task 1).
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/planner/` (`README.md` lists every
file). Plan copy for the repo: `docs/plans/<build date>-page-faq-slide.md` (the builder copies this file there in
Task 1).

## Playback

1. On bdryswi.com the Sump Pump page's FAQ shows its first answer open, opens one answer at a time and slides for
   400 ms. Pasted today it is a stack of plain boxes the browser snaps open: no slide, the first answer closed, several
   open at once. The FAQ on the home and Exterior Drainage pages (another plugin's) pastes as Bricks' Accordion but
   slides at Bricks' own 200 ms, not the site's 350 ms.
2. You said yes to making a page's FAQ Bricks' own Accordion (Nestable) that opens and slides like the site's: the
   first answer open where the site opens it, one at a time where the site does that, and the site's slide time in
   the Accordion's Transition box, where a Bricks pro changes it.
3. Everything else stays as it is: the importer one to one with the old site, Figma designs exact at the design
   width, and every paste this job doesn't touch byte for byte as before.

## Questions (⭐ = the answer the standing auto-go takes; Justin's "go with recommended")

All ⭐ answers are the planner's rulings from research and measurement; none is confirmed.

1. **How the scan learns a list's slide.** ⭐ **A:** at the end of a scan, at the design width, the scan presses one
   closed question of each FAQ in the page (two where none is open), under the same guard as the menu buttons (no
   request that sends data, no page load, no socket), reads the height animation the site plays, whether the other
   open answer closed, or that it opened at once, and saves it in the capture. It works for any site (Elementor's
   script, a CSS transition, a hand-made script). **B:** no pressing; only Elementor's own settings are read (the
   Sump Pump FAQ would work, the home FAQ would stay at 200 ms, other sites too).
2. **Where the scan's reading and Elementor's setting differ.** ⭐ **A:** the reading wins (it is what a visitor
   sees); Elementor's setting is used only where there is no reading (a scan made before this build). **B:** the
   setting wins.
3. **Scans you already have.** ⭐ **A:** they paste byte for byte as today, with one note per part: "capture the page
   again with this build" to get the site's slide. The one exception is an Elementor Nested Accordion in the page
   pasted with `--elementor`: its time, "one at a time" and first-open state are already in the scan, so it becomes
   the Accordion now. **B:** guess a time per plugin (ElementsKit 350 ms) without a new scan: a number taken from one
   plugin's stylesheet, wrong the day a site overrides it.
4. **A list that opens at once on the site** (plain `<details>`, no slide). ⭐ **A:** on a new scan it pastes with
   Transition 0 and, where the site lets several stay open, Independent toggle on: exactly as the site. **B:** Bricks'
   200 ms slide, one at a time (what importer-parity pastes today).
5. **Visitors who ask for less motion** (their device's "reduce motion"). ⭐ **A:** the answer opens at once for them
   (two short CSS lines on the Accordion's class), as the menu's list does (native-widgets Q4 A) and every entrance
   does (site-motion). The old site still slides for them. **B:** slide always, as the site.
6. **An answer laid out as a row or grid** (Elementor's answers are flex boxes; importer-parity refuses them because
   Bricks turns its content wrapper into a plain block). ⭐ **A:** the answer sits inside Bricks' own "Content" Block,
   as in Bricks' default Accordion and native-widgets' menu list, so its layout is untouched. **B:** keep refusing.
7. **A slide the scan can't read** (a script that steps the height itself, as jQuery does: Elementor's old Accordion
   and Toggle widgets; a `max-height` trick). ⭐ **A:** Bricks' own 200 ms, with a note naming the list; a follow-up.
   **B:** guess 400 ms for those widgets.
8. **A list whose closed answers are hidden by a height of 0** instead of `display: none`. On importer-parity's head
   such a list (aria buttons) pastes as an Accordion with every answer open and the wrong heights (measured: 43.5 px
   off after one press). ⭐ **A:** this job refuses it with a plain note (it pastes as its own boxes) and names a
   follow-up job to build it properly. **B:** build it here (the scan would have to read each answer's open look).
9. **The Figma plugin.** Its FAQ already is Bricks' Accordion and already slides: no Transition is written, so
   Bricks' own script slides it at 200 ms (`bricksAccordionFn`, the same text in 2.3.9 and 2.4.2: default 200 when the
   element has no `data-transition`). Figma holds no slide time (the plugin reads no prototype timing), so there is
   nothing to copy. ⭐ **A:** no plugin change; a Bricks pro types a time in the same Transition box. **B:** a panel
   box "FAQ slide time".

## What you will see (measured; `<P>/README.md`)

Prototype: `importer-parity-build` `48fe133c` plus the planner's patch (`<P>/prototype.patch`), two fixture sites,
Bricks' real CSS and accordion script (2.4.2 and 2.3.9), at 1440 and 390 (`<P>/probe-lists-*.log`):

| List (fixture) | Site | Today's paste | Planned paste | Heights at 25/50/75 % vs the site |
|---|---|---|---|---|
| Elementor Nested Accordion, flex answers (`page-faq`) | first open, one at a time, 400 ms linear | Blocks `details`, nothing slides, note "its answer lays out as flex or grid" | Accordion `{expandItem: "0", transition: "400"}`, Item › Title + Content › the answer | 0 px |
| ElementsKit FAQ (`page-faq`) | first open, one at a time, 350 ms ease (a CSS transition) | Accordion `{expandItem: "0"}` (200 ms) | Accordion `{expandItem: "0", transition: "350"}` | at most 0.22 px |
| hand-made `details`, its own script (`page-faq-plain`) | none open, each alone, 250 ms ease-out | Accordion `{}` (200 ms, one at a time) | Accordion `{transition: "250", independentToggle: true}` | 0 px |
| plain `details`, no script (`page-faq-plain`) | first open, each alone, at once | Accordion `{expandItem: "0"}` (200 ms, one at a time) | Accordion `{expandItem: "0", transition: "0", independentToggle: true}` | opens at once in both |
| aria buttons, answers hidden by height 0 (`page-faq-plain`) | first open, one at a time, 300 ms | Accordion with all three answers open, 43.5 px off after a press | refused, its own boxes, a note (Q8) | not an Accordion |

In every Accordion row: the same answers open at load, 0 px at rest, the same answers open after a click, after Enter
on a focused title and after pressing the open title again; under "reduce motion" the paste has no running animation
(the sites still slide); no script error. Justin's saved home scan (made before any of this) pastes byte for byte as
on `48fe133c` on both routes, all three parts (`<P>/bdry-compare.log`).

## The design

### A. The scan reads how a page's lists of questions open (capture; new)

Today the scan presses a `details` only inside a box a button opens (`src/web/read/opens.ts:214` `readSlides`), and
only for a script's own animation of the `details` (`src/web/readers/details.ts:71` `slideOf`); a list in the page is
never pressed, and `readOpens` makes no guard at all on a page with no boxes (`opens.ts` `if (!byTarget.size) return`).

**New reading, at the scan's end.** In `capture.ts`, right after the design width's openers (`capture.ts:486-500`, the
last thing that touches the page), when the capture has code (`opts.code !== false`) and `CaptureOptions.lists !==
false` (new option, default on; off: tests only):

1. **Find the lists** under the parts' roots, drawn at the design width, outside every box `web.code.opens` read and
   outside a closed `details`:
   - two or more `details` children of one parent, each with a drawn `summary`;
   - two or more children of one parent, each holding exactly one element with `aria-expanded` and `aria-controls`
     that names an element inside that same child and outside the title.
   At most 20 lists a page (more: one capture note, the rest unread).
2. **Read which items are open** (`details.open`; the title's `aria-expanded="true"`).
3. **Press the first closed item's title** with the existing watched press (`opens.ts:83` `press`, `openers.ts:212`
   `pressPath`, source `PRESS_SOURCE`) under a guard of its own (`guardPresses(page)`, released after the last list).
   A press the guard stopped reads nothing and is named, as today.
4. **Read the slide**, waiting up to 600 ms (`SLIDE_MS`): the animation under the list whose target is the pressed
   item or inside it and which animates `height`: a script's Web Animation with a `height` keyframe, or a CSS
   transition whose `transitionProperty` is `height`. Kept when its delay is 0 and its duration a finite number above
   0: `{ duration, easing: effect.getComputedTiming().easing, frameEasing: first keyframe's easing }` (`CodeSlide`, the
   type the opened-box reading already uses). Chrome reports a CSS transition's curve as the effect's easing and
   `linear` on its keyframes (measured: `ease` / `linear`).
   - none came, the item is open and the list's height is the same on every frame after the first: **at once**
     (`slide: null`);
   - anything else (the height keeps changing with no such animation: a script stepping it; an animation of another
     property): no `slide` key, and one capture note `a list of questions opens in a way the scan can't read (<list>)`.
5. **Finish** every such animation under the list, wait two frames, read the open items again. **One at a time**
   (`single`): an item open before the press is closed now → `true`; still open → `false`; none was open → press a
   second closed item the same way, and `single` is whether the first closed.
6. **Put back** every `details` (`holdDetails` / `restoreDetails`, as `readSlides` does). Aria lists are left as
   pressed: nothing reads the page after this step (only downloads follow).

**The record** (`src/core/snapshot/web.ts`, beside `CodeSlide`):

```ts
export interface CodeList {
  list: string;               // the list's path (its items' parent)
  items: string[];            // its items' paths, document order
  slide?: CodeSlide | null;   // how a pressed item opened; null: at once; absent: not read
  single?: boolean;           // opening one closed the open one; absent: not read
}
// WebCode.lists?: CodeList[]  page-faq-slide: the page's lists of questions pressed at the design width.
//                             Absent: a capture made before this build. [] : this build found none.
```

`CodeNode.slide` (a `details` in an opened box) stays as it is: a page list is one record a list because it also says
"one at a time" and "at once", which a per-item field can't.

**Where it is built.** New `src/web/readers/lists.ts` (the in-page functions, each self-contained as `details.ts`'s
are: find, open states, watch) and `src/web/read/lists.ts` (`readLists(session, roots, skip, { note })` and
`readListsSafely`, as `readOpensSafely` wraps `readOpens`). `opens.ts` is 326 lines: the press helpers both readers
need (`press`, `pressed`, `PRESS_SOURCE`, `Watch`, `stoppedNote`, `sleep`) move whole to `src/web/read/presses.ts`,
`opens.ts` importing them back, nothing else in it changed. The scan's log gains one line (`Lists: 2 read (400 ms
linear, one at a time; 350 ms ease, one at a time)`). `capture:check` gets a line only if it already lists `opens`
(the builder greps it).

**What it costs.** At most two presses a list, each up to 0.6 s plus two frames: about 1 to 3 s on a page with a FAQ,
nothing on a page without one. No request leaves during a press (the guard), no login, nothing typed.

**Proven before the build** (`<P>/probe-lists.ts` part A, the same steps run from Node on the two fixture sites): the
five readings of the table above, each with the right duration, curve, "one at a time" and "at once".

### B. A page's list becomes Bricks' Accordion with the site's opening (importer)

**Which lists.** importer-parity's recognisers stay as they are (`plain-natives.ts:183-200` `questionsAt`: two or more
`details` of a summary and one box with the triangle hidden, or aria items; the Elementor step's
`elementor-accordion.ts` for ElementsKit and Elementor's Accordion widget), with two changes in `questionsAt`:

- R1. **A `details` list whose answer is flex or grid is no longer refused when the capture says how the list
  opens**: it has a `lists` record for that list, or (a route that reads Elementor's map) the list sits in a
  `nested-accordion` widget whose settings the map holds. Otherwise it is refused as today, with the reason
  `this capture doesn't say how the list opens (capture the page again with this build)` in place of today's
  "its answer lays out as flex or grid" (`plain-natives.ts:195`), and its paste is byte for byte the base's.
- R2. **An aria list is refused when its closed answers keep a box**: on a capture with `keeps`, the items shown at
  the design range (`accordionShape`'s `open`) aren't exactly the items whose title says `aria-expanded="true"`.
  Reason: `its closed answers are hidden by a height of 0 or the like, not display: none`. (Q8; today such a list is
  an Accordion with every answer open.) An aria list with a flex or grid answer stays refused as today (follow-up).

**The shape** (Bricks' own: `ExampleBricks` line 7, `reference/bricks/README.md` "`accordion-nested`", native-widgets'
`reference/bricks/accordion-nested-schema.json`):

```
Accordion (Nestable)      was the list                settings: expandItem?, transition?, independentToggle?
  Block "Item"            was the details / the item  (its own classes; no tag)
    Block "Title"         was the summary / the title (accordion-title-wrapper; no tag)
    -- a block answer (importer-parity's shape, unchanged):
    Block "Answer"        was the answer's box        (accordion-content-wrapper; Bricks shows and hides it)
    -- a flex or grid answer of a details (R1; native-widgets' TreePick.rest):
    Block "Content"       new, Bricks' own            (accordion-content-wrapper; no class; not in the sources)
      Block "<layout>"    was the answer's box, unchanged (its own display and gaps stay)
```

Why two shapes: Bricks' script sets the content wrapper to `display: block` when it opens (`bricksAccordionFn`), which
is right for a block answer (one element fewer, as the plugin's FAQ) and would flatten a flex or grid one. The wrapper
is added only where it does that job.

**The settings** (new `src/core/site/list-timing.ts`, pure, about 60 lines; the prototype's is in `<P>/prototype.patch`):
`listTiming(code, shape, widget): { transition?: string; independent?: true; curve?: string; open?: number[]; from:
"scan" | "elementor" | null; why?: string }`, read in this order for every page Accordion (both recognisers):

| Setting | From the scan's reading (`lists` record whose `list` is the shape's list) | Else, `--elementor` and a `nested-accordion` widget | Else |
|---|---|---|---|
| `transition` (a string of a number, ms) | a usable slide (`slide.ts` `usable`) with one CSS curve (native-widgets' `cssCurve`): its rounded duration; `slide: null`: `"0"` | `n_accordion_animation_duration`: `size` × (1 for `ms`, 1000 for `s`), above 0 and at most 10 000; curve `linear` (Elementor's handler gives no easing) | not written (Bricks' 200 ms) |
| `independentToggle` (only ever `true`) | `single === false` | no `single` reading and `max_items_expended === "multiple"` | not written (one at a time) |
| `expandItem` | as today: a `details`' `open` attribute where the capture kept it; an aria or Elementor-step list's shown answers | a `details` list on a capture without `keeps` "open": `default_state` `expanded` → `"0"`, `all_collapsed` → none | as today |

- The Elementor names and defaults are from Elementor's own code (`<P>/sources/elementor-3.35.0-nested-accordion.php`
  L345-385 and L805-818: `default_state` `expanded` by default, `max_items_expended` `one` by default,
  `n_accordion_animation_duration` `{unit: ms, size: 400}`; the handler `<P>/sources/elementor-4.0.0-nested-accordion-handler.js`).
  A setting missing from the map counts as its default only for `n_accordion_animation_duration`, `default_state` and
  `max_items_expended` of a `nested-accordion` widget.
- A slide whose two easings are both non-linear, or whose duration isn't usable: no `transition`, `why` in a note.
- **The slide class.** When `transition` is written and isn't `"0"`, the Accordion takes native-widgets' slide class
  (`slide.ts` `listSlideClass`, one class a curve, shared with the menu's lists): the curve line (left out for
  `ease`) and the reduced-motion line (Q5). With `"0"` or no `transition` it takes none.
- `accordionPicks` (`elementor-accordion.ts:103`) takes the extra settings and whether to wrap:
  `accordionPicks(code, s, link, more?: { settings?: Record<string, unknown>; shared?: string[]; wrap?: boolean })`;
  with `wrap`, the item's pick carries `rest: { hidden: "accordion-content-wrapper", label: "Content" }`, the answer
  gets no pick and keeps its `display` (the callers skip `withoutDisplay` for it). Both callers pass it:
  `plain-natives.ts` (after `questionsAt`) and `elementor-fold.ts:393-409` (never `wrap` there).
- On the Elementor route the widget's line in "kept as page code: nested-accordion …" is left out once its list is
  an Accordion, and the `Structure:` line counts it.

**Notes** (per part, plain words; one line each kind):
- `<k> list(s) of questions open as on the site (<400 ms, one at a time; 350 ms, one at a time>): Bricks' own Accordion, change the time in its Transition box`
- `<k> list(s) of questions slide at Bricks' own 200 ms: this capture doesn't hold the site's time (capture the page again with this build)` (no `lists` in the capture)
- `a list of questions slides at Bricks' own 200 ms: <the site's own slide couldn't be read | its slide's curve can't be written as one CSS curve> (<list>)` (a record without a usable slide)
- with `independentToggle`, the existing "several answers open at load" note ends `each opens and closes alone, as on the site` instead of `a click opens one at a time`; without it the note's words stay as they are.
- R1 and R2's reasons go through today's `questions stay as they are (<why>): <path>`.

**Known differences** (HANDOFF names them): a second press while an answer still slides (native-widgets' known
difference, `…/native-widgets/planner/probe-second-press.log`); find-in-page doesn't open a closed answer; under
"reduce motion" the paste opens at once where the site slides (Q5); a list with no answer open at load has no open
look in the scan (its title's colour or turned icon when open isn't read: follow-up); a closed answer's words keep the
boxes around them (the scan measures no box inside a closed answer, so the fold can't prove them away: measured on
`page-faq`, the open item holds 2 Texts, a closed one Box › Box › Text; follow-up with fewer-kept-boxes).

### C. The Figma plugin (no change)

`src/core/understand/node.ts:111-116` makes an FAQ `accordion-nested` with `expandItem` and `faqSchema`; no
`transition` is written, so Bricks' script uses its default 200 ms: it already slides (read in Bricks' script, not
re-measured on darksalmon here). `src/plugin/extract` reads no prototype timing, so Figma gives no time to copy. Both
tools make the same shape (Accordion › Item › Title + content); the importer adds only what the old site tells it.
The eighth criterion pins every Figma payload and warning.

### D. The test renderer and the Bricks reference

Nothing new beyond native-widgets (its fifth criterion makes `test/browser/render.ts` print `data-script-args` and
`data-transition`, and adds the schema and `frontend-2.4.2/accordion-fn.js`). This job adds to
`reference/bricks/README.md` "`accordion-nested`": `transition: "0"` opens at once (the script's `isNaN` test keeps
`0`; drawn in `<P>/probe-lists-page-faq-plain.log`), `independentToggle` and `expandItem` together, and under "Still
wanted": Justin's own Accordion with Transition, Independent toggle and two Expand indexes set, copied from his Bricks.

## The standard, point by point ("built like a skilled Bricks builder made it by hand")

1. **Structure.** A list of questions is Bricks' Accordion (Nestable) with Bricks' own Item › Title / Content, as his
   own FAQ and Bricks' default Accordion are built; no Div, no Code element, no `details` tag left on a Block. The one
   added Block is Bricks' "Content" wrapper and only where it does a job (it is what Bricks slides around a flex or
   grid answer); a block answer gets none. Items are labelled "Item", "Title", "Answer" / "Content".
   **Where it isn't met:** a closed answer's words keep one or two boxes around them (above; follow-up).
2. **Classes.** Items, titles and answers keep the classes they have (same-looking items already share them); the
   list keeps its own class with the open look; `site-accordion` is the class every FAQ shares; lists with the same
   curve share one slide class with the menu's lists. The slide class writes only the content wrapper's
   `transition-timing-function` (and its duration under reduced motion); nothing else writes those, so no two classes
   write one property. Names follow the naming in force on the base (short-class-names' if it merged).
3. **Settings before custom CSS.** The time is the Accordion's Transition, "each alone" its Independent toggle, the
   answers open at load its Expand item indexes. Only the curve and the reduced-motion line are custom CSS (Bricks
   has no control for either): two short lines on the class that owns them, none for `ease`.
4. **Bricks' own behaviour.** Bricks' accordion script does the opening, the closing of the others and the slide; no
   script of the site is pasted, nothing needs "Regenerate code signatures".
5. **Editable content.** Questions and answers stay in their text fields and links in Link to; the slide time is
   typed in Transition and takes effect (the proof changes it to 1000 and measures 1000 ms); the answer open at load
   is changed in Expand item indexes.
6. **Looks stay true.** 0 px at rest and after every press, at most 0.22 px mid-slide on the fixtures, both Bricks
   versions. Where exact and clean conflict the paste stays exact: a list the scan can't prove (R1, R2, an unread
   slide) pastes as today and the notes say why.

## What this plan assumes from the jobs in flight (shared files)

| Job (state) | Shared files | What this plan assumes or does |
|---|---|---|
| importer-parity (builder running, `importer-parity-build` `48fe133c`) | `plain-natives.ts`, `elementor-accordion.ts`, `elementor-fold.ts`, `convert.ts`, `snapshot/web.ts` (`keeps`), `test/unit/site-plain-natives.test.ts` | its section D makes page lists Accordions and refuses flex or grid answers, single items, a shown triangle, lists in opened boxes; `web.code.keeps` holds "open", "aria-expanded", "aria-controls". This job changes one refusal (R1), adds one (R2) and adds settings; everything else of `questionsAt` and `accordionShape` is reused as is. **Finding for that job** (not fixed there): an aria list whose answers are hidden by height 0 pastes with every answer open (`<P>/probe-lists-page-faq-plain.log`, last row) |
| native-widgets (approved, not built; base importer-parity `33a73f41`) | `tree.ts` (`TreePick.rest`), `slide.ts` (`cssCurve`, `listSlideClass`, `usable`), `classes.ts`, `natives.ts` (`ROLES` "Content"), `test/browser/render.ts` (the two attributes), `reference/bricks/accordion-nested-schema.json`, `frontend-2.4.2/accordion-fn.js`, `open-paste.ts`, `list-accordion.ts` | all of these exist on the base and are reused, never forked. Its lists (inside an opened box) stay its own: always `independentToggle`, no reading of "one at a time" (its follow-up; this job doesn't change it). If `listSlideClass` takes a slide, this job passes `{ duration, easing: curve, frameEasing: "linear" }` |
| site-no-div (`site-no-div-final` `cf4f887d`, moving onto main) | `elementor-accordion.ts`, `elementor-fold.ts`, `natives.ts`, `tree.ts` | no Div; every Block labelled; this job adds no element kind |
| site-shared-styles (`site-shared-styles-fix1` `7b7501bd`) | `classes.ts`, `convert.ts` | a class family is named through `classes.ts` by a fingerprint of its rules: the slide class is native-widgets' |
| short-class-names (planning) | `classes.ts`, `slide.ts`, `elementor-fold.ts` | renames made-up names; this job names no class itself |
| look-grouping (planning) | `snapshot/web.ts`, `convert.ts` | adds its own capture facts; `lists` is a separate optional field |
| fewer-kept-boxes (planning) | `fold-boxes.ts`, `elementor-fold.ts` | may fold boxes inside answers; an Accordion's picks are never folded. The closed-answer boxes follow-up is its ground |
| plugin-parity (`plugin-parity-build` `89e41a0d`), shared-palette (`shared-palette-build` `9070c50f`) | `test/browser/render.ts` (plugin-parity), `convert.ts` (shared-palette) | no shared rule; this job changes nothing in `src/core` outside `site/` and `snapshot/web.ts` |
| site-menu, site-menu-motion (merged) | `src/web/read/opens.ts`, `readers/details.ts`, `press-guard.ts`, `capture.ts` | the press, the guard and the details hold/restore are reused; moving the press helpers to `presses.ts` changes no behaviour (their tests pass unchanged) |
| site-sticky-cards, forms-wpforms (no plan yet) | none known | nothing assumed |

No in-flight plan names `src/web/capture.ts`, `src/web/read/opens.ts` or `src/web/readers/` as files it changes
(checked by grep over every plan above), so the capture half can't collide.

**Order:** after importer-parity and native-widgets (same files: `plain-natives.ts`, `elementor-accordion.ts`,
`tree.ts`, `slide.ts`), which themselves come after site-no-div and site-shared-styles. Independent of plugin-parity,
shared-palette, look-grouping, clean-values; with short-class-names and fewer-kept-boxes either order (the second to
merge re-runs its pins).

## Acceptance criteria (all **proposed**)

Each line is one criterion with its one test. "The base" is the merge-base commit the build starts from. "Drawn" means
`renderSitePaste` on the site route with Bricks' own CSS and script (`test/web/lib/site-check.ts`), Bricks 2.4.2 and
2.3.9, at 1440 and 390.

- AC1 (proposed): Given a hand-made capture whose page holds a list of three `details` (the first with `open`), each a summary whose display the site sets and one flex-column box, with a `lists` record for it (400 ms, `linear` / `linear`, `single: true`), on both routes and both text modes: the list pastes as one `accordion-nested` whose settings hold `expandItem: "0"` and `transition: "400"` and no `independentToggle` (keys and value types found in `reference/bricks/accordion-nested-schema.json`), carrying `site-accordion` and one slide class whose CSS is the curve line and the reduced-motion line; each `details` is a Block labelled "Item" with no tag, each summary a Block labelled "Title" with `accordion-title-wrapper` and no tag, and the answer's box sits, with its own `display: flex` kept, inside one Block labelled "Content" with `accordion-content-wrapper`, no class and no entry in the sources; the same capture with block answers holds no "Content" Block and its answer Block carries `accordion-content-wrapper` as on the base; no element has a `details` or `summary` tag, the part holds no Code element, and `payloadProblems` is empty. Test `test/unit/site-page-faq.test.ts` "a details list the scan read pastes as an Accordion with the site's time, a flex answer inside Bricks' Content Block".
- AC2 (proposed): Given one list and each row of section B's table: a reading of 350 ms `ease` / `linear` gives `transition: "350"` and a slide class with no curve line; 250 ms `ease-out` / `linear` with `single: false` gives `transition: "250"`, `independentToggle: true` and the curve line `ease-out`; `slide: null` gives `transition: "0"` and no slide class; a reading beside a `nested-accordion` widget whose settings say 1.2 s and `multiple` gives the reading's values; no reading and that widget on the Elementor route gives `transition: "1200"`, `independentToggle: true`, curve `linear`, and, on a capture without `keeps`, `expandItem: "0"` for `expanded` and no `expandItem` for `all_collapsed`; the same widget on the plain route, or no widget, gives no `transition` and no `independentToggle`; a slide with both easings non-linear, a duration of 0 or above 10 000 gives no `transition` and its reason; and each case's notes hold exactly the line section B names for it. Test `test/unit/site-list-timing.test.ts` "an Accordion's Transition, Independent toggle and open items come from the scan's reading, then Elementor's settings, else stay Bricks' own".
- AC3 (proposed): Given a `details` list with flex answers on a capture with no `lists` record and no Elementor settings for it, and an aria list (on a capture with `keeps`) whose three answers are all shown at the design range while only the first title says `aria-expanded="true"`: neither pastes as an `accordion-nested`; the first's part payload is byte-identical to the base tree's paste of the same capture, and the notes hold `questions stay as they are (this capture doesn't say how the list opens (capture the page again with this build)): <path>` and `questions stay as they are (its closed answers are hidden by a height of 0 or the like, not display: none): <path>`; an aria list whose shown answers are exactly its `aria-expanded="true"` items still pastes as an Accordion. Test `test/unit/site-page-faq.test.ts` "a list the capture says nothing about, or whose closed answers keep a box, stays as it is and its notes say why".
- AC4 (proposed): Given the fixture sites `page-faq` and `page-faq-plain`, captured with this build: `web.code.lists` holds exactly one record per list with its path and item paths: the Nested Accordion `{ slide: 400, linear, linear; single: true }`, the ElementsKit FAQ `{ slide: 350, ease, linear; single: true }`, the script-slid `details` `{ slide: 250, ease-out, linear; single: false }`, the plain `details` `{ slide: null; single: false }`, the height-0 aria list `{ slide: 300, ease-in-out, linear; single: true }`; while the lists were pressed the fixture's server saw no request other than a GET and no page load; every `details` has the `open` state it had at load once the capture ends; a list whose title is a link to another page is pressed without a page load and its record has no `slide` and no `single`; and a fixture site without such a list (`site-slide`) captures `lists: []` with every other field of `web.code` deep-equal to the same capture made with `lists: false`. Test `test/web/capture-lists.test.ts` "the scan presses a page's lists of questions under the guard and records how each opens".
- AC5 (proposed): Given the fixture site `page-faq` captured and pasted on both routes, drawn beside the site's own page: for the Nested Accordion and the ElementsKit FAQ, the same items are open at load; every drawn element under each list is within 0.5 px of the site's, at load and after the second title is clicked; with every height animation under the list held at 25, 50 and 75 % of its own time after that click, the list's height and each item's height are within 0.5 px of the site's at the same points; afterwards only the second item is open; Enter on the focused third title opens it and closes the second; clicking it again closes it; under `prefers-reduced-motion: reduce` a click starts no running animation under the list; with the Accordion's `transition` changed to `"1000"` in the payload the slide's CSS transition lasts 1000 ms; the page part holds no Code element for either list and no script error is thrown. Test `test/web/site-page-faq-proof.test.ts` "an Elementor page's two FAQs open, slide and close in the paste as on the site".
- AC6 (proposed): Given the fixture site `page-faq-plain` captured and pasted on the plain route, drawn beside the site's own page: the script-slid list is an Accordion with `transition: "250"` and `independentToggle: true`, none open at load, the heights at 25, 50 and 75 % within 0.5 px of the site's, and a second item opened stays open beside the first; the plain `details` list is an Accordion with `transition: "0"` and `independentToggle: true`, its first answer open at load, a clicked answer open on the next frame with no animation, in both; the height-0 aria list is no Accordion and the part's notes hold its reason; every drawn element under the two Accordions is within 0.5 px of the site's at load and after a click. Test `test/web/site-page-faq-proof.test.ts` "a hand-made site's lists slide, open at once or stay as they are, as the scan read them".
- AC7 (proposed): Given every hand-made code capture the base's pin lists hold (`test/unit/lib/site-pins.ts` and the lists beside it), the saved fixture-site captures and Justin's saved scan (`F2B_BDRY_CAPTURE`), none of which holds `lists`, on both routes: each part's payload is byte-identical to the base's except a part holding a `details` list of flex or grid answers inside a `nested-accordion` widget on the Elementor route (listed by capture and part in the test, each asserted to hold the Accordion of section B); and each part's notes are the base's but for: the one "Bricks' own 200 ms … capture the page again" line where the part holds a page Accordion, R1's reason in place of "its answer lays out as flex or grid", and R2's reason where it applies. Test `test/unit/page-faq-slide-site-pins.test.ts` "every site paste of a capture without a lists reading is byte for byte the base's but a Nested Accordion on the Elementor route" (a story pin: it runs with `F2B_STORY_PINS=1` and `F2B_BASE_TREE`; a skip is never a pass).
- AC8 (proposed): Given the five real design files and every Figma fixture, with the header and footer ticks off and on, and the panel's website route on its fixture captures: every payload and every warnings list is byte-identical to the base's, and no payload's `accordion-nested` holds `transition` or `independentToggle`. Test `test/unit/page-faq-slide-figma-pins.test.ts` "every Figma payload and warning is byte for byte the base's" (a story pin, as the one above).
- AC9 (proposed) (live): Justin scans the Sump Pump page with this build (`npm run site:import -- https://bdryswi.com/sumppump/ <his staging address> --elementor`) and pastes the page on B-Dry staging. In Bricks' Structure panel the FAQ is "Accordion (Nestable)" › "Item" › "Title" and "Content"; on the live page the first answer is open at load, opening another closes it, and the answers slide as on bdryswi.com; he changes the Accordion's Transition from 400 to 1000 in Bricks, saves, and it slides more slowly (a Bricks pro's edit does what it should); nothing needs Regenerate code signatures for the FAQ. Then the home page scanned again with this build: its FAQ's Transition box reads 350 and it slides as on the site. The plugin's pastes don't change, so no darksalmon paste is owed. HANDOFF paste check: the next free id at the merge.

## Touched files (paths on the newest heads; the builder re-reads them on the base)

New: `src/web/readers/lists.ts`, `src/web/read/lists.ts`, `src/web/read/presses.ts` (moved lines);
`src/core/site/list-timing.ts`; `test/unit/site-page-faq.test.ts`, `site-list-timing.test.ts`,
`page-faq-slide-site-pins.test.ts`, `page-faq-slide-figma-pins.test.ts`; `test/web/capture-lists.test.ts`,
`site-page-faq-proof.test.ts`; `test/fixtures/web/sites/page-faq/` and `page-faq-plain/` (from `<P>/fixture/`, plus in
`page-faq-plain` a fourth list whose titles are links to another page, for the fourth criterion);
`test/fixtures/site-page-faq-code.ts` (the hand-made captures of the first three criteria, built as
`site-plain-natives.test.ts`'s are).

Changed: `src/core/snapshot/web.ts` (`CodeList`, `WebCode.lists`); `src/web/capture.ts` (the step and its option),
`src/web/read/opens.ts` (imports the moved helpers), `src/web/types.ts` only if `CaptureOptions` lives there;
`src/core/site/plain-natives.ts` (R1, R2, the settings, `wrap`), `elementor-accordion.ts` (`accordionPicks`' extra
argument; `accordionNotes`' wording with `independentToggle`), `elementor-fold.ts` (the settings; the kept-widget
note), `convert.ts` (hands `plainNatives` the widget a path sits in on the Elementor route; the notes),
`parity-notes.ts` only if its `Natives:` line needs the count; `reference/bricks/README.md`; `docs/HANDOFF.md`, the
plan copy and the ledger.

Not touched: `src/ui/`, `src/plugin/`, `src/core` outside `site/` and `snapshot/web.ts`, `emit/`, the uploader
(`tools/lib/site-upload/`), `open-paste.ts` and `list-accordion.ts` (lists in opened boxes are native-widgets'),
`test/browser/render.ts` (native-widgets printed the attributes), `press-guard.ts`, `readers/details.ts`.

**Tests that pin what this job changes** (the builder may edit only these, each with stronger assertions of the new
behaviour, and names every one in the ledger):
- `test/unit/site-plain-natives.test.ts:56`: the flex answer's reason becomes R1's (its capture has no `lists`);
- unit tests asserting a part's **whole** notes list where the part holds a page Accordion on a capture without
  `lists` (they gain the one "Bricks' own 200 ms" line): found by running the suite; candidates
  `site-elementor-widgets.test.ts:114-119`, `site-elementor-open-item.test.ts:173-228`, `site-parity-*.test.ts`;
- web tests that capture a fixture site holding a list and assert its Accordion's **settings** or notes exactly
  (`elementor-faq`, whose script toggles at once, now reads `slide: null` and pastes `transition: "0"`;
  `parity-natives`' `details` list and aria list): `test/web/site-elementor-faq*.test.ts`, `site-parity-*.test.ts`,
  each updated to the reading the fixture's own script gives, proven by that test's site-versus-paste comparison
  still passing;
- any capture test that deep-equals a whole `web.code` (it gains `lists`).
The planner's prototype (no capture change, so only the first two kinds can show) against `48fe133c`'s unit suite:
`<P>/unit-proto-vs-ip.diff`.

## Tasks (test first; one commit a task, each green; a ledger in `.superpowers/sdd/page-faq-slide/progress.md`)

Every new test is proven able to fail: with the task committed, `git checkout HEAD~1 -- <the task's source files>`,
see it fail for the reason named, `git checkout HEAD -- <those files>`.

### M0: the base

**Task 1.** Copy this plan to `docs/plans/`; re-read every file:line above on the base and note what moved in the
ledger; run `npm run check`, `npm test` (the tally by test name), `npm run test:web` and `npm run test:browser` (by
name), `npm run corpus` (on this desktop: replay the two repo corpus files and the three debug files instead, memory
`corpus-paths-on-desktop`); make a `git archive` of the base under `~/.cache/pfs-b/base` for the two story pins and the
third criterion. Record the base's pastes of Justin's scan, both routes.
**Stop conditions:** importer-parity or native-widgets not on the base (no `TreePick.rest`, no `listSlideClass`, no
`data-transition` in `render.ts`) → stop and report; never rebuild their parts here.

### M1: the scan (capture)

**Task 2 (the record and the press helpers).** `CodeList` and `WebCode.lists` in `snapshot/web.ts`; move the press
helpers to `src/web/read/presses.ts`. No behaviour change: `test/web/capture-slide.test.ts`, the opens capture tests
and `npm run typecheck` pass unchanged. **Stop:** any of them changes → undo the move and export in place instead.

**Task 3 (the fourth criterion).** Add the two fixture sites (`<P>/fixture/`; add the link-titled list). RED:
`test/web/capture-lists.test.ts`. GREEN: `readers/lists.ts`, `read/lists.ts`, the step in `capture.ts` with
`CaptureOptions.lists`, the log line. Start from `<P>/probe-lists.ts` part A (`FIND`, `OPEN`, `WATCH`), which already
gives the five readings; in the capture the press is `press()` with `pressPath`, not a mouse click. **Stop:** a
reading differs from the probe's for a fixture list → find why before changing the fixture; a press sends a request
the guard should have stopped → stop and report.

### M2: the paste (importer)

**Task 4 (the second criterion).** RED: `test/unit/site-list-timing.test.ts`. GREEN: `list-timing.ts` (from
`<P>/prototype.patch`, with `cssCurve`, `usable` and `listSlideClass` taken from `slide.ts`, not copied), the settings
and the slide class passed through `accordionPicks` from both callers, the notes of section B, the kept-widget note.

**Task 5 (the first and third criteria).** RED: `test/unit/site-page-faq.test.ts`. GREEN: R1 and R2 in `questionsAt`,
`wrap` (the item's `rest`, the answer unpicked with its display kept), `convert.ts` handing the widget. Edit
`site-plain-natives.test.ts:56` as listed. **Stop:** a paste of a capture without `lists` changes anywhere but a
Nested Accordion on the Elementor route → the rule is too wide: stop and report.

### M3: the proofs in Chrome

**Task 6 (the fifth criterion).** `test/web/site-page-faq-proof.test.ts` on `page-faq`, from `<P>/probe-lists.ts`
part C (`HOLD`, `HEIGHTS`, `ANY`): Bricks' transition ends by a timer, so the hold reads its three points within the
slide's own time (pause every height animation first, then set each one's time). **Task 7 (the sixth criterion).** The
same on `page-faq-plain`. **Stop:** a height differs by more than 0.5 px where the probe measured 0 to 0.22 → compare
with `<P>/probe-lists-*.log` before touching the rule.

### M4: pins, gates, records

**Task 8 (the seventh and eighth criteria).** The two story pins against Task 1's base tree; update the web and
unit tests listed under "Tests that pin", each named in the ledger with its proof.

**Task 9 (gates).** `npm run check`, `npm test`, `npm run test:browser`, `npm run test:web` (TMPDIR 38 characters or
fewer) compared with Task 1's tallies by test name; the five Figma replays; `site:check` rows on the B-Dry stand-in
and Justin's scan no worse than the base's; one timed capture of `page-faq` and of a fixture without a list (the
reading adds under 5 s to the first, nothing measurable to the second).

**Task 10: Docs & records.**
- the plan copy in `docs/plans/<build date>-page-faq-slide.md` (Task 1) and the ledger, which the finisher moves to
  `docs/plans/<plan>-ledger.md` before the final premerge commit and rebase;
- `docs/HANDOFF.md`: a new section above the previous top `## ` heading ("A page's FAQ opens and slides as on the
  site: Bricks' Accordion with the site's time"), with the scan's reading (section A), R1 and R2, the settings table,
  the known differences, every ⭐ ruling as "not yet confirmed", the follow-ups below, and the paste check (the live
  criterion) at the top of "End-of-run check list" under the next free id (checked free on main's HANDOFF, every local
  branch's and the plan folder, as the project skill says);
- `reference/bricks/README.md`: section D's lines;
- `BUILD` bumped at the merge (never in the copy);
- main `CLAUDE.md` after the merge: the Status build line and one line for this feature with its paste check; one
  standing rule under "Working in this repo": **"A scan presses a page's lists of questions once at its end, under
  the press guard, and records how each opens (`web.code.lists`); a paste's Accordion takes its Transition,
  Independent toggle and open items from that reading (`src/core/site/list-timing.ts`), never from a plugin's name. A
  flex or grid answer sits inside Bricks' Content Block, never as it."**; under "Decisions the user made", Justin's
  yes of 2026-11-13 (a page's FAQ slides like the site's as Bricks' Accordion) and the ⭐ answers of Q3, Q4, Q5 and Q8
  as not yet confirmed. If writing it is refused, the exact lines go in
  `~/.hermes/plans/figma-to-bricks/page-faq-slide-claude-md-pending.md`;
- the project skill's `references/rules-summary.md`: the finisher returns the proposed one-line edit; the main
  session saves it.

**Follow-ups for HANDOFF "Deferred"** (none built here): an aria list whose closed answers are hidden by a height of
0, `max-height` or grid rows, as an Accordion (Q8 B; the scan must read each answer's open look); an aria list with a
flex or grid answer; a slide a script steps itself (jQuery: Elementor's Accordion and Toggle widgets) and `max-height`
slides (Q7); the open look of a list with no answer open at load (the scan could read it while it presses); the boxes
kept around a closed answer's words (with fewer-kept-boxes); "one at a time" for a list inside an opened box
(native-widgets always writes Independent toggle); a single `details` that slides; a slide with a delay; lists not
drawn at the design width (a phone-only FAQ is not pressed); the Figma plugin's own slide time (Q9 B).

## Risks and stop conditions

- **The base moves under the plan.** Six jobs merge first and `plain-natives.ts`, `elementor-accordion.ts`, `tree.ts`
  and `slide.ts` are theirs too. Task 1 re-reads everything; a part another job built is reused, never forked.
- **Pressing a live page's buttons.** The presses are a visitor's (a question's own title), run under the existing
  guard, and only on elements that say they open something (`summary`; `aria-expanded` with `aria-controls`). A title
  that would leave the page is stopped by the guard and read as nothing (the fourth criterion). The importer still
  never hides that its Chrome is automated and never signs in.
- **A scan is slower or less steady.** At most two presses a list and 20 lists; Task 9 times it. A reading that
  fails (a thrown error in the page) is caught by `readListsSafely`: the capture is saved with `lists: []` and a note,
  never lost.
- **A site animates only the answer's height while its padding stays** (a jump at the start): Bricks slides height
  and padding together, so mid-slide heights differ by up to that padding though the ends match. Not seen on the
  fixtures or in Elementor's or ElementsKit's code; a named HANDOFF limit if a real site shows it.
- **Bricks' accordion on the real site.** Proven with Bricks' own script and CSS in Chrome, not in Justin's Bricks:
  the live criterion is that check. `transition` and `independentToggle` come from Bricks' 2.2 source and 2.4.4
  schema (native-widgets' reference), not from a copy out of his Bricks.
- **Chrome runs.** SIGTERM, exit 143 or 137, or "Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30
  min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first and rerun under `systemd-run --user --scope -p
  MemoryMax=4G -p MemorySwapMax=0`.
- **Never** load bdryswi.com, B-Dry staging or any live site; never run `site:upload` or `site:import` against a
  site; fixtures and saved scans only. Only Justin runs the live criterion.

## Completion and reporting

`ready-for-review` when the first eight criteria pass on one committed head with their receipts (a terminal capture
or a screenshot each; for the fifth and sixth a side-by-side shot of the site and the paste mid-slide) under
`~/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/builder/`, the whole unit, browser and web suites compared
with Task 1's tallies by test name, and the ledger committed. The builder's report lists the rulings it made, every
pinned test it edited with its proof, the live criterion as owed to Justin, and
`skill_lessons[{skill, lesson, evidence, enforce}]`.
