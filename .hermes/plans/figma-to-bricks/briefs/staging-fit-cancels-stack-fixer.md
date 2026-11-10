# Role: fixer (the move onto main, and what the move needs): staging-fit-cancels

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). staging-fit-cancels (the code route's paste no longer
cancels a declaration at a width range with `revert`, which rolled back the whole author origin; a value a range drops
is written as bounded runs, so a link that is an inline word at 768–991 keeps its painted button look at other widths)
is review-clean on an **old** main: branch `staging-fit-cancels-build`, head
`b1329c43ec775fa1770e54e0fa2dde1d11b9f0d6` (9 commits), base `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build
2026-11-09.4). Four jobs have merged since, each with a build commit: local `main` is now
`7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4: site-faq, site-reviews, site-slider,
staging-fit-renderer). Move this job onto it, do what the move needs test-first, run the gates, stop at
`ready-for-review`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site. Nothing paid.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines: the goldens rule both ways, "main's side of a conflict is 'this code moved to a new file'") with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Code-route paste traps": `revert`), the repo
`CLAUDE.md` in the main folder (Status lines of the four merged jobs; "Architecture rules": CSS stays typed, never
regex or string-match CSS) and HANDOFF's sections of the four merged jobs.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md`
  (AC1–AC3 or as it lists them; Q1 A as built — a hybrid: properties no range drops keep main's blocks — and Q2 A, not
  yet confirmed by Justin). Deferred items: `evidence/staging-fit-cancels/follow-ups.md` (review 1's P3s R1-1 to R1-6).
- Files both sides changed since `3cfc54ac`: `docs/HANDOFF.md`, `src/core/site/classes.ts`,
  `src/core/site/controls.ts`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-cancels-stack7 b1329c43ec775fa1770e54e0fa2dde1d11b9f0d6`, then `git rebase --onto main
3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (check `git rev-parse main` = `7eeca437…`; if main moved again, use it and
say so). Report your branch.

## Work
1. **The rebase.** Conflicts: keep both sides' meaning, commit by commit (main's `ClassCss.inside`, the slider and
   live-widget class CSS, site-faq's open look; this job's bounded runs); typecheck at each conflicted commit before
   `git rebase --continue`; save each hand resolution's combined diff before `git add`. HANDOFF: every section stays,
   this job's first, then main's lines exactly as main has them; this job's `<staging-fit-cancels id at merge>` / `<at
   merge>` placeholders stay. Save `git range-diff 3cfc54ac..b1329c43 main..<new head before your own commits>`.
2. **AC3's golden** `test/fixtures/site-no-revert-main.json` pins the old main's pastes of the hand-made captures. The
   merged jobs changed pastes on purpose, so regenerate it **from the new base tree** (`main` in a `git archive`
   scratch copy: `node tools/site-no-revert-golden.ts .` there, with this job's tool copied in if main lacks it; never
   from head's output), and say which entries moved and which merged job moved each (prove it: the entries that move
   between old main and new main, against what each job changes). One commit.
3. **Every `revert` the merged jobs write, now that they are under this job** (`grep` the site route's source on the
   rebased head, and the pastes of every fixture, plain and `--elementor`): site-faq's accordion open look
   (`src/core/site/elementor-accordion.ts` `openLook` / `lookCss`; review 1's R1-4 reads it as not the cancel kind: it
   sits on the open item's own element and cancels only that element's own closed value), anything site-slider,
   site-reviews or staging-fit-renderer write. For each: is it the per-range cancel this job replaces (then it rolls
   back the author origin for that property at that range, the bug Justin saw; move it onto this job's helpers —
   `runsOf`, `boundsOf`, `mediaOf` — test first, RED on the rebased head), or a different use that is right as it
   stands (then name it as an exception where AC2's test and HANDOFF's line "The only `revert` in a paste is the
   site-reset class's own" speak: R1-5)? AC2's test must pass on every fixture it scans on the rebased head, for a
   stated reason.
4. **The new renderer.** This job's proofs drew with the old renderer (classes as bare `.cls`); main's renderer now
   prints a class's control CSS with the element's `brxe` class, as Bricks does. Re-run AC1's proof (the link that is
   an inline word at 768–991 and a painted button elsewhere; drawn at 600 and at every range) and every Chrome proof
   of this job on the rebased head: does a bounded run still win where it must against the new selectors, at every
   width? A failure here is a real finding about the job's CSS on a Bricks page: fix it test-first, or stop and report
   it with the smallest repro if the cure is a design change.
5. **Cheap P3s** (each a few lines with a test, else leave recorded): R1-5 (HANDOFF's line names its exception); R1-1
   (two neighbouring bounded runs leave a gap smaller than a pixel: at a fractional width such as 767.5 neither
   `(max-width: 767px)` nor `(min-width: 768px)` matches — close it the way `src/shared/breakpoints.ts` and Bricks'
   own tiers bound ranges, if that is one small change; main had no such gap).
6. Mutate what you add (each new condition removed in turn is killed by a named assertion, never a crash) under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`).
7. **Gates** (on a `git archive` scratch copy of your head; put
   `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
   each log starts `HEAD=` and ends with one line `EXIT=`): both typechecks and `npm run check` (the parallel unit
   suite may need an 8G scope): 0 failures; this job's AC tests; the four merged jobs' own test files that touch class
   CSS or the code route (site-faq's open look, site-slider's Slider CSS, site-reviews' live widget, the renderer's
   class-CSS test, `site:check` on the code-page and elementor fixtures), each web/browser file alone under the cap,
   one Chrome job at a time, compared by name with `main` (five browser files fail on main on this desktop:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder; known flakes: the code-page fixture's 5.09 px load
   flake, `capture-windows` AC7, `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest; **known on main,
   not this job's:** the named-only `site-elementor-page-bdry` fails on main — B-Dry's footer icon list drawn 69 px off
   since Build 2026-11-10.4, its own job; say whether this job changes that number); `test/unit/plugin-convert.test.ts`;
   the five Figma replays byte-identical to `main`; `npm run corpus` the same as `main` (v1's Mac files are missing on
   this machine); B-Dry's stand-in capture
   (`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G scope):
   `npm run site` plain and `--elementor`, no `revert` outside the site-reset class, and `site:check --all` against
   main's numbers at every width (say what moved and why).
8. Records batched into your commits: the ledger (find it under `docs/plans/`; "stack 7": the conflicts and
   resolutions, the golden's regeneration with its proof, each `revert` judged, the renderer re-proof, the gates) and
   HANDOFF's section; append what you defer to `evidence/staging-fit-cancels/follow-ups.md`. Commits: plain `git commit
   -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without
   CLAUDE.md; `git ls-files .superpowers/` stays empty. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/stack-7/` (`range-diff.txt`,
   `conflicts.md`, `resolutions/`, `golden.md`, `logs/`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-s7/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). Scripts written
with Write under `~/.cache/sfc-s7/` (a restart empties `/tmp`); one `bash <file>` per Bash call; long gates on a
scratch copy, never in the worktree while you edit it. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u
earlyoom --since "-30 min" -o short-iso | grep sending`): say so, find what grew, rerun under the cap. Waits under 115
s. The PC lost power twice this week and agents can be stopped by a usage limit: write each log's `EXIT=` line (wait on
`^EXIT=`); when resumed, check `git status` for half-written tracked files (exactly 8388608 bytes) and `git cat-file`
your last commit (a commit made in the last seconds can leave empty objects: point the branch back to the last good
commit, make the content differ, commit again), read your finished logs first and never start a second driver on a
suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, the head before your own commits and the last commit (full SHAs), base; the
conflicts and resolutions; the golden: what moved and which job moved it; each `revert` on the rebased head: cancel
kind (moved, test, RED/GREEN) or exception (why); the renderer re-proof; the P3 steps done or left; mutation table;
each gate against main; B-Dry's stand-in numbers; `found_else`; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
