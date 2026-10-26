# Drawn phone design (desktop + phone frames in one Convert)

## Context

Today the plugin takes one desktop-drawn page and generates tablets and phones from it (the rulebook in
`src/core/adapt/rules/`). The user wants to keep that, and add an option for when their UI designers drew the page
twice: a desktop frame (e.g. "Final homepage", 1440) and a phone frame (e.g. "GRO — Homepage · Mobile 390", 390).
Then phones should show the designer's phone drawing instead of the automatic version.

This is part of v2's deferred "breakpoint designs" item (CLAUDE.md "Deferred"), now asked for. It has a simpler
shape than v1's hidden "Breakpoint designs" checkbox: v1 merged the widths into one tree by matching layer names and
text, and the user chose two copies instead.

Today, selecting both frames stacks them into one page: `understand.ts:77-87` concatenates every root's sections,
the width is the widest root, and the backdrop comes from the first. The phone sections would show under the desktop
ones at every width.

## User decisions (2026-10-08)

- **How to ask for it:** select the desktop frame and the phone frame together, then Convert. The plugin tells them
  apart by width, and the panel shows what it found before Convert. One frame selected means today's behaviour,
  unchanged.
- **Bricks shape: two copies, swapped.** The paste holds the desktop page's sections (hidden at ≤767px) and the
  phone page's sections (hidden at ≥768px). No layer matching. A text edit in Bricks is made in both copies, which
  the user accepted.
- **Switch at 767px** (`mobile_landscape`). The user wasn't sure, so this is the recommended default.
  - Tablets (768–991) get the desktop design, adapted as today.
  - Phones get the drawn phone design: exact at its drawn width, and fluid around it. Narrower phones shrink it;
    wider ones (up to 767) stretch it, with the drawn side margins, pictures keeping their shape and text at its
    drawn size.
- **Designers draw whole pages on phone, and no tablet frame.** No per-section fallback.

## Design

### 1. Detection: one pure function, used by both the panel and the conversion

- **New `src/core/snapshot/designs.ts`:** `splitDesigns(roots)` works on `{name, width, type, visible}`, which both
  `ExtractNode` and `SNode` have.
  - Only visible roots that aren't slices count.
  - **Pair mode** needs roots on both sides of 768. Roots that are frame-like and 320–767 wide form the **phone**
    design. The rest form the **desktop** design. Each side keeps selection order, so several section frames stack
    as they do today.
  - **No pair:** everything is desktop, a phone-only selection included. Today's path is untouched.
  - **Roots 768–991 in pair mode** join the desktop design (it serves 768 and up), and a warning names them.
  - The 320 floor stops a stray icon or text from switching the mode.
  - Also exports `designSummary()` for the panel.
- **`src/shared/breakpoints.ts`:** `PHONE_MAX` (from `mobile_landscape`'s `maxWidth`) and `DRAWN_PHONE_MIN = 320`.
- **Panel:**
  - `messages.ts` gets a `{type: "selection", summary}` message.
  - `plugin/main.ts` posts it on `figma.on("selectionchange")` and once after `init`. Today the panel never hears
    about the selection.
  - New DOM-free `src/ui/selection.ts` writes the line, for example: "Desktop: Final homepage (1440) · Phone:
    GRO — Homepage · Mobile 390 (390) — phones use your phone design."
  - The line goes in `<p id="selection">` above Convert (`ui/main.ts`, `index.html`).
- **Normalise:** `Page` (`normalise/scene.ts`) gains `design: "desktop" | "phone"`, set in `normalise.ts` from
  `splitDesigns`. A debug file replays exactly what the panel showed, with nothing new in the snapshot.

### 2. IR: designs carried side by side, decided once at understand

- `PageIR` (`understand/ir.ts`) gains `designs: DesignIR[]`, where
  `DesignIR = {kind, width, gutter, backdrop, sections}`.
  - `page.sections` is the designs' sections joined, desktop first.
  - `page.width` and `page.backdrop` are the desktop design's.
  - Single mode has one desktop design holding everything, so its output stays byte-identical.
- **`understand.ts` loops per design** (moved into a new `understand/designs.ts` if `understand.ts` grows):
  - `sectionIR` and `space()` stay per root, as today.
  - **Visibility is set at creation.** In pair mode a section gets `show = "desktop"` or `"phone"`. The existing
    `style/behaviours.ts:47` (phone-only content gets `display:none` at desktop) and `phone.swap`
    (`adapt/rules/phone.ts:17`, display at `mobile_landscape`) then do the swap unchanged. Its hero-band margin branch
    needs `role === "phone"`, which drawn sections don't have.
  - **`assignHeadings` runs per design,** so each copy has its own single h1. The hidden copy is `display:none`, so
    screen readers skip it.
  - **`planPhones`** (automatic phone copies: hero buttons band, intro buttons, phone sliders) runs only in single
    mode.
  - Accordions, compose, hovers and the inline-picture pass stay page-wide; they work per node.
- **`understand/section.ts` gets a `phone` flag:** the Container records the frame's drawn side padding (new
  `IRNode.sides`, defaulted in `node.ts`). It skips the 64px "narrow" max-width and counts as roomy.
  `DesignIR.gutter` is the most common `sides` among phone Containers, else 16.

### 3. Adapt: one rule context per design, tiers filtered at engine level

- **`adapt/engine.ts`:** one `RuleContext` per design. Its view of the page has that design's sections, width and
  backdrop. `pageFacts(view, design)` takes the phone gutter from the drawing. Each design gets its own
  `planLayout`. Rules stay the outer loop, in order, with one shared ownership map, so collision checks stay global.
- **`tiersOf(design)` in `facts.ts`** keeps the tiers whose screens overlap where the design shows:
  - single mode: all tiers;
  - desktop in pair mode: `fluid` and `tablet_portrait`;
  - drawn phone: all of them.

  `Out.element` and `Out.cls` drop the other tiers. The desktop copy then gets no dead mobile styles, without
  per-rule checks.
- **New `Rule` flags (`adapt/types.ts`):**
  - `shows`: on `phone.swap`. Its writes stand on every tier, because it is what hides a design.
  - `fits`: a rule that keeps a drawing exact at its width and whole around it.

  The drawn phone runs only rules with `fits` or `shows`. Per design:

  | Rule | Desktop (pair mode) | Drawn phone |
  |---|---|---|
  | space.ramp, type.ramp, size.unpin, compose.stack, row.reflow, turn.upright, grid.columns, split.order | runs; only fluid and tablet output survives | skipped: it's already the designer's phone layout |
  | cta.fullWidth, footer.center | filtered out (mobile tiers only) | skipped |
  | media.shape, picture.band, art.edge, row.icons | runs | **fits**: shapes and percentages kept from 320 to 767 |
  | text.breaks | runs | **fits**: the drawn line breaks drop only under 390 (`max-width: 389px`) |
  | crop.subject | runs | **fits** (ruling: photos cover their box, centred on Figma's crop at every phone width; a zoomed Figma crop can differ by a hair at 390, but photos never stretch at 320–767) |
  | text.wrap, tap.targets | shared classes | phone texts get no balance or pretty; `tap-area` is shared |
  | phone.swap | **shows**: `display:none` at mobile_landscape | **shows**: `display:flex` at mobile_landscape |

- **How the phone stays fluid:** no Bricks tier separates 320 from 390. As with desktop between 992 and the design
  width, the phone copy's base styles do it: fill widths, `max-width:100%`, `min(Wpx,100%)`, min-heights, and
  Container padding instead of a max-width. `fluid()` returns null for widths ≤992, so no clamp is made. Only
  custom CSS below the design width goes under `@media (max-width: W−1px)`.

### 4. Style and classes

- **`style/style.ts` runs per design** (its loop near line 310), using the design's width in `fromDesign` and its
  backdrop. `style.ts` is already 316 lines, so `fontFor` and the text-style classes move to
  `style/text-classes.ts`.
- **Phone text-style classes:** key `style:<id>@phone`, named `<name>-phone` (made unique as in `classes.ts:44`).
  `ClassDef` gains `design` and `twin`. Otherwise `type.ramp.classes` would step the shared desktop class down at
  tablet and phone, and shrink phone text.
- **Phone Container:** a `site-container-phone` class (width 100%, padding = the drawn gutter), with element padding
  where a section's `sides` differs. In pair mode, `site-container` leaves out its mobile layers.
- **Emit merges identical twins** (new `emit/classes.ts`). When a phone class serialises exactly like its desktop
  twin, its users point to the twin and the phone class is dropped. Body text styles end up shared; headings with
  phone values stay as `x` and `x-phone`.

### 5. Emit and the rest

- **`emit/elements.ts`:** each element and class serialises with its own design's width (fluid media, `fromDesign`).
- **Pictures:** photos de-duplicate by hash and WordPress uploads by fingerprint, so a photo used in both designs is
  uploaded once. In inline mode the same photo is embedded in both copies, which makes the paste bigger; the panel's
  8 MB note covers that. Drawings stay per layer, so the descriptions list may show a logo twice. That's acceptable.
- **Warnings:** a 768–991 root joined to the desktop design; phone roots of mixed widths.
- **Out of scope:** the drawn hamburger doesn't open a menu yet. That's M2d, which waits for the user's Nav
  (Nestable) sample, same as the automatic phones. Native sliders on the phone copy appear only where the phone
  drawing itself makes one.

### 6. Tools

- **`tools/snap.ts`:** each width uses its own design (767 and below uses the phone roots). It counts only visible
  sections, compares heights with that design's Figma frames, and runs `--sides` at each design's width.
- **`tools/lib/corpus.ts`:** the same choice of design for its scores.
- **Lint:** already skips `display:none` (`test/browser/lint.ts`).

## How it runs (CLAUDE.md milestone process)

After approval, without stopping:
1. Write `docs/plans/2026-10-08-drawn-phone.md` with the writing-plans skill.
2. Back up to the scratchpad (`rsync -a --exclude node_modules --exclude corpus/out`) and run `npm run corpus`.
3. Carry out the plan natively, test first, with a ledger in `.superpowers/sdd/2026-10-08-drawn-phone/progress.md`.
4. One fresh opus review of `diff -ruN` against the backup, then one fix pass.
5. Move the ledger, bump `BUILD`, record the decision in CLAUDE.md and HANDOFF, and update the v2 spec's "Leave out"
   line.

Tasks (each test first; generic fixtures in `test/fixtures/`, never copies of GRO):
1. **Detection:** `breakpoints.ts`, `snapshot/designs.ts`. Test `designs.test.ts`: pair, desktop-only,
   phone-only, an 800-wide root, a stray icon, order kept.
2. **Panel line:** `messages.ts`, `plugin/main.ts`, `ui/selection.ts`, `ui/main.ts`, `index.html`. Test
   `ui-selection.test.ts`.
3. **Normalise** design tag. Add it to `normalise.test.ts`.
4. **Understand:** `ir.ts`, `node.ts`, `understand.ts` (+ `designs.ts`), `section.ts`. Test
   `understand-designs.test.ts`:
   - visibility per design;
   - no `copy:`/`phone:`/`slider:` keys in pair mode, even with a CTA hero;
   - one h1 per design;
   - unique keys;
   - drawn sides and gutter.
5. **Style:** `style.ts` split, `text-classes.ts`, `classes.ts`, `types.ts`. Test the phone container class, the
   `-phone` text class, and no balance on phone texts.
6. **Adapt:** `facts.ts`, `engine.ts`, `types.ts`, and the flags on the rules. Test `adapt-designs.test.ts`:
   - desktop nodes have no mobile-tier layers except the swap;
   - phone decisions come only from fits/shows rules;
   - no collisions.
7. **Emit:** `elements.ts`, `emit/classes.ts`. Payload tests:
   - phone sections `_display:none` plus `_display:mobile_landscape: flex`;
   - `max-width: 389px` media;
   - the twin merge;
   - byte-identical determinism;
   - golden and corpus payloads unchanged in single mode;
   - `plugin-convert.test.ts` parity on a pair snapshot.
8. **Tools and browser:** `snap.ts`, `corpus.ts`, new `test/browser/designs.test.ts` (pair fixture):
   - phone sections match the drawn heights at 390;
   - no overflow at 320;
   - no distortion at 767;
   - desktop exact at 1440;
   - only one copy visible at 767 and at 768.

## Verification

- `npm run check` (typecheck, build, unit and rule tests) passes. `npm run corpus` shows no width worse than before,
  and the single-frame payloads of all five corpus files are byte-identical to the backup's (this feature must not
  change today's mode).
- Replay plus snap a pair fixture at 320, 390, 767, 768, 1024 and 1440:
  - phone copy exact at 390;
  - desktop exact at 1440;
  - nothing hidden showing;
  - no lint errors from the copy that is hidden.
- **What the user provides:** a debug file saved with both GRO frames selected ("Final homepage" + "GRO — Homepage ·
  Mobile 390"). Replay and snap it at the widths above. Then the paste check (`pbcopy`): paste into an empty page,
  Cmd+S, preview wide and narrow. This joins the end-of-run check list in HANDOFF.
