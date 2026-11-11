# Brief: REVIEWER 15 (delta, one test-only commit), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 15** for Justin's setup story `dream-pass`. The review loop was clean at round 14. The verifier then accepted every other AC and raised one P2 in AC38's own test script (V2C-1: `regression.sh` could pass with nothing compared), and a fixer fixed it in one commit.

**Be sparing:** Justin's weekly usage limit is nearly spent, and this is one test-tooling commit. Do what the brief asks and stop.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` for the record's format and the severities.


## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Previous round's head (your `from`):** `ec7943dc3e0d6aa50c75ad9daffefd71c9b67955` (review 14's head). **Head:** `3536233cac2cb153e307cbef15d37c640d624852`. **Base:** `23fd9580f7b9634fef064d24ced1d9908155e332`.
- Review `git -C <worktree> diff ec7943dc..3536233c`: one commit: `.claude/dream/tests/regression.sh`, a new `.claude/dream/tests/test_regression.py` (run by `run.sh`) and six mutants in `.claude/dream/tests/mutants.py`.
- **Before you start,** confirm HEAD equals `3536233` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- **The AC** (approved plan `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`): AC38, "Given the existing suites (`sync.test.sh`, every `~/.claude/hooks/tests/*.test.sh`, `codex-parity.test.sh`, `ac-check.test.sh`, `review-check.test.sh`), when they run on the story's head, then each prints the same pass and fail tally as on the base"; test `regression_existing_suites_match_the_base_tally`, which `regression.sh` implements.
- Records: the verifier's finding V2C-1 and receipts in `verifier/finding-regression-vacuous/` (`probe.log`); the fixer's in `fixer-13/` (`README.md`, `red.log`, `green.log`, `mutants.md`, `ac38-3536233.log`).

### The finding and the fix
- **V2C-1 (P2):** with `TMPDIR` pointing at a folder not yet made, `--record` failed `mktemp`, ran no suite, wrote an empty baseline and exited 0; the compare against it read no suites and printed `ok 1`. A `{"suites": []}` baseline also passed the compare.
- **What the fixer reports:** a `die` function for every refusal (record: exit 2 and no baseline written; compare: `not ok 1` and exit 1); a failed `mktemp` and every write checked; the baseline written to the temporary folder first and copied into place; record refuses a suite that did not run or tallied 0 tests; compare refuses a baseline with no readable suites block, no suites, a suite at 0 tests, no base commit or one not in the checkout, or one that leaves out a suite the head has **that already existed on the baseline's base commit**; `mapfile` replaced by a `while read` loop for macOS bash 3.2. Six fake-suite tests (one control, five refusals; RED on `ec7943d`, GREEN on the head); mutants G1–G6 killed; dream suite 101 passed; the real AC38 compare on the head against `verifier/ac38-baseline.md` passed (11 suites).
- **The fixer's ruling, to judge:** "fewer suites than the head" is read as "a suite that existed on the base commit", because the story itself adds two hook suites; the base commit is taken from the first 40-character commit id in the baseline's text above the JSON block. Mutant G6 pins that exemption.
- **Named limits:** the write checks after a successful `mktemp` and the suite-count check are backups no test reaches.

## Your job
1. The diff touches only the test tooling and its tests: no dream product code, and the script's normal output and exit codes are unchanged for a good baseline.
2. Every way to pass with nothing compared is now refused: try others (a baseline whose suites block is valid JSON but names suites the head does not have; a suite whose tally line is missing or garbled; a suite that ran but printed no `1..N`; a baseline from another repository; a `--record` interrupted part way; a read-only target for the baseline). And the reverse: does any new refusal block a real, honest run (the verifier's hand-merged baseline, a baseline recorded by the head's own script on the base, the two story-added suites, a suite that legitimately has failing tests on the base)?
3. The ruling: is taking the base commit from the first 40-character id in the header robust, or can another id there (a head id, a story commit) make the exemption wrong? Say what a baseline made by the script itself and the verifier's own one contain.
4. The tests can fail: run `test_regression.py` and mutants G1–G6 yourself on a scratch clone of the head, each killed at an assertion; the whole dream suite under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` and `TMPDIR` in your scratch (make the folders first). Don't rerun the real 11-suite compare (the verifier does).
5. macOS `/bin/bash` 3.2: by reading, or on the Docker `bash:3.2` image if it is cached.
6. Anything else you notice is P3.

## Output: `<evidence>/review-15/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-15/review.json`: round 15, scope "delta", from = `ec7943dc3e0d6aa50c75ad9daffefd71c9b67955`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 23fd9580f7b9634fef064d24ced1d9908155e332 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-15/` (mkdir without -p); remove it by literal path at the end.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. A foreground command is moved to the background after about 180 s: keep each run under that or poll.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC38.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
