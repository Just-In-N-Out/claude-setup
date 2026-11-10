# Finisher (step 1, in a copy): stack 3 — move site-slider onto the new main

You are a fresh finisher (**Opus 5.5, high**). site-reviews has merged: local `main` is now
`f708dfb659049db50bb45df8026faabee2ee0ad7` (Build 2026-11-10.2), which is `cd13abf3` (the head site-slider was stacked
on) plus one build commit that touched only `src/shared/build.ts`, `docs/HANDOFF.md` (site-reviews' section heading,
its paste-check line, its known limits and its end-of-run entry), `docs/plans/2026-11-09-site-reviews.md` and
`docs/plans/2026-11-09-site-reviews-ledger.md`. Move the next stacked job onto it.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-slider-stack3 e85333559bd427a0dec83bd23d2ab2a85624d46a` then
`git rebase --onto main cd13abf38b5012df17ed7c12d075b98d9fbb4222` (check `git rev-parse main` = `f708dfb6…`; if main
moved again, use it and say so).

## Rules
- **A rebase with no conflict gets no new commit at all** (the branch stays a pure rebase; touch no file).
- **A rebase with a conflict:** keep both sides' meaning (HANDOFF: every section stays, this job's first, then main's
  lines exactly as main has them — main's site-reviews heading now reads "build 2026-11-10.2; paste check 3dq owed" and
  its end-of-run entry is "3dq."; this job's `<site-slider id at merge>` placeholders stay). Record the conflict and its
  resolution in this job's ledger (`docs/plans/2026-11-09-site-slider-ledger.md`) as the branch's last commit, and say
  so plainly: a conflicted rebase is reviewed before the job is verified.
- Prove every patch unchanged: `git range-diff cd13abf3..e8533355 f708dfb6..site-slider-stack3`; patch-ids commit by
  commit (`git show --full-index <c> | git patch-id --stable`); for a context-only conflict the `-U0` patch-id of that
  commit, and `git diff -U0 e8533355 <new head before any ledger commit>` equal to `git diff -U0 cd13abf3 f708dfb6`
  (the new head is the old head plus exactly main's build commit).
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head: both typechecks and `npm run check` (the parallel unit suite may need
an 8G scope; put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH in a scratch tree), and
`test/unit/site-slider-unchanged.test.ts` by itself (its sums were regenerated from the stack's base: it must still pass
on the new base). Stop and report if anything fails.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/stack-3/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.txt` or "none", `logs/`), scripts under `~/.cache/stk3/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Multi-step commands from a script file written with
Write. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`);
heavy runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA), "a pure rebase: every patch-id equal" or the conflicts and
resolutions file by file with the ledger commit, each gate's result; then `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
