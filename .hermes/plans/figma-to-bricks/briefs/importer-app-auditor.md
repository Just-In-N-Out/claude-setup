# Role: blind AC auditor (read-only): importer-app (the local importer app)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read any verifier's report or folder** (`evidence/importer-app/verifier/`), nor `builder/`, `fixer-*/`, `planner/`, `review-*/`,
nor the reviewers', builder's, fixers' or planners' reports or folders as proof. Change no source or test, commit nothing, start no agents.
Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o
<absolute path> <sha>`, extract separately). Never load any live site; no logins to any real site; never write to any WordPress site; never
call alttext.ai (only `test/fixtures/wp-standin.ts`, local fixtures, a local alttext stand-in, a made-up password and key; refusal-removing
mutants run inside `unshare -rn`). **Touch nothing under `~/Downloads`:** every test or probe that clicks a download runs Chrome under a
scratch HOME (the tests' `chromeAtHome()`); the shared `chrome-f2b` wrapper finds Chrome through `$HOME`, so under a scratch HOME use a copy
of it with absolute paths as `CHROME_PATH`. Write evidence summaries as .txt or .json (a subagent's Write refuses .md).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it (its by-name checker); `security-best-practices`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live:
  `not_run`). The job: `npm run importer` starts a local app on 127.0.0.1 (a per-run key; Host/Origin checks; a real-site upload refused
  unless started from a terminal) that runs the existing commands as child processes, with a WordPress Application Password box passed only
  to `site:upload`'s input and an alttext.ai key section; `site:upload`/`site:import` without the app's marks byte for byte the base.
- Head **`7ff5f664abec6005c5cd5b083c7bd2b06bf70c46`** (branch `importer-app-fix2`), base **`7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8`**
  (main has moved since; the finish rebases). `git checkout --detach 7ff5f664…`, clean status. Old code: a `git archive` of 7f54b0a5 with
  head's test files and fixtures copied in; where the new app's modules don't import there, prove the AC with one-line mutants of head. AC logs
  start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`. Known flakes under load (rerun alone, say so): AC18's "the job's title is in the
  window after Scan"; AC4's copy fallback (`execCommand('copy')`) at load above ~25.

## Work
Prove every AC yourself: its cited test on head (pass) and on old code or a mutant (fail on its own assertion), plus one check of your own per
AC beyond the cited test. Ideas: drive the app's page yourself in Chrome (started from a pty with `script -qfec`, and without a terminal):
DNS-rebinding Host values, `Origin: null`, a cross-site form POST, a key in the address bar after load, a request body over the limit; the
password and the alttext key never in any process's `/proc/*/cmdline` or `environ` (sample every descendant, the scan's Chrome included), any
file, log, page storage or printed line; an upload to the stand-in after changing the site box mid-flow goes only to the typed site; Ctrl+C
and closing the terminal mid-upload leave no process and keep the record so a rerun sends no file twice; `site:upload`/`site:import` run
without the app byte for byte as base (output, files, requests). A picture per AC (the app's page; a terminal capture where nothing is
visual). Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/auditor/ac.json` and logs there (create it; check it is
empty); self-check with `ac-check.sh` on a copy (`--base 7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8`, no `--reviews`). Put every receipt
wrapper in a script file written with the Write tool and run it with `bash <file>`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iaa/t1`); scripts under `~/.cache/iaa/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome and app process you start by PID (never `pkill -f`
with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first); one Chrome suite at a
time under `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH";
…'`. An archive tree has no `node_modules/.bin` (put a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR` for tests reading `git show`).
Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`.
`cancelled 1` is a timeout. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
