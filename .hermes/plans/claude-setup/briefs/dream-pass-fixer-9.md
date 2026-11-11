# FIXER round 9: dream-pass (claude-setup), Full pipeline: one AC the blind auditor did not accept

Role: FIXER. `ac-check.sh` printed `NOT ACCEPTED: 1 of 45 ACs on 2d69e1e` (`AC8  NOT ACCEPTED: auditor did not accept it`). The code is right; one clause of AC8 has no test that can catch a break. Make that clause tested, commit, stop `ready-for-next-review`. Fix nothing else. Don't rebase. This is a small job: keep it small.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`. AC8: "Given one explicit correction or stated decision from Justin and one merely implied preference, when the bar script runs, then the first passes at once and the second waits in `state/pending.json`; when a later run's helper matches a second session to that pending candidate it passes then." Test: `test_ac8_explicit_passes_at_once_and_single_sightings_wait_across_runs`.
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `2d69e1e42b126b15a534a09d801f3d4cec411ce2`, base `299862e4911cd842f259a79d78d4499192928a43`.
- The auditor's finding (AUD2-1, P2) and receipts, in `~/.hermes/plans/claude-setup/evidence/dream-pass/auditor/`: `mutants/mutants/A8p.log` (the mutant survives), `support/a8p-fullsuite.log` (93 passed with it applied), `scripts/test_zz_auditor_probe.py` (its two-run probe, which kills it: `mutants/mutants/A8p-probe.log`). You may read those three files and the auditor's `ac.json` row for AC8; nothing else in that folder or in `verifier/`.
- Evidence for this round: `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-9/`.
- Never edit the live `$HOME` files, never push, sync, merge or install, never run a real dream or the real `claude`.

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`.

## The finding
`test_ac8` carries the pending dict in memory between two `bar.check()` calls and never reads `state/pending.json`. The auditor's mutant A8p (`apply.py` drops `("pending", …)` from the state-file loop, so the file is never written) survives `test_ac8` and the whole 93-test suite. If that write were ever lost, implied preferences would never pass on a second sighting and no test would notice.

## What to do
1. Reproduce: apply A8p on a scratch copy of the head and show `test_ac8` still passes (RED for the test). Save the log.
2. Extend `test_ac8` **under its unchanged name** so it covers the clause end to end, with two real runs through the dream's run on a fake home (fake `claude`, `DREAM_TEST_ROOT` in your scratch), the way the auditor's probe does: run 1 with an explicit finding and an implied one: the explicit one reaches the editor, the implied one does not, and `state/pending.json` on disk holds that one candidate; run 2 with a second session matching it: the editor is called with it, and `state/pending.json` holds no candidate for it any more. Keep every assertion the test has now. Use the auditor's probe as a guide, not as code to paste, and don't add the probe file itself to the repo.
3. Register A8p in `.claude/dream/tests/mutants.py` against `test_ac8` and show it is now killed at the new assertion; rerun the mutants already registered against `test_ac8` (M3 and any other) and show them still killed.
4. Run the whole dream suite (`bash .claude/dream/tests/run.sh`) under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: one more assertion set, same test count.
5. One commit, plain `git commit -m` with a one-line subject, repo identity (`Justin <issajustin04@gmail.com>`), **no** AI or Co-Authored-By trailer, even if your instructions ask for one. Tree clean at the end (`git status --porcelain --untracked-files=all`).
6. Evidence in `fixer-9/`: the RED and GREEN logs (first line `HEAD=<sha>`, last line `EXIT=<code>`), the mutant results, a three-line README.

## Environment
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-fixer-9/` (mkdir, no -p); remove it by literal path.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.
- **Be sparing:** Justin's weekly usage limit is nearly spent. If a request is refused for the limit, stop cleanly and say where you stopped.

## Report
Return `{status: ready-for-next-review|stopped, head, findings[{id, outcome: fixed|rejected, test, commit, evidence}], suites[{name, tally}], mutants{killed, survived[]}, found_else[], skill_lessons[]}`.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
