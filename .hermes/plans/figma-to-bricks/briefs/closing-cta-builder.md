# Brief: BUILDER for figma-to-bricks feature "closing-cta" (Full pipeline)

Build the approved plan. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta` (branch `worktree-closing-cta`, from local `main` at 5e2f98b, build 2026-10-28.3). Work only there; never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Plan: `docs/plans/2026-10-28-closing-cta.md` in the worktree (untracked: commit it first, as your first commit). The approved, read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`; if the two ever differ, the approved copy wins.
- Evidence folder: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/builder/` (shots, terminal captures, base/head replays, the receipts the plan names). The planner's probes are in `../planner/`.
- Ledger: `.superpowers/sdd/2026-10-28-closing-cta/progress.md` in the worktree.
- Reference hand-edit for AC9: `~/.hermes/plans/figma-to-bricks/evidence/home-paste-media/brands-spacing/All-Type-Home-Brands-Spacing.json` (receipt and edit script beside it). Read only.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the BUILDER role (its `references/rules-summary.md` first; only the worktree `CLAUDE.md` sections you need, via grep + offset/limit).
2. `engineering-best-practices` (Skill tool).
3. `test-driven-development` (Skill tool): a failing test before each code change.
4. `mutation-testing-discipline` (Skill tool) for the closing-CTA recogniser's guards (last section, no paint, content kinds, 1–3 CTAs, nothing placed) and the left-out-part gap guards: prove each guard's test fails when the guard is removed.
5. `systematic-debugging` (Skill tool) whenever a test fails unexpectedly or a lint/byte-identity number changes where the plan says it mustn't: find the cause, don't patch around it.

## Approved answers (Justin's standing auto-go: every ⭐)
Q1 A (the section above's own space, else the page's), Q2 A (same rule whether the footer is left out, kept, or not drawn), Q3 A (keep the space under a left-out header too), Q4 A (a line layer between them goes too). Justin chose earlier: "Closing CTA only" scope, "Page rhythm" spacing (120 / 84 / 64 on Home), Full pipeline.

Justin's words: "Lets do this." / "these are mostly general changes, right? She talks about the buttons and the divider, so make them general changes for any other website." The teammate's request: "Can we remove the line on the top, reduce the spacing on the top, and add more spacing below the buttons in this section?"

Done means: AC1–AC10 each proven by its named test or receipt, AC11 left for Justin (live), `npm run check` green, the browser tests the plan adds green with `skipped 0`, the full browser suite compared by test name with base 5e2f98b (no new failures), committed, status `ready-for-review`. One test and one screenshot per AC (a terminal capture of the test run for an AC with nothing visual), listed in `ac_evidence[]`.

## This machine (Linux/WSL desktop): checks
- Follow the plan's Task 0. `npm run corpus` measures nothing here; don't count it. Never edit `corpus/corpus.json` in the worktree. Corpus-backed unit tests: scratch `git archive` trees of head and base with only `corpus.json` re-pointed and `node_modules` linked, compared by test name.
- Five real files: Home (`corpus/files/hydraulics-home.json`), GRO (`corpus/files/gro-home.json`), Repairs (repo-root `figma-to-bricks-debug-page-1.json`), brainstorm (`figma-to-bricks-debug-design-inspo-brainstorm.json`) and Services (`git show 2199895:figma-to-bricks-debug-page-1.json` into the evidence folder, never the worktree).
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. If Chrome stalls (no animation frames, screenshot timeouts), use the CPU/CSS profile in memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` (a wrapper in your own scratch running `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"`, with `/home/justin/.local/node-v22.23.3/bin` first on PATH); record the executable and flags in the ledger and use the same profile for base and head.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around `node`/`git`, heredoc then node, even the word git inside a grep pattern). Write scratch scripts with the Write tool and run `node <absolute script> <absolute args>`, one plain command per call. Run long gates to a log ending in `echo EXIT=$? >> log` and wait on it.
- Before shots from the untouched copy before your first code change (`npm run snap -- corpus/files/hydraulics-home.json <evidence>/builder/shots/before --sides` with the footer ticked, plus 1728/1440/990/768/390), after shots after the last task; return paths in `shots[]`.

## Rules
- Commit to the branch after each passing task: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't bump `BUILD`. Don't edit the worktree's CLAUDE.md (status notes go in `docs/HANDOFF.md` and the ledger). Never bare `git stash`.
- Stay within the plan's touched files. If a test outside the plan contradicts the approved change, commit what passes and stop naming the exact assertion; never weaken it on your own.
- Keep files under about 300 lines (`style/style.ts` is at 299: helpers go in new files, as the plan says).
- You can't ask Justin anything. On a real trade-off, make the ruling and write it as "My ruling, not yet confirmed" in `rulings[]` and in the ledger. Don't narrow the rule to make a number pass.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.
- Don't start other agents. Stop at `ready-for-review`: no merge, no BUILD, no main-folder edits.

## Return (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], ac_evidence[{ac, test, screenshot}], chrome_env, found_else[], defect_loop_skills[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
