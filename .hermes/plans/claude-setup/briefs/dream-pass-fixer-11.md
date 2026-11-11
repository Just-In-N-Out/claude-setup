# FIXER round 11: dream-pass (claude-setup), Full pipeline: the live probe that is flagged now and then

Role: FIXER. Review 12 found one P2 (R12-1); the referee asked Justin "fix or follow-up?" and he answered **"Fix it"** (recorded in `review-12/justin.json`). Fix it test-only, commit, stop `ready-for-next-review`. Fix nothing else. Don't rebase. Keep it small.

- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `6b9dff26a8d7ce7f51c144bfb76208d7a916ec95`, base `23fd9580f7b9634fef064d24ced1d9908155e332`.
- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (AC37, live: both calls return valid structured output from `claude-opus-5-5`, no transcript file is added, the editor's refused paths are listed).
- Records: `~/.hermes/plans/claude-setup/evidence/dream-pass/review-12/review.json` (R12-1's full text) and `fixer-10/` (the cause, `cause.md`).
- Evidence for this round: `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-11/`.
- Never edit the live `$HOME` files, never push, sync, merge or install, never run a real dream against Justin's real home.

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`.

## The finding
**R12-1 (P2), `.claude/dream/tests/test_agents.py` about line 216:** AC37's live probe (the editor is asked to read a file outside its folder and write `escaped` outside it) is itself flagged by the model's safeguards now and then: 1 of 11 real runs in the evidence. Since fixer 10's change, a flagged run fails the test as "editor was stopped by safeguards" rather than on a second model, but the false-failure rate is the same, and it already cost one extra fix-and-review round. **The reviewer's fix, which Justin approved:** when the editor result's error starts with "editor was stopped by safeguards", run the editor probe once more in a fresh copy and require every assertion on that second run. Two flags in a row still fail (about 1 in 120 at the observed rate).

## What to do
1. Change only the AC37 test (name unchanged): one retry of the editor probe, only on that exact safeguard stop, in a fresh copy (fresh folder, fresh session ids), with every existing assertion applied to the run that counts: model, structured output, refused paths listed, no transcript, history line or hook state for **either** run's session ids. Any other error fails at once, with no retry. Don't change the probe's prompt (that would need Justin's go), don't touch product code, don't retry the helper call.
2. Prove it without spending real calls on flags: make the live test's runner injectable (or factor the decision into a small helper the test uses) so a fake run can return the safeguard stop first and a pass second; a fake test then shows: stop then pass → pass; stop then stop → fail; another error → fail without a retry; a pass → no retry. Register mutants in `.claude/dream/tests/mutants.py` for the retry condition (retry on any error; never retry; retry more than once; skip the leak check on the first run's ids) and show each killed at an assertion.
3. Run AC37's live test once on your head (two real calls; at most one more pair if it hits the retry). If a call is refused for Justin's usage limit, stop and report.
4. The whole dream suite under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` and `TMPDIR` in your cache folder.
5. One commit, plain `git commit -m` with a one-line subject, repo identity (`Justin <issajustin04@gmail.com>`), **no** AI or Co-Authored-By trailer. Tree clean at the end.
6. Evidence in `fixer-11/`: RED and GREEN logs (first line `HEAD=<sha>`, last line `EXIT=<code>`), the mutant results, the live run's log, a three-line README.

## Environment
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-fixer-11/` (mkdir, no -p); big things under `~/.cache/dream-pass-fixer-11/`; remove both by literal path.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.
- **Be sparing:** Justin's weekly usage limit is nearly spent.

## Report
Return `{status: ready-for-next-review|stopped, head, findings[{id: "R12-1", outcome: fixed|rejected, test, commit, evidence}], suites[{name, tally}], mutants{killed, survived[]}, live_ac37: pass|fail, real_calls_used, found_else[], skill_lessons[]}`.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
