# landing-page-loop — fix pass after full review 1

## Role and ownership

You are a fresh FIXER. Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/landing-page-loop`, branch `worktree-landing-page-loop`, integration local `main`, story base `c67128c4cca8eff67afdf3f7e6e8b28a75294deb`, starting reviewed head `a6fae2b1b631bc93514fd37ffbc72a0b44b3b842`. Check identity and clean state before changing anything. You are not alone in the codebase: preserve others' changes and do not revert them. Do not spawn agents, rebase, merge, push, bump BUILD, edit the main folder, change Figma/WordPress, edit skills or memory, or revise the approved ACs.

Your responsibility is verifying and correcting the four review-1 findings below, including meaningful generic regression tests and story-audit sensitivity. Own the implicated review-slider, diagram and navigation-brand logic and directly required helper/test changes within the approved plan; own the media inventory audit and its negative controls. Keep changes bounded to the findings. If a necessary correction needs a genuinely new owner or decision outside the approved plan, report the evidence and proposed scope to the main session before that change; continue independent fixes. Preserve the architecture, pure stages, typed CSS, deterministic IDs, sandbox restrictions and native Bricks editability. No file-specific names, ids, fonts or dimensions may become recognition rules.

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, engineering-best-practices first among engineering skills, receiving-code-review, test-driven-development and git-commit-rules from `/home/justin/.agents/skills/`. Load systematic-debugging for unexpected failures and mutation-testing-discipline when testing a guard. Read the worktree CLAUDE.md and review-loop reference. User/global/project instructions override conflicting skill defaults.

Approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop/plan-approved.md` (SHA256 `541f68d6bfb8fa39a442cdfabc728bcea0aecd0186b7285cdef4db4b60c2ec77`). Evidence root E `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop`. Your outputs belong in `E/fix-1/`, plus the worktree's code/tests and existing story ledger/audit/HANDOFF records as necessary. Prior review evidence `E/review-1/review.json` and `report.json` plus all cited probes is available. Read complete findings, independently verify each before fixing, and give evidence for any rejection rather than silently dismissing it.

## Referee output, verbatim

```
R1-1  P2  src/core/understand/review-slider.ts:31  stripPager deletes stationary non-text leaves outside the pager
R1-2  P2  src/core/adapt/rules/diagram.ts:24  Rotated diagram pieces are sized from their already-rotated bounds and transformed again
R1-3  P2  test/story/landing-page-loop/inventory.ts:73  The required media audit accepts transparent photos as visible content
R1-4  P2  src/core/understand/navigation-brand.ts:47  A normal compact header makes its active page pill an unresolved action
REVIEW AGAIN: 4 P0-P2 finding(s) in review-1 at a6fae2b: fix them, then review again (Full: round 2 reviews the whole story from c67128c; Mini: review the fix commits)
```

The review JSON controls the exact claim/scenario. Leads: R1-1 stationary verification badge next to pagination disappears; prune only actual pager artwork and preserve unrelated subtrees. R1-2 a generic 50x15 marker rotated45 has painted bounds45.962px on base,64.988px on head; examine untransformed dimensions/center and rotated/mirrored/nested controls, preserving design-width geometry. R1-3 opacity0 mutation of photo payloads passes both modes/all25 widths; require actually painted eligible media or reachable active copies with ancestor visibility/opacity, while retaining intentional hidden-copy controls. R1-4 the existing generic active Services pill is33px high in an80px header and loses its page link due to an action-height ratio; retain filter/action negatives while distinguishing proven menu items independently of total bar height. These are reviewer leads, not permission to hardcode these numbers or labels.

## Requirements and boundaries

Read all18 AC clauses and named checks in the approved plan. AC1 centred navigation; AC2 header/footer ticks; AC3 sticky navigation; AC4 navigation/contact/action links; AC5 inset panels; AC6 inferred origins; AC7 editable labelled diagrams; AC8 native review-slider structure; AC9 real review interactions; AC10 actual font-face measurement; AC11 safe typed axes through classes/runs/buttons/forms/states; AC12 every text/run; AC13 media provenance/geometry/visibility; AC14 all-section responsive geometry; AC15 links/motion; AC16 complete matched regression gates within the approved available-input scope; AC17 effective designer-confirmed font match; AC18 live Figma/Bricks round trip. Exact plan clauses control.

AC17 remains NON-LIVE HELD: raw opsz9 is not proof of effective automatic optical sizing, the designer checkbox is unknown, and site font files lack optical/custom axes. Do not guess that flag, weaken the criterion, implement conditional Task9b or claim release acceptance. AC18 is user-owned live/not run. The missing Free Estimate URL stays unlinked with the approved warning. Placeholder review content stays explicitly artificial; no invented reviews/autoplay/timing. Source-photo bytes are absent, local captures use stand-ins, and unsupported adjusted-background appearance is disclosed. Those established limits must stay visible.

Justin said to keep going with recommended options while away. This authorizes routine general fixes and the existing approved defaults, not acceptance waivers or a factual answer to the font-source question. Do not ask him repeated permission for authorized fixes.

## Validation and environment

Write failing generic tests before each valid correction, demonstrate they fail for the finding rather than setup, then restore/pass. Prove the media audit itself rejects the transparent-photo mutation, including parent opacity and intentional inactive-copy cases. Capture relevant visual proof for affected ACs, not payload properties alone. Check rotated diagram geometry at design width and responsive boundaries, retained pager badge, compact-header links and media reachability. Preserve source/run/head bindings in receipts. Use actual touch input where interaction is claimed.

Read existing builder/reviewer recipes as environment leads, not pass receipts. Node22 `/home/justin/.local/node-v22.23.3/bin/node`; Chrome `/home/justin/.cache/chrome-for-testing/chrome-f2b`; owned wrapper clears DISPLAY/WAYLAND_DISPLAY with established Linux launch flags. Read testing-pitfalls and shared corpus-paths-on-desktop memory. Use your evidence folder for large outputs/profiles, not RAM-backed /tmp. Do not mutate shared dependencies or the live candidate during isolated base/mutation tests. Complete appropriate targeted and project gates (`npm run check`, browser/UI, performance and `npm run corpus`) and the affected named ACs at the final frozen head. Reuse an unchanged baseline only with exact source/harness/input identity demonstrated; otherwise rerun the matched baseline. Report exact exit statuses and case identities, including existing failures.

Approved corpus is limited available-five: hydraulics/GRO are recovered configured originals; repairs/brainstorm/Services are explicitly extras. Three original old-Mac snapshots and historical v1 code/PNGs are unavailable, Aswatama is missing, and default-path0cases is not coverage. Do not substitute same-name/count files or claim historical coverage. Existing base/head failures and the1font skip must remain disclosed and no new failure/omitted common case may be hidden. Services input runtime-font correction and its negative controls are part of the candidate; preserve them. Plan Task11's golden shorthand resolves to `test/golden/files/convert-sample.json`; do not loosen broad expected outputs to clear findings.

Commit passing fixes with plain git commit, appropriate grouping, no author override/AI trailer/CLAUDE.md staged. Keep ledger/audit/HANDOFF facts current in the same fix commits; no records-only trailing commit after handback. Stop with a clean frozen head, `ready-for-next-review`. Main will dispatch a fresh full round2 from the story base.

## Report

Write `E/fix-1/report.md` and structured `report.json`: verdict, starting/final head and base, each finding verified/rejected/fixed with rationale/test/evidence/commit, checks and exact outcomes, all18 ac_status (checked/held/live/unproved accurately), remaining limitations. Return reusable `skill_lessons: [{skill, lesson, evidence, enforce}]`; empty is normal. Do not edit skills/memory. End `MAIN SESSION: check and save these skill_lessons now.`
