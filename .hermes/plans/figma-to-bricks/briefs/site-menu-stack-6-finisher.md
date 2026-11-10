# Finisher (step 1, in a copy): stack 6 — move site-menu onto the new main

You are a fresh finisher (**Opus 5.5, high**). site-menu (the capture presses a page's menu / pop-up / drawer buttons
to read what they open, under a guard that stops data-sending requests and page loads while it presses; the paste
carries what opens) is review-clean on an **old** main: branch `site-menu-fix4`, head
`4dd1a2755937da00b28bd7cf8cdf18ab0f1552fe` (31 commits), base `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build
2026-11-09.4). Four jobs have merged since, each with a build commit: local `main` is now
`7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4: site-faq, site-reviews, site-slider,
staging-fit-renderer). Move this job onto it.

**This is a real rebase, not a pure one.** Files both sides changed since `3cfc54ac`: `docs/HANDOFF.md`,
`reference/bricks/README.md`, `reference/bricks/frontend-2.3.9/SHA256SUMS`, `src/core/site/convert.ts`,
`src/core/site/kinds.ts`, `src/core/site/parts.ts`, `src/core/snapshot/web.ts`, `src/web/capture.ts`,
`test/browser/chrome.ts`, `test/browser/render.ts`, `test/web/lib/site-check.ts`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site
(the capture and `site:live` run only against local fixture servers); no logins; never write to any WordPress site.
Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines: above all "main's side of a conflict is 'this code moved to a new file'" and "an upper job that changes a
conversion step by design breaks a merged job's goldens") with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the lines on a capture that presses page controls and "Holding a Chrome to
read-only"), and the repo `CLAUDE.md` in the main folder (its Status lines for the four merged jobs, the standing
rules "The importer never hides that its Chrome is automated" and "`npm run site:live` only reads a published page",
"Finish" step 1). Read HANDOFF's sections of the four merged jobs on main before resolving anything in the files
above: you must know what each side means.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (amended).
  Deferred items and state: `evidence/site-menu/follow-ups.md`.
- Not merged, moving beside this job (don't rebase onto it; keep your resolutions small so its later move is easy):
  site-native-structure (`site-native-structure-fix3`, already on main: `convert.ts`, `parts.ts`, `tree.ts`,
  `render.ts`, `test/web/lib/site-check.ts`, `test/fixtures/site-motion-base/site-page-code.pageCode.json`).

## Your copy (you start in your own worktree)
`git checkout -B site-menu-stack6 4dd1a2755937da00b28bd7cf8cdf18ab0f1552fe`, then `git rebase --onto main
3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (check `git rev-parse main` = `7eeca437…`; if main moved again, use it and
say so).

## Rules
- **Conflicts: keep both sides' meaning, commit by commit.** Never drop a merged job's behaviour (staging-fit-capture's
  styleless-range re-read and refusal; site-reviews' served-page reading and live widgets; site-slider's sliders;
  staging-fit-renderer's `chrome.ts` additions, its renderer printing and 2.4.2 assets, `site:check --whole`, the
  `{ css }` locator; site-faq's open answers) and never drop this job's (the press step and **its guard**: no
  data-sending request and no page load leaves while the capture presses, in the pressed tab, a window a press opens,
  a frame or a worker; what a press opens is read and pasted; the notes). **The guard's code and tests come through
  the rebase with every changed line unchanged**: if a conflict touches `src/web/press-guard.ts`, `capture.ts`'s
  calls into it or `test/browser/chrome.ts`'s launch and ending, resolve it so both the guard and the merged job's
  code run, then re-run the guard's tests at that commit before `git rebase --continue`. HANDOFF: every section stays,
  this job's first, then main's lines exactly as main has them; this job's `<site-menu id at merge>` / `<at merge>`
  placeholders stay.
- **Moved code:** where main's side of a conflict is "this code moved to a new file" (staging-fit-renderer moved
  measuring into `tools/lib/site-measure.ts`, and reading into `tools/lib/site-whole.ts` / `read-only.ts`), port this
  job's change into the moved file, then grep this job's new fields and helpers across every new caller of the moved
  code (`site:live`, `--whole`).
- **Goldens and "unchanged" sums** (this job's and the merged jobs'): a recorded value stale only because the other
  side changed pastes by design is proven by sums of the same inputs on four trees (old base `3cfc54ac`, old head
  `4dd1a275`, new main, new head), then regenerated **by a fixer, not by you**: record the table and stop on it. A
  value that differs for any other reason is a finding: stop on it and report.
- **Where the two sides meet in behaviour** (probe each on the rebased head; local fixtures only): a capture that
  presses on a page with a carousel, a FAQ and a live widget (does a press on a slider's arrow, an accordion's
  question or a widget's button count as a control to press; is what it opens read; do site-slider's and site-faq's
  captures read the same as on main); the capture's format and `capture:check` with both sides' fields;
  staging-fit-capture's re-read of a styleless range with the press step on; `site:check` (`--all`, `--whole`) and
  `site:live`'s drawing on a paste that holds what a press opened; `chrome.ts`: both sides' launch switches joined
  into one `--disable-features` (Chrome keeps only the last). The merged jobs' own tests must pass unchanged on the
  rebased head. If one fails and the cure is more than keeping both sides in a conflict (new logic), **don't write
  it**: stop, and report the failing test, the smallest repro and your reading of the cause, so the main session can
  send a fixer.
- Record every conflict and its resolution, commit by commit, in this job's ledger (find it under `docs/plans/`; `git
  ls-files .superpowers/` must stay empty) as the branch's last commit. A conflicted rebase is reviewed before the job
  is verified: write the record so a reviewer can check each resolution against both sides (`git range-diff
  3cfc54ac..4dd1a275 main..<new head before the ledger commit>` saved; for each conflicted commit, the combined diff of
  what you resolved by hand, saved before `git add`).
- Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff
  --cached --name-only` without CLAUDE.md. `package.json`: after the rebase count each script key (no duplicate, none
  lost). Typecheck at each conflicted commit before `git rebase --continue`.

## Gates (on a `git archive` scratch copy of the new head; put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in)
1. Both typechecks (`tsconfig.sandbox.json` too) and `npm run check` (the parallel unit suite may need an 8G scope).
2. This job's AC tests (each test the approved plan names; the guard's files first: `capture-opens-guards`, the unit
   `web-press-guard`, `capture-opens`, `capture-opens-styled`, `site-opens-more`, `site-opens-proof`,
   `site-check-opens`, `capture-matched-once`, `web-opens-read`, `site-opens-through`), and the four merged jobs' own
   test files (unit, web and browser: find them by the jobs' names and by what their HANDOFF sections cite; the
   read-only guard's `site-live.test.ts` and unit tests among them), each web/browser file alone under `systemd-run
   --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first, no `--setenv=PATH`), one Chrome job at a
   time, compared by name with `main` (five browser files fail on main on this desktop: composition-clipping, fonts,
   hero-pair, peer-sides, pill-holder; known flakes: the code-page fixture's 5.09 px load flake, `capture-windows`
   AC7, `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest: rerun a flake alone before calling it a
   failure). **Known on main, not this job's:** the named-only `site-elementor-page-bdry` fails on main (B-Dry's
   footer icon list drawn 69 px off since Build 2026-11-10.4; its own job).
3. `test/unit/plugin-convert.test.ts`; the five Figma replays byte-identical to `main`; `npm run corpus` the same as
   `main` (v1's Mac files are missing on this machine).
4. The offline B-Dry dry run of the press step (8G scope), as fix round 4 ran it: the same 5 boxes, 0 non-GET requests,
   no other page asked for; and its capture time against main's on the same saved site (say both).
Each log starts `HEAD=` and ends with one line `EXIT=` (wait on `^EXIT=`). Stop and report if anything fails that
isn't a named flake.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/stack-6/` (`range-diff.txt`, `conflicts.md`,
`resolutions/`, `four-trees.md` if any pin moved, `meet/`, `logs/`), scripts under `~/.cache/smn-s6/` (written with
Write; one `bash <file>` per Bash call).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-s6/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the
tool's own shell). SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
short-iso | grep sending`): say so, rerun under the cap. Waits under 115 s. The PC lost power twice this week and
agents can be stopped by a usage limit: write each log's `EXIT=` line; when resumed, check `git status` for
half-written tracked files (exactly 8388608 bytes) and `git cat-file` your last commit (a commit made in the last
seconds can leave empty objects: point the branch back to the last good commit, make the content differ, commit
again), read your finished logs first and never start a second driver on a suite one is still working through.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA); the conflicts and resolutions commit by commit, the moved-code
ports, any pin that moved with its four-tree table, the ledger commit; where the sides meet in behaviour: what you
probed and saw; the guard's tests at each conflicted commit and on the new head; each gate's result against main;
anything you stopped on; then `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
