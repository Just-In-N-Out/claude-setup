# One-line words that wrap in Bricks (pill tags "SEALS & PACKING", "UP TO 10,000 PSI")

## Context

On the user's live Services page (`/services/`, Figma "Services Page Final", 1728 wide), the tags "SEALS & PACKING" and
"UP TO 10,000 PSI" break onto two lines inside their pills; Figma draws each on one line. "HONING" and "ALL BRANDS"
stay on one line. The user wants every text that Figma draws on one line to stay on one line. They want it built on a
branch off `main` and merged back.

**Root cause (reproduced in Chrome on the live page and in the project's renderer; the fix was verified there too):**
- The two-colour tags aren't Bricks Buttons, because a Button label needs one run (`understand/widgets.ts:18`). So each
  tag is a Div pill hugging a Text.
- `style/tracking.ts` `tracked()` gives every letter-spaced text `margin-right: -<spacing>em`. That cancels the space
  CSS adds after the last letter, so the text takes Figma's room in its row.
- Bricks caps every element at its parent's width (`[class*=brxe-]{max-width:100%}`).
- In a box that hugs the text, the negative margin makes the box 0.56px narrower than the words. Bricks' cap then
  holds the text to that width, so it breaks at a space. This happens at every window width and zoom.
  - Live page: text 93.92px wide, 43px tall (two lines).
  - Without the margin, or with the cap grown by the same 0.04em: 22px tall (one line).
  - In a box that really is too narrow, it still wraps, as it should.
- The Buttons are fine because their trailing spacing comes out of their right padding instead.
- The `white-space: nowrap` safety net (`style.ts` `holds`) only runs on designs ≤ 1440 (`SectionInfo.exact`) and only
  from the design width up. So a 1728 design never gets it, and smaller designs show the same bug below their width.
- HANDOFF "Bricks caps every element at its parent's width" (open) already lists this cause among the 18 corpus results
  worse than v1. It names a second cause that also wraps words: placed texts with Figma's Scale constraint drawn wider
  than their box. Final-design's service names get `width: 142.86%` (`place.ts` SCALE case), are capped to 100%, and
  wrap. Both are covered here.
- The other kinds the cap cuts back don't wrap words, so they stay open, as HANDOFF says (ask the user first): the map
  pin circle, placed layers wider than a phone's column, design's banner row.

## Approach

**Branch:** "make sure main is updated" is already true: every `worktree-*` branch is merged and `main` matches
`origin/main`. Load `EnterWorktree` (ToolSearch) and create the worktree `one-line` (branch `worktree-one-line`). Leave the
main folder's uncommitted `figma-to-bricks-debug-page-1.json` alone. Inside the copy, the committed debug file is the
Services page, which shows the bug.

**Milestone flow (CLAUDE.md "How each milestone runs", built straight through):**
1. Write the plan `docs/plans/2026-10-20-one-line-text.md` with `superpowers:writing-plans`.
2. Keep the ledger in `.superpowers/sdd/2026-10-20-one-line-text/progress.md`.
3. Run `npm run corpus` before Task 1.

### Task 1: the cap grows with the trailing spacing (`src/core/style/tracking.ts`)
- **Change in `tracked()`:** wherever a text gets the negative right margin, its max width gets the same room:
  - no `widthMax` → `calc(100% + <ls>em)`;
  - a string `widthMax` ("100%", a calc) → `add(widthMax, "<ls>em")` (reuse `add` from `place.ts`);
  - a numeric `widthMax` → unchanged (`round(+ls)`). The element's own px cap already overrides Bricks' cap.
- **Export a helper** `fullWidth(n: SceneNode): Len` from the same file: `"100%"`, or the grown cap for a tracked text.
- **Comment:** extend the file's header comment by one sentence: Bricks' cap would take that room back, so the cap grows
  by it too.
- **Tests first** (`test/unit/style.test.ts`):
  - Extend "a letter-spaced text takes Figma's room": "Work" and "4.1" get `calc(100% + …em)`; the paragraph keeps 301.
  - New test, a generic fixture: a wrapping row of hug pills (padding, 1px stroke, radius 999), each holding a two-run
    letter-spaced one-line text. Split the builder's segment in two colours. The text keeps its margin and gets
    `widthMax: calc(100% + 0.04em)`.
  - Emit check: `_widthMax` is written as given (`test/unit/emit-settings.test.ts`, if not already covered for calc
    strings).

### Task 2: tier rules keep the grown cap
- **Rules:** `adapt/rules/compose.ts:41` (texts on phones) and `adapt/rules/unpin.ts:69` (`hangs`, from tablets down)
  write `widthMax: "100%"`. On a tracked text that puts the bite back at that tier. Use `fullWidth(n.src)` there.
- **Tests first:** a rule test for each, on a tracked text: the tier's `_widthMax` is the calc.

### Task 3: a Scale-constrained placed layer wider than its box (`src/core/style/place.ts`, SCALE case)
- **Change:** when `w > parent.width`, also set `s.widthMax = s.width` (the same percentage). The plugin means it to be
  wider than its box, so Bricks' cap mustn't cut it back. This holds for every kind of layer, not just text.
- **Test first:** a unit test on `placeStyle` (Scale, 200 wide in a 140 box → width and widthMax "142.86%").

### Task 4: browser test (`test/browser/one-line.test.ts`)
- **What it renders:** the Task 1 pill fixture through `normalise → understand → styleAll → adapt → emitPayload →
  renderPage` (pattern: `test/browser/wide.test.ts`). The renderer copies Bricks' cap (`render.ts` BASE_CSS).
- **What it checks:** each pill's text is one line tall at 1440 and 1024, and at the design width.
- **Prove it catches the bug:** `git checkout HEAD~1 -- src/core/style/tracking.ts` makes it fail; then restore.

### Close
- **Corpus:** `npm run check`, then `npm run corpus`. Expect fewer of the 18 "worse than v1" results (the text overlaps
  and words-per-line from final-design, gro's nav and the hydraulics hover card), and nothing worse.
- **Services check:** replay git's Services file and confirm in Chrome that all four tags are 22px tall at 1728, 1440,
  1024 and 768. Use the scratchpad script pattern: `renderPage` + `getBoundingClientRect` on the tag texts.
- **Review:** one fresh opus review of `git diff main...HEAD`, then one fix pass, each fix test first.
- **Notes:** move the ledger to `docs/plans/2026-10-20-one-line-text-ledger.md`. Update HANDOFF:
  - a new section "One-line words that wrapped in Bricks";
  - in "Bricks caps every element…", the two word-wrapping kinds marked fixed and the rest still open.

### Merge back (CLAUDE.md "Finish")
1. Commit, then `git rebase main`. Run `npm run check` and `npm run corpus` again.
2. Call ExitWorktree with `keep`.
3. In the main folder, run `git merge --ff-only worktree-one-line`.
4. Read `BUILD` and bump it, likely to `2026-10-20.12`. Run `npm run build`, commit "Build 2026-10-20.12: one-line words
   stay on one line in Bricks", then `git push` (main only).
5. Update the main folder's CLAUDE.md ("Start here", "Where things stand", the open "Bricks caps" note).
6. Commit with a plain `git commit -m`: no AI lines, no author override, CLAUDE.md not staged.

## Critical files
- `src/core/style/tracking.ts` (the fix), `src/core/style/place.ts` (`add`, SCALE case)
- `src/core/adapt/rules/compose.ts`, `src/core/adapt/rules/unpin.ts`
- `test/unit/style.test.ts`, the rule tests, the new `test/browser/one-line.test.ts`
- `docs/HANDOFF.md`, `docs/plans/…`, the main folder's `CLAUDE.md`

## Verification
- `npm run check` and `npm run test:browser` pass, with the new browser test failing without the fix.
- `npm run corpus` is no worse anywhere, with fewer cap-caused results.
- Git's Services file: every tag is one line at every width in the renderer.
- **For the user, after the merge** (one step at a time): in Figma, reload the plugin, open Services Page Final, and
  Convert. Paste into the Services page and save. Run LiteSpeed → Purge All, then view the page.
