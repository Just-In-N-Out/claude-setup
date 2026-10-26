# BUILDER — flip-cards (FigmaToBricksV2)

Build the approved plan: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards/docs/plans/2026-10-26-flip-cards.md`
(read-only approved copy: `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/plan-approved.md`).
Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards`, branch `worktree-flip-cards`. Work only there.

## Approval
The plan is approved under the repo's standing auto-go (2026-10-26): every ⭐ answer and every proposed AC as written.
Don't re-plan. Commit the plan file with your first commit.

## No sample gate
The plan needs no Bricks sample (its grid keys and `_attributes` are proven on the live site). Build every task.

## Role and skills
BUILDER. Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/rules-summary.md`; it is not linked into ~/.claude/skills), `engineering-best-practices`,
`test-driven-development` (a failing test before each code change), `systematic-debugging` whenever a test fails
unexpectedly or a corpus number gets worse, `mutation-testing-discipline` for the mark and recognition guards (AC2, AC3, AC11). Read only the
main-folder CLAUDE.md sections you need (your worktree has a snapshot copy; never edit it).

## Repo rules
Commit to the branch after each passing task (plain `git commit -m`, no Co-Authored-By/AI lines, no author override; check
`git diff --cached --name-only` has no CLAUDE.md). Never push, never bump BUILD, never edit the main folder, never use bare
`git stash`. Status notes go in docs/HANDOFF.md and the ledger `.superpowers/sdd/2026-10-26-flip-cards/progress.md`.

## Machine notes (Linux/WSL desktop)
- `npm run corpus` finds no files here (Mac paths): measure `corpus/files/hydraulics-home.json` and `gro-home.json` directly
  with replay/snap, and compare head with main (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` has the exact recipe).
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. A browser test run counts only when its output
  says `skipped 0`; compare the full browser suite by test name with main's (12 font-environment failures are known).
- Before/after pictures: take a "before" shot from the untouched worktree before your first code change and an "after"
  shot after the last task; return their paths in `shots[]`.

## Parallel work
slider-autoplay is being built now in its own worktree. Both features change normalise/scene.ts, normalise/normalise.ts,
understand/ir.ts, understand/understand.ts, understand/recognise.ts, style/style.ts (293 lines: keep it under 300),
emit/elements.ts, reference/bricks/README.md and docs/HANDOFF.md, each in a different place. Stay within this plan's
files; whoever merges second rebases and keeps both. Paste check id: the plan says 3bm, which slider-autoplay also took:
use 3bn.

## Rulings and reporting
You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in
`rulings[]` and in the HANDOFF section. If it can't be decided safely, stop with `status: stopped` and list the options.
If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`.
The plan's Figma mark (Q1 A: a Figma annotation "flip") is the approved trigger; the orchestrator relays any change Justin makes.
If you find any other bug or problem, don't fix it: list it in `found_else` (one line each, evidence, severity).
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]`
(an empty list is normal). Return
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], defect_loop_skills[], found_else[], skill_lessons[]}`
and end with `MAIN SESSION: check and save these skill_lessons now.`
