# REVIEWER 1 (report only) — photo-hotspots (FigmaToBricksV2)

You are a fresh, independent code reviewer. You did not build this. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/reviewer-1/`.

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`,
  head `b8ecf1b`, base `worktree-flip-cards` at `388191d` (this branch is built on flip-cards, which is in review). The diff to review: `git diff 388191d...HEAD`; compare replays and test runs with 388191d, not main.
- Approved plan (read-only copy): `~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`
  (paste check renumbered 3bo → 3bp on purpose).
- Builder's rulings to judge (not yet confirmed by Justin): a trigger with no words gets an aria-label (its card's first
  words) even when it is a link; a card's drawn height is a minimum only where Figma fixes its height; a trigger covering
  its whole box is pinned by share; a pulse mark on a layer with no element of its own gets its own note; a Scale-
  constrained trigger keeps its drawn px size; Figma's dimmed overlay background isn't drawn (named once); the note's
  wording; AC2 read as "as with the dots deleted" for a box with words. The builder also fixed beyond the plan: a Scale
  dot kept a share width (now its drawn width).

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; it isn't linked into ~/.claude/skills), `engineering-best-practices`,
`requesting-code-review` (its security scan and quality gates; skip its "independent reviewer subagent" and auto-fix
steps: you ARE the fresh reviewer, and you can't spawn agents), `code-review-practice`, `mutation-testing-discipline`
for the recognition guards. Read only the main-folder CLAUDE.md sections you need.

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
- Hover with the pointer crossing onto the card, Tab, phone taps (Chrome touch emulation via test/browser/chrome.ts), reduced motion, the card staying inside the photo and on screen, stacking (z-index 50) under ancestors that isolate, browsers without :has(), links inside cards, and anything Bricks might strip.
- Machine: Linux/WSL. `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. `npm run corpus` finds no files
  here (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
  Run gates in the foreground (a session restart kills background runs).

## Report
Return `{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity: critical|high|medium|low, file,
line, claim, evidence, suggested_fix}], ac_status[{ac, accepted, test, evidence}], rulings_assessment[], found_else[],
skill_lessons[{skill, lesson, evidence}]}`. If you find any other problem outside this feature, list it in `found_else`
(don't fix it). If you learn something reusable, list it in `skill_lessons` (an empty list is normal); never edit skills
or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
