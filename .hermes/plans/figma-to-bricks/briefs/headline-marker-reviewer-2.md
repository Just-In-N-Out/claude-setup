# REVIEWER 2 (report only) — headline-marker (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-2/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`,
  head `4d92fc8`, base `main` (`f46f8a2`). The diff to review: `git diff main...HEAD`.
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`
  (paste check 3bo).
- This is the second, fresh review of the corrected code. A first review found 5 issues (a one-line text in a taller
  box squashing the mark; marks lost on stacked heading pieces; circled words holding most of a short heading counted as
  its own style; 8 untested guards; a mark widened to a whole link or phone number) plus a decode crash; a fixer fixed
  all of them (commits 7db699c, 019db96, b429b71, 2828ed4, 97dbeb7, da85fe0, 38a8f9b). Review the whole feature
  yourself, not only those fixes, and check the fixes broke nothing else.
- Rulings to judge (not yet confirmed by Justin): the builder's (a loop = closed, ends within 25% of the diagonal, or
  winds at least 270 degrees; a loose stroke marks only the styled words; lines one pitch apart from the first baseline;
  the drawing box carries reach plus weight; half arcs, multi-piece and dashed strokes stay still) and the fixer's
  (Figma's auto line height read as 1.25 x the size for one line in a taller box; the text's own style = the look with
  the most letters among the pieces the stroke covers less than half of, and a stroke covering every piece of a line in
  two or more looks marks the whole line; a mark on part of a link or phone number is drawn inside it; a mark on a
  Button label is dropped with a note). Shared fixture test/fixtures/builders.ts is 397 lines (285 on main): judge it.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, `mutation-testing-discipline`
for the recognition and anchoring guards. Read only the main-folder CLAUDE.md sections you need.

## What to check
- Correctness against the plan and every AC (AC1–AC12; AC13 is Justin's live check): does each test really prove its AC,
  fail on the base, and test the general case rather than one fixture?
- The repo's architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS
  until emit, only adapt/rules write breakpoint styles, deterministic ids, files under ~300 lines, Figma-sandbox-safe
  code in src/core (no URL/TextEncoder/DOM), no element naming another element's id in custom CSS.
- "Build general logic, never one-file fixes"; "Only Figma's animations"; nothing changes without the mark (corpus
  byte-identity).
- Bricks facts: `_alignSelf: stretch` never written; layout keys only on layout elements; Bricks caps every element at
  its parent's width (`[class*=brxe-]{max-width:100%}`); `.brxe-block` defaults to align-items:flex-start on the live
  site (the renderer lacks it).
- Reduced motion, the scroll and clock versions (M4b), Firefox without scroll timelines, links or phone numbers inside a marked span, the mark staying on its words at every width, and SVG/CSS that Bricks or WordPress might strip.
- Machine: Linux/WSL. `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. `npm run corpus` finds no files
  here (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
  Run gates in the foreground (a session restart kills background runs).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence}]}`. If you find any other problem outside this feature, list it in `found_else`
(don't fix it). If you learn something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills
or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
