# Role: fixer (rebase onto web-code-page's reviewed head): elementor-map

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). elementor-map is accepted (ACs proven on `947922e1`) but is
built on an older commit of web-code-page (`fdcda54c`). web-code-page has since had review fixes and is now at `95097213`
(reviewed clean; its verifier is running, so it may still move). Rebase elementor-map onto it, so it merges cleanly on top,
and stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`,
never push or merge, don't bump `BUILD`, leave other worktrees alone (the web-code-page worktree
`agent-a631038f87d3d7d43` is read-only to you), start no agents. Never load bdryswi.com; no logins; never write to any
WordPress site.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch
  `worktree-agent-a93c32bbf9bbc5ed4`, head `947922e1`, old base `fdcda54c`. New base: `web-code-page-build` at
  `950972138ef0a4df8fe15a0346ab08c2637a664d` (same repo; `git rev-parse web-code-page-build` must equal it, else stop and report).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- What web-code-page's fixes changed (read its commits `59a3cd63..95097213`): the reset class is now named after its rules
  (`site-reset-pqgx`, `src/core/site/classes.ts` `versioned`); a site `p` that is a box pastes as a Div with the p's block
  margins (`kinds.ts` `boxLook`); svg parts carry their computed paint as attributes (`src/web/read/code-markup.ts`);
  HANDOFF and `docs/specs/web-capture.md` sections. Its fixer expects no textual conflicts, but
  `test/unit/site-elementor-widgets.test.ts` (and possibly fixtures) expect class names starting `"site-reset"`.

## Work
1. `git rebase --onto 95097213 fdcda54c` in the worktree. On a conflict keep both sides' meaning (HANDOFF sections both
   stay). Record each conflict and how you resolved it.
2. Run `npm run check`, `npm run test:web` and `npm run test:browser` file by file under the 4 GB cap. Where an
   elementor-map expectation is stale only because of web-code-page's fixes (the reset's name, a `p` box now a Div, svg paint
   attributes), update it in its own commit with a message naming the cause; never weaken what an AC asserts. Where the two
   features really interact (the fold meeting a `p` box Div, the accordion meeting the svg paint), prove it with a test and
   fix it test-first; report anything you can't settle.
3. Rerun AC5, AC6, AC7 (saved stand-in:
   `F2B_ELEMENTOR_STANDIN=/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/builder/ac7/standin-capture.json`,
   read the test for the exact variable), AC8 and `npm run corpus`; and web-code-page's AC7 (`test/web/site-page-proof.test.ts`)
   on the rebased head to show the two together keep it. Evidence in `evidence/elementor-map/rebase-1/` (logs start
   `HEAD=`, end `EXIT=`).
4. Commits: plain `git commit -m`, no author override, no AI lines, no CLAUDE.md (`git diff --cached --name-only` first).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-rb/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time. Never edit a script a
  background run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text)
New head SHA, the commit list since `95097213`, each conflict and resolution, each expectation changed and why, any real
interaction found and fixed (test, RED/GREEN, commit), gates and AC reruns, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
