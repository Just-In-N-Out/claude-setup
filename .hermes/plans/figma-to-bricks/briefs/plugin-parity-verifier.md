# Role: verifier (read-only): plugin-parity

You are a fresh verifier who never saw the build or the review (**Opus 5.5, high**). Prove each acceptance criterion yourself. Change no
source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git
piped into another command: `git archive -o <file> <sha>`, then extract separately). Never load any live site; never write to any WordPress
site; touch nothing under `~/Downloads`. The verifier folder `evidence/plugin-parity/verifier/` doesn't exist yet: create it, and check it is
empty before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head may print test names with an `ACn ` prefix the plan's cited names lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Don't read builder's, planners' or reviewers' reports or folders as proof.
Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made": also say where a Bricks pro would not find the paste logical.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live:
  `not_run`). The job: a Figma paste holds no Div (every frame and drawn shape a Block; only an inline picture stays a Div), every Section
  and Block labelled, repeated looks in shared classes, the page drawn exactly as before at every width, the sticky header stays under
  `html, body { overflow-x: hidden }`.
- Head `89e41a0d071f25aa2c68c913c0a9b6167fe99557` (branch `plugin-parity-build`), base **site-shared-styles' reviewed head**
  `7b7501bd082ae44a99985aac4d080c9b70b67c53` (not merged; the job was built early on it). `git checkout --detach 89e41a0d…`. Old code: a
  `git archive` of 7b7501bd with head's test files and fixtures copied in (where a new module doesn't import, prove with a one-line mutant of
  head). AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G; compare every failure with base by name; rerun a failure alone once; known failing here:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder; flaky under load: capture-opens-guards' service-worker cases,
   render-site-motion, strips' carousel); the story pins with the variables the plan names (`F2B_STORY_PINS=1`); `npm run corpus` (on this
   desktop it measures nothing: compare replays of `corpus/files/*` and the real saves base vs head drawn in Chrome, 0 moved at the design
   width, 1440, 991, 767, 478, 390).
2. Every AC's test by its plan name on head (pass) and on old code (fail), named-only ones with the plan's variables; a picture per AC
   (Structure-panel dumps before/after; a page base | head at the design width and 390).
3. Your own checks: a Figma fixture of your own (not the repo's) with auto-layout rows, a group of absolute shapes, a component used three
   times with one copy changed, a sticky header frame and a drawn phone design — no Div, labels, shared classes, 0 px against the base at
   the design width and 390 on Bricks 2.4.2 and 2.3.9; `figma-to-bricks-debug-page-1.json` (repo root) both picture modes, ticks off and on.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/verifier/ac.json` and logs there; self-check with `ac-check.sh` on a
   copy (`--base 7b7501bd082ae44a99985aac4d080c9b70b67c53`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppv/t1`); scripts under `~/.cache/ppv/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`); one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long suites with `setsid --fork`, waiting on `^EXIT=`; a suite driver skips files already in its log (delete
logs with no `# tests` line before resuming). SIGTERM/143/137/"Killed" may be earlyoom or the scope's own OOM: check `journalctl -u earlyoom`
and `journalctl --user | grep -E 'oom-kill|OOM killer'` first. Finish every gate before reporting (don't hand back "incomplete"). Away rule:
if you need to figure something out, research it; if nothing is found, take your best-reasoned answer and say so.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates by name; own checks; Bricks-pro notes; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
