# Role: reviewer (round 3, report only: the rebase onto web-code-page): elementor-map

You are a fresh reviewer who never saw the build (Opus 5.5, xhigh). Review only: change no source or test, commit nothing,
start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them by
absolute path or `git show`). Never load bdryswi.com; no logins; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real
site or normal use hits (an Elementor site's captured page pasted with `--elementor`; the code method without the flag; any
Figma design converting as before), each with a concrete real-use scenario. Edge cases are P3 (follow-ups). A P0–P2 with no
concrete real-use scenario is a P3. This is the last review round allowed for this job (cap of 3).

## What happened
elementor-map was reviewed clean at `947922e1` (built on web-code-page's `fdcda54c`) and accepted. It was then rebased onto
web-code-page's reviewed head `950972138ef0a4df8fe15a0346ab08c2637a664d`, which had fixed: the reset class named after its
rules (`site-reset-pqgx`), a site `p` that is a box pasted as a Div keeping the p's 1em margins (`kinds.ts` `boxLook`), svg
parts' computed paint written as attributes (`src/web/read/code-markup.ts`).

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- Branch `worktree-agent-a93c32bbf9bbc5ed4`, head `2afc42e73baf6066c94092ceb386e4802c0db567`, new base `95097213`. In your own
  worktree: `git checkout --detach 2afc42e7…`, confirm `git rev-parse HEAD` and a clean `git status --porcelain
  --untracked-files=all`.
- Review: (1) the three conflict resolutions — `docs/specs/web-capture.md`, `test/web/lib/site-check.ts` `settle` (two
  fixes merged: web-code-page's hold of animations, then elementor-map's bounded wait; does the checker still tell the
  truth, could it hide a real difference or hang?), `docs/HANDOFF.md`; compare with `git range-diff
  fdcda54c..947922e1 95097213..2afc42e7`; (2) the four new commits `159ad3d5` (an expectation renamed), `4de46025` (the fold
  counts the body tag's own look, `kinds.ts` `tagLook`, `elementor-fold.ts` `foldable`), `7d993703` (svg-icon accordion
  test), `2afc42e7` (docs); (3) any way the two features together break normal use that neither does alone.
- The rebaser's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/rebase-1/`.
- Earlier reviews: `evidence/elementor-map/review-1/` and `review-2/` (don't repeat a finding without a new fact; a repeat
  sets `repeats`).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-3/review.json` (ids `R3-<k>`; scope: the
rebase delta from `95097213`), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base 950972138ef0a4df8fe15a0346ab08c2637a664d /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map`
(exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-r3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time. The worktree's
  `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A foreground Bash call
  goes to the background at 120 s: keep waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
