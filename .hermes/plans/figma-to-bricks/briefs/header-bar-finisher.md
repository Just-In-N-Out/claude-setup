# FINISHER: header-bar, merge on Justin's "just merge" (FigmaToBricksV2)

Justin ended the review loop after review 8: he said **"just merge"**. No more fixes. Review 8's R8-1, R8-2 and R8-3 are
accepted known limits; the final verifier, auditor and ac-check are skipped at his word. You do the finish in two
phases. Don't start agents, don't merge into main yourself (the orchestrator does that between your phases), and
change no plugin source or test logic except to resolve rebase conflicts.

## Skills (load first, one line each)
The project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`, finisher role), `engineering-best-practices`, `git-commit-rules`.

## Records you need
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `4663e65`, base `dea6296`. Local `main` moved to `3ea33bb` (Build 2026-10-29.2: after-faq-sections, already pushed).
- Plan `docs/plans/2026-10-29-header-bar.md` (approved copy `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`;
  AC14 moved to the header-menu job; AC16 is the live paste check). Ledger `.superpowers/sdd/2026-10-29-header-bar/progress.md`.
- Justin's answers: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md` (read the last entry).
  Follow-ups and the accepted limits: `.../header-bar/follow-ups.md` ("review-8" section). Review 8:
  `.../header-bar/review-8/review.json`.

## Phase A: in the worktree (stop and report when done)
1. `git status` clean, HEAD 4663e65. Move the ledger to `docs/plans/2026-10-29-header-bar-ledger.md`.
2. `docs/HANDOFF.md`, header-bar's section only: add "Review 8 (accepted by Justin, \"just merge\")" with R8-1, R8-2 and
   R8-3 as known limits in plain words, R8-4's correction (an ungrouped call bar over a logo and its ☰: base's run is
   the call bar alone, so that header stays in the paste, head = base; the nav bar under a logo and its ☰ stays too)
   and R8-5's unpinned claims, and Justin's "Main header, as before" answer as a **follow-up job, not built**: a
   picture, four short items and a button right under a call bar should be the main header and leave with it (as base).
   Say the final verifier/auditor were skipped at Justin's word. Commit (plain `git commit -m "…"`, no AI lines, no
   author override; never stage CLAUDE.md).
3. `git rebase main`. On a conflict keep both sides' meaning (HANDOFF sections usually both stay; the after-faq-sections
   section and its 3bt entry must survive whole). Note every conflict and how you resolved it.
4. On the rebased head: `npm run check` (keep exit code and counts) and the header browser tests by name
   (`test/browser/header-bar.test.ts` and any header-paste test) with `CHROME_PATH` set to your own wrapper script
   containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"`,
   `/home/justin/.local/node-v22.23.3/bin` first on PATH; also replay the five real files (`corpus/files/hydraulics-home.json`,
   `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json` and
   `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via `git show 2199895:figma-to-bricks-debug-page-1.json`)
   with ticks off and header+footer on both `main` (3ea33bb, a `git archive` scratch tree) and the rebased head, and
   say which differ and why (header-bar's expected change: the header's logo links home). A failure caused by the two
   features meeting: stop and report it, don't patch around it.
5. Report Phase A: `{phase: "A", rebased_head, conflicts[], check, browser, replays, ledger, handoff}`. Then wait: the
   orchestrator fast-forwards main and sends you "Phase B".

## Phase B: in the main folder `/home/justin/Documents/FigmaToBricksV2` (only after the orchestrator's message)
1. Confirm main's HEAD is your rebased head, clean tree, no merge in flight.
2. Read `BUILD` in `src/shared/build.ts` right before changing it (now `2026-10-29.2`); set the next N for today
   (`date +%F`).
3. HANDOFF: header-bar's heading names the build; its live check (AC16) is in the "End-of-run check list" with
   Justin's steps from the plan, numbered one action each. The B-Dry staging site has no LiteSpeed cache: no Purge All
   step there.
4. `npm run build`; commit only `src/shared/build.ts` and `docs/HANDOFF.md`: `git commit -m "Build <BUILD>: header-bar"`
   (user.email must be issajustin04@gmail.com; no AI lines). `git push` (main only, the repo's own remote and helper,
   as Just-In-N-Out; never switch gh accounts, change the remote or helper, force, or push a feature branch).
5. Main folder `CLAUDE.md` (never committed; reread each section before editing): Status build line to the new build;
   one feature line ("header-bar: with the header tick on, a site's top bar (logo, phone line, button, ☰) is
   recognised as its header and left out, a call bar's nav bar with it; unticked, its logo links home, its phone
   number calls, and its row spans wide screens. Paste check <id> owed"); add the check to the paste-checks line;
   in "Known open bugs and limits" one line: "Header tick: a strip under a call bar that has a picture, four short items
   and a button is read by its words (two-word menus stay, one-word bands leave); Justin wants it read as the main
   header (follow-up)". If a write is refused, leave your lines in
   `~/.hermes/plans/figma-to-bricks/header-bar-claude-md-pending.md`.
6. Verify: release commit, BUILD in `dist/code.js`, `main` = `origin/main` after the push, clean status. Leave the
   worktree and branch in place.

Scratch: a fresh `header-bar-finisher/` under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-finisher/`. Evidence:
`~/.hermes/plans/figma-to-bricks/evidence/header-bar/finisher/`. No live website edits, clipboard changes or messages.

## Final return (after Phase B)
`{status: released|stopped, build, rebased_head, release_head, push, dist, docs, claude_md, rulings[], deferred[],
steps_for_justin[], skill_lessons[{skill, lesson, evidence, enforce}]}`. `rulings[]`: every header-bar ruling not yet
confirmed by Justin, in plain words. Empty skill_lessons is normal; never edit skills or memory. End each report with
`MAIN SESSION: check and save these skill_lessons now.`
