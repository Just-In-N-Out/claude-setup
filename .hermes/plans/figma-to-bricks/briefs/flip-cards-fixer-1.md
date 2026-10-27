# FIXER 1 — flip-cards (FigmaToBricksV2)

Fix the valid findings of reviewer 1 on `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards`
(branch `worktree-flip-cards`, head 388191d, base main f46f8a2). The approved plan's read-only copy:
`~/.hermes/plans/figma-to-bricks/evidence/flip-cards/plan-approved.md`. The review with its probes:
`~/.hermes/plans/figma-to-bricks/evidence/flip-cards/reviewer-1/` (read its probes before fixing).

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review` (verify each finding before fixing;
push back with evidence on any you find invalid), `test-driven-development` (a failing test first for every fix),
`mutation-testing-discipline` (run any harness detached with a marker file naming the mutated file; a session restart
kills its process group), `git-commit-rules`.

## Findings to verify and fix (test first, one commit each)
- **F1 (medium):** with reduced motion a phone's first tap clicks the back's link (and opens a linked card). Add a
  reduced-motion variant of AC8 (plain and linked card); delay the instant swap under `prefers-reduced-motion: reduce`
  (reviewer's proven option: `transition: transform 0s linear 50ms` on the faces); let AC9's "no wait" allow ~100ms.
- **F2 (medium):** a hug-width card is sized by its back's words. The back adds no width (`width: 0; min-width: 100%`, the
  plugin's addsNoWidth idea); add a hug-width fixture to AC6 and AC12.
- **F3 (medium):** a flip card inside a linked wrapper nests an anchor in an anchor. Build the back linked when the card
  or any ancestor is a link; add AC10's case "a linked wrapper around flip cards: no anchor inside another". If small and
  general, also add a nested-anchor check to `payloadProblems` (the class-level guard; prove it on every corpus file and
  fixture, and that it passes on main's output); if not small, list it in found_else.
- **F4 (low):** a pill-shaped flip card gets cta-motion three times. My ruling for you to apply: `markCtas` skips the
  flip card, its front and its back as nodes (CTAs inside the back stay CTAs). Test it.
- **F5 (low):** the six surviving mutants: add one small unit test each (a text's own linked words in `focusable`; the
  showcase counting ruling; the zigzag run skip; which mark wins: instance, then main, then set; a fixed card height
  becoming a min height) and make emit-flip's `classId()` fail with a clear assertion when the class is missing. Re-run
  those six mutants and record each kill.
- **F6 (low):** `n.element = "block"` changes an element's type after it's made (CLAUDE.md architecture rule). Set the
  card's element when it is created, or keep the instance's; correct HANDOFF and README wording (the faces are Divs
  where emitted as div).
- **F7 (low):** the back keeps the variant's drawn height when the instance is drawn shorter: give the back root the
  instance's height where the variant is drawn at the main's size, or drop its min height; test it.

## Gates after the fixes
`npm run check` (0 fail); the flip browser file alone with `skipped 0`; the full browser suite compared by test name with
main's; G3 replays (hydraulics, GRO, debug-page-1, brainstorm) byte-identical to main; the corpus-skipped unit tests in
scratch git-archive trees (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
`export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Run gates in the foreground. Keep every changed file
under ~300 lines. Update HANDOFF, the ledger and the plan copy for any changed ruling.

## Rules
Commit to the branch (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump
BUILD, never edit the main folder, never bare `git stash`. photo-hotspots is being built on a branch based on your
388191d; don't touch its worktree.

## Report
Return `{name, status: ready-for-review|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, found_else[], skill_lessons[{skill, lesson, evidence}]}` and end with
`MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.
