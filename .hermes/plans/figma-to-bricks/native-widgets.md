# native-widgets: Bricks' own elements instead of Code, wherever Bricks has one (plan, 2026-11-13)

Planner: native-widgets (Fable 5.2, high). Pipeline: **Full**. Website importer rules apply (repo CLAUDE.md: one
real-bug review per job, edge cases to follow-ups).
**Base: `main` once the jobs in flight have merged**: site-no-div, site-shared-styles, plugin-parity, importer-parity
and shared-palette (and any of bricks-icons-site, short-class-names, look-grouping, clean-values and
fewer-kept-boxes that merge before this build starts). Today `main` is `7f54b0a5` (Build 2026-11-12.3). Every importer
file:line below is from `importer-parity-build` `33a73f41` (the newest importer head: site-no-div's build and
site-shared-styles' fix 1 `7b7501bd` are under it; the planner's tree `~/.cache/nw-pl/ip`), every plugin file:line
from `plugin-parity-build` `fcdec6e2` (`~/.cache/nw-pl/pp`). The builder re-reads every line on its real base before
editing (Task 1).
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/native-widgets/planner/` (`README.md` lists every
file). Plan copy for the repo: `docs/plans/<build date>-native-widgets.md` (the builder copies this file there in
Task 1).

## Playback

1. Some things in a paste arrive as Code elements: another company's widget (the reviews carousel), the script that
   slides the ☰ menu's "Services" list, and on the Figma plugin's side the scripts for card arrows, searchable lists,
   maps and the header spacer. A Code element needs "Regenerate code signatures" and doesn't run in Bricks' editor.
2. You asked for these to be built with Bricks' own elements wherever Bricks can do the same thing, so the paste reads
   like a Bricks pro built it, and for whatever must stay Code to be labelled and named in the notes.
3. Everything must still look and behave as it does today: the importer one to one with the old site, a Figma design
   exact at its design width, and every paste this job doesn't touch byte for byte as before.

## Questions (⭐ = the answer the standing auto-go takes; Justin's "go with recommended")

All ⭐ answers are the planner's rulings from research (Justin was asleep; none is confirmed).

1. **The menu's sliding list.** ⭐ **A:** it becomes Bricks' **Accordion (Nestable)**: the slide's time sits in the
   Accordion's own "Transition" box, no Code element, no code signature, and it shows in the Structure panel as
   Accordion › Item › Title / Content. Measured on your own scan: nothing moves (0 px, closed and open) and the slide
   is the same (same time, same curve, same height a quarter, half and three quarters of the way, opening and
   closing), with Bricks 2.3.9 and 2.4.2. Three small differences, all Bricks' own accordion behaviour: (a) pressing
   the title a second time while the list is still sliding shows the list whole for a moment before it closes (your
   FAQ accordions in Bricks do the same; the old site turns back smoothly); (b) the browser's "find in page" no longer
   opens a closed list; (c) the title is announced as a button. B: keep the script in a Code element (as today).
2. **Which sliding lists.** ⭐ **A:** a box that holds nothing but sliding lists with one timing, each list a title
   and one box (every Elementor "Nested Accordion", B-Dry's menu included). Any other sliding list (one sitting
   between plain links in its box, lists with different timings in one box) keeps today's script, and the notes say
   why. B: also turn a list that sits between other things into its own one-item Accordion (two extra Blocks per
   list): a later job if a site needs it.
3. **One list open at a time, or each alone.** ⭐ **A:** each alone (the Accordion's "Independent toggle" ticked), as
   today's paste and as a plain browser list behave. B: read from the old site whether opening one closes the others
   (needs a new scan step): later.
4. **Reduced motion** (a visitor who asked their device for less motion). ⭐ **A:** the list opens and closes at
   once, as today's script does, through one line of CSS on the Accordion's class. B: Bricks' default (it slides for
   everyone).
5. **Another company's widget (the reviews carousel).** ⭐ **A:** it stays a Code element: its reviews come from its
   own server through its own script, which no Bricks element can stand in for. It is labelled "Widget" and the notes
   name it and its company. B: paste the reviews as they were on the scan day as Bricks elements (editable, no code,
   but frozen: new reviews never appear).
6. **Embedded frames (a Google map), both tools.** ⭐ **A:** they stay Code. Bricks allows no `iframe` tag on its
   elements, and Bricks' own Map element needs a Google Maps key typed into Bricks' settings. B: Bricks' Map element
   for sites with a key: later, if you want it.
7. **The Figma plugin's card arrows and carousel controls.** ⭐ **A:** they stay as today (the row scrolls sideways by
   itself; a small script makes the drawn arrows move it), and the notes now say so (they didn't). Bricks could only
   do this by turning the whole sideways row into its Slider, which would replace your "Sideways scroll" decision
   (2026-10-08) and the "runs on to the window's edge" one (2026-11-02): a slider steps slide by slide and doesn't
   scroll freely. B: rebuild such rows as Bricks' Slider (Nestable): its own job ("strip-slider"), after you see both
   side by side.
8. **The Figma plugin's header spacer** ("Measure my header", your 2026-10-20 choice). ⭐ **A:** stays a script:
   Bricks has no setting that knows how tall your header is (its Sticky header floats over the page and gives no
   height). B: a panel choice "my header takes its own room" that leaves the spacer out: later, if you want it.
9. **The Figma plugin's searchable lists.** ⭐ **A:** stay a script ("In the page", your 2026-10-19 decision; Bricks'
   own filters need WordPress posts). The notes now say so (they didn't).
10. **Scans you already have.** ⭐ **A:** they paste as today. The list becomes an Accordion on a scan made with Build
    2026-11-11.6 or later (the build that records the slide); your saved 11 November scan is older.

## What you will see (measured)

- **B-Dry's header paste** (`<P>/proto-bdry.log`, your saved scan with the slide the live site plays filled in): the
  ☰ menu's "Services" is one Accordion (Nestable); the paste holds one Code element fewer (6 → 5; the 5 left are the
  SVG drawings the job bricks-icons-site turns into Icons). At 390 and 768 wide, with Bricks 2.3.9 and 2.4.2: every
  drawn element under the list is where today's paste draws it (10 elements closed, 32 open, worst difference 0 px);
  the list is 136 / 211.5 / 287 px tall at a quarter, half and three quarters of the slide in both pastes, opening
  and closing; no script error.
- **What stays Code on B-Dry's home** (importer, `--elementor`, newest head; `<P>/inventory.md`): 36 Code elements
  today: 22 SVG drawings (bricks-icons-site), 12 form fields (importer-parity's Form step, or named there), 1 widget
  (Trustindex reviews) and 1 Google map frame. After the jobs in flight and this one, with `--svg`: the widget, the
  map, and any form importer-parity refuses.
- **The Figma plugin** (five real files, `<P>/inventory.md`): at most 2 Code elements a page (a map, a list's script,
  card arrows, the header spacer). None can be a Bricks element without changing a decision of yours (Q6 to Q9), so
  the plugin's pastes don't change by a byte; two of its scripts get the note they lacked.

## Inventory: every Code element both tools make today

Importer (the code method: `npm run site`, `site:upload`, `site:import`; `src/core/site/`):

| # | What | Made at | Bricks' own way | This job |
|---|---|---|---|---|
| I1 | the script sliding a list in a box a button opens (site-menu-motion) | `open-paste.ts:58-75`, `slide.ts` | Accordion (Nestable): `transition`, `independentToggle` | **rebuilt** (section A); refused shapes keep the script, labelled and named |
| I2 | another company's widget pasted live (site-reviews) | `kinds.ts:83`, `live.ts`, `convert.ts:317` | none (its content comes from its server) | stays Code, labelled "Widget", named |
| I3 | an `svg` drawing | `kinds.ts:117`, `markup.ts` | Icon (media library) | job bricks-icons-site (`--svg`); else stays, counted |
| I4 | a form field (`input`, `select`, `textarea`) | same | Form | importer-parity (simple forms); else stays, counted |
| I5 | `video`, `audio` | same | Video | importer-parity; else stays, counted |
| I6 | `iframe`, `object`, `embed` (a map, a booking frame) | same | none without a key | stays Code ("Embed"), counted |
| I7 | `canvas` | same | none | stays Code, counted |

Already Bricks' own on the importer (no Code): menus and pop-ups (Offcanvas + Interactions, site-menu), entrances
(Interactions, site-motion), Elementor carousels (Slider), Elementor and ElementsKit FAQs (Accordion), the sticky
header (a class).

Figma plugin (`src/core/understand`, `src/core/emit/elements.ts:139-147`):

| # | What | Made at | Bricks' own way | This job |
|---|---|---|---|---|
| P1 | card arrows and a strip's controls | `understand/arrows.ts:77`, `emit/arrows.ts` | only by making the strip a Slider (Q7) | stays; note added |
| P2 | a list's search and filters | `understand/lists.ts:277`, `emit/lists.ts` | none without WordPress posts (Q9) | stays; note added |
| P3 | a live Google map | `understand/node.ts:55`, `emit/maps.ts` | Map needs a key (Q6) | stays (note exists, `understand/maps.ts:8`) |
| P4 | the site header room | `understand/room.ts:17`, `emit/room.ts` | none (Q8) | stays (note exists, `room.ts:10`) |
| P5 | a captured page's widget (the panel's website route) | `understand/embeds.ts:11` | none | unchanged (notes exist, `embeds.ts:21-25`) |
| P6 | a captured page's floating widget (same route) | `understand/floating.ts:39` | none | unchanged (notes exist, `normalise/floating.ts:24-31`) |

Counts on real input (`<P>/inventory.md`; scripts `<P>/count-code.mjs`, `count-plugin.mjs`):

| Paste | Code elements |
|---|---|
| B-Dry home, importer `--elementor`, newest head | header 5 (SVG) · page 23 (11 SVG, 12 fields) · footer 8 (6 SVG, 1 widget, 1 map frame) |
| the same, plain route | header 5 · page 25 · footer 8 |
| B-Dry header with a slide recorded (a re-scan) | + 1 list script → 0 with this job |
| hydraulics, Repairs (plugin) | 1 map (with the header left out: 1 header room) |
| Services (plugin) | 1 list script + 1 map |
| brainstorm (plugin) | 1 card arrows (+ 1 header room with the header left out) |
| GRO (plugin) | 0 (1 header room with the header left out) |

## The design

### A. A sliding list becomes Bricks' Accordion (Nestable) (importer; I1)

**The rule (general; nothing names Elementor, a site or a menu).** Inside a box a button opens, a box L becomes one
Accordion (Nestable) when all of this holds; otherwise every sliding list in it pastes as today (its `details`, its
marker, the script) and the part's notes say why, once per box:

- R1. Every element child of L is a `details` (no words beside them), and L isn't inside another sliding `details`.
- R2. Every one of them has a slide the paste can carry (`slide.ts` `usable`) and they all have the same one.
- R3. The slide is one CSS can play: its effect easing or its first keyframe's easing is `linear` (the other is the
  curve; both `linear` → `linear`). Both set to another curve: refused.
- R4. Each `details` holds exactly its `summary` (first) and one box, no words beside them.
- R5. The site sets the summary's own `display` at every kept range (so the browser's triangle isn't drawn: a
  `summary` left `list-item` would lose its triangle as a Block).

**The shape** (Bricks' own: `ExampleBricks` line 7 and README "`accordion-nested`"; the two settings from Bricks 2.2's
`includes/elements/accordion-nested.php` L53-63 and L366-387 (`<P>/../../site-faq/planner/staging/accordion-nested-2.2.php`)
and Bricks' 2.4.4 element schema (`<P>/schema/accordion-nested.json`)):

```
Accordion (Nestable)   was L          settings: { transition: "<ms>", independentToggle: true }
  Block "Item"         was the details  (its own class; no tag)
    Block "Title"      was the summary  (its own class; no tag; _hidden._cssClasses: "accordion-title-wrapper")
    Block "Content"    new, Bricks' own (no class; _hidden._cssClasses: "accordion-content-wrapper")
      …                the details' one box and everything in it, unchanged
```

- `transition` is the slide's duration as a string of a number (number controls are strings in the samples);
  `independentToggle` is written only as `true` (Bricks reads it with `isset()`, L369-373).
- L keeps its own class and takes two shared ones: `site-accordion` (the FAQ's, unchanged: it shows and hides the
  Content under the site reset) and one class per distinct timing, made as `stay.ts` makes the stay class
  (`versioned`), holding only what Bricks has no control for:
  ```css
  .<slide class> > * > .accordion-content-wrapper { transition-timing-function: <curve>; }
  @media (prefers-reduced-motion: reduce) { .<slide class> > * > .accordion-content-wrapper { transition-duration: 0s !important; } }
  ```
  The first line is left out when the curve is `ease` (the browser's own for a transition). The class's name follows
  the naming in force on the base (today `<page>__list-slide-<4>`; short-class-names' rule if it merged).
- Why a new "Content" Block: Bricks' accordion script sets the content wrapper to `display: block` when it opens
  (`bricks.min.js` `bricksAccordionFn`, the same text in 2.3.9 and 2.4.2: `<P>/../../site-faq/planner/staging/same-js.txt`).
  B-Dry's list is a flex column with a 20 px gap, which would lose its gaps as the wrapper itself. Bricks' own default
  Accordion has the same Block; it is Bricks' wrapper (as an Offcanvas's "Content"), never a site element (sources
  don't name it; its id hashes `<id prefix><details path>:content`).
- The site's `role="region"` on the box inside is left off (Bricks gives its Content wrapper that role); the summary's
  names stay but the ones Bricks' title owns (`role`, `tabindex`, `aria-expanded`), as importer-parity's names rule
  already does for an Accordion's titles.
- The `details` gets no marker class and the box's Offcanvas no Code element for these lists; the part's notes take
  no signing line from them.

**Where it is built.** As picks in `prepare` (`convert.ts`, where `extra.open` is set and before `foldBoxes`), so the
fold and every later step leave the list's elements alone, as they leave an FAQ's:

- new `src/core/site/list-accordion.ts` (pure, about 120 lines): `listAccordions(code, pr, root): { picks: Map<string,
  TreePick>; lists: Array<{ list: string; items: string[]; slide: CodeSlide; curve: string }>; refused: Array<{ box:
  string; why: string }> }`. Picks: L `{ name: "accordion-nested", settings: { transition, independentToggle: true },
  role: "accordion", shared: [SITE_ACCORDION, <slide class>], bare: true }`; each details `{ name: "block", settings:
  {}, role: "item", bare: true, rest: { hidden: "accordion-content-wrapper", label: "Content" } }`; each summary `{
  name: "block", settings: {}, role: "title", hidden: "accordion-title-wrapper", bare: true }` (a summary of words
  keeps its words as one Rich Text, as a title of words does today, without its tag).
- `tree.ts`: `TreePick.rest?: { hidden: string; label: string }`: the element's children after its first are emitted
  inside one Block of Bricks' own (`site: false`, no class, the `_hidden` class and the label given).
- `slide.ts`: `cssCurve(s): string | null` (R3), `listSlideClass(page, s)`, and the notes below.
- `open-paste.ts`: `slides()` is false for a `details` an Accordion took (so no marker, no Code element, no reserved
  id for them); the notes below.
- `natives.ts` `ROLES`: `content: "Content"` (and "Item", "Title" as today).

**Notes** (per part, plain words):
- taken: `<k> list(s) slide open and closed as on the site through Bricks' own Accordion (Nestable): change the time in its Transition box (<ms> ms)`
- refused, after today's script line: `a sliding list keeps its script: <why> (<box path>)`, with why one of: "it sits
  beside other things in its box", "the lists in its box slide with different timings", "a list in its box doesn't
  slide", "its slide's curve can't be written as one CSS curve", "it holds more than a title and one box", "its
  title shows the browser's own triangle".

**Known differences from today's script** (HANDOFF names them; Q1): a second press while the list still slides shows
it whole until the first press's time is up, then it closes (`<P>/probe-second-press.log`: 240 px from 400 to 600 ms
where the script glides 85 → 59 px); find-in-page doesn't open a closed list; a list's own open look (its icon turned
or swapped) is still not read by the scan, as today (a follow-up: "the open look of a sliding list").

**Proven before the build** (`<P>/README.md`): probe 1 (`probe-accordion.ts`, `.log`, `-ease-out-250.log`): the
script's Web Animations slide and Bricks' accordion with the planned settings and CSS give the same heights at 25 /
50 / 75 %, opening and closing, for 400 ms linear and 250 ms ease-out, with Bricks' 2.3.9 script and B-Dry staging's
saved 2.4.2 script; a second list stays open; under reduced motion both open at once. Prototype 2 (`proto-bdry.ts`,
`.log`, `header-today.json`, `header-planned.json`): the numbers under "What you will see".

### B. What stays Code, and why (both tools)

| Kind | Why no Bricks element can stand in (source) |
|---|---|
| another company's widget | its content comes from its own server through its own script (site-reviews Q1 A; `snapshot/embed-code.ts`) |
| an embedded frame | Bricks allows only WordPress's post tags as an element's tag, and `iframe` isn't one (Bricks 2.2 `includes/helpers.php` L3482-3496: `wp_kses_allowed_html( 'post' )`; `<P>/bricks-2.2/helpers.php`); Bricks' Map prints only with a Google Maps key in Bricks' settings (`map.php` L35-37, L67-77; `<P>/bricks-2.2/map.php`), Map (Leaflet) needs coordinates neither tool has (`map-leaflet.php`); the deprecated HTML element isn't offered (`html.php` L11) |
| the plugin's card arrows | Bricks' Interactions scroll only the window, up and down (`bricks.min.js` 2.3.9 `case"scrollTo"`: `window.scrollBy(0, …)`); a Slider would replace the sideways row (Q7) |
| the plugin's list script | Bricks' filters work on a query of WordPress posts; the rows live in the page (2026-10-19) |
| the plugin's header room | Bricks' Sticky header is `position: fixed` with no height variable (`frontend-light-layer.min.css` 2.3.9: `#brx-header.brx-sticky{…position:fixed…}`; no `header-height` in `bricks.min.js`) |
| a Code element itself | prints its code only signed (`code.php` L176-199: without a valid signature it prints an error box; without `executeCode` it prints the code as text, L324-331; `<P>/bricks-2.2/code.php`) |

### C. Labels and notes (importer)

- **Labels.** A live widget's Code element is labelled "Widget" on both routes (today the Elementor route labels it
  after Elementor's widget type, "HTML" on B-Dry: `elementor-fold.ts:378`, the label winning over `natives.ts:64`). A
  list's script that stays is labelled "List slide (script)" (today it has none: `open-paste.ts:73`). SVG, Field,
  Embed, Video, Audio and Drawing stay as site-no-div labels them (`natives.ts:53`).
- **One line per part**, written where the part's notes are assembled (`parts.ts:168-206`) as the part's last line
  (so no test that reads a line's neighbours moves: `site-slide.test.ts` reads the signing line right before the slide
  note), counting every Code element of the part's final payload by kind:
  `Code: <n> Code element(s) Bricks has no element of its own for: <list>. Each needs Regenerate code signatures (Bricks → Settings → Custom code) and shows only on the live page and in Preview, not in Bricks' editor`
  with the list in a fixed order, kinds with none left out: `<k> widget(s) of another company (<hosts>)`, `<k>
  embedded frame(s) (<hosts>)`, `<k> list slide script(s)`, `<k> drawing(s) (SVG)`, `<k> form field(s)`, `<k>
  video(s) or audio`, `<k> canvas drawing(s)`. A part with no Code element has no such line.

### D. The Figma plugin

No paste changes. Two notes are added where the scripts are planned, in the words of the map's and the spacer's:
- card arrows (`understand/arrows.ts`, once per strip): `"<strip's label>": its arrows move the row through a small script (a Code element, "Card arrows"); Bricks has no setting that scrolls a sideways row. After pasting, run Bricks → Settings → Custom code → Regenerate code signatures, or the arrows do nothing (the row still scrolls by hand)`
- a list (`understand/lists.ts`, once per list): `"<list's name>": its search and filters work through a small script (a Code element, "List search and filters"). After pasting, run Bricks → Settings → Custom code → Regenerate code signatures, or they do nothing`

### E. The test renderer and the Bricks reference

- `test/browser/render.ts` (L259, where `data-expand-item` is printed): on the site route an accordion also prints
  `data-script-args="independentToggle"` and `data-transition="<value>"`, in Bricks' order (after `data-expand-item`;
  `accordion-nested.php` L366-387), each only when its setting is set. A paste without them prints as today.
- `reference/bricks/`: `accordion-nested-schema.json` (Bricks' 2.4.4 element schema, sha256 `0275285216a6…04981db`, as
  `slider-nested-schema.json` was added); `frontend-2.4.2/accordion-fn.js` (the accordion function cut from B-Dry
  staging's `bricks.min.js`, sha256 `628ecaeb…adf02`, from `bricksAccordionFn=new BricksFunction(` to `function
  bricksAccordion(){`), its line in that folder's `SHA256SUMS`; README "`accordion-nested`" gains the two settings with
  their source lines and "a slide's time is `transition`; its curve has no control".

## The standard, point by point ("built like a skilled Bricks builder made it by hand")

1. **Structure.** A list that opens is Bricks' Accordion (Nestable) with Bricks' own Item › Title / Content, as its
   default Accordion and Justin's FAQ are built; no Div; the one new Block is Bricks' own wrapper and does a job (it is
   what Bricks slides). Every Code element left is labelled by what it is.
2. **Classes.** Items and titles keep the classes they have; lists with the same slide share one class for it;
   `site-accordion` is the class FAQs already share. The slide class writes only the Content's
   `transition-timing-function` (and its duration under reduced motion); the Content Block has no other class, so no
   two classes write one property.
3. **Settings before custom CSS.** The slide's time is the Accordion's Transition setting, "each alone" its
   Independent toggle. Only the curve and the reduced-motion line are custom CSS (Bricks has no control for either),
   two short lines on the class that owns them.
4. **Bricks' own behaviour.** This job's point: the one script Bricks can replace is replaced. What stays Code is a
   third-party widget, a frame Bricks has no element for, and three plugin scripts with no Bricks equivalent short of
   reversing a decision (Q7 to Q9, each named with its source in section B). **Where it isn't met:** the plugin's card
   arrows could be a Slider; that is Q7 B, Justin's to decide.
5. **Editable content.** The title's words stay in their text field, the links in Link to; the slide's time is typed
   in the Accordion's Transition box and takes effect (the proof test changes it to 1000 and measures 1000 ms).
   Nothing a person would look for in a field is put in CSS.
6. **Looks stay true.** 0 px on B-Dry's menu, the same slide at every measured point. Where exact and clean conflict
   the paste stays exact: a list the rule can't prove keeps its script; the three small differences of Q1 are named
   in HANDOFF and the notes say the list is an Accordion.

## What this plan assumes from the jobs in flight (shared files)

| Job (state) | Shared files | What this plan assumes or does |
|---|---|---|
| site-no-div (`site-no-div-fix3`, moving onto main) | `natives.ts`, `convert.ts`, `tree.ts`, `fold-boxes.ts`, `labels.ts` | no Div; every Block and Code element labelled (`nativeLabel`, `ROLES`); `foldKeep` leaves `picks.choice` alone. This job adds a role label and two Code labels |
| site-shared-styles (`site-shared-styles-fix1` `7b7501bd`) | `classes.ts`, `convert.ts`, `looks.ts`, `share.ts`, `parts.ts` | shared classes and `palette.json`; a class family is named through `classes.ts` by a fingerprint of its rules. The slide class is such a class; `site-accordion` is unchanged |
| importer-parity (builder running, `importer-parity-build`) | `elementor-accordion.ts`, `convert.ts`, `tree.ts`, `natives.ts`, `names.ts`, `parts.ts`, `parity-notes.ts`, `test/browser/render.ts` | its section D makes `details` lists **in the page** Accordions and "refuses a list inside an opened box" (its Q6 A, K3): this job is the opened-box half and adds no rule for the page. If its Task 13 landed `accordionShape` taking a path, the builder reuses its picks where they fit; its names rule drops `role`, `tabindex`, `aria-expanded` on an Accordion's titles; its `Natives:` note line may count this Accordion (the builder adds it there if the line exists) |
| plugin-parity (builder running), shared-palette | none in `src/core/site`; `understand/labels.ts` (plugin-parity) | this job's plugin side adds two warnings and one test; it touches `understand/arrows.ts`, `understand/lists.ts` only for the notes |
| bricks-icons-site (planned) | `kinds.ts`, `markup.ts`, `parts.ts` | turns I3 into Icons with `--svg`; the `Code:` line simply counts what is left |
| short-class-names (planning) | `classes.ts`, `slide.ts` | renames made-up names; the slide class takes whatever rule is in force on the base |
| fewer-kept-boxes (planning) | `fold-boxes.ts`, `elementor-fold.ts` | may fold the boxes around a list; a list's box and items are picks, which a fold never removes. If it merges first, the builder checks AC1's fixture still has its box |
| site-menu-motion (merged, Build 2026-11-11.6) | `slide.ts`, `open-paste.ts`, `test/unit/site-slide.test.ts`, `test/web/site-slide-proof.test.ts` | its fixture `site-slide` (lists beside other things) is this job's refused case: its payloads are the base's but the script's label, its notes gain the reason line and the `Code:` line |

Order: after site-no-div, site-shared-styles and importer-parity (same files). Independent of plugin-parity,
shared-palette, look-grouping and clean-values. With bricks-icons-site either order (the second to merge re-runs its
pins).

## Acceptance criteria (all **proposed**)

Each line is one criterion with its one test. "The base" is the merge-base commit the build starts from. "Drawn" means
`renderSitePaste` on the site route with Bricks' own CSS and script (`test/web/lib/site-check.ts`).

- AC1 (proposed): Given a hand-made capture whose opened box holds a box of two `details` with one usable slide (400 ms linear), each a summary whose display the site sets and one flex-column box, on both routes and both text modes: the box pastes as one `accordion-nested` whose settings hold `transition: "400"` and `independentToggle: true` (both keys and value types found in `reference/bricks/accordion-nested-schema.json`), carrying `site-accordion` and one slide class whose CSS is the two lines of section A; each `details` is a Block labelled "Item" with no tag, each summary a Block labelled "Title" with `accordion-title-wrapper` and no tag, the rest inside one Block labelled "Content" with `accordion-content-wrapper`, no class and no entry in the sources; no element carries a slide marker, the box's Offcanvas holds no Code element, the part's notes hold the Accordion line, no slide-script line and the signing line only where the part holds another Code element, and `payloadProblems` is empty. Test `test/unit/site-list-accordion.test.ts` "a box of sliding lists pastes as one Accordion (Nestable) with the site's timing and no Code element".
- AC2 (proposed): Given each refused shape (a list beside other elements in its box, as the `site-slide` fixture's menu and drawer; two timings in one box; a list without a slide in the box; both easings non-linear; a `details` holding two boxes or words beside its box; a summary with no display set; a list box inside another sliding list), the paste holds no `accordion-nested`: every sliding list is still its `details` Block carrying its timing's marker, its box's Offcanvas holds one Code element labelled "List slide (script)" whose script lists exactly those markers with their timings, and the part's notes hold today's slide line and one `a sliding list keeps its script: <why> (<box path>)` line with that shape's reason. Test `test/unit/site-list-accordion.test.ts` "a sliding list the rule refuses pastes as before and its notes say why".
- AC3 (proposed): Given the new fixture site `site-slide-list` (a ☰ pop-up holding a box of two lists sliding 400 ms with no easing given, and a footer drawer holding a box of one list sliding 300 ms ease-out), captured and pasted on both routes, drawn at 1440 and 390 with Bricks 2.4.2 and 2.3.9: with each menu open, every drawn element under each list is within 0.5 px of the site's own page, lists closed and open; pressing a title (a click, and Enter on the focused title) starts one CSS transition on that item's Content Block with the site's duration and curve, and the item's height at 25, 50 and 75 % of it is within 0.5 px of the site's list at the same points, opening and closing; the second list stays open while the first opens; under reduced motion the list opens and closes with no running animation; with the Accordion's `transition` changed to "1000" in the payload the same slide lasts 1000 ms; no script error is thrown and Escape still closes the menu, which opens again with its lists usable. Test `test/web/site-list-accordion-proof.test.ts` "the lists slide open and closed as on the site through Bricks' own Accordion".
- AC4 (proposed): Given Justin's scan (`F2B_BDRY_CAPTURE`; where the scan predates the slide record, its menu list's slide filled in as 400 ms linear, the live site's own, and the test says so), pasted with `--elementor`: the header's paste holds exactly one `accordion-nested` under the menu's Offcanvas and no Code element with a script; drawn at 390 and 768 with Bricks 2.4.2 and 2.3.9 beside the base tree's paste of the same input (`F2B_BASE_TREE`), every drawn element under the list is within 0.5 px, closed and open, and the list's height at 25, 50 and 75 % of the slide is within 0.5 px, opening and closing. Test `test/web/site-list-accordion-bdry.test.ts` "B-Dry's Services list is one Accordion that draws and slides as the script paste does".
- AC5 (proposed): Given a payload whose `accordion-nested` holds `expandItem`, `independentToggle: true` and `transition`, the site route prints `data-expand-item`, `data-script-args="independentToggle"` and `data-transition` on it in that order, and a payload without the two new settings prints exactly the HTML the base prints; and `reference/bricks/frontend-2.4.2/accordion-fn.js` equals, character for character, the same cut of `reference/bricks/frontend-2.3.9/bricks.min.js`. Test `test/browser/render-site-accordion.test.ts` "the site route prints an accordion's Transition and Independent toggle as Bricks does and 2.4.2's accordion script is 2.3.9's".
- AC6 (proposed): Given every hand-made code capture and this job's fixtures (both routes, both text modes, every part): every Code element is one of the inventory's kinds (a live widget, a list slide script, or markup of a tag `natives.ts` names), has a label that says what it is ("Widget" for a live widget on both routes, "List slide (script)" for the script), and its part's notes hold exactly one `Code:` line whose count equals the part's Code elements and whose kinds and hosts match them; a part with no Code element has no `Code:` line. Test `test/unit/site-code-inventory.test.ts` "every Code element of a site paste is labelled by what it is and counted in its part's notes".
- AC7 (proposed): Given every Figma fixture that makes a Code element and the five real design files, with the header and footer ticks off and on: every Code element comes from exactly one of the six named kinds (card arrows, a list's script, a map, the header room, a captured widget, a captured floating widget), has a non-empty label, and the warnings hold that kind's own note with the signing step (the map's, the header room's and the captured widgets' as today; the card arrows' and the list's of section D), one per strip, list, map and page. Test `test/unit/emit-code-inventory.test.ts` "every Code element of a Figma paste is a named kind with its label and its note".
- AC8 (proposed): Given every hand-made code capture the base's pin lists hold (`test/unit/lib/site-pins.ts` and the lists beside it), this job's refused shapes (built with this tree's fixtures, converted by both trees), the saved fixture-site captures and Justin's saved scan as it is (no slide record), on both routes: each part's payload is byte-identical to the base's except, where the part holds one, a live widget's Code element's label on the Elementor route and a staying slide script's label; and each part's notes are the base's plus the `Code:` line and, where a box holds refused sliding lists, that box's reason line. Test `test/unit/native-widgets-site-pins.test.ts` "every site paste without a list the rule takes is byte for byte the base's but its Code labels" (a story pin: it runs with `F2B_STORY_PINS=1` and `F2B_BASE_TREE`; a skip is never a pass).
- AC9 (proposed): Given the five real design files and every Figma fixture, with the ticks off and on, and the panel's website route on its fixture captures: every payload is byte-identical to the base's, and the warnings are the base's plus exactly the card-arrows and list notes of section D, one per strip and list that has the script. Test `test/unit/native-widgets-figma-pins.test.ts` "every Figma payload is byte for byte the base's and the warnings gain only the Code notes" (a story pin, as the one above).
- AC10 (proposed) (live): Justin scans bdryswi.com with this build (`npm run site:import -- https://bdryswi.com <his staging address> --elementor`) and pastes the header on B-Dry staging. In Bricks' Structure panel the ☰ menu's Offcanvas holds "Accordion (Nestable)" › "Item" › "Title" and "Content"; the header's notes list no list slide script; on the live page at phone width "Services" slides open and closed as on bdryswi.com (the header's drawings still need Regenerate code signatures until bricks-icons-site; the list doesn't); he changes the Accordion's Transition from 400 to 1000 in Bricks, saves, and the list slides more slowly (a Bricks pro's edit does what it should); the footer's reviews are a Code element labelled "Widget" that shows once signatures are regenerated. The plugin's pastes don't change, so no darksalmon paste is owed. HANDOFF paste check: the next free id at the merge.

## Touched files (paths on the newest heads; the builder re-reads them on the base)

New: `src/core/site/list-accordion.ts`; `test/unit/site-list-accordion.test.ts`, `site-code-inventory.test.ts`,
`emit-code-inventory.test.ts`, `native-widgets-site-pins.test.ts`, `native-widgets-figma-pins.test.ts`;
`test/web/site-list-accordion-proof.test.ts`, `site-list-accordion-bdry.test.ts`; `test/fixtures/web/sites/site-slide-list/`
(`index.html`, `style.css`, `popup.js`, `drawer.js`, `slide.js`: `site-slide`'s scripts, its lists inside a box of their
own); `test/fixtures/site-list-code.ts` (the hand-made captures of AC1 and AC2, built on `site-opens-code.ts` as
`site-slide.test.ts`'s `drawerWithLists` is); `reference/bricks/accordion-nested-schema.json`,
`reference/bricks/frontend-2.4.2/accordion-fn.js`.

Changed: `src/core/site/slide.ts` (the curve, the slide class, the notes), `tree.ts` (`TreePick.rest`), `convert.ts`
(the finder for an opened box; a live widget's label; what `Prepared` carries of the lists), `open-paste.ts` (no
marker or script for a taken list; the script's label; notes), `natives.ts` (`ROLES`), `classes.ts` (the slide class
beside the stay class), `parts.ts` (the `Code:` line), `parity-notes.ts` (only if its `Natives:` line exists);
`src/core/understand/arrows.ts`, `lists.ts` (the two notes; `planArrows` needs the page's warnings);
`test/browser/render.ts` (two attributes); `reference/bricks/README.md`, `reference/bricks/frontend-2.4.2/SHA256SUMS`;
`test/unit/bricks-shapes.test.ts` only if it lists allowed accordion keys for the site route; `docs/HANDOFF.md`, the
plan copy and the ledger.

Not touched: `src/web/` (the scan is unchanged: no new capture field), `src/ui/`, `src/plugin/`, `emit/` (no payload
change on the plugin side), the uploader (`tools/lib/site-upload/`), and `test/web/site-slide-proof.test.ts` (it pins
the refused case in Chrome and must pass unchanged).

**Tests that pin what this job changes** (the builder may edit only these, each with stronger assertions of the new
behaviour, and names every one in the ledger): `test/unit/site-slide.test.ts`, only its `withoutSlides` helper
(L144-170), which must also take out this job's two note lines (the box's reason line and the part's `Code:` line) and the
script's label before its "only the new things differ" comparison (L187), with one added assertion that both lines are there; every
other assertion of that file passes as it is (the signing line stays right before the slide note); any test asserting
a live widget's Elementor-route label; any sum of
a saved capture whose Elementor-route paste holds a live widget (`test/unit/site-slider-unchanged.test.ts`'s
`code-page` sums and the like: remade only after proving, per variant, that the paste with the label put back hashes
to the old sum); tests asserting a part's whole notes list where a Code element is present (they gain the `Code:`
line); Figma tests asserting a whole warnings list of a design with a list or card arrows.

## Tasks (test first; one commit a task, each green; a ledger in `.superpowers/sdd/native-widgets/progress.md`)

### M0: the base

**Task 1.** Copy this plan to `docs/plans/`; re-read every file:line above on the base and note what moved in the
ledger; run `npm run check`, `npm test` (the tally by test name), `npm run corpus` (on this desktop: replay the two
repo corpus files and the three debug files instead, memory `corpus-paths-on-desktop`); make a `git archive` of the
base under `~/.cache/nw-b/base` for the two story pins and AC4. Record the base's pastes of Justin's scan, both routes.
**Stop condition:** importer-parity, site-no-div or site-shared-styles not on the base → stop and report.

### M1: the sliding list (importer)

**Task 2 (the fifth criterion: the renderer and the reference).** RED: the new test in
`test/browser/render-site-accordion.test.ts`. GREEN: `render.ts` prints the two attributes; add
`accordion-nested-schema.json` (from `<P>/schema/`), `frontend-2.4.2/accordion-fn.js` (cut from
`~/.hermes/plans/figma-to-bricks/evidence/site-faq/planner/staging/bricks-2.4.2.min.js`, the cut's bounds in a comment
of the test), `SHA256SUMS`, the README lines. Grep `test/unit/render.test.ts` for anything the change removes (it
removes nothing).

**Task 3 (the first criterion: the shape).** `test/fixtures/site-list-code.ts`; RED: AC1's test (the box still pastes
`details` with markers and a script). GREEN: `tree.ts` `rest`; `list-accordion.ts`; `slide.ts` `cssCurve`,
`listSlideClass`; the finder called in `prepare` for an opened box, its picks joined to `picks.choice` before the
fold; `open-paste.ts` skips taken lists; the Accordion note. Prove the test catches it: with the fix committed,
`git checkout HEAD~1 -- src/core/site/convert.ts src/core/site/open-paste.ts`, see the test fail, then `git checkout
HEAD -- src/core/site/convert.ts src/core/site/open-paste.ts`.

**Task 4 (the second criterion: the refusals).** RED then GREEN per refused shape, one fixture variant each; the
reason notes; the script's label. The `site-slide` hand-made capture (`site-slide.test.ts`'s `drawerWithLists`) is
one of the cases: that file passes with only its `withoutSlides` helper changed as "Tests that pin" says.

**Task 5 (the third criterion: Chrome).** The fixture site `site-slide-list`; the proof test, written as
`site-slide-proof.test.ts` is (its `hold` reads a CSS transition here: `a.transitionProperty === "height"` on the
Content Block; `<P>/proto-bdry.ts` `HOLD` is the proven reader). Both routes, 1440 and 390, Bricks 2.4.2 and 2.3.9.
Pictures of the open menu with a list half-way, site beside paste, into the evidence folder. **Stop condition:** a
drawn element more than 0.5 px off that isn't the fixture's own fault → that shape joins the refused ones (R-rule
added, named in HANDOFF), never a wider tolerance.

**Task 6 (the fourth criterion: Justin's scan).** The env-gated test on the read-only copy
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json` (never `~/Downloads`),
filling the slide as `<P>/proto-bdry.ts` does and saying so in its name's log line; base tree from Task 1.

### M2: what stays Code is labelled and named (both tools)

**Task 7 (the sixth criterion: importer).** RED: `site-code-inventory.test.ts`. GREEN: the live widget's label on the
Elementor route; the `Code:` line in `parts.ts`. Then `npm test` whole: every sum or note assertion that moved is
listed in the ledger with its proof (label put back → old sum).

**Task 8 (the seventh criterion: plugin).** RED: `emit-code-inventory.test.ts` (card arrows and lists have no note).
GREEN: the two notes. `npm run check`; `test/unit/plugin-convert.test.ts` and `sandbox-convert.test.ts` pass (no
payload change; the notes are built-ins only).

### M3: pins, gates, records

**Task 9 (the eighth and ninth criteria).** The two story pins against Task 1's base tree; then `npm run check`, `npm
test`, `npm run test:browser`, `npm run test:web` (TMPDIR 38 characters or fewer), the five Figma replays, `site:check`
rows on the B-Dry stand-in and Justin's scan no worse than the base's (the menu isn't in `site:check`'s rows: AC4 is
its check).

**Task 10: Docs & records.**
- the plan copy in `docs/plans/<build date>-native-widgets.md` (Task 1) and the ledger, which the finisher moves to
  `docs/plans/<plan>-ledger.md` before the final premerge commit and rebase;
- `docs/HANDOFF.md`: a new section above the previous top `## ` heading ("A menu's sliding list is Bricks' Accordion;
  what stays Code is labelled and named"), with the rule R1-R5, the shape, the three known differences, every ⭐
  ruling as "not yet confirmed", the follow-ups below, and the paste check (AC10) at the top of "End-of-run check
  list" under the next free id (checked free on main's HANDOFF, every local branch's and the plan folder, as the
  project skill says);
- `reference/bricks/README.md`: the two Accordion settings with their sources; "Still wanted": Justin's own
  Accordion (Nestable) with Transition and Independent toggle set, copied from his Bricks;
- `BUILD` bumped at the merge (never in the copy);
- main `CLAUDE.md` after the merge: the Status build line and one line for this feature with its paste check; one
  standing rule under "Working in this repo": **"Every Code element a paste holds is labelled by what it is and named
  in the notes; add every new Code producer to `test/unit/site-code-inventory.test.ts` (importer) or
  `test/unit/emit-code-inventory.test.ts` (plugin). A sliding list in a box a button opens is Bricks' Accordion
  (Nestable) (`src/core/site/list-accordion.ts`), its time in Transition."**; under "Decisions the user made", the ⭐
  answers of Q1, Q7, Q8 as not yet confirmed. If writing it is refused, the exact lines go in
  `~/.hermes/plans/figma-to-bricks/native-widgets-claude-md-pending.md`;
- the project skill's `references/rules-summary.md`: the finisher returns the proposed one-line edit; the main
  session saves it.

**Follow-ups for HANDOFF "Deferred"** (none built here): a sliding list beside other things as its own one-item
Accordion (Q2 B); whether opening one list closes the others, read by the scan (Q3 B); the open look of a sliding
list (its icon when open); a list open at load (no slide is recorded: site-menu-motion's limit); a `details` list in
the page that slides (the scan doesn't press it; importer-parity makes page lists Accordions with Bricks' own 200 ms);
the plugin's strips as Bricks' Slider ("strip-slider", Q7 B); Bricks' Map for sites with a key (Q6 B); a panel choice
that leaves the header spacer out (Q8 B); widgets that keep the site's elements without the site's script (the
notes' "kept as page code": Elementor's animated headline), which hold no Code element and are outside this job.

## Risks and stop conditions

- **The base moves under the plan.** Five jobs merge first; `convert.ts`, `tree.ts` and `open-paste.ts` are their
  files too. Task 1 re-reads everything; a rule another job already built (importer-parity's path-based
  `accordionShape`) is reused, never forked.
- **A fold removes the list's box.** The picks are in `picks.choice` before `foldBoxes`; AC1 runs on both routes. If a
  job on the base folds before picks are known, stop and report rather than re-order its step.
- **Bricks' accordion on the real site.** Proven with Bricks' own script and CSS in Chrome, not in Justin's Bricks:
  the live criterion is that check. `transition` and `independentToggle` come from Bricks' 2.2 source and 2.4.4
  schema, not from a copy out of his Bricks (README "Still wanted").
- **Chrome runs.** SIGTERM, exit 143 or 137, or "Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30
  min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first and rerun under `systemd-run --user --scope -p
  MemoryMax=4G -p MemorySwapMax=0`.
- **Never** load bdryswi.com, B-Dry staging or any live site; never run `site:upload` or `site:import` against a
  site; fixtures and saved scans only.

## Completion and reporting

`ready-for-review` when the first nine criteria pass on one committed head with their receipts (a terminal capture or
a screenshot each) under `~/.hermes/plans/figma-to-bricks/evidence/native-widgets/builder/`, the whole unit, browser
and web suites compared with Task 1's tallies by test name, and the ledger committed. The builder's report lists the
rulings it made, every pinned test it edited with its proof, the live criterion as owed to Justin, and
`skill_lessons[{skill, lesson, evidence, enforce}]`.
