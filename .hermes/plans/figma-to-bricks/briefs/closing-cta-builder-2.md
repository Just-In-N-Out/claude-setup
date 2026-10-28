# Brief: BUILDER (round 2) for figma-to-bricks feature "closing-cta" → section rhythm (Full pipeline)

Build the revised, approved plan. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta` (branch `worktree-closing-cta`, base 5e2f98b, head 9f88233). Work only there; never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Plan: `docs/plans/2026-10-28-closing-cta.md` in the worktree (revised, uncommitted: commit it first, in the plan's Task 3). The approved, read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`; if the two differ, the approved copy wins. (`plan-approved-v1-closing-only.md` beside it is the superseded first plan: history only.)
- Evidence folder: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/builder/` (round 1's base replays in `base/`, before shots in `shots/before` and `shots/before-off`, the paused Task 3 work in `task3-wip/`). The revising planner's model and probes: `../planner-revise/` (`rhythm-model.ts`, `model-<file>-<ticks>.txt`: your expected numbers).
- Ledger: `.superpowers/sdd/2026-10-28-closing-cta/progress.md` (continue it).

## State
Tasks 0–2 (Part 1, AC1–AC3: the space next to a left-out header/footer) are built, mutation-proved 8/8 and committed by round 1. Don't redo them; the plan's Task 3 only adds `uneven: true` to their fixture calls (no assertion or number changes). Continue with the plan's Tasks 3–8.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (BUILDER role; `references/rules-summary.md` first; only the worktree `CLAUDE.md` sections you need, via grep + offset/limit). Note its lines on `space.ramp` (≥ 40px values come from emit's clamp; a space split across two carriers steps differently) and on calls to action.
2. `engineering-best-practices` (Skill tool).
3. `test-driven-development` (Skill tool): a failing test before each code change.
4. `mutation-testing-discipline` (Skill tool) for the rhythm's guards (who votes for S, P/O/R edge kinds, tight/fixed/free/decorated/overlap exceptions, lines kept between touching painted bands): prove each guard's test fails when the guard is removed.
5. `systematic-debugging` (Skill tool) whenever a test fails unexpectedly or a number differs from the planner's model or the plan.

## Approved answers (Justin's standing auto-go: every ⭐)
Q1 A (one section space between two sections' words), Q2 A (S = the space most sections share), Q3 A (lines go, except between painted bands that touch), Q4 A (a painted section keeps its inside padding; S is outside), Q5 A (the first section keeps its own space), Q6 A (free-drawn pages and drawn phone designs stay as drawn). Planner rulings R1–R13 as written in the plan.

Justin's words: "Do it for every section, like in the photo. Make sure the spacing is good, including the gap between sections. Also apply it to every call-to-action button, not just the closing one." Earlier: "make them general changes for any other website"; the teammate's request: "Can we remove the line on the top, reduce the spacing on the top, and add more spacing below the buttons in this section?"

Done means: AC1–AC11 each proven by its named test or receipt, AC12 left for Justin (live), `npm run check` green, the new browser test(s) green with `skipped 0`, the full browser suite compared by test name with base 5e2f98b (no new failures), the golden `convert-sample.json` unchanged, receipts written, Docs & records task done, committed, status `ready-for-review`. One test and one screenshot per AC (a terminal capture for an AC with nothing visual), listed in `ac_evidence[]`. After shots of Home (ticked) at 1728/1440/990/768/390 with `--sides`, plus Services and Repairs at 1440/768/390, in `shots/after*`.

## This machine (Linux/WSL desktop)
- `npm run corpus` measures nothing here (Mac paths); don't count it. Never edit `corpus/corpus.json` in the worktree. Corpus-backed unit tests: scratch `git archive` trees of head and base with only `corpus.json` re-pointed and `node_modules` linked, compared by test name.
- Five real files: Home `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services `../planner-revise/services.json` (from git 2199895; never put it in the worktree).
- Chrome: the default profile stalled in round 1. Use the CPU/CSS wrapper round 1 used (a script in your own scratch: `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"`, as `CHROME_PATH`), with `/home/justin/.local/node-v22.23.3/bin` first on PATH. Same profile for base and head; record it in the ledger.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around `node`/`git`, heredoc then node, even the word git inside a grep pattern). Write scratch scripts with the Write tool and run `node <absolute script> <absolute args>`, one plain command per call. Long gates to a log ending in `echo EXIT=$? >> log`, then wait on it.

## Rules
- Commit to the branch after each passing task: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't bump `BUILD`. Don't edit the worktree's CLAUDE.md (status notes go in `docs/HANDOFF.md` and the ledger). Never bare `git stash`.
- Tests you may edit are only those the plan lists (Part 1's `uneven: true`; section top-padding pins in tests using `minFontPage`, `carouselPage`, `carouselContacts`, `stripPage`, each old → new in the ledger). The golden must not change. Any other failing test: commit what passes and stop naming the exact assertion; never weaken it on your own.
- Keep files under about 300 lines (`style/style.ts` may reach 300 as planned; anything more goes in a new file).
- If a real page's numbers differ from the planner's model (`model-*.txt`), find out why before going on; record it.
- You can't ask Justin anything. On a real trade-off, make the ruling and write it as "My ruling, not yet confirmed" in `rulings[]` and the ledger. Don't narrow the rule to make a number pass.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit and the next task.
- Other bugs: `found_else` (one line each, evidence, severity); don't fold them in. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]` only, never edit skills or memory; empty is normal.
- Don't start other agents. Stop at `ready-for-review`: no merge, no BUILD, no main-folder edits.

## Return (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], ac_evidence[{ac, test, screenshot}], chrome_env, real_page_changes[], found_else[], defect_loop_skills[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
