# Role: fixer (move onto the new main; test-only job): site-tests-offline

You are a fresh fixer (**Opus 5.5, high**). Load `engineering-best-practices`, `git-commit-rules`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first. Never load any live site; run any test that captures the B-Dry stand-in or draws Justin's scan only inside a
no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0
up && ip route add unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`, inside the memory scope); never write
to any WordPress site; touch nothing under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no author override, no AI or
Co-Authored-By lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain
`git` in your own worktree, each command alone; files only with Write/Edit, never heredocs; scripts run as `bash <file>`. Before every `git
add` / `rebase --continue` in a conflict, `git diff --check`. Deadline Monday 09:00 on this computer: about 90 minutes.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4: test runs
  never reach the internet; every test Chrome and Node fetch loopback-only; the guard `test/unit/site-tests-offline.test.ts`; the AC4 tally
  compare). Nothing under `src/` or `tools/` changes.
- Head `29a7f6c1565bc2f8304eb713124b087fabb11623` (branch `site-tests-offline-fix2`) on `fe29b65d`, review 3 clean.
- Local main is now `e2fc35aaa6b7e3a662d0c3cce37ec636495a5405` (shared-palette + Build 2026-11-15.1). It changed `test/web/site-cli.test.ts`
  (this job edits it too), added `test/browser/panel-site-colours.test.ts` and many unit tests.

## Do
1. `git checkout -B site-tests-offline-fix3 29a7f6c1…`; `git rebase e2fc35aa…`. Record conflicts in
   `evidence/site-tests-offline/fixer-3/conflicts.txt`; keep both sides' meaning (main's new site-colours cases in site-cli stay, each capture
   still given its `launchOffline({ sockets: true })` browser and offline fetcher). HANDOFF: both sections, the newer job's first.
2. Every test main added or changed that launches a Chrome, captures, or fetches must pass this job's guard (AC3) and stay offline: run the
   guard; any new offender gets the same treatment as fixer 2 gave the others, one test-only commit.
3. Gates on the moved head: both typechecks, `npm run check` (8G); every AC's test by plan name into
   `evidence/site-tests-offline/fixer-3/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last); `test/web/site-cli.test.ts` and
   `test/browser/panel-site-colours.test.ts` in the namespace. Ledger: a "Fixer 3 (rebase)" section. Stop at `ready-for-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/stof3/t1`); scripts under
`~/.cache/stof3/s/`; **`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill
-f`/`pgrep -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (above ~40, do the non-Chrome steps
first); memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 …` outside the namespace. Foreground Bash moves to the
background after about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text)
New head (full SHA) and its main; conflicts and how kept; new offenders fixed; gates; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
