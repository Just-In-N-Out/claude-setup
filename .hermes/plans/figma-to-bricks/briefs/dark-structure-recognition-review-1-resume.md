# Resume incomplete review round 1 of 2

Fresh pipeline_reviewer, report only. Read the pinned original brief `/home/justin/.hermes/plans/figma-to-bricks/briefs/dark-structure-recognition-review-1.md` and follow it exactly with these recovery/runtime updates. Do not spawn agents. You are not alone; preserve all other work and never alter product/source/tests/docs/refs.

Justin says “comtinue'”. Existing review1 was interrupted without review.json or a final verdict. Root live list has no old reviewer. This is continuation of the SAME incomplete first round, not review2 or an extra hidden review. The two-round cap and unchanged approved plan/ACs/Q1A–Q3A still apply. The newer one-review website-importer rule concerns a different job; this task is Figma source recognition.

W: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/dark-structure-recognition`.
Pinned clean head: `c6405a52a5416d46a255ad82e3471adb79c6fd31`.
Pinned base: `14240810effc26254e2fc6771fdeb6e67910c429`.
E: `/home/justin/.hermes/plans/figma-to-bricks/evidence/dark-structure-recognition`.
Original review evidence E/review-1/, checkpoint start2026-11-02T21:16:32Z, scratch `/home/justin/.hermes/dsr-r1-wM068i`. Preserve all original receipts unchanged. Own new recovery artifacts under E/review-1/resume/ and fresh short disk scratch; final referee input remains E/review-1/review.json, final report may be E/review-1/resume/report.md. Update new resume/checkpoint.json promptly. Do not infer execution success from old file existence or terminal IDs; inspect actual complete receipts and reproduce only unfinished or materially unresolved work.

Read current source and independently review the WHOLE story as original brief requires, including actual-page preservation, generic structural/negative tests, palette repair, ScrollTimeline capture helper, metadata/receipt repairs and prior HANDOFF-only rebase conflict resolution. Builder final report/structured report is under E/builder-finalize/ and the original review brief explains its limitations. Preserve all qualifications; do not turn original full-suite failures into passes because a controlled check passed. Actual AC8 remains live/owed, reference2.3.9 differs from DJ staging2.4.4. Main has advanced with unrelated jobs; pinned worktree stays immutable during this review, no rebase.

## Latest shared-PC resource rule (supersedes old concurrency assumptions)

Read relevant current `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/run-without-stopping.md` and `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` runtime section. Latest Justin choice is THREE shared Chrome slots, not the older single-slot/no-other-Chrome rule. Before any Chrome-driven sequence (tests, snapshots, probes, base and head), acquire exactly ONE of:

- `/home/justin/.cache/f2b-chrome.lock`
- `/home/justin/.cache/f2b-chrome-2.lock`
- `/home/justin/.cache/f2b-chrome-3.lock`

Use a script with nonblocking flock FD loop over all three, retain that lock for the entire sequence, and the established node-named marker process. Never hold two slots or run two Chrome jobs yourself; run base/head browser sequences sequentially. Release lock and only your marker in a trap. Existing lock files may be opened read-only when supported for advisory flock; if permissions or missing files prevent the legitimate protocol, request the required escalation and report the exact barrier, never bypass coordination. Do not wait for all foreign Chrome to disappear: the acquired slot is the authorization to run. CPU/source review work can proceed while waiting. Root is using one reviewer only; global agent ceiling remains8 across sessions. Do not start extra agents.

Pinned Node22 and child PATH, owned --use-gl=disabled Chrome wrapper, DISPLAY/WAYLAND cleared, fresh short DISK TMPDIR under `/home/justin/.hermes` still apply. No shared dependency/config changes, denied env/profile reads, live/Figma/media writes or broad process kills. Reconcile only proven owned orphan processes from interrupted runs before reusing resources; don't trust stale PID numbers across restarts.

Return complete review.json with exact findings/scenarios and referee self-check, report path, verdict, ac_status and skill_lessons [{skill,lesson,evidence,enforce}] (normally empty). No skill/memory edits. End: MAIN SESSION: check and save these skill_lessons now.


## Windows Desktop: Runaway Memory (mandatory, latest AGENTS)

Mutation runs always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command ending SIGTERM, exit143/137, or Killed may be earlyoom rather than a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso` for sending lines, identify the killed command and growth, and report it to the orchestrator. A killed check must be rerun under the same 4 GB cap, never bare. Do not weaken or bypass the cap; report a concrete unavailable cgroup/systemd prerequisite if one occurs. Preserve existing three Chrome slots and owned-process cleanup. Include relevant kill facts in checkpoints/handback. Root checks earlyoom since its last check on every report and before dispatching the next role; it maps killed paths to owners and notifies Justin, including unowned kills.
