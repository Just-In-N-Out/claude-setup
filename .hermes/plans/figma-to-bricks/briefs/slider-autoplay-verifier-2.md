# VERIFIER (read only) — slider-autoplay (FigmaToBricksV2)

You are a fresh, independent verifier. You never saw the build. Change no source, tests or project notes; commit
nothing. Write evidence only into `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/verifier/round-2/`.

## Inputs and ownership
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay`, branch
  `worktree-slider-autoplay`. Confirm and pin the fully committed clean HEAD before running anything. The
  orchestrator will record the dispatched HEAD below.
- Base: `git -C <worktree> merge-base HEAD main`; record the exact SHA. Initial feature base was `f46f8a2`.
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`, read-only.
- Later approved answers and rulings: the worktree's `docs/plans/2026-10-26-slider-autoplay.md`, sections
  `Justin's answers (2026-10-27)` and `Rulings`, including fixer-2's later recorded rulings. Judge the criteria
  against those amendments. Never change the approved copy or rename the AC tests.
- Check review 1 F1–F8 and review 2 R2-F1–R2-F4 were resolved without regressions. Their reports and fixer evidence
  are in this feature's `reviewer-1`, `fixer-1`, `reviewer-2`, and `fixer-2` folders. The resumed fixer-2 owns its
  own earlier work; your conclusions require your own execution.
- You are not alone in this repository. Never change or revert another session's work. Do not touch the
  headline-marker or photo-hotspots worktrees, evidence or scratch. Do not start subagents.

## Skills
Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/rules-summary.md`, then `engineering-best-practices`. Read
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report
format at the top of its `scripts/ac-check.sh`.

## Acceptance criteria
Prove every numbered criterion AC1–AC14 from the approved plan with its exact named test. In brief: AC1 loop
structure and variant contents; AC2 settings/timing/types; AC3 documented Bricks shape; AC4 recognition guards;
AC5 unchanged ordinary designs and phone sliders; AC6 drawn controls; AC7 playing/looping/pausing/reduced motion;
AC8 edge-to-edge layout; AC9 phone/laptop layout; AC10 narrow sliders; AC11 links, call buttons and unique ids;
AC12 panel notes; AC13 live Bricks round trip; AC14 live Figma file.

Required amendments: the sample gate was lifted by Justin; AC3 uses `reference/bricks/slider-autoplay-documented.json`
until his own copy exists, with keys backed by `reference/bricks/slider-nested-schema.json` (2.4.3). The emitted
interval is delay PLUS speed, so **AC14 expects interval 5800 and speed 800**, replacing the approved copy's 5000.
AC2 and AC7 must exercise the full wait. The scene and panel keep Figma's delay. Phone arrow boxes are 24×24 from
mobile_landscape down, corner arrow pairs count, and no prevArrow/nextArrow setting is emitted. Include the later
R2 findings: all free-drawn slides adapt alike, repeated slide contacts count once in page-wide tallies while
nearest-number searches reach every slide, the specified mutation guards are tested, and arrow clearance is
checked for narrow sliders and band slides at the amended tiers.

## Do
1. Independently re-run `npm run check`, `npm run corpus`, the whole `test/browser/carousel.test.ts` with zero
   skips, and the full browser suite compared by test name with the base. Classify baseline font/environment
   failures accurately; do not silently waive an introduced failure. On WSL use
   `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
2. `npm run corpus` has Mac paths and measures nothing here. Read the project memory
   `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.
   Run corpus-backed tests in your own scratch git-archive trees with `corpus/corpus.json` pointed at local
   `corpus/files/`. Independently perform AC5's five full replay comparisons (hydraulics, GRO, Repairs,
   brainstorm, Services), bricks.json AND warnings byte-identical versus the pinned base. Services is available
   from `git show 2199895:figma-to-bricks-debug-page-1.json`; preserve all source provenance.
3. Run each AC's own test alone on pinned HEAD and on base using HEAD's relevant test/fixture files in an
   isolated copy. Use the `ac-verification.md` recipe: HEAD= first line, named pass/fail, EXIT= last line.
   Every accepted criterion needs your own screenshot: UI result or a real terminal capture image. Use base_exempt
   with a substantive reason for preservation criteria that rightly pass on base. A setup failure never proves RED.
4. Write `verifier/round-2/ac.json` with AC1–AC14. AC13 and AC14 are `(live)`, paste check **3bm**: accepted=false,
   not_run=`live: ...` unless actually run. Do not pretend renderer evidence is Justin's Bricks round trip.
5. Self-check your report with a separate copied receipt set outside the evidence tree and `ac-check.sh`, as the
   reference describes; never read the auditor's report or evidence. Keep each cited receipt inside your own folder.

Make a new agent-specific `/tmp/slider-autoplay-verifier-XXXXXX` folder with mktemp or a fresh mkdir without -p.
Never extract into a pre-existing scratch folder or reuse another agent's files. Long gates log actual runtime,
exit statuses and an EXIT= end marker; distinguish an unfinished process from a test verdict. Keep required
artifacts and preserve diagnostic failures. Send concise progress at meaningful gate milestones.

## Report
Return `{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}],
ac_status[{ac,accepted,test,screenshot,evidence}], gates, rulings[], found_else[],
skill_lessons[{skill,lesson,evidence}]}`. Clean requires all runnable ACs accepted and no introduced gate failure;
AC13–AC14 may remain live/not_run. Never edit skills or memory. Empty skill_lessons is normal.
End with `MAIN SESSION: check and save these skill_lessons now.`

## Corrective verification
Independently confirm AUD-F1 is closed: two same-named slider instances each retain a panel note.
The original blind audit is at evidence/slider-autoplay/auditor/ac.json and the fix evidence at fixer-3/.
Do not rely on their verdicts; re-run the strengthened exact named AC12 test and all other required checks.

## Dispatched revision (2026-10-28)
HEAD: `ceb1514d8d14a5079d84f854c47938d671eb07d2`.
Base: `f46f8a20dec5558ce85b246db48ef83c13ca72d2`.
Confirm clean worktree and pinned revisions. Preserve prior rounds; write only your new evidence area.
