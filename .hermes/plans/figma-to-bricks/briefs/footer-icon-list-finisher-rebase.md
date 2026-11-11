# Finisher (step 1, in a copy): move footer-icon-list onto main Build 2026-11-11.3 and write a rebase receipt

You are a fresh finisher (**Opus 5.5, high**). footer-icon-list is accepted: `ac-check.sh --reviews` printed READY FOR THE
USER 9 of 10 on `fb26a529ee24bfa97f9b563756eb2698e826c328` (branch `footer-icon-list-stack3`, base main
`e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`). Main has since moved to `0248176342c662b821629d462f4d15a2a2a1df98` (Build
2026-11-11.3: capture-refused-styles). The only file both changed is `docs/HANDOFF.md`. **Justin is waiting on this
merge: work quickly** (about 20 minutes).

Never edit the main folder, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other worktrees
alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress
site. Never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Skills:** `git-commit-rules`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
step 5 (the rebase receipt) and the project skill's "Step 4: Merge into main" stacking lines.

## Do
1. In your own worktree: `git checkout -B footer-icon-list-final fb26a529ee24bfa97f9b563756eb2698e826c328`, then `git
   rebase main` (check `git rev-parse main` = `02481763…`). Do **not** add a ledger commit before or after: a pure
   rebase keeps the earlier reports valid.
2. **If the rebase has no conflict:** write the rebase receipt exactly as `ac-verification.md` step 5 says — one log
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/rebase/receipt-<head7>.log`, first line
   `HEAD=<new head>`, then the verbose output of every agent-run AC's test (each row's `command` in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/verifier/ac.json`; AC6 is live: no line; AC1
   with a fresh capture of the offline stand-in by the new head's reader, `F2B_ELEMENTOR_STANDIN` unset; named-only
   tests with their variables set; nothing skipped), last line `EXIT=<rc>`. Heavy runs under `systemd-run --user
   --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G; export variables first; no `--setenv=PATH`). Also `npm run
   check` once (8G).
3. **If the rebase conflicts (HANDOFF):** resolve it (this job's section first, then main's lines exactly as main has
   them), finish the rebase, and **stop and report** the conflict and the new head — the session will then take the
   full path. Write no receipt in that case.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/filf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start. A worktree's
`node_modules` may lack `.bin` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). One plain git
command per call, `git -C <absolute path>`; multi-step steps in a script file run with `bash <file>`. Use `tail -n 3`.
Waits under 115 s; run long chains in the background and wait with bounded loops. SIGTERM / 143 / 137 may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`).

## Report (as text)
Branch, new HEAD (full SHA), "pure rebase, no conflict" or the conflict, the receipt's path and its `EXIT=` line, `npm
run check`'s result, then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
