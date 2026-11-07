# Role: fixer (round 1): elementor-map

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). Fix review 1's P2 findings test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or
merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com; no logins; never write to
any WordPress site.

**Skills to load:** `receiving-code-review` (verify each finding before fixing; push back with evidence on any that doesn't
hold), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` for the fold guards. Read the
project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`
and `references/live-site-reading.md`, and the repo `CLAUDE.md` ("Build general logic": nothing keyed on B-Dry).

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a93c32bbf9bbc5ed4`, branch
  `worktree-agent-a93c32bbf9bbc5ed4`, head `220cb331`, base `fdcda54c` (don't rebase).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-1/review.json`. The reviewer's probes:
  `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/a492f614-99ad-4c9d-89a6-3356eed047b1/scratchpad/probe/` and
  `/home/justin/.cache/em-r/`. Builder's evidence: `evidence/elementor-map/builder/` (B-Dry stand-in capture, the per-section
  table script `builder/scripts/sections-table.ts`).

## Fix (P0–P2 only; the P3s R1-5…R1-10 go to `evidence/elementor-map/follow-ups.md` and HANDOFF "Deferred")
1. **R1-1** (`elementor-fold.ts` rule 6 / `NEUTRAL_SIZE`): a margin moving onto the merged element must refuse the fold (or
   stay equivalent) when the widget box sets width/max-width 100%. Generic test, then B-Dry's "Contact us today" and
   "Schedule A Consultation" measured section by section within 2 px with `--elementor`.
2. **R1-2** (merge (g)): a folded replaced element in a CSS grid must not set its column's minimum (or the fold refuses).
   Generic test with a grid of image widgets wider than their columns; B-Dry's three-photo band within 2 px.
3. **R1-3** (`elementor-accordion.ts:52`): items need to be alike only in the item, the title subtree and the panel
   element; answers may differ in content (paragraph count, a list). Replace the test that locks the old behaviour.
4. **R1-4** (`openLook`): the open look must not take styles that come from the item's place (first/last, sibling
   rules): compare the open item with closed items at comparable places, or drop declarations explained by position.
   Generic test with the first item open and a "no top border after the first" rule; check after a click.
Each: RED saved, then GREEN, commit after each (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md). Rerun
the per-section B-Dry table with and without `--elementor` and record it in HANDOFF (correct the wrong cause it names), plus
AC5/AC7/AC8's tests and `npm run check`. Evidence in `evidence/elementor-map/fixer-1/` (logs start `HEAD=`, end `EXIT=`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-f/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text)
Per finding: fixed (test, RED/GREEN logs, commit) or rejected (evidence); head SHA; the section table; gates; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
