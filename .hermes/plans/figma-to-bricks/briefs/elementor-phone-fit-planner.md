# Role: planner (Mini pipeline): elementor-phone-fit (website importer)

You are a fresh planner (Opus 5.5, high) for FigmaToBricksV2. Write an implementer-ready plan; change no source or test,
commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` (read it, or use your
own worktree). **Never load bdryswi.com** or any live site; no logins; never write to any WordPress site. Nothing paid.

**Skills:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md`, `references/rendering-validation.md`),
`engineering-best-practices`, `implementation-planning`, `systematic-debugging` (this is a bug: prove the root cause with
file:line evidence before proposing a fix). Read the repo `CLAUDE.md` (architecture, "Build general logic": nothing keyed
on B-Dry) and `feature-dispatch/references/mini-pipeline.md` (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/`).

## The job (Justin, 2026-11-08: "Accept, fix 7.59 px later" → this job, Mini)
With `--elementor`, `npm run site`/`site:check` on B-Dry's saved home (the 2026-10-29 page served offline; the web-code-page
AC9 stand-in, `test/web/site-page-bdry.test.ts` and `test/web/site-elementor-bdry.test.ts` name its variables) leaves the
page part **7.59 px** off the site at the 390 width, while the plain code route is within ~1 px. elementor-map's Status
line promised "within 2 px at every width". It is there on `main` `7ff9ba4a` (Build 2026-11-08.1) already, before
site-motion. Find why, as a general rule for Elementor pages, and plan the fix so the Elementor route is within 2 px at
every width the checks measure, with the plain route and Figma designs unchanged.

## Inputs
- Base: local `main` `7ff9ba4aa7f03e3c761a8814fb1ad4021dd51373`. Two jobs will merge before this builds: capture-speed
  (`capture-speed-build`, head `e455130b`: capture-side only) and site-motion (`worktree-agent-acb4df7f943f7bd4c`, head
  `85a1f2fe`: touches `src/core/site/convert.ts`, `classes.ts`, `elementor-fold.ts`, `test/browser/render.ts`). Note
  overlaps your fix would have with site-motion's files.
- Measurements (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/verifier/ac11-out/ac11-elementor-still.json`
  and `verifier/supporting/ac11-still-probe.log` (the 7.59 px at 390 on base's converter). elementor-map's plan and ledger:
  `docs/plans/2026-11-06-elementor-map.md`, `-ledger.md`; its follow-ups:
  `~/.hermes/plans/figma-to-bricks/evidence/elementor-map/follow-ups.md` (one is "below 320 px an accordion's open look is
  lost"). The saved stand-in capture elementor-map used: `evidence/elementor-map/builder/ac7/standin-capture.json`.
- Run what you need to find the cause (the B-Dry named tests, a per-element diff at 390 between site and paste), under
  the machine rules below.

## Plan
Write `~/.hermes/plans/figma-to-bricks/elementor-phone-fit.md`: playback; root cause with file:line evidence and which
element(s) carry the 7.59 px; the general rule; numbered ACs **AC1, AC2…** marked **(proposed)**, one named test each
(at least: B-Dry's Elementor route within 2 px at every measured width, named-only; a generic fixture showing the cause,
RED on base; the plain route and the five Figma replays byte-identical; no other Elementor fixture worse); tag `(live)`
any AC only Justin can check (e.g. his paste at 390 on B-Dry staging); tasks test-first; questions at the top with a ⭐
answer each (the standing auto-go takes the ⭐ answers).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ep-p/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written
  with Write.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.
- After a machine restart, check tracked files of exactly 8388608 bytes (`git status`) before trusting a run.

## Report (as text)
The plan path, the root cause in two lines, the ACs one line each (mark live ones), the questions with ⭐ answers, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
