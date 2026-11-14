# Role: reviewer (round 5, short TEST-ONLY review of fixer 4's commits; report only): shared-palette

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`, extract
separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch nothing under
`~/Downloads`. **Project rule:** P0–P2 only for bugs a real paste or normal use hits, or a test that can't fail; edge cases P3. Keep it short
(30–45 minutes).

## Inputs
- Approved plan (read-only, amendment 2 installed): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md`
  (AC1–AC11; AC11 live). AC8 now says: a see-through site colour is read with its alpha and links only at the same value (alpha to 3
  places); a raw with a fallback, a raw with no variable, an unreadable light and a missing id are skipped and counted, and each skipped
  colour's id and variable are reserved so no written colour takes them.
- Review 4 was clean (MOVE ON) on `34502f91`. Fixer 4: branch `shared-palette-fix4`, head `f47a20d7814916a54617c2d048baf003f87b4991`
  (`git checkout --detach f47a20d7…`); commits 14f782e7 (19 rows added to AC8's cited test in `test/unit/site-colours.test.ts`), 56c694fc
  (`docs/plans/2026-11-11-shared-palette.md` = installed plan; HANDOFF's "The site's colours (Q2 A)" bullet), f47a20d7 (ledger). Its
  evidence: `~/.hermes/plans/figma-to-bricks/evidence/shared-palette/fixer-4/` (`mutants-14f782e.log`, `red-green.log`, `red-where.log`).

## Check
1. `git diff --stat 34502f91..f47a20d7`: nothing under `src/` or `tools/`; the test diff only adds lines.
2. The 19 rows assert every clause of amended AC8 (see-through read with alpha, 3-place comparison, each skip kind counted, ids and
   variables reserved in both tools); rerun 2–3 of the 14 mutants yourself on an export of the head (one reservation mutant, A3, and one of
   your own) and see the cited test alone fail.
3. HANDOFF's bullet and the plan copy match the head's behaviour and the installed plan (`cmp`).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-5/review.json` (round 5, scope of the fix commits from
`34502f91…` (full SHA via `git rev-parse 34502f91`), full SHA `head`), in review-4's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette` and quote its last line; if it
asks for another scope, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read both `repeat-mistakes.md` files
first (`~/.hermes/skills/software-development/figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spr5/t1`); scripts under `~/.cache/spr5/s/`;
unit tests under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Use `tail -n 3`. After SIGTERM/143/137/"Killed" check earlyoom's log first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
