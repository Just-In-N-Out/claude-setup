# Role: reviewer (round 5, a short delta: the HANDOFF-only conflict of the move onto Build 2026-11-11.6; report only): footer-icon-list

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
**Time box: 20 minutes.** Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress
site. Never stop a Chrome you didn't start; touch nothing under `~/Downloads`. The machine is loaded (another session runs
6 agents): run at most one Chrome suite at a time.

## What happened
footer-icon-list head `731707c5e84f9495e152b60d302fe640f6f06554` on main `02481763` has a clean review (review-4, MOVE
ON) and a clean blind auditor (READY 9 of 10). Main moved to `e61c0ca091413adfdca3c9b3abe4757ef2fd521f` (Build
2026-11-11.4 media-clickable, .5 site-scroll-lock, .6 site-menu-motion). A finisher rebased it as branch
`footer-icon-list-final2`, head `c50916eaad942c55e0868626b5b5c6f7a87bf604`. A trial `git merge-tree` showed the only
conflict is `docs/HANDOFF.md`; `src/core/site/convert.ts` and `src/core/snapshot/web.ts` were changed by both sides and
merged on their own. Justin's rule (memory `notes-only-rebase-rule`): a HANDOFF-only conflict with code identical needs
this short delta review plus a re-run of every AC test (a receipt, being written separately), no new verifier/auditor.

## Check (do each yourself)
1. In your own worktree: `git checkout --detach c50916eaad942c55e0868626b5b5c6f7a87bf604`; confirm a clean status.
2. Code identity: `git range-diff 02481763..731707c5 e61c0ca0..c50916ea` and/or compare `git diff 02481763 731707c5 --
   . ':(exclude)docs/HANDOFF.md'` with `git diff e61c0ca0 c50916ea -- . ':(exclude)docs/HANDOFF.md'` (drop `^index `
   lines). Where both sides touched the same file (`convert.ts`, `web.ts`, and any other), read the merged result and
   say whether this job's hunks and main's hunks both stand and still make sense together (names, call sites, types).
3. HANDOFF: main's three new sections (media-clickable 3ea, site-scroll-lock 3ed, site-menu-motion 3ec) and their
   check-list entries are whole and exactly as on main; this job's section first; nothing lost, doubled or reordered; no
   conflict markers; no `<… id at merge>` placeholder but this job's own.
4. `npm run check` (8G scope) on a `git archive` of the new head: exit 0 — including `test/unit/site-no-revert.test.ts`
   against main's golden (site-scroll-lock changed it).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/review-5/review.json` (round 5, a delta: the move
from `731707c5` on `02481763` to `c50916ea` on `e61c0ca0`; `head` the full SHA), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e61c0ca091413adfdca3c9b3abe4757ef2fd521f /home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first; load
`requesting-code-review` and `code-review-practice`. Report only bugs real use hits (the importer's one-real-bug-review
rule); edge cases are P3.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fr5/t1`). A `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink `node_modules` in). One plain git command per call, `git -C <absolute path>`; multi-step steps in a
script file run with `bash <file>`. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137 may be an earlyoom kill (check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`). One final report.

## Report (as text; only review.json is written)
Findings one line each or "none"; the code-identity proof; the both-sides files check; the HANDOFF check; `npm run
check`; `verdict`; `ac_status` (the move changes no AC: say so with the proof); `skill_lessons[{skill, lesson, evidence,
enforce}]`; ending with: `MAIN SESSION: check and save these skill_lessons now.`
