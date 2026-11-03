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

Run the project's required checks on the rebased head: check, full browser suite, configured and qualified available corpus. Preserve actual outcomes, exact inherited failures/skips and missing input populations. Configured zero-input corpus is not coverage. Never manufacture green or treat absent fixtures as behavioral failures. Use completed evidence only when it genuinely matches the unchanged head and required gate contract; otherwise rerun as required. Report exact tested/final HEAD, base/main, rebase/conflicts and any docs-only difference. Every changed head returns to root for coverage/acceptance handling; later records-only commits are not automatically reviewed. The user's two-review cap remains in force.

No author overrides or AI trailers; verify no CLAUDE.md staged before every plain commit. No shared stashes, dependency/config edits, other worktree cleanup or denied env reads. Root owns setup sync.

Runtime: Node `/home/justin/.local/node-v22.23.3/bin/node`, pinned child PATH. Chrome `/home/justin/.cache/chrome-for-testing/chrome-f2b` through owned wrapper with `--use-gl=disabled`, DISPLAY/WAYLAND_DISPLAY cleared. Fresh short owned DISK scratch/profiles/TMPDIR under `/home/justin/.hermes`, not shared RAM/tmp or another role's browser profile.

Stop with a clean worktree, verdict, report/gate paths, exact head/base and ac_status honestly distinguishing accepted behavior from an unqualified changed head. Return `skill_lessons[{skill,lesson,evidence,enforce}]` (normally empty), never edit skills/memory. End: MAIN SESSION: check and save these skill_lessons now.

## Current shared-PC Chrome protocol

Justin's latest trial allows THREE Chrome slots across the whole machine. Hold exactly one of `/home/justin/.cache/f2b-chrome.lock`, `/home/justin/.cache/f2b-chrome-2.lock`, `/home/justin/.cache/f2b-chrome-3.lock` through each complete Chrome sequence, with nonblocking flock FD selection and the established node-named marker. Never hold two slots or launch two Chrome jobs yourself; base/head browser work runs sequentially. Read only the runtime/slot instructions in `briefs/djtrees-common.md` if needed. Do not require all foreign Chrome to disappear after acquiring a slot. Use owned cleanup/traps, never broad process kills. Honor filesystem permissions for lock access; escalate a legitimate blocked lock operation rather than bypass the protocol. Root keeps one role active for this story; the global agent ceiling is8 across sessions. This supersedes prior parallel-Chrome assumptions, not required gate coverage.
