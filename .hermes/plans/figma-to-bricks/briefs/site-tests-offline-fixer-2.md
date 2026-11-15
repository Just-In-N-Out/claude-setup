# Role: fixer (fix round 2, Mini): site-tests-offline

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly) with `references/testing-pitfalls.md`. Read both `repeat-mistakes.md` files first. **Never load any live site.** Run any test that
captures the B-Dry stand-in or draws Justin's scan only inside a no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add
d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user
--map-user=1000 --map-group=1000 <cmd>'`, inside the memory scope) or under the job's sink; never write to any WordPress site; touch nothing
under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder; no git piped into another command; files only with Write/Edit, never heredocs; scripts run as `bash <file>`).
Tests only: if a fix needs `src/` or `tools/`, stop with `stop_reason: escalate to full`.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4).
- Head `001f2a1a906504f1e06193eb143c265547e740a5` (branch `site-tests-offline-fix1`) on main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`.
  `git checkout -B site-tests-offline-fix2 001f2a1a…`. Review 2:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/review-2/review.json` (REVIEW AGAIN), its probes in
  `evidence/site-tests-offline/verifier-2/probe-r2-browserless.log`. Verifier work accepted AC1–AC4 on 001f2a1a.

## Fix (each test first: RED, GREEN, a one-line mutant killed)
- **R2-1 (P2):** the guard (`test/unit/site-tests-offline.test.ts`, `bareCaptures`) requires a `fetcher` on every capture call in a drawing
  file but not a `browser`; `captureSite` with no browser starts its own Chrome through `launchCaptureChrome` (`src/web/capture.ts:82`) with
  no host rule. 17 calls in 10 files have that shape (capture-fonts ×4, site-check-cli ×3, site-cli ×3, site-check-live-widget,
  site-live-carousels, site-live-closing, site-live-drew-nothing, site-live-slider, site-live-standin, site-live). Pass a `launchOffline()`
  browser in each (closing it after, as the files' other launches do), and make the guard fail a capture call that passes no browser (or
  options it passes on) the same way it fails a missing fetcher. Prove with the reviewer's shape: `captureFixture('embeds', { shots: false,
  fetcher: offlineFetch })` behind the sink asks www.google.com / maps.google.com / openstreetmap; with a `launchOffline()` browser it asks
  nothing; the guard names it. A capture whose test needs the capture's own visible Chrome (a person check): say which and why it stays.
- **R2-2 (P3):** `test/web/offline/tally.ts:101` `CHROME_OWN` excuses `www.google.com`, which is also a page host (Maps embeds): narrow it to
  Chrome's own service paths or hosts that are never page hosts, with a test.
- **R2-3 (P3):** `test/web/offline/tally.ts:133` the new-file rule's `!existsSync(join(a.tree, f))` term isn't pinned: add a case (a base
  tally cut short: the file is in the base tree but not its tally → a difference) that kills mutant T1.

## Gates
Both typechecks, `npm run check` (8G); AC1–AC4 by their plan names on your head (AC4's tally base fe29b65d vs head, both in the namespace
under the sink; `--compare` exit 0). Ledger: a "Fixer 2" section. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/stof2/t1`); scripts under `~/.cache/stof2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg`; one Chrome suite
at a time under `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 …` outside the namespace. A `node --test` file spawning a
child `node --test` strips `NODE_TEST*` from the child's env. Foreground Bash moves to the background after about 180 s: wait in bounded
steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check earlyoom's log first. Write summaries as
.txt/.json.

## Report (as text)
Branch, head (full SHA), the main it sits on; per finding: verified or pushed back, RED/GREEN, mutant; gates; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
