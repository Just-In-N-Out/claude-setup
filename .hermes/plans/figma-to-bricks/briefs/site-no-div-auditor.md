# Role: blind AC auditor (read-only): site-no-div (website importer)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read the verifier's report or folder** (`evidence/site-no-div/verifier/`), nor `builder/`, `fixer-*/`, `planner*/`, `review-*/`, nor the reviewers', builder's, fixer's or planners'
reports or folders as proof. Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone
(never `git -C` the main folder). **Never load bdryswi.com**, B-Dry staging or any live site (Google Fonts only as `site:check` does); never
write to any WordPress site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: read-only copy `evidence/media-clickable/run/`).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/live-site-reading.md` ("Code-route paste traps"), `references/testing-pitfalls.md` (CHROME_PATH, the whole-page sticky probe).
Read both `repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only, amendment 3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md` (AC1–AC14; AC14
  live: `not_run`). The job: every website paste (both routes) holds no Div — Sections/Containers/Blocks by rule S (tags), Text links /
  Buttons / linked Images, Rich Text, neutral wrappers folded by rule N with its refusals (percentages, sticky, text settings), each box
  labelled; `native: false` = base with Div renamed Block; Figma designs byte for byte. Named-only tests run by name with the plan's variables.
  The head prints test names with an `ACn ` prefix the plan's names may lack: use `ac-verification.md`'s by-name checker.
- Head **`828f7dc01af443ea5bc248fac1d1106e711cfdba`** (branch `site-no-div-fix3`), base local main **`56b5076b5c1d665abd5bad4bcc78861739cc01e9`**
  (Build 2026-11-12.1). In your own worktree: `git checkout --detach 828f7dc0…`, clean status. Old code: a `git archive` of 56b5076b (`git
  archive -o <file>`, extract separately) with head's test files and fixtures copied in (where a new module doesn't import, prove with a
  one-line mutant of head).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code, plus one check of your own per AC beyond the cited test — e.g. a
plain fixture site of your own (not the verifier's) with a card grid, a sidebar row, a button in a plain div, a heading in a styled box, a
nav `ul > li > a`, a linked logo, a footer with a lone paragraph; both routes, Bricks 2.4.2 and 2.3.9, 1440 and 390: which folds, which stays
a labelled Block, 0 Divs, within 2 px; AC9/AC14: count yourself on Justin's scan (no Div, the plan's counts, base | head paired by site path:
0 moved); AC11: count yourself that every switch-off paste equals base's with Div named Block. A picture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/auditor/ac.json` and logs there (it's empty now); self-check with `ac-check.sh`
on a copy (`--base 56b5076b5c1d665abd5bad4bcc78861739cc01e9`, no `--reviews`). Put every receipt wrapper in a script file written with the
Write tool (compound commands holding `HEAD=` are refused).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sda/t1`); scripts under `~/.cache/sda/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`; never `pkill -f`); one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
