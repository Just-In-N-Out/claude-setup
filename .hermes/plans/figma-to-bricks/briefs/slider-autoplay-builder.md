# BUILDER — slider-autoplay (FigmaToBricksV2)

Build the approved plan: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay/docs/plans/2026-10-26-slider-autoplay.md`
(read-only approved copy: `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`).
Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay`, branch `worktree-slider-autoplay`. Work only there.

## Approval
The plan is approved under the repo's standing auto-go (2026-10-26): every ⭐ answer and every proposed AC as written.
Don't re-plan. Commit the plan file with your first commit.

## The sample gate (from the plan)
Justin has been asked for the Bricks Slider (Nestable) sample (plan "Bricks sample needed"). Build Tasks 1–6 now
(everything before emit). Before Task 7, check whether `reference/bricks/slider-autoplay.json` exists in your worktree
or whether the orchestrator sent you the sample; if not, commit what passes and stop with `status: stopped`,
`stop_reason: waiting for the Bricks slider sample`, naming the last commit. Never write slider autoplay/arrow/fade keys
from the schema alone.

## Role and skills
BUILDER. Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/rules-summary.md`; it is not linked into ~/.claude/skills), `engineering-best-practices`,
`test-driven-development` (a failing test before each code change), `systematic-debugging` whenever a test fails
unexpectedly or a corpus number gets worse, `mutation-testing-discipline` for the recognition guards (AC4). Read only the
main-folder CLAUDE.md sections you need (your worktree has a snapshot copy; never edit it).

## Repo rules
Commit to the branch after each passing task (plain `git commit -m`, no Co-Authored-By/AI lines, no author override; check
`git diff --cached --name-only` has no CLAUDE.md). Never push, never bump BUILD, never edit the main folder, never use bare
`git stash`. Status notes go in docs/HANDOFF.md and the ledger `.superpowers/sdd/2026-10-26-slider-autoplay/progress.md`.

## Machine notes (Linux/WSL desktop)
- `npm run corpus` finds no files here (Mac paths): measure `corpus/files/hydraulics-home.json` and `gro-home.json` directly
  with replay/snap, and compare head with main (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` has the exact recipe).
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. A browser test run counts only when its output
  says `skipped 0`; compare the full browser suite by test name with main's (12 font-environment failures are known).
- Before/after pictures: take a "before" shot from the untouched worktree before your first code change and an "after"
  shot after the last task; return their paths in `shots[]`.

## Parallel work
flip-cards is being planned in its own worktree and will likely touch scene.ts, normalise.ts, ir.ts, understand.ts,
node.ts, elements.ts, style.ts, render.ts, builders.ts, the Bricks README and HANDOFF. Stay within this plan's files;
whoever merges second rebases and keeps both HANDOFF sections. Paste check id: 3bm (renumber at merge if taken).

## Rulings and reporting
You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in
`rulings[]` and in the HANDOFF section. If it can't be decided safely, stop with `status: stopped` and list the options.
If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`.
If you find any other bug or problem, don't fix it: list it in `found_else` (one line each, evidence, severity).
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]`
(an empty list is normal). Return
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], defect_loop_skills[], found_else[], skill_lessons[]}`
and end with `MAIN SESSION: check and save these skill_lessons now.`

## Update 2026-10-27: the sample gate is lifted
Justin: "Can't you tell the thing to go and search it up? Like search up how to do it?" Build tasks 7–9 from Bricks'
official slider-nested schema, Bricks Academy's docs and the live homev2 page's printed data-splide; archive them as
`reference/bricks/slider-autoplay-documented.json` with a README section saying documented, not copied; AC13 (live
paste/save/copy-back) is the proof of the keys; Justin's copy replaces the file when it arrives. Keep every AC test name
as approved; AC3 compares against the documented file meanwhile.
