# rich-text — amendment 1: every text is Rich Text; a wholly linked text is Rich Text inside a linked Block

**Justin's ruling (2026-11-04, replaces plan Q1/Q2):** "I do not want it for paragraph, I want it for everything."
1. **Every text is Rich Text, except headings**, which stay Bricks' Heading (with its tag). Buttons stay Buttons.
2. **A text that is all one link** (`elementLink(ir) !== null`: an email, a phone number, a whole-text Figma link, a
   Navigate/page link, a link an understand pass set: menu label, logo home, list link, contact value) is **Rich Text
   inside a Block that carries the link in Link to** (`settings.link` with element-link's type/newTab/rel and
   cta-names' `ariaLabel`). **No Basic Text (`text-basic`) is emitted anywhere.**

Base for this amendment: the rich-text copy `agent-a4bddf14ed2da3ed7` at `79438622` plus the review-1 fix in progress
(`emit/rich-text.ts` `asTyped`, `test/browser/editor-content.ts`). **Prerequisite:** element-link
(`agent-a7f58956799bac1e2`, head `906e50fc`) is merged into `main` and the rich-text branch is rebased on it
(it brings `ir.textLink`, `ir.ts elementLink`, `ctaLinkName`/`ctaAttributes` from cta-names, the linked-heading
`<hN><a>` CSS, and `page-addresses.ts` listing a whole text link by its element's id). Build this amendment on that
rebased branch, after the review-1 fixer's commits.

## Decisions (with evidence)

### D1. Where the wrapper is made: at emit, from one IR node — no IR change

- The IR keeps one node, `element: "text"` (already so on the branch). A wholly linked text is a final IR fact only
  once understand is done (`navigation-links.ts`, `header-bar.ts`, `list-links.ts`, `list-rows.ts`, `phone.ts` set
  `ir.link` late; element-link sets `ir.textLink` at `node.ts` and `elementLink` reads both). So emit, which runs once
  on the final IR, **serialises that one text node as two Bricks elements**: the Block (the link) and its Rich Text
  child (the words). No element changes type, no stage edits an earlier one's output (CLAUDE.md architecture rules),
  exactly as the approved plan already made emit choose the Bricks name.
- Rejected: an understand pass that inserts a wrapper IR node. The layout plan (`adapt/layout.ts`), every rule's
  breakpoint writes (keyed by IR key), recognise passes and `faceOf`/`least` all read the text node as a flow child;
  a new parent changes rows, shares and rule targets for every linked text in every file — a far bigger, riskier job
  for a pure serialisation difference.

### D2. Ids stay deterministic, and the link keeps the id it has today

- **The Block takes the IR node's id** (`ids.get(ir.key)`, unchanged). So everything that names the text's element by
  id keeps working with no change: the rules' and style's `#brxe-<id>` custom CSS, state triggers (`states.ts` ids),
  `page-addresses.ts` (its `ids` list the element carrying the link — now the Block), the panel's `relink`
  (`ui/site-pages.ts`, rewrites `settings.link` of that id), marquee `tabindex -1`.
- **The Rich Text child gets `assignIds(wordKeys, nodeIds)`** where `wordKeys = [<key>:words]` for every wrapped
  text and the second argument reserves every node id (`ids.ts assignIds(keys, reserved)` already supports it). Node
  ids are computed exactly as today, so `page-addresses.ts` (which calls `assignIds` on node keys alone) gives the
  same ids as emit; a word id never takes a node's id; the same snapshot gives the same ids.

### D3. What each of the two elements carries

The text node's settings are what makes its box; its words only inherit. So **everything the node has goes on the
Block, and the Rich Text holds only its words**:

| Block (`name: "block"`, the node's id, parent = the node's parent) | Rich Text (`name: "text"`, word id, parent = the Block) |
|---|---|
| every setting `layeredSettings` writes for the node (computed with element `"block"`, so Bricks' layout-key rules hold: `payloadProblems` "Layout keys by element"), its breakpoint layers, states, `_cssCustom`, `_cssGlobalClasses` (typography classes, `text-balance`/`text-pretty`, `tap-area`, `text-phone-numbers`), `_attributes` (marquee copy `tabindex -1`, cta-names' attributes, hotspot), `label` | `settings.text = "<p>" + asTyped(html) + "</p>"` (the same writer as every Rich Text, review-1 fix included; `copiedTextLinks` first for loop copies) and nothing else: no classes, no typography, no link, no label |
| `settings.link` (element-link's shape + `ctaLinkName`), `settings.tag = "a"` (Bricks' Block shows Link to only with `tag: "a"`: `container.php` controls `link` `'required' => ['tag','=','a']`, `Element_Block extends Element_Container`) | |
| `_display: "block"` unless the node's own base settings already have `_display`; `_width: "auto"` unless they already have a base `_width` | |

Why it looks exactly as today:
- **Box:** Bricks 2.3.9 front end (darksalmon `frontend-light-layer.min.css`, read 2026-11-04):
  `.brxe-block{align-items:flex-start;display:flex;flex-direction:column;width:100%}`; no rule for `.brxe-div`,
  `.brxe-text` or `a.brxe-*`. Block's `width:100%` would stretch the box (CLAUDE.md "Bricks gives every Block width:
  100%"), and its flex column with `align-items:flex-start` would shrink a single-line Rich Text to its words, so
  a fixed-width centred text would sit left. `#brxe-<id>{display:block;width:auto}` (id beats the class) makes the
  Block the same box the Basic Text `<a>` was: in a flex/grid parent both are blockified items sized by content or by
  the node's own `_width`; the Rich Text `div` inside fills it as a block. `_display: "block"` is a Bricks option
  (`base.php` `_display` options include `block`). Breakpoint `_display`/`_width` writes the node already has (phone
  swap `none`, `100%` on phones) stay and win at their tier.
- **Typography, colour, text-align, white-space, text-wrap, letter-spacing, line-height, text-transform, text-shadow,
  `background-clip:text` gradients** are inherited (or, for decoration and background-clip, painted through
  descendants), so on the Block they reach the `<p>`. The approved plan's check stands: `src/core` writes no
  non-inherited text property on a text (`text-overflow`, `line-clamp`, `::first-line`). Link colour: Bricks
  `:where(a){color:currentcolor;text-decoration:none}` applies to the Block `<a>` as it did to the Basic Text `<a>`;
  element-link's `linkInk` (`color: inherit` for a colourless whole link) lands on the Block as before.
- **Descendant selectors** written on the node (`.text-phone-numbers .phone-number`, mark styles, state triggers
  `.trigger-x:hover #brxe-<id>`) still match: the words are now one level deeper, still descendants. No
  `#brxe-${id} >` child selector is written for texts (`grep` in `src/core`: only the linked Heading's `> a`).
- **`tap-area`** (`position: relative` + `::after` inset at tablets) is on the Block = the `<a>` = the click target.
- **Phone menu (Nav Nestable):** Bricks wraps each child of `brx-nav-nested-items` in `<li>`
  (`container.php maybe_wrap_nav_link`, keyed on the parent's `_hidden._cssClasses`); the Block is that child, so
  `<li><a class="brxe-block">…</a></li>`, matched by `.brxe-nav-nested.brx-open li.menu-item a{width:100%}` as the
  Basic Text `<a>` was.
- **Flip cards, hover layers, hotspots, marquee copies:** their attributes and states are node-level → Block. The
  nested-link invariant holds: the Block is the link, its Rich Text has no `settings.link` and its words no `<a>`
  (element-link: `textStyled(ir, linked || elementLink(ir) !== null)` drops inline links of a whole-link text).
- **PDF whole links:** `downloadControl` keys on `ir.element` (`"text"`), so a wholly linked text to a PDF gets no
  `download` attribute, exactly as the Basic Text didn't; it keeps `newTab` (no behaviour change; noted, not changed).

### D4. Headings and Buttons

- **A linked Heading stays Bricks' Heading with Link to** (ruling 1): element-link's `heading` + `settings.link` +
  `#brxe-<id> > a{color:inherit;text-decoration:inherit}` is unchanged; no wrapper. Confirmed.
- Buttons, accordion parts, forms, Nav parts, Code, images: unchanged.

### D5. Known edge (not a question; recorded as a follow-up)

A linked Basic Text `<a>` was `display: inline` when its parent was not flex/grid (Bricks has no `a.brxe-*` display
rule). The plugin's own layout elements are flex/grid, so this is rare; the Block is a block box there, which can widen
its click area to the line (its words stay where they were since text-align inherits). Goes to `follow-ups.md` (P3).
Also a renderer gap found while reading: `test/browser/render.ts` `.brxe-block` lacks Bricks' `align-items:flex-start`
(follow-up, not this job: it changes every Block's render).

## Changed and new ACs (all proposed)

- **AC1 (proposed), amended:** A non-heading text **with or without a link** is emitted as Rich Text (`name: "text"`,
  `settings.text` = `<p>` + its HTML (through `asTyped`) + `</p>`). A text without a link is that one element, with
  no `link` key. Test: `test/unit/emit-rich-text.test.ts` "a paragraph is Rich Text with one <p>" (unchanged).
- **AC3 (proposed), replaced:** Given a text that is wholly one link (each of: its own `ir.link` set by a later
  understand pass, e.g. a logo text linked home; element-link's `textLink` from a whole Figma hyperlink; a `mailto:`
  email; a `tel:` phone number; a CTA text with cta-names' name), when converted, its node's id is a `block` with
  `tag: "a"`, `settings.link` exactly as element-link + cta-names write it (type, url, newTab/rel, ariaLabel),
  `_display: "block"`, `_width: "auto"` (or the node's own `_width`), all the node's classes, attributes, custom CSS
  and breakpoint settings, and **exactly one child**: a `text` whose settings are only `{ text: "<p>…</p>" }`, whose
  id is not any node's id, and whose words hold no `<a`. Test: `test/unit/emit-rich-text.test.ts` "a whole-link text
  is Rich Text inside a linked Block" (one case per kind above).
- **AC4 (proposed), amended:** Across every unit fixture's payload, the rich-text page and every corpus page: **no
  element is `text-basic`**; no `text` carries `settings.link`; every `text`'s words hold no `<a` whose element has a
  linked ancestor; every `block` whose only child is a `text` and that carries `settings.link` has `tag: "a"` and
  exactly one child. Test: `test/unit/emit-rich-text-invariant.test.ts` (rewritten), plus
  `test/unit/emit-nested-links.test.ts` counting the wrapper Block as a link producer (CLAUDE.md "Add every new link
  producer to that test").
- **AC6 (proposed), amended:** Nothing moves, link texts included: in Chrome at 390, 768, 1440 and the design width,
  for the generic fixture (adds: a whole-link email line, a whole-link phone line with its phone-number span, a fixed-
  width centred whole-link text, a menu-label text linked by an understand pass, a small linked text with `tap-area`)
  every text's element box (`#brxe-<id>`: the Block for a linked text) and its words' rectangle (a Range over its
  text) equal main's render (element-link's Basic Text `<a>`) within ±0.5px; `npm run corpus` errors/warnings per file
  and width equal main's. Test: `test/browser/rich-text-boxes.test.ts` (plus the corpus receipt).
- AC2, AC5, AC7: unchanged (AC2's inner HTML now through `asTyped` per the review-1 fix).
- **AC8 (proposed) (live), amended:** Justin pastes a converted page on darksalmon: in Bricks' structure panel every
  non-heading text shows as "Rich Text" (no "Basic Text" anywhere) and opens in the rich editor; a linked text shows
  as a Block (its Link to filled) holding one Rich Text; headings stay Headings (a linked one with its Link to); the
  live page looks and clicks as before (Regenerate code signatures, LiteSpeed Purge All after the paste).
- **AC9 (proposed), new:** Ids: the same snapshot gives a byte-identical payload twice; every node keeps the id
  `pageAddresses` gives it (the wrapper Block of a whole text link to a frame is the id listed for that address, and
  `relink` changes its `settings.link`). Test: `test/unit/emit-rich-text.test.ts` "a wrapped text keeps its id for
  page addresses" (fixture: a whole-text Figma link to a frame; `pageAddresses(page)` id === the Block's id; run
  `ui/site-pages.ts relink` on the payload and read the Block's new url).
- **AC10 (proposed), new:** The payload passes `payloadProblems` with wrapped texts (no layout-only key refused, no
  `_alignSelf: stretch`, no bare flex basis): the node's settings are computed for `block`. Test: the invariant test
  asserts `payloadProblems(payload)` is empty for every fixture and corpus page.

## Tasks (test-first; commit after each passing task)

Source files: `src/core/emit/rich-text.ts`, `src/core/emit/elements.ts`, `src/core/emit/payload.ts` (comment line 10
only). Tests: `test/unit/emit-rich-text.test.ts`, `test/unit/emit-rich-text-invariant.test.ts`,
`test/unit/emit-nested-links.test.ts`, `test/fixtures/rich-text.ts`, `test/browser/rich-text-boxes.test.ts`, plus the
mechanical updates. **Three source files: one fixer pass.**

0. Rebase on `main` with element-link merged (conflicts in `emit/elements.ts`: keep element-link's `elementLink`/
   `ctaLinkName`/heading CSS and this branch's `textElement`); `npm run check`; save `npm run corpus` as the
   amendment's baseline receipt. Capture main's render of the AC6 link fixture (Basic Text `<a>`) as the baseline the
   box test compares against (the test renders a main-shaped payload, as Task 5 of the plan already does).
1. **AC3 / AC9 RED:** add the failing cases to `emit-rich-text.test.ts` (and the fixture texts to
   `test/fixtures/rich-text.ts`). Run `node --test test/unit/emit-rich-text.test.ts`: fails on `name: "text-basic"`.
2. **GREEN, `emit/rich-text.ts`:** replace `textElement` with
   `textShape(ir, html): { wrapped: boolean; text?: string }` — `wrapped = ir.element === "text" && elementLink(ir) !== null`;
   `text = html === undefined ? undefined : "<p>" + asTyped(html) + "</p>"`. Drop `"text-basic"` from the module.
3. **GREEN, `emit/elements.ts`:** in `emitPayload`: after `ids`, compute
   `wordIds = assignIds(wrappedKeys.map((k) => k + ":words"), ids.values())` (walk the IR once for wrapped texts).
   In `visit`: `const wrapped = ir.element === "text" && elementLink(ir) !== null`; call `layeredSettings(…,
   wrapped ? "block" : ir.element, …)`; settings.text goes on the Rich Text when wrapped, on the element otherwise;
   when wrapped, after the link block: `settings.tag = "a"` (extend the existing `div`/`block` line to `|| wrapped`),
   `settings._display ??= "block"`, `settings._width ??= "auto"`; push the Block (`name: "block"`, `children:
   [wordId]`, label) then the Rich Text (`{ id: wordId, name: "text", parent: id, children: [], settings: { text } }`,
   omitting `text` when undefined). Non-wrapped texts: `name: "text"`. Run step 1's test: green. `npm run check`.
4. **Mechanical tests:** every test that looked up a linked text as `text-basic` / `.brxe-text-basic` (element-link's
   and cta-names' tests included: `payload.test.ts`, `ui-text-links.test.ts`, `text-link-followups.test.ts`,
   `convert-contacts.test.ts`, `style-phone-numbers.test.ts`, …) now finds the Block by the node's id (link, tag)
   and the words in its one Rich Text child (the branch's `wordsHtml` helper reads through it; browser selectors
   `.brxe-text`). Regenerate `test/golden/files/convert-sample.json` and `render-order-default.html`; read the diff:
   only wrapped texts gain a Block + Rich Text, nothing else moves. `npm run check`.
5. **AC4 / AC10:** rewrite `emit-rich-text-invariant.test.ts` (no `text-basic`; Rich Text never linked; linked
   text-holding Blocks have `tag: "a"` and one child; `payloadProblems` empty); add the wrapper to
   `emit-nested-links.test.ts`. Mutation check (under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0`): drop `tag = "a"`, drop `_display`, put the link on the Rich Text — each must fail a test.
6. **AC6:** extend `rich-text-boxes.test.ts` with the link fixture texts; compare box and words rectangles against
   main's shape; `npm run corpus` equal to Task 0's receipt.
7. **AC7 / AC9:** replay the corpus twice, `cmp` payloads; `plugin-convert.test.ts` green.
8. **Records:** HANDOFF rich-text section: the new rule ("every text is Rich Text, except headings; a wholly linked
   text is Rich Text inside a Block with Link to; no Basic Text"), Justin's ruling 2026-11-04, D3/D5, AC8's amended
   steps; follow-ups (D5). CLAUDE.md lines for the finisher: Status line, and the standing rule replacing the plan's
   "Basic Text only for a text that is wholly one link".

## Risks

- Bricks' editor: a Block with `tag: "a"` holding a Rich Text — Bricks warns "no elements with links inside your
  linked container"; Rich Text has none, so no warning. AC8 (live) is where a Theme Style styling `a` or `p` shows.
- Element-link's own accepted ACs say "its `text-basic` has `settings.link`" (AC1–AC3 of element-link). Their rule
  (the link lives in Link to, not an `<a>` in the words) still holds — on the Block. Their tests are updated by
  Task 4; say so in HANDOFF.

## Questions

None needed. (Label placement — the node's label goes on the Block, the Rich Text unlabelled — and Block over Div —
Justin's word, and a Div `<a>` has no Bricks display rule so it would be inline — are decided above.)
