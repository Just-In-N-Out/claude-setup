# Role: fixer (the move onto main, and what the move needs): panel-embed-code

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). panel-embed-code (on both importer routes a pasted
Code element runs only a widget's own code; a floating widget's code is pasted only when the file that drew it is a
served tag and drew it by itself; everything else is listed, named) has finished its fix rounds on an **old** main:
branch `panel-embed-code-fix3`, head `ca7d6046e7d342f23b27ccc69e9267f95b3b3305` (23 commits), base
`f708dfb659049db50bb45df8026faabee2ee0ad7` (Build 2026-11-10.2). Two jobs have merged since, each with a build commit:
local `main` is `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4: site-slider, staging-fit-renderer).
Move this job onto it, do what the move needs, run the gates, stop at `ready-for-review`. (Fix round 3's commits
`6b115d3f..ca7d6046` have not been reviewed yet: one review will cover them and your move together.)

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging, a widget vendor's
host** or any live site (local fixture servers and saved files only); no logins; never write to any WordPress site.
Nothing paid. Nothing may hide that the importer's Chrome is automated. **Change nothing of the job's rule** (what is
pasted, what is listed): this round is the move, stale pins and records.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the stacking lines: goldens both ways, the four trees, the leaf-by-leaf diff with notes
compared by content, "run each AC's test on the new main too") with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the embeds line), and the repo `CLAUDE.md` in the main folder (the Status lines of
site-slider and staging-fit-renderer; "Website captures").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`
  (AC1–AC11; AC11 live; a planner is amending its wording beside you: not your concern). Deferred items:
  `evidence/panel-embed-code/follow-ups.md`.
- Files both sides changed since `f708dfb6`: `docs/HANDOFF.md` only.

## Your copy (you start in your own worktree)
`git checkout -B panel-embed-code-stack9 ca7d6046e7d342f23b27ccc69e9267f95b3b3305`, then `git rebase --onto main
f708dfb659049db50bb45df8026faabee2ee0ad7` (check `git rev-parse main` = `7eeca437…`; if main moved again — the job
footer-icon-list may merge while you work: a new `src/core/site/sides.ts` and two lines in `src/core/site/blocks.ts`
— use the newest main and say so). Report your branch.

## Work
1. **The rebase.** HANDOFF: every section stays, this job's first, then main's lines exactly as main has them
   (site-slider's and staging-fit-renderer's sections and end-of-run entries read their builds and ids, 3dr and 3ds);
   this job's `<panel-embed-code id at merge>` / `<at merge>` placeholders stay. Resolve the same way in every commit
   of this job that touches the file; save each hand resolution's combined diff before `git add`. A conflict outside
   `docs/` is not expected: if one appears, keep both sides' meaning, typecheck at that commit before `git rebase
   --continue`, and record it. Save `git range-diff f708dfb6..ca7d6046 main..<new head before your own commits>` and
   the patch-ids (`git show --full-index <c> | git patch-id --stable`; for a context-only conflict the `-U0`
   patch-id).
2. **Stale pins.** The job's "unchanged sums" (AC9: `F2B_UNCHANGED_SUMS=1`; recorded at the builder's Task 0 from
   `f708dfb6`) and any other recorded sum, golden or byte receipt of this job pin the old main's pastes. site-slider
   changed pastes on purpose (carousels; a note), staging-fit-renderer changed none. For each pin that fails on the
   rebased head: prove by the trees (old base `f708dfb6`, old head `ca7d6046`, new main, new head; the same saved
   inputs; where both sides changed one paste, leaf by leaf with element arrays keyed by id and notes compared by
   content) that the entry moves only by the merged job's change, then regenerate it **from the new base tree**
   (`main` in a `git archive` scratch copy, with this job's generator; never from head's output, never capturing
   again), and say which entries moved and which job moved each. And the reverse: any merged job's pin this job moves
   (site-slider's `site-slider-unchanged`; staging-fit-renderer's byte receipts): prove it moves only by this job's
   change (the panel route's notes; the capture's new fields), then regenerate through that test's own generator on
   your head. A pin that moves for any other reason is a finding: report it, change no rule.
3. **Where the sides meet** (local fixtures only; say what you probed and saw): a capture of a page with a carousel
   and a floating widget, converted on both routes (site-slider's Slider beside this job's listed or pasted widget;
   the footer's Code element); the capture's tracker (`src/web/read/tracker.ts`: the stack read and
   `Error.captureStackTrace`) under staging-fit-capture's styleless-range re-read and site-slider's capture reading
   (a slider's script-made slides and arrows: is a Splide-made box ever read as a floating widget or its stack as
   "code with no file"?); `site:check --all` / `--whole` and `site:live`'s drawing (against a local page only) on a
   paste holding this job's Code elements and empty boxes; staging-fit-renderer's `chrome.ts` additions with this
   job's capture tests. If something fails and the cure is new logic in the job's rule, **don't write it**: report
   the failing run, the smallest repro and your reading of the cause.
4. **Each AC's test on the new main too** (`git archive` of main with the test laid over): is each AC's RED still a
   RED there for the reason the plan gives (main's renderer changed how class CSS prints; this job's ACs are about
   pasted code and notes, so it should be)? Say what differs.
5. **Gates** (on a `git archive` scratch copy of your head; put
   `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
   each log starts `HEAD=` and ends with one line `EXIT=`): both typechecks (`tsconfig.sandbox.json` too) and `npm run
   check` (the parallel unit suite may need an 8G scope): 0 failures; the job's unit tests with
   `F2B_UNCHANGED_SUMS=1`, `plugin-convert`, `sandbox-convert`; the job's web files (`panel-floating-chain`,
   `floating-holds`, `tracker-stack`, `capture-floating`, `capture-embeds`, `panel-embed-code`, `tracker-style`,
   `capture-wakers`) and the merged jobs' capture and class-CSS files (site-slider's slider and carousel files,
   staging-fit-renderer's `site-live*`, `site-check-cli`, the read-only unit tests, staging-fit-capture's styled-range
   files, site-reviews' live-widget files), each alone under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0` (export variables first; no `--setenv=PATH`), one Chrome job at a time, compared by name with
   `main` (five browser files fail on main on this desktop: composition-clipping, fonts, hero-pair, peer-sides,
   pill-holder; the named-only `site-elementor-page-bdry` fails on main by the footer's 69 px, another job's; known
   flakes: the code-page fixture's 5.09 px load flake, `capture-windows` AC7, `capture-entrances` R8-1: rerun a flake
   alone before calling it a failure); the five Figma replays byte-identical to `main`; `npm run corpus` the same as
   `main` (v1's Mac files are missing on this machine); the three reviews' probes (`~/.cache/pec-r1`, `pec-r2`,
   `pec-r3`: the scripts fixer 3 kept under `evidence/panel-embed-code/fixer-3/scripts/`) re-run on your head: the
   same result as fixer 3 recorded (T1, T3 listed; nothing but self-drawing served files pasted; trackers and tag
   managers asked 0 times when the paste is drawn and clicked).
6. Records batched into your commits: the ledger (find it under `docs/plans/`; "stack 9": the rebase, each pin
   regenerated with its proof, the meet probes, the gates) and HANDOFF's section if a line needs it; append what you
   defer to `evidence/panel-embed-code/follow-ups.md`. Commits: plain `git commit -m` (or `-F <file>`), no author
   override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md; `git ls-files
   .superpowers/` stays empty. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/stack-9/` (`range-diff.txt`, `patch-ids.txt`,
   `conflicts.md`, `resolutions/`, `pins.md`, `meet/`, `logs/`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-s9/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). Scripts written
with Write under `~/.cache/pec-s9/` (a restart empties `/tmp`); one `bash <file>` per Bash call; long gates on a
scratch copy, never in the worktree while you edit it. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u
earlyoom --since "-30 min" -o short-iso | grep sending`): say so, find what grew, rerun under the cap. Waits under 115
s. The PC lost power twice this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line
(wait on `^EXIT=`); when resumed, check `git status` for half-written tracked files (exactly 8388608 bytes) and `git
cat-file -t HEAD` (a commit made in the last seconds can leave empty objects: point the branch back to the last good
commit, make the content differ, commit again), read your finished logs first and never start a second driver on a
suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, the head before your own commits and the last commit (full SHAs), base; the
rebase (pure or the conflicts and resolutions); each pin: what moved, which job moved it, the proof; where the sides
meet: what you probed and saw; each AC's RED on the new main; each gate against main; the reviews' probes on your
head; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce`
is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
