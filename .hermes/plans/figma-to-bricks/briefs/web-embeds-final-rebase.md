# Finisher brief: web-embeds (J5), last importer merge — rebase onto main's Build 2026-11-02.5

**Role:** finisher (fresh Opus 5.5, xhigh). Fast and exact. Never stop to ask; decide and record.

**Where things stand:** web-embeds is accepted (`ac-check` READY FOR THE USER, 11/13, AC12/AC13 live) on
`embeds-merge` = `3a39c11fe7e28a2bd893622e9c8c5016bf2a9fde`, stacked on `tiers-merge` = `2fd7a95ef4b7c7bacacddef6bf749a65fb032e25`.
Main has since fast-forwarded to `2fd7a95` and gained one build commit: main = `9212c477…` ("Build 2026-11-02.5": BUILD
bump, HANDOFF paste ids 3cx/3cy and their check-list entries, the panel/tiers/address ledgers moved from `.superpowers/` to
`docs/plans/`). Your job: move embeds' commits onto main, finish its records, prove only the base changed, and stop.

**Skills:** load `git-commit-rules` and `engineering-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging" step 1, its re-rebase proofs and the paste-id
and `.superpowers` lines).

## Steps (in your agent worktree)

1. `git rev-parse main` (expect `9212c477…`; if it moved, use the current main and say so). `git checkout --detach
   3a39c11fe7e28a2bd893622e9c8c5016bf2a9fde`, `git switch -c embeds-final`, `git rebase --onto <main> 2fd7a95ef4b7c7bacacddef6bf749a65fb032e25 embeds-final`.
   Expect only HANDOFF conflicts (embeds' section on top, main's sections unchanged).
2. Records, one commit: move embeds' ledger `.superpowers/sdd/2026-10-30-web-embeds/progress.md` to
   `docs/plans/2026-10-30-web-embeds-ledger.md` (`git ls-files .superpowers/` must be empty after); keep paste check **3cw**
   unless main's HANDOFF already uses it (then the next free id on main and every local branch; `worktree-dark-structure-recognition`
   also claims 3cw, unmerged); add 3cw's entry to the top of HANDOFF's "End-of-run check list" like 3cx/3cy.
3. Proofs (receipts in `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/final-rebase/`): patch-ids of embeds' commits before
   and after (`--full-index --stable`; only HANDOFF commits may differ, in context); embeds' own diff equal file by file apart
   from HANDOFF and the ledger move; BUILD equal to main's; `package.json` keys once each.
4. Gates on the new head by test name against main: both typechecks, `npm run check`, the five Figma replays byte-identical,
   `test/web/capture-embeds.test.ts` (skipped 0), and if main moved past `9212c477` with a change to `test/browser/render.ts`
   (the DJ Trees phone menu does that), the whole `test:web` file by file too.
5. Stop and report the new head (full SHA). Don't merge, push, bump BUILD or touch the main folder.

## Rules

- Plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged. Never bare `git stash`; leave every other
  branch and worktree alone.
- Chrome: one Chrome job of your own at a time, closed after each step; TMPDIR at most 38 characters (`~/.cache/wefr/tmp`).
  SIGTERM / 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Write multi-step scripts with Write and run `bash <file>`; git
  commands as separate plain calls; no redirects, dot-sourcing or the bare word `source` in a command.
- Never write to any WordPress site; never load bdryswi.com. Put any summary in your report.

## Report

The new head (full SHA), the rebase (conflicts), the records commit, the proofs, gate tallies by name, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
