# Brief: BUILDER (part 2, "Space gives way") for figma-to-bricks feature "label-floor" (Full pipeline)

Build the revised, approved plan's new tasks. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, HEAD b49d6f7; part 1 built AC1–AC8). Work only there; never edit the main folder.
- Plan: `docs/plans/2026-10-26-label-floor.md` (revised in place, uncommitted: commit it as your first commit, together with the ledger). The approved read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md` (AC1–AC15; AC9 live); if the two differ, the approved copy wins.
- Ledger: `.superpowers/sdd/2026-10-26-label-floor/progress.md`. It is untracked: commit it with every task (`ac-check.sh` fails on any untracked or uncommitted file). Leave the worktree clean at the end (no stray scratch: put scratch in the evidence folder).
- Evidence: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/` (part 1's files are there; add part 2's under `builder/part2/`), shots in `~/.hermes/plans/figma-to-bricks/shots/label-floor/` (prefix part 2's with `p2-`).

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, BUILDER role; `references/rules-summary.md`; only the worktree `CLAUDE.md` sections you need), `engineering-best-practices`, `test-driven-development` (a failing test before each change), `mutation-testing-discipline` (the give-way guards: which rows count as tight, the half-gap cap, the widen and last-resort steps), and `systematic-debugging` whenever a test fails unexpectedly or a number gets worse.

## Approved answers
Part 1: 1A 2A 3A 4A 5A. Justin's decision for part 2: **"Space gives way"** (in a row drawn exactly as wide as its items, the gaps give up what the labels grew, so the row keeps its drawn width and one line). The plan's new questions take their ⭐ by his standing auto-go: **6A** all gaps alike (one CSS gap), **7A** a gap shrinks to at most half its size on that screen, **8A** if the gaps can't give enough the row widens into the room beside it, else its words keep their drawn size (noted in the panel), **9A** GRO links outside tight rows are recorded for a follow-up, not fixed here.

Done means: Tasks 7–14 of the plan built test-first; AC1–AC8 still green; AC10–AC15 each proven by its named test (AC14/AC15 by the by-id diff and spill measurement main vs this build); `npm run check` green; browser tests green except the 12 known environment failures (same names); committed; worktree clean; status `ready-for-review`.

## This machine
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` (part 1's no-sudo setup). Browser baseline at main here: 349/362, 12 font-environment failures, names in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`: compare by name, not count.
- `npm run corpus` measures nothing here (Mac paths). Measure the five files directly (hydraulics-home, gro-home, Repairs = repo-root `figma-to-bricks-debug-page-1.json`, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) with replay/snap and part 1's scripts (`evidence/label-floor/corpus/diff-by-id.mjs`, `spill.ts`, `labels.ts` if the plan names it), against both main (cd9c1c9) and b49d6f7 as the plan's ACs say.
- Take part-2 before shots from b49d6f7 before your first code change (GRO nav at 1440/1300/1200, GRO hero at 1440/1300) and after shots after the last task. One test and one screenshot per AC (a terminal capture for a non-visual AC).

## A sibling copy is running
`worktree-faq-answer-space` (another session) touches `understand/accordion.ts` and HANDOFF and also names paste check **3bl**. Stay within this plan's files. Write this feature's paste check as the next free id after the ones in your HANDOFF and say in the ledger that it may need renumbering at merge.

## Rules
- Commit after each passing task: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; `git diff --cached --name-only` before each commit: CLAUDE.md never staged. Don't push, don't bump `BUILD`, don't edit the worktree's CLAUDE.md, never bare `git stash`.
- Stay within the plan's touched files; update only the existing tests the plan names, each named in the ledger with why. Any other failing test: stop and report.
- The plan's first part-2 task is a byte-identical move and a blast-radius survey that must find exactly GRO's three rows; if it finds others, record them and follow the plan's instruction for that case (stop if the plan says so).
- You can't ask Justin anything. On a real trade-off, make the ruling, written "My ruling, not yet confirmed" in `rulings[]` and the ledger. If it can't be decided safely, stop with `status: stopped` and the options.
- Low on steps: commit what passes, stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit.
- Other bugs: `found_else` (one line, evidence, severity); don't fix them. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]`; never edit skills or memory; an empty list is normal.
- Stop at `ready-for-review`: no merge, no BUILD, no main-folder edits.

## Return
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], ac_evidence[{ac, test, screenshot}], found_else[], defect_loop_skills[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
