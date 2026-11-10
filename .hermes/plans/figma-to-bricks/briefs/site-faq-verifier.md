# Role: verifier (read-only): site-faq

You are a fresh verifier who never saw the build or the reviews (Fable 5.2, high). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees (read
them with `git show`). **Never load bdryswi.com** or any live site; no logins; never write
to any WordPress site.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/plan-approved.md`
  (AC1–AC8; AC8 live, Justin's: mark it `not_run`, owed). Find every cited test name with ac-check's own grep first; a
  name the plan wraps across lines goes through a by-name checker.
- Head `a4b74bcb87213a6403e9796b4bda9367c71b7723` (branch `site-faq-fix1`); base (old code)
  `fd1986dcdbc8cf35f114b80be456e94279346743` (local `main`, Build 2026-11-09.3). In your own worktree:
  `git checkout --detach a4b74bcb…`, confirm `git rev-parse HEAD` and a clean status (after a restart, restore tracked
  files of exactly 8388608 bytes). Old code: a tree from `git archive` of `fd1986dc` with head's test files and fixtures
  copied in (a hybrid tree if base only fails at import); logs on an archive start `HEAD=<sha> (archive)`.
- AC7 is named-only: `F2B_BDRY_CAPTURE_1109=/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (Justin's saved
  capture; an 8G scope; never the live site). AC6 (captures whose widths agree convert byte-identically; Figma replays
  and corpus unchanged): your own witness of base vs head (the fixers' script
  `evidence/site-faq/fixer-1/scripts/witness.ts` may be read to find its inputs, not its results), the five Figma
  replays byte-identical, `npm run corpus` the same as base (v1's Mac files are missing here).
- Don't read the builders', fixer's or reviewers' reports as proof.

## Work
1. Gates on head: both typechecks, `npm run check`, `npm run corpus` (same output as base; v1's three Mac files are
   missing on this machine), the **full** `npm run test:browser` and `npm run test:web`, file by file under the 4 GB cap,
   compared with base by test name (pre-existing failures are fine only if they also fail on base by name); the five
   replays byte-identical to base.
2. Every AC's named test on head (must pass) and on old code (an AC about new behaviour must fail there; preservation ACs
   pass on both), each log starting `HEAD=` and ending `EXIT=`, skipped 0; a picture or terminal capture per AC (AC4, AC5, AC7:
   the FAQ drawn at load and after a click; a terminal capture otherwise).
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/verifier/ac.json` and logs in that folder;
   self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy, as the
   reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfq-v/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too; close every Chrome you
  start (kill by its profile path if Node dies). The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
  Point `corpus.json` at the repo's copies as testing-pitfalls says. Run multi-step commands from a script file written
  with Write, paths spelled out.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry captures 8G). The
  PC loses power now and then (a failing UPS): keep scripts and logs under `~/.cache/sfq-v/`, never the `/tmp` scratchpad,
  and write each log's `EXIT=` line so finished runs count after a restart. Start long drivers with `setsid --fork`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; gates; `verdict`; `ac_status`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
