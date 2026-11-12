# Role: reviewer (round 2, a delta: the HANDOFF-only rebase onto Build 2026-11-11.6; report only): plugin-header-footer-ticks

You are a fresh reviewer (**Opus 5.5, high**). Review only; change nothing, commit nothing, start no agents; never load any live site.
**Time box: 20 minutes.**

## What happened
plugin-header-footer-ticks was accepted (READY FOR THE USER 5/6) on `c0e04ef4a1d5b6580203e822ad36fff06ec33b83` (base `e61c0ca0`). Rebased onto
main `9f75e8ac800cc49d84625a7b437e796b48f18dc5` (Build 2026-11-11.7, site-sticky-header) as branch `plugin-header-footer-ticks-final`, head
`b61f0d57d8bcbf87c059ea99a8c8367765409ee9`. Conflict only in `docs/HANDOFF.md` (commit `abe7a104 → 94503c55`); no source or test file conflicted. Records: `evidence/plugin-header-footer-ticks/rebase/` (`conflicts.md`, `range-diff.txt`). Justin's rule: a HANDOFF-only conflict takes a short review + the receipt.

## Check (your own worktree, `git checkout --detach b61f0d57…`)
1. Outside `docs/HANDOFF.md`, the story's diff from `9f75e8ac` equals its diff from `e61c0ca0` to `c0e04ef4` with hunk numbers and
   `index` lines removed (`sed -E 's/^@@ -[0-9,]+ \+[0-9,]+ @@/@@/'`).
2. HANDOFF: main's sections and check-list entries (3eb, 3ec, 3ed, 3ea) exactly as on main; this job's (`<id at merge>`) as on the accepted head;
   nothing lost or doubled; no markers.
3. `test/browser/panel.test.ts` alone under `systemd-run --user --scope -p MemoryMax=4G
   -p MemorySwapMax=0`, one at a time.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/review-2/review.json` (round 2, a delta from `c0e04ef4`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
9f75e8ac800cc49d84625a7b437e796b48f18dc5 /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks`. Load
`requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ph4/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; write scripts with the Write tool, run as
`bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings or "none"; each check; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
