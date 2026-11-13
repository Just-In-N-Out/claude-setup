# short-class-names: readable class names with a short site prefix, the same on every page of a site, in both tools (plan, Full, 2026-11-13)

Planner: Fable 5.2 high. Plan only: no source or test changed, nothing committed, no agent started, no live site
loaded, no WordPress written.
Evidence (`<E>` below): `~/.hermes/plans/figma-to-bricks/evidence/short-class-names/planner/` (`README.md` lists every
file). Scratch trees: `~/.cache/sc-pl/` (may be gone; every script takes its trees as arguments).
Measured on: site-shared-styles' fix head `7b7501bd` (the newest head every job in flight shares; it sits on
site-no-div's `d915f7dc`), plugin-parity-build `fcdec6e2`, shared-palette-build `738e300a`, importer-parity-build
`33a73f41` (it moved to `1f407006` while this was written: `prepare`, the controls and one line of `share.ts`'s
colour reader; none of the naming functions this plan changes), main `7f54b0a5` (Build 2026-11-12.3). The prototype (`<E>/scripts/proto-patch.ts` +
`<E>/scripts/class-names.proto.ts`) applies to `7b7501bd`.

## Playback

1. Today the importer names every class after the page (`home__heading-mhrv`, `home__get-a-free__row-abcd`), so two
   pages of one site share no class, and most names end in four made-up letters. The plugin's shared classes end in
   four letters too (`text-cqsk`).
2. Wanted (the standard's point 2): names a Bricks pro reads at a glance, with a short prefix for the site
   (`bd-heading-1`, `bd-button-primary`, `bd-card`), the same name and id on every page of that site, never clashing
   with the site's own classes or a framework's.
3. This plan gives both tools one naming module: a prefix made from the site's name, the class's purpose, then a plain
   label; and a small list of the names already given for that site, so a class keeps its name on the next page and
   the next scan, and a name never comes to mean other rules.

## Questions (⭐ = the ruling taken; Justin was asleep, so each ⭐ is my best-reasoned answer after research. "go with recommended" takes them all)

1. **What comes after the purpose: a plain label or four letters?** ⭐ **A: a plain label, kept stable by a list of
   the site's names.** `bd-heading-1`, `bd-heading-2`, `bd-text-body`, `bd-button-primary`, `bd-card`, `bd-card-2`.
   The tool keeps a small file per site: each name it gave and a fingerprint of that class. On the next page or the
   next scan, a class with the same rules gets the same name (so Bricks asks nothing), and a class with other rules
   gets the next free label, never a name already used. Why a list is needed: I tried names without one. A number
   only means something on the page it was counted on, and words made from a class's values aren't unique (on your
   scan two text classes are both Roboto 400 at 16 px with line height 1.65 and differ only in their tablet and
   phone sizes, and two Buttons differ only in a gradient). Without the
   list, a third scan of your home page reused 220 names for other rules and Bricks would ask about each
   (`<E>/proto-chain-el.txt`); with the list it asks about none. B: keep four letters made from the class's own rules
   (`bd-heading-edcy`): nothing to keep, always safe, but not what a person would type.
2. **Where does that list live?** ⭐ **A: the tool keeps it by itself**, one file per old site, beside the record of
   uploaded pictures on this computer (`~/.config/figma-to-bricks/class-names/bdryswi.com.json`), and writes a copy
   into each paste folder (`class-names.json`). `site:import` and `site:upload` read and update it with no extra
   step. On another computer you pass the copy once (`--class-names <file>`). The Figma plugin keeps its list inside
   the Figma file, so it travels with the file. B: no file kept; you pass the list by hand on every run.
3. **Where does the prefix come from?** ⭐ **A: from the site's name, and you can change it.** The importer takes it
   from the old site's address (`bdryswi.com` → `bd`); the plugin from the Figma file's name ("B-Dry" → `bd`). Two
   letters; three when the two are another tool's (`wp`, `is`, `fa`, `mt` … → `mtbikes.com` is `mtb`). Change it
   with `--prefix xy` or the panel's new "Class prefix" box. Once a site's list exists its prefix stays. B: the tool
   asks you to type a prefix the first time, for every site.
4. **Which plugin classes get the prefix?** ⭐ **A: the classes that hold a site's look**: the shared look classes
   (`bd-heading-1`, `bd-card`) and the Figma text styles' classes (`bd-heading-h1`, `bd-saira-condensed-bold-20`).
   The plugin's own helper classes keep their fixed names (`site-container`, `text-balance`, `text-pretty`,
   `tap-area`, `cta-motion`, `list-row`, `strip-arrow`, `showcase-card`, `marquee`, `focus-ring` …): they are the same
   on every site, the plugin's scripts find elements by them, and they are the plugin's counterpart of the
   importer's `site-reset`. B: prefix those too (a larger job: about 40 names used inside scripts, selectors and each
   other's CSS).
5. **The importer's helper classes** (`site-reset-<4>`, `site-scroll-lock-<4>`, `site-slider-<4>`, `site-text`,
   `site-flat`, `site-accordion`, `site-offcanvas`). ⭐ **A: unchanged.** They are the tool's own, the same on every
   site, never a site's look, and the four letters are how an older version already on a site is never asked about
   (your 2026-11-07 "only these keep theirs"). The font files' class and the sticky-header class, which differ per
   site, become `bd-fonts` and `bd-sticky-header`.
6. **The words.** ⭐ **A:** `heading-1, -2 …` biggest first; `text-body` for the most used text, then `text-2, -3 …`;
   `button-primary`, `button-secondary`, then `button-3 …` by how many buttons carry each; `card`, `box`,
   `section`, `container`, `row`, `stack` (a column), `grid`, each bare first then `-2, -3 …`; an element's own
   class is its section's first words and what it is (`bd-call-us-heading`, `bd-call-us-row-2`); the parts' roots
   `bd-header`, `bd-page`, `bd-footer`. `styles.txt` lists each shared class with its uses and values, so "primary"
   is never a guess. B: numbers only (`bd-button-1`, `bd-text-1`).
7. **Both tools pasting into one WordPress site.** ⭐ **A: give them different prefixes** (the plugin's box, the
   importer's `--prefix`). Each tool keeps its own list, so the same prefix on one site could give one name two
   meanings. The notes and HANDOFF say so. B: one shared list file passed between the panel and the importer (a
   later job, if you ever mix them on one site).
8. **Pages already pasted.** ⭐ **A: left alone.** Their classes keep the old names; a re-paste brings the new names
   beside them and asks nothing (the new names and ids are on no site). Old classes no page uses any more are
   deleted by hand in Bricks (Class manager → filter "unused"). `site:live` reads a page pasted before this build
   only with the build that pasted it. B: none (Bricks has no rename a paste can trigger).

## What I measured

- **Justin's scan** (`evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`, read only), Elementor step:
  685 elements, 499 classes: 57 shared (17 text, 5 button, 21 box, 14 layout), 433 own (357 of them on one
  element), 9 others (the reset, the lock, the fonts and sticky-header classes, 5 helpers). Plain route: 860 elements, 604 classes (`<E>/site-names-sss.txt`,
  `<E>/site-names-sss-full.txt`).
- **Names with the prototype** on that scan (`<E>/proto-justin-el.txt`): `bd-heading-1 … -6`, `bd-text-body`,
  `bd-text-2 … -11`, `bd-button-primary`, `-secondary`, `-3 … -5`, `bd-card … -8`, `bd-box … -11`, `bd-section`,
  `bd-container`, `bd-stack … -7`, `bd-row … -6`, `bd-grid`, own classes `bd-call-us-heading`, `bd-call-us-box-2`,
  `bd-fonts`, `bd-sticky-header`. Average name length 25.0 → 17.6 characters, longest 42 → 35.
- **Only names change.** The prototype's paste is the base's paste under a one-to-one renaming of its classes
  (names, ids, the names inside custom CSS, an Interaction's id) on Justin's scan (505 classes, Elementor step; 616,
  plain), the B-Dry stand-in, the 2026-11-04 scan, and 180 of 180 pastes of the nine hand-made code fixtures (both
  routes, both text modes, whole pages and every section): `<E>/proto-chain-el.txt`, `<E>/proto-fixtures.txt`.
- **The list.** Four conversions as pages of one site (Justin's scan, the stand-in, the 2026-11-04 scan, Justin's
  scan again), each with the list the one before left: Bricks' own check (`test/fixtures/bricks-paste.ts`) asks about
  0 classes at every step; the stand-in keeps 170 of 360 names the site has; the second pass of Justin's scan keeps
  all 492 (0 new names, also with the two other pages in between: `<E>/proto-rescan.txt`); the list
  holds 1,169 names after three pages. Without the list the third page clashes on 220 names.
- **Why words from values can't replace the label**: `<E>/site-names-sss-full.txt` (text classes with the same
  family, weight and line height that differ only in sizes at narrower widths; two Buttons that differ only in a
  gradient).
- **Tests that pin today's names** on `7b7501bd`: the unit suite is 3,808 tests, 3,717 pass, 0 fail, 91 skipped; with
  the prototype 51 fail in 20 files, all name pins (`<E>/unit-proto-failing.txt`, `-files.txt`; a 52nd failure is the
  prototype's own `import(` type expression, which Figma's sandbox check refuses: the build uses plain imports).
- **The plugin** (plugin-parity-build, the five real files, ticks on and off, `<E>/plugin-names-plugin-parity.txt`):
  29–91 classes a page; 6–62 shared looks named `<purpose>-<4 letters>`; Figma text styles named after the style
  (`saira-condensed-bold-20-7fr2`); about 40 fixed helper names (`src/core/style/classes.ts`, `hotspots.ts`). Class ids come from the class's key, not its name
  (`emit/elements.ts:81-85`).
- **Prefixes** (`<E>/prefixes.txt`): `bdryswi.com` → `bd`, `djtrees.com` → `dj`, `mtbikes.com` → `mtb`,
  `wpbeginner.com` → `wpb`, `staging.example.co.uk` → `ex`, `127.0.0.1` → `web`; "B-Dry" → `bd`, "All Type Hydraulic
  Cylinder" (the Repairs file) → `at`.

## What Bricks does (read, not guessed)

Bricks 2.4.2's builder script, B-Dry staging's saved copy (`<E>/bricks-import-classes-2.4.2.txt`), and
`reference/bricks/README.md` "Global classes on paste" (2.4's check, 2.2's Accept and Reject):

- A pasted class is **asked about** when its id is on the site with another name or other settings (compared as JSON
  text), or its name is on the site under another id. A pasted class the site holds with the same id, name and
  settings is not asked about; one the site holds under neither id nor name is added without a question.
- **The label**: "Conflict: ID" only when the id is on the site under another name; every other asked class reads
  "Conflict: Name" (so a class Justin changed in Bricks, same id and name, other settings, reads "Conflict: Name");
  a class the site doesn't hold reads "New class".
- **Reject** discards the pasted copy; an element keeps a class id the site holds, so it carries the site's class
  (his change). A rejected class whose name the site holds under another id is mapped to that id. **Accept**
  replaces the site's class of that id, else of that name.
- Class manager → Export writes every class of the site (`bricks-css-classes`); this plan doesn't need it.

## Design

### N1. One module both tools use: `src/shared/class-names.ts`

Pure, built-ins only (`src/shared` is already on `test/unit/site-isolation.test.ts`'s allow-list for `src/core/site`,
and the Figma conversion may load it). The whole file, proven in the prototype
(`<E>/scripts/class-names.proto.ts`; use plain `import` lines, never an `import(` type):

```ts
import { fnv1a } from "./hash.ts";

export interface ClassList { version: 1; prefix: string; classes: Record<string, string> }

export const RESERVED: ReadonlySet<string> = new Set(["wp", "is", "has", "brx", "brxe", "bricks", "el", "fa", "fas", "far", "fab", "bi", "ti", "bg", "btn", "col",
  "row", "grid", "flex", "gap", "text", "site", "mt", "mb", "ml", "mr", "mx", "my", "pt", "pb", "pl", "pr", "px", "py", "fs", "fw", "lh", "ls", "sm", "md", "lg",
  "xl", "no", "on", "id", "js", "ui"]);
export const FALLBACK_PREFIX = "web";
export const validPrefix = (p: string): boolean => /^[a-z][a-z0-9]{1,5}$/.test(p) && !RESERVED.has(p);

export function hostName(host: string): string {
  const labels = host.toLowerCase().replace(/^www\./, "").split(".").filter(Boolean);
  if (labels.length > 1) labels.pop();
  if (labels.length > 1 && /^(co|com|org|net|gov|edu|ac)$/.test(labels[labels.length - 1])) labels.pop();
  return labels[labels.length - 1] ?? "";
}
export function prefixFrom(name: string): string {
  const words = name.normalize("NFKD").replace(/\p{M}+/gu, "").toLowerCase().split(/[^a-z0-9]+/).map((w) => w.replace(/^[0-9]+/, "")).filter(Boolean);
  const letters = words.length > 1 ? words.slice(0, 3).map((w) => w[0]).join("") : (words[0] ?? "");
  const more = words.length > 1 ? letters + words[0].slice(1) : letters;
  for (const p of [letters.slice(0, 2), more.slice(0, 3)]) if (p.length >= 2 && validPrefix(p)) return p;
  return FALLBACK_PREFIX;
}
export function keyOf(text: string): string {
  const LETTERS = "abcdefghijklmnopqrstuvwxyz";
  let out = "";
  for (const salt of ["", "\u0001"]) { let h = fnv1a(salt + text); for (let i = 0; i < 6; i++) { out += LETTERS[h % 26]; h = Math.floor(h / 26); } }
  return out;
}
function* labels(purpose: string): Generator<string> {
  if (purpose === "text") yield "body";
  if (purpose === "button") { yield "primary"; yield "secondary"; }
  if (purpose !== "heading" && purpose !== "text" && purpose !== "button") yield "";
  for (let n = purpose === "heading" ? 1 : purpose === "button" ? 3 : 2; ; n++) yield String(n);
}
function* plain(): Generator<string> { yield ""; for (let n = 2; ; n++) yield String(n); }

export interface Namer { prefix: string; take: (purpose: string, rules: string) => string; named: (name: string, rules: string) => string; list: () => ClassList; added: () => string[] }
export function namer(prefix: string, given?: ClassList): Namer {
  const classes = new Map(Object.entries(given?.classes ?? {}));
  const byKey = new Map([...classes].map(([name, key]) => [key, name]));
  const added: string[] = [];
  const give = (purpose: string, rules: string, from: Generator<string>): string => {
    const key = keyOf(rules);
    const have = byKey.get(key);
    if (have) return have;
    for (const label of from) {
      const name = `${prefix}-${purpose}${label ? `-${label}` : ""}`;
      if (classes.has(name)) continue;
      classes.set(name, key);
      byKey.set(key, name);
      added.push(name);
      return name;
    }
    throw new Error("no label left");
  };
  return {
    prefix,
    take: (purpose, rules) => give(purpose, rules, labels(purpose)),
    named: (name, rules) => give(name, rules, plain()),
    list: () => ({ version: 1, prefix, classes: Object.fromEntries(classes) }),
    added: () => added,
  };
}
```

Also in the module (not in the prototype): `readClassList(text: string): ClassList` (parses and checks the shape:
`version: 1`, a valid prefix, every name `^<prefix>-[a-z0-9-]+$`, every key twelve letters; throws one plain
sentence otherwise) and `writeClassList(list): string` (JSON, keys sorted, two-space indent, a final newline).

**The rules the module keeps (N1a–N1d):**
- N1a. A class whose rules (as written for any name) the list holds keeps that name, whatever its purpose reads now.
  This is site-shared-styles' open R1-3: a look carried by `h2`s on one page and `h3`s on another, or re-scanned
  after a tag changed, is one class.
- N1b. A name is only ever given once. A class with new rules takes the next free label of its purpose; a name whose
  class no page shows any more stays taken (the site may still hold it).
- N1c. A list is never trimmed or renumbered by the tools. `--new-class-names` starts a new one (for a site whose old
  pastes and classes were deleted).
- N1d. A name is `^[a-z][a-z0-9]*(-[a-z0-9]+)+$`: one dash between parts, never `__`.

### N2. The importer's names (`src/core/site`)

| Class | Name | Order of first sight |
|---|---|---|
| shared text look, every carrier a Heading | `<p>-heading-1`, `-2` … | font size at the widest range, biggest first; then uses; then document order |
| any other shared text look | `<p>-text-body`, `<p>-text-2` … | uses, most first; then document order |
| shared Button look | `<p>-button-primary`, `-secondary`, `-3` … | uses; then document order |
| shared box look | `<p>-card` (it paints), `<p>-box`, `<p>-section`, `<p>-container`, then `-2` … | uses; then document order |
| shared layout look | `<p>-row`, `<p>-stack` (a flex column), `<p>-grid`, then `-2` … | uses; then document order |
| a section's root | `<p>-<its first two words>` (`<p>-section` with no words; `<p>-section-<words>` when they start with a digit) | document order |
| an element's own class | `<p>-<section words>-<role>`, then `-2` … (the roles of `classes.ts roleOf`) | document order |
| a part's root, the wrapper above its sections | `<p>-header`, `<p>-page`, `<p>-footer`; `<p>-header-inner` … | |
| an opened box (Offcanvas) and its elements | `<p>-offcanvas`, `<p>-offcanvas-<role>`, then `-2` … | document order |
| the site's font files | `<p>-fonts`, then `-2` … (both routes; the plain route's bare `site-fonts` goes) | |
| a header kept at the top | `<p>-sticky-header` | |
| reset, sideways lock, slider restore, `site-text`, `site-flat`, `site-accordion`, `site-offcanvas` | unchanged (Q5) | |
| made-up names that are not global classes: an opener's and a sliding list's marker in `_cssClasses`, `@keyframes` | `<p>-open-<4>`, `<p>-slide-<4>`, `<p>-<keyframes name>-<4>`: the four letters stay (Bricks never asks about them, nobody edits them as classes, and they need no list) | |

- `purposeOf` (`looks.ts`): a text look is `heading` when every carrier is a Heading, else `text` (the `h1 … h6`
  purposes go: a tag is the carrier's, not the look's); a flex column is `stack`.
- The namer is made once per conversion: `namer(opts.prefix ?? opts.classNames?.prefix ??
  prefixFrom(hostName(hostOf(capture))), opts.classNames)`. Shared looks are named first (`share.ts lookNames`, in
  the table's order), then own classes in document order (`convert.ts nameClasses`, one branch for both routes: the
  Elementor step's fingerprint branch and the plain route's counter both go), then the fonts and sticky-header
  classes. A section paste (`siteToBricks`) names the page's looks the same way first, as today.
- The rules a name is keyed by are exactly what today's fingerprints are made from: `lookNames`' `rules`,
  `nameClasses`' `scope + rules` (an accordion's and a slider's look included), the fonts class's faces, the
  sticky-header class's CSS written for the name `\u0000`.
- Class ids: unchanged rule (`classIdsOf`: a hash of the name), so the same name is the same id on every page.
- `ConvertOptions` gains `prefix?: string` and `classNames?: ClassList`; `SitePage` and `SiteResult` gain
  `classNames: ClassList` (the list after this conversion) and `named: { kept: number; added: number }`.
- `pageSlugOf` stays for what it still names (the paste folder, `open-paste.ts`); `slugOf(words, page)` becomes
  `slugOf(words)` (the section's words only).

### N3. The importer's commands

- `--prefix <letters>` on `site`, `site:upload`, `site:import`: checked with `validPrefix` (else one line and exit
  1, before anything is read, scanned or sent). A prefix that differs from the list's stops the run: "this site's
  classes are named `bd-…`; to rename, start a new list with --new-class-names".
- `--class-names <file>`: the list to read and write. `--new-class-names`: start a new list (the old file is kept
  beside it as `<name>.before-<date>.json`).
- Default list: `site:import` and `site:upload` use `<the record's folder>/class-names/<host>.json` (so
  `~/.config/figma-to-bricks/class-names/bdryswi.com.json`, and a test's `--record <tmp>/r.json` keeps its list
  under `<tmp>`). `site`, `site:live` and `site:check` use a list only when `--class-names` names one (`site` writes
  it back, the other two only read), so every existing test and offline run names classes as for a site with no
  list. The lines `site:import` and `site:upload` print for a later `site` or `site:live` run carry
  `--class-names "<file>"`.
- The list is written once, after the pastes are written, to a temporary file renamed into place; a dry run writes
  none. A copy goes to `<outDir>/class-names.json`. A list that can't be read or isn't one stops the run with one
  line naming the file, before anything is written, scanned or sent (exit 1), as `--colours` does.
- A first run for a host with no list prints: "No class-names list for bdryswi.com on this computer: starting one
  (prefix bd). If pages of this site were pasted from another computer, stop and pass its class-names.json with
  --class-names."
- Notes (each part, after site-shared-styles' lines) and the command's summary: "Class names: prefix `bd`; N already
  on this site's list, M new (list: <file>)". `styles.txt` already lists each shared class by name with its uses and
  values.
- Next steps (`tools/lib/site-import/next.ts`): "Bricks asks "Import classes" only about a class that changed since
  it was pasted (marked "Conflict: Name"). If you changed it yourself in Bricks, press × (Reject): yours stays on
  every element. Otherwise press ✓ (Accept)." (This also settles site-shared-styles' R2-2 wording.)

### N4. The plugin's names (`src/core/emit`, `src/core/normalise`, `src/plugin`, `src/ui`)

- `Snapshot.names?: string` (raw JSON of a `ClassList`, like `site` and `alts`; `src/core/normalise/names.ts`
  parses it, a broken one reads as none with one warning). Made at extraction (`src/plugin/extract/snapshot.ts`):
  the file's saved list (`figma.root` plugin data `f2b-names`), else `{ version: 1, prefix:
  prefixFrom(api.fileName()), classes: {} }`. A website capture (`source: "web"`) never gets one.
- **No `names` in the snapshot** (every fixture, every debug file saved before this build): the paste is byte for
  byte as before. Nothing below runs.
- **With `names`**: `emit/elements.ts` makes `namer(prefix, list)`, then
  - each Figma text style's class is `nm.named(<its slug as today>, "style:<its key>")`: `bd-heading-h1`,
    `bd-saira-condensed-bold-20-7fr2`, a phone twin `…-phone` as today; named first, in `result.classes` order;
  - each look class (`emit/looks.ts`) is `nm.take(<purpose>, <its key>)`, in a fixed order: text looks with a size
    of 22 px or more are `heading`, biggest first; then `text` by layers carrying it; `button`; `card`, `box`,
    `section`, `container`; `row`, `stack` (plugin-parity's `column`), `grid`; a look class a style class's name
    already holds takes the next label (a file with a text style "Heading 1" keeps `bd-heading-1` for the style);
  - the plugin's own helper classes (every `ClassDef` whose key is neither `style:…` nor `look:…`) keep name and id;
  - a prefixed class's id is `shortId("class:<prefix>:<key>")` (look ids still dodge the others through
    `assignIds`), so a paste onto a site that holds the unprefixed class of the same key asks nothing (same id with
    another name would read "Conflict: ID").
- `ConvertResult.names: ClassList | null` (the list after this conversion). After each conversion the panel sends it
  to the plugin, which saves it in the file (`src/plugin/names.ts saveNames`, the pattern of `src/plugin/site.ts`).
  The debug file holds the list the conversion read, so a replay is the plugin's paste.
- The panel (`src/ui/index.html`, `settings.ts`, `main.ts`): a box "Class prefix" under the Bricks settings, showing
  the file's prefix; a change is checked (`validPrefix`: "2 to 6 letters or digits, a letter first; not wp, is, fa
  …"), saved in the file and used from the next conversion; changing it once names exist starts a new list (the
  panel says so before saving); empty turns the prefix off (names as before this build).
- `replay` prints the prefix in its summary; `styles.txt` shows the new names (it reads the payload).

### N5. Tests' helper for Bricks' dialog (`test/fixtures/bricks-paste.ts`)

Two functions beside `bricksClassConflicts`, written from `<E>/bricks-import-classes-2.4.2.txt`:
`bricksClassLabel(site, cls): "Conflict: ID" | "Conflict: Name" | "New class" | null` (null: not asked) and
`bricksPasteClasses(site, payload, accept: (name: string) => boolean): { site: GlobalClass[]; content:
BricksElement[] }` (new classes added; an accepted class replaces the site's of that id, else of that name; a
rejected one is dropped; each element's `_cssGlobalClasses` keeps an id that is accepted or on the site, maps a
rejected name clash to the site's id, and drops the rest).

## The standard, point by point

1. **Structure.** Untouched: no element, label or tree changes (the rename-only criteria prove it).
2. **Classes.** This job's point. Names read by purpose behind a short site prefix; the same class has the same name
   and id on every page of the site (the list); a look's name no longer changes with its carriers' tags; no name
   holds a page's name or made-up letters except the tools' own helpers and the markers nobody edits. It adds or
   merges no class: which looks are shared is site-shared-styles', plugin-parity's and look-grouping's. Still true
   after this job and named for those jobs: 357 of 433 own classes on Justin's scan sit on one element ("a one-off
   tweak sits on the element" is not met by a class per element; moving them into element settings is not a naming
   change and is left to a job of its own).
3. **Settings before custom CSS.** Untouched (class settings are byte for byte the same under the new names).
4. **Bricks' own behaviour.** Untouched.
5. **Editable content.** Untouched.
6. **Looks stay true.** Only names change: every paste is the base's under a one-to-one renaming (the 4th and 11th
   criteria), draws the same under any names (the 9th), and a name is never reused for other rules, so answering
   Bricks' question can't move another page.

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a site's name, its prefix is two letters from it (a host's own label: `bdryswi.com` → `bd`, `www.` and the ending left off; two or more words: their first letters, "B-Dry" → `bd`), three where the two are another tool's (`mtbikes.com` → `mtb`), `web` where it has no two usable letters; `--prefix` or the panel's box wins when it is 2 to 6 letters or digits, a letter first and not another tool's, and is refused with one sentence otherwise. Test `test/unit/class-names.test.ts` "a site's prefix comes from its name: two letters, never another tool's, and a typed one wins".
- AC2 (proposed): Given the namer, a purpose's labels come in order (`heading-1, -2`; `text-body, text-2`; `button-primary, -secondary, -3`; any other purpose bare then `-2`); a class whose rules the list holds keeps its name whatever its purpose; a name the list holds is never given to other rules; the list round-trips through `writeClassList` and `readClassList`, and a broken list is refused with one sentence. Test `test/unit/class-names.test.ts` "a class keeps its name while its rules stay, and a name is never given to other rules".
- AC3 (proposed): Given every code fixture's pastes (both routes, both text modes, whole pages and every section), every global class is one of the tools' own helpers by its exact name or a name under the site's prefix matching N2's table, every other made-up name (markers, `@keyframes`) starts with the prefix, no name holds `__` or the page's name, and a class the header, page and footer pastes or a section paste and a page paste both hold has one name, id and settings. Test `test/unit/site-class-names.test.ts` "every class of every paste is one of the tools' own helpers or a site-prefix name read by purpose".
- AC4 (proposed): Given every paste the list `test/unit/lib/site-pins.ts` gives, the same list on the Elementor step and the shared-looks fixture, the paste equals the base's paste under a one-to-one renaming of its made-up names: its digest with every global class's name and id replaced by its place and every other made-up name by its order of first sight equals the digest recorded on the base in Task 1. Test `test/unit/site-names-rename.test.ts` "every website paste is the base's paste under a one-to-one renaming of its classes".
- AC5 (proposed): Given two pages of one site that share looks and a second scan of the first page, each converted with the list the one before left: every class the pages share by its rules has the same name, id and settings on both, no name is held with two different settings, the second scan's pastes are byte for byte the first's, and Bricks' own check (`bricksClassConflicts`, the site holding the earlier pastes' classes) asks about no class at any step; converted without the list, the same second page is asked about (the test shows the clash the list prevents). Test `test/unit/site-names-list.test.ts` "with the site's list a second page and a second scan keep every class's name, id and settings".
- AC6 (proposed): Given a shared text look carried by `h2`s on one page and by `h3`s and a paragraph on another, with the list it has one name, id and settings on both pages, and adding an element with a new look to a page renames no class the list holds. Test `test/unit/site-names-list.test.ts` "a look carried by other tags on another page keeps its name, and a new look renames none".
- AC7 (proposed): Given a site holding a page's pasted classes where one shared class's settings were changed in Bricks, pasting the page again (and a second page that carries the class) asks about exactly that class, labelled "Conflict: Name"; with Reject every element that carried it carries the site's changed class and no class is added or lost; with Accept the site's class takes the paste's settings; a paste after an unchanged first paste asks about nothing. Test `test/unit/emit-class-paste.test.ts` "a class changed in Bricks is the only one asked about, as Conflict: Name, and Reject keeps it on every element".
- AC8 (proposed): Given the commands against local fixtures and the WordPress stand-in only: `site:import` and `site:upload` read and write `<record's folder>/class-names/<host>.json` and a copy `class-names.json` in the paste folder, after the pastes; a dry run writes neither; `site`, `site:live` and `site:check` touch a list only with `--class-names`; `--prefix` sets a new list's prefix, is refused when malformed or another tool's, and stops the run when it differs from the list's; `--new-class-names` starts a new list and keeps the old file; an unreadable list stops the run with one line before anything is written or sent; the notes and the summary say "Class names: prefix …". Test `test/unit/site-names-cli.test.ts` "the commands keep the site's list: where it is read and written, --prefix, --class-names, --new-class-names, a dry run".
- AC9 (proposed): Given the fixture sites `shared-looks` and `elementor-natives`, each captured and converted, the paste drawn with its names and drawn with every global class renamed to `c<n>` (names inside custom CSS with it) gives every element the same box (0.5 px) and the same computed font, colours, background, padding, border, display and gaps at 1440, 1024, 768 and 390, with Bricks 2.4.2's front-end CSS and with 2.3.9's. Test `test/browser/site-names-inert.test.ts` "a paste draws the same with its names and with every class renamed".
- AC10 (proposed): Given any Figma snapshot without a class-names list (every generic fixture, the corpus files, both picture modes, the header and footer ticks on and off) and the panel's website route, the paste is byte for byte the base's, by sums recorded on the base in Task 1. Test `test/unit/short-class-names-figma.test.ts` "every Figma paste without a class prefix is byte for byte the base's".
- AC11 (proposed): Given the same snapshots with a prefix: every look class is `<prefix>-<purpose>` with its label in N4's order, every Figma text style's class is `<prefix>-<its name as before>`, every helper class keeps its name and id, each prefixed class's id differs from its unprefixed one, the paste equals the unprefixed paste under a one-to-one renaming of those classes (the same digest as the 4th criterion's), and Bricks' own check asks about no class when it is pasted onto a site holding the unprefixed paste's classes. Test `test/unit/plugin-class-names.test.ts` "with a prefix a Figma paste's look and text-style classes carry it, its helpers keep their names, and nothing else changes".
- AC12 (proposed): Given two pages of one Figma file that share looks, converted one after the other with the list the first returned, in both orders: a look both pages hold has one name, id and settings, Bricks' own check asks about no class, and a look only the second page holds takes a label the list doesn't hold. Test `test/unit/plugin-class-names.test.ts` "two pages of one Figma file share names through the file's list, and Bricks asks about none".
- AC13 (proposed): Given a snapshot holding a class-names list, the plugin's own conversion (`src/plugin/convert.ts`) gives exactly a replay's paste and the same returned list, the new code runs with Figma's sandbox globals only, and the plugin saves the returned list in the file after a conversion and reads it at the next. Test `test/unit/plugin-class-names.test.ts` "the plugin's paste of a file with a prefix is exactly a replay's, and the list it returns is the one it saves".
- AC14 (proposed): Given the panel on a file, the "Class prefix" box shows the file's prefix (made from the file's name the first time), a valid change is saved in the file and used by the next conversion, an invalid one is refused with the sentence naming the rule and nothing is saved, changing it once names exist says a new list starts, and an empty box converts with the names as before this build. Test `test/unit/ui-class-prefix.test.ts` "the panel's Class prefix box: shown from the file, saved with it, a wrong one refused, empty turns it off".
- AC15 (proposed): Given B-Dry's saved 2026-10-29 home served on 127.0.0.1 (never the live site; the stand-in capture), with the Elementor step and without it: every class is a helper or under the prefix, no name holds `__`, the count of classes and elements equals the base's, and `site:check` reads no row worse than the base's rows recorded in Task 1. Test `test/web/site-names-bdry.test.ts` "B-Dry's saved page pastes with short names on both routes and site:check reads no row worse than the base".
- AC16 (proposed): Given `npm run site:import` on a fixture site with the WordPress stand-in, the next steps say what Bricks' "Import classes" asks about and what to press (× Reject keeps a class you changed, ✓ Accept otherwise), the first run for a host says it starts a list, and the line it prints for a later `npm run site` carries `--class-names` with the list's path. Test `test/unit/site-names-cli.test.ts` "site:import's next steps name the list and what to press on Import classes".
- AC17 (proposed) (live): Justin, on his own sites: (a) he scans bdryswi.com with the new build (`npm run site:import … --elementor`), pastes header, page and footer into an emptied page on B-Dry staging, sees classes named `bd-…` in Bricks' class list (no `home__`, no four made-up letters except the helpers), opens `bd-button-primary` (or the first button class `styles.txt` lists), changes its background and every button carrying it changes, nothing else; he runs the import again and re-pastes: Bricks asks only about that class as "Conflict: Name", he presses ×, and his colour is still on every button; (b) in Figma he converts a page with the Class prefix box showing a prefix, pastes it into an empty page on darksalmon, sees `<prefix>-heading-1`-style names, changes one text class's size and every text carrying it follows.

## Touched files (base: main after the five jobs in flight; paths as on `7b7501bd` and the builders' heads)

**New:** `src/shared/class-names.ts`; `src/core/normalise/names.ts`; `src/plugin/names.ts`; `tools/lib/class-names-file.ts`
(the default path, read, atomic write, the copy, `--new-class-names`); `tools/names-blind-sums.ts` (the digest of the
4th criterion, run on a tree's root: `node tools/names-blind-sums.ts <tree>`); `test/unit/lib/names-blind.ts`;
`test/fixtures/short-class-names-blind.json`, `test/fixtures/short-class-names-figma.sha256.json` (Task 1, from the
base); `test/fixtures/site-two-pages.ts` (two generic pages of one made-up site sharing looks, one with a look the
other lacks, one carrying a shared text look on other tags; built on `test/fixtures/site-looks-code.ts`); the tests
named in the criteria.

**Changed (importer):** `src/core/site/share.ts` (`lookNames`), `looks.ts` (`purposeOf`), `convert.ts`
(`ConvertOptions`, `SiteResult`, `nameClasses`, `siteToBricks`, `pageLooks`), `parts.ts` (`baseOf`, the fonts and
sticky-header classes, `SitePage`), `classes.ts` (`slugOf`; `versioned` stays for the helpers and markers), `stay.ts`
(`stayClass(nm)`), `opens.ts`, `slide.ts`, `motion.ts`, `open-paste.ts` (the prefix in place of `<page>__`);
`tools/site.ts`, `tools/site-upload.ts`, `tools/site-import.ts`, `tools/site-live.ts`, `tools/site-check.ts`,
`tools/lib/site-write.ts`, `tools/lib/site-import/args.ts`, `after-scan.ts`, `next.ts`, `tools/lib/site-upload/args.ts`,
`flow.ts`; `tools/site-sticky-header-sums.ts` (its `__site-stay-` pattern).

**Changed (plugin):** `src/core/snapshot/schema.ts` (`names?`), `src/core/normalise/normalise.ts`, `scene.ts`,
`src/core/convert.ts` (`ConvertResult.names`), `src/core/emit/elements.ts`, `emit/looks.ts` (names through the
namer, its order), `src/plugin/extract/snapshot.ts`, `extract/api.ts` (no new call: `fileData`, `fileName` exist),
`src/plugin/convert.ts`, `main.ts`, `src/shared/messages.ts`, `src/ui/index.html`, `settings.ts`, `main.ts`, `run.ts`;
`tools/replay.ts` (the summary's prefix).

**Tests that pin today's names and change with this job** (the builder may edit these; each keeps its other
assertions and gains the new names):
- unit, 51 tests in 20 files on `7b7501bd` (`<E>/unit-proto-failing.txt`): `site-class-names`, `site-elementor-names`,
  `site-look-names`, `site-text-looks`, `site-box-looks`, `site-button-looks`, `site-looks-one-writer`, `site-css`,
  `site-parts`, `site-text`, `site-hidden-parts`, `site-motion`, `site-motion-old`, `site-native-stay`,
  `site-sticky-header`, `site-no-revert`, `site-opens-no-revert`, `site-opens-old`, `site-slider`,
  `site-slider-unchanged` (its sums under `test/fixtures/site-slider-base/`); with them `test/web/lib/class-names.ts`
  (`PLUGIN`, `bareNames`) and `test/fixtures/site-no-revert-main.json` (`node tools/site-no-revert-golden.ts .`);
- pins and goldens that hold whole pastes: `test/fixtures/site-native-pins.json`, `site-no-div-pins.json`,
  `site-no-div-replay-pins.json`, `site-shared-styles-pins.json`, `site-shared-styles-replay-pins.json`,
  `site-basic-golden.json`, `site-media-base/`, `site-motion-base/`, importer-parity's `site-parity-pins.json` and
  `site-parity-replay-pins.json`, shared-palette's `shared-colour-base.json` where it holds an importer paste. Rule:
  a pin in the default suite is regenerated only after the 4th criterion's digest shows that paste is the base's
  under renaming; an env-gated story pin (`F2B_STORY_PINS=1`) of an earlier job is that job's receipt and is left
  (recorded once in the ledger as "moved by short-class-names: names only");
- web and browser tests that read class names (`test/web/site-*.test.ts` that match `__`, `test/web/lib/site-check.ts`,
  `test/browser/render-site-*.test.ts`): run every `test/web` file and `test/browser` file by name on the base in
  Task 1 and on the head; each that changes is a name pin, fixed the same way;
- plugin-parity's `plugin-looks-names.test.ts`, `emit-class-paste.test.ts` and `plugin-parity-pin.test.ts` run on
  snapshots without a list and must pass unchanged.

## Tasks

**Milestone 0: records and the base's receipts**
1. Copy this plan to `docs/plans/<date>-short-class-names.md`; start the ledger
   (`.superpowers/sdd/<plan>/progress.md`). Read `figma-to-bricks/references/repeat-mistakes.md` and
   `feature-dispatch/references/repeat-mistakes.md`. Confirm the base holds site-no-div, site-shared-styles,
   plugin-parity, importer-parity and shared-palette (`git log --oneline main`); if one is missing, stop and say
   which.
2. On the base, before any change: `npm run check`; `npm run corpus` (on the desktop: the two repo corpus files by
   replay, memory `corpus-paths-on-desktop`); every `test/web` and `test/browser` file by name (tallies in the
   ledger); `site:check --all --no-shots` rows of the B-Dry stand-in on both routes into
   `<evidence>/builder/base-rows/`.
3. Write `test/unit/lib/names-blind.ts` and `tools/names-blind-sums.ts` (the blind digest: `<E>/scripts/proto-fixtures.ts`
   `blind()` is the reference; an Interaction's id compared by place) and record
   `test/fixtures/short-class-names-blind.json` and `test/fixtures/short-class-names-figma.sha256.json` from the
   base. Commit them with the two story tests (`site-names-rename`, `short-class-names-figma`), both gated by
   `F2B_STORY_PINS=1` and green on the base.

**Milestone 1: the module**
4. `test/unit/class-names.test.ts` (the 1st and 2nd criteria's tests, the table of `<E>/prefixes.txt`), red: the
   module doesn't exist. Then `src/shared/class-names.ts` as in N1 with `readClassList` / `writeClassList`. Green;
   `npm run typecheck` (the sandbox config covers `src/shared`).

**Milestone 2: the importer's names**
5. The fixture `test/fixtures/site-two-pages.ts` and the tests of the 3rd, 5th and 6th criteria, red on the base
   (names start `home__`; no list). Rewrite `test/web/lib/class-names.ts` for the new grammar.
6. The naming change in one commit (the producer and its pins move together): `share.ts`, `looks.ts`, `convert.ts`,
   `parts.ts`, `classes.ts`, `stay.ts`, `opens.ts`, `slide.ts`, `motion.ts`, `open-paste.ts` as in N2
   (`<E>/scripts/proto-patch.ts` shows each anchor on `7b7501bd`; the markers and keyframes take the prefix here,
   which the prototype left). Then the 51 unit pins by file, each in the same commit as its source where the suite
   would otherwise be red, and the default-suite goldens regenerated after `F2B_STORY_PINS=1 node --test
   test/unit/site-names-rename.test.ts` is green.
7. Mutants for the list (each must fail the 5th or 6th criterion's test, then be restored): the key match removed
   (every class takes a fresh label); a taken name reused; the purpose made part of the key.
8. `test/fixtures/bricks-paste.ts` N5 and the 7th criterion's test (red before the functions exist is a helper red;
   the behaviour red: with the list switched off in the test's second paste, more than one class is asked about).
9. The 9th criterion's browser test (the renderer's two Bricks versions; rename by parsing the payload, never by
   editing CSS text in `src`).

**Milestone 3: the commands**
10. `tools/lib/class-names-file.ts` and the flags in `site`, `site:upload`, `site:import`, `site:live`,
    `site:check`, `site-write.ts`, the args modules and `next.ts`; the 8th and 16th criteria's tests against local
    fixtures and `test/fixtures/wp-standin.ts` only, every run with `--record` under a temp folder. Grep the tests
    that pin a command's usage line or list its `--out` folder (`readdirSync(out)`): `class-names.json` is a new file
    there; update those pins in the same commit.
11. The 15th criterion's web test on the stand-in; compare its rows with Task 2's.

**Milestone 4: the plugin**
12. `Snapshot.names`, `normalise/names.ts`, `Scene`, `ConvertResult.names`; `emit/elements.ts` and `emit/looks.ts`
    as in N4. Tests of the 11th and 12th criteria red first (a snapshot with `names` converts as without on the
    base). `F2B_STORY_PINS=1 node --test test/unit/short-class-names-figma.test.ts` stays green after every commit.
13. `src/plugin/extract/snapshot.ts`, `src/plugin/names.ts`, `convert.ts`, `main.ts`, `messages.ts`; the 13th
    criterion's test (`test/fixtures/panel.ts` stands in for the file's data).
14. The panel's box (`index.html`, `settings.ts`, `main.ts`, `run.ts`) and the 14th criterion's test. `npm run build`
    (the SES checks).

**Milestone 5: close**
15. `npm run check`, `npm run test:browser`, `npm run test:web`, `npm run corpus`; the web and browser tallies
    against Task 2's by test name; before and after text proof in the ledger (the look fix changes no picture):
    Justin's saved scan converted on the base and the head, the first 60 class names of each side by side.
16. Docs & records (below). Stop at `ready-for-review`.

## Overlaps and order

- **Base.** Main after site-no-div, site-shared-styles, plugin-parity, importer-parity and shared-palette merged.
  This job should be the **first** of the five planned on 2026-11-13 (look-grouping, clean-values,
  fewer-kept-boxes, native-widgets): it moves every importer golden once, and the others then name their classes
  through the namer (look-grouping's `bd-button-call` is `nm.take("button-call", rules)`; clean-values changes a
  class's rules, which under N1b gives it the next label, never a renamed neighbour).
- **Assumed from site-shared-styles** (`7b7501bd`): `share.ts` (`lookKeys`, `applyKeys`, `lookNames(rows, page,
  ink)`, `nameLooks`, `Row.key`, `Row.states`), `looks.ts purposeOf`, `class-source.ts classKey`, `convert.ts
  nameClasses(…, shared, ink)` and `pageLooks`, `colours.ts` (colours by value, untouched), `tools/lib/site-write.ts
  stylesText`, `next.ts CLASSES`, `test/unit/site-look-names.test.ts`. Its open notes at its rebase onto main (R1-2
  fonts, R2-1 the palette step) are its own; R2-2 (the "Conflict: Name" wording) and R1-3 (a name moving with a
  carrier's tag) are settled here.
- **Assumed from site-no-div**: `parts.ts`' lifted sections and their slugs, `labels.ts`; nothing of names.
- **Assumed from plugin-parity** (`fcdec6e2`): `emit/looks.ts` (`sharedLooks`, its name line and `purposeOf`),
  `emit/elements.ts:81-85` (class ids from keys), `ConvertResult.shared`, `tools/lib/styles-text.ts`,
  `test/unit/plugin-looks-names.test.ts`, `plugin-parity-pin.test.ts`. Its Q4 A (four letters) and Q5 A (text styles
  unchanged) hold for a snapshot without a list and are replaced by N4 with one.
- **Assumed from importer-parity** (`33a73f41`, still building): it edits `parts.ts`, `convert.ts`, `tree.ts` and
  adds `src/core/site/names.ts`, which is about accessibility names (aria-label, title), not class names: this job
  says "class names" everywhere (`classNames`, `--class-names`, "Class names:" beside its "Names:" note) and adds no
  file called `names.ts` under `src/core/site`.
- **Assumed from shared-palette** (`738e300a`): the `--colours` flag's shape in `site.ts`, the args modules and
  `site-write.ts`, and its panel box "Colours already on the site" in `index.html`, `settings.ts`, `messages.ts`,
  `plugin/main.ts`: the Class prefix box sits beside it and follows its message pattern.
- **Shared files with jobs planned beside this one**: look-grouping (`share.ts`, `looks.ts`, `emit/looks.ts`),
  clean-values (`controls.ts`, `class-source.ts`), fewer-kept-boxes (`fold-boxes.ts`, `elementor-fold.ts`, `parts.ts`),
  native-widgets (`tree.ts`, `kinds.ts`). Building this job first avoids two jobs editing `lookNames` and
  `nameClasses` at once.

## Risks and known limits

- **A list missing on another computer** names a second page's classes as for an empty site, and Bricks would ask
  about every clashing name (220 on the third page in the measurement). The first-run line says so, the paste folder
  holds a copy to pass, and N1b means a wrong answer can only happen where that line was ignored. A site-wide
  remedy (reading the site's classes from Bricks' own export) is a follow-up.
- **A tool update that writes a class another way** gives that class a new label on the next scan (`bd-heading-7`
  beside the old `-1 … -6`), as today's four letters change; the old class and any change Justin made to it stay
  on the site. Labels therefore creep after such updates; `--new-class-names` starts clean once the old pastes are
  gone.
- **"Primary" is the most used button on the first page scanned**, not a judgement. `styles.txt` shows each class's
  uses and values; look-grouping may later name buttons by what they are for.
- **A class id that equals an element id of the same paste** moves on (`classIdsOf`, unchanged), so such a class
  can have another id on another page and Bricks then asks about it by name. Unchanged from today, about 1 paste in
  1,000; follow-up.
- **Pages pasted before this build** keep `home__…` classes; `site:live` finds a part's root by its class list and
  reads those pages only with the build that pasted them (Q8).
- **The plugin and the importer on one site with one prefix** can give one name two meanings (Q7): different
  prefixes; the notes say so.
- **Scope held:** no class is merged, split or moved; no element changes; the panel's website route and every Figma
  snapshot without a list are byte for byte as before.

## Docs & records

1. The plan copied to `docs/plans/<date>-short-class-names.md`; the ledger moved by the finisher to
   `docs/plans/<date>-short-class-names-ledger.md` before the final premerge commit and rebase.
2. `docs/HANDOFF.md`: a new section above the previous top heading ("Short class names with a site prefix"): the
   rules N1a–N1d, N2's table, where the list lives and how to move it, the eight rulings as "not yet confirmed", the
   follow-ups above, and the paste check owed for the live criterion (the next free id at the merge: the finisher
   checks main's HANDOFF, every local branch's and the plan folder, as the project skill says), its entry at the top
   of "End-of-run check list".
3. `BUILD` bumped at the merge (never in the copy).
4. Main `CLAUDE.md` after the merge: the Status line (build, one line for this job with its paste check); in
   "Decisions the user made", replace "Code-method class names start with the page's name" with: names are
   `<site prefix>-<purpose>-<label>` from `src/shared/class-names.ts` in both tools, a name is given once and never
   reused for other rules, the site's list lives beside the upload record (importer) and in the Figma file (plugin),
   only the tools' own helper classes keep fixed names; in "Working in this repo": a job that changes how a class is
   written gives it a new label, so it says so in its notes, and tests that convert twice pass the first run's list.
5. Proposed line for `figma-to-bricks/references/rules-summary.md` (the finisher returns it; the main session
   saves it): "Class names: `<prefix>-<purpose>-<label>` via `src/shared/class-names.ts`; importer list beside the
   upload record, plugin list in the file; helpers keep fixed names."
6. `reference/bricks/README.md` "Global classes on paste": the dialog's labels and what an element keeps after
   Reject, from 2.4.2 (`<E>/bricks-import-classes-2.4.2.txt`).

## Reporting (the builder's and every later role's report)

Status, the head, each criterion with its test's result, the tallies against the base by test name, rulings made
while building, `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with
`MAIN SESSION: check and save these skill_lessons now.` Reviewers and auditors also answer: "would a Bricks pro
find these names logical and easy to change?"
