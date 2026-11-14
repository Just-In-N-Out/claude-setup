# Role: blind AC auditor (read-only): plugin-parity (Figma plugin)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read the verifier's report or folder** (`evidence/plugin-parity/verifier/`), nor `builder/`, `fixer-*/`, `planner*/`, `review-*/`, nor the reviewers', builder's, fixer's or planners'
reports or folders as proof. Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone
(never `git -C` the main folder). Never load any live site; never
write to any WordPress site; touch nothing under `~/Downloads`.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/rendering-validation.md`, `references/testing-pitfalls.md` (CHROME_PATH, the whole-page sticky probe, the story pins).
Read both `repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live:
  `not_run`). The job: a Figma paste holds no Div (every frame and drawn shape a Block; only an inline picture stays a Div), every Section and
  Block labelled, repeated looks in shared classes, the page drawn exactly as before at every width, the sticky header stays under
  `html, body { overflow-x: hidden }`. Named-only tests run by name with the plan's variables (`F2B_STORY_PINS=1` for the story pin). The head
  may print test names with an `ACn ` prefix the plan's names lack: use `ac-verification.md`'s by-name checker; write each `ac.json`
  command so it parses in bash (test names hold apostrophes: double quotes, `\$`) with its env on the command.
- Head **`89e41a0d071f25aa2c68c913c0a9b6167fe99557`** (branch `plugin-parity-build`), base **site-shared-styles' reviewed head
  `7b7501bd082ae44a99985aac4d080c9b70b67c53`** (not merged; the job was built early on it). In your own worktree: `git checkout --detach
  89e41a0d…`, clean status. Old code: a `git archive` of 7b7501bd (`git archive -o <file>`, extract separately) with head's test files and
  fixtures copied in (where a new module doesn't import, prove with a one-line mutant of head).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code, plus one check of your own per AC beyond the cited test — e.g. a
Figma fixture of your own (not the verifier's) with nested auto-layout, a card component used four times (one copy recoloured), a group of
vectors, an image fill, a phone design beside the desktop, a sticky header; both picture modes, ticks off and on, Bricks 2.4.2 and 2.3.9, the
design width and 390: 0 Divs but inline pictures, every Section and Block labelled, looks shared, 0 px against base; the real saves
(`figma-to-bricks-debug-page-1.json`, `corpus/files/*`) base | head paired by element: 0 moved. Before reading a picture, wait past the
paste's largest Interaction `animationDelay`. A picture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/auditor/ac.json` and logs there (create it; check it is empty); self-check with
`ac-check.sh` on a copy (`--base 7b7501bd082ae44a99985aac4d080c9b70b67c53`, no `--reviews`). Put every receipt wrapper in a script file written
with the Write tool and run it with `bash <file>` (compound commands holding `HEAD=` are refused). Also say where a Bricks pro would not find
the paste logical (the standard at the top of the repo CLAUDE.md "Decisions the user made").

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppa/t1`); scripts under `~/.cache/ppa/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`; never `pkill -f`); one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
