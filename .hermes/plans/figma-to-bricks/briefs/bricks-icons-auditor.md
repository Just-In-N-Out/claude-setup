# Role: blind AC auditor (read-only): bricks-icons (M1, the Figma plugin half)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read the verifier's report or folder** (`evidence/bricks-icons/verifier/`), nor the reviewers', builder's, fixer's or planners'
reports or folders as proof. Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone
(never `git -C` the main folder). Never load any live site; never write to any WordPress site.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/rendering-validation.md` (inline-svg lines), `references/testing-pitfalls.md`; `reference/bricks/README.md` ("Icon"). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Inputs
- Approved plan (read-only, amendment 1: M1 only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md`
  (AC1–AC7; AC7 live: `not_run`). The job: a plain drawn icon in a Figma design becomes Bricks' Icon element (library SVG, colour and size in
  its controls) when the panel sends pictures to WordPress with Icons as SVG; everything else stays as it was.
- Head **`c78fa0cfcbc7ce9a9b9689613274f633130012ef`** (branch `bricks-icons-fix1`), base **`0248176342c662b821629d462f4d15a2a2a1df98`**. In your
  own worktree: `git checkout --detach c78fa0cf…`, clean status. Old code: a `git archive` of base with head's test files and fixtures copied
  in (where a new module doesn't import, prove with a one-line mutant of head).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code, plus one check of your own per AC beyond the cited test (e.g. AC2: a
Figma fixture of your own with icons that should and shouldn't become Icons, each refusal by its rule; AC4/AC5: picture vs Icon in Chrome at
six widths under Bricks 2.3.9 and 2.4.2 CSS, then Width alone, Height alone and both edited below the drawn size, boxes and the words beside
equal; AC3 with `F2B_STORY_PINS=1`: count yourself that every saved file with Icons off converts to base's bytes). A picture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/auditor/ac.json` and logs there (it's empty now); self-check with
`ac-check.sh` on a copy (`--base 0248176342c662b821629d462f4d15a2a2a1df98`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bia/t1`); scripts under `~/.cache/bia/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`; never `pkill -f`); one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
