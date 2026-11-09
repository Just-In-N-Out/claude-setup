# Role: reviewer (round 2: the rebase's conflict resolution only, report only): elementor-phone-fit

You are a fresh reviewer (Opus 5.5, high). Review only: change no source or test, commit nothing, start no agents. Never
edit the main folder or other worktrees (read with `git show`). Never load any live site; no logins; never write to any
WordPress site.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3.

## Inputs
- Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/plan-approved.md`.
- The reviewed, accepted head `dab961f9c30755b1890adc478ee9fdf3d5431516` (on `7ff9ba4a`) was rebased by a finisher onto
  local `main` `103cbb37800b5f4ea7c925e7899a1a1a652d47c5` (Build 2026-11-09.1: capture-speed and site-motion merged):
  branch `elementor-phone-fit-final`, head `e94e0311603a70ec35b9b6348cab52747dd97d23`. In your own worktree:
  `git checkout --detach e94e0311…`, confirm HEAD and a clean status.
- **Scope:** `git range-diff 7ff9ba4a..dab961f9 103cbb37..e94e0311` — what changed in the rebase: one `docs/HANDOFF.md`
  conflict (top sections and the end-of-run list; this feature's block first, main's unchanged) and the ledger commits;
  `src/core/site/elementor-fold.ts` merged cleanly beside site-motion's AC15 refusal in `foldable`'s first loop (rule 8
  still closes `foldable`). Check the clean merge keeps both meanings (does site-motion's wrapper-with-a-look refusal and
  rule 8 interact on a real Elementor page with motion?), and HANDOFF keeps every section and check-list entry of both.
  Finisher receipts (read, don't trust): `evidence/elementor-phone-fit/finisher-1/`.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   103cbb37800b5f4ea7c925e7899a1a1a652d47c5 /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ep-r2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start. Heavy runs under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
