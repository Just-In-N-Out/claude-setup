# Finisher brief: web-embeds (J5), rebase 2 — onto main's Build 2026-11-03.1 (DJ Trees phone menu)

**Role:** finisher (fresh Opus 5.5, xhigh). Fast and exact. Never stop to ask; decide and record.

**Where things stand:** web-embeds is accepted on `embeds-final` = `c9ce2583e397993fa8bb7eafa4b919aaf0fa07ec` (a pure
rebase onto main `9212c477276f12ea4bb0453723619109ca9da4dc`; verifier clean, auditor accepted every AC but AC2, whose plan
text is being amended to match fix 2; the code doesn't change). Main has since moved to
`88a6aa49fb617bea4fe4257df9d3392e8bed14d8` (22 commits: the DJ Trees phone menu, Build 2026-11-03.1). It changes
`test/browser/render.ts` (a linked Image prints as Bricks does: `<a id class=brxe-image…><img>`), the render goldens and
`src/core` rules, so the importer's render-based checks can move. Your job: move embeds' commits onto main, keep its
records right, prove only the base changed, run the gates that the new base can affect, and stop.

**Skills:** load `git-commit-rules`, `engineering-best-practices` and `systematic-debugging`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging" step 1, its re-rebase proofs and the paste-id
and `.superpowers` lines) and `references/testing-pitfalls.md`.

## Steps (in your agent worktree)

1. `git rev-parse main` (expect `88a6aa49…`; if it moved, use the current main and say so). `git checkout --detach
   c9ce2583e397993fa8bb7eafa4b919aaf0fa07ec`, `git switch -c embeds-final-2`, `git rebase --onto <main>
   9212c477276f12ea4bb0453723619109ca9da4dc embeds-final-2`. Expect HANDOFF conflicts (embeds' section on top, main's
   sections unchanged) and maybe the end-of-run check list. Code conflicts: keep both sides' meaning field by field and
   list each hunk (file, both intents, the result) in your receipts.
2. Records: paste check **3cw** stays unless main's HANDOFF now uses it (`command grep -rn --exclude-dir=evidence 3cw` on
   main and on every local branch; `worktree-dark-structure-recognition` also claims 3cw, unmerged); if taken, the next free
   id everywhere, renamed in embeds' HANDOFF section and its check-list entry. `git ls-files .superpowers/` must be empty.
3. **The amended plan:** the main session will send you a message naming the amended plan file. When it arrives (before you
   report), copy that file over `docs/plans/2026-10-30-web-embeds.md` byte for byte and commit it alone as
   `web-embeds plan: amendment 1 (AC2's script rules match fix 2)`. If it hasn't arrived when your gates are done, report
   without it and say so.
4. Proofs (receipts in `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/final-rebase-2/`): patch-ids of embeds' commits
   before and after (`--full-index --stable`; only HANDOFF/records commits may differ, in context); embeds' own diff equal
   file by file apart from HANDOFF and resolved files (name them); BUILD equal to main's; `package.json` keys once each.
5. Gates on the new head, by test name against main `88a6aa49` (and against `c9ce258` for embeds' own tests): both
   typechecks, `npm run check`, the five Figma replays byte-identical to main's, the whole `test:web` file by file, and
   `test/web/capture-embeds.test.ts` (skipped 0). A failure the new base causes (a render change meeting an embeds
   expectation): find the root cause, fix it test first in the smallest way, commit, list it with its red/green. A
   failure that is the same on main is main's: record it, don't fix it.
6. Stop and report the new head (full SHA). Don't merge, push, bump BUILD or touch the main folder.

## Rules

- Plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged. Never bare `git stash`; leave every other
  branch and worktree alone (`embeds-final` stays at `c9ce258`).
- Chrome: one Chrome job of your own at a time, closed after each step; TMPDIR at most 38 characters (`~/.cache/wef2/tmp`).
  SIGTERM / 143 / 137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Write multi-step scripts with Write and run `bash <file>`; git
  commands as separate plain calls; no redirects, dot-sourcing or the bare word `source` in a command.
- Never write to any WordPress site; never load bdryswi.com; live reads (GET only) only of the Hostinger site (`?f2b=`) and
  letsgro.ai. Never call alttext.ai. Put any summary in your report.

## Report

The new head (full SHA), the rebase (conflicts), the records and plan commits, the proofs, gate tallies by name, any fix,
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
