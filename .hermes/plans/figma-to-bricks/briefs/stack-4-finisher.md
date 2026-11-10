# Finisher (step 1, in a copy): stack 4 — move staging-fit-renderer onto the new main

You are a fresh finisher (**Opus 5.5, high**). Three jobs have merged since this job was stacked: local `main` is now
`2879e4968438e7a442594d1021cb024dd85b3976` (Build 2026-11-10.3: site-faq, site-reviews and site-slider merged, each
with a build commit). staging-fit-renderer still sits on the **old** stack: branch `staging-fit-renderer-stack1-fix5`,
head `abf1271404d62df57118e90b1fa9b12d0b02a384`, whose base is `7d9754ed8adb5308bd525b309e7ba4672e284104` (the old
`site-slider-stack1-fix3`). Outside `docs/`, `git diff 7d9754ed 2879e496` is `src/shared/build.ts` only: the three jobs'
code under this one is unchanged; what moved is `docs/HANDOFF.md` (each merged job's section heading, paste-check line,
known limits and end-of-run entry now carry its build and id: 3dp, 3dq, 3dr), their plan files and ledgers.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-stack4 abf1271404d62df57118e90b1fa9b12d0b02a384` then
`git rebase --onto main 7d9754ed8adb5308bd525b309e7ba4672e284104` (check `git rev-parse main` = `2879e496…`; if main
moved again, use it and say so).

## Rules
- **A rebase with no conflict gets no new commit at all** (the branch stays a pure rebase; touch no file).
- **A rebase with a conflict:** keep both sides' meaning (HANDOFF: every section stays, this job's first, then main's
  lines exactly as main has them — the merged jobs' headings and end-of-run entries now read their builds and ids; this
  job's `<staging-fit-renderer id at merge>` / `<at merge>` placeholders stay). Resolve the same way in every commit of
  this job that touches HANDOFF (there are several: the build's, and one per fix round). Record each conflict and its
  resolution in this job's ledger (`docs/plans/2026-11-09-staging-fit-renderer-ledger.md`) as the branch's last commit,
  and say so plainly: a conflicted rebase is reviewed before the job is verified. A conflict outside `docs/` is not
  expected: if one appears, stop and report it exactly.
- Prove every patch unchanged: `git range-diff 7d9754ed..abf12714 2879e496..<new head before any ledger commit>`;
  patch-ids commit by commit (`git show --full-index <c> | git patch-id --stable`); for a context-only conflict the
  `-U0` patch-id of that commit; and `git diff -U0 abf12714 <new head before any ledger commit>` equal to
  `git diff -U0 7d9754ed 2879e496` after dropping `^(index |@@ )` lines (the new head is the old head plus exactly the
  base move).
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH
and symlink the main folder's `node_modules` in): both typechecks and `npm run check` (the parallel unit suite may need
an 8G scope). Stop and report if anything fails.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/stack-4/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.txt` or "none", `logs/`), scripts under `~/.cache/stk4/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Multi-step commands from a script file written with
Write. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`);
heavy runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA), "a pure rebase: every patch-id equal" or the conflicts and
resolutions commit by commit with the ledger commit, each gate's result; then `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
