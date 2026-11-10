# Role: fixer (round 2: rebase onto main, then review 2's R2-1, P2): site-native-structure

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). First rebase site-native-structure onto local `main`,
then fix review 2's one P2 test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging** or any live site (local fixtures and saved
files only); no logins; never write to any WordPress site. Nothing paid.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the wrapper-fold lines) and `references/rendering-validation.md`, the repo `CLAUDE.md`
("Build general logic": nothing keyed on B-Dry; "Bricks gives every Block `width: 100%`") and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-native-structure-fix2 db5829201a3e546da0a861fb5e7d234a7a91e07d` (the reviewed head, branch
`site-native-structure-fix1`, on the old main `fd1986dc`), confirm `git rev-parse HEAD` and a clean status (after a
machine restart, look for tracked files of exactly 8388608 bytes and restore them). Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`.
  Don't change the plan or any AC (a planner amends AC6's and AC10's wording after this round: review 2's R2-2).
- New base: local `main` `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4, staging-fit-capture merged;
  check `git rev-parse main`). It adds `src/core/site/styled-ranges.ts`, touches `tools/site.ts`, `tools/site-check.ts`,
  the capture and `docs/HANDOFF.md`; a capture holding a width range read without the site's styles is now refused.
- Review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-2/review.json` and its
  probes in that folder (`probe-margin.test.ts`, `probe-margin-chrome.test.ts`, `probe-rtl.test.ts`). Fixer 1's
  receipts: `evidence/site-native-structure/fixer-1/`.

## Work
1. **Rebase first:** `git rebase main`. Expect a HANDOFF conflict at most; keep both sides' meaning (this job's section
   first, main's lines as main has them). Record each conflict and resolution in the ledger. Rerun on the rebased head:
   both typechecks, `npm run check`, this job's AC tests (AC14 on a clean stand-in capture, never Justin's 2026-11-09
   capture, which main now refuses) and staging-fit-capture's `site-cli` and `test/unit/site-styled-ranges.test.ts`; stop
   and report if anything new fails.
2. **R2-1 (P2, `src/core/site/elementor-place.ts:126`):** a percentage-width body still folds out of a stretched widget
   box that has side margins. The merge moves those margins onto the Button but keeps its `width: 100%`, which then
   means the whole column where on the site it meant the column less the margins: in Chrome the pasted Button is 40 px
   wider than the site's and 20 px past its column (a full-width call button, Alignment: Justified, with Advanced →
   Margin left/right, in a column). The box proof misses it because border boxes leave margins out. General rule, for
   every body rule 10 folds (a Button, a linked picture's `a`, an img with `width` or `max-width` in %): a percentage
   width or max-width never ends up resolving against a wider box than on the site — either refuse (one labelled box
   stays, the note says why) or write the exact `calc(100% - <the margins moved onto it>)`; choose the one you can prove
   at every width of every kept range, per side and per range, and say which. Test first: a unit case (with and without
   the capture holding the widget box's own box) and a captured fixture case in
   `test/fixtures/web/sites/elementor-places/` (a full-width button with widget side margins in a column; the same for a
   linked picture with a 100% img if it reaches the same code), read in Chrome with Bricks' front-end CSS at the
   fixture's widths: the Button's box equals the site's within 0.5 px. RED on the rebased head, then GREEN.
3. **Small, only if each is a few lines and proven by a test:**
   - R2-3: under a right-to-left direction (`direction: rtl` on the body's line), `text-align: left`/`right` must not
     fold as `flex-start`/`flex-end` (they mirror): refuse with a note, and correct HANDOFF's Deferred line that says
     the boxes refuse it.
   - R2-2's test half: AC14's test requires only "at least one Button alone"; make it able to fail on a real drop (for
     example: every Button and linked picture either stands alone or has its note, and the alone counts on the saved
     stand-in are printed and compared with the counts HANDOFF states), without keying source on B-Dry.
   - R2-4 stays a follow-up (already recorded).
4. Mutate what you add (each condition of the new guard removed in turn kills a test), under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
5. Records batched into your commits: HANDOFF's site-native-structure section and "Deferred", the ledger ("Fix pass 2").
6. Gates before stopping: both typechecks, `npm run check`, AC1–AC14 by name (logs `HEAD=` first, `EXIT=` last; AC13
   with `F2B_PIN_BASE=1` against the new main), the five replays byte-identical to main, `test:web` and `test:browser`
   file by file under the 4 GB cap compared by name with new main (run main's side for files that differ; rerun a
   differing file alone before calling a regression). Commit after each passing step (plain `git commit -m`, no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/fixer-2/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-f2/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start. Worktree `node_modules` may lack `.bin`, and a `git archive` scratch tree
  has no `tsc`: put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH there. Run multi-step commands
  from a script file written with Write, paths spelled out; keep scripts and logs under `~/.cache/sns-f2/` (a restart
  empties `/tmp`); run long gates on a scratch copy, never in the worktree while you edit it.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under the 4 GB cap (B-Dry 8G) with a bounded `--test-timeout`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, new base SHA, last commit (full SHA), the rebase conflicts and resolutions, R2-1:
verified?, the rule (refuse or calc, and why), fix, tests, RED/GREEN paths, mutation; the small steps done or left;
B-Dry stand-in counts (Buttons and linked pictures alone) before and after; gates vs main; `found_else`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
