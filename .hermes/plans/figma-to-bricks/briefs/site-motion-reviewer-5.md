# Role: reviewer (round 5: fix commits only, report only): site-motion

You are a fresh reviewer who never saw the build (Opus 5.5, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins. Nothing may
hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture -- <a real site>` then `npm run site` with or without `--elementor`, its
animations, hovers, focus looks and entrances in Bricks 2.3.9; captures as fast and as correct as capture-speed made them;
Figma designs converting as before), each with a concrete real-use scenario. Edge cases are P3.

## Inputs
- Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md`
  (Amendments first; AC4, AC15). capture-speed's in-repo plan now has Amendment 1 on AC8 (Justin: "Count per look, speed
  later (Recommended)", `evidence/site-motion/fixer-3/justin-ac8.json`).
- Branch `site-motion-fix5`, head `325800747bb29432297dc841b3ad05eb8abdd2ce`, on local `main`
  `99ff06f46a53fe9f43cfa456e1d42a685bbc36c7`. In your own worktree: `git checkout --detach 32580074…`, confirm
  `git rev-parse HEAD` and a clean status.
- **Scope (round 5): only the fix commits since round 4's head and what they touch:** `git diff 325d1f8b..HEAD`
  (`75c2f76f` fix + tests, `fea60aa3` plan Amendment 4 + drawing cases in the AC4/AC7 unit tests, `cd4ac623` HANDOFF,
  `32580074` ledger), plus the code they call (`src/core/site/classes.ts` `stillCss`/`heldStill`/`customCss`,
  `src/core/site/convert.ts` held frames for a non-entrance finite animation).
- Round 4 (`evidence/site-motion/review-4/review.json`) found R4-1 P2: under reduced motion a drawing (svg, iframe, video
  as a Code element) whose own finite animation fades it in stayed paused on its first frame (opacity 0). Fixer 5's rule:
  under reduced motion a finite animation left in an element's own rules stops (`animation: none !important`) and a
  forwards/both fill shows its end frame at once; endless animations keep the paused rule; box entrances paste byte for
  byte as before. Receipts (read, don't trust): `evidence/site-motion/fixer-5/`.
- Check: the drawing now shows under reduced motion and still plays with motion; no endless animation or box entrance
  changed; the end frame is the site's; Amendment 4's text honest (the approved copy is now the plan at `32580074`);
  the tests fail without the fix; Figma designs untouched.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/review-5/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   99ff06f46a53fe9f43cfa456e1d42a685bbc36c7 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-r5/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
