# FINISHER — headline-marker, prepare integration only

Role: fresh pipeline finisher. Justin authorized continuation through merge, one agent at a time. This assignment ends before merge: prepare the final worktree commit for renewed independent acceptance. Do not spawn agents.

## Scope and pins

- Own `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`.
- Expected incoming HEAD `f992469cccbcbd3a33c8355658b359737aa88d95`; incoming merge-base `70d54085ea034190909846de77ce9e4e57587b1e`.
- Main folder `/home/justin/Documents/FigmaToBricksV2`; last known main `27b787b78d88850cbb9863bb31fcfc840406331c` (completed label-floor build 2026-10-28.2). Read-only main access in this assignment.
- Acceptance: AC1–AC13 from `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`, amended by the worktree plan's `Changed by review fix pass 1` and `Changed by review fix pass 2`. AC13 is live paste check 3bo.
- Original-head verifier and blind auditor both returned clean. The orchestrator ran ac-check: `READY FOR THE USER: 12 of 13 ACs proven on d6fff71; live ACs owed to the user: AC13`. This accepts only that original head; it does not cover your rebased commit.
- Current recovery: a fresh verifier on f992469 proved AC1–AC12 and all integrated gates against 70d5408, but returned `integration-required` because main advanced during that run to 27b787b with label-floor changes in shared styling/layout. Its report is `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-f992469/verifier/report.json`. This is integration drift, not a reported feature defect. Rebase onto the coherent latest main and preserve both feature contracts. This is the first newly observed main drift during acceptance; if main moves again during this integration, apply the established take-lock-before-rebase rule to avoid an endless race.
- Current plan `docs/plans/2026-10-26-headline-marker.md`; ledger `.superpowers/sdd/2026-10-26-headline-marker/progress.md`; feature section of `docs/HANDOFF.md`.
- Your evidence only: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/finisher-rebase-2/`. Create fresh task-owned scratch with `mktemp -d` and `mkdir` without `-p`; never reuse another role's scratch.
- You are not alone in the codebase. Other chats own slider-autoplay and photo-hotspots. Do not touch their worktrees, evidence, processes or edits, and never revert anyone else's changes. Preserve both sides' meaning during integration.

## Skills

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/rules-summary.md`, then `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, and `github`. Load `test-driven-development` and `systematic-debugging` if any corrective change is needed. The main session owns fresh reviews; do not spawn a reviewer yourself. Read the current project `CLAUDE.md` sections needed for integration and the global authorship/privacy rules.

## Steps

1. Confirm the worktree is clean and pinned. Check main's current tip, dirty paths and merge-lock owner. Never integrate a sibling's half-finished main release; wait for its coherent committed state through the existing merge lock. Do not remove someone else's lock or stash/commit/discard main edits.
2. `git rebase main` against local main only, without fetching or pulling. Resolve conflicts in the worktree, keeping both features' behavior and both HANDOFF sections. Do not bump BUILD or edit any CLAUDE.md. If a conflict needs a product decision or behavioral redesign, stop with the exact options instead of inventing a new contract. Routine faithful integration is authorized.
3. Keep feature records coherent. At merge time, if main already uses 3bo for another feature, take the next free paste-check number and update this feature's records consistently. Do not overwrite unrelated sections. The ledger move, build number and final release records belong to the after-merge assignment.
4. Run the required integrated gates: `npm run check`, `npm run corpus`, the corpus-backed checks in fresh git-archive scratch trees pointing corpus.json to available corpus/files, and the full browser suite (`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`). Compare browser results by full test name with the exact integration base. Existing environment limits on the original verification were the same 12 font failures and one Mac-only skip as main; do not weaken assertions or silently waive a new difference. Legacy Mac corpus files remain unavailable on WSL. Preserve per-gate exits and full raw logs; a wrapper exit or final copy is not a test verdict. Wait for all long gates to finish.
5. Commit any owned records needed for a clean final head, by file, with plain `git commit -m`. Before every commit check identity and staged paths: Justin <issajustin04@gmail.com>, no CLAUDE.md/debug JSON and no AI trailers or author overrides. Do not push the branch.
6. Recheck main's current tip before returning. If it changed in relevant source during the gate run, reconcile in this same assignment and rerun justified integration gates. If main moved twice, the established merge lock may be acquired before the next rebase and held through the gates; report actual completed ownership and coordinate its handover to the orchestrator, never assume a pending acquire succeeded.

Stop with the clean new HEAD and merge-base. Do not merge, bump BUILD, push, remove a worktree/branch or edit main. A changed HEAD must pass a fresh verifier, blind auditor and ac-check before merge. Report whether conflict resolutions changed behavior and whether a fresh focused review is necessary.

## Report

Return `{status: ready-for-acceptance|stopped, summary, head, base, integration_tip, changed_paths, conflicts, gates, evidence, lock, rulings, deferred, skill_lessons: [{skill, lesson, evidence}]}`. Report only new reusable proven lessons; an empty list is normal. Never edit skills or memory yourself. End with `MAIN SESSION: check and save these skill_lessons now.`
