# Role: finisher (rebase + receipt): bricks-icons-site onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first. **Never load bdryswi.com** or any live site (every Chrome that draws a site capture or paste with `SITE_OFFLINE`); touch nothing under `~/Downloads`; never write to any WordPress site. Commit to your branch only; don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder). **No ledger move** (the after-merge finisher does it).

## State
bricks-icons-site is accepted: `ac-check.sh` READY FOR THE USER (4 of 5, AC5 live) on head `a06ed92d887bd960fd3dc3df33fa7c2a620fa8f2`
(branch `bricks-icons-site-build`) on base `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4`. Local main is now `84722938` (Build 2026-11-14.1):
cf4f887d plus one commit touching only `docs/HANDOFF.md`, `docs/plans/2026-11-11-site-no-div-ledger.md` and `src/shared/build.ts`. Read
`git rev-parse main` at your start (another merge may land first).

## Do
1. Your own worktree: `git checkout -B bricks-icons-site-final a06ed92d887bd960fd3dc3df33fa7c2a620fa8f2`; `git rebase <main's SHA>`. Record
   each conflict in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/rebase/conflicts.txt` and `git range-diff` in
   `range-diff.txt`. HANDOFF/ledger only → both sides word for word, this job's section first. Any source/test conflict → keep both sides'
   meaning, record exactly what you resolved and how, and say so in the report (it then takes a full review).
2. Main's merged jobs' named-only pins that read `src/` (e.g. `media-avif-untouched`, `site-import-figma-unchanged` with their named base
   archive 56b5076b and only main's `src/shared/build.ts` laid over it): run them by name on the new head; one that fails only because of
   this job's files is updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <the pinned paths>`; a stray-file and a
   one-byte mutant still fail it), RED/GREEN, one commit — and say so. If they fail the same way on main itself, say so and leave them.
3. Rerun every agent-run AC test (AC1–AC4 by their plan names in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/plan-approved.md`,
   AC4 with `F2B_STORY_PINS=1`, AC3 with the B-Dry stand-in named, every Chrome with `SITE_OFFLINE`; AC2's upload test needs the network on
   for the AVIF encoder download unless you pass `F2B_ENCODER_CACHE`; WordPress and alttext.ai stay the 127.0.0.1 stand-ins) on the new head
   into `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line,
   `EXIT=` last, skipped 0). Then `npm run check` (8G scope); Figma replays byte for byte main's.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bisf/t1`); scripts under `~/.cache/bisf/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/
"Killed" may be earlyoom: check first.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
