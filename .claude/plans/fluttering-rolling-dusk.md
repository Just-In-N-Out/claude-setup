# Desktop fixes from the "Final homepage" debug file (build 2026-10-08.6)

## Context

The user compared Figma with the pasted desktop page and sent two pairs of pictures:

- "It needs the Right idea…" comes out in a serif, wrapping into short lines.
- In "05 · The alreadys", the check list is pushed off to the right with its words overlapping.

Their debug file, `figma-to-bricks-debug-design-inspo-brainstorm.json` (build .6, "Final homepage", 1440 wide), was
replayed and rendered at 1440 with Figma beside it. Both problems reproduce. The comparison found four causes: one
is a missing font, three are general rules in `src/core/style/sizing.ts`. Lint at 1440 now: overflow-x 1,
text-clipped 4, text-overlap 14.

## Findings and root causes

1. **Missing font (pictures 1–2, plus the serif headings and the huge "ALRE…" in picture 3).**
   - Aswatama isn't on Google Fonts, so the site shows the browser's serif stand-in.
   - The stand-in is wider and shows the lowercase letters Aswatama draws as capitals. The text keeps Figma's line
     length (`lineCap`), so the wider letters wrap into short lines.
   - This isn't a conversion bug, and there's no code change. The user uploads Aswatama in Bricks → Custom Fonts,
     with the family name exactly `Aswatama` (the panel already lists it after Convert).
   - Aswatama isn't installed on this Mac, so my renders can't show it either.

2. **A layer set to fill a column that hugs its width makes the column wider (picture 3–4, the reported bug).**
   - In Figma, "Frame 3" (heading, paragraph, button) hugs its width at 393, set by the 393-wide heading. The
     paragraph is set to fill.
   - In Figma a fill layer never widens a hugging box. In CSS it does: the column (`width: auto`) measures the
     paragraph (`width: 100%`) as one long line, about 1134px.
   - So the column takes about 1134px of the 1248 row, and the list (fill, `flex: 1 1 0`) gets about 18px and
     collapses.
   - The cause: `sizeStyle` in `src/core/style/sizing.ts` writes `width: "100%"` for every fill layer outside a row.

3. **A text drawn as wide as its wrapping row doesn't take a line ("Industries:" in "06 · Selected work").**
   - "Industries:" is a fixed 487-wide text in a 487-wide wrapping row, so Figma puts the pills below it, two per
     line.
   - `textWidth` gives a short label only `min-width: <its words>`. So it shrinks to about 70px, the first pill
     sits beside it, and every pill after it lands on its own line.
   - In a wrapping row, the box decides where lines break, not the words.

4. **A box drawn wider than its auto-layout column is squeezed to the column (the services slider in "04").**
   - "Frame 20" is 1440 wide, centred in a 1248 auto-layout column (hanging 96px past each side, to the section's
     edges). Its layers sit 96px in.
   - The build caps it at `max-width: 100%` = 1248, then insets its layers 96px, so they get 1056 instead of 1248.
     Photo, text and pills all come out about 20% narrower, and the pills stack.
   - `hangs()` (sizing.ts) already keeps a drawn overhang as a share of the column, but only for *inferred*
     columns (`f.inferred`). Figma lets a fixed layer run past a real auto-layout column the same way.

## Changes (all in `src/core/style/sizing.ts`, test first)

**Fix 2: fill inside a hugging column adds no width of its own.**

- In `sizeStyle`, when all of these hold:
  - `ir.sizing.w === "fill"`;
  - the parent flow is a `column`;
  - `ir.parent.sizing.w === "hug"`;
  - at least one other flowing sibling isn't fill (something else sets the hug width; otherwise keep today's
    output);
- write `width: 0` + `widthMin: "100%"` (Bricks' `_width` / `_widthMin` controls, no custom CSS).
  - This is the standard CSS trick: a width of 0 adds nothing to the column's size, and min-width 100% still fills
    it.
- If the layer has its own Figma min/max width (`n.limits.minW` / `maxW`), keep today's output, since min-width
  would beat its max width.
- Check while implementing: `emit` must keep a falsy `0` width. The test asserts `_width: "0"` in the payload.
- Update the header comment ("Fill grows…") to say why.

**Fix 3: a fixed text in a wrapping row keeps its box.**

- In the `ir.sizing.w === "fixed"` text branch: when the parent flow is a `row` with `wrap`, and the text's box is
  wider than its words by more than `SPARE` (or its words are unknown), write `{ width: px(w), widthMax: "100%" }`
  instead of `textWidth(n)`.
- Other texts keep `textWidth`.

**Fix 4: a box hangs past any column it's drawn wider than.**

- In `hangs()`, drop the `f.inferred` requirement. Any column flow, real or inferred, keeps an overhang as
  `pct(width, column)`.
- Bands and fill layers stay excluded.
- The existing rule `adapt/rules/unpin.ts` already resets hanging boxes to `max-width: 100%` at tablet_portrait, so
  tablets and phones are unchanged.
- Update the comment above `hangs()`.

## Tests (generic fixtures, no names, sizes or text from the user's file)

- Add the tests to `test/unit/style-layout.test.ts` (it already exercises `sizeStyle`), following its builders:
  - a hug column (fixed text + fill paragraph + button) in a row beside a fill box → the paragraph gets `width 0` /
    `min-width 100%`;
  - a hug column whose only flowing child is fill → unchanged;
  - a fill child with a max width → unchanged;
  - a wrapping row whose first child is a short fixed text as wide as the row → `width = box`, `max-width 100%`;
  - an auto-layout column holding a fixed box wider than it → `widthMax` is its share (e.g. "115.38%"), and
    `unpin` writes 100% at tablet_portrait.
- Add one browser-level check if `test/browser` has a fixture path for it (the hug-column case): the fill box keeps
  its drawn width at the design width.
- Prove each test catches its bug: copy the repo to the scratchpad, undo the fix there, and watch the test fail.

## Process

1. Back up the repo: `rsync -a --exclude node_modules --exclude corpus/out` to the scratchpad. Run `npm run corpus`
   before any change and record the numbers.
2. Fix 2, then 3, then 4, each test first. Run `npm run check` after each.
3. Update `test/unit/golden.test.ts` expectations only where the change is one of these three rules (diff it
   against the backup first).
4. Bump `BUILD` in `src/shared/build.ts` to `2026-10-08.7` (re-read it first).
5. Write a HANDOFF section "Desktop sizing fixes", and update the CLAUDE.md "Where things stand" line plus the
   Aswatama note.

## Verification

- `npm run check` passes.
- `npm run corpus`: no width worse than before. Watch overflow-x at 1024/1440, since a hanging box can reach the
  window edge.
- `npm run replay` + `npm run snap -- <debug> <out> 390,768,1024,1440 --sides` on the user's file:
  - "The alreadys": list beside the 393 column, rows not overlapping, same height as Figma.
  - "Selected work": "Industries:" on its own line, pills two per line.
  - "Services": slide 1248 wide, pills two per line.
  - 1440 lint: text-overlap and text-clipped drop from 14 and 4. Headings stay serif in my shots (no Aswatama
    here).
- Byte-identical replay twice in a row (deterministic ids).
- `diff -ruN` against the backup to review the change set.

## What the user does after

1. In Bricks → Custom Fonts, upload Aswatama, family name `Aswatama`.
2. Reload the plugin in Figma (build .7), Convert, and paste into an empty page.
3. If the headings are still serif after uploading the font, copy one Bricks element that uses Aswatama (picked in
   Bricks' font menu) and send it. That shows how Bricks names uploaded fonts in a paste, which is unverified today.
