# VERIFIER (read only) — flip-cards (FigmaToBricksV2)

You are a fresh, read-only verifier. You never saw the build. Change no source or test, commit nothing. Write only into
`~/.hermes/plans/figma-to-bricks/evidence/flip-cards/verifier/` (create it).

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards`, branch `worktree-flip-cards`, head
  `45b02d3` (confirm with `git rev-parse HEAD`; it must be clean). Base: `git -C <worktree> merge-base HEAD main`
  (expected `f46f8a2`).
- Approved plan (read-only, the ACs to prove): `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/plan-approved.md`.
  Its later changes and every ruling are in the worktree's plan copy and docs/HANDOFF.md ("flip-cards" sections). Note:
  fixer 2 removed the nested-link refusal from payloadProblems (now a test-only invariant): verify that's coherent.
- Findings that were fixed (confirm each is closed and caused no regression): review 1 F1–F7
  (`evidence/flip-cards/reviewer-1/`, fixed in `evidence/flip-cards/fixer-1/`), review 2 F1–F6
  (`evidence/flip-cards/reviewer-2/`, fixed in `evidence/flip-cards/fixer-2/`).

## Skills
Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, and read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER steps and the run
recipe). Format of ac.json: the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## Do
1. Re-run the gates yourself: `npm run check`; the flip browser file alone (`skipped 0`); the full browser suite compared
   by test name with main's; replays of hydraulics, GRO, debug-page-1 (scratch copy) and brainstorm, bricks.json and
   warnings.txt byte-identical to main; the corpus-skipped unit tests in scratch git-archive trees (memory note
   `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Look for regressions.
2. For every AC1–AC13: run its own test on HEAD and on the base (separate `git worktree add --detach` copy, head's test
   files copied in; one AC at a time) with the recipe (`HEAD=` first line, `EXIT=` last line), take a screenshot per AC
   (a real PNG of the browser result, or a terminal capture image for a non-visual AC), and write `verifier/ac.json`.
   AC2 rightly passes on base: give it `base_exempt` with a reason. AC13 is `(live)`: `"accepted": false,
   "not_run": "live: …"`.
3. Self-check blind: `cp` your ac.json, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh
   --repo <worktree> --base <base> --plan <plan-approved.md> <your ac.json> <scratch copy ac.json>`, fix format slips,
   then delete the copy.
- Machine: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Long gates: log with an end marker
  (`echo EXIT=$? >> log`) and wait with `until grep -q '^EXIT=' log; do sleep 2; done` (a foreground call is moved to
  the background after ~180s). Keep scratch in your own `<scratchpad>/verifier-flip-cards/` folder and copy anything
  that proves a finding into your evidence folder at once (the scratchpad can lose files).
- Justin is away: if something is unclear, research it and decide; don't stop to ask.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot,
evidence}], gates, skill_lessons[{skill, lesson, evidence}]}`. `clean` needs every AC accepted, AC13 aside. List reusable
lessons only (an empty list is normal); never edit skills or memory. End with `MAIN SESSION: check and save these
skill_lessons now.`
