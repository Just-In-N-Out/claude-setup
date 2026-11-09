# Role: verifier (read-only, round 2, rebased head): elementor-phone-fit

You are a fresh verifier who never saw the build or the reviews (Opus 5.5, high). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees (read
them with `git show`). **Never load bdryswi.com** or any live site; no logins; never write
to any WordPress site.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/plan-approved.md`
  (AC1–AC6 and its **Amendments** at the top: AC1's footer row at 1025 is a known exception, no worse than base; AC6
  live, Justin's: mark it `not_run`, owed).
- Head `e94e0311603a70ec35b9b6348cab52747dd97d23` (branch `elementor-phone-fit-final`, rebased); base (old code)
  `103cbb37800b5f4ea7c925e7899a1a1a652d47c5` (local `main`, Build 2026-11-09.1: capture-speed and site-motion merged). In your own worktree: `git checkout --detach e94e0311…`, confirm
  `git rev-parse HEAD` and a clean status. Old code: a tree from `git archive` of `103cbb37` with head's test files and new
  fixtures copied in.
- AC1 and AC5's B-Dry tests are named-only: read the tests for their variables. Main now writes capture code version 3: capture a fresh
  stand-in yourself from the saved 2026-10-29 files with this head's capture (about 7 min under an 8G `systemd-run`
  scope) and use it for head and base with the saved 2026-10-29 files the test names (paths in the builder's logs
  under `evidence/elementor-phone-fit/builder/`; use those logs only to find paths). Say it is a saved stand-in, not the
  live site.
- Don't read the builder's, finisher's or reviewers' reports as proof, nor the first round's `verifier-1-*`/`auditor-1-*`
  folders (their logs may only tell you where saved inputs are).
- Also run site-motion's AC11 named (`test/web/site-motion-bdry.test.ts`, both routes) on head: its Elementor still-frame
  row at 390 should now be within 2 px (it was 7.59 px on base).

## Work
1. Gates on head: both typechecks, `npm run check`, `npm run corpus` (same output as base; v1's three Mac files are
   missing on this machine), the **full** `npm run test:browser` and `npm run test:web`, file by file under the 4 GB cap,
   compared with base by test name (pre-existing failures are fine only if they also fail on base by name); AC10's five
   replays byte-identical to base; AC4's byte receipt your own (convert the saved stand-in and every fixture capture in one process on base and head, the plain route and the Elementor route).
2. Every AC's named test on head (must pass) and on old code (an AC about new behaviour must fail there; preservation ACs
   pass on both), each log starting `HEAD=` and ending `EXIT=`, skipped 0; a picture or terminal capture per AC (AC1/AC2:
   site | paste shots at 390 where the test writes them).
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/verifier/ac.json` and logs in that folder;
   self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy, as the
   reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ep-v2/tmp`);
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
