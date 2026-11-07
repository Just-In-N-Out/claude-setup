# REVIEWER round 3 (delta): cortexos-memory-hook (claude-setup) — Mini pipeline

Role: fresh REVIEWER, report only. You never saw the build or any fix. Edit nothing in the worktree, the plan or $HOME, don't commit,
push or sync. Write only <evidence>/review-3/review.json (plus your own probe files in review-3/) and your own scratch.

Inputs:
- Plan: the approved copy ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md, EXCEPT that AC2 and the Design's
  "Spaces" rule are superseded by the amendment in the working plan ~/.hermes/plans/claude-setup/cortexos-memory-hook.md
  (marked "amended 2026-11-07 (R1-2/R2-1), awaiting go"; Justin ruled on it in review-2/justin.json and is approving the wording).
  Judge AC2 against the amended text and every other AC against plan-approved.md.
- Worktree /home/justin/.claude-setup-wt/cortexos-memory-hook, head 6b8860715c6e3f2cb9b48240dbaefc287402a4a2.
- Story base dd80ac4a38c74caf156b9e786f299471cf6c513b. Your `from` (previous round's head): 1118f2c6cec9d5b2eed01731147a69b72e6bad9c.
- Scope: the fix commits `git -C <worktree> log -p 1118f2c..6b88607` (7672eb8, 6b88607) and what they touch.
- Earlier records: review-1/review.json, review-2/review.json, review-2/justin.json (Justin: fix R2-1 and R2-2, AC3 stays as approved).
  The fixer's answer: R2-2 fixed in 7672eb8 (keywords equal the plan's jq at any length; tests ac3_search_sends_keywords_not_prompt,
  search_long_prompt_is_fast); R2-1 fixed in 6b88607 to the amended four-step rule (tests ac2_search_request_scope_and_headers,
  search_space_from_subfolder_worktree_or_session); R2-3 done in 7672eb8. Fixer evidence: <evidence>/fixer-2/.
- A changed rule of an AC (against the texts above) is a P1 "false AC". Re-raise an earlier finding only with `repeats` (+ `new_fact`).
Evidence: /home/justin/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/

## Skills (Skill tool), one line each
`requesting-code-review`, `code-review-practice`, `engineering-best-practices`, `mutation-testing-discipline`.
Follow ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md exactly (round 3, scope "delta",
from = 1118f2c…, head = 6b88607…; three trees: 8f168ca as oldest runnable, 1118f2c, head).

## Severities
P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could
plausibly hit (inputs, configs, git operations, macOS bash 3.2 and WSL), anything breaking an AC, or a test that can't fail.
P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Every P0–P2 needs a concrete
real-use scenario. Focus: latency budget (git watchdog, awk path, temp prompt file), fail-open, privacy (only keywords sent; the
prompt temp file's lifetime/permissions), Mac bash 3.2 and BSD awk/git on the Mac paths that actually run there.

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base dd80ac4a38c74caf156b9e786f299471cf6c513b <evidence>`;
exit 2 = your file is wrong, fix it; 0/1/3 = the referee's verdict.

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-reviewer-3/` (mkdir, no -p); big
  files under ~/.cache/cortexos-memory-hook-reviewer-3/; remove both by literal path. Never copy real prompts or transcripts into
  evidence (it is synced); counts only.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Never write to CortexOS. Desktop coreutils are uutils
  (mkdir not atomic; `timeout` adds ~100 ms).

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[], review_json, skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
