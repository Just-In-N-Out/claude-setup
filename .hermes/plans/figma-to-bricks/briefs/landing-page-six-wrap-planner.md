# Landing page six — bounded implementation-plan amendment

You are a fresh PLANNER, investigating a builder-discovered AC7 hold in an already authorized job. Main only orchestrates. Do not write production/tests, start agents, weaken acceptance, or edit the active worktree while the builder's gates run. You are not alone: builder owns current source/tests and all builder evidence; preserve that work. You own only `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-six/amendment-wrap/` and your private scratch. Return an amended plan proposal there, not in the worktree, so main can install it after showing the changes.

## Existing contract

- W: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/landing-page-six`, branch worktree-landing-page-six.
- Base: `04ab9b189b45917853779a28d889915095d7e4b1`.
- E: `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-six`.
- Immutable current plan: `E/plan-approved.md`, SHA25652ab2df7be0f6c61396511bfcd26488b9444e033aa4d7e579a05e05fc1209957.
- Inputs: frozen `E/inputs/figma-debug.json` and `figma-reference.png`, provenance in manifest.
- Builder ledger: `W/.superpowers/sdd/2026-10-31-landing-page-six/progress.md`; current broader build is still in acceptance testing, not reviewed or released.

Justin's original ask: “Well, for this page I tried using the updated plug-in and it did a terrible job. It didn't recognize any of the headers or the arrows. Please implement better logical reasoning because it didn't help with this page. And you can see the fonts and the layouts are all over the place.” He wants general plugin logic, no file-specific patches. The project standing auto-go applies to proposed recommended plan choices shown by main; no old landing-page-loop font/release waiver applies. Thirteen ACs, AC13 alone live, are already approved under that process. Preserve their ids, names, test names and live set. In particular, AC7's word/line/source fidelity is a required non-live check, not a reason to silently allow a mismatch.

## Builder's new evidence and request

Reported at15:40–15:45UTC:

> Source70:100 puts “appearance” on line2; HTML puts it at the end of line1. The460px box, family, weight, axes and individual word widths match; the HTML word ends~0.016px inside its box. Independent source/rendered screenshots confirm a24px word-baseline shift despite unchanged total line count.

> A read-only CSS experiment: normal/pre-wrap/pre-line keep that word on line1; white-space:break-spaces moves it to source line2 with the same box/font/axes/size/words/source word widths. This is evidence about a whitespace boundary, not proof of a new font policy. Suggested next action is a planner amendment evaluating a narrowly/general-property-based Figma whitespace-preservation rule plus full source/paired-design regressions. No whitespace/font production change has been made.

Evidence is builder-owned and read-only to you:
- `E/builder/AC7/source-word-wrap.png`, `rendered-word-wrap.png`.
- `E/builder/final-matrix/baseline-offset-diagnostic.json`.
- `E/builder/word-wrap-css-experiment.json` (locate the exact named receipt if owner nested it; never modify it).
- Builder's ledger contains measured source/geometry and six-face facts. All197 units painted at1440/991/390; six requested face descriptors loaded. Do not infer this proves every line/word criterion.

Separate builder work continues on already tested wide-photo and laptop active-menu fixes, remaining source-geometry overlap/rhythm dispositions, and final full gates. Do not duplicate those investigations or edit their modules. The last frozen tested source was33e021d97346209f6e07245d65b9d5b0db267c0b; newer corrections may now be committed. Pin the head you inspect and use a private archive if source is changing; your proposal must identify the actual reference head. Builder retains ownership of integrating your eventual approved instructions.

## Required bounded investigation and output

1. Read the current plan, source/raw text/whitespace/layout properties, the actual source glyphs and rendered word data. Prove or falsify a general implementable cause. The single CSS experiment is a hypothesis; do not prescribe break-spaces globally merely because it moves this one word. Compare relevant negative/source variations and official primary CSS/font documentation when needed. Use read-only probes in owned scratch; keep failed controls.
2. If source semantics justify a fix under the existing AC7 contract, amend implementation scope/tasks and exact tests without weakening the AC. Name the minimal modules, structural/property predicates, source provenance, whitespace/newline/space/tab/typed-break/nowrap/language/text-run cases and regression implications that a fresh builder needs. Preserve existing approved break/minimum/button policies or identify a real conflict explicitly. No design-specific word/width/font/id behavior, guessed font changes or whole-page hacks.
3. If the choice genuinely changes an existing product policy or the current fidelity contract, return concrete options, recommendation and evidence for main to present. Do not approve a waiver yourself, tag AC7 live, redefine a failed metric as passed or rely on the older story's release exception. An unresolved limitation remains held. Main may show a recommended amended plan under standing auto-go, but must have the actual proposal/evidence first.
4. Write a complete proposed amended plan as `E/amendment-wrap/plan-proposed.md`, retaining the original plan content and AC identities unless a separately explicit decision is needed. Include a concise Amendments section, the original approved copy path/hash, reference source head, and which earlier receipts remain historical/failures and must be rerun. Do not overwrite the original immutable copy. Validate the plan parser's ids/live set/test-name lines, and make clear whether any AC text changed versus only implementation details. If no amendment is warranted, return a precise evidence-backed blocker/report instead of manufacturing one.
5. Return report.json plus concise diagnosis, proposed changes/questions, plan/hash, and skill_lessons. Keep this bounded; do not run all unchanged complete suites while planning. No source implementation, commits, BUILD bump, merging, pushing, site/Figma writes or external messages.

Load engineering-best-practices first, project figma-to-bricks/references, implementation-planning and systematic-debugging. Use Node `/home/justin/.local/node-v22.23.3/bin/node`; task-owned Chrome wrapper around `/home/justin/.cache/chrome-for-testing/chrome-f2b --use-gl=disabled`, clear DISPLAY/WAYLAND_DISPLAY. Own short disk-backed archives/profiles/temp, not large /tmp RAM files. Never mutate shared node_modules/corpus or read credentials/browser profiles; `/home/justin/.hermes/.env` is denied.

Setup-sync pull was attempted immediately before this dispatch with approved escalation, still failed on read-only bare-repo lock. No conflict; do not bypass the permission or halt independent local work. Main owns sync handling.

Return `skill_lessons[{skill,lesson,evidence,enforce}]`, normally empty. Never edit skills/memory. End `MAIN SESSION: check and save these skill_lessons now.`
