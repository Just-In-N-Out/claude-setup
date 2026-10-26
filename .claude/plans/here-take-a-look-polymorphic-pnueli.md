# Plan: faint outline around a picture frame drawn over a photo (photo-frame-outline)

## Context

**What Justin reported (screenshot, Hydraulic Cylinder Repairs hero):** the cylinder on the right sits in a box with a
thin, faint white outline and rounded corners. On the page it reads as a stray line cutting across the truck photo,
and it needs to go.

**What is true (checked):**
- The outline is in the Figma design, not a converter bug. Layer `div.prod` (588×588, radius 12) has a 1px INSIDE
  white stroke at 10% (`color/white-10`) and a radial yellow glow fill at 12%→0%. Figma's own render
  (debug file `renders`) shows the same outline. The paste writes it faithfully: element "Prod",
  `_border` 1px `rgba(255,255,255,0.1)` (`style/paint.ts` `boxPaint` ← `SceneNode.stroke` ← `normalise/paints.ts`
  `strokeOf`).
- It sits over the hero photo (`904d54f5…`, a CROP image + a white Saturation layer, under a 60–95% dark gradient).
- The same box style appears 11 times across Justin's files. Only this hero one sits on a photo. The others are on
  plain dark backgrounds: 5 Services row photos, 2 "Our Speciality" photos and 3 homepage Gallery photos.

**Justin chose (2026-10-22, "Only over a photo"):** as a rule for every design, a see-through box with a faint outline
around a picture loses the outline **only where it is drawn on top of a photo**. Boxes on plain backgrounds keep
theirs, as drawn. Filled cards and divider lines are untouched.

**Intended outcome:** the paste for such a box is exactly what it would be if the designer had deleted that stroke in
Figma. Every other paste (all five corpus files) stays byte-identical.

## Approach

One new normalise pass, run on each page's tree **right after `build()` and before `inferLayouts`**, so it sees
Figma's own paint order (children bottom → top), and every later stage (layout, padding, understand, style, adapt,
emit) sees the box as if the stroke had never been drawn. No later stage changes, and no CSS string matching.

### New file `src/core/normalise/photo-frames.ts` (~80 lines)

`leaveFaintFrames(root: SceneNode, warn)` walks the tree in pre-order (= paint order: a node's own paints, then its
children bottom to top). It keeps a running list of **covering candidates painted so far**, each with its shown rect
(its box ∩ the rects of the clipping frames around it). For each node it decides:

A box **loses its stroke** (`node.stroke = null`, plus one note) when all of these hold:
1. **Faint hairline:** `stroke.color.a × node.opacity ≤ FAINT (0.2)`, and every side's width ≤ `HAIRLINE (2)` px.
2. **See-through:** no fill stronger than faint (each solid's alpha, and each gradient's strongest stop, ≤ FAINT), no
   image fill, no background blur (a glass panel keeps its edge).
3. **A picture frame:** it holds a picture (a descendant of kind `image`, or with an image paint, or a video) and no
   text anywhere inside it. Glass cards with words keep their outline.
4. **On a photo:** among layers painted before it whose shown rect covers ≥ `COVER (0.9)` of its box, the **topmost**
   one that is either opaque (`opaquePaint` on a shown fill) or a photo decides, and it must be a photo. A photo is a
   `photoPaint` fill (image, opacity ≥ 0.5, not TILE) on a layer with opacity ≥ 0.5, or a layer that plays a video.
   An opaque panel between the photo and the box blocks it, while see-through tints (the hero's dark gradient) don't.
5. **No hover involved:** neither it nor any frame around it has a `hover`. Otherwise the hover variant's own stroke
   would come back as an outline on hover (`style/states.ts`), so it is kept, as a ruling.

Note text (deduplicated by `warn`): `"<name>": its faint outline is left out where it sits on the photo behind it`.

### Edits

- `src/core/normalise/paints.ts`: move `photoPaint` here from `understand/recognise.ts` (normalise can't import from
  understand). `recognise.ts` imports it from paints, and `understand/showcase.ts` updates its import.
- `src/core/normalise/normalise.ts`: in the per-root loop, `leaveFaintFrames(tree, warn)` between `build(...)` and
  `inferLayouts(...)`. The palette (`paletteOf`, which reads strokes) runs later, so a colour used only by a dropped
  outline isn't offered.
- Constants are named with a one-line reason each, matching the file's style. Keep the file under ~120 lines.

### Rulings to report to Justin (not yet confirmed by him)

- "Faint" means 20% opacity or less, "hairline" means 2px or less, and "on a photo" means the photo covers at least
  90% of the box.
- A video behind counts as a photo.
- A box with words, a background blur, a fill stronger than 20%, or a hover keeps its outline.
- The panel shows one note per box whose outline was left out.

## Tests (test-first, each seen failing before the code)

New generic fixture `test/fixtures/photo-frames.ts` (no names, sizes or colours from Justin's file):
`photoFramePage(opts)` builds a section with a full-bleed photo (`imageFill`), an optional dark see-through gradient
over it, and a grid holding a word column plus a see-through, rounded frame with a faint 1px stroke holding a picture.
Opts toggle each condition: `backdrop: "photo" | "solid" | "video"`, `strokeAlpha`, `strokeWeight`, `fillAlpha`,
`words`, `blur`, `panelBetween`, `cover` (photo smaller than the frame), `hover`, `photoOpacity`, `tiled`.

`test/unit/normalise-photo-frames.test.ts`:
- **The core invariant:** `convert(photoFramePage())`'s payload deep-equals `convert(same page with the frame's
  strokes: [])`'s payload, and its warnings add exactly the one note.
- The frame's element has no `_border` width or style, and keeps its radius and glow.
- **Kept, with the payload deep-equal to the input converted with the pass disabled:** a solid backdrop, an opaque
  panel between, words inside, a background blur, a 60% fill, a 50% stroke, a 3px stroke, a photo covering 80%, a
  hover (own and ancestor), a photo at 0.4 opacity, a tiled texture, a frame holding no picture.
- **Boundaries pinned:** alpha 0.2 dropped and 0.21 kept, width 2 dropped and 2.01 kept, cover 0.9 dropped and 0.89
  kept. Run mutation checks on each (flip `≤`/`<`, drop a condition) with `mutation-testing-discipline`. Every
  mutant must fail a test.
- A video backdrop: dropped.
- `payloadProblems(payload)` is `[]` for every variant.

Prove the tests catch the bug: with the fix committed, `git checkout HEAD~1 -- src/core/normalise` must turn them red,
then restore.

## Workflow (project CLAUDE.md "How each milestone runs" + global skill steps)

1. `EnterWorktree` name `photo-frame-outline` (branch `worktree-photo-frame-outline`). Check that `node_modules` and
   CLAUDE.md were copied, and `npm ci` only if missing. Skills: `engineering-best-practices`, `implementation-planning`
   (writes `docs/plans/2026-10-22-photo-frame-outline.md` from this plan), `test-driven-development`.
   Ledger: `.superpowers/sdd/photo-frame-outline/progress.md`.
2. `npm run corpus` baseline before Task 1. Keep `corpus/paste/*/bricks.json` copies in the scratchpad for byte
   comparison.
3. Task 1: move `photoPaint` (characterisation: `npm run check` green, corpus pastes identical). Task 2: fixture and
   failing tests. Task 3: `photo-frames.ts` and wiring until green. Commit after each passing task (plain
   `git commit -m`, no CLAUDE.md staged).
4. Close: `npm run check`, `npm run test:browser`, `npm run corpus`. All five corpus pastes must be byte-identical to
   the baseline, with the same lint and the same known v1 issues.
5. Justin's file: `npm run replay -- figma-to-bricks-debug-page-1.json <scratch>`, then diff against main's replay.
   The only differences allowed are "Prod"'s `_border` width and style (radius kept) and the one note.
   `npm run snap -- … 1728,1440,990,390 --sides`: look at the hero shots. No outline, and the glow, rounded box and
   cylinder are unchanged.
6. One fresh review subagent (opus) with `requesting-code-review` and `code-review-practice`, given the diff
   (`git diff main...HEAD`) and not my conclusions. Then `receiving-code-review`: verify each finding, fix valid ones
   test-first, rerun check, browser and corpus.
7. Finish per CLAUDE.md "Several agents at once":
   - `git rebase main`, then check and corpus again.
   - `ExitWorktree keep`, then `git merge --ff-only worktree-photo-frame-outline` in the main folder. Leave Justin's
     modified debug file untouched.
   - Read `BUILD` and bump it (expected `2026-10-22.10`), run `npm run build`, commit "Build <BUILD>:
     photo-frame-outline", then `git push` (main only).
   - Update the main CLAUDE.md ("Start here" and "Where things stand"). Add a HANDOFF section and allocate the next
     free paste check in "End-of-run check list".
   - Skills: `git-commit-rules`.

**Estimate:** 2–3 h total. That's about 1 h to build test-first, 30–40 min for the full checks, corpus and Justin's file,
and 45–60 min for review and fixes, plus merge, build and notes. Confidence medium. The review's findings are the
main unknown.

## Verification (end to end)

- `npm run check`, `npm run test:browser` and `npm run corpus` all pass, with all five corpus pastes byte-identical.
- Replay diff of Justin's Repairs file: only "Prod"'s border and one note change.
- Snap shots at 1728, 1440, 990 and 390 show the hero box without the outline.
- **Paste check owed by Justin** (one action at a time in the final message): reload the plugin in Figma, Convert the
  Hydraulic Cylinder Repairs page, paste into its Bricks page, then Cmd+S. Look at the hero: no outline around the
  cylinder, with the glow and box unchanged. The Remanufactured page's hero likely has the same box and would change
  the same way after a fresh Convert and paste. That is unverified, because its debug file isn't on disk.

## Not in scope

- The box's height or crop at laptop widths (worktree `cutout-square-box` owns picture sizing; no shared files).
- Faint outlines on filled cards, divider lines, or photo boxes on plain backgrounds (Justin's choice).
