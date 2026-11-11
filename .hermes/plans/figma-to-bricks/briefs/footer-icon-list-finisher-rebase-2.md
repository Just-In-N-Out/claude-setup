# Finisher (step 1, in a copy): move footer-icon-list onto main Build 2026-11-11.5 and write a rebase receipt

You are a fresh finisher (**Opus 5.5, high**). footer-icon-list's head is `731707c5e84f9495e152b60d302fe640f6f06554`
(branch `footer-icon-list-final`, base main `0248176342c662b821629d462f4d15a2a2a1df98`). Review 4 is clean (MOVE ON) and
the blind auditor accepted it (READY 9 of 10); a verifier is still re-checking it in parallel. Main has since moved to
`11f07742…` (Build 2026-11-11.4 media-clickable, 2026-11-11.5 site-scroll-lock). A trial `git merge-tree` shows the only
conflict is `docs/HANDOFF.md`; `src/core/site/convert.ts` merges cleanly (both sides changed it). site-scroll-lock also
changed `src/core/site/classes.ts`, `parts.ts`, several pin tests and `test/fixtures/site-no-revert-main.json`;
media-clickable changed `test/browser/render.ts`. **Justin is waiting on this merge: work quickly.**

Justin's rule (memory `notes-only-rebase-rule`, 2026-11-11): a rebase whose only conflict is HANDOFF, with both sides kept
word for word and the code identical, needs a short delta review plus a re-run of every AC test on the new head (this
receipt), not a new verifier and auditor.

Never edit the main folder, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other worktrees
alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress
site. Never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Skills:** `git-commit-rules`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
step 5 (the rebase receipt) and the project skill's "Step 4: Merge into main" stacking lines. Read
`~/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Do
1. In your own worktree: `git checkout -B footer-icon-list-final2 731707c5e84f9495e152b60d302fe640f6f06554`, then `git
   rebase 11f07742` (check `git rev-parse main` starts `11f07742`; use the full SHA). No ledger commit before or after.
2. Resolve the HANDOFF conflict by keeping both sides **word for word**: this job's section first, then main's lines
   exactly as main has them. If any other file conflicts, stop and report it (no receipt).
3. Prove code identity: `git diff 731707c5~N..731707c5 -- . ':!docs/HANDOFF.md'` vs the new range's same diff (or
   `git range-diff 02481763..731707c5 11f07742..HEAD`) — report whether every non-HANDOFF patch is identical.
4. Write the receipt exactly as `ac-verification.md` step 5 says: one log
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/rebase/receipt-<head7>.log`, first line
   `HEAD=<new head>`, then the verbose output of every agent-run AC's test (each row's `command` in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/verifier-fb26a52/ac.json` and, if it exists by
   then, `.../footer-icon-list/verifier/ac.json`; AC6 is live: no line; AC1 with a fresh capture of the offline stand-in
   by the new head's reader, `F2B_ELEMENTOR_STANDIN` unset; named-only tests with their variables set; nothing
   skipped), last line `EXIT=<rc>`. Heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`
   (B-Dry 8G; export variables first; no `--setenv=PATH`). Also `npm run check` once (8G), including
   `test/unit/site-no-revert.test.ts` against main's new golden — if it fails because both jobs changed what a site paste
   writes, report it (don't regenerate the golden without saying so).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/filr/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start. A worktree's
`node_modules` may lack `.bin` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). One plain git
command per call, `git -C <absolute path>`; multi-step steps in a script file run with `bash <file>`. Use `tail -n 3`.
Waits under 115 s; run long chains in the background and wait with bounded loops. SIGTERM / 143 / 137 may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`). A verifier agent is
using `~/.cache/footer-icon-list-verifier/`: leave it alone.

## Report (as text)
Branch, new HEAD (full SHA), the conflict and how it was resolved, code identity yes/no, the receipt's path and its
`EXIT=` line, `npm run check`'s result, then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
