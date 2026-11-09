# Finisher (step 1, in a copy): elementor-phone-fit — ledger, commit, rebase onto main

You are a fresh finisher (Opus 5.5, high). Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare
`git stash`, never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load any live
site; no logins; never write to any WordPress site.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging", the `.superpowers` line) with
`references/testing-pitfalls.md`, and the repo `CLAUDE.md` "Finish" step 1.

## Your copy (you start in your own worktree)
`git checkout -B elementor-phone-fit-final dab961f9c30755b1890adc478ee9fdf3d5431516` (the accepted head of
`elementor-phone-fit-build`). The builder's ledger was never committed: copy it from
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-adf8cd7c93e808e50/.superpowers/sdd/2026-11-08-elementor-phone-fit/progress.md`
(read it by absolute path; don't write there) to `docs/plans/2026-11-08-elementor-phone-fit-ledger.md` in your copy.

## Steps
1. Commit the ledger (`elementor-phone-fit: the ledger`), then `git rebase main` (local `main` = `103cbb37…`, Build
   2026-11-09.1: capture-speed and site-motion merged; check `git rev-parse main`). Expected overlaps: site-motion adds a
   refusal in `foldable`'s first loop of `src/core/site/elementor-fold.ts` (~126) and changed `elementor-fold.ts`'s
   wrapper-look rule (AC15); rule 8 sits at the end of `foldable`; HANDOFF top sections. Keep both sides' meaning; record
   each conflict and resolution in the ledger (and commit that).
2. On the rebased head run: both typechecks, `npm run check`, `npm run corpus` (same as main; v1's Mac files are missing),
   `test/unit/site-elementor-fold.test.ts`, `test/web/site-elementor-pull.test.ts`, the elementor web tests and
   site-motion's `test/web/site-motion-proof.test.ts`, `test/browser/site-motion-flat.test.ts`; and the named B-Dry AC1
   test `test/web/site-elementor-page-bdry.test.ts` with a stand-in written by **this rebased head's** capture (main now
   writes capture code version 3: capture afresh from the saved 2026-10-29 files under an 8G scope, ~35 min, or check
   the test accepts v3 and reuse a v3 stand-in only if made by this same capture code). Also site-motion's AC11 named
   (`test/web/site-motion-bdry.test.ts`, both routes): its Elementor still-frame row at 390 should now be ≤ 2 px.
   Find the variables' paths in `~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/verifier/` and
   `evidence/site-motion/verifier/` logs. Stop and report if anything new fails.
3. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/finisher-1/` (logs `HEAD=` first,
   `EXIT=` last). Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached
   --name-only` without CLAUDE.md.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ep-f/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome you
  start. Run multi-step commands from a script file written with Write.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`) or a scope oom-kill (`journalctl --user`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G
  -p MemorySwapMax=0 <cmd>` (B-Dry captures 8G). `compare-corpus.test.ts` needs a 3600000 ms cap. Waits under 115 s.

## Report (as text)
Branch, the new HEAD (full SHA), the conflicts and resolutions, each test's result (AC1 rows; site-motion AC11's
Elementor row at 390), `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
