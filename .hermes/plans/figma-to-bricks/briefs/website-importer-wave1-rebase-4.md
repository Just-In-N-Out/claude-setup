# Finisher brief: website importer wave 1, rebase onto main 6cfd3e6 (after fix 2)

**Role:** finisher (fresh Opus 5.5, xhigh). Fast and exact. Never stop to ask; decide and record.

**Where things stand:** wave 1's line is branch `wave1-fix-2` = `38dc0ca01cddabc4ffbd1ec6bbc4060c91c14564`, built on main
`b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1` (wave1-final `a2ae004` + fix 1 `b6cd456..5b52fe7` + fix 2 `bb7f5aa..38dc0ca`).
Main is now `6cfd3e6681b7d0e121173ed746ab49206c672c4e` (Build 2026-11-02.4, DJ Trees; its 33 files touch none of
`src/web`, `test/web`, `test/browser/render*`/`chrome.ts`, `tools/capture*`/`site-compare`/`replay`, `src/core/snapshot`
or `package.json`). The DJ Trees session holds its merges until wave 1 merges. Your job: move the line onto
`6cfd3e6`, prove only the base changed, run the quick gates, and stop.

**Skills:** load `git-commit-rules` and `engineering-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging" step 1 and its re-rebase proofs).

## Steps (in your agent worktree)

1. `git checkout --detach 38dc0ca01cddabc4ffbd1ec6bbc4060c91c14564`, `git switch -c wave1-merge`, then
   `git rebase --onto 6cfd3e6681b7d0e121173ed746ab49206c672c4e b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1 wave1-merge`.
   Expect only HANDOFF conflicts: the wave-1 sections (compare, capture) go above main's sections, main's unchanged.
2. Proofs (receipts in `~/.hermes/plans/figma-to-bricks/evidence/website-importer-wave1/rebase4/`): patch-ids before and
   after (`git show --full-index <c> | git patch-id --stable`; only HANDOFF commits may differ, with identical changed
   lines); old head → new head equals `b09727f` → `6cfd3e6` file by file apart from HANDOFF context; tree composition
   (each path from main, from the line, or merged); `package.json` keys once each; BUILD equal to main's.
3. Quick gates on the new head, by test name against main `6cfd3e6`: both typechecks, `npm run check`, and the five
   Figma replays (hydraulics, GRO, Repairs, brainstorm, Services from `2199895`, plain and `--site`) byte-identical. The
   final checkers run the long suites.
4. Stop and report the new head (full SHA). Don't merge, push, bump BUILD or touch the main folder.

## Rules

- Plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged. Never bare `git stash`; leave every
  other branch and worktree alone.
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` short (`~/.cache/w1r4/tmp`).
  Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; the bare word
  `source` in a command is refused. SIGTERM / 143 / 137 may be an earlyoom kill
  (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Put any summary in your report.

## Report

The new head (full SHA), the rebase (conflicts, how resolved), the proofs, gate tallies by name, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
