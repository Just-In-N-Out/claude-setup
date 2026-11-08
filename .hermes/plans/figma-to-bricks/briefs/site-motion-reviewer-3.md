# Role: reviewer (round 3, fix commits only, report only): site-motion

You are a fresh reviewer who never saw the build (Opus 5.5, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a captured site page pasted into Bricks 2.3.9 by `npm run site`, with or without
`--elementor`, and its animations, hovers, focus looks and entrance animations; Figma designs converting as before), each
with a concrete real-use scenario. Edge cases go in as P3. A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md` (AC4, AC7).
- Branch `worktree-agent-acb4df7f943f7bd4c`, head `85a1f2fe36124135c6f37c8d1a0b7b9d655b09ec`, base
  `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373` (`main`). In your own worktree: `git checkout --detach 85a1f2fe…`, confirm
  `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`.
- **Scope (round 3): only the fix commits since round 2's head and what they touch:** `git diff 13a336a00dc2162fe4884330311fe3f14a9aa5c4..HEAD`
  (`242c0f60` renderer, `eec3129a` the rule, `55d18ba3` fixture/proof/HANDOFF, `d257827f` a test case, `38ee173a`
  formatting, `85a1f2fe` ledger), plus the code they call (`src/core/site/motion.ts` `entranceOf`/`startsHidden`/`hides`,
  `test/browser/render.ts` `hiddenOnLoad`, `tools/lib/site-motion-live.ts`).
- Round 2 (`evidence/site-motion/review-2/review.json`) found R2-1 P2: Bricks prints `data-interaction-hidden-on-load`
  only for a type holding "In", so an entrance named `rise`/`fadeUp` flashed before it played. Justin chose "Fix it, then
  merge". Fixer 2's rule: an entrance whose start look (first keyframe, or last when reversed, over the rest look) has
  opacity 0 or visibility hidden and whose site name lacks a capital "In" takes the type `<paste name>In` (e.g.
  `home__fade-up-abcdIn`), never an animate.css name; frames still play by `.c.brx-animate-<type>`; the renderer and the
  AC14 live check print/ask the mark only where Bricks' PHP does. AC4/AC7 unit pins `rise`/`fade` changed to the new type.
  Receipts (read, don't trust): `evidence/site-motion/fixer-2/`.
- Check: does the new type reach Bricks 2.3.9 and play the site's frames (does `brx-animate-<type>` with that name, and
  animate.min.css's `[data-animation*=In]`, behave as claimed in `reference/bricks/frontend-2.3.9/`); a clash between two
  pastes; the renderer still matching Bricks (not hiding another bug); the pin changes honest against AC4/AC7; the tests
  failing without the fix; Figma designs untouched.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Hover, focus and motion") and `references/rendering-validation.md`, the repo
`CLAUDE.md` and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format).
1. Review the scoped diff for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/review-3/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion` (exit 2 means
   your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-r3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after.
  The worktree's `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written
  with Write, paths spelled out.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
