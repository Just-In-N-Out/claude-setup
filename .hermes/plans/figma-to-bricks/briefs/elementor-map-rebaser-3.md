# Role: fixer (rebase 3 onto web-code-page's amendment 4 head): elementor-map

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). elementor-map (reviewed clean at `c0538d8e`, review 4; rebase 2 at
`c853dcfb` on web-code-page `f28f1dc0`, report in `evidence/elementor-map/rebase-3/`) must move onto web-code-page `4ba9a178`
(fixer 4, Justin's "Prefix every name"; its short review is running, so it may still move). Rebase elementor-map onto it, so it merges cleanly on top,
and stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`,
never push or merge, don't bump `BUILD`, leave other worktrees alone (the web-code-page worktree
`agent-a631038f87d3d7d43` is read-only to you), start no agents. Never load bdryswi.com; no logins; never write to any
WordPress site.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch
  `worktree-agent-a93c32bbf9bbc5ed4`, head `c853dcfb`, old base `f28f1dc0`. New base: `web-code-page-build` at
  `4ba9a1782e0d36f1efd6e2322dd23df1a90274bd` (same repo; `git rev-parse web-code-page-build` must equal it, else stop and report).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- What web-code-page's fix changed (read its commits `f28f1dc0..4ba9a178`): `slugOf` now returns `<page>__…` for every
  section (worded too); roots and wrappers are `<page>__site-header|page|footer` and `<page>__site-<part>__inner`; only
  `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` keep exact names; `nameClasses` numbers repeats past every given
  name; `test/web/lib/class-names.ts` `bareNames` accepts only those four exactly or `<page>__…`, plus new `sharedNames`.
  Rebase 2 reported what will need updating: the step's own name builders (lambdas in `parts.ts` and `convert.ts`
  `siteToBricks`) if they build roots themselves (`site-page-…`, `site-page__inner-…`, `site-fonts-…` versioned names must
  take the page too, except `site-fonts`'s rule: decide by Justin's ruling that every code-method class takes the page),
  `test/unit/site-elementor-names.test.ts:123`, `test/unit/site-hidden-parts.test.ts:66`, HANDOFF example names, and a likely
  conflict in `class-names.ts` (keep web-code-page's strict checker, add only the step's versioned endings under `<page>__`).

## Work
1. `git rebase --onto 4ba9a178 f28f1dc0` in the worktree. On a conflict keep both sides' meaning (HANDOFF sections both
   stay). Record each conflict and how you resolved it.
2. Run `npm run check`, `npm run test:web` and `npm run test:browser` file by file under the 4 GB cap. Where an
   elementor-map expectation is stale only because of web-code-page's fixes (every name now under `<page>__`), update it in its own commit with a message naming the cause; never weaken what an AC asserts. Where the two
   features really interact (the fold's versioned names meeting the page prefix), prove it with a test and
   fix it test-first; report anything you can't settle.
3. Rerun AC5, AC6, AC7 (saved stand-in:
   `F2B_ELEMENTOR_STANDIN=/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/builder/ac7/standin-capture.json`,
   read the test for the exact variable), AC8 and `npm run corpus`, the class-clash check over every pair of pastes (fixer 2's), `bareNames`/`sharedNames` on every `--elementor` paste, and web-code-page's AC7 (`test/web/site-page-proof.test.ts`)
   on the rebased head to show the two together keep it. Evidence in `evidence/elementor-map/rebase-3/` (logs start
   `HEAD=`, end `EXIT=`).
4. Commits: plain `git commit -m`, no author override, no AI lines, no CLAUDE.md (`git diff --cached --name-only` first).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-rb3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time. Never edit a script a
  background run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text)
New head SHA, the commit list since `4ba9a178`, each conflict and resolution, each expectation changed and why, any real
interaction found and fixed (test, RED/GREEN, commit), gates and AC reruns, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
