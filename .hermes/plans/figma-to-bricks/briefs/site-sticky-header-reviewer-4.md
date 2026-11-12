# Role: reviewer (round 4, a delta: the HANDOFF-only rebase onto Build 2026-11-11.6; report only): site-sticky-header

You are a fresh reviewer (**Opus 5.5, high**). Review only; change nothing, commit nothing, start no agents; never load any live site.
**Time box: 20 minutes.**

## What happened
site-sticky-header was accepted (READY FOR THE USER 8/9) on `dac22907cfea2d79df9d27ef794e3521eb217e97` (base `11f07742`). Rebased onto
main `e61c0ca091413adfdca3c9b3abe4757ef2fd521f` (Build 2026-11-11.6, site-menu-motion) as branch `site-sticky-header-final3`, head
`c58e97dad13d63da794677e9274d8e6a0db9f4be`. Conflict only in `docs/HANDOFF.md` (commit `5dedb1b8 → e1458ae6`); `src/core/site/parts.ts`
auto-merged (main's `slideNotes` lines beside this job's stay note and `rootClasses`). Receipt:
`evidence/site-sticky-header/rebase/receipt-c58e97d.log` (EXIT=0). Records: `evidence/site-sticky-header/stack2/` (`conflicts.md`,
`range-diff.txt`). Justin's rule: a HANDOFF-only conflict takes a short review + the receipt.

## Check (your own worktree, `git checkout --detach c58e97da…`)
1. Outside `docs/HANDOFF.md`, the story's diff from `e61c0ca0` equals its diff from `11f07742` to `dac22907` with hunk numbers and
   `index` lines removed (`sed -E 's/^@@ -[0-9,]+ \+[0-9,]+ @@/@@/'`); for `parts.ts` (touched by both), the edits don't overlap and
   both notes are pushed; every part root lock-first, header lock → stay → fonts.
2. HANDOFF: main's sections and check-list entries (3ec, 3ed, 3ea) exactly as on main; this job's (3eb) as on the accepted head;
   nothing lost or doubled; no markers.
3. `test/web/site-sticky-header.test.ts` and `test/web/site-slide-proof.test.ts` alone under `systemd-run --user --scope -p MemoryMax=4G
   -p MemorySwapMax=0`, one at a time.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/review-4/review.json` (round 4, a delta from `dac22907`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e61c0ca091413adfdca3c9b3abe4757ef2fd521f /home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header`. Load
`requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sh4/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; write scripts with the Write tool, run as
`bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings or "none"; each check; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
