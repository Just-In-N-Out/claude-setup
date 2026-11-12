# Role: verifier (read-only): site-no-div

You are a fresh verifier who never saw the build, the fixes or the reviews (**Opus 5.5, high**). Prove each acceptance criterion yourself.
Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main
folder; no git piped into another command: `git archive -o <file> <sha>`, then extract separately). **Never load bdryswi.com**, B-Dry staging or
any live site; never write to any WordPress site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: read-only copy
`evidence/media-clickable/run/`). The verifier folder `evidence/site-no-div/verifier/` is empty: check before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head prints test names with an `ACn ` prefix the plan's cited names may lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` "Code-route paste traps". Read both `repeat-mistakes.md` files first. Don't read builder's, fixers', planners'
or reviewers' reports or folders as proof.

## Inputs
- Approved plan (read-only, amendment 3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md` (AC1–AC14; AC14
  live). The job: every website paste (both routes) holds no Div — Sections/Containers/Blocks by rule S, Text links/Buttons/linked Images,
  Rich Text, neutral wrappers folded by rule N (with its refusals), each box labelled; `native: false` = base with Div renamed Block; Figma
  designs byte for byte.
- Head `828f7dc01af443ea5bc248fac1d1106e711cfdba` (branch `site-no-div-fix3`), base local main `56b5076b5c1d665abd5bad4bcc78861739cc01e9`
  (Build 2026-11-12.1). `git checkout --detach 828f7dc0…`. Old code: a `git archive` of 56b5076b with head's test files and fixtures copied in
  (where a new module doesn't import, prove with a one-line mutant of head). AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G; compare every failure with base by name; rerun a failure alone once); `dist/` and the
   Figma replays byte for byte base's; the merged jobs' golden tools rerun on head (`node tools/site-no-revert-golden.ts .` and the others the
   plan names) with their outputs equal to the committed goldens.
2. Every AC's test by its plan name on head (pass) and on old code (fail), named-only ones with the plan's variables; a picture per AC
   (Structure-panel dumps before/after; site | paste at 1440 and 390).
3. Your own checks: a plain fixture site of your own (not the repo's) with a flex row of a card and a sidebar, a `width: 100%` button in a
   plain div, an `h2` inside a div with its own font size, a sticky bar inside a wrapper, a menu `ul > li > a`, a `section, article, section`
   top level — which folds, which stays a labelled Block, and 0 px against the site at 1440 and 390 on Bricks 2.4.2 and 2.3.9; Justin's scan
   on both routes: no Div, the counts the plan states, base | head paired by site path (0 moved).
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/verifier/ac.json` and logs there; self-check with `ac-check.sh` on a copy
   (`--base 56b5076b5c1d665abd5bad4bcc78861739cc01e9`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdv/t1`); scripts under `~/.cache/sdv/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`); one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long suites with `setsid --fork`, waiting on `^EXIT=`; a suite driver skips files already in its log.
SIGTERM/143/137/"Killed" may be earlyoom: check first. Finish every gate before reporting (don't hand back "incomplete").

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates by name; own checks; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
