# Role: planner (Mini pipeline): elementor-footer-fit (website importer)

You are a fresh planner (Opus 5.5, high) for FigmaToBricksV2. Write an implementer-ready plan; change no source or test,
commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` (read it, or use your
own worktree). **Never load bdryswi.com** or any live site; no logins; never write to any WordPress site. Nothing paid.

**Skills:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md`, `references/rendering-validation.md`),
`engineering-best-practices`, `implementation-planning`, `systematic-debugging` (a bug: prove the root cause with
file:line evidence). Read the repo `CLAUDE.md` ("Build general logic": nothing keyed on B-Dry) and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`.

## The job (Justin, 2026-11-08: "Separate job for footer" → this job, Mini)
With `--elementor`, B-Dry's saved home's **footer** is 51.89 px off the site at the 1025 width (on `main` and with
elementor-phone-fit alike): widget `f2bd68b` (elementor-map's open "Facebook" row, in its HANDOFF section) has a holder
182 px tall but its `p` is 130 px; its widget box is stretched in a flex row, and once folded the `p` itself would be
stretched (or not), so the paste's footer differs. Find why, as a general rule for Elementor pages (the builder's scan
suggests "a wrapper measured taller than its body + inner margins + its padding refuses the fold"; prove or replace it),
and plan the fix so every part (header, page, footer) is within 2 px at every width the checks measure, with the plain
route and Figma designs unchanged.

## Inputs
- **Builds on elementor-phone-fit** (accepted soon; branch `elementor-phone-fit-build`, head
  `7b7d345fb0914b97371323294462c0e844a0c928`, base `7ff9ba4a`; plan `docs/plans/2026-11-08-elementor-phone-fit.md`
  there): it adds fold rule 8 "Margin boxes" (`marginBoxes`) at the end of `foldable` in `src/core/site/elementor-fold.ts`.
  Plan your rule as rule 9 against that head. Main is now `99ff06f4` (capture-speed); site-motion (branch
  `site-motion-fix4`/later, touches `elementor-fold.ts`'s first loop) merges before both.
- The builder's receipts: `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/builder/`
  (`footer-hold/scan.txt`, `ac1/green-head-fresh.log`, `ac1/red-base-geometry.log`), the fresh v2 stand-in
  `builder/ac1/head-fresh/standin-capture.json` (check `web.code.version` before reusing any stand-in), the AC1 test
  `test/web/site-elementor-page-bdry.test.ts` at `7b7d345f`.
- Measure **every part** (header, page, footer) at every width on base and with your probed rule, not only the footer.

## Plan
Write `~/.hermes/plans/figma-to-bricks/elementor-footer-fit.md`: playback; root cause with file:line evidence; the general
rule; numbered ACs **AC1, AC2…** marked **(proposed)**, one named test each (at least: B-Dry's Elementor whole page within
2 px at every measured width, named-only; a generic fixture showing the cause, RED on base; the plain route and the five
Figma replays byte-identical; no other Elementor fixture worse); `(live)` for any AC only Justin can check (his paste on
B-Dry staging at 1025); tasks test-first; questions at the top with a ⭐ answer each. Paste check id: `<elementor-footer-fit
id at merge>`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-p/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome you
  start. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written
  with Write.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.
- After a machine restart, check tracked files of exactly 8388608 bytes (`git status`) before trusting a run.

## Report (as text)
The plan path, the root cause in two lines, the ACs one line each (mark live ones), the questions with ⭐ answers, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
