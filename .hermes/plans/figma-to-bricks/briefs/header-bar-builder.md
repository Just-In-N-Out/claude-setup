# Brief: BUILDER for figma-to-bricks feature "header-bar" (Full pipeline)

Build the approved plan. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, made
  from local `main` at a3a008e). Work only there; never edit the main folder `/home/justin/Documents/FigmaToBricksV2`
  or another worktree.
- **Local `main` moved while the plan was written:** it is now `dea6296` (build 2026-10-29.1, headline-marker merged).
  First step, before Task 0: `git rebase main` in the worktree (the branch has no commits yet; the plan file is
  untracked), then commit the plan as your first commit. Everywhere the plan says base `a3a008e`, use the rebased base
  (`git merge-base HEAD main`, expected `dea6296`): byte-identity, lint and test-name comparisons are against it. If
  headline-marker's changes touch a file the plan touches, say so in the ledger and keep both sides' meaning.
- Plan: `docs/plans/2026-10-29-header-bar.md` in the worktree. The approved, read-only copy is
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`; if the two ever differ, the approved copy wins.
- Evidence folder: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/builder/` (shots, terminal captures, base/head
  replays, the receipts the plan names). The planner's probes and measurements are in `../planner/`.
- The B-Dry paste goes where the plan says: `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/`. Never
  change the Home pastes (v3 and earlier).
- Ledger: `.superpowers/sdd/2026-10-29-header-bar/progress.md` in the worktree.
- Both live sites (`https://bdryswi.com/`, `https://bdry.staging.growithgro.com/`) are read only over HTTP with
  `?f2b=<random>`: never log in, never change anything.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the BUILDER
   role (its `references/rules-summary.md` first; only the worktree `CLAUDE.md` sections you need, via grep +
   offset/limit).
2. `engineering-best-practices` (Skill tool).
3. `test-driven-development` (Skill tool): a failing test before each code change.
4. `mutation-testing-discipline` (Skill tool) for the header-recognition guards (`contactLine`, `action`,
   `logoThenActions` and the existing negatives) and the logo-link guard (its own Figma link wins, no nested links):
   prove each guard's test fails when the guard is removed.
5. `systematic-debugging` (Skill tool) whenever a test fails unexpectedly or a byte-identity or lint number changes
   where the plan says it mustn't: find the cause, don't patch around it.

## Approved answers (Justin's standing auto-go: every ⭐)
Q1 A (both: the plugin's header rules and a new B-Dry header paste), Q2 A (the menu panel slides in from the right,
like bdryswi.com; its Services list slides down), Q3 A (the menu is built against Justin's Offcanvas + Toggle sample;
it waits for the file), Q4 A (bdryswi.com's moving blue shimmer, still for reduced motion), Q5 A (the bar stays at the
top while the page scrolls), Q6 A (on screens wider than the design, the header bar's logo and buttons sit 64px in
from the window's edges), Q7 A (the plugin's own ☰ menu from a Figma overlay is a later job). The planner's "Rulings
(mine, under the auto-go; to confirm)" stand unless a test proves one wrong.

**The sample (Tasks 7–9, AC14):** Justin has the plan's 8 steps and will save the file as
`/mnt/c/Users/Admin/Downloads/offcanvas-toggle.json`. Check for it at the start and again before you finish. If it is
there, copy it into `reference/bricks/offcanvas-toggle.json` as Task 7 says and build Tasks 7–9. If it isn't, build
every other task, mark AC14 `waiting for the sample` in the ledger, and stop at `ready-for-review` with
`waiting: ["AC14: Offcanvas + Toggle sample"]`. Never write Offcanvas or Toggle keys from memory or from the docs (Q3 B
was not chosen).

**Running beside this job:** `after-faq-sections` (the three B-Dry sections missing after the FAQ) is being planned in
its own worktree. It may also touch `test/browser/render.ts` and the plugin's global classes. Don't touch its worktree.
This job takes paste check **3bs** (3br is headline-marker's); after-faq-sections takes the next free one.

Done means: AC1–AC15 each proven by its named test or receipt (AC14 may stay waiting for the sample as above), AC16
left for Justin (live), `npm run check` green, the browser tests the plan adds green with `skipped 0`, the full browser
suite compared by test name with the rebased base (no new failures), committed, status `ready-for-review`. One test
and one screenshot per AC (a terminal capture of the test run for an AC with nothing visual), listed in
`ac_evidence[]`.

Justin's words: "Take a look at the header. For instance, in the first photo you can see how the buttons are placed.
In the second photo is what our plug in gets from utilizing it. You can see a big difference. Also, on the top left,
when you click the logo it takes you back to the home screen. When you click on the phone number you can call them. On
the right side, for the sidebar, it slides down. We need to implement all of these." / "Whatever, just do it without
the debug and figure it out." (No debug file: the plan's root cause is an inference from the live sites.)

## This machine (Linux/WSL desktop): checks
- Follow the plan's Task 0. `npm run corpus` measures nothing here; don't count it. Never edit `corpus/corpus.json` in
  the worktree. Corpus-backed unit tests: scratch `git archive` trees of head and base with only `corpus.json`
  re-pointed and `node_modules` linked, compared by test name.
- Real files: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root
  `figma-to-bricks-debug-page-1.json` and `figma-to-bricks-debug-design-inspo-brainstorm.json`.
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. If Chrome stalls (no animation frames,
  screenshot timeouts), use the CPU/CSS profile in memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; record the executable
  and flags in the ledger and use the same profile for base and head.
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C` to another folder). Write scratch scripts with the Write tool and run
  `node <absolute script> <absolute args>`, one plain command per call, with paths spelled out. Run long gates to a log
  ending in `echo EXIT=$? >> log` and wait on it in the foreground.
- Before shots from the untouched (rebased) copy before your first code change, after shots after the last task;
  return their paths in `shots[]`.

## Rules
- Commit to the branch after each passing task: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or
  AI lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't
  bump `BUILD`. Don't edit the worktree's CLAUDE.md (status notes go in `docs/HANDOFF.md` and the ledger). Never bare
  `git stash`.
- Stay within the plan's touched files. If a test outside the plan contradicts the approved change, commit what passes
  and stop naming the exact assertion; never weaken it on your own.
- Keep files under about 300 lines (helpers go in new files, as the plan says).
- You can't ask Justin anything. On a real trade-off, make the ruling and write it as "My ruling, not yet confirmed"
  in `rulings[]` and in the ledger. Don't narrow a rule to make a number pass.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the
  last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence,
  severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong,
  missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence,
  enforce}]`. `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line
  proposal for a check that would have caught it (its kind: Claude Code hook, git hook, test, lint or script; what it
  checks; where it runs). An empty list is the normal answer.
- Don't start other agents. Stop at `ready-for-review`: no merge, no BUILD, no main-folder edits.

## Return (your final message)
`{name, status: ready-for-review|stopped, summary, base, rulings[], steps_for_justin[], waiting[], stop_reason,
worktree, last_commit, shots[], ac_evidence[{ac, test, screenshot}], chrome_env, found_else[], defect_loop_skills[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
