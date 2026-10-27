# REVIEWER 1 (report only) — headline-marker (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-1/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`,
  head `bb86429`, base `main` (`f46f8a2`). The diff to review: `git diff main...HEAD`.
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`
  (the plan says paste check 3bm; it was renumbered 3bn on purpose).
- Builder's rulings to judge (not yet confirmed by Justin): a card takes Tab focus itself whenever its back holds no
  link (even with an unlinked Button, which Bricks renders as a span); the turned selector is
  `:is(:hover, :focus, :has(> .flip-back:focus-within))` instead of the plan's `:has(> .flip-back :focus)`; AC6's
  "taller on phones" proven with two backs; a mark on a non-card layer (Button, text, picture, a whole section) is named
  and converts as without it, and a form on either face can't flip; showcase counting leaves flip cards out before the
  "two or more" count; recognise.ts judges hasText/hasFlowText by the front too.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, `mutation-testing-discipline`
for the mark and recognition guards. Read only the main-folder CLAUDE.md sections you need.

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
- Phones (tap), Tab, reduced motion, links on the back, Safari backface risk, nested anchors.
- Machine: Linux/WSL. `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. `npm run corpus` finds no files
  here (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
  Run gates in the foreground (a session restart kills background runs).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence}]}`. If you find any other problem outside this feature, list it in `found_else`
(don't fix it). If you learn something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills
or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
