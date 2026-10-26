# Brief: BUILDER for figma-to-bricks feature "cta-label-wrap"

Build the approved plan at `~/.hermes/plans/figma-to-bricks/cta-label-wrap.md`. Justin's answers: W1A W2A W3A (all recommended; W1A he confirmed himself). Commit after each passing task: the model connection has been dropping.

## In short
- The bug: button words ("CALL US", "Call Us Now") in narrow cards wrap onto 2-3 lines on tablets and phones, because `size.unpin` drops the button's floor to 0. Expected: a button label stays on one line, as in Figma.
- The fix is in the plan: the layout plan learns each box's least width (`adapt/least.ts`), cards stack before a button would wrap (W1A: one card per row at that size, no card left alone), and the label's floor only goes down to its one-line width.
- Generic logic only: no keying on names, words, sizes or colours. Build the generic fixture `test/fixtures/narrow-buttons.ts`.
- Found items this closes (mark each in `~/.hermes/plans/figma-to-bricks/found-else.md` at the merge, as `~~item~~ ✅ fixed in build <BUILD> (cta-label-wrap)`, or `⚠️ partly fixed` with what's left):
  - "Medium: Info card 'Call Us Now' button label wraps onto 2-3 lines at 768-480 (label gets _widthMin:tablet_portrait 0)."
  - "Medium (covered by cta-label-wrap W2A): the design file's pill buttons wrap at laptop widths (style/style.ts:193-196 drops a held label's floor below the design width)."

## State
- Main is `f3d6ed8`, build 2026-10-21.4. phone-side-padding has merged (the plan said to build after it), so take the corpus baseline fresh now.
- Paste checks 3aa–3af are taken. `frame-text-links` is building in parallel (normalise/text.ts, ui/site-*): no shared source files. Whoever merges second rebases, keeps both HANDOFF sections and takes the next free paste check number.
- `test-cleanup` waits until this merges.

## How
1. Load `skill_view('figma-to-bricks')` in the BUILDER role (Step 2 through Step 3, skipping item 6: the main chat runs the review). Read `references/rules-summary.md` first, then only the CLAUDE.md sections you need (adapt, layout plan, size.unpin, buttons). Never read the whole file.
2. Load `skill_view('test-driven-development')` and write a failing test before each change. On an unexpected failure or a worse corpus number, load `systematic-debugging`.
3. Use exactly the worktree `.claude/worktrees/cta-label-wrap` and the branch `worktree-cta-label-wrap`, from main `f3d6ed8` or newer.
4. Take before pictures from the untouched copy before the first code change (`npm run snap -- <file showing the bug> .superpowers/sdd/<plan>/shots/before --sides`), and after pictures after the last task. Copy the section pairs (tablet and phone widths) to `~/.hermes/plans/figma-to-bricks/shots/cta-label-wrap/` as `before-<section>.png` / `after-<section>.png`, and return the absolute paths in `shots[]`.
5. Copy the plan into `docs/plans/2026-10-21-cta-label-wrap.md`, and write the ledger and the HANDOFF section with the next free paste check.
6. Leave BUILD and CLAUDE.md alone; those are for the finisher.
7. You can't ask Justin anything. On a real trade-off, make the ruling and write it in HANDOFF as "My ruling, not yet confirmed". Put look-changing rulings in `rulings`.
8. If you find any other bug, don't fix it or fold it in: list it in `found_else` (one line each, evidence and severity).
9. Stop at ready-for-review: everything committed; `npm run check`, `npm run test:browser` (3 known stale panel failures) and `npm run corpus` no worse than the baseline; not merged, nothing pushed.
10. Kill any headless Chrome you started. If you run out of steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and the last commit.
11. Write the summary in plain words for a WhatsApp reader.
