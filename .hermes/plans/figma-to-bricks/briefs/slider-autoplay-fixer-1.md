# FIXER 1 — slider-autoplay (FigmaToBricksV2)

Fix the valid findings of reviewer 1 (verdict: request-changes) on
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay` (branch `worktree-slider-autoplay`, head
172e7f1, last source 040d0f5, base main f46f8a2). Approved plan (read-only):
`~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`. Review, probes and mutation harness:
`~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/reviewer-1/` (review.json, probe*.ts/log, mutants).

## Justin's answers (2026-10-27) — record them in the plan under "## Justin's answers (2026-10-27)" and in HANDOFF
- **Slide timing: "Full wait, as Figma".** Each slide stays still for the whole After delay: write
  `interval = delay + speed` (Splide counts interval from the start of the change). Pin it in AC2's test (keep its name).
- **Phone arrows: "Smaller arrows on phones".** Arrows stay on phones but shrink from mobile_landscape down (per-breakpoint
  keys only if the schema/documented evidence backs them; otherwise the element's own custom CSS on its own id). Make
  them as small as stays tappable and inset them so the ends of a full-width button are reachable where possible; prove
  with `elementFromPoint` 8px in from each end of the reviewer's probe5 button at 390 and 480. Record the size you pick
  as "My ruling, not yet confirmed".
- **Corner arrows: "Yes, recognise them".** Two opposite arrows drawn side by side in one corner (same place on every
  slide) become the slider's own arrows, like side arrows; extend `normalise/carousel-controls.ts` with generic tests
  (and the matching negative: two same-direction icons, one slide only).

## Findings (test first, one commit each)
- **F1 (high):** on tablets/phones Splide stretches every slide to the tallest, but each slide's band stays its own
  height, leaving a blank strip and misplacing drawn dots. Make the slide's one child fill the slide (flex-grow 1,
  keeping the drawn vertical alignment). Fixture option: one slide with longer words; browser check at 390 and 768 that
  each slide's first child is as tall as the slide.
- **F2 (medium):** arrow colour/size read from the matched layer's own paint and box: an icon frame around a vector
  gives white, a painted circle button gives its 20% backdrop, size 64. Read the colour from the arrow's drawing (its
  SVG stroke/fill, leaving out the backdrop, or the vector inside) and the size from the drawing's bounds. Add
  icon-frame and circle-button fixtures to AC6's test (AC6 isn't accepted until this holds).
- **F5 (medium):** paste check 3bm (HANDOFF) must also cover: a fade slider wrapping last → first (rewind), the left
  arrow pointing left on the live page, and an Instant slider (`speed "0"`). If you can, decide from evidence whether
  the previous arrow needs `prevArrow`/`nextArrow` (the user's carousel shape `{library: "ionicons", icon:
  "ion-ios-arrow-back"}` / `"ion-ios-arrow-forward"`); otherwise leave a clear step for Justin to send the copy back.
- **F6 (medium, tests):** surviving mutants K1 (the inner-cycle guard: main → A → B → A never returning; without it
  normalise loops forever: test this first), K2 (look-the-same), K3 (the slider's contact-link guard), K4 (click-only
  wired arrows), K6 (left-third arrow rule), K8 (dots on one line). One negative test each; re-run the reviewer's
  in-memory hook mutants and record each kill.
- **F7 (low):** AC3 compares against an example written into the documented file: also check every written key and
  its type against the saved schema copy until Justin's copy arrives (keep the test name).
- Reviewer notes to leave as limits in HANDOFF (no code): touch users have no pause control (WCAG 2.2.2, a question for
  Justin later); R1 reads Figma's 1ms After-delay chain idiom as 1s; render.ts is 323 lines (split it only if you touch
  it heavily).

## Gates
`npm run check` (0 fail); `test/browser/carousel.test.ts` alone with `skipped 0`; the full browser suite compared by name
with main's; AC5's five user files (hydraulics, GRO, Repairs, brainstorm, Services) with bricks.json and warnings
byte-identical to main; corpus-skipped unit tests in scratch git-archive trees (memory note
`corpus-paths-on-desktop.md`). `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Long gates: log with an
end marker (`echo EXIT=$? >> log`), wait with `until grep -q '^EXIT=' log; do sleep 2; done`. Files under ~300 lines.

## Rules
Commit to the branch (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump
BUILD, never edit the main folder, never bare `git stash`. Other features are in their own worktrees; don't touch them.
Mutation harness detached with a marker file, or in-memory hooks.

## Report
Return `{name, status: ready-for-review|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, ac_status[{ac, accepted, test, evidence}], found_else[], skill_lessons[{skill, lesson, evidence}]}`
and end with `MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.
