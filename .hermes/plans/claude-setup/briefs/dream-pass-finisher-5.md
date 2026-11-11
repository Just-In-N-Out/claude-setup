# FINISHER (after-merge step): dream-pass (claude-setup), Full pipeline

Role: FINISHER, the after-merge step of `~/.claude/CLAUDE.md` step 7. dream-pass is merged: local `main` of the setup repo is `a7288940b977e5fba1345da67c3a94312a4ba932` and is pushed to GitHub (`ac-check.sh` printed `READY FOR THE USER: 42 of 45 ACs proven on a728894`, with `REBASE  ACCEPTED`). Your job is the plan's after-merge step and nothing else.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md`, section "How the first real run is staged", steps 1 and 2 (step 3 onward is Justin's).
- The dream lives at `~/.claude/dream/` (live, merged). Its CLI is `~/.claude/dream/bin/dream`; read its usage (`dream --help` or the header of `~/.claude/dream/lib/dreamlib/run.py`) before you run it.
- Evidence: `~/.hermes/plans/claude-setup/evidence/dream-pass/finisher-5/`.

## Skills (Skill tool), one line each
`engineering-best-practices`.

## Steps
1. Confirm `git --git-dir="$HOME/.claude-setup.git" rev-parse main` is `a7288940…` or a descendant of it (other sessions sync), and that `~/.claude/dream/bin/dream` exists.
2. `~/.claude/dream/bin/dream install` **without `--enable`**. Save its output.
3. `~/.claude/dream/bin/dream init`. Save its output, including how many sessions wait to be read and how many were skipped.
4. `~/.claude/dream/bin/dream status`. Save its output.
5. Check and report, changing nothing: `~/.claude/dream/local/` exists and the mode is `dry-run`; `~/.config/systemd/user/dream.service` and `dream.timer` exist and pass `systemd-analyze --user verify`; `systemctl --user is-enabled dream.timer` says it is not enabled and `systemctl --user is-active dream.timer` says inactive; `systemctl --user is-active dream.service` says inactive; the session-start hook `~/.claude/hooks/dream-notice.sh` prints what it should for a dream that has not run yet (run it by hand with an empty JSON on stdin: `bash ~/.claude/hooks/dream-notice.sh </dev/null` or as its test does, and save its output).
6. Add one "Landed" line at the end of `~/.hermes/plans/claude-setup/dream-pass.md`: `Landed <date>: merged into setup-repo main at a7288940 and pushed; installed with the timer off, mode dry-run; AC39, AC40 and AC41 are owed to Justin.` Change nothing else there.
7. Stop. Don't run `sync.sh` (the main session does).

## Hard rules
- Never start `dream.service`, never run `dream run`, `dream mode live` or `dream install --enable`, never `systemctl --user enable` or `start` anything, never `loginctl enable-linger`. Those are Justin's steps.
- Never call the real `claude`. Never push, merge or commit. Never touch `~/Leorna/` or `~/.hermes/skills-library`.
- If a step fails, stop and report its output verbatim; don't work around it and don't undo the merge.
- **Be sparing:** Justin's weekly usage limit is nearly spent.
- In the Bash tool `grep` is ugrep (use `command grep`); never `pkill -f`.

## Report
Return `{status: installed|stopped, main_sha, install_output, init_summary, status_output, mode, units_verify, timer_enabled, timer_active, service_active, notice_output, landed_line, stop_reason, steps_for_justin[], found_else[], skill_lessons[]}` in plain words. `steps_for_justin` are the exact commands for AC40, AC41 and AC39, in that order, from the plan and the dream's own CLI: each for the Ubuntu window, any sudo command as one `&&` line, with what Justin should look at after each.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
