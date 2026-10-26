# FINISHER: link-upload-fixes (B2)

Approved plan: ~/.hermes/plans/figma-to-bricks/link-upload-fixes.md (L1A L2A L3A). Existing clean worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/link-upload-fixes, branch worktree-link-upload-fixes, tip a6c131c. Main now build 2026-10-21.9 or newer. Preserve sibling changes; text-breaks is finishing and test-cleanup is building (including stale browser test expectations).

Load figma-to-bricks (FINISHER), receiving-code-review, git-commit-rules and test-driven-development with skill_view; say you loaded them. Follow project skill context loading using rules-summary first, relevant CLAUDE.md sections only. Verify each review finding and fix test first, then project finish/merge gates. Do not re-plan approved work.

## Fresh reviewer findings (received verbatim)
B2-REVIEW-1 — medium (P2), pre-existing but R8 acceptance incomplete:
"The cancellation fix does not cover the panel after run.done() resolves. While finish() awaits video lookup, an error calls run.cancel(), but finish() subsequently enables Copy again, copies the cancelled paste and replaces the error with success. This predates B2, but leaves its R8 cancellation acceptance incomplete."
Evidence: src/ui/main.ts:192-213 awaits video lookup after obtaining Outcome, then copies without checking whether run was cancelled or replaced. Error handler at 370-375 cancels and clears run. Real Chrome: defer video GET, wait for 'Looking for the videos', deliver error, release GET. Clipboard copies increase 1→2, Copy again enabled, status 'Copied'. Both baseline and feature reproduce.
Reproducer: ~/.hermes/cache/scratch/link-upload-review-wz85n79l/cancel-panel-probe.mjs; cancel-panel-tip.json and cancel-panel-baseline.json.

B2-REVIEW-2 — low (P3), introduced:
"When both the original address and the matched candidate hold owned media, two successful renames are reported as only one freed address. The second media change disappears from the notes."
Evidence: src/ui/site-pages.ts:113-114 retains only one Held when both freed; linkNotes at 166 cannot describe/count both repairs. Owned media at /catalog/ and draft candidate /catalog-final/ leads to two rename POSTs but '1 address freed', first item only.
Reproducer: ~/.hermes/cache/scratch/link-upload-review-wz85n79l/media-edge-probes.mjs; media-edges-tip.json twoRenames.

## Separate discovery (record, do not broaden scope)
LINK-RENAME-COLLISION — pre-existing medium: owned media renamed catalog→catalog-image can occupy another protected link /catalog-image/ while that Match still has picture=false. src/ui/site-media.ts:46-63 only checks paths occupied before rename, not every protected path; destination occupancy not added. Baseline and feature offline probes both reproduce. media-edges-{tip,baseline}.json collision. Add to found-else.md if not already recorded, with evidence; don't fix under this batch.

## Finish
Run npm run check, npm run test:browser and npm run corpus before merge/rebased gates per skill; report remaining baseline failures accurately, including any fixed by test-cleanup meanwhile. Keep full baseline report, compare corpus payloads/lint not noisy scores alone. No live-site writes: offline stubs and read-only GETs only.
Update ledger, plan copy, HANDOFF. Paste check 3aj is now google-partial-fonts conversion check: choose next unused check and update all references for Remanufactured/Core Exchanges re-paste.
Use merge lock, rebase in worktree, ff-only merge, BUILD bump from actual main, npm run build, commit and push main per skill. Never force/reset/stash user changes. Release lock on every failure path. Protected CLAUDE.md write denial must not be retried/bypassed: save pending exact edits and report. Mark only genuinely fixed found items closed after verified merge. Remove worktree/branch safely, archive leftovers. Return status, build, last_commit, summary, closed_items, found_else, pending_docs, steps_for_justin. If blocked, commit passing work and stop with reason.
