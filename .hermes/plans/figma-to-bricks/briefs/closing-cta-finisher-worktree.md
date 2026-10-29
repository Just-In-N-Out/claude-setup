# FINISHER, step 1 (worktree only): closing-cta → section rhythm (FigmaToBricksV2)

Do exactly the pre-merge finish step, then stop.
- **Yours:** the worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta` on branch
  `worktree-closing-cta`, and your evidence folder `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/finisher-worktree/`.
- **Don't:** merge into main, bump `BUILD`, build or edit anything in the main folder, push, remove the worktree, edit
  skills or memory, or start other agents. Don't take, wait on or touch any main-folder release lock: this step works
  only in the worktree.

## Pins and inputs
- **Accepted candidate:** `3a4ecf72a3fa38ccaff76fbedda222fefc7de928`, clean. Original base: `5e2f98b` (build 2026-10-28.3).
- **Acceptance:** the orchestrator ran ac-check.sh on the fresh verifier's and blind auditor's reports. Its last line
  was `READY FOR THE USER: 11 of 12 ACs proven on 3a4ecf7; live ACs owed to the user: AC12`. This authorizes this
  finish step. AC12 (Justin's live paste check) is still owed.
- **Local `main` now:** `b3addfb` "Build 2026-10-28.4: photo-hotspots". Re-read it before rebasing. Rebase only onto
  coherent committed source; never onto a half-finished state or a git operation in progress.
- **Other sessions are working:** other worktrees (headline-marker and others) belong to them. Never touch their
  worktrees, evidence or processes.
- **Approved plan (read only):** `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`, AC1–AC12.
  Plan in git: `docs/plans/2026-10-28-closing-cta.md`. Ledger: `.superpowers/sdd/2026-10-28-closing-cta/progress.md`.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md`
   first (FINISHER role).
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `test-driven-development` before any integration code or test fix.
5. `systematic-debugging` if a gate fails unexpectedly.

Don't review your own work or redo the acceptance loop.

## Steps
1. **Check the state.** Confirm the worktree is clean at `3a4ecf7`, and check git state and what `main` holds now.
2. **Records, before the rebase.**
   - Move the ledger to `docs/plans/2026-10-28-closing-cta-ledger.md` (`git mv` if it's tracked, else move and add it).
   - Add a short "Verification" note to this feature's HANDOFF section, compact like its neighbours:
     - verifier and blind auditor both clean on `3a4ecf7`;
     - ac-check READY FOR THE USER, AC12 owed.
   - Add these follow-ups, found by the checkers, in plain words under the feature's open items:
     - **(a) Phones, a drawing beside the closing's buttons:** a drawing pinned beside the buttons at the design width
       lands on the full-width phone buttons from 478 down. On base it covers one button; on head (48 under the buttons
       instead of 64) it covers both. The J2 guard reads design-width and 992 geometry only.
     - **(b) Hills taller than the tablet step:** hills drawn taller than the bottom padding's tablet step land on
       the buttons at 1100–992 too, not only at 992. It's the same on base.
     - **(c) Home on small phones:** Home scrolls 7px sideways at 375–320 in the renderer, on base too.
     - **(d) A drawing with the default Top pin:** drawn along a section's bottom, it hangs up to 34px past it between
       1366 and 992 (base too).
     - **(e) An inset card's bottom-pinned drawing:** one taller than the card padding's tablet step lands on its
       buttons at 1024–992 (base too).
     - **(f) The hero's phone buttons band:** it keeps 24px under its buttons on phones (S + 24, base too, fits Q5 A).
     - **R2-F6 stays as recorded.**
   - Commit (plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines). Check
     `git diff --cached --name-only` first: CLAUDE.md and debug files must never be staged.
3. **`git rebase main`**, against local main only: no fetch, pull or origin. On a conflict, keep both sides' meaning:
   - both features' HANDOFF sections stay;
   - in shared source (`ir.ts`, understand, style, adapt rules, emit), merge both features' behaviour.
   Never blanket-pick ours or theirs, never force, never bare `git stash`, never reset main.
4. **The paste-check number.** The plan calls AC12's check **3bp**, but photo-hotspots (now in main) took 3bp. Once
   rebased, find the highest paste-check id in main's HANDOFF "End-of-run check list" and give this feature the next
   free one (likely 3bq). Do this in a separate commit, in HANDOFF and the plan in git, and add it to the end-of-run
   check list in the same style as its neighbours. The approved plan's copy in evidence stays as it is.
5. **Gates on the rebased branch.** Keep full logs ending in `EXIT=` and record every true exit.
   - `npm run check` in the worktree.
   - Corpus-backed unit tests in fresh scratch `git archive` trees of the new head and of `main`. In each tree,
     re-point `corpus.json` to local files, link `node_modules`, and put a scratch `bin/tsc` link to
     `node_modules/typescript/bin/tsc` first on PATH. Compare by test name.
   - The full browser suite on the new head and on `main`, compared by complete test name: no new failure, no lost
     test, no new skip. The known font-environment failures count only if they are identical on both.
   - `test/browser/section-rhythm.test.ts` alone (skipped 0).
   - Replays of the five real files at four tick settings (off, header, footer, both), new head vs `main`. Report which
     elements change. They should be exactly this feature's changes, as the plan's tables say, on top of main.
   - `npm run corpus` measures nothing here (Mac paths): say so; don't count it as a pass.
   - If an integration fix is needed, write the test first and commit it separately.
6. **Stop** with the worktree fully clean. Report the **new HEAD**, the base it now sits on, the conflicts and how you
   resolved them, the gates, the paste-check id, and any proposed edits to the main CLAUDE.md or the skill's
   rules-summary. Don't go on to main. If HEAD differs from `3a4ecf7`, the orchestrator runs a fresh verifier, blind
   auditor and ac-check on it before the merge.

## This machine
- **Chrome:** your own wrapper script containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH. Use the same wrapper on both sides.
- **Five real files:**
  - Home `corpus/files/hydraulics-home.json`
  - GRO `corpus/files/gro-home.json`
  - Repairs: repo-root `figma-to-bricks-debug-page-1.json`
  - brainstorm: `figma-to-bricks-debug-design-inspo-brainstorm.json`
  - Services: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/services.json` (never in the
    worktree)
- **Scratch:** your own fresh `finisher-worktree/` folder under the session scratchpad
  (`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-closing-cta/ecf5994f-8276-4f04-b9c6-a00ab4b226ac/scratchpad`).
  Never reuse another role's tree. Copy scratch scripts into your evidence `scripts/` as soon as you write them.
- **Leave alone:** a headless Chrome (PID 232915) from 03:10 isn't yours. Never kill browsers globally.
- **Worktree guard:** this session refuses Bash it can't prove stays in the worktree: shell variables or loops around
  `node`/`git`, a heredoc then node, the word git inside a grep pattern.
  - Write scripts with Write.
  - Run `node <absolute script> <absolute args>`, one plain command per call.
  - Send long gates to a log ending in `echo EXIT=$? >> log`.
- **Don't edit the worktree's CLAUDE.md.**

## Report (your final message)
`{status: ready-for-reverification|stopped, old_head, head, base, changes, conflicts, gates, paste_check_id, rulings,
live_acs, found_else[], proposed_claude_md_edits, skill_lessons[{skill, lesson, evidence}]}`. An empty skill_lessons
list is normal; never edit skills or memory. End with the line `MAIN SESSION: check and save these skill_lessons now.`
