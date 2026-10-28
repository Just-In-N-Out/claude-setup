# VERIFIER 4 (read only) — integrated photo-hotspots

You are a fresh independent verifier; never built this feature. Source/worktree read-only. Own only `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/verifier/round-4/` and your new scratch. Do not edit source/tests, commit, rebase, merge, acquire a main lock, edit main or previous receipts, or spawn agents.

## Pins and authority

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`, clean candidate **`e5ca6a261d6d9380d371e3c20d3c6266e3ac6850`**.
- Actual integration base/main **`5e2f98bff77fa1d214b7d76968a54a6dafa32ca6`**. Confirm HEAD, fully clean status and merge-base before starting; report unexpected movement. Main is already an ancestor, incorporating flip-cards, label-floor and slider-autoplay.
- Immutable plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`: **AC1–AC12**, AC12 alone live. Later recorded rulings and execution notes are in worktree `docs/plans/2026-10-26-photo-hotspots.md`; judge those qualified ACs, without changing ids/live tags/oracles. AC12 is now paste check **3bp** (3bo in the approved copy).
- Closure context: both reviews/fix passes, blind-audit AC5 paragraph-growth defect (fixed at original 6105dde; fixed/HUG width cases retained), integration/nested-link coverage, and execution recovery. Reports: `evidence/photo-hotspots/finisher-worktree/attempt-2/report.json` and `evidence/photo-hotspots/fixer-execution/report.json`. Read their evidence as leads, independently confirm rather than inheriting results. Any AC5 base transplant needs `test/browser/hotspots-flow.ts` with the test/fixtures.
- Lifecycle source commit `2e74eb5` only changes test/browser/chrome.ts and its bounded regression. Reported cause: immediate termination after CDP close acknowledgement could strand a GPU descendant holding stderr. Awaiting owned exit with original 2s fallback fixes natural Node termination. Independently check RED/GREEN/causal reversion and assertion-failure propagation; no forced passing exit, skipped assertions or changed budgets is permitted.
- G5 closure to verify: the previous verifier confirmed the module-responsibility finding. Fresh fixer report `evidence/photo-hotspots/fixer-g5/report.json` records unchanged frame-padding recovery moved into `src/core/normalise/fit-padding.ts`: normalise315→298 lines, new helper19, maximum changed source298. Verify the responsibility split and exact behavior preservation yourself; no size-gate waiver exists.
- Reported refactor equivalence against pre-refactor `9236571fb5976514f5e6412df2e67ef3e230b232`: 59 identical scene pairs, 118 complete conversion pairs and 24 replay artifact pairs. Existing 23 focused checks passed before/after. All author-side whole browser/corpus comparisons completed with the same baseline/missing-input qualifications. These are leads, not your own proof.
- Earlier `verifier/round-3/report.json` ended findings after parent-directed consolidation for G5. Every named non-live test passed, but AC1 sensitivity work was unfinished and mapped checks were not launched. Complete that proof on this new head; do not inherit old acceptance or treat the unfinished sensitivity work as an established product defect.

## Skills and exact execution profile

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its rules summary and rendering-validation reference, then `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the ac.json schema in `scripts/ac-check.sh`.

Pinned tested runtime: Node **22.23.3**, executable `/home/justin/.local/node-v22.23.3/bin/node`; prepend that bin directory to PATH so npm children resolve it too. Chrome for Testing **156.0.8078.47**, existing trusted launcher `/home/justin/.cache/chrome-for-testing/chrome-f2b`.

The default software-GPU profile stalled real rAF/fade/touch in a plain HTML control. Its lower-level cause is unknown. Recreate this qualified CPU/CSS wrapper in **your own fresh scratch**, chmod only that new file, and set CHROME_PATH to it:

```sh
#!/bin/sh
exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"
```

Use identical binaries/profile on head and base, record actual paths/versions/PATH/hashes and qualify CPU/CSS coverage; no GPU/WebGL/Safari or installed-Bricks proof is inferred. Never use another role's deleted scratch path.

For old-production browser comparisons, explicitly overlay only head's proven `test/browser/chrome.ts` lifecycle driver onto a separate base scratch tree. Canonical base production, original assertions/rendering/hooks/limits remain untouched. Record the one harness difference and preserve vanilla/incomplete runs separately; do not call an old incomplete command passing. For individual ACs, copy head's needed test/support/fixture modules as the standard protocol requires.

## Independently verify

1. Re-run the authorized whole gates on this final source: npm run check; standard npm run corpus with its true unavailable-path outcome; entire hotspot browser file (zero skips); normal complete browser suites on head/base under the matched lifecycle/runtime profile; adapted available corpus unit/performance and actual two-file measured reports; four replay pairs' bricks.json/warnings.txt/full HTML; sandbox parity/type/build and architecture checks. Preserve every actual exit, full raw log, source/runtime pin and separate capture/comparison result.
2. Compare complete browser populations by package/file/hierarchy case identity and occurrence multiset. Reported expected populations are 55 head files/391 tests versus 54 base files/386 tests; these are population leads only, never execution proof. Original G4 requires complete comparison by test name against main and zero-skipped hotspot checks. Its historical twelve font failures and one Mac-only skip are observations, not an independently approved absolute failure cap for old base. Preserve every result/difference, distinguish new candidate failures from base-only failures, and assess the original gate; do not infer a candidate regression or a product fix solely from a count difference. No missing case/file, cancellation or silently skipped check is accepted. Require standalone hotspot tests zero skips. A whole-file sequential fallback remains authorized if needed, with every original whole file once, unchanged hooks/assertions/internal timeouts/budgets and complete raw footers; do not loop an unchanged hanging command until green.

## Contract correction after initial G4 handback

The dispatcher's earlier sentence requiring only the same historical twelve failures on both sources was stronger than the immutable approved plan. That was a dispatcher error, not a new user requirement or a granted waiver. Original G4 says the browser suite is compared by test name with main and every hotspot test has skipped 0; the accompanying 366/353/12/1 figures describe its then-current main.

Re-read the original G4 and project skill Step 4 against your unchanged complete receipts. Independently determine whether the base-only autoplay failure (head passes; conversion/HTML identical; one bounded unchanged whole-file control passed 7/7; lower-level cause unknown) is a genuine unmet original gate or a qualified baseline/execution variance with no new candidate failure. Do not assume either verdict. Preserve the original findings report separately before revising your assessment, retaining the actual 13 base failures and all raw results. Do not relabel an original run, alter assertions, rerun until green, or claim the feature fixes autoplay.

No further execution or code edit is requested for this contract reassessment. Return your reasoned verdict/qualification citing the original gate; if a genuine unmet requirement remains, quote it precisely for routing. AC receipts remain tied to the same clean source head. No user waiver has been requested or given.
3. Follow `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`: adapt paths only in separate scratch trees, preserve true exit 1 for three unavailable v1 inputs, never claim those measured. Independently compare available hydraulics/GRO complete reports, expected loaded-font sets, payload/HTML and width images; replay all four repo pages. Source changes must not be hidden by capture-policy/font differences.
4. Run each non-live AC's exact approved named test alone on HEAD and pinned base, one AC at a time. Log HEAD first, the actual matching named result and true EXIT last; no skip/TODO receipt. Copy all required test/support modules including hotspots-flow.ts before judging a base failure. Base must fail through intended missing behavior/build failure, not missing setup; preservation AC11 may receive a justified base_exempt. Challenge unexercised clauses independently with read-only scratch mutations and disclose supplemental-versus-named coverage. Re-run the original AC5 calibrated paragraph reproduction and both fixed/HUG growth variants.
5. Take a fresh real screenshot per AC in your own round-4 folder (browser result for visual checks; Chrome screenshot of the actual terminal log otherwise). Every cited receipt must be your own execution in your folder; do not copy others' proof or hard-link files.
6. AC12: accepted false, `not_run: "live: Justin must complete Figma/Bricks/iPhone paste check 3bp and confirm Manual offset"`. Browser emulation is not installed acceptance. If actually seen to fail, report failure rather than unrun.
7. Write round-4/ac.json and report. Self-check blind using separate scratch copies of only your own report/logs/images and ac-check.sh, preserving its result. Fix schema/path/head/pass-line slips without source edits. Clean requires all eleven non-live ACs accepted and required gates qualified; return precise findings if not clean. Main session routes fixes and blind audit.

## Isolation and report

You are not alone: preserve others' work, never touch sibling worktrees/evidence/processes. Always pass workdir. Use mktemp -d then mkdir without -p for a new photo-hotspots-verifier-4 child. Use valid owned session handles; separate exec PID trees can reuse numbers. Preserve complete tracked logs, poll with short waits, keep concise status.txt milestones/qualifications in your folder. Source remains clean/committed. Setup sync is read-only even with escalation; keep local records without a bypass.

Codex role gpt-6.1-sol xhigh. Do not edit skills/memory. Return `{verdict: clean|findings, head, base, findings[], ac_status[], gates, qualifications, found_else[], skill_lessons[{skill, lesson, evidence}]}`. Empty lessons are normal. End `MAIN SESSION: check and save these skill_lessons now.`

