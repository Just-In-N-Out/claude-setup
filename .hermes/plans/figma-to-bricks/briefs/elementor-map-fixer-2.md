# Role: fixer (round 2: rebase + R3-1): elementor-map

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). First rebase elementor-map onto web-code-page's new head, then
fix review 3's P2 finding R3-1 test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other worktrees
alone (web-code-page's worktree `agent-a631038f87d3d7d43` is read-only to you), start no agents. Never load bdryswi.com; no
logins; never write to any WordPress site.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md` ("Build general logic"; ids are deterministic).

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch
  `worktree-agent-a93c32bbf9bbc5ed4`, head `2afc42e7`, current base `95097213`.
- New base: `web-code-page-build` at `c920728a2355240119304f890236bdf315a21176` (check `git rev-parse web-code-page-build`; if
  it differs, stop and report). Its new commits `95097213..c920728a`: plan amendment 2, `tools/capture.ts` Chrome finder,
  AC20's ink oracle, fonts `declaredAs`/`siteFaces`, HANDOFF and spec.
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-3/review.json` (R3-1 P2; R3-2…R3-4 P3) and
  Justin's ruling `review-3/justin.json`: **fix R3-1 now**. The reviewer's probes: `/home/justin/.cache/em-r3/probe-which.ts`,
  `probe-classes.ts`.

## Work
1. `git rebase --onto c920728a 95097213`. Keep both sides' meaning on any conflict (HANDOFF sections both stay). Record each
   conflict and resolution. Run `npm run check` and the elementor-map web tests; stop and report if anything new fails.
2. **R3-1:** with `--elementor`, classes must never share a name (and so an id) with the whole-page paste's classes while
   holding other settings. General rule (no B-Dry names): give the Elementor route's classes their own names, e.g. named
   after their settings the way `classes.ts` `versioned` names the reset, or a route suffix; pick the smallest rule that
   makes "a class two pastes share has the same name, id and settings" true for any pair of the importer's pastes of one
   capture. Test first: a unit test converting a marker-carrying capture with `siteParts()` and with the `--elementor` route
   that fails when a name in both has different settings (RED on `2afc42e7`), and B-Dry's stand-in probe (the 9 of 14 names)
   after. Mutate the guard. Also name the Import classes dialog in HANDOFF's AC10 steps (what to press and why). Keep the
   plan's naming ruling's spirit (the section's slug, then a role); if the rule you need changes what Justin sees in Bricks'
   class list, say so plainly in the report.
3. Put R3-2, R3-3, R3-4 in `evidence/elementor-map/follow-ups.md` and HANDOFF "Deferred".
4. Rerun AC5, AC6, AC7 (saved stand-in:
   `F2B_ELEMENTOR_STANDIN=/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/builder/ac7/standin-capture.json`,
   read the test for the exact variable), AC8, `npm run check`, `npm run corpus`, `test:web` and `test:browser` file by file
   under the 4 GB cap, and web-code-page's AC7 and AC20 (`test/web/site-page-proof.test.ts`). Evidence in
   `evidence/elementor-map/fixer-2/` (logs start `HEAD=`, end `EXIT=`).
5. Commits: plain `git commit -m`, no author override, no AI lines, no CLAUDE.md (`git diff --cached --name-only` first).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-f2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time. Never edit a script a background
  run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- A foreground Bash call goes to the background at 120 s: keep waits under 115 s.

## Report (as text)
New head SHA; rebase conflicts and resolutions; R3-1: fixed (test, RED/GREEN logs, commit, mutants) or rejected (evidence);
what changes in Bricks' class list; gates; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never
edit skills or memory), ending with `MAIN SESSION: check and save these skill_lessons now.`
