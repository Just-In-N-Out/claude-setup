# Role: reviewer (round 5, report only (Amendment 4 fix commits only; one short review allowed by Justin's ruling)): web-code-page

You are a fresh reviewer who never saw the build (Opus 5.5, xhigh). Review only: change no source or test, commit nothing,
start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them by
absolute path or `git show`). Never load bdryswi.com; no logins; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real
site or normal use hits (a captured site's whole page pasted into Bricks with `npm run site`: header, page and footer; the
`site:check` measurement telling the truth; any Figma design converting as before), each with a concrete real-use scenario.
Edge cases go in as P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md` (AC1–AC19
  with Amendment 1; AC12 and AC19 live, Justin's). Justin's later ruling replacing Q4 A:
  `evidence/web-code-page/justin-q4-slider.md` (a slider keeps its own slides; only the script's loop copies are left out).
- Branch `web-code-page-build`, head `4ba9a1782e0d36f1efd6e2322dd23df1a90274bd`, base main `ea504778` (`git rev-parse
  ea504778`). In your own worktree: `git checkout --detach 4ba9a178…`, confirm `git rev-parse HEAD` and a clean status. Review
  `git diff ea504778...HEAD` (a large diff: prioritise `src/core/site/`, `src/web/read/`, `src/web/code.ts`, the tracker,
  `tools/site*.ts`, `test/web/lib/site-check.ts`, and anything under `src/core` outside `site/` that could change Figma output).
- Builder's receipts (read, don't trust): `evidence/web-code-page/builder/`. Saved B-Dry stand-in and Justin's 11-04 capture
  as the plan names them (read-only).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` (architecture rules; Bricks paste rules such as whole-hundred font
weights, layout keys by element, no `_alignSelf: stretch`, no element-id in custom CSS; "Build general logic") and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the
`review.json` format).
1. Review for real bugs: pastes Bricks would refuse or misprint, CSS lost or applied to the wrong element across the three
   parts and the one class table, alt text (`altText`) wrong, markers leaking into the paste, the slider ruling, the
   checker's new rules (clipped boxes skipped, scroll-through, held animations) hiding real differences, the Figma converter's
   byte identity, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/review-5/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base ea504778
   /home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page` (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-r5/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time. The worktree's
  `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Keep wait loops under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
## Round 5 specifics
- Round 4 (at `f28f1dc0`) was clean; its P3 R4-1 asked whether word-named classes count as bare. Justin ruled
  (`evidence/web-code-page/justin-r4-1-prefix.md`): "Prefix every name". Fixer 4 built **Amendment 4** (in `plan-approved.md`):
  commits `f28f1dc0..4ba9a178` (`e2228d62` rule + tests, incl. `nameClasses` numbering past every given name; `85f5a960` plan;
  `c802b93d` HANDOFF/spec; `4ba9a178` ledger). Evidence: `evidence/web-code-page/fixer-4/`. Roots are now
  `<page>__site-header|page|footer` (fixer's own decision under "every code-method class").
- Review only that delta and what it touches: every class but `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` under
  `<page>__`; the renamed roots still matched by everything that finds them (the checker `site:check`, scripts, slider/menu
  code, `tools/site*.ts`, HANDOFF steps); the new numbering never giving two sections one name nor changing a name needlessly;
  nothing else in any paste changing; Figma converter byte identity; the new tests can fail. A finding repeated with no new
  fact sets `repeats`.
- Ids are `R5-<k>`. Self-check with `review-check.sh` as in round 1.
