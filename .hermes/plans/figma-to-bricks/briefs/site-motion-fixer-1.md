# Role: fixer (round 1: R1-1): site-motion

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). Fix review 1's P2 finding R1-1 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com or any live site; no
logins; never write to any WordPress site. Nothing paid.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Hover, focus and motion") and `references/rendering-validation.md`, the repo
`CLAUDE.md` and `reference/bricks/README.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a40aae4db73069c4b`, branch `site-motion-build`,
  head `cfb0aa33745c64981b1b3139210e11ddaadc7082`, base local `main` `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (check
  `git rev-parse main`; if main moved, stop and report — don't rebase).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md` (AC4, AC7).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/review-1/review.json` (R1-1 P2; R1-2…R1-5 P3).

## Work
1. **R1-1:** an entrance whose rest rule hides the element (`opacity: 0`, or any end state the fill mode holds) with
   `animation-fill-mode: forwards`/`both` ends hidden in the paste, because Bricks 2.3.9 removes `brx-animate-<type>` (where
   `motion.ts` `bindingOf` puts the animation) at `animationend`; under reduced motion it is hidden from the start. General
   rule: once the entrance has played, the element keeps the animation's end frame as the site does (e.g. hold the last
   keyframe's values on `.c.brx-animated` when the fill mode is forwards/both), and under reduced motion it shows its end
   frame at once. Test first: a unit case and a browser proof on the `site-motion` fixture (add an element with
   `opacity:0; animation: <name> 1s forwards`) that reads the element visible after the entrance ends and visible under
   reduced motion — RED on `cfb0aa33`, then GREEN; mutate the guard.
2. Put R1-2…R1-5 in `evidence/site-motion/follow-ups.md` and HANDOFF's site-motion "Deferred" list.
3. Gates before stopping: both typechecks, `npm run check`, AC3–AC9 and AC12/AC15 tests, AC11 named on the saved captures
   the plan names, the replays and `npm run corpus` identical to main, `test:web` and `test:browser` file by file under the
   4 GB cap compared by name with the builder's `evidence/site-motion/builder/gates-rebased/` (rerun only differing files on
   main).
4. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/fixer-1/` (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-f/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` with a bounded `--test-timeout`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), R1-1: verified?, the rule, fix, tests, RED/GREEN paths,
mutation, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
