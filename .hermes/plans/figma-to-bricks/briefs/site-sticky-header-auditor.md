# Role: blind AC auditor (read-only): site-sticky-header

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your
own folder. **Never read the verifier's report or folder** (`evidence/site-sticky-header/verifier/`, `verifier-ad041d3/`),
the reviewers', the builder's, the fixer's or the planners' reports as proof. Change no source or test, commit nothing, start
no agents. Never load any live site; never write to any WordPress site; touch nothing under `~/Downloads` except reading
Justin's scan into your own scratch copy.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and
the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the wheel
and sibling-class mutant lines). Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Inputs
- Approved plan (read-only, amendment 1): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md`
  (AC1–AC9; AC9 live: `not_run`).
- Head `c370ffa23f5157776d5c7bb710f6a4c9608b7cb6` (branch `site-sticky-header-fix1`), base
  `0248176342c662b821629d462f4d15a2a2a1df98`. In your own worktree: `git checkout --detach c370ffa2…`, clean status. Old code:
  a `git archive` of `02481763` with head's test files, fixtures and sums copied in.

## Work
Prove every AC yourself: its cited test on head (pass) and on old code (fail on its own assertion, or `base_exempt` with a
reason and a mutant), plus one check of your own per AC beyond the cited test (e.g. AC1/AC3: a header fixture of your own —
a script-fixed Elementor-style bar with a spacer — captured fresh, converted, drawn on Bricks 2.4.2 and 2.3.9 at 1440 and 390,
in the page and in a Header template, scrolled, then a real Bricks Offcanvas with "No scroll" opened by a click and a real
wheel turn; AC4: the class CSS is exactly the five lines; AC8: each code-page variant minus class and note hashes to main's
sum from git). A picture per AC. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/auditor/ac.json`
and logs there (check it's empty first); self-check with `ac-check.sh` on a copy (`--base
0248176342c662b821629d462f4d15a2a2a1df98`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sha2/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). Piped/chained git commands may be refused (script files; `git -C <absolute
path>`). Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl
-u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
