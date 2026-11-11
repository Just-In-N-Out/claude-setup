# Brief: REVIEWER 11 (delta, one test-only commit), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 11** for Justin's setup story `dream-pass`. The review loop was clean at round 10. The blind auditor then did not accept AC8 (one clause had no test that could catch a break), and a fixer extended that test in one commit. You review **only that commit**. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-11/` and your scratch folder, never push, sync, merge or install, never run a real dream or the real `claude`.

**Be sparing:** Justin's weekly usage limit is nearly spent, and this is a 49-line test change. Do what the brief asks and stop.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` for the record's format and the severities.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Previous round's head (your `from`):** `2d69e1e42b126b15a534a09d801f3d4cec411ce2`. **Head:** `ee17d9885d00d3d7ffa1f85bce1d9912980b5c7e`. **Base:** `299862e4911cd842f259a79d78d4499192928a43`.
- Review `git -C <worktree> diff 2d69e1e4..ee17d988`: one commit, `.claude/dream/tests/test_bar.py` (+46) and `.claude/dream/tests/mutants.py` (+3).
- **Before you start,** confirm HEAD equals `ee17d98` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- **The AC** (from the approved plan, `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`): "AC8: Given one explicit correction or stated decision from Justin and one merely implied preference, when the bar script runs, then the first passes at once and the second waits in `state/pending.json`; when a later run's helper matches a second session to that pending candidate it passes then." Test: `test_ac8_explicit_passes_at_once_and_single_sightings_wait_across_runs`.
- Records: the auditor's finding and receipts (`auditor/mutants/mutants/A8p.log`, `auditor/support/a8p-fullsuite.log`); the fixer's in `fixer-9/` (`README.md`, `red-a8p-old-test.log`, `green-ac8.log`, `green-dream-suite.log`, `mutants.md`).

### The finding and the fix
- **AUD2-1 (P2):** `test_ac8` carried the pending dict in memory between two `bar.check()` calls and never read `state/pending.json`; the auditor's mutant A8p (`apply.py` drops `("pending", …)` from its state-file loop) survived the test and the whole suite.
- **The fix:** after every existing assertion, `test_ac8` now runs the dream twice on a fake home: run 1 with a correction and an implied preference (the editor gets only the correction; `state/pending.json` on disk holds that one candidate); run 2 with a second session matching it by the id read from the file (the editor is called with it; the id is gone from `state/pending.json`; the line is in the live memory note). Mutants registered: A8p, and A8r (`run.py` never reads `pending.json` back). The fixer reports M3, A8p and A8r killed and the dream suite at 93 passed.

## Your job
1. The diff touches only the test and the registry: no product code, no other test, no assertion of `test_ac8` removed or loosened.
2. The new part tests the AC's clause for real: it reads the file the code writes (not a value the test set itself), the second run really goes through the reading path, and the run-2 match uses the id from the file rather than a constant that would pass anyway. Say whether any check in it can pass vacuously.
3. The tests can fail: run M3, A8p and A8r yourself on a scratch clone of the head (`.claude/dream/tests/mutants.py`, as its header says), each killed at an assertion, not a crash; then the unchanged test on the head passes.
4. The whole dream suite on a scratch clone of the head (`bash .claude/dream/tests/run.sh` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` in your scratch).
5. Anything else you notice is P3.

## Output: `<evidence>/review-11/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-11/review.json`: round 11, scope "delta", from = `2d69e1e42b126b15a534a09d801f3d4cec411ce2`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 299862e4911cd842f259a79d78d4499192928a43 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-11/` (mkdir without -p); remove it by literal path at the end.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: keep each run under that or poll.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC8.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
