# Role: fixer (round 2, Amendment 2): web-code-page

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). Build Amendment 2's tasks B1–B7 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com; no logins; never write to
any WordPress site.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (B5's mutants).
Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md`, and the repo `CLAUDE.md` ("Build general logic";
font weights in a paste are single whole hundreds).

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`, branch `web-code-page-build`,
  head `22833bb1` (the plan commit), base main `ea504778` (don't rebase).
- Plan (read-only copy): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`, Amendment 2:
  AC8's `npm run capture` finder (Task B1), AC20 bold and italic (B2–B5), gates (B6), docs (B7). ⭐ answers Q15 A, Q16 A
  (panel font uploads → follow-up), Q17 A taken under the standing auto-go. The planner proved its code in a scratch tree:
  `evidence/web-code-page/planner/amend2/` (`apply-plan.mjs`, proto logs; read, don't trust).
- The verifier's finding: `evidence/web-code-page/verifier/logs/finding-bold-head.log`, `verifier/finding-bold/`.

## Work
Each task: RED saved, then GREEN, commit after each (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md:
`git diff --cached --name-only` first). B6's gates in full: both typechecks, `npm run check`, `npm run corpus` (same as main;
v1's three Mac files are missing here), five replays byte-identical to main, `test:web` and `test:browser` file by file under
the 4 GB cap compared with main by test name, AC7/AC16/AC20, AC9/AC17/AC18 (named inputs as the plan says), AC10
(`F2B_CODE_PAGE_CAPTURE=/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`). Q16's follow-up goes to
`evidence/web-code-page/follow-ups.md` and HANDOFF "Deferred". Evidence in `evidence/web-code-page/fixer-2/` (logs start
`HEAD=`, end `EXIT=`). Note for later: elementor-map is being rebased onto `95097213` and will rebase again onto your head.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-f2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` except where a test needs it unset (B1). One Chrome job at a
  time. Never edit a script a background run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text)
Per task: test, RED/GREEN logs, commit; mutants; head SHA; gates; then `skill_lessons[{skill, lesson, evidence, enforce}]`
(empty is normal; never edit skills or memory), ending with `MAIN SESSION: check and save these skill_lessons now.`
