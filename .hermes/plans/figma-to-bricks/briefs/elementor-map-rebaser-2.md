# Role: fixer (rebase 2 onto web-code-page's amendment 3 head): elementor-map

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). elementor-map (reviewed clean at `c0538d8e`, review 4) is built on
web-code-page `c920728a`. web-code-page has since had fixer 3 (Justin's ruling: never a bare class name) and is now at
`f28f1dc0` (its short review is running, so it may still move). Rebase elementor-map onto it, so it merges cleanly on top,
and stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`,
never push or merge, don't bump `BUILD`, leave other worktrees alone (the web-code-page worktree
`agent-a631038f87d3d7d43` is read-only to you), start no agents. Never load bdryswi.com; no logins; never write to any
WordPress site.

**Skills to load:** `engineering-best-practices`, `test-driven-development`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch
  `worktree-agent-a93c32bbf9bbc5ed4`, head `c0538d8e`, old base `c920728a`. New base: `web-code-page-build` at
  `f28f1dc0abcf77cf75cf15edb47d8f0b8d9a945a` (same repo; `git rev-parse web-code-page-build` must equal it, else stop and report).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- What web-code-page's fix changed (read its commits `c920728a..f28f1dc0`): `src/core/site/classes.ts` `slugOf(words, page)` now needs the page
  (`pageSlugOf(finalUrl)`); a section with no words is `<page>__section`. Callers at `parts.ts` and `convert.ts`, and tests
  `site-parts.test.ts`/`site-css.test.ts`, will meet it; the typecheck catches a call missing the page. The new oracle
  `test/web/lib/class-names.ts` `bareNames` must also pass on every `--elementor` paste (add that test, test-first: RED on
  the old head if the fold route can still produce a bare name). elementor-map's own versioned names (slug + role + 4
  letters) must keep the page prefix where the slug is empty.

## Work
1. `git rebase --onto f28f1dc0 c920728a` in the worktree. On a conflict keep both sides' meaning (HANDOFF sections both
   stay). Record each conflict and how you resolved it.
2. Run `npm run check`, `npm run test:web` and `npm run test:browser` file by file under the 4 GB cap. Where an
   elementor-map expectation is stale only because of web-code-page's fixes (a wordless section now `<page>__section`), update it in its own commit with a message naming the cause; never weaken what an AC asserts. Where the two
   features really interact (the fold's versioned names meeting the page prefix), prove it with a test and
   fix it test-first; report anything you can't settle.
3. Rerun AC5, AC6, AC7 (saved stand-in:
   `F2B_ELEMENTOR_STANDIN=/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/builder/ac7/standin-capture.json`,
   read the test for the exact variable), AC8 and `npm run corpus`, the class-clash check over every pair of pastes (fixer 2's), and web-code-page's AC7 (`test/web/site-page-proof.test.ts`)
   on the rebased head to show the two together keep it. Evidence in `evidence/elementor-map/rebase-2/` (logs start
   `HEAD=`, end `EXIT=`).
4. Commits: plain `git commit -m`, no author override, no AI lines, no CLAUDE.md (`git diff --cached --name-only` first).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-rb2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time. Never edit a script a
  background run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text)
New head SHA, the commit list since `f28f1dc0`, each conflict and resolution, each expectation changed and why, any real
interaction found and fixed (test, RED/GREEN, commit), gates and AC reruns, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
