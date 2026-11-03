USER MERGE HOLD (2026-11-03): Review4 and independent verification are authorized. Stop after accepted checks; do not merge, bump BUILD, publish/push a release or write main until Justin explicitly instructs a merge. This supersedes all standing auto-finish text below.

# DRAFT — pin accepted head and result before dispatch

Role: fresh pipeline_finisher, premerge only, no agents. Load engineering-best-practices, git-commit-rules, project `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and pertinent testing-pitfalls. You are not alone; preserve others' work.

W: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/dark-structure-recognition`, branch `worktree-dark-structure-recognition`.
M: `/home/justin/Documents/FigmaToBricksV2` (read-only).
E: `/home/justin/.hermes/plans/figma-to-bricks/evidence/dark-structure-recognition`.
Own evidence: E/finish-premerge/.
Approved plan: E/plan-approved.md.
Accepted head: ROOT_MUST_PIN_HEAD.
Acceptance result: ROOT_MUST_PIN_RESULT.

Perform the required premerge finish steps only. Verify clean state and completed HANDOFF/ledger records. Move runtime ledger to `docs/plans/2026-10-31-dark-structure-recognition-ledger.md` if still required, commit necessary owned finish records, and rebase onto current local main. Preserve both sides on conflicts. No unnecessary documentation churn, new feature work, main edits, BUILD bump, merge, push, live-site/Figma writes or agent spawning. Root owns integration and subsequent dispatch.

Run the project's required checks on the rebased head: check, full browser suite, configured and qualified available corpus. Preserve actual outcomes, exact inherited failures/skips and missing input populations. Configured zero-input corpus is not coverage. Never manufacture green or treat absent fixtures as behavioral failures. Use completed evidence only when it genuinely matches the unchanged head and required gate contract; otherwise rerun as required. Report exact tested/final HEAD, base/main, rebase/conflicts and any docs-only difference. Every changed head returns to root for coverage/acceptance handling; later records-only commits are not automatically reviewed. The user authorized two full reviews plus ONE additional focused review of the final fixes. No further review round is authorized; root handles any new coverage question.

No author overrides or AI trailers; verify no CLAUDE.md staged before every plain commit. No shared stashes, dependency/config edits, other worktree cleanup or denied env reads. Root owns setup sync.

Runtime: Node `/home/justin/.local/node-v22.23.3/bin/node`, pinned child PATH. Chrome `/home/justin/.cache/chrome-for-testing/chrome-f2b` through owned wrapper with `--use-gl=disabled`, DISPLAY/WAYLAND_DISPLAY cleared. Fresh short owned DISK scratch/profiles/TMPDIR under `/home/justin/.hermes`, not shared RAM/tmp or another role's browser profile.

Stop with a clean worktree, verdict, report/gate paths, exact head/base and ac_status honestly distinguishing accepted behavior from an unqualified changed head. Return `skill_lessons[{skill,lesson,evidence,enforce}]` (normally empty), never edit skills/memory. End: MAIN SESSION: check and save these skill_lessons now.

## Current shared-PC Chrome protocol

Justin's latest shared memory update (~2026-11-02 20:15, `memory/run-without-stopping.md` line27) supersedes the three-slot trial: **no shared Chrome slot limit**, but each agent runs only ONE of its own Chrome jobs at a time. Run base/head sequentially. Do not wait for old shared-slot locks or for foreign Chrome to disappear. Preserve owned cleanup, the 4GB mutation cap and earlyoom investigation. Global agent ceiling8 still applies; root runs one role for this story. Never disturb another session's locks/processes.

## Windows Desktop: Runaway Memory (mandatory, latest AGENTS)

Mutation runs always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command ending SIGTERM, exit143/137, or Killed may be earlyoom rather than a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso` for sending lines, identify the killed command and growth, and report it to the orchestrator. A killed check must be rerun under the same 4 GB cap, never bare. Do not weaken or bypass the cap; report a concrete unavailable cgroup/systemd prerequisite if one occurs. Preserve owned-process cleanup and the current no-slot-cap/one-own-Chrome-job rule. Include relevant kill facts in checkpoints/handback. Root checks earlyoom since its last check on every report and before dispatching the next role; it maps killed paths to owners and notifies Justin, including unowned kills.
