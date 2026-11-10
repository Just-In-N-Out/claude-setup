# Role: fixer (the move onto main, and what the move needs): control-weight

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). control-weight (on the website importer's code route,
an element its parent reads as an inline word at some widths carries those widths in its own class, at every depth
the reading nests, so Bricks' class controls can't out-weigh the parent's rule) was built on top of another job's
branch: branch `control-weight-fix1`, head `c187461461b12b5022734142787852e2398f33fa` (source head `3ebb082d`), sitting
on staging-fit-cancels' old head `ce5b38acbb959c12218e319560608c660c753b70`. That job has now merged: local `main` is
`56a9379faf207c2bfa76211dff1365db7d74be37` (Build 2026-11-10.6; site-media-upload merged before it as Build
2026-11-10.5). Move this job onto `main`, do what the move needs, run the gates, stop at `ready-for-review`. (Fix pass
1's commits `a442672e..c1874614` have not been reviewed yet: one review will cover them and your move together.)

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site
(saved captures and local fixtures only); no logins; never write to any WordPress site; never run `npm run
site:upload` against anything. Nothing paid. **Change nothing of the job's rule**: this round is the move, stale pins
and records. (Mini pipeline: if the move needs a design decision, stop with `status: stopped`, `stop_reason: escalate
to full`.)

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the stacking lines: goldens both ways, the four trees, story pins are receipts, "run each
AC's test on the new main too") with `references/testing-pitfalls.md` and `references/live-site-reading.md`
("Code-route paste traps"), and the repo `CLAUDE.md` in the main folder (the Status lines of Builds 2026-11-10.5 and
.6; the standing rule "A website paste never cancels a declaration at a width range with `revert`").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md`
  (AC1–AC6, proposed; none live). Deferred items: `evidence/control-weight/follow-ups.md`. Review 1 (at `a442672e`):
  `evidence/control-weight/review-1/review.json`; fix pass 1's receipts: `evidence/control-weight/fixer-1/`.
- Files both sides changed since `ce5b38ac`: `docs/HANDOFF.md` (the builder reworded one Known-limits bullet in
  staging-fit-cancels' section; that job's merge finisher has since added bullets there and filled its build and id
  3du), `src/core/site/convert.ts` (site-media-upload's media hooks; this job's lines in `prepare`'s class loop),
  `test/web/site-range-cancels.test.ts` (staging-fit-cancels' file: this job turned its `todo` test into a real one).

## Your copy (you start in your own worktree)
`git checkout -B control-weight-stack12 c187461461b12b5022734142787852e2398f33fa`, then `git rebase --onto main
ce5b38acbb959c12218e319560608c660c753b70` (only this job's own commits move: staging-fit-cancels' commits are already
in `main`, patch for patch; check `git rev-parse main` = `56a9379f…`; if main moved again, use it and say so). Report
your branch.

## Work
1. **The rebase.** Keep both sides' meaning in each conflict; typecheck at each conflicted commit before `git rebase
   --continue`; save each hand resolution's combined diff before `git add`. `convert.ts`: site-media-upload's media
   map and `sourceUrl` code stays as main has it; this job's `owners`, `decls`, `words`, `moved` in the class loop,
   `own` reading `decls`, `inline:` reading `words` without the moved keys. HANDOFF: every section stays, this job's
   first, then main's lines exactly as main has them (staging-fit-cancels' section reads Build 2026-11-10.6 and 3du,
   with the bullets its finisher added; **this job's reworded Known-limits line in that section** — the one that said
   the 768–991 limit is fixed where the paste proves which element is which — goes in beside main's newer bullet about
   the inline-link limit not being specific to 768–991: make the two read as one true statement: the limit holds
   wherever a wrapper's words hold the link at some range, and this job removes it where the paste proves which
   element is which, each element inside it too; elsewhere the `:nth-child` rule stays as before); this job's
   `<control-weight id at merge>` placeholders stay. `test/web/site-range-cancels.test.ts`: main's file with this
   job's change (the `todo` test is a real test; no `todo` left in the file). Save `git range-diff
   ce5b38ac..c1874614 main..<new head before your own commits>`.
2. **Stale pins.** `test/fixtures/site-no-revert-main.json` (staging-fit-cancels' golden of main's hand-made pastes,
   in the default suite; the plan's AC5 says it stays unchanged): it must still pass untouched. This job's AC4 byte
   test compares with a base tree: its base is now `main` `56a9379f` (the plan says `ce5b38ac`: the pastes are the
   same; prove it: the base tree's sums on `ce5b38ac` and on `56a9379f` are equal for the captures the test reads),
   and record that the planner must amend the plan's base. Any other default-suite pin that fails on the rebased
   head: prove by the trees whether it moves only by a merged job's change or by this job's design; regenerate it
   only then (from the new base tree where it pins main; through the test's own generator where it pins this job's
   output), and say which entries moved and why. A merged job's env-gated story pin (`F2B_STORY_PINS=1`) is that
   job's receipt: if this job moves one by design (the captures holding the shape), record the table and move on.
3. **Where the sides meet** (local fixtures only; say what you probed and saw): site-media-upload's media map on a
   capture holding the shape (a moved element with a background or mask picture in its class, a moved Image): the
   library address reaches the moved element's own class and its bounded runs; without a map the paste is byte for
   byte this job's old head's. staging-fit-cancels' bounded runs under this job's moved readings: no `revert`
   appears (`test/unit/site-no-revert.test.ts`, and your own grep over the shape fixtures' pastes).
4. **Each AC's test on the new main too** (`git archive` of `56a9379f` with the test laid over): AC1's RED is still
   the `inline-block` and the 28 px inside 768–991 (and review 1's nested label at 768–991 for the nested fixture);
   say what differs.
5. **Gates** (on a `git archive` scratch copy of your head; put
   `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
   a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar;
   never chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`; each log starts `HEAD=` and
   ends with one line `EXIT=`): both typechecks (`tsconfig.sandbox.json` too) and `npm run check` (the parallel unit
   suite may need an 8G scope): 0 failures; the job's tests (`test/unit/site-inline-own.test.ts`,
   `test/web/site-range-cancels.test.ts`, `test/web/site-inline-nested.test.ts`, each web file alone under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, export variables first, no `--setenv=PATH`); AC4's
   byte test by name against base `56a9379f` (47 captures: only the captures holding the shape differ);
   `test/unit/plugin-convert.test.ts`; the five Figma replays byte-identical to `main`; the site-route web files the
   change can touch (the site-code / site-elementor / site-page / site-motion proofs; the merged jobs' class-CSS and
   media files: `site-upload-page`, `site-live-widget*`, the slider files), each alone under the cap, compared by
   name with `main` (known flakes: the code-page fixture's 5.09 px load flake, `capture-entrances` R8-1,
   `site-elementor-button` pixels-at-rest: rerun a flake alone before calling it a failure; the named-only B-Dry
   files fail on main by the footer's 69 px, another job's); review 1's probes (`~/.cache/cw-r1/`: `cw-nested`,
   `cw-leak`, `cw-text` 0 differences; `cw-words` as base) re-run on your head.
6. Records batched into your commits: the ledger (`docs/plans/2026-11-10-control-weight-ledger.md`, "stack 12": the
   rebase, each conflict and resolution, the pins, the meet probes, the gates; the plan lines the planner must amend:
   the base `ce5b38ac` → `main`, AC1's range words — the limit is not specific to 768–991 —, review 1's nested rule
   "at every depth", the `alone` variant) and HANDOFF; append what you defer to
   `evidence/control-weight/follow-ups.md`. **The lifted-child fixture** (review 1's R1-4) can't be added yet:
   site-native-structure's `lift` is still not on main; keep it recorded. Commits: plain `git commit -m` (or `-F
   <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md; `git
   ls-files .superpowers/` stays empty. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/stack-12/` (`range-diff.txt`, `conflicts.md`,
   `resolutions/`, `pins.md`, `meet/`, `logs/`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-s12/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). Scripts written
with Write under `~/.cache/control-weight-stack12/`; one `bash <file>` per Bash call; long gates on a scratch copy,
never in the worktree while you edit it. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom
--since "-30 min" -o short-iso | grep sending`): say so, find what grew, rerun under the cap. Waits under 115 s; wait
for background drivers in the foreground with a bounded loop script. The PC lost power twice this week and agents
were stopped by a usage limit twice: write each log's `EXIT=` line (wait on `^EXIT=`); when resumed, check `git
status` for half-written tracked files (exactly 8388608 bytes) and `git cat-file -t HEAD`, read your finished logs
first and never start a second driver on a suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, the head before your own commits and the last commit (full SHAs), base; the
rebase (conflicts and resolutions); the pins (what moved, why); where the sides meet; each AC's RED on the new main;
each gate against main; review 1's probes on your head; the plan lines for the planner; `found_else`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line
check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
