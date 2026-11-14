# look-grouping: copies of the same button, heading or card share one class, in both tools (plan, Full, 2026-11-13)

Planner: look-grouping (Fable 5.2, high). Pipeline: **Full**. Both tools: the website importer's code method
(`src/core/site`) and the Figma plugin (`src/core/emit`).
**Base: `main` once the five jobs in flight have merged** (site-no-div, site-shared-styles, plugin-parity,
importer-parity, shared-palette; main is `7f54b0a5`, Build 2026-11-12.3). Every file:line and every number below was
read or measured on a clean export of **`plugin-parity-build` `fcdec6e2`**, the newest head that holds site-no-div (to
its fix 2), site-shared-styles (fix 1, `7b7501bd`) and plugin-parity together (`~/.cache/lg-pl/pp`), and on a prototype
of this job on top of it (`~/.cache/lg-pl/proto`). The builder re-reads each on the real base before editing.
Evidence (`<P>` below): `~/.hermes/plans/figma-to-bricks/evidence/look-grouping/planner/` (`README.md` lists every file).
Plan copy for the repo: `docs/plans/<date>-look-grouping.md` (the builder copies this file there in Task 1).

## Playback

1. Today both tools put elements in one shared class only when they look exactly the same at every width. Two "Call us
   now" buttons that differ in one small thing get no class in common, and a Bricks pro has to merge them by hand.
2. Justin: "if it is the same button like call me all call me buttons should change it should identify them by name".
   So every copy of the same button shares one class, and changing that class changes them all; the same for headings,
   cards and other parts that repeat.
3. This job makes a copy that differs a little carry the class of its thing and keep only its own difference on
   itself, so nothing moves: for any Figma design and any scanned site.

## Questions (⭐ = the ruling taken; Justin was asleep, so each ⭐ is my best-reasoned answer after research. "go with recommended" takes them all)

1. **What makes two elements "the same thing"?** ⭐ **A: three signs, strongest first, always the same Bricks element
   (a Button with Buttons, a Heading with Headings):**
   (a) the same words and the same link ("Call Us Now" → `tel:…`);
   (b) the same name where it was made: in Figma the same component, on a website the site's own class names on the
   element;
   (c) they look exactly the same at the design width and differ only on smaller screens.
   B: only (a) and (b). On your scan that leaves out 20 of the 30 copies found (the headings that are one size on
   desktop and another on phones, the cards that differ only in their padding on tablets). C: only (a): 2 copies on
   your scan, 4 on the hydraulics file.
2. **How different may a copy be and still share the class?** ⭐ **A: at most two kinds of setting** (say its padding
   and its hover colour). Every copy I found on your scan, the B-Dry stand-in and the five Figma files differs in one
   or two (28 in one, 2 in two on your scan); with three, a blue button and a gold one of the same words would
   become "the same button" with three settings of its own each. B: one kind. C: three kinds (2 more copies on your
   scan).
3. **Where does a copy's own difference live?** ⭐ **A: on the element itself, in both tools** (in Bricks: click the
   copy with no class selected and you see its own value). Bricks gives an element's own setting the last word over
   every class at every width and on hover, whatever order the classes print in; I proved it in Chrome with Bricks
   2.3.9's and 2.4.2's CSS (148 readings). This changes one phrase of the standard: "that copy's real difference stays
   on its own class" becomes "stays on the element" (its point 2 already says "a one-off tweak sits on the element").
   B: on the importer route in the copy's own class. Two classes of one element would then write the same property, and
   which wins depends on the order Bricks prints classes in and on whether each value is a setting or Custom CSS.
4. **Two groups that each are a class already** (two "Call" buttons that look one way, two that look another). ⭐ **A:
   they stay two classes.** A class that exists is never dissolved into another, so no page loses sharing it has
   today. Merging them made 10 to 59 elements a file carry their own values where today they share a class (on the
   GRO file five menu texts would each carry their own size). B: merge them when the words and link are the same.
5. **The class's name.** ⭐ **A: a class whose elements all have the same words is named after them**:
   `bd-button-call-us-now`, `bd-button-schedule-an-inspection` (the prefix and the rest as short-class-names names
   classes; before that job is on main, `home__button-schedule-an-inspection-<4 letters>` and
   `button-call-us-now-<4 letters>`).
   Any other class keeps the name it has today. B: no words in names (`bd-button-primary`, `bd-button-3`).
6. **A website's own class names.** ⭐ **A: they count only where they tell something**: when more than half of the
   elements carrying the same names look exactly alike (five flip-card buttons alike, the sixth with another hover
   colour: the sixth joins). On an Elementor site every button carries the same generic names, so the names alone
   say nothing there. B: always count them. On your scan that put 15 headings of other sizes into the 20 px heading
   class, each with its size on itself, and a blue button into the orange buttons' class.
7. **Where it applies.** ⭐ **A: every paste of both tools, with no flag**: `npm run site`, `site:upload`,
   `site:import`, section pastes, the boxes a button opens, the plain route and `--elementor`, and every Figma design.
   A website capture converted in the Figma panel stays byte for byte. B: behind a flag.

## Notes on the brief

Two lines of the brief reached me cut ("…what this job assumes from ea" and an item 3 of "The plan must settle" of
which only "px." is left). I read them as "…assumes from each" and "the counts before and after and the worst move in
px", and answer both below ("What I measured", "Overlaps and order").

## What Justin will see (the prototype's real pastes)

**Your 2026-11-11 scan, `--elementor`** (`<P>/site-proto-facts.txt`, `<P>/site-proto-why.txt`):

- The three "Schedule An Inspection" buttons are one class (today: two share one, the third has its own). The class
  holds the font, the padding 12/24, the corners, the shadow and the orange gradient; the hero's copy, whose gradient
  ends a shade lighter, keeps one line on itself:
  `#brxe-jlbqbr { background-image: linear-gradient(180deg, #FFA332 0%, #FFB356 100%); }`. The other two hold nothing.
- The same for the three "View Our Services" buttons, and for the six flip-card buttons (the sixth keeps its hover
  colour).
- Seven headings that are the same on desktop and another size on phones or tablets join their heading class and keep
  that one size; 13 boxes join their card or container class and keep a padding or a picture; 7 rows and columns join
  their layout class and keep one alignment.
- In all: 57 → 64 shared classes; 254 → 282 of the pastes' 685 elements carry one (class uses by kind: text 87 → 99,
  button 15 → 18 of the 23 Buttons, box 99 → 113, layout 84 → 93); 30 copies keep 39 short rules of their own. All 57
  classes of today keep their name, id and rules.

**The hydraulics Figma file** (`<P>/proto-facts.txt`, `<P>/dump-call-buttons.txt`): its ten Buttons share no class
today, because the plugin's phone rules give each its own side padding on upright phones. Now the four "Call Us Now"
buttons are one class (yellow, padding 26/15, the border, the shadow), and each copy keeps only
`_padding:mobile_portrait`; the two "Schedule Now" buttons are another. Change the class's background or its top
padding once and all four change (`<P>/change-once-plugin-hydraulics.txt`).

## What I measured

**Groups by exact look today against by this plan's rule** (the prototype: real pastes, not a count on paper):

| Input | Shared classes | Class uses (an element with a box and a layout class counts twice) | Copies joined | What they keep |
|---|---|---|---|---|
| Your scan, `--elementor` (493 site elements) | 57 → 64 | 285 → 323 | 30 | 39 rules (28 copies one kind of setting, 2 two) |
| Your scan, plain route (643) | 60 → 68 | 319 → 359 | 30 | 41 rules |
| B-Dry stand-in, `--elementor` (493) | 58 → 65 | 288 → 326 | 30 | 39 rules |
| B-Dry stand-in, plain route (642) | 61 → 68 | 325 → 367 | 34 | 46 rules |
| GRO home (Figma) | 43 → 43 | 306 → 307 | 1 | a row's wrap and alignment on phones |
| Brainstorm (Figma) | 62 → 65 | 364 → 385 | 16 | padding 10, a row's direction 3, wrap 2, a size 1 |
| Hydraulics home (Figma) | 16 → 18 | 132 → 139 | 5 | 4 Buttons their phone padding, 1 column its alignment |
| Repairs (Figma) | 11 → 15 | 58 → 70 | 8 | 4 Buttons and 4 cards their padding |
| Services (Figma) | 33 → 37 | 584 → 602 | 11 | 5 padding, 6 a row's direction or alignment |

By sign on your scan (`--elementor`): the same at the design width 20, the site's own class names 8, the same words
and link 2. On the Figma files: words and link 7, the same Figma component 2, the same at the design width 32.
Every class of the base keeps its id and name on all nine inputs; with the switch off the prototype's pastes are byte
for byte the base's (`<P>/proto-facts.txt`, `<P>/site-proto-facts.txt`).

**Nothing moves** (worst move: 0 px):

| Run | Result |
|---|---|
| Plugin, five real files × 18 widths (1728 … 320: every tier, laptops 1100–1300, 375/360/320), Bricks 2.3.9 CSS: every element by id, box (0.5 px) and computed font, colours, padding, border, shadow | 90 of 90 the same (`<P>/geo-all-bricks239.log`) |
| Plugin, five real files × 8 widths, Bricks 2.4.2 CSS | 40 of 40 the same (`<P>/geo-all-bricks242.log`) |
| Importer, your scan `--elementor`, the joins off against on, every element's whole computed style (with `::before` and `::after`) and box at one width per range (15 widths) | 15,360 readings, 0 differ (`<P>/style-diff-justin-el.log`) |
| Importer, B-Dry stand-in `--elementor`, 6 widths | 4,368 readings, 0 differ (`<P>/style-diff-standin-el.log`) |
| Importer, B-Dry stand-in, plain route, 4 widths | 3,268 readings, 0 differ (`<P>/style-diff-standin-plain.log`) |
| Importer, your scan, plain route, 4 widths | 4,568 readings, 1 differs: the reading flake below, nothing of this job (`<P>/style-diff-justin-plain.log`) |

Two things the first importer run showed, both settled (`<P>/style-diff-justin-el-1-pictures-not-swapped.log`):
- The drawing tool `test/web/lib/site-check.ts` `pastePictures` swaps a picture's address for the capture's bytes
  only in classes' Custom CSS (`:261-264`), so a copy's own background picture, now on its element, was drawn from its
  address (26 readings). The paste itself was the same. Task 9 makes the tool swap an element's Custom CSS too; with
  that the run is the 0 above.
- One section's `animation-name` read `none` in one tab and its name in the other at one or two widths, in both
  directions. It is the drawing's own flake, not this job's: the same paste (the joins off) drawn twice and compared
  differs in exactly that reading in 2 of 3 runs (`<P>/style-diff-same-twice.log`). The build's web tests read with
  `test/web/lib/style-equal.ts`, as site-shared-styles' do, and Task 2 checks that it holds that reading still.

**Change it once** (`<P>/change-once-plugin-hydraulics.txt`, `<P>/change-once-site-justin-el.txt`, Bricks 2.3.9 and
2.4.2 CSS, 1440 … 390): the class's top padding changed once: exactly its 4 (hydraulics) and 3 (your scan) carriers
changed, every one to the new value, and no other element.

**The mechanism by itself** (`<P>/cascade-probe.ts`, `<P>/cascade-probe.txt`, 148 readings, both Bricks versions): one
class on six Buttons, each copy keeping another kind of difference on its element: its own value on upright phones
only; the drawn value where the class squeezes; no hover colour where the class has one; its own value inside one of
the site's own width runs (1025–1366); its own value at every width. Every reading is as claimed, before and after
the class's padding is changed from 26 to 40.

**Rules I tried and dropped** (`<P>/sim-*.txt`, counts on paper from `<P>/simulate.cjs`):
- the site's class names always (Q6 B): on paper 74 copies on your scan instead of 32, among them 15 headings of
  other sizes joining the 20 px heading class;
- merging classes that exist (Q4 B): 2 to 7 classes a file dissolve and 10 to 59 elements carry their own values;
- a limit of 1 or 3 kinds (Q2): on paper 28 or 34 copies on your scan instead of 32 (the real prototype, which also
  applies G4, joins 30).

**The base's unit suite** in a scratch export (no `node_modules`): 3,809 tests, 3,719 pass, 3 fail (environment:
`sandbox-convert.test.ts`, the build test, `web-architecture.test.ts`), 87 skipped. The prototype: 10 more fail, all
tests that pin what this job changes on purpose ("Tests that pin today's output").

## What Bricks does (read, not guessed)

- **An element's own settings print under `#brxe-<id>`, a class's controls under `.<class>.brxe-<element>`, a
  class's Custom CSS as written.** Read on B-Dry staging's Bricks 2.4.2
  (`evidence/quote-button-hover/planner/post-155.min.css`: 617 `#brxe-…` rules, `#brxe-…:hover` among them;
  `evidence/site-reviews/planner/staging-homev2-2026-11-09.html`: 374 `.<class>.brxe-<element>` blocks) and in the
  repo's renderer of live 2.3.9 (`test/browser/render-order.ts`). So an element's own rule (1,0,0) outweighs every
  class rule, its hover rule (1,1,0) every class hover rule (0,3,0), at every width.
- **Classes print in the order they are first met** (Bricks 2.2 `includes/assets.php` L1011-1068, L3709-3731:
  `$global_classes_elements`, saved in `evidence/site-shared-styles/planner/bricks-2.2/assets.php`). That is why Q3 B
  would need care, and why Q3 A needs none.
- **Bricks rewrites an element's own id inside its own settings on paste** (`reference/bricks/README.md` "Ids on
  paste"), so `#brxe-<id>` in an element's own Custom CSS stays its own. The importer already writes such rules on
  Offcanvas elements (5 on your scan).
- Not seen on a live site yet: a class edited in Bricks' builder with a copy's own value beside it. The last
  criterion (live) is that proof.

## The rule (one rule for both tools)

A **look** is what site-shared-styles (R1–R3) and plugin-parity (S1, S4, S5) already make of an element: its
properties of one kind (text, button, box, layout) at every width and state. Nothing of that changes: not the kinds,
not what a look takes, not the counts (2 texts, 2 buttons, 3 boxes, 3 layouts).

- **G1. A class stays a class.** A look enough elements draw exactly is one class with the rules, the id and the name
  it has today (but for Q5's words). It never joins another class (Q4 A).
- **G2. A leftover may be a copy.** A look fewer elements draw than a class needs joins a class when one of its
  elements and one of the class's are the same Bricks element and one of these holds:
  - (a) **the same words and the same link**: words lower-cased with runs of white space as one space; the link as the
    paste writes it; only an element with both (a Button, a text that is one link);
  - (b) **the same name**: the plugin: an instance of the same Figma main component (`main:<id>`), or the layer of
    that component it stands for inside an instance (`layer:<the last part of Figma's I<instance>;<layer> id>`); the
    importer: the site's class names on the element, sorted, those only one element of the page carries left out.
    A name counts only where it **tells** a look: more than half of the elements carrying it (one Bricks element, one
    kind) draw the class's exact look;
  - (c) **the same at the design width**: the plugin: the look's design-width values and fluid values; the importer:
    its values at the design width's range (`web.code.statesAt`, else the widest) and what its own states change.
- **G3. Only a little may differ:** at most `MAX_KEPT = 2` kinds of setting. A kind is a property with its sides folded
  (`padding-left` and `padding-block-end` are padding; the four `border-…-color` one; the corners one; `row-gap` and
  `column-gap` gap; `fill` with `color`), counted once whatever the widths and states it differs at.
- **G4. A copy must be able to carry the class.** It keeps its own look where:
  - it doesn't set exactly the properties the class sets (a property the class sets and the copy never does can't be
    undone on the element);
  - both tools: a part differs that has no place on the element (the importer: a `::before`/`::after`, a words' inline
    element, an absorbed part; the plugin: a Button's drawn icons stay on it already);
  - the importer: a state the class sets and the copy doesn't can only be set back to one value the copy declares at
    every width; a look an ancestor's state sets on the copy for a property it would keep (the element's own rule
    would outweigh it);
  - the plugin: the class is a grid layout (a tier's alignment is another Bricks key there); a value that would have to
    be written back at a tier is a fluid one.
- **G5. Which class.** Leftovers are taken most elements first, then first on the page. Each joins the class it
  differs least from, then the one most elements carry, then the first on the page. A leftover that finds none can
  be joined by later ones; together they are a class only once they reach the count (2, 2, 3, 3), with the first's
  rules. So the same input always gives the same classes.
- **G6. What the class holds.** Its own look, as today. A class made of leftovers holds the first one's look. Its
  purpose (`h2`, `card`, `row`) is read from its own elements, never from its copies, so no class of today is renamed
  by a copy joining it.
- **G7. What a copy keeps, on the element itself.** The fewest values that draw it as before:
  - the importer: for each property and each kept range where its value differs from the class's, its own value
    there, written through `fromStates` like a class's (a control where Bricks has one for it, else the element's
    Custom CSS under `#brxe-<id>`, in bounded runs as `blocks.ts` writes them); for each state, its own value, or its
    plain value where the class's state would otherwise show. Its own class is written without the look's
    properties, as for any carrier.
  - the plugin: for each path, its design-width and fluid values where either differs; then down the tiers (tablets,
    sideways phones, upright phones) its own value wherever the class's would show another, and the value it shows
    there written back where it has none of its own at that tier.
  - Two numbers the paste writes the same way are the same value (the plugin compares numbers to 0.01: Figma's
    25.999923 and 26 are both written 26).
- **G8. One writer still.** No two classes of an element write one property. An element writes a property its class
  writes only as G7 says, and class and element together give exactly the declarations the element had.
- **G9. One decision a page.** The importer decides over the header, the page and the footer together, and a section
  paste and an opened box take the page's decision (as site-shared-styles does). The plugin decides per design (a drawn
  phone design apart), counting Figma layers.

## Design

### C1. One module both tools use: `src/shared/copies.ts` (new)

Pure, built-ins only (`src/shared` is on `test/unit/site-isolation.test.ts`'s allow-list, `:46-47`, and the Figma
conversion may load it). The whole file, run with its own cases in `<P>/copies.proto.ts` and
`<P>/copies.proto.test.ts` (1 test, pass):

```ts
// The copies of one thing (look-grouping; Justin, 2026-11-13: "all call me buttons should change … identify them by
// name"): which looks too few elements draw to be a class join a class of the same thing. One rule for both tools: the
// website importer (src/core/site/share.ts) and the Figma plugin (src/core/emit/looks.ts) each give it their looks and
// say what a copy would keep. Pure, built-ins only.

// how many kinds of setting a copy may keep on itself and still carry the class (Q2 A)
export const MAX_KEPT = 2;
// element: its Bricks element; thing: its words and its link ("" when it has no words or no link); name: the Figma
// component it comes from, or the site's own class names on it ("" none)
export interface CopyItem { element: string; thing: string; name: string }
// a look as its tool wrote it: key, its rules; kind (text, button, box, layout); uses, how many elements (the plugin:
// Figma layers) draw it; first, where it first shows on the page; design, its rules at the design width alone; items,
// its elements
export interface CopyLook { key: string; kind: string; uses: number; first: number; design: string; items: CopyItem[] }
export type CopyWhy = "the same words and link" | "the same name" | "the same at the design width";
// a look joined to a class: the class's key, why, what each of its elements keeps on itself (the tool's own shape) and
// how many kinds of setting that is
export interface Joined<K> { to: string; why: CopyWhy; kept: K; kinds: number }

// looks: every look of the page (or of one Figma design) in any order; min: how many elements make a class, by kind;
// keptOf: what a copy of `cls` drawing `copy` would keep on itself, null where it can't carry the class.
// Returns each joined look and every class's count with its copies.
export function joinCopies<K>(looks: CopyLook[], min: Record<string, number>,
  keptOf: (copy: CopyLook, cls: CopyLook) => { kept: K; kinds: number } | null): { joins: Map<string, Joined<K>>; uses: Map<string, number> } {
  // a name tells a look when more than half of the elements carrying it (one Bricks element, one kind) draw that look
  const byName = new Map<string, Map<string, number>>();
  const nameKey = (l: CopyLook, i: CopyItem): string => `${l.kind}\u0000${i.element}\u0000${i.name}`;
  for (const l of looks) for (const i of l.items) {
    if (!i.name) continue;
    const m = byName.get(nameKey(l, i)) ?? new Map<string, number>();
    m.set(l.key, (m.get(l.key) ?? 0) + 1);
    byName.set(nameKey(l, i), m);
  }
  const tells = (l: CopyLook, i: CopyItem): string | null => {
    const m = byName.get(nameKey(l, i));
    if (!m) return null;
    const all = [...m.values()].reduce((a, b) => a + b, 0);
    const [key, n] = [...m].sort((a, b) => b[1] - a[1] || (a[0] < b[0] ? -1 : 1))[0];
    return all >= 2 && n * 2 > all ? key : null;
  };
  const why = (a: CopyLook, c: CopyLook): CopyWhy | null => {
    let named = false, alike = false;
    for (const x of a.items) for (const y of c.items) {
      if (x.element !== y.element) continue;
      alike = true;
      if (x.thing && x.thing === y.thing) return "the same words and link";
      if (x.name && x.name === y.name && tells(a, x) === c.key) named = true;
    }
    return named ? "the same name" : alike && a.design === c.design ? "the same at the design width" : null;
  };
  const byKey = new Map(looks.map((l) => [l.key, l]));
  const uses = new Map(looks.map((l) => [l.key, l.uses]));
  const joins = new Map<string, Joined<K>>();
  // a look enough elements draw is a class and stays one (Q4 A); the others, most elements first, then first on the page
  const classes = looks.filter((l) => l.uses >= min[l.kind]).sort((a, b) => a.first - b.first);
  const left = looks.filter((l) => l.uses < min[l.kind]).sort((a, b) => b.uses - a.uses || a.first - b.first);
  for (const l of left) {
    let best: { c: CopyLook; j: Joined<K> } | null = null;
    for (const c of classes) {
      if (c.kind !== l.kind) continue;
      const reason = why(l, c);
      if (!reason) continue;
      const k = keptOf(l, c);
      if (!k || k.kinds > MAX_KEPT) continue;
      // the class it differs least from, then the one most elements carry, then the first on the page
      const more = best !== null && (k.kinds < best.j.kinds || (k.kinds === best.j.kinds && uses.get(c.key)! > uses.get(best.c.key)!));
      if (best === null || more) best = { c, j: { to: c.key, why: reason, kept: k.kept, kinds: k.kinds } };
    }
    if (best) { joins.set(l.key, best.j); uses.set(best.c.key, uses.get(best.c.key)! + l.uses); }
    else classes.push(l);   // no class of its thing yet: later copies may join it
  }
  // copies that together never reach the count make no class: their looks stay on their elements, as before
  for (const [k, j] of [...joins]) if (uses.get(j.to)! < min[byKey.get(j.to)!.kind]) joins.delete(k);
  return { joins, uses };
}
```

Also in the module: `wordsSlug(words: string): string` (lower case, accents left off, every run of other characters
one dash, the first three words, at most 24 characters, no dash at an end; "" when nothing is left), for Q5's names.

### C2. The importer (`src/core/site`)

The prototype's diff is `<P>/proto-all.diff` (it wrote a copy's values as Custom CSS only and kept the rule inside
`share.ts`; the build moves the rule into the shared module and writes controls too). Where things go:

- `src/core/site/copies.ts` (new, at most 200 lines; not `names.ts`, which is importer-parity's):
  - `itemOf(t, tokens)`: a tree element's `CopyItem`: its words (a Button's `settings.text`, else `wordsOf` of its
    node's `html`) and link (`settings.link.url`, else its node's `href`); its name: the names in `node.marks.class`
    that more than one own-classed element of the page carries, sorted and joined by a space. `marks`
    holds the page's own `class` attribute since capture version 2 (`src/web/read/code.ts:32` `MARKS`,
    `src/core/snapshot/web.ts:50`); a capture without it gives no name, and signs (a) and (c) still work.
  - `familyOf(property)` (G3) and `designOf(row, index)` (G2 c).
  - `keptOf(copy: Row, cls: Row)`: G4's refusals, then per kept range the copy's declarations that differ from the
    class's, and per state its own or its set-back value: `{ kept: { states: CodeDecls[]; self: StateCss[] }, kinds }`.
  - `keptSettings(el, kept, ranges, ink, options)`: the element's own settings from `kept`: `fromStates(kept.states,
    el, false, ranges, …)` (no Background → Image step: a kept picture stays CSS, named in the notes), its controls
    through `inked`, its Custom CSS through a new `classes.ts` `rulesAt(selector, own, states, ink)` with the selector
    `#brxe-<id>` plus the look's `where.self`.
- `src/core/site/share.ts`:
  - `Row` gains `cand: Candidate` and `items: CopyItem[]`; `lookKeys(count, copies = true)` (`:37-51`) builds a
    `CopyLook` per row (`uses` its elements, `first` as today, `design` from `designOf`), calls `joinCopies` with
    `MIN_USES` and `keptOf`, and returns the classes (G1 and G5's) with their counts; a new `copiesOf(rows)` gives the
    joins (`Map<look key, Joined<Kept>>`). A class's `carriers` stay its own elements (G6).
  - `applyKeys` (`:55-71`): a candidate whose key joined a class is `given` like a carrier's (its own class is written
    without the look's properties), carries the class's key, and its spec gets `kept` (several where a box's box look
    and layout look both joined). The element-level refusal of G4 (an ancestor's state) is taken here, per element.
  - `pageInk` (`:88-100`) also counts the colours of every `kept` value, so a colour only a copy shows is a palette
    colour too.
  - `sharedNotes`: one more line (below).
- `src/core/site/convert.ts`: `ConvertOptions.copies?: boolean` (`:67`; on unless `false`; a test and diagnosis
  switch no command line sets, like `looks` and `palette`); the spec's `kept`; `payloadOf` (`:555-578`) merges
  `keptSettings` into the element's settings; `pageLooks` (`:614-626`) passes the switch, so a section paste takes
  the page's decision.
- `src/core/site/parts.ts` `sitePage` (`:69-…`): passes the switch to `lookKeys`; after `withStates`, each element's
  kept settings with the page's ink.
- `src/core/site/looks.ts:1-7`: the comment's "never a site's ids, class names or words" becomes "a look is read
  from structure, declared CSS and computed text settings only; which looks are copies of one thing also reads the
  page's words, links and class names, only to compare them with each other (copies.ts), never a particular one".
- **Notes** (each part, after site-shared-styles' lines): `Copies: <n> elements carry a shared class and keep a value
  of their own on the element (<a> by their words and link, <b> by the site's class names, <c> the same at the design
  width); click one with no class selected to see it`. No line when none.
- `tools/lib/site-write.ts` `styles.txt`: under each shared class, `copies: <n>` and one line per copy (its words or
  label, the kinds it keeps).
- `test/web/lib/site-check.ts` `pastePictures` (`:254-260`): also swaps the addresses in an element's own
  `_cssCustom` (the prototype's two lines), so `site:check` and the tests draw a copy's own picture from the
  capture's bytes.
- Not touched: the capture (`src/web`), `kinds.ts`, `controls.ts`, the Figma panel's website route, `src/ui`.

### C3. The plugin (`src/core/normalise`, `src/core/emit`)

- `src/core/normalise/scene.ts` `SceneNode.component?: string` ("the Figma component it comes from: `main:<id>` for
  an instance, `layer:<id>` for a layer inside one; absent: none"), set where the node is made
  (`src/core/normalise/normalise.ts:179-181`, from `ctx.snap.instances[n.id]` and the node's id): the stage that knows
  it records it. The prototype passed `snapshot.instances` to emit instead; the build doesn't.
  `Snapshot.instances` holds each instance whose main was saved (at most 80 components, `src/plugin/extract/
  components.ts:9`); an instance past that has no name, and signs (a) and (c) still work. No extract change.
- `src/core/emit/looks.ts` (173 lines today; with this at most 260, else `keptOf` moves to `emit/look-copies.ts`):
  - each look keeps its elements' `CopyItem`s (words from `n.words ?? label.text.characters`, the label a Button's
    `n.text`, else `n.src`; link `elementLink(n)`; name `n.src.component`; boxes and layouts have no words);
  - `keptOf(copy, cls)`: the same paths, else null; per path G7's walk: `{ base: Set<path>, tiers: Record<tier,
    Set<path>>, back: Layers }` (`back`: the values written back at a tier); G4's grid and fluid refusals;
  - after the looks of a design are collected (`:133`), `joinCopies(looks, MIN, keptOf)`; a class is made for every
    look that is a class or was joined (`:134-148`), its count the layers of its own elements and its copies';
    `Shared.of` gets, for a copy, the class's key, the class's paths and `keep`;
  - `without(style, paths, keep)` and `layersWithout(tiers, paths, keep)` leave the kept paths on the element and add
    `keep.back`.
  - Not in the prototype: it refuses every copy that would need a value written back at a tier and compares numbers
    exactly, so its counts can only grow in the build; the fourteenth criterion's test covers both.
- `src/core/emit/elements.ts:108-110`: passes `look.keep`; `SharedLook` (`ConvertResult.shared`) gains `copies:
  number` (how many of its `uses` keep a value of their own).
- `src/core/convert.ts`: `AsBefore.copies?: true` (the looks as plugin-parity made them); `emitPayload(…, { looks,
  copies: before.copies !== true, … })`.
- `tools/lib/styles-text.ts`, `tools/replay.ts`: `styles.txt` lists each class's copies; the summary says
  `<n> shared looks (<m> copies)`.
- Not touched: `src/core/adapt/**`, `src/core/style/**`, `src/core/understand/**`, `src/plugin/**`, `src/ui/**`,
  `reference/bricks/*.json`. A website capture (`page.capture`) has no looks and so no copies.

### C4. Names (Q5 A)

A class all of whose elements, copies included, are one thing by sign (a) (the same words and link) is named after
the words, `wordsSlug(words)`:

| On main when this job builds | Importer | Plugin |
|---|---|---|
| `src/shared/class-names.ts` (short-class-names) | `nm.named("button-<slug>", rules)` in `share.ts` `lookNames`, in the place and order that plan gives look classes: `bd-button-schedule-an-inspection`; a second class of the same words takes `-2` | the same call in `emit/elements.ts`: `bd-button-call-us-now` |
| not there yet | `versioned("<page>__button-<slug>", rules)`: `home__button-schedule-an-inspection-<4 letters>` | `button-<slug>-<4 letters>` in `looks.ts:137-138` |

The purpose word is the class's (`button`, `heading`, `text`). An empty slug, or elements with other words, leaves the
name as it is today. The rules a name is keyed by are the class's own, so a copy joining a class never changes its
name or id, and Bricks asks about no class on a re-paste.

## The standard, point by point

1. **Structure:** not touched. No element is added, removed or renamed; ids don't change.
2. **Classes:** this job is the line "the same button shares one class". A copy carries the class of its thing; its
   real difference is one or two values on the element, where a Bricks pro looks for a one-off; a class named after
   its words reads at a glance (`bd-button-call-us-now`). Never two classes writing one property (G8). No class is
   lost: every class of today stays (G1). Q3 A changes the standard's words "on its own class" to "on the element".
3. **Settings before custom CSS:** a class's values are written as today. A copy's own value goes through the same
   writer, so it is a control where Bricks has one (the plugin: always the element's own controls; the importer: a
   plain value on Bricks' breakpoints) and the element's Custom CSS only where the class's own would be CSS too (a
   gradient, one of the site's own width runs). Colours stay palette links. Sizes are not changed here (clean-values).
4. **Bricks' own behaviour:** not touched.
5. **Editable content:** not touched; words, links and pictures stay where they are.
6. **Looks stay true:** the whole point of G4, G7 and G8: a copy that can't keep its difference exactly stays as it
   is today (exact wins), and the notes say how many copies there are. Measured: 0 px on every input.

## Acceptance criteria (all **proposed**)

"The switch" is `ConvertOptions.copies: false` (importer) and `ConvertOptions.asBefore.copies` (plugin): the looks as
the base makes them. Fixtures are generic, never copies of B-Dry or of a file. "Drawn" means with Bricks' own
front-end CSS in Bricks' print order, as `site:check` and plugin-parity's browser tests draw. "Every tier" is 1440,
1200, 1024, 800, 767, 600, 390, 375, 360 and 320.

- AC1 (proposed): Given looks of one kind, a look too few elements draw joins a class of the same Bricks element with the same words and link, or with a name more than half of whose elements draw the class's look (4 of 5 yes; 3 and 3, 2 of 4 no), or with the same design-width rules; never when more than two kinds of setting differ or `keptOf` says it can't; it takes the class it differs least from, then the one most elements carry; a look that is a class never joins another; leftovers of one thing are a class together only once they reach the count; the same looks in any order give the same joins. Test `test/unit/copies.test.ts` "the shared rule: a look too few elements draw joins the class of the same thing; a class stays a class".
- AC2 (proposed): Given a scanned page with three Buttons of the same words and link, two alike and one whose background differs, all three carry one button class holding the two's rules; the third's element holds only its background, as its own setting or `#brxe-<id>` rule, and its own class none of the look's properties; a Button of the same words and link that differs in three kinds of setting, and a text link of the same words (another Bricks element), share nothing with them. Test `test/unit/site-copies.test.ts` "buttons with the same words and link share one class; the one that differs keeps only its difference on itself".
- AC3 (proposed): Given boxes that carry one of the site's class names, four alike and one with another padding, the fifth joins their class and keeps its padding; where the same names sit on two looks of three, or on eight looks among ten elements, nothing joins by the names; a name only one element carries counts for nothing; a capture without `marks` joins nothing by names and converts without error. Test `test/unit/site-copies.test.ts` "the site's own class names join a copy only where most of their elements look alike".
- AC4 (proposed): Given headings that draw alike at the design width's range, two alike everywhere and one with another font size on phones, the three carry one text class and the third's element holds only that size at those widths (a bounded run, or a control where the widths are Bricks' own); headings that differ at the design width share nothing by this sign. Test `test/unit/site-copies.test.ts` "elements that look the same at the design width share one class and keep their other widths on themselves".
- AC5 (proposed): Given copies that can't keep their difference on the element (a property the class sets and the copy never does; another `::before`; a state the class sets that the copy can't set back to one value; a property an ancestor's hover also sets on the copy), each keeps its own look as with the switch; a state the class sets and the copy doesn't is set back to the copy's own value on the element; and every class the paste holds with the switch keeps its id, name and settings without it, but for a name Q5's words change. Test `test/unit/site-copies.test.ts` "a copy that can't keep its difference stays as before, and every class that existed keeps its rules".
- AC6 (proposed): Given any paste of any code fixture (both routes, both text modes, parts and sections), no two classes of one element write one property under one condition; an element's own settings write a property only where its shared class writes it too; and for every element its classes' declarations with its own on top are exactly the declarations it had with the switch, at every range and state. Test `test/unit/site-looks-one-writer.test.ts` "an element's own rule beside its class writes only what differs, and class and element together are what the element had".
- AC7 (proposed): Given the fixture sites `site-copies` (new), `shared-looks`, `plain-natives` and `elementor-natives`, each captured and converted with the switch and without it, drawn with Bricks 2.4.2's CSS and with 2.3.9's at every width the capture read, every element that takes a box has the same computed style (every property, its `::before` and `::after`) and the same box (0.5 px) in both drawings, the buttons also under a forced hover and focus; the test first asserts that the `site-copies` paste holds copies of all three signs. Test `test/web/site-copies.test.ts` "with copies joined every element draws as without them, at every width, Bricks 2.4.2 and 2.3.9".
- AC8 (proposed): Given the `site-copies` paste drawn at 1440 and 390 with both Bricks versions, changing one value of a class that has copies (a button class's padding, a text class's font family, a box class's background colour) changes that property on every element carrying the class, copies included, and on no other element; changing in the class a property one copy keeps changes every carrier but that copy. Test `test/web/site-copies.test.ts` "changing a class changes every copy and no other element; a value a copy keeps stays".
- AC9 (proposed): Given B-Dry's saved 2026-10-29 home served on 127.0.0.1 (never the live site), with the Elementor step and without it, the pastes hold copies (three Buttons of the same words in one class among them), every element that takes a box draws as with the switch at one width per range (Bricks 2.4.2 and 2.3.9), and no `site:check` row is worse than the base's by more than 0.5 px. Test `test/web/site-copies-bdry.test.ts` "B-Dry's saved page draws the same with copies joined, on both routes" (named-only: `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`).
- AC10 (proposed): Given the switch, every paste of every code fixture (the list `test/unit/lib/site-pins.ts` gives) is byte-identical to the base's, by sums recorded on the base in Task 1. Test `test/unit/site-copies-off.test.ts` "with copies off every website paste is byte for byte as before them" (named-only: `F2B_PIN_BASE=1`, a story-time pin).
- AC11 (proposed): Given `npm run site` on a capture with copies, each part's notes hold the `Copies:` line with its three counts, `styles.txt` lists under each shared class its copies with what each keeps, a section paste writes the same, a capture with no copies has no such line, and the usage lines are unchanged. Test `test/web/site-cli.test.ts` "site names the copies in its notes and in styles.txt".
- AC12 (proposed): Given a Figma page with four Buttons of the same words and link whose side padding on upright phones the rules made differ, and a fifth of the same words in another colour, font and padding, the four carry one button class; three hold nothing of the look but `_padding:mobile_portrait`, the first nothing; the fifth keeps its own settings; a text of the same words shares nothing with them. Test `test/unit/plugin-copies.test.ts` "buttons with the same words and link share one class; each keeps only the phone padding the rules gave it".
- AC13 (proposed): Given instances of one Figma component, seven alike and two with another padding, the two join the seven's class and keep their padding on themselves; instances of a component whose looks are three and three join nothing by it; a layer inside the instances joins by the component's layer it stands for; a file with no components converts without error. Test `test/unit/plugin-copies.test.ts` "instances of one Figma component share its class where most of them look alike".
- AC14 (proposed): Given elements alike at the design width, one whose tier values differ joins and keeps only those; where the class squeezes a value at a tier and the copy doesn't, the copy's value is written back at that tier; numbers the paste writes the same way (25.999923 and 26) are no difference; a copy of a grid layout class, a copy whose paths differ from the class's, and a text with a Figma text style join nothing. Test `test/unit/plugin-copies.test.ts` "a copy keeps the fewest values that draw it as before: its own tiers, a value written back, never a Figma text style's text".
- AC15 (proposed): Given any Figma design, each element's settings read through its look classes with its own settings on top (a group such as padding side by side, at every tier, a wider tier's own value showing at the narrower ones) equal its settings with the switch's `looks`, key for key, and an element writes a path its look class writes only where G7 says. Test `test/unit/plugin-looks-resolve.test.ts` "read through its look classes with its own values on top every element's settings equal the paste without looks: every fixture and corpus file, both picture modes".
- AC16 (proposed): Given the drawn set (plugin-parity's `test/browser/drawn-set.ts`) and the generic page `copiesPage` (new), converted with the switch and without it, every element has the same box (0.5 px) and the same computed font, colours, background, padding, border, corners, shadow, display, direction, wrap, alignment and gaps at every tier, drawn with Bricks 2.3.9's CSS and with 2.4.2's; the test first asserts that `copiesPage` holds copies of all three signs. Test `test/browser/plugin-copies.test.ts` "with copies joined every element of the drawn set draws as without them at every tier, with Bricks 2.3.9 and 2.4.2".
- AC17 (proposed): Given the `copiesPage` paste drawn at 1440 and 390 with both Bricks versions, changing one value of a look class that has copies (its background colour, its top padding) changes that property on every element carrying it, copies included, and on no other element; changing its side padding at the design width changes every carrier at 1440 and leaves each copy's own phone padding at 390. Test `test/browser/plugin-copies.test.ts` "changing a look class changes every copy and no other element; a value a copy keeps stays".
- AC18 (proposed): Given the switch, every Figma paste (every generic fixture, the corpus files, both picture modes, the ticks on and off) equals the base's byte for byte, by sums recorded on the base in Task 1. Test `test/unit/plugin-copies-pin.test.ts` "with copies off every Figma paste equals the base's" (named-only: `F2B_STORY_PINS=1`, a story-time pin).
- AC19 (proposed): Given a website capture converted in the panel's way (`convert` on a snapshot with `source: "web"`), the paste is the same with and without the switch and holds no look class and no copy. Test `test/unit/plugin-copies-captures.test.ts` "a website capture converts the same with and without copies: no look class, no copy".
- AC20 (proposed): Given the plugin's own conversion and Figma's sandbox, the plugin's paste is exactly a replay's and the new code uses only the language's built-ins. Test `test/unit/plugin-convert.test.ts` "the plugin's paste is exactly what a replay of the same snapshot gives".
- AC21 (proposed): Given a class all of whose elements have the same words and link, in both tools it is named after those words by C4's table for the base it is built on; a class whose elements have other words keeps the name it has with the switch; the class has the same name, id and settings in every paste of a page and on two pages that hold it; a copy joining a class changes neither its name nor its id; and Bricks' own class comparison (`test/fixtures/bricks-paste.ts`) asks about no class when a page is pasted twice. Test `test/unit/copies-names.test.ts` "a class of one thing is named after its words, the same in every paste, and a re-paste asks about no class".
- AC22 (proposed): Given `npm run replay` on a design with copies, its summary line names the count of copies and `styles.txt` lists under each look class its copies with what each keeps; `ConvertResult.shared` holds each class's `copies`. Test `test/unit/replay-styles.test.ts` "replay lists each look class's copies: the summary's count and styles.txt".
- AC23 (proposed) (live): Justin (1) converts bdryswi.com's scan with the new build (`--elementor`), empties B-Dry staging's `/homev2/` and pastes header, page and footer: the page looks as before; he clicks a "Schedule An Inspection" button, picks its `…button-schedule-an-inspection…` class, changes its padding, and all three buttons change; the hero's lighter gradient is still its own (click it with no class selected: its background sits there). (2) He converts the hydraulics page in Figma with "Pictures go: to WordPress", pastes it on darksalmon: he clicks a "Call Us Now" button, changes its class's background colour, and every "Call Us Now" button follows, at 1440 and at 390. Test: Justin's paste check `<look-grouping id at merge>` (HANDOFF "End-of-run check list").

RED on the base: the first five, the seventh and eighth (their first assertion: the paste holds copies), the eleventh
to the fourteenth, the sixteenth and seventeenth (the same first assertion), the twenty-first and twenty-second. The
first's test comes with its module (the rule doesn't exist on the base). Green on the base by design, as regression
pins: the sixth and fifteenth (they hold trivially with no copies; each also asserts that the fixtures hold copies, so
they are RED until the joins exist), the tenth, eighteenth, nineteenth and twentieth.

## Tests that pin today's output (the builder may edit these, and only as said)

The prototype fails 10 unit tests the base passes (`<P>/unit-base-fail.txt`, `<P>/unit-proto-fail.txt`; by name):

| Test (file) | Why it fails | The only edit allowed |
|---|---|---|
| `test/unit/site-looks-one-writer.test.ts` "no two classes of one element write one property, and nothing is lost or added" | it reads an element's declarations from its classes alone ("lost: row-gap 28px") | read the element's own settings on top (the sixth criterion's test, in the same file); the two-classes clause stays as it is |
| `test/unit/plugin-looks-resolve.test.ts` "read through its look classes every element's settings equal…" | "qbrxnx writes `_columnGap:mobile_portrait` and so does row-gkxk" | the fifteenth criterion: an element may write a path its class writes only as G7 says; every other clause stays |
| `test/unit/plugin-looks.test.ts` "elements that draw the same share one class per kind…" | its clause "its tiers differ: no shared look" (the heading whose long word steps down on phones) | that heading now carries the headings' class and keeps its phone size: assert exactly that; the other clauses stay |
| `test/unit/site-inline-own.test.ts` (two tests: "an element its parent reads inline at some widths carries those widths in its own class…", "an element inside it carries the wrapper's reading…") | the label's tablet and phone font sizes moved from its own class to its element (it joined a text class by the design width) | accept the widths in the element's own class **or** on the element itself (which outweighs the parent's rule even more); the rest stays |
| `test/unit/adapt-split.test.ts` (two tests on a zigzag's stacked order) | they read `_direction:<tier>` on the element, which the row's layout class now holds for a copy | read the setting through the element's look classes with `test/fixtures/drawn.ts` `drawnSettings`, as plugin-parity's edits of this kind do |
| `test/unit/cta-names.test.ts` "names change nothing else" | it compares the whole paste with a golden file written once by older code (`test/golden/files/cta-names-base.json`); two of the fixture's Buttons now join a class | convert with `asBefore: { copies: true }` in this test (it pins names, not classes); the golden file is not touched |
| `test/unit/site-motion-old.test.ts` "AC9 a capture made before this build pastes as before…", `test/unit/site-slider-unchanged.test.ts` "pastes without an Elementor slider are byte-identical" | sha256 sums of fixture pastes (`site-elementor-code.elementorBand` moves) | prove per variant that the paste with `copies: false` hashes to the recorded sum, then remake the sums (`planning-checks.md`: the whole-suite rule) |

Any other test that fails outside this list: commit what passes and stop, naming the assertion. Browser and web tests
that read a tier setting or a class's declaration off one element are found the same way in Task 2 (`npm run
test:browser`, `npm run test:web` on the base and after Milestones 2 and 3, compared by name).

## Touched files

New: `src/shared/copies.ts`, `src/core/site/copies.ts`, `test/unit/copies.test.ts`, `test/unit/site-copies.test.ts`,
`test/unit/site-copies-off.test.ts`, `test/unit/plugin-copies.test.ts`, `test/unit/plugin-copies-pin.test.ts`,
`test/unit/plugin-copies-captures.test.ts`, `test/unit/copies-names.test.ts`, `test/web/site-copies.test.ts`,
`test/web/site-copies-bdry.test.ts`, `test/browser/plugin-copies.test.ts`, `test/fixtures/site-copies-code.ts` (a
hand-made capture, as `site-looks-code.ts`), `test/fixtures/web/sites/site-copies/` (a served site, as
`shared-looks`), `test/fixtures/copies.ts` (`copiesPage`, as `shared-looks.ts`), `test/unit/lib/site-copies-pins.ts`,
`tools/copies-sums.ts` (records the base's sums for the tenth and eighteenth criteria).
Changed: `src/core/site/share.ts`, `convert.ts`, `parts.ts`, `classes.ts` (`rulesAt`), `looks.ts` (a comment),
`src/core/normalise/scene.ts`, `normalise.ts`, `src/core/emit/looks.ts`, `elements.ts`, `src/core/convert.ts`,
`tools/lib/site-write.ts`, `tools/lib/styles-text.ts`, `tools/replay.ts`, `test/web/lib/site-check.ts`
(`pastePictures`), `test/web/site-cli.test.ts`, `test/unit/replay-styles.test.ts`, the pinned tests above,
`docs/HANDOFF.md`, `reference/bricks/README.md` ("An element's own rule beside a class": what was read on staging's
2.4.2 and in 2.2's `assets.php`), `docs/plans/<date>-look-grouping.md` and its ledger.

## Tasks (test-first; commit after each passing task, files by name; never commit CLAUDE.md; never bump BUILD in the copy)

### Milestone 0: the base's facts
1. Copy this plan to `docs/plans/<date>-look-grouping.md`; start the ledger (`.superpowers/sdd/<plan>/progress.md`).
   Check `git log main` holds the five jobs' build commits (else stop: the base is wrong). Record on the base:
   `npm run check`'s tally, `npm run corpus` (on the desktop: the two repo files by `replay`, memory
   `corpus-paths-on-desktop`), the unit, browser and web suites by test name; with `tools/copies-sums.ts` the sums for
   the two story pins (written to `test/unit/lib/site-copies-pins.ts` and a plugin twin). Commit.
2. Repeat the planner's measurements on the base and keep them in the ledger: `<P>/proto-facts.ts`,
   `site-proto-facts.ts`, `geometry-diff.ts`, `style-diff.ts`, `change-once.ts` run on a scratch tree with
   `<P>/proto-all.diff` applied (it may need re-fitting where the five jobs moved lines). The planner's runs showed
   one reading that differs between two drawings of the same paste (a section's `animation-name`,
   `<P>/style-diff-same-twice.log`): check that `test/web/lib/style-equal.ts` holds it still on the base; a reading
   that differs only with the joins on is a stop (a copy's own value changed what plays).

### Milestone 1: the shared rule
3. The first criterion's RED: `test/unit/copies.test.ts` from `<P>/copies.proto.test.ts` (import path changed), with
   `src/shared/copies.ts` as in C1 plus `wordsSlug` and its cases (three words, an accent, 24 characters, nothing
   left). Green; `npm run typecheck` (the sandbox config covers `src/shared`). Commit.

### Milestone 2: the importer
4. `test/fixtures/site-copies-code.ts`: a generic page with the shapes of the second to fifth criteria (three Buttons
   of one thing, one differing; one differing three ways; a text link of the same words; five boxes with one site
   class name, the names on two looks of three, a lone name; three headings alike at the design width; the copies
   that can't keep their difference). The second criterion's RED, then `copies.ts` `itemOf`, `familyOf`, `keptOf`
   (declarations only), `share.ts` `lookKeys`/`applyKeys`, `convert.ts` `kept` and `payloadOf`, `classes.ts`
   `rulesAt`, `parts.ts`. Green. Commit.
5. The third criterion (names that tell; a capture without `marks`). Commit.
6. The fourth criterion (`designOf`; bounded runs through `fromStates`; a control where the widths are Bricks' own).
   Commit.
7. The fifth criterion (G4's refusals; a state set back; `pageInk` counts kept colours: one more assertion that a
   colour only a copy shows is in `palette.json`). Commit.
8. The sixth criterion in `site-looks-one-writer.test.ts`, with the pinned tests' edits of the table (importer
   rows). `npm test` whole: compare by name with Task 1. Commit.
9. `test/web/lib/site-check.ts` `pastePictures` and its own unit check; the served site `site-copies`; the seventh
   and eighth criteria (`test/web/site-copies.test.ts`, on `test/web/lib/style-equal.ts`). Commit.
10. The notes line and `styles.txt` (the eleventh criterion). Commit.
11. The ninth criterion on B-Dry's saved page (named-only), with `site:check --all` rows beside the base's, both
    routes; the tenth criterion's pin with the switch. `npm run test:web` whole, by name. Commit.

### Milestone 3: the plugin
12. `SceneNode.component` (a unit assertion in `test/unit/plugin-copies.test.ts`'s first test: an instance, a layer
    inside one, a plain frame). Grep `test/` for tests that deep-equal a whole scene node first; none may change.
    Commit.
13. `test/fixtures/copies.ts` `copiesPage` (a sibling text above each part; three parts; Buttons in rows of other
    widths so the phone rules give each its own padding; a component with nine instances, seven alike; a component
    with looks three and three; a heading whose long word steps down on phones; a row that stacks on phones beside
    rows that don't; a grid). The twelfth criterion's RED, then `emit/looks.ts` items, `keptOf`, `joinCopies`,
    `without`/`layersWithout` with `keep`; `elements.ts`; `convert.ts` `asBefore.copies`. Green. Commit.
14. The thirteenth criterion (names that tell). Commit.
15. The fourteenth criterion (a value written back, numbers to 0.01, the refusals). Commit.
16. The fifteenth criterion in `plugin-looks-resolve.test.ts` and the pinned tests' edits of the table (plugin rows).
    `npm test` whole, by name. Commit.
17. The sixteenth and seventeenth criteria (`test/browser/plugin-copies.test.ts`, plugin-parity's drawing helpers);
    the eighteenth to twentieth; `tools/lib/styles-text.ts`, `tools/replay.ts` and the twenty-second. `npm run
    test:browser` whole, by name. Mutation run under the memory cap for the guards (G3's limit, G4's refusals, the
    "tells" majority, the written-back value): each mutant killed by a named test. Commit.

### Milestone 4: names
18. The twenty-first criterion with C4's row for the base (`src/shared/class-names.ts` on main or not), both tools.
    Commit.

### Close
19. Before/after shots (the skill's rule: this job changes no look, so a text proof instead): for your scan's stand-in
    and the hydraulics file, each class with copies, its elements and what each keeps, base against head, into the
    ledger and `shots[]` as text paths.
20. The close's gates: `npm run check`, `npm run test:browser`, `npm run test:web`, `npm run corpus`, the named-only
    tests with their variables, each by name against Task 1.
21. **Docs & records** (below). Stop at `ready-for-review`.

## Overlaps and order

| Job | State | Shared files | Who owns what, and how they meet |
|---|---|---|---|
| site-no-div | merging (`site-no-div-final` `4a4bfa17`) | `src/core/site/convert.ts`, `parts.ts` | base. Assumed: every box a Block, Buttons by shape, `ConvertOptions.native` |
| site-shared-styles | reviewed (`site-shared-styles-fix1` `7b7501bd`) | `share.ts`, `looks.ts`, `class-source.ts`, `classes.ts`, `convert.ts`, `parts.ts`, `test/unit/site-looks-one-writer.test.ts`, `test/web/lib/style-equal.ts`, `tools/lib/site-write.ts` | base. **It owns what a look is and when looks are equal**; this job owns only which leftovers join a class and what they keep. Assumed: `Row`, `lookKeys`/`applyKeys`/`lookNames`, `ClassSource`, `fromStates`, `ownClass`, the switch `looks`, the fixtures `shared-looks`, `plain-natives`, `elementor-natives`, `site-pins.ts` |
| plugin-parity | building (`plugin-parity-build` `fcdec6e2`) | `src/core/emit/looks.ts`, `elements.ts`, `src/core/convert.ts`, `test/unit/plugin-looks*.test.ts`, `test/fixtures/drawn.ts`, `test/browser/drawn-set.ts`, `tools/lib/styles-text.ts` | base. **It owns the plugin's looks** (S1–S8). Assumed: `sharedLooks`, `Shared.of`, `without`, `layersWithout`, `ConvertOptions.asBefore`, `ConvertResult.shared`. This job changes its S2 for copies only ("an element whose tiers differ keeps its own values" becomes "joins and keeps those values") |
| importer-parity | building (`importer-parity-build`, `1f407006` when this was saved) | `src/core/site/share.ts`, `convert.ts`, `parts.ts`, `class-source.ts`, `controls.ts`, `tree.ts`; it adds `src/core/site/names.ts` | base. This job's new file is `copies.ts`, not `names.ts`. More controls in `fromStates` reach a copy's own values with no change here |
| shared-palette | building (`shared-palette-build` `738e300a`) | `share.ts` (`pageInk`), `colours.ts`, `convert.ts`, `parts.ts` | base. A copy's own colour goes through the same `ink` |
| short-class-names | planned today (`~/.hermes/plans/figma-to-bricks/short-class-names.md`) | `share.ts` `lookNames`, `looks.ts` `purposeOf`, `emit/looks.ts` names, `emit/elements.ts`, `convert.ts` `nameClasses` | **It owns every name**; this job only says which class is named after its words and gives it the slug (C4, both rows). Either order. Recommended: short-class-names first, so the fourth milestone uses `nm.named`. If this job merges first, short-class-names' builder keeps C4's rule when it swaps the naming (one call) and reruns the twenty-first criterion's test. A class's rules key is unchanged by copies, so its list of names needs nothing new |
| clean-values | being planned today | `controls.ts`, `emit/settings.ts`, values in both tools | **It owns values** (the 0.5 px snapping, more controls). Either order. After it, values that were 25.999 and 26 are equal before this job compares them, so more copies become plain carriers; this job's G7 number rule (0.01) covers the plugin until then. Whoever merges second reruns both jobs' drawn tests |
| bricks-icons-site, site-controls (later jobs) | not planned | `controls.ts`, `kinds.ts` | none in code |

Order: the five bases → (short-class-names, clean-values, **look-grouping** in any order; recommended last of the
three). The builder starts only when `git log main` holds the five bases' build commits, and rebases onto main before
`ready-for-review`.

## Risks and known limits

- **A copy's own value on the element outweighs everything a class says for that property.** That is the point, and
  G4 refuses the one case where it would hide something (an ancestor's hover look). A later job that adds another
  class-level look for a property (a new accordion or slider look) must check copies; the sixth criterion's test
  fails if a class and an element write one property outside G7.
- **A group of leftovers that never reaches the count** leaves its members on their own even where one of them could
  have joined a real class at a second choice (C1's last loop). Rare; nothing moves; named in HANDOFF "Deferred".
- **The first copy's look is the class's** for a class made of leftovers. Re-scanning a page whose first copy changed
  gives the class other rules and so another name (never the old name with new rules), as for any class today.
- **Words in a name change with the words.** A button renamed on the site gets a class of another name on the next
  scan; the old class stays on the WordPress site until deleted (short-class-names' Q8).
- **A website's class names tell less on a page builder's site** (Q6): on Elementor most joins come from signs (a) and
  (c). Hand-written sites (`.btn-primary`, `.card`) gain most from (b).
- **Cards that repeat without a component, a class name or the same desktop look** (cards in a grid that differ at
  the design width) still don't join. Reading repetition from structure (siblings of one shape) is a later job, named
  in HANDOFF "Deferred".
- **The plugin's 80-component limit** (extract): instances past it have no name.
- **Tools that read a paste's rules from classes alone**: found and fixed here: `pastePictures`. Task 2 and Task 11
  run `site:check --all`, `site:live`'s mapping test and `tools/lib/site-motion-live.ts`'s tests on a paste with
  copies; a tool that misses an element's own rule is fixed in this job and listed in the ledger.
- **Bricks' builder with a copy's value beside an edited class** is proven only in the renderer and in staging's
  printed CSS; the live criterion is its proof.
- Review brief: the reviewer asks "would a Bricks pro find this logical and easy to change?" of the copies, and
  measures 375, 360 and 320 for the plugin (the phone padding lives there).

## Docs & records

- This plan copied to `docs/plans/<date>-look-grouping.md` (Task 1); the ledger moved by the finisher to
  `docs/plans/<date>-look-grouping-ledger.md` before the final premerge commit and rebase.
- `docs/HANDOFF.md`: a new section above the top `## ` heading ("Copies of the same thing share one class"): the rule
  G1–G9 in plain words, the measured numbers, every ⭐ ruling marked "not yet confirmed", "Deferred" (the limits
  above), and the paste check `<look-grouping id at merge>` at the top of "End-of-run check list" (the finisher takes
  the next id free on main, on every local branch's HANDOFF and in the plan logs).
- `reference/bricks/README.md`: "An element's own rule beside a class".
- `BUILD` bumped by the finisher after the merge; `npm run build`.
- Main `CLAUDE.md` after the merge: **Status** (the build line; one line for the feature with its paste check);
  **the standard's point 2**: "that copy's real difference stays on its own class" → "stays on the element" (Q3 A,
  once Justin confirms; until then HANDOFF carries it as a ruling); under "Working in this repo": "A copy's own value
  sits on the element (its own setting or `#brxe-<id>` rule), never in a second class; a tool that reads a paste's
  rules reads an element's own too"; under "Decisions": the three signs and the limit of two kinds, as Justin's
  2026-11-13 rule with the ⭐ answers "not yet confirmed". If writing the file is refused: exactly those lines in
  `~/.hermes/plans/figma-to-bricks/look-grouping-claude-md-pending.md`.
- The project skill and memory: the finisher returns the proposed lines; the main session saves them.

## Completion and reporting

`ready-for-review` only when the twenty-two agent-run criteria pass on one commit and the gates of Task 20 are no
worse than Task 1 by test name. Every role's report: its verdict, `ac_status` for each criterion by number, the
commit, what it ran with real exit codes, any earlyoom kill, `skill_lessons[{skill, lesson, evidence, enforce}]`,
ending with `MAIN SESSION: check and save these skill_lessons now.` Builders, reviewers and fixers first read
`figma-to-bricks/references/repeat-mistakes.md` and `feature-dispatch/references/repeat-mistakes.md`. Agents never
run `site:upload` or `site:import` against a live site, never load bdryswi.com or B-Dry staging, and test only against
local fixture sites.
