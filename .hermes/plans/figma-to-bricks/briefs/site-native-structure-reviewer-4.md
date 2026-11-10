# Role: reviewer (round 4: the move onto main and fix round 3; report only): site-native-structure

You are a fresh reviewer who never saw the build, the rebase or the fix (**Opus 5.5, high**). Review only: change no
source or test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or
other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (`site:live` only
against a local stand-in server; saved files and local fixtures only); never write to any WordPress site; no logins.
Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a capture of a real Elementor site converted with `npm run site … --elementor` and pasted
into Bricks 2.3.9 / 2.4; `site:check` and `site:live` run on such a paste; the plain route and Figma designs converting
as before), each with a concrete real-use scenario. Edge cases are P3. A P0–P2 with no concrete real-use scenario
counts as P3.

## What happened before you
The job (the website importer's `--elementor` paste becomes Bricks' Section / Container / Block, Heading, Button,
Divider and linked Image; a part's root that draws nothing is left out, "lifted") was reviewed clean three times on an
old main (`3cfc54ac`; last reviewed head `0581852c`). Four importer jobs then merged (site-faq, site-reviews,
site-slider, staging-fit-renderer; `main` is `7eeca437ea100c821bcfb82cdbbe516a023ff097`, Build 2026-11-10.4). A
finisher rebased the job onto it (31 commits, 9 conflicted, plus a hand port into main's new
`tools/lib/site-measure.ts`), and a fixer then fixed three things where the job meets the merged ones (S5-1 a merged
job's goldens regenerated; S5-2 `site:live` on a lifted part; S5-3 `site:check --whole` / `--all` read a lifted part
from its own top elements). **Nobody has reviewed the rebase's resolutions or that fix.** That is your job.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live; AC6 and AC10 amended, to be confirmed by Justin).
- Branch `site-native-structure-fix3`, head `138799bb7a8e20b37149edafcabee74d646aec60` (code head `41c0a262`; the last
  commit is records), base `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097`. In your own worktree: `git checkout
  --detach 138799bb7a8e20b37149edafcabee74d646aec60`, confirm HEAD and a clean status. Review `git diff
  7eeca437...HEAD`; the fix is `git diff 40b980ea..HEAD`; the reviewed pre-rebase story is `git diff
  3cfc54ac...0581852c`.
- The rebase record: `evidence/site-native-structure/stack-5/` (`conflicts.md`, `resolutions/` — each hand resolution's
  combined diff —, `range-diff.txt`, `changed-lines.txt`, `meet/`). The fixer's receipts (read, don't trust):
  `evidence/site-native-structure/fixer-3/` (`logs/`, `mutants/`, `golden4/`, `web-gates/`, `web-main/`, `ac14/`).
  Deferred items: `evidence/site-native-structure/follow-ups.md` (don't re-report what is recorded unless you rate it
  higher, with a scenario).
- **Known, its own job, not a finding here:** B-Dry's footer icon list `4d37935` is drawn 69 px off at every width by
  main's renderer since Build 2026-11-10.4 (`site-elementor-page-bdry` fails identically on main); a planner is on it
  (`footer-icon-list`). AC14's footer rows wait for it. Do say if you find this job makes it worse or different.

## Check hardest
1. **Each hand resolution against both sides** (`resolutions/`): `convert.ts` `Prepared`, `parts.ts` `PartResult`,
   `elementor-fold.ts` `Folded`, `classes.ts` `ClassCss`, `render.ts` (main's slider CSS line plus `wrapped`),
   `test/web/lib/site-check.ts`, `tools/site-check.ts`, the hand port in `tools/lib/site-measure.ts`, the union in
   `site-elementor-unchanged.test.ts`. Did a merged job's behaviour or this job's get dropped, doubled or reordered?
   `git range-diff 3cfc54ac..0581852c 7eeca437..40b980ea` (ledger commit aside): any commit whose own +/- lines changed
   beyond a both-sides line?
2. **Where the jobs meet in the paste** (convert fixtures and the B-Dry stand-in
   `evidence/site-native-structure/inputs/standin-capture-0581852c.json`; draw in Chrome where it matters): a carousel
   under native structure (the Slider keeps its slides as direct children; its timing, arrows, dots and slide height;
   Bricks' slider CSS survives; the Slider under a Section > Container doesn't get a width, flex or padding rule that
   changes it); a FAQ (opens the site's answers; the open look follows Bricks' open item) when its box becomes a
   Section / Container / Block; a live widget's Code element at its own place inside a lifted or native part
   (`site:check`'s stand-in still finds it); fold rules 8, 9 and 10 together; a Button or linked Image inside a slide
   or an accordion item; a lifted part that holds only a slider or only a live widget.
3. **Fix round 3.** S5-2: `site:live` finding a lifted part "by its first section's classes, narrowed to the one its
   other sections follow": on a whole-page paste where two parts start with sections of the same classes; where the
   published page has other content between or around the pasted parts; where Bricks printed the part inside
   `#brx-header` / `#brx-content` / `#brx-footer` templates; a part with one section; wrong match → a false OK or a
   false FAIL? S5-3: `readSection { top }` equal to the old wrapper's box (block, flex, grid parents; margins that
   collapse; a first section hidden at a width; a clipping parent; sticky or absolute top elements); `site:check`
   stdout and `report.json` byte for byte as main for a paste with no lifted part (prove on three fixtures). The
   read-only guard untouched (`git diff 7eeca437...HEAD -- tools/lib/read-only.ts test/browser/chrome.ts` and how
   `site-live.ts` starts and ends Chrome).
4. **S5-1's regenerated goldens are honest:** re-derive the four-tree claim on two inputs of your own choice (old base
   `3cfc54ac`, reviewed head `0581852c`, main, head; `git archive` copies): the 28 regenerated `-elementor` entries move
   only by this job's change; every `-code` entry and the saved captures are byte for byte unchanged. Any other pin in
   the repo that should have moved and didn't, or was regenerated without proof?
5. **Nothing else moved:** without `--elementor` every paste byte for byte as main (AC13: the job's 144 pins); Figma
   designs byte for byte (`test/unit/plugin-convert.test.ts`, the five replays); the merged jobs' own tests pass on
   head (read `fixer-3/web-gates/`, rerun three files of your choice, each alone under the cap).
6. The tests can fail (read the mutant receipts; one or two mutants of your own on the fix under the 4 GB cap).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md`, `references/live-site-reading.md` and `references/rendering-validation.md`, the repo
`CLAUDE.md` in the main folder (Status lines of the four merged jobs; "Architecture rules"; the `site:live` standing
rule) and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-4/review.json`, then
   self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base 7eeca437ea100c821bcfb82cdbbe516a023ff097 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-r4/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in). Scripts written with Write; probes and logs under `~/.cache/sns-r4/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Known flakes: the code-page fixture's 5.09 px load flake,
  `capture-windows` AC7, `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest. Waits under 115 s. The PC
  lost power twice this week: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw;
AC14: say what holds apart from the known footer rows), then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
