# FIXER 2 — headline-marker (FigmaToBricksV2)

Fix the valid findings of reviewer 2 (verdict: request-changes) on
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker` (branch `worktree-headline-marker`, head
4d92fc8, base main f46f8a2). Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`.
Review, probes and mutants: `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-2/` (read probes/ and
logs/ first). The first fix pass: `evidence/headline-marker/fixer-1/` and HANDOFF's "Review fix pass 1".

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review` (verify each finding first; push
back with evidence on any invalid one), `test-driven-development`, `mutation-testing-discipline` (harness detached with a
marker file, or in scratch archive copies), `git-commit-rules`.

## Findings (test first, one commit each)
- **R2-F1 (high, a regression from b429b71):** a one-line left-aligned (or justified) heading starting with the marked
  words marks the whole line. Count a piece as under the stroke only when its estimated width is real (the reviewer's
  tried fix: `endOf(c) - c.x0 > 0.5 && covered(c) >= 0.5*(endOf(c) - c.x0)`). AC4 cases: left-aligned one-line heading
  whose styled words come first, short and long plain tail; one in the Chrome sweep.
- **R2-F2 (medium):** (a) a loose ring on a short one-line heading ("Over [forty years] now") marks the whole line; (b) a
  second, longer phrase in the circled words' style elsewhere makes them count as the text's own style. Take the own
  look from the uncovered pieces beside the covered run on its own line (fall back to the rest of the text only when the
  line has none); when every piece is covered, prefer pieces covered nearly whole (≥ 90%) whose look differs; mark the
  whole line only when the stroke spans `WHOLE` of it. Tests for both shapes. Keep the plan's Q4A single-style rule.
- **R2-F3 (medium):** marked words flush with a text's right (or left) edge: the ring's overhang (~24px) passes the 16px
  phone gutter, the page scrolls sideways at 390/375/360/320. Hold the mark's horizontal overhang within the gutter at
  the phone tiers through an `adapt/rules` rule (only adapt/rules writes breakpoint styles: one file, a `decision` line,
  reading sizes from PageFacts), or another architecture-clean way you prove. Add a right-aligned heading ending in its
  marked words to the AC9 sweep at 390, 375, 360 and 320 (scrollWidth ≤ the window).
- **R2-F4 (low):** the single-line height `min(box.height, 1.25×size)` leaked into hug boxes: use `box.height` when the
  text hugs its height (WIDTH_AND_HEIGHT or HEIGHT); keep the estimate only for fixed or filling boxes. Test a hug box
  with a tall-line font ratio.
- **R2-F5 (low):** a ring around a single short word or digit is refused as "much bigger": compare against
  `max(words.width, line height)`. Test.
- **R2-F6 (low):** hover variant trees never run `anchorMarks`, so a marked title in a hover-overlay card loses its ring on
  hover: anchor marks in the `look()` trees too (or, if not small, add a note); test.
- **R2-F7 (low, tests):** M4 (no fixture with the root away from the canvas origin: add one, e.g. (3000, −700)), M1 (R10's
  copy-words guard: FAQ question copies), M7 (leading space " forty years"), M17/M18 (stroke-opacity, the flip
  transform), and AC9's paint-order clause in Chrome (sample a pixel where a strike or tight ring crosses a glyph; a
  `z-index: 1` mutant must fail). Re-run the mutants, record each kill.
- R2-F8 (builders.ts at 397 lines): not now; record it in HANDOFF as a follow-up after the parallel features merge.

## Gates
`npm run check` (0 fail); the headline-marker browser file alone (`skipped 0`); the full browser suite by name against
main's; replays of hydraulics, GRO, page-1 (scratch copy) and brainstorm with bricks.json and warnings.txt byte-identical
to main; the corpus-skipped unit tests in scratch git-archive trees (memory `corpus-paths-on-desktop.md`).
`export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Long gates: log with `echo EXIT=$? >> log`, wait with
`until grep -q '^EXIT=' log; do sleep 2; done`. Source files under ~300 lines. Update HANDOFF, the plan copy and the
ledger for every changed ruling. Copy probes that prove something into your evidence folder at once.

## Rules
Commit (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump BUILD, never
edit the main folder, never bare `git stash`. Other features are in their own worktrees; don't touch them. Justin is
away: when unsure, take the recommended option and record it as "My ruling, not yet confirmed"; when you don't know how,
research it and implement your best rather than stopping.

## Report
Return `{name, status: ready-for-verify|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, ac_status[{ac, accepted, test, evidence}], found_else[], skill_lessons[{skill, lesson, evidence}]}`
and end with `MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.
