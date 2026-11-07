# BUILDER brief: cortexos-memory-hook (claude-setup) — Mini pipeline

Role: BUILDER. Build exactly the approved plan, test-first, and stop at `ready-for-review`.
- Approved plan (read-only, the contract): ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md
  (its "Justin's answers" section is binding: every ⭐; AC15 and AC16 are (live) and owed to Justin; no permission/allow-rule changes).
- Evidence folder: ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/ (write baseline.md, per-AC captures here).
- Work only in the setup-repo worktree the plan names: `$HOME/.claude-setup-wt/cortexos-memory-hook`, branch
  `cortexos-memory-hook` off local `main` of ~/.claude-setup.git. Never edit the live files in $HOME (~/.claude/settings.json,
  ~/.claude/hooks/*) — install happens at the finish step, not now. Don't push. Don't run ~/.claude/setup/sync.sh.

## Skills to load (Skill tool), one line each when you do
`engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (AC5 and AC8 are guards: prove their tests
can fail with a mutant each), `git-commit-rules`.

## Rules
- Test-first per AC: a failing test, then the code. One test and one terminal capture per AC (AC1–AC14) in the evidence folder;
  AC15/AC16 are live — do not run AC15's live writes (auto mode refuses agent writes to CortexOS); ship the 0.30 floor.
- Read-only calls to the running CortexOS (127.0.0.1:8080) are fine if a task needs them; never write to it; never touch other
  containers (leorna-pg, ndx6-*), the CortexOS repo or its untracked override.
- Commits: plain `git commit -m` with the repo's configured identity (personal, issajustin04@gmail.com); never override author,
  never add an AI/Co-Authored-By trailer; never stage a CLAUDE.md (this setup repo is the documented exception only for files the
  plan names, and this plan names none).
- Mini: if the fix needs much more than the plan's touched files, a design decision the plan doesn't settle, or the plan is wrong,
  stop with `status: stopped`, `stop_reason: escalate to full` or `plan gap: …`. Never redesign on your own.
- Desktop memory rule: run test suites and any mutation run under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A SIGTERM/143/137/"Killed" may be an earlyoom kill:
  check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as pass/fail; report any kill.

## Report
Return `{status: ready-for-review|stopped, stop_reason?, branch, head, base, worktree, ac_status[{ac, test, capture, result}],
suites[{name, base_tally, head_tally}], mutants[{ac, mutant, killed}], found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
