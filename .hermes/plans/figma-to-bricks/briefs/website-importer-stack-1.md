# Finisher brief: website importer, stack the four accepted wave-2 jobs on wave 1's merge head

**Role:** finisher (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building … get this working and can see it."
Never stop to ask; decide and record.

**Where things stand:** wave 1's merge head is `wave1-merge` = `0f9e870be571a961f4b363f72069e0370324d378` (on main
`6cfd3e6`, Build 2026-11-02.4; its final checkers are running now, and it merges as soon as they accept). Four more
jobs are built, reviewed and checked, each on an older base. Your job: stack them on `0f9e870`, one on top of the next,
so each can fast-forward main in turn, and prove each step.

| Job | Branch (head) | Its base | New branch |
|---|---|---|---|
| web-panel (J4) | `web-panel-final` (`c2f6a160f533a8912727e8fcc4cc9ad5255708e7`) | `a2ae004dff5de3f1405bde34c7d93dc79e329403` | `panel-merge` on `0f9e870` |
| web-address | `web-address-build` (`71006122cd8396f3efd803efca9762ee0c7d675a`) | `c2f6a160…` (the panel head) | `address-merge` on `panel-merge` |
| web-tiers (J2) | `web-tiers-fix-2` (`9eb26ab8befc8b1314e7a9583ae742f7f2f61295`) | `89022abbef4e3584a93a68cd7118dea69aa93f2b` | `tiers-merge` on `address-merge` |
| web-embeds (J5) | `web-embeds-fix-2` (`78c0b9befd0957f861650b76bbf0fa7a03fc3dc9`) | `89022abbef4e3584a93a68cd7118dea69aa93f2b` | `embeds-merge` on `tiers-merge` |

`a2ae004` and `89022ab` are older copies of wave 1's own commits; `--onto` moves only each job's commits. Expect real
code conflicts: panel, tiers and embeds all touch `src/core/normalise/normalise.ts` and `scene.ts`; tiers and embeds
also share `src/core/style/style.ts`, `style/types.ts`, `understand/ir.ts`, `understand/understand.ts`; panel and
tiers share `understand/designs.ts`; panel and embeds share `src/core/snapshot/web.ts`. HANDOFF conflicts in every step.

**Skills:** load `git-commit-rules`, `engineering-best-practices` and `systematic-debugging`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging" step 1 and its re-rebase proofs) and
`references/testing-pitfalls.md`. Read each job's HANDOFF section before resolving its conflicts.

## Steps, one job at a time in the order above (in your agent worktree)

1. `git checkout --detach <job head>`, `git switch -c <new branch>`, `git rebase --onto <onto> <its base> <new branch>`.
2. **Conflicts:** keep both sides' meaning, field by field; never drop either side's rule, field or test. HANDOFF: the
   newer job's section first, then the others unchanged. After each conflicted commit, typecheck before continuing.
   List every conflicted hunk and how you resolved it (file, both sides' intent, the result) in your receipts: the final
   checkers review these.
3. **Proofs** per job (receipts in `~/.hermes/plans/figma-to-bricks/evidence/website-importer-stack-1/<job>/`): patch-ids
   before and after (`--full-index --stable`), non-conflicted commits identical; the job's own diff on the new base equals
   its old diff file by file apart from the resolved files (name them); `package.json` keys once each; BUILD equal to
   main's (`2026-11-02.4`).
4. **Quick gates** per job on its new head, by test name against the level below it (wave1-merge for panel, etc.): both
   typechecks, `npm run check`, the five Figma replays byte-identical, and the job's own AC test files (unit ones, plus
   its browser/web files: panel `test/browser/panel-capture.test.ts`; address `test/browser/panel-address.test.ts` and
   `test/web/helper-*.test.ts`; tiers `test/web/site-tiers-fixture.test.ts` and `-split`; embeds
   `test/web/capture-embeds.test.ts`). A failure the stack causes: fix it test first in the smallest way, commit on that
   job's branch, list it. Then the next job.
5. **Stop and report** the four new heads (full SHAs). Don't merge, push, bump BUILD or touch the main folder.

## Rules

- Plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged. Never bare `git stash`; never move
  `wave1-merge` or any job's original branch.
- Chrome: at most one Chrome job of your own at a time, closed after each step. TMPDIR at most 38 characters
  (`~/.cache/wstk/tmp`). Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill
  (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Write multi-step scripts with Write and run `bash <file>`;
  git commands as separate plain calls; no redirects or the bare word `source` in a command (refused).
- Never call alttext.ai or WordPress for real; never load bdryswi.com; live reads (GET only) only of the Hostinger site
  (`?f2b=`) and letsgro.ai. Put any summary in your report.

## Report

Per job: new branch and head (full SHA), conflicts and resolutions, proofs, gate tallies by name, any fix; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
