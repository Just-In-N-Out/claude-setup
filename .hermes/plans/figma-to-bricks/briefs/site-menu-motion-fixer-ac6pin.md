# Role: fixer (test pin only): site-menu-motion — AC6's named pin compares the paste without the scroll lock

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `test-driven-development`, the project skill's
`references/testing-pitfalls.md`. Never load any live site; never write to any WordPress site; touch nothing under `~/Downloads`.
Commit to the branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.

## State
`site-menu-motion-final`, head `15853c2cf26f994a20958b3ff40e56f23ba00ebf` (rebased onto main `11f07742`, Build 2026-11-11.5; only
`docs/HANDOFF.md` conflicted). The receipt
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/rebase/receipt-15853c2.log` ends `EXIT=1`: AC6's named test
"Justin's scan of today converts byte for byte as on main" (env `F2B_SITE_SLIDE_BDRY`) pins main-02481763 sums (`5500e42b…`,
`012efa47…`); site-scroll-lock (11.5) adds its lock class to every paste, so the head's sums are `cf45187b…`/`fd5b4047…`, equal to
main `11f07742`'s; with the lock taken out (`test/web/lib/scroll-lock.ts` `unlocked`) they equal the pins
(`rebase/ac6-unlocked-15853c2.log`).

## Do
1. Your own worktree: `git checkout -B site-menu-motion-final2 15853c2c…`.
2. Change only that test: compare each paste with its lock taken out (the same `unlocked` rule site-scroll-lock's pins use) against
   the pinned sums; the test's name stays; its comment says why. RED: the test as it is fails on `15853c2c`; GREEN after. Mutant: a
   paste with a changed byte outside the lock still fails it. Commit.
3. Rerun every agent-run AC test (AC1–AC6, AC6's named receipt with
   `F2B_SITE_SLIDE_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/builder/bdry-capture.json`) on the new
   head into `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/rebase/receipt-<head7>.log` (`HEAD=` first, each
   `ok` line, `EXIT=` last; skipped 0; Chrome under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`).
   `npm run check` (8G scope).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/smp/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; write scripts with the Write tool,
run as `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
New head (full SHA); RED/GREEN/mutant; receipt path and last line; gate; `skill_lessons[]`, ending with: `MAIN SESSION: check and
save these skill_lessons now.`
