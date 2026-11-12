# Role: fixer (Full fix round 1, M1): bricks-icons — an Icon resizes both ways in Bricks (R1-1, R1-2)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/rendering-validation.md` inline-svg lines, `references/testing-pitfalls.md`). Read both `repeat-mistakes.md` files first.
Never load any live site; never write to any WordPress site. Figma's sandbox rules hold (built-ins only; no `import` followed by `(`/`//`/`/*`;
no `<!--`/`-->`). Commit to the branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.

## Findings (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/review-1/review.json`; probes `~/.cache/bir/s/`)
- **R1-1, P2, `src/core/style/icon.ts:16`:** every Icon in the flow carries `_widthMin: min(<drawn width>px, 100%)`, which beats the icon
  control's Width: a Width set below the drawn width shrinks the drawing but the box keeps the drawn width (24 px icon made 12×12 → box
  24×12, words beside it don't move; the picture it replaces becomes 12×12). AC5 says the box is the size its Width and Height give.
- **R1-2, P3 (take it: same AC), `src/core/style/icon.ts:19`:** where nothing sets an Icon's height, custom CSS `height: auto` prints after
  the icon control, so a Height typed alone does nothing (Repairs' "Oc arrow" Icons; Height 40 leaves 16×24.8).

Fix so the floor and the shape apply only while the person hasn't set the Icon's own Width/Height (e.g. put the floor and `aspect-ratio`
where the control's CSS out-weighs them, or write the drawn size into the control itself so the person edits that value) — whatever keeps
AC4 (nothing moves at paste, 0.5 px, six widths, renderer CSS and Bricks 2.3.9/2.4.2) and makes AC5 true both ways.

## Do
1. Your own worktree: `git checkout -B bricks-icons-fix1 dc625574a78e15d9deb76d9dd4d85688dd65b6e1`.
2. RED first: extend AC5's Chrome test (`test/browser/icon-elements.test.ts`, test name unchanged) — shrink an Icon (Width and Height below
   the drawn size; Height alone; Width alone) and compare with the same edit on the picture it replaced: box size equal, words beside it
   move the same, on Bricks 2.3.9 and 2.4.2 CSS. GREEN; AC4 still 0.5 px; mutants for each guard.
3. Gates: `npm run check` (8G scope), AC1–AC6 by name (AC3 story pin with `F2B_STORY_PINS=1`), the five replays with Icons off byte for
   byte main's. Record in the ledger and HANDOFF. Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bif/t1`); scripts under `~/.cache/bif/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time, each under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool; run each git command plain and alone in your own worktree. Use `tail -n 3`. Waits under 115 s.

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; gates; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
