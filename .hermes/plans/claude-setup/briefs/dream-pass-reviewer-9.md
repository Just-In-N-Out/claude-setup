# Brief: REVIEWER 9 (delta, one test-only commit), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 9** for Justin's setup story `dream-pass`. The review loop was clean at round 8. The verifier then accepted every non-live AC and raised one P2 in test code (V1-1); a fixer fixed it in one commit. You review **only that commit**. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-9/` and your scratch folder, never push, sync, merge or install, never run a real dream or the real `claude`.

**Be sparing:** Justin's weekly usage limit is nearly spent, and this is a two-line change. Do what the brief asks and stop.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` for the record's format and the severities.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Previous round's head (your `from`):** `36fd44ed76f14fbe5f060458f91b9612785da691`. **Head:** `99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`. **Base:** `63f09cb6ef84c490cc990f07b98bd27d85f5089a`.
- Review `git -C <worktree> diff 36fd44ed..99bb2f31`: one commit, two test files.
- **Before you start,** confirm HEAD equals `99bb2f3` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- Records: the verifier's finding and receipts in `~/.hermes/plans/claude-setup/evidence/dream-pass/verifier/gates/` (`hook-flake-under-load.log`, `hook-flake-30x.log`); the fixer's in `fixer-7/` (`README.md`, `red-under-load.log`, `green-under-load.log`, `mutants.md`).

### The finding and the fix
- **V1-1 (P2):** `start()` in `.claude/hooks/tests/dream-notice.test.sh` and `fire()` in `.claude/hooks/tests/dream-ledger.test.sh` fed the hook's stdin with `printf … | HOME=… bash "$HOOK"` under `set -uo pipefail`. A hook that exits before reading stdin kills the writer with SIGPIPE, the pipeline returns 141 and the test fails falsely, only under CPU load (the fixer measured 7 of 30 and 5 of 30 runs under 36 busy loops on 24 cores).
- **The fix (`99bb2f31`):** `start()` feeds stdin from a here-string; `fire()` writes the input to `$ROOT/stdin` with `printf '%s'` and redirects from that file, so the bytes stay exact (a here-string would add a newline to the empty-input case). The fixer reports 0 of 30 failures per suite under the same load, both suites passing plain and with `PATH=/usr/bin:/bin /bin/bash`, the dream suite at 92 passed, and mutants X25, X31, F1d and F12b still killed by real assertions.

## Your job
1. The diff touches only those two helpers: no hook, no assertion, no expected value, nothing else.
2. The tests still test the same thing: each case's input reaches the hook byte for byte as before (the empty-input and bad-JSON cases of the ledger test in particular); the exit code and output each case asserts on are still the hook's own; `$ROOT/stdin` cannot leak between cases or collide when the suite's cases run in the order they do.
3. The tests can still fail: run the four named mutants yourself on a scratch clone, or reverse the hook's behaviour by hand for one case of each suite, and see a real `FAIL` line.
4. The flake is gone: each suite 30 times under a CPU burst on a scratch clone of the head (about 1.5 busy loops per core; the whole thing inside `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; stop every busy loop by its own PID, never `pkill -f`), zero `rc=141`, zero `not ok`.
5. Safe under macOS `/bin/bash` 3.2 by reading (here-strings and plain redirects are).
6. Anything else you notice is P3.

## Output: `<evidence>/review-9/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-9/review.json`: round 9, scope "delta", from = `36fd44ed76f14fbe5f060458f91b9612785da691`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 63f09cb6ef84c490cc990f07b98bd27d85f5089a <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-9/` (mkdir without -p); remove it by literal path at the end.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo. Set `DREAM_TEST_ROOT` to a scratch folder so nothing is written under the live `~/.cache`.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`). A foreground command is moved to the background after about 180 s: keep each run under that.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC25 and AC31.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
