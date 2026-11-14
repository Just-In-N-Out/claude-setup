# Role: builder (Mini): site-tests-offline

You are a fresh builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`
(the guard); the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with
`references/testing-pitfalls.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). **Mini pipeline:** if the fix needs a change under `src/` or `tools/`,
a design decision, or turns out much bigger than the plan says, stop with `status: stopped`, `stop_reason: escalate to full`.

**Hard rules:** never load bdryswi.com or any live site; until a file is converted, never run a test that draws Justin's scan or the B-Dry
stand-in with a bare Chrome (the scan tests run only through `launchOffline()` or under the plan's sink wrapper, which answers every outside
host on 127.0.0.1); never write to any WordPress site; touch nothing under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no
author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.
Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command; files only with
Write/Edit, never heredocs or `cat >>`; scripts run as `bash <file>`).

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4, all
  proposed, none live; Q1 ⭐ A every test file that draws a site paste or capture; Q2 ⭐ A `site-live-widget-bdry.test.ts` is the guard's one
  named exception, `site-tiers-live.test.ts` stays). The planner's probe: `evidence/site-tests-offline/planner/`.
- Base: local main `392f67e2a6b52c40a64acaf7d344a50c934dee26`. `git checkout -b site-tests-offline-build 392f67e2…`.
- Justin's scans (read-only copies; never write to them): `F2B_BDRY_CAPTURE=/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`
  (site-slider-bdry), `F2B_BDRY_CAPTURE_1109=/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (site-elementor-faq-bdry); give each
  variable only to its own file.
- Other jobs edit test files too (site-shared-styles, importer-parity, plugin-parity, native-widgets): keep each launch edit one line, no
  reformatting, so their rebases meet small hunks.

## Build
Test-first as the plan's tasks say: Task 1's base tallies before any edit; AC1 and AC3 RED, then GREEN; AC2 RED on base under the sink wrapper,
GREEN on head; AC4's per-file tally base vs head. Commit after each passing task. Ledger in `.superpowers/sdd/site-tests-offline/progress.md`;
a HANDOFF line and the testing-pitfalls line naming the guard go in the plan's Docs & records task (testing-pitfalls: write the proposed line
in the ledger and HANDOFF; never edit skills). A screenshot or terminal capture per AC in
`/home/justin/.hermes/plans/figma-to-bricks/shots/site-tests-offline/`; receipts in `evidence/site-tests-offline/builder/`. Gates: both
typechecks, `npm run check` (8G), every touched test file by name on head and base. Stop at `ready-for-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/stob/t1`); scripts under `~/.cache/stob/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f` with a pattern in
your own command line; a `user-data-dir=` pattern ends in `/`); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first);
one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first
on PATH) and no repo (set `GIT_DIR`). Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a
script file. Use `tail -n 3`. `cancelled 1` is a timeout. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o
short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text)
Branch, worktree, head (full SHA), base; per AC: RED/GREEN receipts, mutants; files touched (count, any outside the plan's list and why); any
test that failed only offline (the host it asked for); gates; `found_else`; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit
skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
