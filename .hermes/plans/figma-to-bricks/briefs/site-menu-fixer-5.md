# Role: fixer (round 5, narrow: a merged job's stale goldens after the move onto main): site-menu

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). site-menu was rebased onto `main`
`7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4) by a finisher: branch `site-menu-stack6`, head
`803c23843d917472f645547f896e609c76cb5db1` (the ledger commit; code head `21b0dc975a84a3761e902824de8840e5603dce8c`).
Every gate passed but one unit test of a merged job, whose goldens this job moves by design. Regenerate those goldens
with proof, then stop at `ready-for-review`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, don't rebase, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any
live site; no logins; never write to any WordPress site. Change no source file under `src/` and nothing of the press
guard (`src/web/press-guard.ts`, its tests): this round touches test fixtures and records only.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main": the stacking lines on goldens — the four trees and the leaf-by-leaf diff) with
`references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix5 803c23843d917472f645547f896e609c76cb5db1`, confirm `git rev-parse HEAD` and a clean
status. Report your branch.

## The finding
`test/unit/site-slider-unchanged.test.ts` ("pastes without an Elementor slider are byte-identical") fails on the new
head with 16 misses and passes on main: all 8 variants of `site-page-code.pageCode` and all 8 of `code-page`. The
finisher's record (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/stack-6/four-trees.md`, its
`pathdiff.py`): in all 16 the only change is this job's intended header note (the old words "a menu button opens
nothing yet: its link was the page builder's pop-up action (the menu job)" become `UNOPENED_NOTE`: "a menu or pop-up
button opens nothing: capture again with this build so the capture reads what it opens"); the job's leaves old base →
old head (`3cfc54ac` → `4dd1a275`) equal main → new head leaf for leaf and don't overlap main's own change to
code-page (its footer notes); the other 64 sums are equal on all four trees.

## Work
1. **Check that proof yourself first** (re-run it on `git archive` copies of the four trees; don't trust the table):
   the 16 entries move only by this job's note; nothing else in those pastes differs between main and head.
2. Regenerate only `test/fixtures/site-slider-base/site-page-code.pageCode.json` and
   `test/fixtures/site-slider-base/site.code-page.sha256.json` (the 16 entries) through the test's own generator
   (`pastesOf`) with your head's converter, on the same saved inputs, **without capturing again**; every other entry
   and every saved capture stays byte for byte (prove it: a key-by-key compare before and after). RED before (the test
   fails with 16 misses), GREEN after. One commit.
3. **Find every other pin this job moves on the new main**, not only the unit ones: site-faq's, site-reviews',
   site-slider's and staging-fit-renderer's "unchanged" sums, goldens and byte receipts in `test/web/`,
   `test/browser/` and behind env gates (`F2B_UNCHANGED_SUMS`, `F2B_STORY_PINS`, `F2B_PIN_BASE`, `F2B_REAL_CAPTURES`,
   `F2B_PANEL_CAPTURES`, named-only tests whose inputs are on this machine), and this job's own pins against the new
   base. Same rule for each: prove by the trees and the leaves, then regenerate; a pin that moves for any other
   reason is a finding: fix nothing in `src/`, report it.
4. Gates (on a `git archive` scratch copy of your head; put
   `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules`
   in; each log starts `HEAD=` and ends with one line `EXIT=`): both typechecks and `npm run check` (the parallel unit
   suite may need an 8G scope): **0 failures**; `test/unit/plugin-convert.test.ts`; the guard's tests unchanged and
   green (`web-press-guard` unit; `capture-opens-guards` alone under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0`, export variables first, no `--setenv=PATH`; its worker-capture comparison is a known load flake:
   rerun alone at low load before calling it a failure). `git diff 803c2384..HEAD --stat` shows only fixture and
   docs files.
5. Records in your commits: the ledger (`docs/plans/2026-11-09-site-menu-ledger.md`, "Fix pass 5": the proof, the
   entries regenerated, the other pins checked, the gates); append what you defer to
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/follow-ups.md`. Commits: plain `git commit -m` (or
   `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.
   Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-5/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-f5/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (stop it by the PIDs of
its own profile path; never `pkill -f <pattern>`). Scripts written with Write under `~/.cache/smn-f5/`; one `bash
<file>` per Bash call. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
short-iso | grep sending`). Waits under 115 s. The PC lost power twice this week and agents were stopped by a usage
limit twice: write each log's `EXIT=` line (wait on `^EXIT=`); when resumed, check `git status` and `git cat-file -t
HEAD` (a commit made in the last seconds can leave empty objects: point the branch back to the last good commit, make
the content differ, commit again) and read your finished logs first.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); the proof re-run; the entries regenerated and the
before/after key compare; every other pin checked and what you found; the gates; `found_else`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
