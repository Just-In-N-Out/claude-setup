# GRO desktop: gaps between sections, text jumping lines, and other layout bugs

## Context

The user pasted "GRO — Homepage · Desktop 1440" (debug file `figma-to-bricks-debug-design-inspo-brainstorm.json`, build
2026-10-07.15, pictures inside the JSON), and the desktop isn't a 1:1 copy of Figma. The screenshots show:
- a grey box under "SCROLL TILL SUNRISE";
- INSIGHTS wrapping in the nav;
- the hero line hidden behind the desert waves;
- pink and cream strips between sections;
- "4.1" sitting over "Photography".

The user also asked for every other bug on the page. I reproduced them all in the replay and Chrome at 1440 and swept
the page section by section against Figma's render.

This design is **entirely free-floating**: every frame is `layoutMode: NONE`, so every row and column is inferred by
v2. Every fix is a general rule for a class of design and nothing is keyed to this file. Some fixes apply to every
design: letter-spacing, aligned texts, transparent text, the shape pin and bleeding art.

## Decisions (user, 2026-10-07)

- **Desktop only in this plan.** A phone pass for free-floating designs (picture headings that shrink, placed layers
  that restack, decorations that scale) is a separate plan straight after. This plan must not make phones worse. Any
  value it adds that would misbehave below desktop is reset by an adapt rule.
- **Content inside the 64px margin** (the hero's sideways text at x=27, the testimonial quote mark at 32) stays exact at
  the design width, hanging into the margin. On tablets and phones it moves inside the tier's own gutter (36/16).
- Record both in CLAUDE.md "Decisions the user made" and in `docs/HANDOFF.md`.

## Root causes (all verified)

| # | Symptom | Cause | Where |
|---|---|---|---|
| 1 | Labels 2–3px wider than Figma's box; rows overflow | CSS adds letter-spacing after the last letter, Figma's box doesn't (Chrome − ls = Figma ±0.4px over 154 texts) | style (text) |
| 2 | Nav wraps INSIGHTS; "LET'S GRO →" and "SEE OUR WORK →" drop the arrow | hugging rows of words get `flex-wrap: wrap` at all widths | `style.ts:123-125` |
| 3 | "FULL-SERVICE. NATIONWIDE…" and "CLIENT NAME" wrap | `onOneLine` nowrap only for column-wide auto-width texts | `sizing.ts:47-56` |
| 4 | "4.1", "Create", "02 / 04", "exists." show at the left, over other text | a one-line text's box is swapped for `widthMin`, assuming left alignment | `place.ts:39-43`, `sizing.ts:36-42` |
| 5 | Waves and dunes cover text (sections 02, 12) | inference regroups children; a placed layer lying between flowing layers in z goes on top of all of them | `infer.ts:215-228` |
| 6 | Pink strip at the bottom of a section | art bigger than its section is stretched to 100%×100% with `contain` | `place.ts coverStyle`, `style.ts picture()` |
| 7 | Cream strip between services and the yellow section | a band's inferred top space is dropped (`parentFlow` null, so no desktop or tier margin) | `understand.ts:185`, `style.ts band()` |
| 8 | Grey box under "SCROLL TILL SUNRISE" (editor) | shape Divs aren't pinned against the editor's 90px empty-box size | `style.ts:212-221` |
| 9 | Full-width waves, curve, team photo and contour lines boxed in by the gutters | edge-to-edge layers become Container items | `understand.ts sectionIR` |
| 10 | Content up to 58px right of Figma; rows collide or overflow (04 TOC, 11 columns, footer) | inferred left offset is a % margin from the frame's edge, then the Container adds its gutter | `infer.ts`, `place.ts nudgeStyle` |
| 11 | 06's card squeezed, caption off its photo | a row reaching the frame's edge is fitted into the Container | same as 10 |
| 12 | 07: five invisible service lines show in dark text | a text fill with opacity 0 is dropped, so the text takes the theme colour | `text.ts runOf` |
| 13 | Hairline strips at section edges | rounded px boxes lose the art's aspect, and `contain` letterboxes by ~1px | `style.ts picture()` fit |

Before any fix, section heights at 1440 (built − Figma) are: hero +40, 02 +13, testimonial +15, footer +2.

## Process (CLAUDE.md milestone flow, no stop between plan and run)

1. Back up the repo to the scratchpad (`rsync -a --exclude node_modules --exclude corpus/out`).
2. Write this plan as `docs/plans/2026-10-07-gro-desktop.md` (writing-plans skill), with a ledger in
   `.superpowers/sdd/gro-desktop/progress.md`.
3. Run `npm run check` and `npm run corpus` before Task 1.
4. Add the GRO file to the corpus (`corpus/files/gro-home.json` + `corpus.json`). Every current corpus file is wider
   than 1440, so the corpus alone can't prove fixes 2 and 3.
5. Each step is test first, with a generic fixture (never a copy of GRO). Prove the test catches the bug by undoing the
   fix in a scratchpad copy.
6. At the end: one fresh review on opus, one fix pass, the ledger moves to `docs/plans/`, and every ruling and
   deferred minor is reported in plain words.

## Steps (structural first, then the ones that depend on row room)

**1. `Flow.inferred` flag** (groundwork)
- Add the field to `Flow` (`normalise/scene.ts`).
- `false` in `flow.ts` (NO_FLOW, `flowOf`) and `understand/copies.ts`; `true` in `infer.ts` `line()` and `grid()`.
- Test in `infer.test.ts`; update the deepEqual in `flow-text.test.ts:13`.

**2. Paint order in inferred layouts (fix 5)**, in a new `normalise/paint-order.ts` used by `inferLayout`.
- **Rule:**
  - A placed layer paints under the flow when every flowing layer it overlaps is above it, and over it otherwise.
  - If it lies between flowing layers it overlaps, the ones under it leave the flow too. They stay placed where they
    are, painted under it in Figma's order. Repeat until nothing lies between.
  - Save and restore each child's `{absolute, sizing, nudge}` between attempts (`group()` changes them).
- Warn when text is taken out of the flow (it won't reflow on phones; the phone pass handles it).
- Test: a generic "layered landscape" (disc, bleeding back art, pole, bleeding front art, texts) gives order
  [disc, back, pole, front, …flow], all four at `zIndex -1` in DOM order. Plus a no-sink case. Existing guards
  `infer.test.ts:61` and `:153` must still pass.
- Out of scope: auto-layout frames with absolute children in mid z-order (flow items can't leave auto layout, and
  z-index on content is capped at 1).

**3. Measure section columns from the Container's content box (fixes 10, 11)**
- New `normalise/content-box.ts` `rebaseSections(root)`, called at the end of `inferLayouts` for page sections only
  (`normalise.ts:186`).
- **Rule:**
  - An inferred, start-aligned column of a section on a page ≤ `CONTAINER_MAX` is measured from the gutter
    `BREAKPOINTS[0].gutter`. Full-width parts don't set the edge. The section's full-width bands with inferred columns
    are handled the same way.
  - Padding becomes G/G, and nudges become shares of W−2G.
  - A layer starting in the gutter gets a negative `nudge.cross`, so it hangs into the margin (user decision).
- A box wider than its column keeps its width as a share of the column, e.g. 105.5%: `sizing.ts` `hangs(ir)`.
- `understand.ts:174`: a hanging run item isn't made the Container.
- Adapt:
  - `unpin.ts`: a hanging box goes back to `widthMax: 100%` at `tablet_portrait`;
  - `space.ts`: a negative cross nudge goes to 0 at `tablet_portrait`.
- Wider pages and auto-layout sections are unchanged; layers within 1px of the gutter are ignored.
- Tests:
  - new `content-box.test.ts`: a 1440 page gives padding 64, a −14 nudge for a layer at 50 and none for one at 63; a
    full-width rect doesn't zero the padding; a 1728 page is unchanged;
  - `style.test.ts`: a negative share margin and a cap above 100%;
  - `adapt-unpin` and `adapt-space` at `tablet_portrait`;
  - `convert.test` freePage still passes.

**4. Band top space (fix 7)**
- `understand.ts:185` sets `b.parentFlow = flow` (update the `ir.ts:30` comment).
- `style.ts band()` merges `flowPlace(ir)`, so `space.ts` writes the fluid, tablet and phone steps from the same nudge.
- Test: a free section, then a painted full-width group far below. Its desktop `margin.top` equals the nudge, and the
  tablet and phone values are stepped.

**5. Full-width parts (fix 9)**, in `understand.ts sectionIR`.
- **Rule:** in a section laid out by v2, a part spanning the section edge to edge spans the page like a band, painted
  or not. The part is a lone layer, or the CUT group of what overlaps it.
  - A lone picture or shape becomes a full-width element with no height, so it keeps its shape through aspect-ratio.
  - A group becomes a band with a flow-none Container.
- Auto-layout sections are unchanged (guard: `understand.test.ts:216`).
- Test: intro text, a full-width photo with a caption, a text, then a full-width divider. Section children come out as
  [container, band, container, vector], and the divider gets `width 100%` and aspect-ratio.
- Check that `planPhones` copes with bands in free sections.

**6. Picture boxes and fit (fixes 6, 13)**
- `geometry.ts` `bleeds()`. `place.ts coverStyle(n, parentBox, below)`: a cover reaching more than 2px past its parent
  keeps its own box as shares (e.g. −2%/0/104%/106.67%); other covers stay 100%.
- `picture()` fit: FIT photos and vectors in the flow use `contain`; boxes the design sets both ways (placed, cover) use
  `cover`, so rounding can't leave a strip.
- Tests: bleeding art gets the % box and cover; a plain cover is unchanged; a placed vector gets cover; the
  `convert.test.ts:91` flow-vector check still passes.

**7. Aligned texts keep their box (fix 4)**
- `place.ts:39-43`: use the `widthMin` path only for left or justified text placed by its left.
- `sizing.ts textWidth`: centred or right-aligned text gets `width: w, widthMax: 100%`.
- Tests: a right-aligned 533 box keeps `width 533`; a left-aligned text placed in the right half keeps its width;
  plain left texts are unchanged.

**8. Trailing letter-spacing (fix 1)**, in a new `style/tracking.ts`.
- `ls` is the last run's letter-spacing in px, only when above 0. The text gets `margin.right: -<ls/size>em`, combined
  through `place.ts add()` (export it).
- Numeric `width`/`widthMax` taken from Figma's box grow by ls; ink-based `widthMin` floors don't. Turned texts are
  skipped.
- Bricks Buttons: `padding.right = max(0, p.right − ls)`.
- Tests via a new `letterSpacing` option in `test/fixtures/builders.ts text()`: labels, a right-aligned placed box, a
  multi-line text, a turned text and ls ≤ 0, and a Button.
- Paste round-trip of an `em` margin goes on the HANDOFF check list.

**9–10. No wrapping from the design width up, only in sections shown as drawn (fixes 2, 3)**
- `SectionInfo.exact`: true when the page is ≤ `CONTAINER_MAX` and each Container's inner fits the content width
  (+2px) or has a `maxWidth`. Computed in `sectionIR`; the style `visit` passes it down.
- Fix 2: word rows keep `{wrap: true}` (`layout.ts wraps()` reads it) and add
  `fromDesign: { width, css: ["flex-wrap: nowrap"] }` when exact and Figma doesn't wrap them.
- Fix 3: `onOneLine(ir, exact)`: in an exact section, every text Figma draws on one line gets nowrap, Button labels
  too.
- Tests: extend `style.test.ts:278` and `:420` (1440 page gets nowrap, a 1728 page doesn't), and add an auto-layout
  section with 40px side padding (no nowrap). Regenerate the golden `convert-sample.json` after review.

**11. Transparent text fill (fix 12)**
- `text.ts runOf`: when fills are listed but none shows, the text is its own hue at alpha 0. Missing fills keep the
  fallback (`flow-text.test.ts:50-51`).
- `phone.ts dots` skips alpha-0 inks.
- Test: an opacity-0 fill gives `rgba(…, 0)`.

**12. Shape pin (fix 8)**
- Pull `emptyBox(st, ir)` out of `style.ts:203-209` and use it in `picture()` (inline, as now) and in `shape()` (both
  branches).
- Test: a 1×46 gradient rect gets `_widthMin: min(1px, 100%)`, `_heightMin: 0` and the outline rule.

**13. Close**
- Bump `BUILD`. Update CLAUDE.md "where things stand" and the decisions. CLAUDE.md names `npm run snap`, which doesn't
  exist; correct it.
- Update HANDOFF: paste checks for the em margin and for the nowrap rule beating `_flexWrap`.

## Verification

- `npm run check` passes (`plugin-convert` stays byte-identical).
- `npm run corpus` is no worse than baseline at any width.
- GRO in paste mode, through a scratch script with the real SVGs:
  - at 1440: every section exactly its Figma height; `text-overlap` = 0; no overflow-x;
  - side-by-side crops against Figma for all 13 sections: nav on one line, arrows on the buttons, waves under the
    text, no strips, content at x=63, full-width art edge to edge, hidden lines hidden;
  - at 1920: still correct;
  - at 390, 768 and 1024: no new overflow or collisions against the pre-change shots.
- Re-measure the leftovers: footer +2px and the sideways text (~8px).
- `pbcopy` the paste for the user. The photos in replay files are grey stand-ins; real ones come from the plugin.

## Deferred (reported, not fixed here)

- "Good partnerships…" is 2 lines in Figma and 1 in Chrome (font metrics).
- Negative letter-spacing isn't compensated; its error is in the safe direction.
- The header row may spill 1–3px into the gutter instead of wrapping (63px grid and rounding).
- Auto-layout frames with absolute layers in mid z-order.
- Full-bleed children of auto-layout sections.
- The phone pass, and the phone menu (still waits for the Nav Nestable sample).
