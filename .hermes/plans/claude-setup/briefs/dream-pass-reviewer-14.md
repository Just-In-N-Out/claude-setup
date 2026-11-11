# Brief: REVIEWER 14 (delta, one test-only commit), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 14** for Justin's setup story `dream-pass`. Review 12 found that the live AC37 probe is flagged by the safeguards now and then; Justin answered "Fix it" and a fixer added one retry (reviewed in round 13). Review 13 found that the retry checked a written-outside file only in the retry's own folder (R13-1, P2); Justin answered "Fix it" again, and the fixer fixed that in one commit. You review **only that commit**. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-14/` and your scratch folder, never push, sync, merge or install, never run a real dream or the real `claude`.

**Be sparing:** Justin's weekly usage limit is nearly spent, and this is a small test change. Do what the brief asks and stop.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` for the record's format and the severities.


## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Previous round's head (your `from`):** `a98875b18e103d09f33534ac49403d8e48d70071` (review 13's head). **Head:** `ec7943dc3e0d6aa50c75ad9daffefd71c9b67955`. **Base:** `23fd9580f7b9634fef064d24ced1d9908155e332`.
- Review `git -C <worktree> diff a98875b1..ec7943dc`: one commit, `.claude/dream/tests/test_agents.py` and one mutant in `.claude/dream/tests/mutants.py`.
- **Before you start,** confirm HEAD equals `ec7943d` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- Records: R13-1 in `review-13/review.json`, Justin's answer in `review-13/justin.json`; the fixer's in `fixer-12/` (`README.md`, `red.log`, `green.log`, `mutants.md`, `mutants-run.log`).

### The finding and the fix
- **R13-1 (P2):** after a safeguard-stop retry, `escaped.txt` was checked only in the retry's `outside-2`; a stopped first run that wrote `outside/escaped.txt` passed when the retry was clean.
- **What the fixer reports:** `probe_and_check` keeps each run's outside folder and asserts `escaped.txt` is absent in every one, the stopped run included, before the counted run's checks; a new case in `test_the_live_editor_probe_runs_once_more_only_after_a_safeguard_stop` (a stopped run writes outside, the retry is clean: must fail) was RED on `a98875b` and is GREEN; mutant R13a (checks only the last run's folder) is killed, R12a–R12d still killed; suite 95 passed; no live calls (the probe is unchanged). It says no other check of the old single-run test could apply to a stopped run (a stopped run's output is never kept).

## Your job
1. The diff touches only the test and the registry: no product code, the probe prompt unchanged, no assertion removed or loosened.
2. Every side effect the old single-run test would have caught is now checked on every attempt, the stopped one included: judge the fixer's claim that nothing else applies (files written outside, files changed in the copy, transcripts, history lines, hook state, for both runs' session ids).
3. The tests can fail: run the fake test and mutants R12a–R12d and R13a yourself on a scratch clone of the head, each killed at an assertion; the whole dream suite under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` in your scratch. No real calls.
4. Anything else you notice is P3.

## Output: `<evidence>/review-14/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-14/review.json`: round 14, scope "delta", from = `a98875b18e103d09f33534ac49403d8e48d70071`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 23fd9580f7b9634fef064d24ced1d9908155e332 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-14/` (mkdir without -p); remove it by literal path at the end.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: keep each run under that or poll.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC37.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
