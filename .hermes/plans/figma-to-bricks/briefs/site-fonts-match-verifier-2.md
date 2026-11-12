# Role: verifier (read-only): site-fonts-match — on its rebased head

You are a fresh verifier who never saw the build, the fix or the reviews (**Opus 5.5, high**). Prove each acceptance criterion yourself.
Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main
folder). **Never load bdryswi.com**, B-Dry staging or any live site (Google Fonts only as `site:check` does); never write to any WordPress
site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: read-only copy `evidence/media-clickable/run/`). The verifier folder
`evidence/site-fonts-match/verifier/` is empty: check before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md` (fonts lines) and
`references/testing-pitfalls.md` (the subset-font line, CHROME_PATH line). Read both `repeat-mistakes.md` files first. Don't read builder's,
fixer's or reviewers' reports or folders as proof.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md` (AC1–AC9; AC9 live).
- Head `c8ad17b88a345eb9f1dbcb7946bca7e236a837c2` (branch `site-fonts-match-fix2`: the accepted dde55059 rebased onto main with source conflicts
  in `src/core/site/convert.ts` and `parts.ts` resolved, a test-only re-pin commit and a test-only AC7 sums commit; review 3 clean), base local
  main `56b5076b5c1d665abd5bad4bcc78861739cc01e9` (Build 2026-11-12.1, site-native-structure merged). `git checkout --detach c8ad17b8…`. Old code:
  a `git archive` of 56b5076b with head's test files and fixtures copied in. AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.
  Never read `verifier-dde5505/`, `auditor-dde5505/`, `rebase/`, `fixer-2/` or `review-3/` as proof.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (compare every failure with base by name; rerun a failure alone once); `dist/` and the Figma replays byte for byte base's.
2. Every AC's test on head (pass) and on old code; a picture per AC (AC5: site | paste drawn at 1440 and 390, each line labelled with the font
   Chrome drew it with).
3. Your own checks: where this job meets site-native-structure (a site-served family on a page whose part roots are lifted and one
   whose header keeps its root: the fonts class on every top element, no plain name in any Typography control, Chrome drawing the site's
   file); Justin's scan through head and base on both routes (AC7: byte for byte as base for a capture read before this build);
   a fixture site of your own with a site-served family in three weights where one file 403s and one weight is Google's — the paste's
   families, `@font-face`, Bricks' Google scan (ported in AC4's test) and the drawn fonts.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/verifier/ac.json` and logs there; self-check with `ac-check.sh`
   on a copy (`--base 56b5076b5c1d665abd5bad4bcc78861739cc01e9`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sfv2/t1`); scripts under `~/.cache/sfv2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start (`pgrep -f '[u]ser-data-dir=<path>'`); memory
scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long suites with `setsid --fork`, waiting on `^EXIT=`; a suite driver
skips files already in its log. SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates by name; own checks; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
