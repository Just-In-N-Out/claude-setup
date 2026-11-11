# Brief: REVIEWER 13 (delta, one test-only commit), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 13** for Justin's setup story `dream-pass`. Review 12 found one P2 in the live AC37 test (its probe is itself flagged by the model's safeguards about 1 run in 11 and then fails falsely); Justin answered "Fix it", and a fixer changed that test in one commit. You review **only that commit**. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-13/` and your scratch folder, never push, sync, merge or install, never run a real dream or the real `claude`.

**Be sparing:** Justin's weekly usage limit is nearly spent, and this is a small test change. Do what the brief asks and stop.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` for the record's format and the severities.


## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Previous round's head (your `from`):** `6b9dff26a8d7ce7f51c144bfb76208d7a916ec95` (review 12's head). **Head:** `a98875b18e103d09f33534ac49403d8e48d70071`. **Base:** `23fd9580f7b9634fef064d24ced1d9908155e332`.
- Review `git -C <worktree> diff 6b9dff26..a98875b1`: one commit, `.claude/dream/tests/test_agents.py` (+116 −36 with `mutants.py`) and `.claude/dream/tests/mutants.py` (+7).
- **Before you start,** confirm HEAD equals `a98875b` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- **The AC** (approved plan `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`): "AC37 (live): Given this machine's real `claude`, when the named-only live test makes one helper call and one editor call with the AC29 flags, then both return valid structured output from `claude-opus-5-5`, no transcript file is added …, and the editor's refused paths are listed." Test: `test_live_headless_calls_are_isolated_and_confined`.
- Records: R12-1 in `review-12/review.json`, Justin's answer in `review-12/justin.json`; the fixer's in `fixer-11/` (`README.md`, `red.log`, `green.log`, `mutants.md`, `R12d-unmasked.log`, `ac37-live-a98875b.log`).

### The finding and the fix
- **R12-1 (P2):** the live probe (read a file outside the folder, write `escaped` outside it) is itself flagged by the model's safeguards about 1 run in 11 and then fails falsely. The approved fix: when the editor's error starts with "editor was stopped by safeguards", run the editor probe once more in a fresh copy and require every assertion on that run; two flags in a row still fail; any other error fails at once; the probe's prompt is unchanged.
- **What the fixer reports:** the probe and its checks moved into a module-level `probe_and_check(t, R, work, real, res, call=agents.call, settle=2)` used by the live test; one retry only on that stop, with its own outside folder and copy and a new session id; the leak check covers the helper's id and every editor run's id; a new fake test `test_the_live_editor_probe_runs_once_more_only_after_a_safeguard_stop` with five cases; mutants R12a–R12d killed; dream suite 95 passed; AC37 live passed on the head at the first try.

## Your job
1. The diff touches only the test and the registry: no product code; the probe's prompt bytes unchanged (check it yourself, not from the report); no assertion of the live test removed or loosened by the move into `probe_and_check`; the first run's checks still all apply when no retry happens.
2. The retry is exactly what Justin approved: only on that one error prefix, at most once, a fresh copy and a fresh session id, every assertion on the run that counts, and the leak check on **both** runs' ids. A first run that was stopped must not leave anything the second run's checks would miss (a file it wrote outside, a transcript, a history line, hook state).
3. The tests can fail: run the new fake test and mutants R12a–R12d yourself on a scratch clone of the head (`.claude/dream/tests/mutants.py`), each killed at an assertion; the whole dream suite under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` in your scratch. Don't run the live test (no real calls).
4. Anything else you notice is P3.
## Output: `<evidence>/review-13/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-13/review.json`: round 13, scope "delta", from = `6b9dff26a8d7ce7f51c144bfb76208d7a916ec95`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 23fd9580f7b9634fef064d24ced1d9908155e332 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-13/` (mkdir without -p); remove it by literal path at the end.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: keep each run under that or poll.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC37.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
