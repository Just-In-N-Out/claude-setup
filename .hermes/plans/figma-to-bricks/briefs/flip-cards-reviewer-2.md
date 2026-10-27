# REVIEWER 2 (report only) — flip-cards (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/reviewer-2/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards`, branch `worktree-flip-cards`,
  head `d84f038`, base `main` (`f46f8a2`). The diff to review: `git diff main...HEAD`.
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/plan-approved.md`
  (the plan says paste check 3bm; it was renumbered 3bn on purpose).
- This is the second, fresh review of the corrected code. A first review found 7 issues (reduced-motion tap, hug-width
  cards sized by the back, nested anchors in a linked wrapper, pill flip cards as CTAs, untested branches, an element
  type changed after creation, a shorter instance keeping the back's height); a fixer fixed all seven (commits 5bf4629,
  df3a9f6, ae3f83e, 19190a9, 97a9a18, 3aae0f1, 960bee2). Review the whole feature yourself, not only those fixes, and
  check the fixes didn't break anything else.
- Rulings to judge (not yet confirmed by Justin): builder's (a card takes Tab focus when its back holds no link; the
  turned selector `:is(:hover, :focus, :has(> .flip-back:focus-within))`; a mark on a non-card layer converts as without
  it; a form on either face can't flip; flip cards don't count toward a row of product cards) and fixer's (a card inside
  a linked wrapper gets no tabindex; a back drawn wider than its card holds no line on one line; the 50ms
  reduced-motion swap counts as "at once"; a nested link makes convert() refuse the whole paste via assertPayload; a back
  within 4px of its component's height fills the card).
- Pay particular attention to the new nested-link guard in `src/core/emit/payload.ts`: it refuses a whole paste. Is it
  right on every corpus file and fixture, and are there legitimate pastes (e.g. a Button inside a linked card made by
  other features, text links inside linked cards) it would now wrongly refuse? v1's three Mac corpus files aren't on
  this machine: say what still needs a Mac run.

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
