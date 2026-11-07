# PLANNER (amendment only): cortexos-memory-hook — AC2 and the Design's space rule

Role: PLANNER. Edit only the working plan ~/.hermes/plans/claude-setup/cortexos-memory-hook.md (never plan-approved.md, never code).
Justin's ruling (2026-11-07, evidence review-2/justin.json): keep R1-2's behaviour (the project space follows the session into
subfolders and worktrees, falling back to the session's own project folder) and fix R2-1 (never cross the cwd's git repository:
a linked worktree uses its main repo). Amend AC2 and the Design lines on spaces so they state exactly which folder counts:
(1) the cwd's own ~/.claude/projects/<key>/memory; (2) else the nearest parent folder's, but only within the cwd's git repository
(a linked worktree: its main repo); (3) else the session's own project folder (dirname of transcript_path), unless that is the home
folder's; (4) else only claude-shared. Keep AC2's existing clauses that still hold; keep each test name whole on one line (ac-check
matches plan lines); name the test(s) AC2 uses (existing `ac2_search_request_scope_and_headers`, and the fixer's
`search_space_from_subfolder_worktree_or_session` if it belongs to AC2). Mark the change "amended 2026-11-07 (R1-2/R2-1), awaiting go".
Read for context: review-1/review.json, review-2/review.json, review-2/justin.json in ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/.
Don't touch AC3 (Justin kept it as approved; the fix restores it).

Report `{plan_path, diff_summary, ac2_before, ac2_after, skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
