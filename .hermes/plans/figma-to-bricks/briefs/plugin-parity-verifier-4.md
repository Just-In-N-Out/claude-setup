# Role: verifier 4 (read-only, after the rebase onto main with source conflicts): plugin-parity

You are a fresh verifier who never saw the build or the reviews (**Opus 5.5, high**). Prove each acceptance criterion yourself. Change no
source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git
piped into another command: `git archive -o <file> <sha>`, then extract separately). Never load any live site; run any test that captures the
B-Dry stand-in or draws Justin's scan only with no outside network (`unshare -rn sh -c 'ip link set lo up && exec unshare --user
--map-user=1000 --map-group=1000 <cmd>'`); never write to any WordPress site; touch nothing under `~/Downloads`. The folder
`evidence/plugin-parity/verifier-4/` doesn't exist yet: create it, and check it is empty before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head may print test names with an `ACn ` prefix the plan's cited names lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Don't read builder's, finishers', planners' or reviewers' reports or
folders as proof. Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made": also say where a Bricks pro would not
find the paste logical.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live:
  `not_run`). The job: a Figma paste holds no Div (every frame and drawn shape a Block; only an inline picture stays a Div), every Section
  and Block labelled, repeated looks in shared classes keyed on their settings as written, the page drawn exactly as before at every width,
  the sticky header stays under `html, body { overflow-x: hidden }`.
- Head **`2fe8bb52fac3d49689f580c6a504070356147dd1`** (branch `plugin-parity-final`), base **main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`**
  (Build 2026-11-14.4; holds the Figma-route bricks-icons job: "Icons as: SVG" with pictures to WordPress makes Bricks Icons). The job was
  accepted on an older base and rebased with source conflicts in `src/core/convert.ts`, `understand/{ir,understand}.ts`, `emit/elements.ts`;
  review 4 of that resolution is clean. `git checkout --detach 2fe8bb52…`. Old code: a `git archive` of fe29b65d with head's test files and
  fixtures copied in (where a new module doesn't import, prove with a one-line mutant of head). AC logs start `HEAD=<sha>` ("archive" on line
  2), end `EXIT=`. **Set `GIT_DIR` to the main repo's `.git` in every archive-tree runner**; put a `tsc` wrapper first on PATH (`exec node
  "$PWD/node_modules/typescript/bin/tsc" "$@"`). Before each Chrome suite check `/proc/loadavg` (above ~40: unit work first).
- Known red on main itself, not this job: `test/browser/icon-elements.test.ts` renderer@600/390 "11 icons shown" (expects 9): confirm on
  base and head with identical boxes, and record it as base-failing.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G inside the no-network namespace; compare every failure with base by name; rerun a failure
   alone once; known failing on base: composition-clipping, fonts, hero-pair, peer-sides, pill-holder, site-live 3 of 6, icon-elements;
   flaky under load: capture-opens-guards' service-worker cases, render-site-motion, strips' carousel); the story pins with `F2B_STORY_PINS=1`
   and the base pins with `F2B_PIN_BASE=1`; `npm run corpus` (on this desktop it measures nothing: compare replays of `corpus/files/*` and the
   real saves base vs head drawn in Chrome, 0 moved at the design width, 1440, 991, 767, 478, 390).
2. Every AC's test by its plan name on head (pass) and on old code (fail), named-only ones with the plan's variables; a picture per AC
   (Structure-panel dumps before/after; a page base | head at the design width and 390).
3. Your own checks: a Figma fixture of your own (not the repo's) with auto-layout rows, a group of absolute shapes, a drawn one-colour icon
   (with "Icons as: SVG" and pictures to WordPress: still an Icon, its parent a Block, no shared look writing its Width/Height/Fill), a
   component used three times with one copy changed, two pages converted in turn with and without a colour variable, a sticky header frame and
   a drawn phone design: no Div, labels, shared classes, 0 px against the base at the design width and 390 on Bricks 2.4.2 and 2.3.9;
   `figma-to-bricks-debug-page-1.json` (repo root) both picture modes, ticks off and on; site pastes of the repo's site fixtures byte for byte
   main's.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/verifier-4/ac.json` and logs there; self-check with `ac-check.sh` on a
   copy (`--base fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppv4/t1`); scripts under `~/.cache/ppv4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start by
PID (a `user-data-dir=` pattern ends in `/`); one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (systemd-run expands `$VAR`: escape it or use a
script file). Write scripts with the Write tool. Use `tail -n 3`. Foreground Bash moves to the background after about 180 s: long suites with
`setsid --fork`, waiting on `^EXIT=` in bounded steps of 160 s or less; a suite driver skips files already in its log (delete logs with no `#
tests` line before resuming). SIGTERM/143/137/"Killed" may be earlyoom or the scope's own OOM: check `journalctl -u earlyoom` and
`journalctl --user | grep -E 'oom-kill|OOM killer'` first. Write summaries as .txt/.json. Finish every gate before reporting. Away rule: if
you need to figure something out, research it; if nothing is found, take your best-reasoned answer and say so.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates by name; own checks; Bricks-pro notes; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
