# Brief: BUILDER for figma-to-bricks feature "after-faq-sections" (Full pipeline)

Build the approved plan. Don't re-plan.

## Step 0: your copy is the worktree you start in (do this before anything else)
You were started in your own worktree (`isolation: worktree`, under `.claude/worktrees/agent-…`, on its own branch,
made from `main` at dea6296). **Build the whole job there.** Don't switch worktrees: an earlier builder's EnterWorktree
into the prepared copy `.claude/worktrees/after-faq-sections` was refused, so that copy is not used. Don't touch it.
1. Record `pwd`, `git branch --show-current` and `git rev-parse HEAD`; report them as `worktree`, `branch` and `base`.
2. If `CLAUDE.md` or `node_modules/` is missing, copy them from the main folder (read only there):
   `cp /home/justin/Documents/FigmaToBricksV2/CLAUDE.md <your worktree>/` and
   `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`. CLAUDE.md is excluded from git; never
   stage it.
3. Leave your worktree and branch in place when you finish: they hold the job's commits, and the next roles start
   from your `last_commit`.
If anything here is refused, change nothing more and stop: `status: stopped`, `stop_reason: "<the exact message>"`.
Never write in the `header-bar` worktree, the prepared `after-faq-sections` worktree or the main folder
`/home/justin/Documents/FigmaToBricksV2`.

## Where
- Plan: the approved, read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`
  (the planner couldn't write into the worktree; its working copy is
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/planner/2026-10-29-after-faq-sections.md`). Task 0
  catches up with local `main` (now `dea6296`, build 2026-10-29.1, headline-marker merged) with
  `git merge --ff-only main`, then copies the plan to `docs/plans/2026-10-29-after-faq-sections.md` and commits it as
  your first commit. If the two plan copies ever differ, the approved copy wins. Every base comparison is against the
  caught-up commit (`git merge-base HEAD main`).
- Evidence folder: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/builder/`. The planner's probes,
  captures and real-site measurements are in `../planner/`.
- The B-Dry paste goes where the plan says: `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/`. v3 and earlier
  stay untouched. Copy the two hand-over files to `C:\Users\Admin\Downloads` (`/mnt/c/Users/Admin/Downloads/`) only
  as Task B4 says, without overwriting any existing file.
- Ledger: `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md` in the worktree.
- Both live sites (`https://bdryswi.com/`, `https://bdry.staging.growithgro.com/`) are read only over HTTP with
  `?f2b=<random>`: never log in, never change anything.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the BUILDER
   role (its `references/rules-summary.md` first; only the worktree `CLAUDE.md` sections you need, via grep +
   offset/limit).
2. `engineering-best-practices` (Skill tool).
3. `test-driven-development` (Skill tool): a failing test before each code change.
4. `mutation-testing-discipline` (Skill tool) for the footer-stack guards (exactly one stacked frame found as the
   footer, never looking through a wrapper, full-width stacked parts, wordless parts going with the footer): prove each
   guard's test fails when the guard is removed.
5. `systematic-debugging` (Skill tool) whenever a test fails unexpectedly or a byte-identity or lint number changes
   where the plan says it mustn't: find the cause, don't patch around it.

## Approved answers (Justin's standing auto-go: every ⭐)
Q1 A (the plugin keeps page parts drawn inside a footer frame, in this job), Q2 A (Home only, under the FAQ, plus a
small paste of just the sections), Q3 A (the same Trustindex widget in one Code element), Q4 A (the quote button
turns orange under the pointer, as on bdryswi.com). The planner's "Rulings (mine, under the auto-go; to confirm)" stand
unless a test proves one wrong.

**Running beside this job:** `header-bar` (the B-Dry header bar) is being built right now in its own worktree. It
touches `understand/site-header.ts`, a new `understand/header-bar.ts`, `understand/understand.ts`, `understand/ir.ts`,
`style/style.ts`, and later `test/browser/render.ts`; its paste goes to `bdry-paste/header-v1/`. Don't touch any of
that. **Paste check numbers:** header-bar took **3bs**, so this job takes **3bt** (the plan says 3bs: use 3bt; if
header-bar's number changes at its merge, the finisher renumbers).

Done means: AC1–AC11 each proven by its named test or receipt, AC12 left for Justin (live), `npm run check` green, the
browser tests the plan adds green with `skipped 0`, the full browser suite compared by test name with the caught-up
base (no new failures), committed, status `ready-for-review`. One test and one screenshot per AC (a terminal capture of
the test run for an AC with nothing visual), listed in `ac_evidence[]`.

Justin's words: "After the FAQ there are the Contact Us and review forms, with the animations and everything. Our
plug-in didn't pull any of those, so we need to fix that." / "Whatever, just do it without the debug and figure it
out." / "Put it in another planner … then we'll give it to another builder and do the pipeline again. Full pipeline."

## This machine (Linux/WSL desktop): checks
- Follow the plan's Task 0. `npm run corpus` measures nothing here; don't count it. Never edit `corpus/corpus.json` in
  the worktree. Corpus-backed unit tests: scratch `git archive` trees of head and base with only `corpus.json`
  re-pointed and `node_modules` linked, compared by test name.
- Real files: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root
  `figma-to-bricks-debug-page-1.json` and `figma-to-bricks-debug-design-inspo-brainstorm.json`, plus Services
  (`git show 2199895:figma-to-bricks-debug-page-1.json` into the evidence folder, never the worktree).
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. If Chrome stalls (no animation frames,
  screenshot timeouts), use the CPU/CSS profile in memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; record the executable
  and flags in the ledger and use the same profile for base and head.
- Worktree guard: Bash is refused when it can't be proven to stay in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C` to another folder, the word git inside a grep pattern or a script's
  text, and the word `source` anywhere, even in a path: name folders `src-…` or `origin-…` instead). Write scratch
  scripts with the Write tool and run `node <absolute script> <absolute args>`, one plain command per call. Run long
  gates to a log ending in `echo EXIT=$? >> log` and wait on it in the foreground.
- Before shots from the untouched (caught-up) copy before your first code change, after shots after the last task;
  return their paths in `shots[]`.

## Rules
- Commit to the branch after each passing task: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or
  AI lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't
  bump `BUILD`. Don't edit the worktree's CLAUDE.md (status notes go in `docs/HANDOFF.md` and the ledger). Never bare
  `git stash`.
- Stay within the plan's touched files. If a test outside the plan contradicts the approved change, commit what passes
  and stop naming the exact assertion; never weaken it on your own. If AC7's ±6px can't be met by the renderer, stop
  and report rather than widening the tolerance (the plan's own risk line).
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
  checks; where it runs). An empty list is the normal answer. Say in `skill_lessons` whether building in the start-up worktree worked
  (CLAUDE.md and node_modules there or copied, commits kept).
- Don't start other agents. Stop at `ready-for-review`: no merge, no BUILD, no main-folder edits.

## Return (your final message)
`{name, status: ready-for-review|stopped, summary, base, branch, rulings[], steps_for_justin[], stop_reason,
worktree, last_commit, shots[], ac_evidence[{ac, test, screenshot}], chrome_env, found_else[], defect_loop_skills[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
