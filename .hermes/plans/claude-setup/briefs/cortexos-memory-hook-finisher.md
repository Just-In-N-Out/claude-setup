# FINISHER step 1: cortexos-memory-hook (claude-setup)

Role: FINISHER, step 1 of "Worktrees from `claude -w`" applied to the setup repo. ac-check printed READY FOR THE USER at head
6b8860715c6e3f2cb9b48240dbaefc287402a4a2 (live ACs AC15, AC16 owed to Justin).
- Worktree /home/justin/.claude-setup-wt/cortexos-memory-hook, branch cortexos-memory-hook; setup repo gitdir ~/.claude-setup.git
  (bare, work tree $HOME). Run git with `-C <worktree>` (pathspecs from a cwd under $HOME silently narrow otherwise).
- Do: confirm the tree is clean and everything is committed; `git -C <worktree> rebase main` onto LOCAL main as it is now (never
  fetch/pull/push; main has moved, e.g. fffd18f also edits .github/README.md in a different hunk). On a conflict keep both sides'
  meaning. Then re-run the whole offline cortexos-memory suite and every suite AC14 names under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; tallies must equal the reviewed head's (cortexos-memory 15/0;
  harness-guards 19/0, setup-sync-pull 8/0, skill-review-nudge 16/0, subagent-ac-gate 31/0, subagent-handback-gate 13/0,
  subagent-lessons-gate 22/0, sync 32/0, codex-parity 15/3 with the same 3 pre-existing failures — if main changed a suite's
  count, report it rather than "fixing" it).
- Report whether the result is a pure rebase: `git -C <worktree> range-diff 6b88607~8..6b88607 main..HEAD` style comparison of the
  story's commits (base dd80ac4), and `git patch-id --verbatim` equality per commit.
- Don't: merge into main, ExitWorktree, run sync.sh, edit live $HOME files, write to CortexOS, add AI trailers, override authorship.
- Stop and report the new HEAD. Scratch: fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-finisher/`
  (mkdir, no -p), removed by literal path. SIGTERM/143/137/"Killed" may be earlyoom: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`.

## Skills (Skill tool), one line each
`git-commit-rules`, `engineering-best-practices`.

## Report
Return `{status: rebased|stopped, old_head, new_head, main_at, pure_rebase: true|false, conflicts[], suites[{name, tally}], found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
