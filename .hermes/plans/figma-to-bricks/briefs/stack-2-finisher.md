# Finisher (step 1, in a copy): stack 2 — move site-reviews and site-slider onto the new main

You are a fresh finisher (**Opus 5.5, high**). site-faq has merged: local `main` is now
`e4355044c111c3c4c759e0ee50b22955534704dc` (Build 2026-11-10.1), which is `143a4e19` (the head site-reviews was stacked
on) plus one build commit that touched only `src/shared/build.ts`, `docs/HANDOFF.md` (site-faq's section heading, its
paste-check line, its known limits and its end-of-run entry) and `docs/plans/2026-11-09-site-faq-ledger.md`. Move the
next two stacked jobs onto it:

    main e4355044  ←  site-reviews  ←  site-slider

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree; both branches live there)
1. `git checkout -B site-reviews-stack2 dec9452cbf28b25709d44e829b86bc0c7e91837e` then
   `git rebase --onto main 143a4e19a6428e961c29a5f16f5cd715da91b7c1` (check `git rev-parse main` = `e4355044…`; if main
   moved again, use it and say so).
2. `git checkout -B site-slider-stack2 7d9754ed8adb5308bd525b309e7ba4672e284104` then
   `git rebase --onto site-reviews-stack2 dec9452cbf28b25709d44e829b86bc0c7e91837e`.

## Rules
- **A rebase with no conflict gets no new commit at all**: the branch must stay a pure rebase of its reviewed head
  (review 4 covers `dec9452c`; site-slider's `7d9754ed` is reviewed at its own turn), so the clean review still covers
  it. Don't add a ledger commit, don't touch any file.
- **A rebase with a conflict:** keep both sides' meaning (HANDOFF: every section stays, the newer job's first, then
  main's lines exactly as main has them — main's site-faq heading now reads "build 2026-11-10.1; paste check 3dp" and
  its end-of-run entry is "3dp."; each remaining job's `<… id at merge>` placeholders stay). Record the conflict and
  its resolution in that job's ledger (`docs/plans/2026-11-09-<job>-ledger.md`) as that branch's last commit, and say
  so plainly in your report: a conflicted rebase needs a fresh review before the job is verified.
- Confirm with `git range-diff` (for site-reviews: `143a4e19..dec9452c` against `e4355044..site-reviews-stack2`; for
  site-slider: `dec9452c..7d9754ed` against `site-reviews-stack2..site-slider-stack2`) and with patch-ids
  (`git show --full-index <c> | git patch-id --stable`, old against new, commit by commit) that every patch is
  unchanged; list any commit whose patch-id differs and why (context only, or a conflict).
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of each new head: both typechecks and `npm run check` (the parallel unit suite may need
an 8G scope; put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH in a scratch tree). Stop and report
if anything fails.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/stack-2/` and `evidence/site-slider/stack-2/`
(`range-diff.txt`, `patch-ids.txt`, `conflicts.txt` or "none", `logs/`), scripts under `~/.cache/stk2/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Multi-step commands from a script file written with
Write. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`);
heavy runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
Per job: branch, the new HEAD (full SHA), its base (full SHA), "a pure rebase: every patch-id equal" or the conflicts
and resolutions file by file with the ledger commit, each gate's result; then `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
