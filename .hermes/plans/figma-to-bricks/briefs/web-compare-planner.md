# Planner brief: web-compare (J0, the compare tool of the website importer)

**Role:** planner (fresh Opus 5.5, xhigh) for one Full-pipeline job of the website importer. You write the job's
implementer-ready plan; you build nothing. Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): you can't ask him anything. Put questions at
the top of the plan, each with options and a ⭐ answer; the build takes the ⭐ answers (recorded as "taken under the away
grant"). Where a source is unclear, research and decide; record it as a ruling, not yet confirmed.

**Skills:** load `engineering-best-practices` and `implementation-planning` with the Skill tool; read the project skill
with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (and the `references/` it points you to).

## The job

The approved proposal is `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` (Justin's final answers at
the top, chosen for the most faithful one-to-one copy). This job is its §11 "J0: the compare tool (the oracle)" (lines 581–642). Read the whole proposal (sections 2–4,
7–10 matter to every job), then plan exactly that section's scope; the other jobs (J1…J10) are planned separately, so
note anything you need from them as a hand-over, never build it here. Also read the repo's `CLAUDE.md` (the rules
every agent follows) and `docs/specs/2026-10-06-v2-design.md`, and the proposal's evidence in
`~/.hermes/plans/figma-to-bricks/evidence/website-importer/planner/` (probes and the spike).

## Where you work

You start in your own git worktree of `~/Documents/FigmaToBricksV2` (an agent copy at `origin/main` = `dea6296`).
Write the plan there as `docs/plans/2026-10-29-web-compare.md` and commit it to your copy's branch (plain `git commit -m`,
no author override, no AI lines; check `git diff --cached --name-only` holds no CLAUDE.md). Don't push, don't bump
`BUILD`, don't edit CLAUDE.md, never bare `git stash`. Probes and saved pages go in
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/`. Report your branch name and commit SHA: the builder brings its
own copy up to that commit.

## The plan must have

- Playback in plain words, the questions (⭐) at the top, then numbered acceptance criteria **AC1, AC2…**, each with
  one named test (use the proposal's ACs for this job as the start; mark ones you add or change as **proposed**; tag
  checks only Justin can do `(live)` right after the id). Tasks a fresh agent with no context can build test-first,
  owned files, and the hand-over to wave 2.
- **General logic only** (CLAUDE.md "Build general logic"): nothing keyed on bdryswi.com or any one site's names,
  ids, classes, texts or sizes; site lists live only in data files (`corpus/web.json` as the proposal says).
- **Every fix goes in the plugin** (memory `plugin-first`): no paste-only patches.
- **This machine (Windows desktop, WSL):** read
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`. Browser tests need
  `CHROME_PATH` set to the proven wrapper (with `--disable-software-rasterizer`); without Chrome, browser tests skip
  yet exit 0, so a run counts only when it says `skipped 0`. `npm run corpus` measures nothing here: say how the
  plan's corpus/byte-identity receipts are taken (repo corpus files, replay in scratch trees).
- Live reads of public sites are fine (read only, never logged in); never write to any WordPress site.

## Report back

The plan path, branch and commit; the questions with ⭐; the ACs one line each (marking `(live)` and **proposed**);
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable lessons only; `enforce` is `none` or a one-line
check proposal; an empty list is normal; never edit skills or memory yourself), and end with:
`MAIN SESSION: check and save these skill_lessons now.`
