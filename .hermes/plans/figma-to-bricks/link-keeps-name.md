# link-keeps-name: a folded box's label never renames a link that has its own words

Mini pipeline. Base: main `034c5d0d` (Build 2026-11-17.4). Website importer only (`src/core/site`).
Planner's evidence (prototype diff, the three test files, probes, logs):
`~/.hermes/plans/figma-to-bricks/evidence/link-keeps-name/planner/`.
The builder copies this plan to `docs/plans/2026-11-17-link-keeps-name.md`.

## Questions (the ⭐ answer is taken under the standing auto-go)

- **Q1. A link whose words show on some screens only** (words on phones, an icon alone on wider screens), under a
  labelled box: ⭐ **A** the box's label stays on the link, as today (without it the link would have no name at the
  widths where its words are hidden). **B** the label is left out there too.
- **Q2. The box's `role`.** ⭐ **A** a role that would take the words away as the name (`region`, `group`, `img`,
  `listitem`…) is left out together with the label, only where the element keeps its own name; a role that is itself
  named by its words (`heading`, `button`, `tab`…) lands as today. **B** no role is ever handed onto a link, button or
  heading (this changes a saved fixture: the `elementor-faq` capture's four FAQ title links lose `role="heading"` on
  the plain route, and breaks one existing pin).
- **Q3. The box's `title`.** ⭐ **A** it still goes down, as today (beside words a title is a tooltip, never the
  name). **B** it is left out with the label.
- **Q4. How far the rule reaches.** Justin's decision names links. ⭐ **A** the same rule for everything that is named
  by its own words: links, buttons, headings, elements whose role is named by its words, and pictures with an alt.
  **B** links and buttons only (a heading or a picture under a labelled box is still renamed).

## Playback

When the importer folds a wrapper box into the one element it holds, it moves the wrapper's accessibility names onto
that element. If the wrapper carried an `aria-label`, the link inside is then read by that label instead of its own
words (the site says "Read more", the paste says "Summer offers"). Justin decided (2026-11-16, "Link keeps its
words"): a link that has its own words keeps them as its name; the wrapper's label goes onto the link only when the
link has no name of its own (an icon-only link). The reason is WCAG 2.5.3 (label in name).

## Root cause (base `034c5d0d`)

- `src/core/site/names.ts:77` `handDown(wrapper, element)`: for each of `NAMEABLE` (`aria-label`, `title`, `role`,
  `aria-hidden`, `aria-current`, `lang`, `dir`, `tabindex`) the wrapper's value is copied onto the element whenever
  the element has none of that name (L80-L85). It never asks whether the element is named by what it holds.
- Its two callers: rule N, `src/core/site/fold-boxes.ts:179`; the Elementor fold,
  `src/core/site/elementor-fold.ts:397`. No other code writes names onto an existing element.
- `src/core/site/tree.ts:117` `namesOf` then writes that `aria-label` into the link control (`link.ariaLabel`) or as a
  custom attribute, and an `aria-label` replaces the name an element takes from its words.
- Reproduced on the base with hand-made captures (`logs/ac-red-base.tap`): a labelled box over `<a href>Read more</a>`
  gives `link.ariaLabel: "Summer offers"`; a labelled heading widget puts the label on the `h2` Heading; a labelled
  image widget puts it on the linked Image over its alt; a labelled box with `role="region"` puts both on the link.

## The fix: rule L (in `names.ts`, read by both folds)

- **L1, named by its words:** an element whose role takes its name from what it holds (ARIA 1.2 "name from content"):
  its own `role` where it has one (button, cell, checkbox, columnheader, gridcell, heading, link, menuitem,
  menuitemcheckbox, menuitemradio, option, radio, row, rowheader, switch, tab, tooltip, treeitem), else its tag: `a`
  with an `href`, `button`, `h1`-`h6`. A picture is named by its alt.
- **L2, has a name of its own:** the paste holds one for it at every width range it shows in: its own `title`, or
  under it, in what shows in that range and isn't `aria-hidden`: words, a picture's alt, a part's `aria-label`, a
  drawing's `<title>`. A picture: a non-empty alt or title. (Its own `aria-label` always wins, as today.)
- **L3:** on an element with a name of its own, a folded wrapper's `aria-label` never lands, nor a wrapper's `role`
  that is not one of L1's roles. Everything else lands as today: `title` and the other names, a role of L1's list, and
  every name on an element with no name of its own (an icon-only link, a plain box, a picture with no alt).
- Computed only from what the capture holds (tags, roles, words, alts, shown ranges). No site string, class or
  plugin name is read.

**What happens to the wrapper's label:** it is left out of the paste (no hidden copy, no attribute, no class) and
named in one notes line per part, after the other names lines:
`N names of folded boxes are left out, the link, button, heading or picture inside keeps its own name: aria-label "…", role "…"`
(at most five named in full, then `, and K more`; `1 name … is left out` for one).

**The Bricks-pro standard:** the paste's link reads as the site's link does and as its visible words say (point 6,
looks stay true, and "A website paste keeps the site's accessibility names"); nothing new is written: no attribute,
no class, no Code element. A builder who wants the label back finds it in the notes.

**The plugin (Figma route) is not changed:** a Figma frame carries no accessibility name, and the plugin's own names
(`src/core/understand/cta-names.ts`) already contain the visible words. Only `src/core/site` changes.

## Acceptance criteria (all proposed; no live AC)

- AC1 (proposed): Given a box carrying an `aria-label` that rule N folds into the link it holds, then a link with a name of its own (words, a hidden arrow beside words, words through different parts at different widths, a picture's alt, a named part, a titled drawing, its own title) carries no `aria-label`, the paste holds no copy of the label and the notes name it; a link with none (an empty or missing alt, words that are `aria-hidden`, never shown or shown at some widths only, an untitled or hidden drawing) carries the label in its link control as before; the box's `title` still lands; the link's own `aria-label` wins as before. Test: `AC1 a folded box's aria-label never renames a link that has a name of its own, and still names a link that has none` (`test/unit/site-link-keeps-name.test.ts`).
- AC2 (proposed): The same for every other element named by its words: a button, each of `h1`-`h6`, a box with each of the 18 roles of L1 and a picture with an alt or a title keep their own name; a plain box, a box with another role, an empty button, an `a` with no address and a picture with an empty alt take the label as before. Test: `AC2 a button, a heading, an element a role names by its words and a picture with an alt keep their own name; a plain box, another role's box and a picture with no alt take the label` (`test/unit/site-link-keeps-name.test.ts`).
- AC3 (proposed): A folded box's `role` that is not one of L1's roles is left out with its label (or alone) where the element keeps its own name, and named in the notes after the label; a role of L1's list lands as before; on an element with no name of its own both land as before; the element's own role wins as before and decides whether its words name it. Test: `AC3 a folded box's role that isn't named by its words is left out with its label where the element keeps its own name; a role named by its words, and both on an element with no name, land as before` (`test/unit/site-link-keeps-name.test.ts`).
- AC4 (proposed): The Elementor fold follows the same rule: a heading widget whose box and holder are both labelled gives a Heading with no `aria-label` and both labels named (the nearest first); a linked picture whose link fills its widget box keeps its alt as its name; the same picture with no alt takes the widget's label. Test: `AC4 the Elementor fold keeps the rule: a heading widget's and a linked picture's own name stay, each folded box's label named; a linked picture with no alt takes it` (`test/unit/site-link-keeps-name.test.ts`).
- AC5 (proposed): Each part's notes hold one line naming what was left out (at most five in full, then how many more), after the other names lines; a part or page that left nothing out holds no such line; a left-out label is held nowhere in the paste; the same capture gives the same result twice. Test: `AC5 one notes line per part names the labels and roles left out, at most five in full, and a part with none says nothing` (`test/unit/site-link-keeps-name.test.ts`).
- AC6 (proposed): Against the base tree, every other paste is the base's byte for byte: all 14 fixture captures in the eight variants (112 results: paste, notes, sources), and every part of each named scan on both routes (B-Dry's six saved scans: 36 parts, 0 differ, the count printed); and a page of four labelled boxes differs from the base's only by the `aria-label` and `role` of the two elements that keep their own name and by the names lines of the notes. A story pin, run with `F2B_STORY_PINS=1`. Test: `AC6 every fixture paste and every named scan's paste is the base's byte for byte, and a page of labelled boxes differs only by the names rule L leaves out` (`test/unit/link-keeps-name-pins.test.ts`).

No live AC and no paste check: none of Justin's six saved scans holds the shape (0 of 36 parts change, both routes),
so there is nothing new to look at on his site.

## Proven on a prototype (planner, 2026-11-17, scratch trees made with `git archive` of `034c5d0d`)

- On the base, with only the test files added: the six tests fail, each by its own assertion (`logs/ac-red-base.tap`).
- With the source diff applied: the six pass (`logs/ac-green-proto.tap`), `tsc` (both configs) and the build pass.
- Whole unit suite on the prototype: 4178 tests, 4030 pass, 141 skipped, 7 fail; the base: 4172, 4025, 140, 7. The 7
  are the same on both and are "not a git repository" errors of a `git archive` tree (`git show`, `git diff`), not
  failures of the code (`logs/unit-base.tap`, `logs/unit-proto-final.tap`). `test/unit/site-names.test.ts` passes
  unchanged: no existing test pins the old behaviour.
- A first, wider role rule (Q2 B) changed the saved `elementor-faq` fixture and broke an existing pin
  (`logs/pins-fixtures.txt`, `logs/unit-proto-L4wide.tap`); the rule above does not.

## Tasks (one commit, test first)

1. Copy this plan to `docs/plans/2026-11-17-link-keeps-name.md`; start the ledger
   (`.superpowers/sdd/2026-11-17-link-keeps-name/progress.md`); run `npm run corpus` once before the change.
2. Tests first. Copy these three files byte for byte from the planner's evidence folder `files/` to the same paths in
   the repo (sha256 in brackets):
   - `test/fixtures/site-wrapper-names.ts` (`d4d9689d3957d9a165fb3c60ee6b4e8c281d42dfe7d0f5fa4191497bc1c1c99f`): the generic labelled chains.
   - `test/unit/site-link-keeps-name.test.ts` (`9e18ab523377ca3ada9cded584455df25d816e11b62399051f017003357d5acc`): the tests of the first five criteria.
   - `test/unit/link-keeps-name-pins.test.ts` (`d7266db71c079f146d33fc2e90275869a3d7a8b7528e218843ca2fa5b8bea7fd`): the story pin.
   Run `node --test test/unit/site-link-keeps-name.test.ts`: 5 fail, by assertion (a label on the element, a missing
   notes line), not by an import error. Keep the output as the RED receipt.
3. The fix. Apply `proto-src.diff` from the evidence folder (`patch -p1 < …/proto-src.diff` from the repo root;
   sha256 `c9a2783100e2d13aa2d5febb87fbe5a7d2daece689ed5457b9b2eaf22c620853`; it applies cleanly to `034c5d0d` and gives the prototype's `src` exactly). It changes:
   - `src/core/site/names.ts`: rule L (`namesItself`, the L1 role and tag lists), `handDown(wrapper, element, nodes)`
     returning `left`, `NamesCount.left`, `addNames` joining it, the new line in `namesNotes`.
   - `src/core/site/fold-boxes.ts` and `src/core/site/elementor-fold.ts`: pass `nodes` to `handDown`, collect `left`,
     return it (`BoxesFolded.left`, `Folded.left`).
   - `src/core/site/convert.ts`: collect both folds' `left` and hand it to `addNames` beside `byId` and `notHeld`.
   Run the same test command: 5 pass. Run `node --test test/unit/site-names.test.ts`: 2 pass, unchanged.
4. The story pin. Make the base tree with plain commands, each alone:
   `git archive --format=tar -o ~/.cache/lkn-<role>/base.tar 034c5d0d`, then `tar -xf` it into
   `~/.cache/lkn-<role>/base` and link the repo's `node_modules` into it. Then, from the repo:
   `env F2B_STORY_PINS=1 F2B_BASE_TREE=<that folder> F2B_SCANS=<folders> node --test test/unit/link-keeps-name-pins.test.ts`
   with `F2B_SCANS` naming `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run` (required: the read-only copy
   of Justin's home scan) and, as they are today, `~/Downloads/bdryswi-com-home`, `-about-us`,
   `-basement-waterproofing`, `-contact-us`, `-egress-windows` (read only). Expect 1 pass and the printed line
   `scans: 6; parts compared on both routes: 36; … (names changed): 0`. If a later rescan in `~/Downloads` holds a
   labelled box over a named link, that folder's difference is the rule's own: leave the folder out and say so.
5. Gates: `npm run check`, `npm run corpus` (no worse than before). One terminal capture per criterion (nothing
   visual changes). Commit: fixture, two test files, four source files, the plan copy.
6. Docs & records (one task): HANDOFF section "link-keeps-name" that answers importer-parity's open question
   ("a folded wrapper's `aria-label` renames its link … keep that?", `docs/HANDOFF.md` L1907: no, "Link keeps its
   words") with rule L, Q1-Q4's answers as not yet confirmed and the follow-ups below; the ledger; at the finish the
   Status line (no paste check owed) and one standing rule in CLAUDE.md "Working in this repo": "A folded wrapper's
   `aria-label` (and a role not named by its words) never lands on an element that has a name of its own
   (`names.ts` rule L); add every new step that hands a wrapper's names down to `handDown`."

Suggested mutants for the reviewer (not run by the planner): drop `own &&` in `handDown`; `every` to `some` in
`namesItself`; drop the role clause; drop `left.push` in either fold; drop `left` in `convert.ts`.

## Touched files

Source (4): `src/core/site/names.ts` (+59 −8 lines), `fold-boxes.ts` (+6 −3), `elementor-fold.ts` (+4 −2), `convert.ts` (+4 −1).
New tests (3): `test/fixtures/site-wrapper-names.ts`, `test/unit/site-link-keeps-name.test.ts`,
`test/unit/link-keeps-name-pins.test.ts`. Docs: the plan copy, the ledger, `docs/HANDOFF.md`.
Older story pins that list the source files later jobs changed (`test/fixtures/later-jobs.ts`,
`media-avif-untouched`, `site-import-figma-unchanged`) already name all four files; nothing to add there.

**Size:** four source files, one more than Mini's "about three", but three of them change by a few additive lines
and there is no design decision left beyond the ⭐ answers. Still Mini.

## Files shared with fewer-kept-boxes (branch `fewer-kept-boxes-on-main8`, `c75e4caf`; either merge order)

- `src/core/site/fold-boxes.ts` (both change it). That job rewrites the `BoxesFolded` line, `foldBoxes`' signature
  and its return line; this job adds `left` to the same interface and return line, a `const left` line, the third
  argument of `handDown` and one `left.push` line. A textual conflict on the interface and return lines is expected:
  keep both (that job's fields and `left`).
- `src/core/site/convert.ts` (both change it). This job adds four one-line pieces beside the `clashes`/`byId` lines,
  which that job leaves as they are; keep both.
- Not shared: `names.ts`, `elementor-fold.ts`, `parity-notes.ts`, `test/unit/site-names.test.ts` (that job changes
  none of them); `parts.ts` (only that job).
- The exact merged lines are in `probes/apply_fkb.py`. Proven on a tree of `c75e4caf` with this job laid over it
  (`logs/combined-fkb8.tap`): `tsc` passes; 35 of 35 tests pass (this job's six, `site-names`, and that job's
  `site-fold-boxes`, `site-fold-moves`, `site-fold-moves-off`, `site-elementor-fold`); the story pin run against
  `c75e4caf` as its base: 112 fixture results and 36 scan parts byte for byte.
- What this job assumes from that one: nothing. Its extra folds only mean more boxes reach `handDown`, each judged by
  the same rule; its fixtures hold no labelled box, so neither job moves the other's pins. Whichever merges second
  re-runs its own story pin with the other's head as the base tree (the pin compares trees, not saved sums).

## Found on the way (not in this job)

- On the base, the saved `elementor-faq` fixture's plain route hands `role="heading"` from a `div` onto four FAQ
  title links (a link that then reads as a heading). Q2 B would end it; under Q2 A it stays, as today.
- `src/core/site/tree.ts` `attrsFor` (L128-L141) puts an absorbed inner element's `aria-label` on a Button that has
  words. A suspicion only: no capture of Justin's shows it.
- The rule reads the capture's alt. A picture whose site alt is empty but whose media-library alt has words (the AI
  alt text) is treated as unnamed, so a box's label still lands on its link.
- Limits: words inside a word box's inline markup are read per box, not per width range; a name that points at
  another element by id (`aria-labelledby`) is never pasted, as today.
