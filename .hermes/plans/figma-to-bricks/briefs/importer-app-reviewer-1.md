# Role: reviewer (round 1, FULL review of the whole story; report only): importer-app

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site; no logins; never write to any WordPress site; never
call alttext.ai (only `test/fixtures/wp-standin.ts`, local fixture sites and a local alttext stand-in on 127.0.0.1, a made-up password and
key); never ask for or hold Justin's password or key; touch nothing under `~/Downloads`. **Importer rule:** one review per job, P0–P2 only for
bugs a real use hits (a scenario and a measured number); edge cases P3 — **except security**: a hole in the app's guards (anything another
site, page or local process could use to start a command, read a scan, get the password or key, or write to WordPress) is P0/P1 whether or
not it is likely.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live). The
  job: `npm run importer` serves a local app on 127.0.0.1:47812 with a per-run key that runs the existing commands as child processes —
  scan, preview, copy header / body / footer / all, saved scans, a WordPress upload with a password box (only to `site:upload`'s input,
  refused unless the app was started from a terminal), an alttext.ai key section shown only as "ending in …"; the pastes byte for byte what
  the command line writes; without the app's marks `site:upload`/`site:import` print and write exactly as before (AC17).
- Branch `importer-app-build`, head `de1a5969` (resolve the full SHA with `git rev-parse importer-app-build`), base main `7f54b0a5`:
  `git checkout --detach <head>`; review `git diff 7f54b0a5...HEAD`. Builder's evidence: `~/.hermes/plans/figma-to-bricks/evidence/importer-app/builder/`
  (a head start, not proof; its ledger task 24 lists every guard mutant). The CLAUDE.md wording the plan proposes (S11):
  `~/.hermes/plans/figma-to-bricks/importer-app-claude-md-pending.md` — judge whether it keeps the standing rules' meaning (repo CLAUDE.md
  "One uploader writes to WordPress…", "The website importer's helper…").
- Builder's found_else: AC6's request log sees the preview frame but not the app's tab; a piped answer isn't echoed (P3); `F2B_SHOTS`
  shared with `web-picture-ratio`; marquee timing-flaky; AC17's record now compared parsed (side-by-side uploads write in completion order).

## Check hardest
1. **Security (load `security-best-practices`, `security-threat-model`):** DNS rebinding (Host), CSRF from a web page (Origin, Sec-Fetch-Site,
   JSON only, no CORS), the key (length, constant-time compare, where it lives, the URL it's in, the Referer it may leak), body size,
   path traversal into scans (real-path check, symlinks), argument injection into the child commands (flags, `--`, names starting `-`),
   the password and key never in an argument, env, file, log, page, process list (`ps`), crash output or child's printed line; the
   terminal mark (can the page or another local process fake it?); the preview's sandbox and CSP (can a scanned page's script reach the
   app, the key or the network?). Try each yourself on 127.0.0.1.
2. AC17: without the app's marks the commands are byte for byte as on base (prints, files, record).
3. Child processes: stopped by process group (Stop and app exit leave no Chrome or node behind); two jobs at once; a job that fails says why.
4. The pastes the app copies equal the command line's for the same scan and options.
5. The page (load `ux-frontend-workbench`): plain words, numbered steps, one action at a time as Justin likes; works at 1440 and a narrow
   window; keyboard reachable.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-1/review.json` (round 1, **scope full**, from `7f54b0a5…` (full
SHA via `git rev-parse 7f54b0a5`); full SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base <full 7f54b0a5> /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app`. Load `requesting-code-review`
and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked)
with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iar1/t1`); scripts under `~/.cache/iar1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (with a fixture HOME use the test's `placeIn` wrapper); every Chrome
offline (`test/fixtures/web/offline.ts` or `SITE_OFFLINE`); close every Chrome and child you start (by process group); one Chrome suite at a
time under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Use another port than 47812 for your own app runs if the tests allow it. Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never
end your turn to wait). After SIGTERM/143/137/"Killed" check earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; the S11 wording: keeps the rules or not; Bricks-pro / UX notes;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
