# DRAFT — second and final authorized full review; pin every placeholder before dispatch

Fresh pipeline_reviewer, report only, no agents. You are not alone; preserve all other work. Own only E/review-2/ and fresh private scratch; no source/test/docs/ref edits or commits.

W `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/dark-structure-recognition`.
E `/home/justin/.hermes/plans/figma-to-bricks/evidence/dark-structure-recognition`.
Head ROOT_MUST_PIN_HEAD.
Base ROOT_MUST_PIN_BASE.
Approved plan E/plan-approved.md, unchanged hash `23fe2fb95ab2311819000091925656fea9753555fe4c10ce9fa663f34078b511`.
Prior review E/review-1/review.json and its completed report ROOT_MUST_PIN_REVIEW_REPORT.
Fixer response ROOT_MUST_PIN_FIX_REPORT_OR_NONE.
Current candidate validation ROOT_MUST_PIN_CANDIDATE_REPORT.

Load engineering-best-practices, requesting-code-review, code-review-practice, review-fix-cadence and project `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with relevant testing pitfalls. Follow actual referee schema in feature-dispatch/scripts/review-check.sh. Round2 is FULL: independently inspect the whole story from the pinned base through head, fixes included, and verify disposition of each previous finding. Repeated defects get repeats/new_fact fields accurately. Concrete real-use scenarios are required for P0–P2; do not invent severities, hide failures or turn speculative edge cases into blockers. Root owns referee decisions, not you.

This is the user's second/final authorized review round. Report every genuine finding honestly; do not suppress it to force a clean verdict, run a hidden third round, retag ACs, weaken criteria or infer a release waiver. The separate website-importer one-review policy is not this story's policy. Independent verification/audit still follow review.

All eight ACs, Q1A/Q2A/Q3A and their named tests are in the approved plan. General header ownership/omission/actions, safe footer navigation and truthful static review-selector inference are the scope. Preserve explicit actions and earlier working designs. Q1A does not implement a working numbered-review slider or fabricate missing records/autoplay. No hardcoded source IDs/names/colours/fonts/geometry in production recognition. Review capture-tool and palette-path repairs and any rebase conflict resolutions with the same rigor as product changes. Distinguish actual source changes from new main's unrelated features.

Per review1’s completed role-requirement assessment, each copy agent must run npm run check and npm run corpus; a full paired browser suite is a pre-merge/verifier gate, not a prerequisite for a report-only review of already reproduced findings. Complete meaningful impacted browser probes and preserve accurate gate limits; do not rerun unrelated broad suites merely for ceremony. No final release gate is waived.

Evaluate exact original/qualified gate populations, absent input/font cases, inherited failures and timing observations. Read actual exits; no wrapper-success inference. Test-file names/hierarchy/occurrences matter, not just totals. A controlled passing run does not erase a failed full run. Current version/native limits remain honest: AC8 is live/owed unless genuinely executed; source/reference2.3.9 and DJ staging2.4.4 are different installed proof targets. No Figma/site/media writes.

Runtime: Node `/home/justin/.local/node-v22.23.3/bin/node` and pinned child PATH; owned --use-gl=disabled Chrome wrapper, DISPLAY/WAYLAND cleared; short owned DISK scratch/profiles/TMPDIR under `/home/justin/.hermes`, not RAM/tmp. Preserve other sessions' processes/files, shared dependencies/config and denied env. Root owns setup sync.

Before each Chrome sequence acquire ONE shared slot via nonblocking flock over `/home/justin/.cache/f2b-chrome.lock`, `f2b-chrome-2.lock`, `f2b-chrome-3.lock`, retain it through the whole sequence and run the established node-named marker. Never hold two slots or run two Chrome jobs yourself; base/head browser sequences are sequential. Follow the runtime/slot section of `briefs/djtrees-common.md` when needed. Do not wait for all foreign Chrome after acquiring a slot. Respect permissions and use owned traps/cleanup. Global agent ceiling8; root runs one role for this story.

Write checkpoint and final E/review-2/review.json; self-check referee format, don't act on its verdict. Return exact base/head, verdict, finding severity counts/evidence, ac_status for all eight with real proof limits, report paths and skill_lessons [{skill,lesson,evidence,enforce}] (normally empty). Never edit skills/memory. End: MAIN SESSION: check and save these skill_lessons now.


## Windows Desktop: Runaway Memory (mandatory, latest AGENTS)

Mutation runs always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command ending SIGTERM, exit143/137, or Killed may be earlyoom rather than a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso` for sending lines, identify the killed command and growth, and report it to the orchestrator. A killed check must be rerun under the same 4 GB cap, never bare. Do not weaken or bypass the cap; report a concrete unavailable cgroup/systemd prerequisite if one occurs. Preserve existing three Chrome slots and owned-process cleanup. Include relevant kill facts in checkpoints/handback. Root checks earlyoom since its last check on every report and before dispatching the next role; it maps killed paths to owners and notifies Justin, including unowned kills.
