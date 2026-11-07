# Role: reviewer (round 5, report only: the two rebases onto web-code-page's naming rulings): elementor-map

You are a fresh reviewer who never saw the build (Opus 5.5, xhigh). Review only: change no source or test, commit nothing,
start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them by
absolute path or `git show`). Never load bdryswi.com; no logins; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real
site or normal use hits, each with a concrete real-use scenario; edge cases are P3. This short round checks only what rebases 2 and 3 changed
(they carry real fix commits and conflict resolutions, so `--reviews` needs them covered).

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- Branch `worktree-agent-a93c32bbf9bbc5ed4`, head `ea3d8817ee61f25ffb671aeab64d9d84093a04c0`, base `4ba9a178`
  (web-code-page's head after Justin's rulings "Never use bare names" and "Prefix every name": every code-method class under
  `<page>__` except `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat`). In your own worktree: `git checkout --detach
  ea3d8817…`, confirm `git rev-parse HEAD` and a clean status.
- Since review 4 (clean at `c0538d8e` on base `c920728a`): rebase 2 onto `f28f1dc0`, rebase 3 onto `4ba9a178`. Check the
  replays with `git range-diff c920728a..c0538d8e 4ba9a178..ea3d8817` (3 conflicts: `parts.ts` `baseOf`, `convert.ts`
  `nameClasses` versioned vs numbering branches, `test/web/lib/class-names.ts`). New commits: `d728f3f5`, `bb063ac9`,
  `48a546d4` (bare-name tests on the step's pastes), `3c8d4bb5` (two expectations now `home__…`), `e91ec578` (the step's font
  class `<page>__site-fonts-<4>`), `52a058c8` (a wrong assertion removed), `ea3d8817` (docs). Evidence (read, don't trust):
  `evidence/elementor-map/rebase-2/`, `rebase-3/`. Rebaser's own rulings, not confirmed: the step's font class takes the page;
  `site-accordion` keeps its exact name.
- Review only that delta: the conflict resolutions keep both features' meaning (the repeat-numbering loop really runs on the
  code-method branch, the versioned branch can't give two elements one name), every `--elementor` paste's class is under the
  page or an exact shared name, two pages of one site still don't clash, the code method byte-identical without the flag, the
  FAQ accordion still 0 px / clicks right, tests can fail. A finding repeated with no new fact sets `repeats`.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-5/review.json` (ids `R5-<k>`; delta from
`c0538d8e` via the range-diff), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base 4ba9a1782e0d36f1efd6e2322dd23df1a90274bd /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-r5/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time (another job's
  verifier runs Chrome too: a browser failure seen beside it is rerun alone before judging).
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A foreground Bash call
  goes to the background at 120 s: keep waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
