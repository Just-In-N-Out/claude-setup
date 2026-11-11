# Role: finisher (step 1: rebase + receipt): site-scroll-lock onto Build 2026-11-11.4

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the rebase receipt section) and the repo
`CLAUDE.md` "Finish" step 1. Never load any live site; never write to any WordPress site; touch nothing under `~/Downloads`.
Commit to the branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.

## State
`site-scroll-lock` is accepted (`ac-check.sh --reviews`: READY FOR THE USER 6/7) on head
`ad5bd862faeae4ed025df224a9bf966198ef71a1` (branch `site-scroll-lock-build`) on base `02481763`. Local `main` is now
`088ee066eef9e004c6ea61516628b4719ec96304` (Build 2026-11-11.4 = media-clickable: `src/core/site/background.ts` new,
`src/core/site/convert.ts`, `test/browser/render.ts`, `test/unit/render.test.ts` LP6, HANDOFF, ledger).
**Do not add a ledger commit** (the ledger moves into `docs/plans/` in the merge's build commit on main, so a pure rebase
stays a pure rebase of the accepted head).

## Do
1. In your own worktree: `git checkout -B site-scroll-lock-final ad5bd862…`, then `git rebase 088ee066…`. Record whether any
   conflict was resolved (HANDOFF: both sections stay, this job's first; any source conflict: keep both sides' meaning and
   STOP after resolving — report it, the session sends it to a review). Record `git range-diff 02481763..ad5bd862
   088ee066..HEAD`.
2. If the rebase was pure (no conflict): write the rebase receipt as `ac-verification.md` says — rerun every agent-run AC's
   cited test (AC1–AC6; AC5/AC6 named-only with `F2B_BASE_TREE` = a fresh `git archive` of `088ee066` with main's
   `node_modules` linked) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/rebase/receipt-<head7>.log` in its exact format
   (`HEAD=` first, `EXIT=` last). Then `npm run check` (8G scope) and the job's Chrome file plus `site-cli`, `site-check-cli`,
   `site-slider-unchanged`, and media-clickable's `test/browser/site-background-control.test.ts` (4G scopes): two features
   that pass alone can break together.
3. Report the new head and whether the rebase was pure.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/slf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Piped/chained git commands may be refused (script files; `git -C <absolute path>`). Use `tail -n
3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
New head (full SHA), pure or not (with the conflicts), the range-diff summary, the receipt path and its last line, gates;
`skill_lessons[]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
