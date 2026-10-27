# BUILDER — headline-marker (FigmaToBricksV2)

Build the approved plan: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker/docs/plans/2026-10-26-headline-marker.md`
(read-only approved copy: `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`).
Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`. Work only there.

## Approval
The plan is approved under the repo's standing auto-go (2026-10-26): every ⭐ answer and every proposed AC as written.
Don't re-plan. Commit the plan file with your first commit.

## No sample gate
The ⭐ path needs no Bricks sample (CSS only). The Figma Motion debug file in the plan's AC13 steps confirms the trim
units and where an ellipse's trim starts; it doesn't block the build (R5, R6 stay isolated in one function each).

## Role and skills
BUILDER. Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/rules-summary.md`; it is not linked into ~/.claude/skills), `engineering-best-practices`,
`test-driven-development` (a failing test before each code change), `systematic-debugging` whenever a test fails
unexpectedly or a corpus number gets worse, `mutation-testing-discipline` for the recognition and anchoring guards (AC1, AC3–AC5). Read only the
main-folder CLAUDE.md sections you need (your worktree has a snapshot copy; never edit it).

## Repo rules
Commit to the branch after each passing task (plain `git commit -m`, no Co-Authored-By/AI lines, no author override; check
`git diff --cached --name-only` has no CLAUDE.md). Never push, never bump BUILD, never edit the main folder, never use bare
`git stash`. Status notes go in docs/HANDOFF.md and the ledger `.superpowers/sdd/2026-10-26-headline-marker/progress.md`.

## Machine notes (Linux/WSL desktop)
- `npm run corpus` finds no files here (Mac paths): measure `corpus/files/hydraulics-home.json` and `gro-home.json` directly
  with replay/snap, and compare head with main (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` has the exact recipe).
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. A browser test run counts only when its output
  says `skipped 0`; compare the full browser suite by test name with main's (12 font-environment failures are known).
- Before/after pictures: take a "before" shot from the untouched worktree before your first code change and an "after"
  shot after the last task; return their paths in `shots[]`.

## Parallel work
slider-autoplay (paused for a Bricks sample) and flip-cards (in review) are on their own branches, and photo-hotspots is
being planned. Shared files, all additive: normalise/scene.ts, normalise/normalise.ts, style/style.ts (≈293 lines on
main; flip-cards brought it to 294: keep this feature's change to the one call the plan names), test/fixtures/builders.ts,
test/unit/sandbox-convert.test.ts, docs/HANDOFF.md. photo-hotspots may touch style/motion.ts or emit/motion.ts (your
Task 7). Stay within this plan's files; whoever merges later rebases and keeps both. Paste check id: 3bo.

## Rulings and reporting
You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in
`rulings[]` and in the HANDOFF section. If it can't be decided safely, stop with `status: stopped` and list the options.
If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`.
The approved trigger is Figma Motion's Trim path (Q1 A, no mark); the orchestrator relays any change Justin makes.
If you find any other bug or problem, don't fix it: list it in `found_else` (one line each, evidence, severity).
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]`
(an empty list is normal). Return
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], defect_loop_skills[], found_else[], skill_lessons[]}`
and end with `MAIN SESSION: check and save these skill_lessons now.`

Machine note: a Claude Code session restart kills background runs and empties the scratchpad: run gates in the foreground,
and run any mutation harness detached with a marker file naming the mutated file (mutation-testing-discipline).
