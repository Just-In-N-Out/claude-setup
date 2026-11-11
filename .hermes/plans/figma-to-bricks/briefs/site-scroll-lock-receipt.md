# Role: finisher (receipt only): site-scroll-lock on its rebased head

You are a fresh finisher (**Opus 5.5, high**). Change no source or test, commit nothing, start no agents; never load any live
site. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the rebase receipt format).

**Why:** site-scroll-lock was accepted on `ad5bd862…` and rebased onto main `088ee066eef9e004c6ea61516628b4719ec96304` as branch
`site-scroll-lock-final`, head `c37528ced95f707ccade6627b6a59c0e05cedfa4`, with a conflict only in `docs/HANDOFF.md`. Justin's rule
(2026-11-11): such a move takes a short review (running separately) plus a re-run of every agent-run AC's cited test on the new
head — no new verifier or auditor.

## Do
In your own worktree: `git checkout --detach c37528ce…`, clean status. Rerun every agent-run AC's cited test from the approved plan
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/plan-approved.md` (AC1–AC6; AC5/AC6 named-only with
`F2B_BASE_TREE` = a fresh `git archive` of `088ee066` with main's `node_modules` linked; each test by name, alone, Chrome ones
under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`) into
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/rebase/receipt-c37528c.log` in the receipt format (`HEAD=`
first, each test's own `ok` line, `EXIT=` last; skipped 0).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/slx/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (`pgrep -f
'[u]ser-data-dir=<path>'`); piped/chained git commands may be refused (script files; `git -C <absolute path>`). Use `tail -n 3`.
Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep
-E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
The receipt path and its last line; any test that failed and its alone-rerun; `skill_lessons[]`, ending with: `MAIN SESSION:
check and save these skill_lessons now.`
