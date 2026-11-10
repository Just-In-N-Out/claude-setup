# FIXER round 7: dream-pass (claude-setup), Full pipeline: one verifier finding, in two test helpers

Role: FIXER. The verifier accepted every non-live AC on `36fd44ed` and raised one P2, in test code only. Verify it (`receiving-code-review`), fix it, commit, stop `ready-for-next-review`. Fix nothing else. Don't rebase; add one commit on top of the head. This is a small job: keep it small.

- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `36fd44ed76f14fbe5f060458f91b9612785da691`, base `63f09cb6ef84c490cc990f07b98bd27d85f5089a`.
- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`.
- The verifier's receipts: `~/.hermes/plans/claude-setup/evidence/dream-pass/verifier/gates/hook-dream-notice.log`, `hook-dream-notice-minpath.log`, `hook-flake-under-load.log`, `hook-flake-30x.log`.
- Never edit the live `$HOME` files, never push, sync, merge or install, never run a real dream or the real `claude`.

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `git-commit-rules`.

## The finding
**V1-1 (P2):** the named tests of AC31 and AC25 fail at random under CPU load, with no defect in the hooks. `start()` in `.claude/hooks/tests/dream-notice.test.sh` (line 11) and `fire()` in `.claude/hooks/tests/dream-ledger.test.sh` (line 14) run `printf '<json>' | HOME=… bash "$HOOK"` under `set -uo pipefail`. `dream-notice.sh` never reads stdin, and `dream-ledger.sh` exits before reading it when `local/` is missing. When the hook exits before `printf` writes, the writer dies of SIGPIPE, the pipeline returns 141 and the test prints `FAIL: … rc=141`. Measured: 3 of 9 runs of the notice suite and 2 of 9 of the ledger suite failed under 36 busy loops on 24 cores; 0 of 30 alone. It only ever fails falsely. The verifier's smallest fix: feed the hook's stdin without a pipe in both helpers (a here-string, `bash "$HOOK" <<<"$json"`, or a file redirect).

## What to do
1. Reproduce it first, on a scratch clone of the head, the way the verifier did: each suite several times under a short CPU burst (about 1.5 busy loops per core for about 25 s, the whole thing inside `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, and make sure every busy loop is stopped afterwards by its own PID, never `pkill -f`). Save the RED log.
2. Fix both helpers. Check both test files for any other place that feeds a hook through a pipe and fix those too; change nothing in the hooks themselves and no assertion. Keep the files safe for macOS `/bin/bash` 3.2 (here-strings are fine there).
3. Show GREEN the same way: the same number of runs under the same burst, zero `rc=141` and zero `not ok`. Then both suites once plain and once as `PATH=/usr/bin:/bin /bin/bash <suite>`, and the whole dream suite (`bash .claude/dream/tests/run.sh`).
4. The story's mutants registered against these two tests (`X25`, `X31` and any other that names `ac25_…` or `ac31_…` in `.claude/dream/tests/mutants.py`) must still be killed: rerun just those.
5. One commit, plain `git commit -m` with a one-line subject, repo identity (`Justin <issajustin04@gmail.com>`), no AI or Co-Authored-By trailer. Tree clean at the end (`git status --porcelain --untracked-files=all`).
6. Evidence in `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-7/`: the RED and GREEN logs (first line `HEAD=<sha>`, last line `EXIT=<code>`) and a three-line README.

## Environment
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-fixer-7/` (mkdir, no -p); remove it by literal path.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`). A foreground command is moved to the background after about 180 s: keep each run under that.
- **Be sparing:** Justin's weekly usage limit is nearly spent. If a request is refused for the limit, stop cleanly and say where you stopped.

## Report
Return `{status: ready-for-next-review|stopped, head, findings[{id, outcome: fixed|rejected, commit, evidence}], suites[{name, tally}], mutants{killed, survived[]}, found_else[], skill_lessons[]}`.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
