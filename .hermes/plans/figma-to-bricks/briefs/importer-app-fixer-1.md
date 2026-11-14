# Role: fixer (fix round 1, after review 1): importer-app — R1-1 (P2) and R1-3, R1-4, R1-6, R1-7, R1-9 (P3s worth fixing now)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `security-best-practices`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`. Read
both `repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).
Never load any live site; no logins; never write to any WordPress site; never call alttext.ai (only `test/fixtures/wp-standin.ts`, local
fixture sites and a local alttext stand-in, a made-up password and key); never ask for or hold Justin's password or key. **Touch nothing
under `~/Downloads`:** run every test that clicks a download under a scratch HOME with `.cache/chrome-for-testing` and `.cache/chrome-libs`
symlinked in (Chrome writes a hidden temp file in `$HOME/Downloads` first). Commit to your branch only (plain `git commit -m`, no author
override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command; scripts with the Write
tool, run as `bash <file>`, no heredocs, no `python3 - <<`). Away rule (Justin is asleep, "go with recommended"): research first; else take
your best-reasoned answer and record it as a ruling (not yet confirmed) in the ledger and HANDOFF.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live).
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-1/review.json` (read in full; probes in
  `/home/justin/.cache/iar1/s/`). `git checkout -B importer-app-fix1 de1a59697adcf564f213d5b17c47d576c3481398` (base `7f54b0a5`).

## Fix, each test first (RED on de1a5969, GREEN after, a one-line mutant killed)
- **R1-1 (P2, `tools/lib/importer-app/routes.ts:147`):** with no alttext.ai key saved, an upload never meets the command's hidden key
  question: the app passes `--no-ai-alt` when no key file exists (or the page's AI box starts unticked and disabled with "Add your alttext.ai
  key below first"), whichever the plan's AC15 wording asks; a test with no key file and the box as it starts.
- **R1-3 (`test/web/importer-app-copy.test.ts:106`, test-only):** the Download test runs Chrome under a scratch HOME (symlinks above) so it
  never touches `~/Downloads`; also make its fallback-copy step steady (it failed 1 of 2 there).
- **R1-4 (`tools/importer.ts:58`, `server.ts:62`):** closing the terminal during a job never crashes on `write EIO`: guard writes to a hung-up
  terminal and finish `close()` (stop jobs by process group, delete the previews folder) — test with a real pty (`script -qfc`) killed
  mid-job: 0 processes left, the previews folder gone.
- **R1-6 (`page/upload.ts:64`):** the site and user boxes show what `importer.json` keeps for the opened scan (Q6 A).
- **R1-7 (`page/views.ts:123`):** a command-line-made folder opens with the Elementor box set from what its pastes were made with (read it
  from the folder's own notes or record), not the browser's last choice.
- **R1-9 (S11 wording, `docs/plans/2026-11-13-importer-app.md:547`, HANDOFF and
  `~/.hermes/plans/figma-to-bricks/importer-app-claude-md-pending.md`):** "a shell or environment variable"; the key never in "a Chrome the
  tools start, or the page's storage"; the password "held only in the app's own memory, never on disk" (as the code does).
- R1-2 (AC18 load flake), R1-5 (SIGQUIT/SIGKILL leaves the job), R1-8, R1-10, R1-11: follow-ups; write them in HANDOFF's follow-ups.

## Gates
`npm run check` (8G); every AC1–AC19 test by its plan name on the head (the copy test under a scratch HOME); AC17 (`site:upload` and
`site:import` without the app's marks byte for byte the base); the guard mutants still killed. Ledger: a "Fixer 1" section; HANDOFF
updated. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iaf1/t1`); scripts under `~/.cache/iaf1/s/`;
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (with a fixture HOME use the test's `placeIn` wrapper); every Chrome offline;
close every Chrome and child you start by PID (never `pkill -f` with a pattern in your own command line); memory scopes `systemd-run --user
--scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`; mutants under a 4G
cap. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text)
Branch, head (full SHA); per finding: verified or pushed back, RED/GREEN, mutant; rulings; gates by name; `ac_status` per AC;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
