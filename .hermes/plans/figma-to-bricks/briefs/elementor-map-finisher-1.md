# Role: finisher step 1 (rebase onto main): elementor-map

You are a fresh finisher for FigmaToBricksV2 (Opus 5.5, xhigh). elementor-map is accepted (`ac-check.sh`: READY FOR THE
USER 8/10 on `ea3d8817`, AC9/AC10 live) on base `4ba9a178`. That base is now merged into local `main`, which has one more
commit on top: `9b248818` "Build 2026-11-07.1 … (web-code-page)" (BUILD bump, HANDOFF records with paste check 3di, the
web-code-page ledger moved to `docs/plans/`). Rebase elementor-map onto `main` and stop. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. Never load bdryswi.com; no logins; never write to any WordPress site. Justin may be
running a capture in Chrome right now: don't touch any Chrome you didn't start.

**Skills:** `engineering-best-practices`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (Merging steps) with
`references/testing-pitfalls.md`, and the repo `CLAUDE.md` "Finish" step 1.

## Work (worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch `worktree-agent-a93c32bbf9bbc5ed4`)
1. Confirm HEAD = `ea3d8817ee61f25ffb671aeab64d9d84093a04c0` and a clean status, and `git rev-parse main` =
   `9b2488186cd3a83a3df0f5df3abd0d3c8ab8e96c`; else stop and report.
2. **Do not** commit anything before the rebase (the ledger move and the plan's AC7 amendment are done by the after-merge
   finisher in the main folder, so the rebased head stays a pure rebase of the reviewed one).
3. `git rebase main`. On a conflict keep both sides' meaning (HANDOFF sections both stay; elementor-map's section above
   web-code-page's; its end-of-run entry at the top of "End-of-run check list"; keep the build line as main has it).
   Record every conflict, the file and hunk, and how you resolved it. If a paste-check id clashes with 3di, keep the old
   id through the rebase and report it (the after-merge finisher renumbers).
4. Gates on the rebased head, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: `npm run check`,
   `npm run corpus` (same as before the rebase), `npm run test:web` and `npm run test:browser` file by file (compare
   failures by name with the pre-rebase head; this desktop's font failures are known). AC7 named test with
   `F2B_ELEMENTOR_STANDIN=/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/builder/ac7/standin-capture.json`
   (read the test for the exact variable) and web-code-page's `test/web/site-page-proof.test.ts`. Logs to
   `~/.hermes/plans/figma-to-bricks/evidence/elementor-map/finisher-1/`, each starting `HEAD=` and ending `EXIT=`.
5. Report whether the rebase was **pure** (no conflicts, no hand edits) and confirm with `git range-diff
   4ba9a178..ea3d8817 main..HEAD` (save its output in the evidence folder).

## Machine
- Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-f/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time.
- SIGTERM / 143 / 137 / "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text)
New HEAD SHA, pure or not (conflicts and resolutions), the range-diff summary, gates and AC reruns with log paths, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
