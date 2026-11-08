# Role: fixer (round 2: R2-1): site-motion

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). Fix review 2's P2 finding R2-1 test-first, then stop at
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
  head `13a336a00dc2162fe4884330311fe3f14a9aa5c4`, base local `main` `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (check
  `git rev-parse main`; if main moved, stop and report — don't rebase).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md` (AC4, AC7).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/review-2/review.json` (R2-1 P2; R2-2…R2-5 P3); Justin chose "Fix it, then merge" (`review-2/justin.json`).

## Work
1. **R2-1:** Bricks prints `data-interaction-hidden-on-load` only for a Start animation whose `animationType` contains
   "In" (`stripos`, `includes/interactions.php` `add_data_attributes`; Bricks 2.2 GPL source, check what
   `reference/bricks/` and the 2.3.9 front end hold). `motion.ts:69` uses the site's keyframes name as the type when it is
   a plain word, so an entrance named `rise`, `fadeUp`, `slideUp`, `reveal` or `appear` shows at rest, then jumps to its
   0% frame (opacity 0) when it plays: a flash on scroll and right after load. General rule: when the site's entrance
   starts hidden (its first frame or rest rule hides it), the Interaction's type contains "In" and is not an animate.css
   name (so animate.min.css never plays its own frames), and the site's keyframes still play by the class rule as now.
   Also make `test/browser/render.ts:167` print the mark only where Bricks' PHP does (type contains "In"). Test first: a
   unit case and a browser proof on the `site-motion` fixture with an entrance named without "In" (e.g. `fadeUp`, from
   opacity 0) that reads it hidden before it comes into view and never visible-then-hidden — RED on `13a336a0` with the
   renderer fixed, then GREEN; a renderer test that a non-"In" type gets no mark; mutate the guard.
2. Check R2-2…R2-5 are in `evidence/site-motion/follow-ups.md` and HANDOFF's site-motion "Deferred" list (add them to HANDOFF if missing).
3. Gates before stopping: both typechecks, `npm run check`, AC3–AC9 and AC12/AC15 tests, AC11 named on the saved captures
   the plan names, the replays and `npm run corpus` identical to main, `test:web` and `test:browser` file by file under the
   4 GB cap compared by name with the fixer 1's `evidence/site-motion/fixer-1/gates/` (rerun only differing files on
   main).
4. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/fixer-2/` (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-f2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` with a bounded `--test-timeout`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, base, last commit (full SHA), R2-1: verified?, the rule, fix, tests, RED/GREEN paths,
mutation, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
