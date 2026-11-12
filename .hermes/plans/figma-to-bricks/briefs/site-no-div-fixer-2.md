# Role: fixer (fix round 2): site-no-div — rule N's two remaining holes (R2-1, R2-2) and AC5's cited-test rows

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/testing-pitfalls.md`, `references/live-site-reading.md` "Code-route paste traps"). Read both `repeat-mistakes.md` files
first. Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch nothing under `~/Downloads`
(Justin's scan copy: `evidence/media-clickable/run/`). Commit to your branch only; don't push; don't bump BUILD; don't edit the main folder
or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder).

## Findings (review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/review-2/review.json`; probes, the rule-N-off hook and logs in `review-2/probes/`)
- **R2-1, P2, `src/core/site/fold-boxes.ts:102`:** the "wrapper is `width: 100%` itself" exception lets every width percentage through
  (padding, margin, min-/max-width, left, right); in a flex/grid row with siblings the wrapper's box isn't its parent's. Probe-d: up to 516 px
  off (2560), 257 (1440), 216 (390); 0 px with rule N off. Fix as the reviewer measured: in a flex or grid parent the exception covers only
  the element's own `width: 100%` / `height: 100%`.
- **R2-2, P2, `fold-boxes.ts:41` (`fontKept`) and the merge:** an element with no font size of its own folds and takes the wrapper's size,
  beating a heading's browser size (the paste's reset is `all: revert`); the merge also puts a wrapper's `font-weight` over a heading's browser
  bold and carries an em `line-height`/letter-spacing onto an element with a larger font size. Probe-c: h2 30 → 20 px, 700 → 300, a line
  27 → 41 px and up to 283 px below moved; 0 px with rule N off. Fix generally: refuse the fold when the wrapper carries a text setting
  (font-size, font-weight, line-height/letter-spacing in em, font-family…) that the element would take where the browser's own stylesheet
  gives it a different value (headings, `b`/`strong`, `small`, form controls…) or that is relative to a size the element changes; keep the
  folds that move nothing on Justin's scan and B-Dry (byte-identical pastes there, as round 1 proved).

## Also (test-only, same branch)
AC5's cited test ("Test …" of AC5 in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md`, amendment 1) gets the
rows the amendment planner wrote: `…/site-no-div/planner-amend-1/ac5-rows.txt` (green on 374ea2ce, red on ae288ac8: `ac5-rows-*.log`), plus a
row each for R2-1 and R2-2's refusals under the unchanged test name. If a second amendment (AC4, in `planner-amend-2/`) lands while you work,
I'll send you its rows too.

## Do
1. Your own worktree: `git checkout -B site-no-div-fix2 374ea2ce2075d86054c70c07daab45ef1148798a`.
2. Each finding: verify with the reviewer's probe, RED test first (beside the repo's fixtures), GREEN, a mutant per new guard. Rerun AC1–AC13 by
   name (named-only with their variables), `site-no-div-plain`, `site-no-div-bdry` (8G); review 1's and 2's probes 0 px on Bricks 2.4.2 and
   2.3.9; Justin's scan and the B-Dry stand-in byte-identical to 374ea2ce on both routes, native on and off (else say what moved and why);
   pins re-recorded only by their own tools, saying how many moved and why.
3. Gates: `npm run check` (8G scope); the `site-*` web files the fold reaches, one Chrome suite at a time (4G). Ledger "Fixer 2" and HANDOFF.
   Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdf2/t1`); scripts under `~/.cache/sdf2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`.

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; the AC5 rows; pins moved and why; gates; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
