# Second and final authorized full review

Fresh pipeline_reviewer, report only, no agents. You are not alone; preserve all other work. Own only E/review-2/ and fresh private scratch; no source/test/docs/ref edits or commits.

W `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/dark-structure-recognition`.
E `/home/justin/.hermes/plans/figma-to-bricks/evidence/dark-structure-recognition`.
Head 6a874e762fb3d6fce76d31af58482c6d885112d2.
Base b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1.
Approved plan E/plan-approved.md, unchanged hash `23fe2fb95ab2311819000091925656fea9753555fe4c10ce9fa663f34078b511`.
Prior review E/review-1/review.json and its completed report E/review-1/resume/report.md.
Fixer response E/fixer-1/report.md and E/fixer-1/fixer-report.json.
Current candidate validation E/integration-prep/report.md and E/integration-prep/report.json.

Integration preparation rebased the completed fix before this final review because local main had advanced in two shared files. Independently inspect E/integration-prep/conflicts.json, union-proof.json and range-diff-final.txt: additive HANDOFF resolutions, style caller union, and the necessary final record commit are within your full review. Final reviewed code matches the rebased a7eb65f code; head6a874e7 adds records only. Provisional paste check is now3cw, to be rechecked under release lock. Main BUILD2026-11-02.3 was preserved. Do not infer accepted ACs from the finisher report.

Load engineering-best-practices, requesting-code-review, code-review-practice, review-fix-cadence and project `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with relevant testing pitfalls. Follow actual referee schema in feature-dispatch/scripts/review-check.sh. Round2 is FULL: independently inspect the whole story from the pinned base through head, fixes included, and verify disposition of each previous finding. Repeated defects get repeats/new_fact fields accurately. Concrete real-use scenarios are required for P0–P2; do not invent severities, hide failures or turn speculative edge cases into blockers. Root owns referee decisions, not you.

This is the user's second/final authorized review round. Report every genuine finding honestly; do not suppress it to force a clean verdict, run a hidden third round, retag ACs, weaken criteria or infer a release waiver. The separate website-importer one-review policy is not this story's policy. Independent verification/audit still follow review.

All eight ACs, Q1A/Q2A/Q3A and their named tests are in the approved plan. General header ownership/omission/actions, safe footer navigation and truthful static review-selector inference are the scope. Preserve explicit actions and earlier working designs. Q1A does not implement a working numbered-review slider or fabricate missing records/autoplay. No hardcoded source IDs/names/colours/fonts/geometry in production recognition. Review capture-tool and palette-path repairs and any rebase conflict resolutions with the same rigor as product changes. Distinguish actual source changes from new main's unrelated features.

Per review1’s completed role-requirement assessment, each copy agent must run npm run check and npm run corpus; a full paired browser suite is a pre-merge/verifier gate, not a prerequisite for a report-only review of already reproduced findings. Complete meaningful impacted browser probes and preserve accurate gate limits; do not rerun unrelated broad suites merely for ceremony. No final release gate is waived.

Evaluate exact original/qualified gate populations, absent input/font cases, inherited failures and timing observations. Read actual exits; no wrapper-success inference. Test-file names/hierarchy/occurrences matter, not just totals. A controlled passing run does not erase a failed full run. Current version/native limits remain honest: AC8 is live/owed unless genuinely executed; source/reference2.3.9 and DJ staging2.4.4 are different installed proof targets. No Figma/site/media writes.

Runtime: Node `/home/justin/.local/node-v22.23.3/bin/node` and pinned child PATH; owned --use-gl=disabled Chrome wrapper, DISPLAY/WAYLAND cleared; short owned DISK scratch/profiles/TMPDIR under `/home/justin/.hermes`, not RAM/tmp. Preserve other sessions' processes/files, shared dependencies/config and denied env. Root owns setup sync.

Justin's latest shared memory update (~2026-11-02 20:15, `memory/run-without-stopping.md` line27) supersedes the three-slot trial: **no shared Chrome slot limit**, but each agent runs only ONE of its own Chrome jobs at a time. Run base/head sequentially. Do not wait for old shared-slot locks or for foreign Chrome to disappear. Preserve owned cleanup, the 4GB mutation cap and earlyoom investigation. Global agent ceiling8 still applies; root runs one role for this story. Never disturb another session's locks/processes.

Write checkpoint and final E/review-2/review.json; self-check referee format, don't act on its verdict. Return exact base/head, verdict, finding severity counts/evidence, ac_status for all eight with real proof limits, report paths and skill_lessons [{skill,lesson,evidence,enforce}] (normally empty). Never edit skills/memory. End: MAIN SESSION: check and save these skill_lessons now.


## Windows Desktop: Runaway Memory (mandatory, latest AGENTS)

Mutation runs always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command ending SIGTERM, exit143/137, or Killed may be earlyoom rather than a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso` for sending lines, identify the killed command and growth, and report it to the orchestrator. A killed check must be rerun under the same 4 GB cap, never bare. Do not weaken or bypass the cap; report a concrete unavailable cgroup/systemd prerequisite if one occurs. Preserve existing three Chrome slots and owned-process cleanup. Include relevant kill facts in checkpoints/handback. Root checks earlyoom since its last check on every report and before dispatching the next role; it maps killed paths to owners and notifies Justin, including unowned kills.
