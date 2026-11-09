# Role: fixer (round 5: R4-1 + plan amendment 4): site-motion

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high). Fix review 4's P2 R4-1 test-first, write the plan's
Amendment 4, then stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never
bare `git stash`, never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load any
live site; no logins; never write to any WordPress site. Nothing paid.

**Skills:** `receiving-code-review` (verify the finding first), `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Hover, focus and motion") and `references/rendering-validation.md`, the repo
`CLAUDE.md` and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-motion-fix5 325d1f8b9b045de9b7e50944c4aac640cdc7202c` (branch `site-motion-fix4`, on local `main`
`99ff06f46a53fe9f43cfa456e1d42a685bbc36c7`); confirm HEAD and a clean status (after a restart, restore tracked files of
exactly 8388608 bytes). Check `git rev-parse main` is still `99ff06f4` (if it moved, stop and report).

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md`.
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/review-4/review.json` (R4-1 P2; R4-2, R4-3 P3)
  and its probes `review-4/reduce-head.log`, `reduce-f39.log`, `.r4-reduce.test.ts`.

## Work
1. **R4-1:** since `a412b543` (F1) a drawing (svg, iframe or video pasted as a Code element) keeps its own finite entrance
   in its rules and plays it from load; under reduced motion the block writes only `animation-play-state: paused
   !important`, holding it on its first frame, so a drawing that fades in from opacity 0 never appears (AC7: every
   entrance at rest and visible under reduced motion). General rule: under reduced motion a finite animation left in an
   element's own rules is not paused on its first frame: `animation: none !important`, plus the held end frame
   (`heldStill`) for a forwards/both fill; endless animations keep today's paused rule. Test first: a unit case and a
   browser proof with Bricks' own script (the probe's iframe with `animation: fade 1.25s both`, reduce on: visible, opacity
   = the site's end) — RED on `325d1f8b`, then GREEN; normal motion unchanged. Mutate the guard.
2. **Plan Amendment 4 (R4-2):** bring the in-repo plan `docs/plans/2026-11-07-site-motion.md` to the approved copy's text
   (`plan-approved.md` = amendments 1–3), then add Amendment 4 in its Amendments list and mark the AC4 (and AC7 if needed)
   lines: a drawing (svg, iframe, video as a Code element) plays its finite animation from load with a note (Bricks'
   Interaction would need a box that moves the drawing; fixer 3's HANDOFF ruling 10), and under reduced motion shows its
   end frame at once. Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`'s
   amendment paragraph: no Amendments-list line starts with an AC id; run `ac-check.sh`'s `ac_start`, `bad_id` and `live`
   regexes on the old and new plan (ids, live set, cited test names unchanged). Say "main session to reinstall
   plan-approved.md from `git show <head>:docs/plans/2026-11-07-site-motion.md`".
3. Put R4-3 in HANDOFF's site-motion "Deferred" list (it's in `follow-ups.md`).
4. Gates: `npm run check`, AC3–AC7 tests (unit + browser `site-motion-proof`, `site-motion-flat`), AC11 named on the saved
   captures (paths in `evidence/site-motion/verifier/` logs), the five replays byte-identical to main, `test:web` and
   `test:browser` file by file under the 4 GB cap compared by name with fixer 4's `evidence/site-motion/fixer-4/gates/`
   and fixer 3's `fixer-3/gates/` (browser). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/fixer-5/` (logs `HEAD=` first, `EXIT=` last).
5. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-f5/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome you
  start. Run multi-step commands from a script file written with Write, paths spelled out.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), R4-1: verified?, the rule, fix, tests, RED/GREEN paths,
mutation, Amendment 4 text and regex check, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
