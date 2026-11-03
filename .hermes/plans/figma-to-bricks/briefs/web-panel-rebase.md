# Finisher brief: web-panel (J4), rebase onto wave 1's merge head

**Role:** finisher (fresh Opus 5.5, xhigh). web-panel is accepted (`ac-check`: READY FOR THE USER, 16/17 on `845e601`,
AC16 live). It was built on wave 1's old combined head `89022ab`. Wave 1 is now rebased onto today's main as
`wave1-final` = `a2ae004dff5de3f1405bde34c7d93dc79e329403` (on main `b09727f`, Build 2026-11-02.3), and merges next.
Your job: put the panel's own commits on top of `a2ae004`, prove nothing changed but the base, run the quick gates,
and stop. Never stop to ask; decide and record.

**Skills:** load `git-commit-rules` and `engineering-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging" step 1, the re-rebase proofs) and
`references/testing-pitfalls.md`.

## Steps (in your agent worktree)

1. `git checkout --detach 845e60146f6d3434e96bf44f497f63a98202eb74`, `git switch -c web-panel-final`, then
   `git rebase --onto a2ae004dff5de3f1405bde34c7d93dc79e329403 89022abbef4e3584a93a68cd7118dea69aa93f2b web-panel-final`.
   Only the panel's commits move (the plan cherry-picks, Tasks 1–15, fixer 1).
2. **Conflicts:** keep both sides' meaning. HANDOFF: the panel's section first, then wave 1's and main's unchanged.
   Main's DJ Trees changes since wave 1's old base are in 43 files; list any file both sides changed.
3. **Proofs** (receipts in `~/.hermes/plans/figma-to-bricks/evidence/web-panel/rebase/`): patch-ids of the panel's
   commits before and after (`git show --full-index <c> | git patch-id --stable`; only conflicted commits may differ, with
   identical changed lines); `git diff 89022ab 845e601` equals `git diff a2ae004 <new head>` file by file, apart from
   HANDOFF context; `package.json` has each script key once; BUILD equals main's.
4. **Quick gates** on the new head, by test name against `a2ae004`: both typechecks, `npm run check`,
   `test/browser/panel-capture.test.ts` (skipped 0), and the AC5 byte-identity receipt (the builder's script in
   `evidence/web-panel/builder/`). The final checkers re-run the ACs on this head afterwards.
5. **Stop and report** the new head. Don't merge, push, bump `BUILD` or touch the main folder.

## Rules

- Plain `git commit -m`, no author override, no AI lines; no CLAUDE.md staged. Never bare `git stash`; leave every other
  branch and worktree alone (`wave1-final` is being checked by four other agents: never move it).
- Chrome: at most one Chrome job of your own at a time, closed after each step. Runaway memory: SIGTERM, exit 143/137
  or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun
  such a check under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wpanel-rebase/tmp`). Write
  multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; the bare word `source` in a
  command is refused.
- Never call alttext.ai or WordPress for real; never load bdryswi.com. Put any summary in your report.

## Report

The new head (full SHA), what the rebase did (conflicts, how resolved), the proofs, gate tallies by name, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
