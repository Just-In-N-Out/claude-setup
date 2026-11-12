# Role: reviewer (round 2, a delta: the move onto Build 11.5 and one test-pin commit; report only): site-menu-motion

You are a fresh reviewer (**Opus 5.5, high**). Review only; change nothing, commit nothing, start no agents; never load any live
site; never write to any WordPress site. **Time box: 25 minutes.**

## What happened
site-menu-motion was accepted on `4f0882b1f7c51b52c464e6eff878518b78ba502c` (base `02481763`). Rebased onto main `11f07742`
(Build 2026-11-11.5: media-clickable + site-scroll-lock) as `15853c2c` with a conflict **only in `docs/HANDOFF.md`** (this job's
section first; check list 3ec, 3ed, 3ea). Then one commit `bc793b50f60afc4bae6ea121731fd80336bae588` (branch
`site-menu-motion-final2`) changes only `test/unit/site-slide.test.ts`: AC6's named pin compares each paste with site-scroll-lock's
lock class taken out (`test/web/lib/scroll-lock.ts` `unlockedParts`) against the unchanged main-02481763 sums, and first asserts
the paste holds the lock. Justin's rule (2026-11-11): a HANDOFF-only conflict and such a test-only pin update take a short review +
an AC re-run (receipt: `evidence/site-menu-motion/rebase/receipt-bc793b5.log`, EXIT=0). Records:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/rebase/` (`conflicts.md`, `range-diff.txt`, `ac6pin/`).

## Check (your own worktree, `git checkout --detach bc793b50…`)
1. Outside `docs/HANDOFF.md` and `test/unit/site-slide.test.ts`, the story's diff from `11f07742` equals its diff from `02481763` to
   `4f0882b1` with hunk numbers removed (`sed -E 's/^@@ -[0-9,]+ \+[0-9,]+ @@/@@/'`); list the files main and the story both touched
   and check their edits don't overlap (`parts.ts`: the slide-notes line vs scroll-lock's lines).
2. HANDOFF: main's two sections and check-list entries exactly as on main; this job's as on the accepted head; nothing lost or
   doubled.
3. The pin change: it still fails on any byte changed outside the lock and when the lock is missing (one mutant of your own); the
   receipt's AC6 line is its own `ok`.
4. Together: `test/web/site-slide-proof.test.ts` and `test/web/site-scroll-lock.test.ts` alone under `systemd-run --user --scope -p
   MemoryMax=4G -p MemorySwapMax=0` — the drawer's slide and the lock's no-scroll lines meet cleanly.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/review-2/review.json` (round 2, a delta from `4f0882b1`; full
SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base <full SHA of 11f07742> /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion`. Load
`requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sm2/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; write scripts with the Write tool,
run as `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings or "none"; each check; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
