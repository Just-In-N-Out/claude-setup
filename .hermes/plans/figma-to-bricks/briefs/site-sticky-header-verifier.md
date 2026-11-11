# Role: verifier (read-only): site-sticky-header on its fixed head

You are a fresh verifier who never saw the build, the fix or the reviews (**Opus 5.5, high**). Prove each acceptance
criterion yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other
worktrees. Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch nothing under
`~/Downloads`. Before writing, `evidence/site-sticky-header/verifier/` must not exist or be empty.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job and the
`ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the wheel
and sibling-class mutant lines) and `references/live-site-reading.md`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Don't read the builder's,
fixer's or reviewers' reports or folders as proof (`verifier-ad041d3/` included).

## Inputs
- Approved plan (read-only, amendment 1): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md`
  (AC1–AC9; AC9 live: `not_run`). Find every cited test with ac-check's own grep; read each before running it.
- Head `c370ffa23f5157776d5c7bb710f6a4c9608b7cb6` (branch `site-sticky-header-fix1`), base
  `0248176342c662b821629d462f4d15a2a2a1df98`. In your own worktree: `git checkout --detach c370ffa2…`, clean status. Old
  code: a `git archive` of `02481763` with head's test files, fixtures and sums copied in. An AC log cited in `ac.json`
  starts with the bare `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0.

## Work
1. Gates on head: both typechecks, `npm run check` (8G scope), the job's Chrome file and `site-cli`, `site-check-cli`,
   `site-slider-unchanged` (each under a 4G scope); the plugin bundle (`dist/`) byte-identical to base's.
2. Every AC's test on head (pass) and on old code (fail on its own assertion, or `base_exempt` with a reason and a mutant);
   a picture per AC (AC1–AC3: the bar's top before and after the scroll and with `no-scroll` + a real wheel, 1440 and 390).
3. Beyond the fixtures: Justin's saved scan (copy `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json` into your own
   scratch folder; read-only) converted by head (`--elementor`), drawn locally with no address loaded: the header stays at
   the top through the whole page at 1440, 768, 390, in the page and in a Header template.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/verifier/ac.json` and logs there; self-check
   with `ac-check.sh` on a copy (`--base 0248176342c662b821629d462f4d15a2a2a1df98`, no `--reviews`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/shv/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). A `git archive` tree needs main's `node_modules` symlinked; piped/chained git
commands may be refused (script files, `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s; long runs
with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep
-E 'sending SIG[A-Z]* to process'` first and rerun alone under a cap.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates; the scan check; `verdict`; `ac_status`; `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal), ending with `MAIN SESSION: check and save these skill_lessons now.`
