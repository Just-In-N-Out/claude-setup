# Role: reviewer (round 6, report only: the rebase onto main's HANDOFF conflict): elementor-map

You are a fresh reviewer who never saw the build (Opus 5.5, xhigh). Review only: change no source or test, commit nothing,
start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them by
absolute path or `git show`). Never load bdryswi.com; no logins; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits; edge cases are P3. This is
a short round: only the rebase onto main.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- Branch `worktree-agent-a93c32bbf9bbc5ed4`, head `1a79e64291bc063749d22c69f85cf8a1c9905c1f`, base `main` =
  `9b2488186cd3a83a3df0f5df3abd0d3c8ab8e96c` (Build 2026-11-07.1, web-code-page merged). Review 5 was clean at
  `ea3d8817` on `4ba9a178`. In your own worktree: `git checkout --detach 1a79e642…`, confirm HEAD and a clean status.
- What changed: `git range-diff 4ba9a178..ea3d8817 9b248818..1a79e642` (37 `=`, 1 `!`: commit `37fa89cf`, was `6b7ff5c1`,
  whose `docs/HANDOFF.md` hit two conflicts: the top section order and the top of "End-of-run check list"). Check also that
  `git diff ea3d8817 1a79e642` equals `git diff 4ba9a178 9b248818` file by file (no src/test/tools path differs). The
  finisher's evidence (read, don't trust): `evidence/elementor-map/finisher-1/conflicts/`.
- Check: both HANDOFF sections and both end-of-run entries are whole (elementor-map's first, then web-code-page's 3di),
  nothing dropped or duplicated, the build is main's, the code is identical to the reviewed head.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-6/review.json` (ids `R6-<k>`), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
9b2488186cd3a83a3df0f5df3abd0d3c8ab8e96c /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; no Chrome needed. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
