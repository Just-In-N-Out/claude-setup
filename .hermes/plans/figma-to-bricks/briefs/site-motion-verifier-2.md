# Role: verifier (read-only, round 2): site-motion

You are a fresh verifier who never saw the build or the reviews (Opus 5.5, high). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees (read
them with `git show`). **Never load bdryswi.com** or any live site (AC14's tool is never run live); no logins; never write
to any WordPress site.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Hover, focus and motion") and `references/rendering-validation.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md`
  (AC1–AC15; read its **Amendments** section first (1–4); AC13 and AC14 live, Justin's: mark them `not_run`, owed).
- Head `325800747bb29432297dc841b3ad05eb8abdd2ce` (branch `site-motion-fix5`, rebased onto capture-speed); base (old code)
  `99ff06f46a53fe9f43cfa456e1d42a685bbc36c7` (local `main`, Build 2026-11-08.2). In your own worktree:
  `git checkout --detach 32580074…`, confirm `git rev-parse HEAD` and a clean status. Old code: a tree from `git archive`
  of `99ff06f4` with head's test files copied in (a hybrid tree if base only fails at import).
- AC9 (`F2B_SITE_MOTION_OLD`) and AC11 (`F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, `F2B_SITE_MOTION_STANDIN`) are
  named-only: read the tests and plan Tasks 0 and 13 for their variables; the saved inputs' paths are in the builder's and
  fixers' logs under `evidence/site-motion/` (use those logs only to find paths). Say they are saved captures/stand-ins,
  not the live site.
- Don't read the builder's, fixers' or reviewers' reports as proof, nor the first verifier's `ac.json` (its folder is
  moved to `verifier-1-85a1f2fe/`; its logs may only tell you where saved inputs are).
- capture-speed (now on main) also gets checked: its AC8 test is amended (counts per page state) and its named AC1
  differs from main only by site-motion's own capture fields (`/web/code/version`, `statesAt`, `keyframes`, `states`): say so.

## Work
1. Gates on head: both typechecks, `npm run check`, `npm run corpus` (same output as base; v1's three Mac files are
   missing on this machine), the **full** `npm run test:browser` and `npm run test:web`, file by file under the 4 GB cap,
   compared with base by test name (pre-existing failures are fine only if they also fail on base by name); AC10's five
   replays byte-identical to base.
2. Every AC's named test on head (must pass) and on old code (an AC about new behaviour must fail there; preservation ACs
   pass on both), each log starting `HEAD=` and ending `EXIT=`, skipped 0; a picture or terminal capture per AC (AC3–AC7:
   site | paste shots or frame readings where the test writes them).
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/verifier/ac.json` and logs in that folder;
   self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy, as the
   reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-v2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too; close every Chrome you
  start (kill by its profile path if Node dies). The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
  Point `corpus.json` at the repo's copies as testing-pitfalls says. Run multi-step commands from a script file written
  with Write, paths spelled out.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; gates; `verdict`; `ac_status`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
