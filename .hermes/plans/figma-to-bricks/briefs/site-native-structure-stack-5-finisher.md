# Finisher (step 1, in a copy): stack 5 — move site-native-structure onto the new main

You are a fresh finisher (**Opus 5.5, high**). site-native-structure (the website importer's paste becomes Bricks'
Section / Container / Block, Heading, Button and linked Image instead of "div div div") is review-clean on an **old**
main: branch `site-native-structure-fix2`, head `0581852c7fd95092ad6be1e2650cc3beb8c1808b`, base
`3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4). Four jobs have merged since, each with a build commit:
local `main` is now `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4: site-faq, site-reviews, site-slider,
staging-fit-renderer). Move this job onto it.

**This is a real rebase, not a pure one.** Files both sides changed since `3cfc54ac`: `docs/HANDOFF.md`,
`reference/bricks/README.md`, `src/core/site/classes.ts`, `src/core/site/convert.ts`, `src/core/site/elementor-fold.ts`,
`src/core/site/parts.ts`, `test/browser/render.ts`, `test/fixtures/site-elementor-code.ts`,
`test/unit/site-elementor-unchanged.test.ts`, `test/web/lib/site-check.ts`, `tools/site-check.ts`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site
(don't run `site:live` against a real address); no logins; never write to any WordPress site. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`, and the repo `CLAUDE.md` in the main folder (its Status lines for the
four merged jobs, "Architecture rules", "Finish" step 1). Read HANDOFF's sections of the four merged jobs on main
before resolving anything in the files above: you must know what each side means.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (amended; AC1–AC14 or as it lists them). Deferred items and state: `evidence/site-native-structure/follow-ups.md`.
- AC14's stand-in capture, saved at the reviewed head: `evidence/site-native-structure/inputs/standin-capture-0581852c.json`
  (sha256 starts `b01b4e08`). The reviewed head's numbers on it: 15 of 17 Buttons and 4 of 5 linked pictures stand
  alone; the page within the plan's tolerance at every width.

## Your copy (you start in your own worktree)
`git checkout -B site-native-structure-stack5 0581852c7fd95092ad6be1e2650cc3beb8c1808b`, then
`git rebase --onto main 3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (check `git rev-parse main` = `7eeca437…`; if main
moved again, use it and say so).

## Rules
- **Conflicts: keep both sides' meaning, commit by commit.** Never drop a merged job's behaviour (a FAQ's open answers
  and open look; a live widget's Code element at its own place and what it may hold; a carousel as Slider (Nestable)
  with its slides, timing and CSS; the renderer's class CSS and 2.4.2 assets; `site:check --whole`, the `{ css }`
  locator, the styleless-capture refusal) and never drop this job's (native elements, fold rule 10, the amended AC6 /
  AC10 wording). HANDOFF: every section stays, this job's first, then main's lines exactly as main has them; this job's
  `<site-native-structure id at merge>` / `<at merge>` placeholders stay.
- **Goldens and "unchanged" sums** (`test/unit/site-elementor-unchanged.test.ts` and any other recorded sums of this
  job): where a recorded value is stale only because a merged job changed the base's pastes by design, regenerate it
  from the **new base tree** (`main`, in a `git archive` scratch copy, with the job's own generator if it has one),
  never by copying head's output, and say which values moved and which merged job moved each. A value that differs on
  the rebased head for any other reason is a finding: stop on it and report.
- **Where the two sides meet in behaviour, not only in text** (probe each on the rebased head; local fixtures only):
  a slider's slides, a FAQ's items and a live widget's slot under native structure (does a slide, an accordion item or
  a widget's slot become a Section / Container / Block where the merged job needs its own element, class or place?
  does the Slider keep its slides as direct children? does the FAQ's open look still follow Bricks' open item? does
  `site:check` still find them?). The merged jobs' own tests must pass unchanged on the rebased head. If one fails and
  the cure is more than keeping both sides in a conflict (new logic), **don't write it**: stop, and report the failing
  test, the smallest repro and your reading of the cause, so the main session can send a fixer.
- Record every conflict and its resolution, commit by commit, and every regenerated value, in this job's ledger (find
  it under `docs/plans/`; `git ls-files .superpowers/` must stay empty) as the branch's last commit. A conflicted
  rebase is reviewed before the job is verified: write the record so a reviewer can check each resolution against both
  sides (`git range-diff 3cfc54ac..0581852c main..<new head before the ledger commit>` saved; for each conflicted
  commit, the hunks you resolved by hand).
- Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff
  --cached --name-only` without CLAUDE.md. `package.json`: after the rebase count each script key (no duplicate, none
  lost).

## Gates (on a `git archive` scratch copy of the new head; put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in)
1. Both typechecks (`tsconfig.sandbox.json` too) and `npm run check` (the parallel unit suite may need an 8G scope).
2. This job's AC tests (each test the approved plan names), and the four merged jobs' own test files (unit, web and
   browser: find them by the jobs' names and by what their HANDOFF sections cite), each web/browser file alone under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, one Chrome job at a time, compared by name with
   `main` (five browser files fail on main on this desktop: composition-clipping, fonts, hero-pair, peer-sides,
   pill-holder; known flakes: the code-page fixture's 5.09 px load flake, `capture-windows` AC7, `capture-entrances`
   R8-1, `site-elementor-button` pixels-at-rest: rerun a flake alone before calling it a failure).
3. `test/unit/plugin-convert.test.ts`; the five Figma replays byte-identical to `main`; `npm run corpus` the same as
   `main` (v1's Mac files are missing on this machine).
4. AC14's stand-in (8G scope): `npm run site -- <stand-in> … --elementor` and `site:check -- <stand-in> --all
   --elementor` on the rebased head against the reviewed head's numbers above; say what moved and why (the merged
   jobs change this page's FAQ, reviews and slider by design).
Each log starts `HEAD=` and ends `EXIT=`. Stop and report if anything fails that isn't a named flake.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/stack-5/` (`range-diff.txt`, `conflicts.md`,
`regenerated.md`, `logs/`), scripts under `~/.cache/sns-s5/` (written with Write; one `bash <file>` per Bash call).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-s5/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30
min" -o short-iso | grep sending`): say so, rerun under the cap. Waits under 115 s. The PC loses power now and then and
agents can be stopped by a usage limit: write each log's `EXIT=` line; when resumed, read your finished logs first and
never start a second driver on a suite one is still working through.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA); the conflicts and resolutions commit by commit, the regenerated
values and which job moved each, the ledger commit; where the sides meet in behaviour: what you probed and saw; each
gate's result against main; anything you stopped on; then `found_else`, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
