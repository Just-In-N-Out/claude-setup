# Role: verifier (read-only): site-slider

You are a fresh verifier who never saw the build or the reviews (**Opus 5.5, high**). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees (read
them with `git show`). **Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and saved files
only); no logins; never write to any WordPress site. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Site sliders") and `references/rendering-validation.md`.

## Inputs
- Approved plan (read-only; amended 1–11, the Amendments list is at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md` (AC1–AC10; AC10 live, Justin's:
  mark it `not_run`, owed). Find every cited test name with ac-check's own grep first (`command grep -E
  "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the runner prints with a prefix goes through a by-name
  checker citing a phrase that sits whole on one plan line. Judge each AC against the amended words.
- Head `8a13b71c46b26864e2b29ab08fae5f941c7b040e` (branch `site-slider-stack3`; the last commit is the ledger, code head
  `b24c5e4e`); base (old code) `f708dfb659049db50bb45df8026faabee2ee0ad7` (local `main`, Build 2026-11-10.2). In your
  own worktree: `git checkout --detach 8a13b71c46b26864e2b29ab08fae5f941c7b040e`, confirm `git rev-parse HEAD` and a
  clean status (after a restart, restore tracked files of exactly 8388608 bytes). Old code: a tree from `git archive`
  of `f708dfb6` with head's test files and fixtures copied in (a hybrid tree or a labelled stand-in if base only fails
  at import). An AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second line) and
  ends `EXIT=`, skipped 0; gate logs may start `HEAD=<sha> (archive)`.
- **AC9 (named-only, B-Dry):** per amendment 11 it reads a clean capture. Until Justin's re-capture exists that is the
  saved stand-in the plan names — `~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json`
  (sha256 `3c238957cea09ba6ac78027600d76eea53f29cd2981a85a3a9cdcbf774686dda`; the saved 2026-10-29 home served
  locally, not the live site; check the hash). `F2B_BDRY_BASE` and `F2B_BDRY_BASE_REPORT` must be remade from that same
  file with the base commit's code (`f708dfb6`): read the test for its variables. 8G scope. Record the file's sha256 in
  your evidence (the blind auditor uses the same file).
- AC8 (pastes without an Elementor slider are byte-identical): the named unit test compares against committed sums;
  back it with your own witness of base vs head (the saved captures converted by each tree in one process; the five
  Figma replays; `npm run corpus` the same as base — v1's Mac files are missing here).
- Don't read the builders', fixers' or reviewers' reports as proof.

## Work
1. Gates on head: both typechecks, `npm run check`, `npm run corpus` (same output as base), the **full**
   `npm run test:browser` and `npm run test:web`, file by file under the 4 GB cap (several drivers may share a suite
   only with the claim-folder method in testing-pitfalls; a separate TMPDIR for each script started at the same time),
   compared with base by test name. For the base side of the two suites you may compare by name against the
   site-reviews verifier's per-file logs of `cd13abf3`
   (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/verifier/gates/`; that tree is `f708dfb6` minus
   the build commit, which touched only `src/shared/build.ts`, HANDOFF, a plan file and a ledger) and run base yourself
   only for files that differ, fail, or that this job changed; say which is which. Pre-existing failures are fine only
   if they also fail on base by name (five browser files fail on main on this desktop: composition-clipping, fonts,
   hero-pair, peer-sides, pill-holder); rerun a differing file alone before calling a regression. The five replays
   byte-identical to base.
2. Every AC's named test on head (must pass) and on old code (an AC about new behaviour must fail there; preservation
   ACs pass on both: `base_exempt` with a reason and a byte receipt); a picture per AC — the pasted slider at load and
   after its arrow is pressed or a dot is clicked for AC1/AC3/AC5/AC6, site | paste at the widths the AC names, a
   terminal capture otherwise.
3. Also show, because three jobs merged under this one (a width range read without the site's stylesheets is read
   again; an Elementor FAQ pastes as an accordion; a third-party widget pastes as one live Code element): a page holding
   a slider and a live widget converts to one Slider (Nestable) and one live Code element and `site:check --all
   --elementor` is OK on it; with a stylesheet failing in the design width's page load the capture still records the
   slider's settings and slides.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/verifier/ac.json` and logs in that folder;
   self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy (`--base
   f708dfb659049db50bb45df8026faabee2ee0ad7`), as the reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-v/t1`,
  `t2`, …); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too; close every
  Chrome you start (kill by its profile path if Node dies). A worktree's `node_modules` may lack `.bin` and a scratch
  tree has no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Point `corpus.json` at the
  repo's copies as testing-pitfalls says (in a scratch copy, never the worktree). Run multi-step commands from a script
  file written with Write, paths spelled out.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry 8G; the
  parallel unit suite may need 8G). The PC loses power now and then: keep scripts and logs under `~/.cache/ssl-v/`,
  never the `/tmp` scratchpad, write each log's `EXIT=` line so finished runs count after a restart, and start long
  drivers with `setsid --fork`. If you are stopped by a usage limit and resumed, read your finished logs first and
  never start a second driver on a suite one is still working through.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; gates; `verdict`; `ac_status`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or
memory), ending with `MAIN SESSION: check and save these skill_lessons now.`
