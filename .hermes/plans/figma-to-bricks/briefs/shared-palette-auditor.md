# Role: blind AC auditor (read-only): shared-palette (both tools)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read any verifier's report or folder** (`evidence/shared-palette/verifier/`, `verifier-2/`), nor `builder/`, `fixer-*/`, `planner*/`,
`review-*/`, nor the reviewers', builder's, fixers' or planners' reports or folders as proof. Change no source or test, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path> <sha>`, extract separately; a `~` path is refused). Never load any live site (every Chrome that draws a site capture or
paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site (only `test/fixtures/wp-standin.ts` on
127.0.0.1, inside `unshare -rn` where you can); touch nothing under `~/Downloads` (Justin's scan copy:
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Write evidence summaries as .txt or .json (a subagent's Write refuses .md).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it (its by-name checker: the head may print `ACn ` before the plan's test names); the
project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md`. Read both `repeat-mistakes.md` files first. Also say where a Bricks pro would not find the paste or the
palette logical (the standard at the top of the repo CLAUDE.md "Decisions the user made").

## Inputs
- Approved plan (read-only, amendment 2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11;
  AC11 live: `not_run`). The job: one colour has one id and one variable (`--color-<hex>`) from both tools and every page of a site; given the
  site's own palette exports (`--colours`, the panel's "Colours already on the site"), both tools link the site's id and variable and write a
  palette file of only the new colours under a free name; without site colours every Figma conversion is byte for byte the base's.
- Head **`f47a20d7814916a54617c2d048baf003f87b4991`** (branch `shared-palette-fix4`), base site-shared-styles' reviewed head
  **`7b7501bd082ae44a99985aac4d080c9b70b67c53`** (not merged). `git checkout --detach f47a20d7…`, clean status. Old code: a `git archive` of
  7b7501bd with head's test files and fixtures copied in (where a new module doesn't import, prove with a one-line mutant of head). AC logs
  start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.

## Work
Prove every AC yourself: its cited test on head (pass) and on old code or a mutant, plus one check of your own per AC beyond the cited test —
e.g. a palette export of your own (two palettes; hsl, rgb(), upper and lower hex, a see-through rgba, a hand-named colour, a `raw` with a
fallback, a missing id), two scanned pages of one site (Justin's scan copy and the B-Dry stand-in, both routes), a Figma save with and
without colour names (`figma-to-bricks-debug-page-1.json`, `corpus/files/*`), each tool's palette.json fed to the other, the same out folder
run three times, the real panel (head's `dist/ui.html` in Chrome, pictures by address when comparing with replay). AC3: the golden hashes made
on base equal head's. A picture per AC (a terminal capture where nothing is visual). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/auditor/ac.json` and logs there (create it; check it is empty);
self-check with `ac-check.sh` on a copy (`--base 7b7501bd082ae44a99985aac4d080c9b70b67c53`, no `--reviews`). Put every receipt wrapper in a
script file written with the Write tool and run it with `bash <file>`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spa/t1`); scripts under `~/.cache/spa/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
by PID (never `pkill -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first);
one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files 8G). Use `tail -n 3`. Waits under 115 s; long runs with `setsid
--fork`, waiting on `^EXIT=`. `cancelled 1` in a test log is a timeout, not a result. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; Bricks-pro notes; `verdict`; `ac_status`; `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
