# Role: fixer (round 1): web-code-page

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). Fix review 1's P2 findings test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or
merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com; no logins; never write to
any WordPress site.

**Skills to load:** `receiving-code-review` (verify each finding before fixing; push back with evidence on any that doesn't
hold), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` ("Build general logic"; Bricks paste rules) and `reference/bricks/README.md`.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`, branch `web-code-page-build`,
  head `59a3cd63`, base main `ea504778` (don't rebase). Note: another job (elementor-map) is built on top of this branch;
  keep changes focused so it rebases cleanly.
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md` and Justin's slider
  ruling `evidence/web-code-page/justin-q4-slider.md`.
- Review: `evidence/web-code-page/review-1/review.json`; the reviewer's probes are in the scratchpad it names
  (`probes/svg-paint.ts`, `probes/p-box.ts`). Builder's evidence: `evidence/web-code-page/builder/`.

## Fix (P0–P2; the P3s R1-4…R1-7 go to `evidence/web-code-page/follow-ups.md` and HANDOFF "Deferred")
1. **R1-1** (`src/web/read/code-markup.ts:38`): an svg's inner parts must keep their paint: carry the computed or rule-based
   paint (fill, stroke, stroke-width, opacity…) the page gives each part, generically (descendant selectors, the svg's own
   `<style>`, inline `style`). Generic fixture svg painted only by page CSS; a test comparing every part's computed fill and
   stroke on the site page and the drawn paste; B-Dry's highlighted headline ("Over 60 Years", marker circle) as named evidence.
2. **R1-2** (`src/core/site/kinds.ts:44`, 52–55): a site `<p>` (or any element the parser auto-closes around a block) that
   becomes a box must not split in rich mode: pick a tag/structure that keeps its words and class inside. Test that each drawn
   element's parent is the one the payload names.
3. **R1-3** (`docs/HANDOFF.md:85`, `src/core/site/classes.ts:14`): the changed reset must not be silently kept by Bricks'
   "Import classes" dialog: rename the reset class when its CSS changes (preferred, e.g. a versioned name, with a test that a
   changed reset gets a new name and id) and fix HANDOFF's AC12 steps to name the dialog and the choice.
Each: RED saved, then GREEN, commit after each (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md). Then
rerun AC7 (`site-page-proof`), AC9/AC17/AC18 (`site-page-bdry`, named-only, with the builder's saved stand-in), `npm run
check` and the five replays byte-identical. Evidence in `evidence/web-code-page/fixer-1/` (logs start `HEAD=`, end `EXIT=`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-f/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Keep wait loops
  under 115 s.

## Report (as text)
Per finding: fixed (test, RED/GREEN logs, commit) or rejected (evidence); head SHA; gates; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
