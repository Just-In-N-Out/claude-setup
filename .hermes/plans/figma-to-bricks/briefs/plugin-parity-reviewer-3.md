# Role: reviewer (round 3, FIX review of fixer 2's test-only commits; report only): plugin-parity

You are a fresh reviewer who never saw the build or the fixes (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path> <sha>`, extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site;
never write to any WordPress site; touch nothing under `~/Downloads`. Keep it to about 20–30 minutes: this is the job's last review round.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live).
- What failed: verifier 2 (`evidence/plugin-parity/verifier-2/ac.json`): AC9 and AC10's **cited** tests passed on 89e41a0d (proven false
  by the first auditor) and on a mutant undoing fix 1's naming; only supporting tests beside them caught it.
- Fix 2 (test-only): branch `plugin-parity-fix2`, head `d9144e8c39c0e023c3fda60fa283a56a78e14297` (test commit `ae2aebc7`; ledger and
  HANDOFF `d9144e8c`). Review `git diff beeacc8f72b1fa4c21d52f9e4ca690bf75a4c9c7..d9144e8c` (`test/unit/plugin-looks-names.test.ts`,
  `test/unit/emit-class-paste.test.ts`). Fixer's runs: `evidence/plugin-parity/fixer-2/` (a head start, not proof).

## Check hardest
1. The cited tests' names are unchanged from the plan (AC9 "a look has one name, id and settings on every page, and a new look renames
   nothing"; AC10 "shared looks add no class conflict on a re-paste, between two pages, or after a label's minimum size").
2. Each cited test, run by name: passes on d9144e8c; fails on its own assertion on 89e41a0d (its code + head's two test files, `GIT_DIR`
   set) and on the typed-names mutant; no clause the old cited tests checked was lost in the fold (`resetIds()` between helpers hides
   nothing).
3. No source file changed; `npm run check` green (8G).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/review-3/review.json` (round 3, scope delta from
`beeacc8f72b1fa4c21d52f9e4ca690bf75a4c9c7`, full SHA `head`), in review-2's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity` and quote its last line; if it asks
for another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppr3/t1`); scripts under `~/.cache/ppr3/s/`;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH";
…'`. An archive tree has no `node_modules/.bin`: call `node node_modules/typescript/bin/tsc`. Use `tail -n 3`. Waits under 115 s.
SIGTERM/143/137/"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
