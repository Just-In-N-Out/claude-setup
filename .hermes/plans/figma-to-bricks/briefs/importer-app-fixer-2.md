# Role: fixer (fix round 2, after review 2): importer-app — R2-1 (P2), R2-2 (P3 wording)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify the finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `security-best-practices`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`. Read
both `repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).
Never load any live site; no logins; never write to any WordPress site; never call alttext.ai (only `test/fixtures/wp-standin.ts`, local
fixtures, a local alttext stand-in, a made-up password and key); never ask for or hold Justin's password or key. **Touch nothing under
`~/Downloads`:** every test that clicks a download runs under a scratch HOME (the tests' `chromeAtHome()`). Commit to your branch only (plain
`git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md;
never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another
command; scripts with the Write tool, run as `bash <file>`, no heredocs). Justin answered review-check's question: **"Fix now"**.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live).
- Review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-2/review.json` (read in full). `git checkout -B
  importer-app-fix2 f2399d4ed48b1f80c957e3829f2a0dfbcd36ceb8` (base `7f54b0a5`).

## Fix, test first (RED on f2399d4e, GREEN after, a one-line mutant killed)
- **R2-1 (`tools/lib/importer-app/page/upload.ts:70`, `page/main.ts:41 jobEnded`):** fix 1 fills the site and user boxes from the scan's
  `importer.json` on every open, and the page re-opens the scan whenever a job ends, so what the person typed goes back to the saved site
  after List pictures (or a failed Log in and check) — a login can then go to the old site with the new site's password. Fill the two boxes
  only when a *different* scan is opened (the row's id differs from the one shown), never on the re-open after a job. Test in Chrome with the
  in-process app: open a scan whose importer.json keeps site A and user a; type site B and user b; run List pictures to its end (and a failed
  Log in and check); the boxes still read B and b; opening another scan and back shows that scan's saved values.
- **R2-2 (wording):** HANDOFF says what the boxes show when an opened scan keeps no site (the last scan's values stay; the yes question names
  the site before anything goes up).

## Gates
`npm run check` (8G); the importer-app AC tests by their plan names on the head (the copy test under a scratch HOME); AC17 (`site:upload`
and `site:import` without the app's marks byte for byte the base); the guard mutants still killed. Ledger: a "Fixer 2" section; HANDOFF
updated. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iaf2/t1`); scripts under `~/.cache/iaf2/s/`;
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; every Chrome offline; close every Chrome and child you start by PID (never
`pkill -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first); memory
scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH";
…'`; mutants under 4G. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. `cancelled 1` is a timeout.
SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write
summaries as .txt/.json.

## Report (as text)
Branch, head (full SHA); per finding: verified or pushed back, RED/GREEN, mutant; rulings; gates by name; `ac_status` per AC;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
