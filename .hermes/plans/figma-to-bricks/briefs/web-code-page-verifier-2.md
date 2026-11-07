# Role: verifier (read-only): web-code-page

You are a fresh verifier who never saw the build or the reviews (Opus 5.5, xhigh). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees (read
them by absolute path or `git show`). Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job and
the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md` (AC1–AC20
  with Amendments 1 and 2; AC12 and AC19 live, Justin's: mark them `not_run`, owed). Justin's ruling replacing Q4 A (a slider keeps
  all its own slides): `evidence/web-code-page/justin-q4-slider.md`.
- Head `c920728a2355240119304f890236bdf315a21176` (branch `web-code-page-build`); base (old code) main `ea504778` (`git
  rev-parse ea504778`). In your own worktree: `git checkout --detach c920728a…`, confirm `git rev-parse HEAD` and a clean
  `git status --porcelain --untracked-files=all`. Old code: a tree from `git archive` of the base with head's test files and
  the test-only modules they import copied in (a hybrid tree if base only fails at import).
- Named-only inputs (read-only): AC9/AC17/AC18 `F2B_CODE_PROOF_BDRY=$HOME/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/bdry-2026-10-29`
  and `F2B_CODE_PROOF_CAPTURE` as the plan's Task for AC9 says (read the plan and the test for the exact use; a fresh
  stand-in capture takes about 31 min). AC10 `F2B_CODE_PAGE_CAPTURE=/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`
  (Justin's 11-04 capture).
- Don't read the builder's, fixer's or reviewers' reports as proof; their logs only tell you where things are.

## Work
1. Gates on head: both typechecks, `npm run check`, `npm run corpus` (same output as base; v1's three Mac files are missing on
   this machine), the **full** `npm run test:browser` and `npm run test:web`, file by file under the 4 GB cap, compared with
   base by test name (pre-existing failures are fine only if they also fail on base by name). AC11: five replays and the
   corpus byte-identical to base.
2. Every AC's named test on head (must pass) and on old code (an AC about new behaviour must fail there; an AC keeping
   existing behaviour is `base_exempt` with a byte-identity probe), each log starting `HEAD=` and ending `EXIT=`, skipped 0;
   a picture or terminal capture per AC (AC7/AC9: side-by-side site | paste shots). Read `git log -p ea504778..HEAD -- <each
   AC's test files>` against the plan.
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/verifier/ac.json` and logs in that folder;
   self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy, as the
   reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-v2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time, closed after each step. The
  worktree's `node_modules` may lack `.bin`: see testing-pitfalls. Point `corpus.json` at the repo's copies as
  testing-pitfalls says. Never edit a script a background run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; gates; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`

## Round 2 note
A first verifier ran on `95097213`; its folder is now `evidence/web-code-page/verifier-1-95097213/`. Don't read it: prove
everything yourself on `c920728a`. Amendment 2 changed AC2/AC3 wording, builds AC8's `npm run capture` finder and adds AC20
(bold and italic, `test/web/site-page-proof.test.ts`). For AC8, also run `npm run capture` with `CHROME_PATH` unset.
