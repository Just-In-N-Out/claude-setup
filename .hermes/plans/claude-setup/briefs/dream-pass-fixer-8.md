# FIXER round 8: dream-pass (claude-setup), Full pipeline: the `CLAUDE.md` budget, then the rebase with its one known conflict

Role: FIXER, with one rebase Justin's situation makes unavoidable inside the loop. The story was accepted on `99bb2f31` (`READY FOR THE USER: 42 of 45`), but its landing stopped: rebasing onto `main` conflicts in `.claude/CLAUDE.md`, and after the rebase the story's own docs test would fail because `main`'s `CLAUDE.md` grew past the 30,000-byte budget. Justin decided on 2026-11-10: **the dream's budget for the global `CLAUDE.md` is raised to 36,000** (the last paragraph of "Justin's answers" in the approved plan). You make that change, then rebase and resolve the one known conflict, run the suites and stop `ready-for-next-review`. Fix nothing else.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`.
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`, base `63f09cb6ef84c490cc990f07b98bd27d85f5089a`. The setup repo is `~/.claude-setup.git` (work tree `$HOME`); its local `main` moves every few minutes.
- The stopped landing's records: `~/.hermes/plans/claude-setup/evidence/dream-pass/finisher-2/stop.txt` and `conflict-CLAUDE.md.diff`.
- Evidence for this round: `~/.hermes/plans/claude-setup/evidence/dream-pass/fixer-8/`. Write receipts there as you go (this desktop restarted twice today; `/tmp` is a RAM disk).
- Never edit the live `$HOME` files, never push, sync, merge into `main` or install, never run a real dream or the real `claude`.

## Skills (Skill tool), one line each
`receiving-code-review`, `test-driven-development`, `engineering-best-practices`, `mutation-testing-discipline`, `git-commit-rules`.

## Part 1: the budget (on the current head, before any rebase)
1. Confirm HEAD is the head above and `git -C <worktree> status --porcelain --untracked-files=all` is empty.
2. The number lives in at least three places: `.claude/dream/conf/budgets.tsv` (row `.claude/CLAUDE.md 30000`), `.claude/dream/tests/test_docs.py` (about line 91: fails at 30,000 bytes or more) and `.claude/dream/DREAM.md` section 6's "Size budgets" line. Find every other place that states the global `CLAUDE.md`'s budget (docs, prompts, `desktop.md`, tests, fixtures, the mutant registry) and change each to 36,000. Don't touch the 30,000 that is the moved-bytes cap (`caps.conf`, `moved = 30000`) or any other file's budget.
3. Test first: show RED by running the docs test against a tree whose `CLAUDE.md` is over 30,000 and under 36,000 bytes (the size it will have after the rebase, about 31,900), then GREEN with the change; and keep the test able to fail: a `CLAUDE.md` of 36,000 bytes or more must still fail it, and the dream's own budget guard must still refuse an edit that takes the file past 36,000 and allow one that keeps it under (use the existing budget tests' pattern). Rerun the mutants registered against the tests you touch.
4. One commit, plain `git commit -m` with a one-line subject.

## Part 2: the rebase
5. Record `main`'s SHA; `git rebase main` in the worktree.
6. The one conflict you may resolve is the known one, in `.claude/CLAUDE.md`, while applying story commit `12f5792e`: `main`'s commit `1cc9837d` rewrote the line that begins "- **Agent models (user, …" and the story adds one sentence, "The dream reads the same skills and never duplicates a saved lesson.", to the line that begins "- **Subagents report skill lessons, the main session saves them" right beside it. Keep `main`'s text of both lines exactly as `main` has it and add the story's one sentence at the same place in the lessons line (after "…that the skill doesn't already say."). Nothing reworded, nothing dropped. The story's own "Dream Pass" section keeps the story's version.
7. Any other conflict, in any file: `git rebase --abort`, stop with `status: stopped` and name it. Don't resolve it.
8. After the rebase, record in `fixer-8/`: `git range-diff 63f09cb6..<your budget commit> <main sha>..HEAD` (every pair must be `=` except `12f5792e`'s successor); the proof that both sides were kept in `CLAUDE.md` (rebuild the resolution: `main`'s own change of the file applied to the pre-rebase head's file must give the rebased file; where both sides changed one line, show it at the word level); `CLAUDE.md`'s size in bytes against 36,000; and that the three `SKILL.md` files still carry `main`'s text plus the story's one pointer line each.

## Part 3: the suites, on the rebased head
9. Each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` and `TMPDIR` in your own cache folder, logs in `fixer-8/` (first line `HEAD=<sha>`, last line `EXIT=<code>`):
   - the whole dream suite (`bash .claude/dream/tests/run.sh`);
   - both dream hook suites, plain and as `PATH=/usr/bin:/bin /bin/bash <suite>`;
   - the regression gate with a fresh baseline: two `--record` runs of the head's `regression.sh` on a `git clone` of that `main` (a test counts as passing when either run passes), then `bash .claude/dream/tests/regression.sh <baseline>` on a clone of your head. `main` has gained changes to `feature-dispatch/scripts/` and `.claude/setup/codex/` since the story's base, so this gate matters. Some suites have millisecond limits: check `uptime`, wait up to 20 minutes for the 1-minute load to fall under about 8, record the load at each stage, and rerun a failing suite alone on `main` and on the head before reading a mismatch as real.
   A failure that is not load: don't fix it, report it with its log.
10. Tree clean (`git status --porcelain --untracked-files=all` empty). If `main` moved while you worked, stay on the `main` you rebased onto and report both SHAs.

## Rules
- Commits keep the repo identity (`Justin <issajustin04@gmail.com>`); no AI or Co-Authored-By trailer; no author overrides.
- List every line of `DREAM.md` you change in your report: that file changes only when Justin says so (this change is his decision), and he is shown each line.
- **Be sparing:** Justin's weekly usage limit is nearly spent. If a request is refused for the limit, stop cleanly and say exactly where you are (budget commit made or not, rebased or not; mid-rebase: `git rebase --abort` first).
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-fixer-8/` (mkdir, no -p); big things under `~/.cache/dream-pass-fixer-8/`; remove both by literal path.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `| grep -q` under `pipefail`; never `pkill -f`; desktop `mkdir` (uutils) is not atomic. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound, and don't end your turn while one runs.

## What comes after you
A fresh review of your budget commit and the rebase resolution, then a fresh verifier and a fresh blind auditor on your head, then `ac-check.sh`, then the landing.

## Report
Return `{status: ready-for-next-review|stopped, old_head, budget_commit, main_sha, main_now, new_head, conflicts[{file, kept}], both_sides_kept: yes|no with evidence, claude_md_bytes, dream_md_lines[], range_diff_changed[], suites[{name, tally}], regression: ok|not ok, mutants{killed, survived[]}, stop_reason, found_else[], skill_lessons[]}` in plain words.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
