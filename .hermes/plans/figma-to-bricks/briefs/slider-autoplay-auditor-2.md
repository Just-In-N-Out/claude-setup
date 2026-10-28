# BLIND AC AUDITOR (read only) — slider-autoplay (FigmaToBricksV2)

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer or verifier
report. Remain blind: never open any other role's reports, evidence folders or briefs. Do not read project status
notes or the full mutable plan for prior verdicts. Source and tests are read-only; commit nothing; start no agents.

## The only feature inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`.
- Later approved answers and rulings, extracted without review reports:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-amendments-ceb1514.md`.
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay`, branch
  `worktree-slider-autoplay`. The dispatched HEAD and base are recorded below; confirm clean HEAD and pin them.
- Your own evidence folder only:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/auditor/round-2/`.

## Skills and acceptance work
Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its
`references/rules-summary.md`, and `engineering-best-practices`. These are operating rules, not previous verdicts.
Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and
the report format in the header of its `scripts/ac-check.sh`. Follow the blind auditor procedure there.

Independently prove **AC1–AC14** from the approved plan as amended. Use each exact test name in that plan, keeping
it on one line in your report. The amended timing is delay PLUS speed: **AC14 expects interval 5800, speed 800**.
AC13 and AC14 are live paste check **3bm**, accepted=false with not_run=`live: ...` unless actually checked by Justin.
The documented Bricks reference is authorized until his copy exists, as the amendments explain.

For every runnable AC, make your own HEAD and base executions and screenshot. Log HEAD= first and EXIT= last;
the test's named assertion must run, pass on HEAD, and fail on base for changed behavior. Test setup failure is not
proof of RED. Copy HEAD's relevant tests/fixtures into a separate base tree; do not change this worktree. For
preservation behavior that correctly passes on base, use base_exempt with a specific substantive reason. Inspect
every clause of each AC rather than relying on the test title. Receipt files must be inside your own folder,
created by you, not copied or hardlinked from another role. For a nonvisual criterion, take a real terminal image.

Write `auditor/round-2/ac.json`, then self-check by COPYING your own report and receipts to your own fresh scratch folder
outside the evidence tree and running ac-check with those two independent paths as described in the reference.
Never look at any other role's folder to format or repair your report.

## Machine and ownership
- WSL browser: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. No skipped targeted browser ACs.
- Corpus config has Mac paths. Read only the machine procedure note
  `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  run your own git-archive scratch trees with config pointed to local corpus/files. AC5 compares all five replays,
  bricks.json AND warnings, against the pinned integration base. Services comes from
  `git show 2199895:figma-to-bricks-debug-page-1.json`.
- Make a new `/tmp/slider-autoplay-auditor-XXXXXX` folder with mktemp or a fresh mkdir without -p. Never use a
  pre-existing scratch area or another feature's files. You are not alone in the repository: preserve other
  sessions' changes and never touch headline-marker or photo-hotspots worktrees/evidence.
- Long runs preserve actual runtime and exit status in logs with an EXIT= marker. Incomplete is not passing.
  Send concise progress at meaningful milestones without borrowing another agent's conclusions.

## Report
Return `{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}],
ac_status[{ac,accepted,test,screenshot,evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence}]}`.
Clean needs every runnable AC accepted. Empty skill_lessons is normal; never edit skills or memory.
End with `MAIN SESSION: check and save these skill_lessons now.`

Your only evidence area is auditor/round-2/. Do not open prior auditor files in the parent folder.

## Dispatched revision (2026-10-28)
HEAD: `ceb1514d8d14a5079d84f854c47938d671eb07d2`.
Base: `f46f8a20dec5558ce85b246db48ef83c13ca72d2`.
Confirm clean worktree and pinned revisions. Preserve prior rounds; write only your new evidence area.
