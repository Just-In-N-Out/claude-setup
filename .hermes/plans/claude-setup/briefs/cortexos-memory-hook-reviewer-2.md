# REVIEWER round 2 (delta): cortexos-memory-hook (claude-setup) — Mini pipeline

Role: fresh REVIEWER, report only. You never saw the build or the fix. Edit nothing in the worktree or $HOME, don't commit, push or
sync. Write only <evidence>/review-2/review.json (plus your own probe files in review-2/) and your own scratch.

Inputs:
- Approved plan (contract, read-only): ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md
- Worktree: /home/justin/.claude-setup-wt/cortexos-memory-hook, head 1118f2c6cec9d5b2eed01731147a69b72e6bad9c
- Story base: dd80ac4a38c74caf156b9e786f299471cf6c513b. Previous round's head (your `from`): 8f168ca6377d60d6cde5745297c9d8007c20665f
- Scope: the fix commits `git -C <worktree> log -p 8f168ca..1118f2c` (3bcb96b, 080c877, 1118f2c) and what they touch.
- Earlier record: <evidence>/review-1/review.json (findings R1-1 and R1-2 were P2; R1-3…R1-7 were P3, left for follow-ups).
  The fixer's answer: R1-1 fixed (test search_long_prompt_is_fast_keywords_from_its_start, 3bcb96b); R1-2 fixed (test
  search_space_from_subfolder_worktree_or_session, 080c877 + 1118f2c). Fixer evidence: <evidence>/fixer-1/.
- Judge also whether either fix changes a rule an approved AC states (the fixer says no, but notes the Design text differs for
  prompts over 4000 characters (AC3) and for which folder counts as a cwd's memory folder (AC2)). A changed AC rule is a P1
  "false AC"; a fix that only departs from Design prose is not, unless it breaks real use.
Evidence: /home/justin/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/

## Skills (Skill tool), one line each
`requesting-code-review`, `code-review-practice`, `engineering-best-practices`, `mutation-testing-discipline`.
Follow ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md exactly (delta round: round 2, scope "delta",
from = 8f168ca…, head = 1118f2c…; use the three-trees idea: base, previous head, head).

## Severities
P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could
plausibly hit (inputs, configs, git operations, macOS bash 3.2 and WSL), anything breaking an AC, or a test that can't fail.
P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Every P0–P2 needs a concrete
real-use scenario. Re-raise an R1 finding only with `repeats` (and `new_fact` if you have one).

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base dd80ac4a38c74caf156b9e786f299471cf6c513b <evidence>`;
exit 2 = your file is wrong, fix it; 0/1/3 = the referee's verdict.

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-reviewer-2/` (mkdir, no -p); big
  files under ~/.cache/cortexos-memory-hook-reviewer-2/; remove both by literal path. Never copy real prompts or transcripts into
  evidence (it is synced); counts only.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Never write to CortexOS.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[], review_json, skill_lessons[]}` (ac_status may
be empty: a separate verifier does the AC work).
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
