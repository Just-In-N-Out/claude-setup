# REVIEWER round 1 (full) + VERIFIER AC work: cortexos-memory-hook (claude-setup) — Mini pipeline

Role: fresh REVIEWER, report only. You never saw the build. Do not edit any file in the worktree or $HOME, don't commit,
don't push, don't run sync.sh. You may write only inside your own folders named below and your own scratch folder.

Inputs (only these):
- Approved plan (the contract, read-only): ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md
  (its "Justin's answers" section is binding; AC15 and AC16 are (live), owed to Justin).
- Worktree: /home/justin/.claude-setup-wt/cortexos-memory-hook (branch cortexos-memory-hook)
- head: 8f168ca6377d60d6cde5745297c9d8007c20665f
- base: dd80ac4a38c74caf156b9e786f299471cf6c513b (= `git -C <worktree> merge-base HEAD main`; setup repo gitdir ~/.claude-setup.git)
- Review the whole story: `git -C <worktree> diff <base>..<head>`. Note one known deviation from the plan, to judge on its merits:
  the state lock is a `set -C` (noclobber) file instead of the plan's mkdir lock.

## Skills to load (Skill tool), one line each when you do
`requesting-code-review`, `code-review-practice`, `engineering-best-practices`, `mutation-testing-discipline` (guards AC5, AC8).
Read the rules in ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md and
~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md and follow them exactly.

## Job 1: review (writes <evidence>/review-1/review.json)
Evidence: /home/justin/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/
Write review-1/review.json: round 1, scope "full", from = base, head = the head above, findings (empty array when clean),
in the review-loop.md format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks
normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases: inputs, configs, git operations, macOS
bash 3.2 and WSL), anything breaking an AC, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits,
or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario. Focus areas: fail-open and latency
(a hook must never block or noticeably slow a session), the key never reaching argv or a synced file, loopback-only, no raw
chat sent (only keywords, Q1=a), settings.json changes being pure additions, Mac/bash-3.2 safety of the early gates.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>`;
exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Job 2: verifier AC work (writes <evidence>/verifier/ac.json)
Per ac-verification.md: re-run the gates (every suite the plan's AC14 names), run each AC1–AC14 test by name on head and on base
(base copy via `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach <base>`, head's test
files copied in; never `worktree add` against the setup repo), logs stamped `HEAD=<sha>`, one terminal capture per AC as its
screenshot. AC15/AC16: `"accepted": false, "not_run": "live: <why>"`. Do NOT write to CortexOS (auto mode refuses agent writes;
read-only calls are fine). Self-check your ac.json blind as the doc says (copy, run ac-check.sh without --reviews, delete copy).

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-reviewer-1/`
  (mkdir without -p); /tmp is a RAM tmpfs, keep big things under ~/.cache/cortexos-memory-hook-reviewer-1/. Remove both by literal path at the end.
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM/143/137/"Killed" may be an
  earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading a result.
- Desktop coreutils are uutils 0.8.0; `mkdir` is not atomic under contention.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}],
review_json, verifier_ac_json, skill_lessons[]}`. Summaries go in the report, not in extra files.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
