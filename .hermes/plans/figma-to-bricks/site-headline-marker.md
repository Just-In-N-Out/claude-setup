# site-headline-marker: a scanned site's Animated Headline marker draws itself in Bricks (plan, Mini, 2026-11-14)

Planner: site-headline-marker (Fable 5.2, high). Pipeline: **Mini** (one review; edge cases go to follow-ups). Website
importer rules apply (repo CLAUDE.md). Plan only: no source or test changed, nothing committed, no agent started, no
live site loaded, no WordPress written.
**Base: `main` once importer-parity has merged** (this plan was read from `main` `fe29b65d`, Build 2026-11-14.4; the
two meet in `elementor-fold.ts`, `convert.ts` and `test/browser/render.ts`: "Overlaps and order").
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/planner/` (`README.txt` lists
every file). The builder copies this plan to `docs/plans/<build date>-site-headline-marker.md`.

## Playback

1. On bdryswi.com's home the words "60 Years" in the headline get a red circle that draws itself when the headline
   scrolls into view. It is Elementor Pro's "Animated Headline" widget.
2. Today the importer pastes it still, as five pieces (a Block, three Rich Texts and a Code element holding the
   drawing): nothing moves, and a Bricks person can't change the words or the colour in one place.
3. You asked for it to paste drawing itself as on the site, for every site that uses this widget, built the way a
   Bricks pro would build it.

## Questions for Justin (the build takes the ⭐ answers unless you say stop)

1. **Where does the drawing live in Bricks?**
   - A ⭐ **In the Heading itself.** One Heading; its Text field holds the whole sentence, with the marked words
     wrapped once (`Over <span class="f2b-mark f2b-mark-1">60 Years</span> Of Trusted…`), exactly as the Figma plugin
     writes its markers. A class on the Heading draws the circle around that span. Change the words in the Text
     field and the circle follows them; move the span and the circle moves.
   - B A separate Icon or SVG beside the words. Rejected: the sentence would become three elements in a row (words,
     marked words with the drawing, words), which wraps differently from the site and isn't one editable sentence.
   - C A Code element with the site's script. Rejected: your standard keeps Code for third-party widgets only.
2. **How do you change the marker's colour?**
   - A ⭐ **One line.** The marker class starts with `--f2b-mark-color: …`, linked to the colour in your palette
     (Style Manager → Colors). Change the palette colour, or that one line, and the marker changes.
   - B Baked into the drawing's code (as the Figma plugin does today). Rejected: a pro would have to edit an encoded
     picture.
3. **Which class carries it?**
   - A ⭐ **Its own class, named by purpose** (`home__marker-ab12` today; `bd-marker` once short-class-names
     merges), before the Heading's own class. It holds only the marker. Headlines with the same marker share it.
   - B The Heading's own class. Rejected: the marker's code would sit among the Heading's position and spacing.
4. **When does it draw?** A ⭐ As on the site: once, when the Heading is 100 px inside the window, started by
   Bricks' own Interaction on the class (Enter viewport → Start animation; you can see and change it under
   Interactions). B On page load. Rejected: on the site a headline lower on the page draws when you reach it.
5. **A headline set to repeat** ("Infinite Loop" in Elementor): A ⭐ repeats as on the site (draws, waits, fades,
   draws again). B draws once. B-Dry's headline has the loop off, so your page is the same either way.
6. **Elementor's other headline style, "Rotating"** (words that swap: typing, flip, slide…): A ⭐ left as it pastes
   today (still, showing its first words) with one plain note; a job of its own if you want it. Bricks has no element
   for it, and without a script each of its nine effects needs its own build. B-Dry doesn't use it.

Rulings the planner made (⭐, in the HANDOFF as "not yet confirmed"):

- R1. **In the Bricks editor and for visitors who ask for reduced motion the marker shows whole and still.** The
  editor doesn't run the Interaction; the site shows it whole at once under reduced motion too.
- R2. **A headline that also plays an entrance of its own** (fade in, on the widget itself) keeps one Block around
  the Heading for that entrance: Bricks plays one Start animation per element at a time.
- R3. **Every other span of the sentence disappears into the Heading only where that provably changes nothing**
  (design D3). Otherwise it stays a plain `<span>` in the Text field, with its look on the Heading's own class.
- R4. **Browsers that can't combine masks** (Chrome before 120, 2023) show the words without the marker, never a
  coloured box.
- R5. **A drawing the paste can't read** (an older scan, a shape with no path) pastes as today, with a note saying
  "capture the page again with this build".

## What was measured (`<P>/README.txt`)

- **The scan already holds everything.** In your 2026-11-11 scan the widget's settings (highlight, circle, 1200 ms,
  loop off), the drawing's path, its colour `rgb(231, 58, 58)` and width 5, the drawing's box, and each span's look
  are all there (`<P>/capture-headline.txt`). The capture needs no change.
- **Today's paste** (`main` `fe29b65d`, `--elementor`): Block "Animated headline" → Block → Block "Heading" (h3) →
  Rich Text "Over", Block → Rich Text "60 Years" + Code "SVG", Rich Text "Of Trusted…"; the page holds 479 elements,
  23 of them Code (`<P>/base-paste-headline.txt`).
- **Elementor Pro's own code** (GPL, pro-elements 4.4.0; `<P>/elementor-pro/`): the markup, the nine shapes' paths,
  the CSS (`stroke-dasharray` from `0 1500` to `1500 1500`, eased, over the duration; a second path half a duration
  later), the start (when the headline is 100 px inside the window), the loop (hide at duration + 0.8 × delay, a
  0.4 s fade and blur, start again at duration + delay), reduced motion (whole at once).
- **A prototype of the paste's CSS against Elementor's own, in Chrome** (`<P>/proto-marker.ts`, `proto-compare.ts`,
  `compare-words-hidden.log`, `compare/*.png`; offline, Chrome for Testing 156): all nine shapes plus B-Dry's stroke
  at 56 px and at 27 px, rounded ends above the words, and two looping cases. Before it plays the paste shows no
  marker; at the end the two drawings are within 2 px and 7 % of each other's pixel count; at every moment between
  (3 to 75 % of the time) the site's is within 7 px of the paste's and the paste's within 5 px of the site's. The
  same numbers with the CSS inside `@layer bricks`, as Bricks 2.4.2 prints it.
- **The Figma plugin's own sweep isn't enough** (`<P>/shapes.json`): it reads the zigzag as a circle, and the
  circle's overlapping end would show early. Hence the "runs" rule (D4).
- **Bricks** (`<P>/same-interactions.mjs`, `reference/bricks/frontend-2.3.9/`, saved 2.4.2 files): an Interaction's
  `rootMargin` is read by both 2.3.9's and 2.4.2's script and is a field in the builder (Bricks 2.0+); two of the
  functions it runs through differ between the versions, so the proof runs both; Bricks hides an element until its
  animation starts when the animation type holds the letters "in" in any case, so the marker's type holds none.

## The design

### D1. What the site does (the facts the paste copies)

Markup: `<hN class="elementor-headline">` holding zero or more plain spans (`elementor-headline-plain-text`), one
wrapper (`elementor-headline-dynamic-wrapper`, inline-block, relative) holding the marked words
(`elementor-headline-dynamic-text`) and, added by the script, `<svg viewBox="0 0 500 150"
preserveAspectRatio="none">` with one or two `<path>`. The svg is `position: absolute; left: 50%; top: 50%;
transform: translate(-50%,-50%); width: calc(100% + 20px); height: calc(100% + 20px); overflow: visible`. Each path
draws by `stroke-dasharray: 0 1500 → 1500 1500` with the easing `ease` over `highlight_animation_duration` (1200 ms
by default); a second path starts half a duration later. Width, colour, round ends and "bring to front" are widget
settings printed as CSS. Shapes: circle, underline_zigzag, x, strikethrough, curly, diagonal, double,
double_underline, underline.

### D2. Scope

In: every Animated Headline of style **highlight**, any shape (the paste reads the drawing's own paths from the
scan, so a shape Elementor adds later works too), one or more paths, any stroke width, colour, round ends, front or
behind, any duration, loop on or off.
Named and left as today: style **rotate** (Q6); a headline whose drawing the scan doesn't hold or the reader can't
read (R5); a drawing whose box changes between width ranges; paths that differ in colour or width. Each prints one
note.
Off: `ConvertOptions.marker: false` (a test and diagnosis switch, no command-line flag): every paste byte for byte
as before this job. The plain route (no `--elementor`) is untouched.

### D3. The fold: `src/core/site/elementor-headline.ts` (new), called from `elementor-fold.ts`

A new branch in `foldElementor`'s widget loop, before the `BODIES` fallback, for `e.widget === "animated-headline"`
(skipped when `opts.marker === false`: `FoldOptions` gains `marker?: boolean`):

```ts
export interface MarkerLook {
  heading: string;                                  // the headline node's path (the Heading)
  shape: string;                                    // settings.marker ?? "circle": for the note only
  words: string;                                    // the marked words as text: for the note only
  viewBox: [number, number, number, number]; paths: string[];
  strokeWidth: number; round: boolean; colour: string; above: boolean;
  duration: number;                                 // ms
  loop: { delay: number } | null;                   // ms
  box: { width: string; height: string; left: string; top: string; transform: string };  // the svg's own, as captured
}
export function headlineShape(code: WebCode, pr: PageRanges, e: ElementorEntry):
  { why: string } | { chain: string[]; node: CodeNode; gone: string[]; look: MarkerLook };
```

`headlineShape` reads, and refuses with a plain `why` when a step doesn't hold:

1. `e.settings.headline_style` is absent or `"highlight"` (else why: "a rotating headline").
2. From `e.path` down through single-child boxes: the node whose class holds the token `elementor-headline`
   (`chain` = the boxes passed, ending on it). Its children are plain spans (token `elementor-headline-plain-text`,
   kind `words`) and exactly one wrapper (token `elementor-headline-dynamic-wrapper`, kind `box`) whose children are
   exactly one `words` span and one `svg` (kind `other`, `html` present).
3. The svg's markup gives a `viewBox` of four numbers and at least one `<path d>`; every path has the same baked
   `stroke` and `stroke-width` (the capture bakes computed paint into the markup: `src/web/read/code-markup.ts`);
   `round` = baked `stroke-linecap: round`. Read with the repo's own readers (`src/core/site/icons.ts` /
   `markup.ts` for the root, `src/core/normalise/svg-paths.ts` `pathOf` for points); no regular expression over CSS.
4. The svg's `width`, `height`, `left`, `top`, `transform` declarations are the same at every range (`statesOf`).
5. `duration` = `Number(e.settings.highlight_animation_duration) || 1200`; `loop` = `e.settings.loop === "yes"`
   → `{ delay: Number(e.settings.highlight_iteration_delay) || 8000 }` (Elementor's `data-settings` lists a setting
   that is on, defaults included: B-Dry's holds the default 1200 and no `loop`, so its loop is off); `above` = the
   svg's `z-index` is 2 or more.

The returned `node` replaces the headline node: `kind: "words"`, `children: []`, no `spaces`, and

- `html` = its children in order, a space where `spaces` lists the child's index: a plain span's `html` as it is (or
  `<span>…</span>` when it can't dissolve), the wrapper as `<span class="f2b-mark f2b-mark-1">…</span>` (`MARK_CLASS`
  from `src/core/style/typography.ts`: the plugin's name) around the marked words' `html` (or around
  `<span>…</span>` when the inner span can't dissolve);
- `inline` = each span kept, by its element index path in that html, with its declarations per range;
- `decls` / `inherited` = the headline's own, plus what dissolved plain spans handed up.

**Dissolving** (R3), judged on full declarations per range (`statesOf`):

- A **plain span** dissolves when every plain span has the same declarations and each is either an inherited text
  property (colour, font, letter- and word-spacing, text-transform, text-decoration, text-shadow, line-height) or
  neutral for an inline box (`box-sizing`, `position: relative|static`, `z-index`, and `vertical-align` only when
  the inner span dissolved too). Its text properties go on the headline (the span's value wins), the neutral ones
  go nowhere.
- The **inner words span** dissolves into the mark span when it sets only colour, `font-weight`, `font-style`,
  letter- and word-spacing, text-transform, text-decoration, text-shadow, `box-sizing`, `display:
  inline|inline-block`, `position: relative|static`, `z-index`, zero or `auto` insets, and no `line-height` or a px
  `line-height` that is at most the headline's px `line-height` at every range (then it is dropped: with the same
  font the wrapper's own line holds a shorter one, so the box is the same). Its text properties become the mark
  span's `inline` declarations.
- The **mark span's** own `inline` declarations never hold `position`, `display`, `z-index` or insets: the marker
  class writes those (one writer per property).

`gone` = the wrapper, its words span, the svg and every dissolved span: they leave `nodes`, and their entries
leave the returned capture's `web.motion` (the path's dash animation is the marker's now).

In `foldElementor`: on `why` → `notes.push(\`not a marked Heading: animated-headline ${e.id}: ${why}\`); kept(e)`
and the widget goes on as today. Else `nodes[h] = node`, delete `gone`, `markers.push(look)` (`Folded` gains
`markers: MarkerLook[]`), `mapped++`, then the wrappers: `fold(e, chain)` as for a heading, except that a chain
through an `a`, or a widget whose merged declarations name an entrance animation (R2), isn't folded (`kept(e)`,
with the existing "not folded" note). `convert.ts` `prepare` collects `f.markers` into `Prepared.markers`, as it
does `sliders`.

### D4. The marker: `src/core/site/marker.ts` (new, pure; a port of `<P>/proto-marker.ts`, sha256 `bb76330c…`)

`markerOf(m, pointsOf)` → runs, images and the timeline; `markerCss(cls, look, marker, colour, names)` → the CSS.

- **Runs.** Each path is flattened to points (`pathOf`) and cut where its travel along x turns back by more than
  2 % of the viewBox width. A run is uncovered along x (left to right or right to left) inside its own band: the
  rectangle of its line grown by half the stroke plus 1.
- **Images.** The mark span's `::before` and `::after` (one image: `::after`). Each path starts an image; inside a
  path a run starts the next image when more than 10 % of its line lies inside an earlier run's band in the same
  image (it would show early). The circle: its two halves in `::before`, the overlapping end in `::after`. More than
  two images: the rest share the second (measured on the zigzag: within 5 px).
- **Each image** is `background-color: var(--f2b-mark-color)` under a mask of layers: first the shape (a data-URL
  SVG of the image's paths, stroke `#000`, the site's `viewBox` grown to hold strokes that run past it,
  `preserveAspectRatio="none"`, so the stroke stretches as on the site), then one gradient per run, sized and placed
  on its band: `linear-gradient(to right|left, #000 calc(var(--f2b-draw, 1) * (100% + 1px) - 1px), #0000 0)`;
  `mask-composite: intersect, add, …` (the shape ∩ the bands' union). Its box is the site's svg box as captured,
  width and height multiplied by how much the viewBox grew.
- **Timeline.** One registered number per run (`--f2b-draw`, `--f2b-draw-2`, …; `@property`, `inherits: true`,
  `initial-value: 1`, as `src/core/emit/motion.ts` `DRAW_PROPERTY`). Path i starts at i × duration / 2; its drawn
  share at time t is `min(1, dash × ease((t − start) / duration) / length)` with `dash` 1500 (the site's keyframes'
  end, from `web.motion` when the scan holds it); a run's value is its x travel at that share (sampled at eighths of
  its length). The keyframes are those values at sampled times, linear between, keeping only the stops a
  farthest-point split needs (tolerance 0.004; never a greedy walk: its errors add up, `<P>/dbg-lead.ts`).
- **Loop.** The period is duration + delay; one more registered number per path (`--f2b-fade`, `--f2b-fade-2`)
  takes opacity 1 → 0 and `blur(0 → 10px)` over 400 ms from duration + 0.8 × delay (+ i × duration / 2 for path i,
  dropped when that falls after the period: Elementor never fades it either); `animation-iteration-count: infinite`.

The CSS a class `N` carries (`N-draw` its keyframes; shown for one run):

```css
@property --f2b-draw { syntax: "\3C number\3E"; inherits: true; initial-value: 1; }
.N { --f2b-mark-color: var(--color-e73a3a, rgb(231, 58, 58)); isolation: isolate; }
.N .f2b-mark { position: relative; display: inline-block; z-index: -1; }
@supports (mask-composite: intersect) {
.N .f2b-mark::after { content: ""; position: absolute; left: 50%; top: 50%; transform: translate(-50%,-50%); width: calc((100% + 20px) * 1.024); height: calc((100% + 20px) * 1.08); z-index: -1; pointer-events: none; background-color: var(--f2b-mark-color); mask-image: url("data:image/svg+xml,…"), linear-gradient(to right, #000 calc(var(--f2b-draw, 1) * (100% + 1px) - 1px), #0000 0); mask-size: 100% 100%, 98.4% 12.1%; mask-position: 0 0, 50% 88%; mask-repeat: no-repeat; mask-composite: intersect; }
}
@keyframes N-draw { 0% { --f2b-draw: 0; } 4.38% { --f2b-draw: 0.21; } … 100% { --f2b-draw: 1; } }
@media (prefers-reduced-motion: no-preference) {
.bricks-is-frontend .N:not(.brx-animated) { --f2b-draw: 0; }
.N.brx-animate-f2bMarkDraw { animation-name: N-draw; animation-timing-function: linear; }
}
```

"Bring to front": the span and the image take `z-index: 1`. The colour is written through `ink.css`
(`src/core/site/colours.ts`), so it is the palette's `var(--color-<hex>, <as written>)` when the palette is on.
Measured sizes: 1.4 KB (a line) to 5.3 KB (the looping circle) per marker class.

### D5. The class and the Interaction: `src/core/site/marker-class.ts` (new)

`withMarkers(p, names, settingsOf, page, ink)`, called right after `withLooks` in `parts.ts` `sitePage` and in
`convert.ts` `siteToBricks`: for each `p.markers` entry whose heading got a class,

- the class name is `versioned(\`${page}__marker\`, (n) => markerCss(n, …)).name` (`classes.ts`: four letters from
  its own rules, so equal markers share one class and a changed marker takes a new name);
- `settingsOf.set(name, { _interactions: [interaction], _cssCustom: css })` with
  `interaction = { id: shortId(\`interaction:${name}\`), trigger: "enterView", action: "startAnimation",
  animationType: "f2bMarkDraw", animationDuration: "<total>s", rootMargin: "0px 0px -100px 0px", runOnce: true }`
  (the shape of `motion.ts` `interactionOf`; total = duration, 1.5 × duration with two paths, duration + delay for a
  loop; `rootMargin` is Bricks' own field, `interactions.php` "rootMargin", read by `bricks.min.js` 2.3.9 and 2.4.2);
- the heading's `spec.lookNames` gains the name, so `payloadOf` puts the class before the Heading's own.

Why the type is the fixed word `f2bMarkDraw`: Bricks' PHP marks an element hidden on load when its animation type
holds "in" in any letter case (`stripos`, Bricks 2.2 GPL `interactions.php` L612), which would hide the whole
Heading until it plays; a page's name can hold "in", this word can't. It is no animate.css name, so only the
class's own rule gives it keyframes. How it plays: Bricks adds `brx-animated` and `brx-animate-f2bMarkDraw` with
the duration inline; the class's rule names the keyframes; at `animationend` Bricks takes `brx-animate-…` away and
the registered numbers fall back to 1: the marker stays whole. Before it plays, on the front end only, the numbers
are 0. In the builder there is no `bricks-is-frontend`, under reduced motion neither rule applies: whole and still.

`share.ts` `pageInk` also counts each marker's colour (one loop over `p.markers`), so the palette holds it.
Notes, one per marker: `Marker: <class> draws a <shape> around "<words>" as the site does (<duration> ms[, again
every <period> ms]); its colour is --f2b-mark-color at the top of the class's CSS`.

### D6. The checks' tools

- `reference/bricks/frontend-2.4.2/bricks.min.js` and `animate-layer.min.css`: copied from the saved files
  (`evidence/site-faq/planner/staging/bricks-2.4.2.min.js`, sha256 `628ecaeb…`;
  `evidence/staging-fit/planner/staging/css/animate-layer.min.css`, sha256 `376e94ed…`), their lines added to
  `frontend-2.4.2/SHA256SUMS` and a paragraph to `reference/bricks/README.md` (where each was read, the
  `rootMargin` field, the "in" rule). No site is loaded for this.
- `test/browser/render.ts`: `PageOptions.bricksAssets?: "2.3.9" | "2.4.2"` (default `"2.3.9"`, as today): which
  folder `bricksMotion`'s script and animate CSS come from. Nothing else of the renderer changes.
- Fixtures: `test/fixtures/site-headline-code.ts` (`headlineCode(opts)`: a hand-made capture shaped as
  `<P>/capture-headline-subtree.json`, with every option: shape, paths, stroke, round, above, duration, loop, plain
  spans or none, an inner span that can and can't dissolve, style rotate, no svg markup) and
  `test/fixtures/site-headline.ts` (`headlineSite(cases)`: a local page with the widget's markup, the highlight rules
  of Elementor Pro 4.4.0's `widget-animated-headline.min.css` as served, and a stand-in script that does what the
  handler does: appends the shape's svg, adds `e-animated` when the headline is 100 px inside the window, runs the
  loop's two timers). Generic words and colours; nothing from B-Dry.

## The standard, point by point (CLAUDE.md "THE STANDARD FOR EVERY PASTE")

1. **Structure.** One Heading with the site's tag where five elements were; its wrappers fold away by the existing
   rules (a labelled Block stays only where a rule or R2 needs it); no Div, no Code, no wrapper for the drawing.
2. **Classes.** The marker is one purpose-named class holding only the marker, shared by equal markers, before the
   Heading's own class; the marked words' own look (colour, weight) is on the Heading's own class; the two never
   write one property (AC9). The Heading still takes the page's shared text class.
3. **Settings before custom CSS.** The words are the Text setting, the tag the Tag setting, the start an
   Interaction. Bricks has no control for a drawing around words, so the drawing is custom CSS on the class that
   owns it; it is not short (1.4 to 5.3 KB), and its one line a person changes is first. The colour is the palette's.
4. **Bricks' own behaviour.** Bricks' Interaction starts it (visible under Interactions, with its rootMargin); no
   Code element, no script, no code signatures to regenerate.
5. **Editable content.** The sentence is in the Heading's Text field; the marked words are the span; the colour is
   a variable; the timing is the Interaction's duration.
6. **Looks stay true.** The marker follows the site's within the tolerances measured in Chrome at every moment, the
   words sit where the site's do at 1440, 1024, 768 and 390; where clean and exact conflict (a span that can't
   dissolve), exact wins and the span stays.

The same shape in both tools: the span and its class name, the drawing on the span's pseudo-elements as a data-URL
SVG, a mask uncovered by registered `--f2b-draw` numbers, no Code: as the Figma plugin's headline-marker. Different,
with reason: a class instead of the element's own CSS (the importer's rule, and it can be shared), a start by
Interaction (the site starts on entering the window; Figma gives no trigger), the colour as a variable, runs in
bands (the site's stroke order is known; a Figma drawing's isn't). Bringing the plugin's marker to the class and
variable is a follow-up.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): Given a hand-made capture holding an Elementor Animated Headline of style highlight (each of the nine shapes), with `--elementor` it pastes as one Heading with the site's tag whose text is the sentence with the marked words in `<span class="f2b-mark f2b-mark-1">`, carrying a `<page>__marker-<4>` class before its own, with no Code element and no element for its spans or drawing, and the notes hold one `Marker:` line naming the class, the shape and `--f2b-mark-color`; test `a highlighted Animated Headline is one Heading with its marked words in its text and a marker class` in `test/unit/site-headline.test.ts`.
- AC2 (proposed): Given the fixture site drawn beside its paste in Chrome with Bricks' own script and CSS (2.3.9 and 2.4.2), for each of the nine shapes at 0, 10, 20, 50 and 100 % of the play time: before it plays and at 0 % the paste shows no marker pixel; at 10, 20 and 50 % no marker pixel of either side is farther than 9 px from the other's; at 100 % none is farther than 3 px and the pixel counts are within 10 %; test `each marker shape draws as the site's at 0, 10, 20, 50 and 100 % of its time on Bricks 2.3.9 and 2.4.2` in `test/web/site-headline-proof.test.ts`.
- AC3 (proposed): Given the fixture site's headlines (plain words with their own colour, marked words with their own colour, weight, letter-spacing and a 1 px line-height, a smaller font from 767 px down, a sentence that wraps on phones, and one whose inner span can't dissolve), at 1440, 1024, 768 and 390 every word of the paste is on the same line and within 1 px of the site's, the mark span's box is within 1 px of the site's wrapper, and the plain and marked words have the site's computed colour, size and weight; test `the headline's words wrap and sit as on the site at 1440, 1024, 768 and 390` in `test/web/site-headline-proof.test.ts`.
- AC4 (proposed): Given a page with the Heading below the fold, drawn with Bricks' own `bricksInteractions()` (2.3.9 and 2.4.2): the Heading's words show from load, the marker shows no pixel while the Heading is 60 px inside the window, it plays once the Heading is 140 px inside, it ends whole, and scrolling away and back doesn't play it again; test `the marker waits until its Heading is 100 px inside the window, then Bricks' own Interaction plays it once` in `test/browser/render-site-headline.test.ts`.
- AC5 (proposed): Given headlines with a stroke width of 3 and of 12, another colour, rounded ends, "bring to front", a 600 ms duration and a two-path shape: the paste's marker matches the site's within AC2's tolerances at 20, 50 and 100 %, the second path starts half a duration after the first, and with the words showing in another colour the marker's visible pixel count is within 10 % of the site's both behind and in front of the words; test `the marker follows the site's stroke width, colour, rounded ends, order and duration` in `test/web/site-headline-proof.test.ts`.
- AC6 (proposed): Given a headline with the loop on (delay 2000 ms) with one path and with two: just before the hide both sides are whole, 400 ms after it the first path is gone on both, a second path the site never fades isn't faded, and one period later both draw again from nothing; test `a looping marker fades and draws again in the site's rhythm` in `test/web/site-headline-proof.test.ts`.
- AC7 (proposed): Given the paste drawn with `prefers-reduced-motion: reduce`, and drawn without the `bricks-is-frontend` body class (the builder): the marker is whole from load in both, no animation runs on the Heading, and its pixels are within 3 px of the site's finished marker; test `reduced motion and the builder show the marker whole and still` in `test/browser/render-site-headline.test.ts`.
- AC8 (proposed): Given a paste with the palette on: the marker class's first rule sets `--f2b-mark-color` to `var(--color-<hex>, <the site's colour>)`, `palette.json` holds that colour, no other place in the class names a colour, and in Chrome changing that one value to another colour recolours every marker pixel while changing the Heading's words keeps the marker around the span; test `one variable recolours the marker and the palette holds its colour` in `test/browser/render-site-headline.test.ts`.
- AC9 (proposed): Given every paste of the headline fixtures (whole page and every section, both text modes): the marker class and the Heading's other classes write no property twice on one selector target, the marker class holds no declaration but the marker's own, no paste holds a Div, and none holds a Code element for a headline's drawing; test `the marker class and the Heading's own class never write one property` in `test/unit/site-headline.test.ts`.
- AC10 (proposed): Given a rotating headline, a highlight headline whose scan holds no drawing markup, one whose drawing has no path, one whose drawing's box changes between ranges and one whose widget plays an entrance: the first four paste byte for byte as `main` makes them, each with one `not a marked Heading: … <why>` note, and the fifth keeps one labelled Block around its marked Heading with the entrance on the Block; test `a rotating headline, an unreadable drawing and an entrance of its own are named and safe` in `test/unit/site-headline.test.ts`.
- AC11 (proposed): Given every hand-made code capture the repo's pin lists hold, on both routes, and the headline fixtures converted with `marker: false` and on the plain route: every paste is byte for byte what `main` makes (hashes recorded on a `git archive` of the base); test `pastes without a marked headline, the plain route and the switch off are byte for byte main's` in `test/unit/site-headline-off.test.ts`.
- AC12 (proposed): Given every Figma design file this machine holds and the panel's website route: each converts byte for byte as on the base; test `Figma designs and the panel's website route convert byte for byte as main` in `test/unit/site-headline-figma.test.ts`.
- AC13 (proposed): Given Justin's 2026-11-11 scan (read-only, converted and drawn with no outside network) with `--elementor`: the home's headline is one h3 Heading whose text is `Over  <span class="f2b-mark f2b-mark-1">60 Years</span> Of Trusted Waterproofing And Foundation Repair` with a marker class of a circle (1200 ms, no loop), the page holds one Code element fewer than on `main` (22, was 23), every element outside the headline widget and every class they carry is byte for byte `main`'s, and at 1440, 1024, 768 and 390 each of the headline's words sits within 1 px of where `main`'s paste draws it; test `B-Dry's scan: the home's headline is one marked Heading and nothing else moves` in `test/web/site-headline-bdry.test.ts`.
- AC14 (proposed) (live): Justin runs his own `npm run site:import -- https://bdryswi.com/ <B-Dry staging> --elementor`, imports `palette.json`, pastes the home on staging /homev2/ and looks in a private window: the red circle draws around "60 Years" when the headline comes into view, as on bdryswi.com, at desktop and phone width; in Bricks he changes the words in the Heading's Text field and the marker's colour (the palette colour or the class's first line) and sees both on the page.

Story-time pins (AC11, AC12) run only when named (`F2B_PIN_BASE=1`), as the repo's other pins do; AC13 only when
named (`F2B_HEADLINE_SCAN=<the scan>`, `F2B_HEADLINE_BASE=<a git archive of the base>`), under
`unshare -rn sh -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`.

## Touched files

New: `src/core/site/elementor-headline.ts`, `src/core/site/marker.ts`, `src/core/site/marker-class.ts`;
`test/fixtures/site-headline-code.ts`, `test/fixtures/site-headline.ts`, `test/fixtures/site-headline-pins.json`,
`test/fixtures/site-headline-figma-pins.json`; `test/unit/site-headline.test.ts`, `test/unit/site-marker.test.ts`,
`test/unit/site-headline-off.test.ts`, `test/unit/site-headline-figma.test.ts`,
`test/browser/render-site-headline.test.ts`, `test/web/site-headline-proof.test.ts`,
`test/web/site-headline-bdry.test.ts`, `test/web/lib/marker-pixels.ts` (the pixel reader of `<P>/proto-compare.ts`);
`tools/site-headline-pins.ts` (the recorder: the converter from a tree given as its argument, the fixtures from its
own tree); `reference/bricks/frontend-2.4.2/bricks.min.js`, `reference/bricks/frontend-2.4.2/animate-layer.min.css`.

Changed: `src/core/site/elementor-fold.ts` (the branch, `Folded.markers`, `FoldOptions.marker`),
`src/core/site/convert.ts` (`ConvertOptions.marker`, `Prepared.markers`, the `withMarkers` call in `siteToBricks`),
`src/core/site/parts.ts` (the `withMarkers` call), `src/core/site/share.ts` (`pageInk`: the markers' colours),
`test/browser/render.ts` (`bricksAssets`), `test/unit/site-no-div.test.ts` (the headline fixture among its
captures, in the test's own list when adding it to a pinned list would move a pins file),
`reference/bricks/README.md`, `reference/bricks/frontend-2.4.2/SHA256SUMS`, `docs/HANDOFF.md`.

Not changed: the capture (`src/web`), `src/core/snapshot`, the Figma plugin (`src/core/emit`, `src/plugin`,
`src/ui`), the commands' options, `BUILD`.

## Tasks

Run from the worktree. Chrome: `CHROME_PATH` as the figma-to-bricks skill says for this machine. A command that
dies with SIGTERM, 137, 143 or "Killed" is checked against earlyoom first (global CLAUDE.md) and rerun under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Commit after each green task (plain `git commit`,
`git diff --cached --name-only` first: never CLAUDE.md). Ledger: `.superpowers/sdd/site-headline-marker/progress.md`.

**M0. Base.**
1. `git log --oneline -1`; `git diff --name-only fe29b65d HEAD -- src/core/site test/browser/render.ts
   test/unit/site-no-div.test.ts reference/bricks` and read what moved in this plan's files; where a cited line or
   helper changed, follow the code as it is now and note it in the ledger. Stop and report if `elementor-fold.ts`
   no longer has a per-widget loop with `choice`, `fold` and `kept`.
2. `npm run check` and `npm run corpus`: record the tallies. `git archive HEAD | tar -x -C ~/.cache/shm-build/base`.

**M1. Fixtures and reference files.**
3. Copy the two Bricks 2.4.2 files (D6), verify their sha256, add the `SHA256SUMS` lines and the README paragraph.
4. `test/fixtures/site-headline-code.ts` and `test/fixtures/site-headline.ts` (D6), with a unit test that the
   hand-made capture's headline subtree has the node kinds, marks and declarations of
   `<P>/capture-headline-subtree.json` (tags, kinds, class tokens, the svg's markup shape; values generic).
5. `tools/site-headline-pins.ts`; record `test/fixtures/site-headline-pins.json` and
   `site-headline-figma-pins.json` on `~/.cache/shm-build/base`; write `site-headline-off.test.ts` and
   `site-headline-figma.test.ts`; both green on the unchanged tree with `F2B_PIN_BASE=1` (they pin, they aren't RED).

**M2. The marker (pure).**
6. RED: `test/unit/site-marker.test.ts`: for the nine shapes (`<P>/shapes-d.json`) `markerOf` gives images/runs
   circle 2/3, underline_zigzag 2/4, x 2/2, double 2/2, double_underline 2/2, the four lines 1/1; every run's first
   stop is 0 and last 1; values never fall; a line of length 493.5 is whole at 21 % of the duration and the circle
   at 55.5 % (±1 %); a two-path shape's second run is 0 until 50 % of the duration; a loop's stops end with the
   fade at 0 and a second path's fade is dropped when it would start after the period; `markerCss` holds one
   `--f2b-mark-color`, the `@supports` block, no `display` outside `.f2b-mark`, no "in" in the animation type.
   `node --test test/unit/site-marker.test.ts` fails: no module.
7. GREEN: port `<P>/proto-marker.ts` to `src/core/site/marker.ts` (split past ~300 lines: `marker.ts` the geometry
   and timeline, `marker-css.ts` the CSS), with D4's CSS (the `@supports` block, the reduced-motion media, the fixed
   type, per-path fades). Same command passes; `npm run typecheck` (the sandbox config: built-ins only).

**M3. The fold and the class.**
8. RED: `test/unit/site-headline.test.ts`, the AC1, AC9 and AC10 tests on `headlineCode(...)`. Fails: the headline
   is still boxes and a Code element.
9. GREEN: `elementor-headline.ts` (D3), the branch in `elementor-fold.ts`, `Prepared.markers`,
   `marker-class.ts` and its two calls, `pageInk`. `node --test test/unit/site-headline.test.ts` passes; then
   `npm run check`; then the pins of M1 with `F2B_PIN_BASE=1` (still green: nothing else moved).
10. `test/unit/site-no-div.test.ts` walks the headline fixture.

**M4. Chrome proofs.**
11. `test/browser/render.ts` `bricksAssets`; RED then GREEN `test/browser/render-site-headline.test.ts` (the tests
    of AC4, AC7 and AC8) on both versions. If 2.4.2's script needs page data the renderer doesn't give it, read which from the
    script, add it, and record it in the README; if it still can't run, stop and report (never skip the version).
12. `test/web/lib/marker-pixels.ts` and `test/web/site-headline-proof.test.ts` (AC2, AC3, AC5, AC6): serve
    `headlineSite`, capture it with the repo's capture, convert with `--elementor`, draw the paste with Bricks' own
    script, pause every animation on both pages at the same clock time (`document.getAnimations()`, `currentTime`),
    hide the words (`color: transparent`) for the marker counts, crop both around the marked words' box and compare
    as `<P>/proto-compare.ts` does. Words in a colour whose blue channel is high when they show (AC5): their
    antialiasing fringes then never read as the marker's red.
13. Prove each new test catches its bug (`git checkout HEAD~1 -- <the fix's files>`, see it fail, restore), and run
    one mutant per AC2/AC4/AC7 rule under the memory cap: the hide rule removed, the type renamed to hold "In", the
    gradient direction flipped, the second path's start at 0.
14. `test/web/site-headline-bdry.test.ts` (AC13), named, offline.

**M5. Close.**
15. `npm run check`, `npm run corpus`, `npm run test:browser`, `npm run test:web` (the named B-Dry stand-in tests
    the skill lists, with their inputs, when this machine holds them); a screenshot per AC in the evidence folder
    (the side-by-side strips at 0, 20, 50, 100 % for AC2; a terminal capture where nothing is visual).
16. Docs & records (below). Stop at `ready-for-review` with the branch, the head and the ledger.

## Overlaps and order

| Job | Shared files | What this job assumes | Order |
| --- | --- | --- | --- |
| importer-parity (rebasing) | `elementor-fold.ts`, `convert.ts`, `test/browser/render.ts`, `test/unit/site-no-div.test.ts` | the widget loop keeps `choice`/`fold`/`kept`; typography may be class controls: the Heading and its span go through the same class machinery, nothing here reads them | **build after it merges** |
| native-widgets | `convert.ts` (`prepare`), `render.ts`, `reference/bricks/README.md`, `frontend-2.4.2/SHA256SUMS`, its Code inventory | its inventory lists one Code element fewer where a page has a marked headline (its plan says the headline is outside it); both add lines to `SHA256SUMS` | either; the second rebases |
| page-faq-slide | `render.ts`, `reference/bricks/README.md` | none of its lines | either |
| site-sticky-cards | `convert.ts`, `parts.ts`, `render.ts` | its `pinned(capture)` runs first; a positioned widget keeps its box, so a sticky headline keeps a Block around its Heading | either |
| look-grouping | `share.ts`, `convert.ts`, `parts.ts` | copies of one heading may share a class: the marker class stays its own, and `withMarkers` runs after `withLooks`/`withStates` whatever is added between | either; the second re-records its pins |
| short-class-names | `share.ts`, `convert.ts` (`nameClasses`), `parts.ts` | it renames every `<page>__` class: the marker class is named through `versioned` like the stay and fonts classes, and its rename list must gain `marker` (`bd-marker`) | if it merges first, name the class through its `nm.named("marker", rules)` |
| fewer-kept-boxes (planning) | `elementor-fold.ts`, `fold-boxes.ts` | may fold more wrappers: the Heading is a words node, never a box it folds | either |

Every job's HANDOFF section and CLAUDE.md Status line meet at the finish: keep both sides. Each merged job's
story-time pins that list every site paste compare with `marker: false` if this job's fixtures ever join their lists.

## Risks and follow-ups

- The proof ran on Chrome 156; Safari and Firefox draw masks and registered properties by the same standards but
  weren't measured: the live check (AC14) on his phone is the first real one. A browser without `@property`
  (Firefox before 128) plays the drawing in steps and ends whole.
- Bricks 2.4.2 prints class CSS inside `@layer bricks`: measured the same in Chrome (`<P>/compare-in-layer.log`).
- A cache plugin that delays Bricks' script delays the marker (the words show; the marker draws once the script
  runs), as on the site, where the script adds the drawing.
- Follow-ups (not built): the rotating style; the Figma plugin's marker on a class with the colour variable; the
  marker classes in `styles.txt`; a marker whose box changes with the width; markers in more than two images drawn
  exactly (zigzag: within 5 px today); a vendor-prefixed fallback for Chrome before 120.

## Docs & records (the builder, then the finisher)

- This plan to `docs/plans/<date>-site-headline-marker.md`; at the finish the ledger to
  `docs/plans/<date>-site-headline-marker-ledger.md`.
- `docs/HANDOFF.md`: a new section on top: what pastes now, Q1–Q6 ⭐ and R1–R5 as "not yet confirmed", the measured
  tolerances, the follow-ups above, and the paste check (the next free id in "End-of-run check list", AC14's steps
  one action at a time: his own `site:import`, Import `palette.json` first, paste /homev2/, look in a private
  window at desktop and phone width, change the words and the colour).
- `reference/bricks/README.md`: the 2.4.2 script and animate layer (where read, sha256), the Interaction's
  `rootMargin`, and "a Start animation's type that holds 'in' in any case hides its element until it plays".
- At merge (finisher): `BUILD`, one Status line in CLAUDE.md for the feature with its paste check, and the standing
  rule "an importer animation that isn't an entrance takes a type with no 'in' in it" under "Working in this repo"
  (or in `~/.hermes/plans/figma-to-bricks/site-headline-marker-claude-md-pending.md` if the write is refused).
- Every agent's report lists `skill_lessons[{skill, lesson, evidence, enforce}]` and never edits skills or memory.

## Report (builder)

The branch and head; each AC with its test's result and screenshot; `npm run check` and `npm run corpus` tallies
against M0's; every ruling made beyond R1–R5 in plain words; anything stopped on, with what was tried.
