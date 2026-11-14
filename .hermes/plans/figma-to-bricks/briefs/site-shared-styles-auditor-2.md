# Role: blind AC auditor 2 (read-only, after the rebase onto main): site-shared-styles (website importer)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read any verifier's or earlier auditor's report or folder** (`evidence/site-shared-styles/verifier/`, `verifier-2/`, `auditor/`), nor `builder/`, `fixer-*/`, `planner*/`,
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
- Approved plan (read-only, amendment 1): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`
  (AC1–AC15; AC15 live: `not_run`). The job: a website paste's repeated looks live in shared purpose-named classes (text styles, buttons,
  cards and boxes, rows), same-looking elements share one, a one-off tweak sits on the element, never two classes writing one property; the
  site's colours go to one palette (palette.json, Style Manager → Colors) and settings name them; looks stay true; the switch off and Figma
  designs byte for byte as before. Named-only tests run by name with the plan's variables (`F2B_PIN_BASE=1`, the B-Dry env for AC11).
- Head **`f971b30691f6c00c0580793c99c8b415ba9bebe3`** (branch `site-shared-styles-rebased`: the accepted 7977b8f8 rebased onto main with
  source conflicts resolved against bricks-icons-site — an Icon's class writes no Bricks control — plus test-only `f971b306`), base main
  **`392f67e2a6b52c40a64acaf7d344a50c934dee26`** (Build 2026-11-14.2; main has since moved to 6bca1176, importer-app, notes-only overlap).
  `git checkout --detach f971b306…`, clean status. Old code: a `git archive` of 392f67e2 with head's test files and fixtures copied in (where a
  new module doesn't import, prove with a one-line mutant of head; build `dist/` there before browser runs; set `GIT_DIR` inside a runner for
  tests reading `git show`). AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`. Both jobs must hold together: main's icon tests
  (`test/unit/site-icons*.test.ts`, `test/web/site-icons-look.test.ts`) and an Icon in a shared look are part of your own checks. `test/web/site-shared-styles.test.ts`'s forced
  `:focus` reading waits 450 ms against 0.3 s transitions: one lone forced-state difference under load is timing until a lone rerun repeats it.

## Work
Prove every AC yourself: its cited test on head (pass) and on old code or a mutant, plus one check of your own per AC beyond the cited test —
e.g. a fixture site of your own (not the verifier's) with headings of one look declared three ways, buttons alike but for one tweak, cards
alike but one, a hover only on an ancestor, colours in gradients and shadows; Justin's scan copy (it holds opened boxes; the stand-in has none) and the B-Dry stand-in, both routes; a section paste against the page paste on a capture with opened boxes; Bricks
2.4.2 and 2.3.9, 1440, 1024, 768 and 390: elements carrying each shared class, 0 properties written by two classes (CSSOM), switch off vs on 0
moved, an edit of one class's value changes exactly its carriers, a palette variable edit changes only its users, two pages pasted in turn ask
Bricks about no class (`test/fixtures/bricks-paste.ts`). A picture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/auditor-2/ac.json` and logs there (create it; check it is empty);
self-check with `ac-check.sh` on a copy (`--base 392f67e2a6b52c40a64acaf7d344a50c934dee26`, no `--reviews`). Put every receipt wrapper in a
script file written with the Write tool and run it with `bash <file>`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssa2/t1`); scripts under `~/.cache/ssa2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
by PID (never `pkill -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first);
one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files 8G). Use `tail -n 3`. Waits under 115 s; long runs with `setsid
--fork`, waiting on `^EXIT=`. `cancelled 1` in a test log is a timeout, not a result. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; Bricks-pro notes; `verdict`; `ac_status`; `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
