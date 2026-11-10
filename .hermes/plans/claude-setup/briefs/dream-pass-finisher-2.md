# FINISHER (landing): dream-pass (claude-setup), Full pipeline

Role: FINISHER. The story is accepted: `ac-check.sh` printed `READY FOR THE USER: 42 of 45 ACs proven on 99bb2f3; live ACs owed to the user: AC39 AC40 AC41`, with `REVIEWS CLEAN: review-9 at 99bb2f3`. Your job is the landing Justin approved on 2026-11-10 (the last paragraph of "Justin's answers" in the approved plan): rebase onto the newest local `main`; **if every commit is unchanged, there is no conflict and the test suites pass, it lands at once**; any conflict or changed commit means stop, because that needs a fresh review and a full re-check. Then the plan's after-merge step. You fix nothing and decide nothing.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` ("How the first real run is staged", steps 1 and 2, is what you carry out; steps 3 onward are Justin's).
- Worktree: `/home/justin/.claude-setup-wt/dream-pass` (branch `dream-pass`), head `99bb2f31f8d18ca5dfe18d4d59de61925a64b7b2`, on base `63f09cb6ef84c490cc990f07b98bd27d85f5089a`. The setup repo is `~/.claude-setup.git` with work tree `$HOME`; its local `main` moves every few minutes because Justin's other sessions run `~/.claude/setup/sync.sh`.
- Evidence: write yours in `~/.hermes/plans/claude-setup/evidence/dream-pass/finisher-2/` as you go (this desktop restarted twice today; `/tmp` is a RAM disk).

## Skills (Skill tool), one line each
`engineering-best-practices`, `git-commit-rules`.

## Part 1: rebase, prove it pure, run the suites
1. Confirm the worktree's HEAD is the head above and `git -C <worktree> status --porcelain --untracked-files=all` is empty. If not, stop and report.
2. Record `main`'s SHA, then in the worktree `git rebase main`. On **any** conflict: `git rebase --abort` and stop with `status: stopped`, naming the file. Do not resolve it.
3. Prove the rebase pure: `git range-diff 63f09cb6..99bb2f31 <main sha>..HEAD` must show every pair as `=` (save it as `finisher-2/range-diff-<n>.txt`); same number of commits (51), same authors and messages, no merge commits. If any pair is not `=`: `git reset --hard 99bb2f31` is **not** allowed; instead leave the branch as it is, stop with `status: stopped` and report the pair.
4. On the rebased head, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, with `DREAM_TEST_ROOT` and `TMPDIR` in your own cache folder, logs in `finisher-2/` (first line `HEAD=<sha>`, last line `EXIT=<code>`):
   - the whole dream suite (`bash .claude/dream/tests/run.sh`);
   - both dream hook suites (`.claude/hooks/tests/dream-ledger.test.sh`, `dream-notice.test.sh`);
   - the regression gate: a fresh baseline on a `git clone` of that `main` (two `--record` runs of the head's `regression.sh` with its root option, a test counting as passing when either run passes), then `bash .claude/dream/tests/regression.sh <baseline>` on a clone of your head. Some existing suites have millisecond limits and flip under load: check `uptime`, wait up to 20 minutes for the 1-minute load to fall under about 8, record the load at each stage, and rerun a failing suite alone on `main` and on the head before reading a mismatch as real. `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on `main`.
   If a suite fails for a reason that is not load, stop with `status: stopped` and the log. Don't fix anything.

## Part 2: land it
`main` will probably have moved while the suites ran. So:
5. If `main` moved since your rebase: rebase again onto it, prove it pure again (step 3, against the previous rebased head's range), and rerun the dream suite and both hook suites on the new head (a few minutes; the regression gate is not rerun for a pure re-rebase unless the commits `main` gained touch `.claude/hooks/`, `.claude/setup/`, `.claude/githooks/`, `.codex/` or `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/`, in which case rerun it too). Repeat until the suites have passed on a head whose base is the current `main`. Give up after 5 rounds and report.
6. Then, at once, the merge, under `sync.sh`'s own lock so no sync commits in the middle. Read how `~/.claude/setup/trim/land.sh` takes and releases that lock (`$HOME/.claude-setup.git/setup-sync.lock`) and do the same; hold it for seconds only. Under the lock:
   - `main` must still be the SHA you rebased onto; if not, release the lock and go back to step 5;
   - no file the merge will change may have an uncommitted change under `$HOME` (`git --git-dir="$HOME/.claude-setup.git" --work-tree="$HOME" status --porcelain -- <the story's changed paths>`); if one does, another session is mid-edit: release the lock, run `~/.claude/setup/sync.sh pull` once (it commits that edit), and go back to step 5. Never stash, reset, discard or overwrite someone's edit;
   - `cd "$HOME" && git --git-dir="$HOME/.claude-setup.git" --work-tree="$HOME" merge --ff-only dream-pass`;
   - release the lock. Never delete a lock that is not yours.
7. Check and record: `git --git-dir="$HOME/.claude-setup.git" log --oneline -3 main` shows the story's commits on top; `main` equals the branch head; `~/.claude/dream/bin/dream`, `~/.claude/hooks/dream-ledger.sh` and `dream-notice.sh` exist; `~/.claude/settings.json` parses as JSON (`jq . >/dev/null`) and holds the two dream hook entries; the three `references/repeat-mistakes.md` files exist under `~/.hermes/skills/…/leorna`, `figma-to-bricks` and `feature-dispatch`; `~/.claude/CLAUDE.md`'s size in bytes; `git -C ~/.hermes/skills-library rev-list --count origin/main..HEAD` is 0; no `setup-sync.lock` is left.

## Part 3: the plan's after-merge step (only after a successful merge)
8. `~/.claude/dream/bin/dream install` **without `--enable`**, then `~/.claude/dream/bin/dream init`, then `~/.claude/dream/bin/dream status`. Save the output. Then check and report: `~/.claude/dream/local/` exists and the mode is `dry-run`; `~/.config/systemd/user/dream.service` and `dream.timer` exist and pass `systemd-analyze --user verify`; `systemctl --user is-enabled dream.timer` says it is **not** enabled and `systemctl --user is-active dream.timer` says inactive; `dream init`'s summary (how many sessions wait to be read, how many were skipped).
9. Add one "Landed" line at the end of `~/.hermes/plans/claude-setup/dream-pass.md`: the date, the `main` SHA, "timer off, mode dry-run", and that AC39, AC40 and AC41 are owed to Justin. Change nothing else there.
10. Stop. Do **not** run `sync.sh` to push (the main session does that and the final check).

## Hard rules
- Never start `dream.service`, never run `dream run`, `dream mode live` or `dream install --enable`, never `systemctl --user enable` or `start` anything, never `loginctl enable-linger`. Those are Justin's steps (AC39, AC40, AC41).
- Never call the real `claude` (don't run the named-only live test).
- Never push, never touch `~/Leorna/`, never commit in `~/.hermes/skills-library`.
- Never stash, reset, force, or resolve a conflict. Keep the repo identity on every commit (`Justin <issajustin04@gmail.com>`; a rebase keeps authors); no AI or Co-Authored-By trailer.
- If the merge has happened and a later step fails, do not try to undo the merge: stop and report exactly what is and is not done.
- **Be sparing:** Justin's weekly usage limit is nearly spent. If a request is refused for the limit, stop cleanly and say exactly where you are (rebased or not, merged or not, installed or not).
- Scratch in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-finisher-2/` (mkdir, no -p); big things under `~/.cache/dream-pass-finisher-2/`; remove both by literal path at the end.
- SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first (its start banner, a line with no process name, is not a kill).
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`; desktop `mkdir` (uutils) is not atomic. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound, and don't end your turn while one runs.

## Report
Return `{status: landed|stopped, main_before, main_after, head_landed, rebase_rounds, pure: yes|no with evidence, suites[{name, tally, on_head}], regression: ok|not ok, merged: yes|no, installed: yes|no, mode, timer_enabled, init_summary, claude_md_bytes, library_clone_commits, lock_left, stop_reason, steps_for_justin[], found_else[], skill_lessons[]}` in plain words. `steps_for_justin` are the exact commands for AC40, AC41 and AC39, in that order, each with the window to run it in (the Ubuntu window) and sudo commands as one `&&` line.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
