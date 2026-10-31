# landing-page-loop — fix pass after full review 2

## Role and ownership

You are a fresh FIXER. Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/landing-page-loop`, branch `worktree-landing-page-loop`, integration local `main`, story base `c67128c4cca8eff67afdf3f7e6e8b28a75294deb`, starting reviewed head `122e0c975af963c7be42c9e892f75a97b62668ed`. Check identity and clean state before changing anything. You are not alone in the codebase: preserve others' changes and do not revert them. Do not spawn agents, rebase, merge, push, bump BUILD, edit the main folder, change Figma/WordPress, edit skills or memory, or revise the approved ACs.

Your responsibility is verifying and correcting the four review-2 findings below, including meaningful generic regression tests and story-audit sensitivity. Own the implicated review-slider logic and directly required helper/generic fixture/test changes within the approved plan; own the text inventory audit and its negative controls. Preserve the already verified fixes for stationary artwork, transformed diagram pieces, compact navigation pills and painted/reachable media. Keep changes bounded to the findings. If a necessary correction needs a genuinely new owner or decision outside the approved plan, report the evidence and proposed scope to the main session before that change; continue independent fixes. Preserve the architecture, pure stages, typed CSS, deterministic IDs, sandbox restrictions and native Bricks editability. No file-specific names, ids, fonts or dimensions may become recognition rules.

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, engineering-best-practices first among engineering skills, receiving-code-review, test-driven-development and git-commit-rules from `/home/justin/.agents/skills/`. Load systematic-debugging for unexpected failures and mutation-testing-discipline when testing a guard. Read the worktree CLAUDE.md and review-loop reference. User/global/project instructions override conflicting skill defaults.

Approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop/plan-approved.md` (SHA256 `541f68d6bfb8fa39a442cdfabc728bcea0aecd0186b7285cdef4db4b60c2ec77`). Evidence root E `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop`. Your outputs belong in `E/fix-2/`, plus the worktree's code/tests and existing story ledger/audit/HANDOFF records as necessary. Prior review evidence `E/review-1/review.json`, `E/review-2/review.json`, their reports/probes and `E/fix-1/report.json` are available. Review2 independently confirmed all four review1 findings fixed; its four new findings remain to be verified and corrected. Read complete findings, independently verify each before fixing, and give evidence for any rejection rather than silently dismissing it.

## Referee output and continuation

The referee initially returned ASK JUSTIN because review2 has four new P2s, the same count as review1. Justin had already explicitly instructed the main session to keep things going with recommended options while away. Main recorded his exact existing words as continuation only in `E/review-2/justin.json`, with provenance in `continuation-authority.md`; no finding or AC was waived. Root reran the referee and received:

```
R2-1  P2  src/core/understand/review-slider.ts:43  Pager discovery ignores links and actions on the pager group or its ancestors, then deletes those explicit destinations
R2-2  P2  src/core/understand/review-slider.ts:35  Rebuilding pager ancestors as source-free holders discards the stationary notice wrapper's authored appearance and spacing
R2-3  P2  test/story/landing-page-loop/inventory.ts:49  The mandatory text inventory passes when responsive styles make the source text invisible on phones
R2-4  P2  src/core/understand/review-slider.ts:65  Loose quote and attribution nodes are forced to fill the slide, losing their designed widths and centering
REVIEW AGAIN: 4 P0-P2 finding(s) in review-2 at 122e0c9: fix them, then review the fix commits
```

## Review2 findings, verbatim

```json
[
  {
    "id": "R2-1",
    "severity": "P2",
    "file_line": "src/core/understand/review-slider.ts:43",
    "claim": "Pager discovery ignores links and actions on the pager group or its ancestors, then deletes those explicit destinations",
    "scenario": "A designer links the grouped review indicators or their notice row to the full reviews page; conversion replaces that linked group with a slider and the destination disappears.",
    "evidence": [
      "probes.ts",
      "probe-observations.json",
      "browser-probes.ts",
      "browser-probe-observations.json",
      "linked-pager-snapshot.json",
      "linked-status-snapshot.json"
    ],
    "detail": "pagerOf checks link/click ownership only on individual mark leaves. Although visit carries an inside flag, the later walkIR(host.children) rediscovery does not carry it. Adding one ordinary Figma URL reaction to either the Pager row or the Status row in the generic fixture leaves a hit-tested https://reviews.test/all/ anchor on base and yields one new slider with no such anchor on head, at390 and1440. Respect link/prototype ownership throughout the complete host-to-pager path and preserve the conservative fallback for linked indicators. This is a new ownership-boundary defect, not a recurrence of the fixed R1-1 leaf deletion."
  },
  {
    "id": "R2-2",
    "severity": "P2",
    "file_line": "src/core/understand/review-slider.ts:35",
    "claim": "Rebuilding pager ancestors as source-free holders discards the stationary notice wrapper's authored appearance and spacing",
    "scenario": "A designer puts the review notice and pager on a tinted rounded strip; conversion removes the strip's color, opacity, corners and side padding along with the decorative pager.",
    "evidence": [
      "probes.ts",
      "browser-probe-observations.json",
      "painted-status-snapshot.json",
      "painted-status-base-1440.png",
      "painted-status-head-1440.png",
      "painted-status-base-390.png",
      "painted-status-head-390.png"
    ],
    "detail": "stripPager now preserves untouched artwork leaves, fixing R1-1. When a descendant pager is removed it still replaces every changed ancestor with phoneBox/holder and retains no src/style owner. A generic Status carrier with fill#b5d6e8, opacity0.65, radius12 and24px sides converts on base with those values. Head still creates the slider but its stationary Status becomes transparent, opacity1, radius0, padding0 and expands from394.875px to1072px at1440. Retain the carrier's authored look/constraints while removing only pager content, or conservatively decline an unsupported carrier. The retained badge proves this is distinct from the earlier missing-leaf finding."
  },
  {
    "id": "R2-3",
    "severity": "P2",
    "file_line": "test/story/landing-page-loop/inventory.ts:49",
    "claim": "The mandatory text inventory passes when responsive styles make the source text invisible on phones",
    "scenario": "A responsive style regression hides headings, navigation words and body copy on portrait phones; the required whole-page text acceptance still reports a pass.",
    "evidence": [
      "text-phone-opacity-hook.mjs",
      "text-phone-opacity-mutant.log",
      "text-phone-mutant/landing_text_inventory/receipt.json",
      "text-phone-mutant/landing_text_inventory/390.json",
      "text-phone-observer.ts",
      "portrait-hidden-text.json",
      "portrait-hidden-text.png",
      "text-opacity-mutant.log"
    ],
    "detail": "At each width the check requires only DOM ownership and textContent. Font/paint checks run only at1440; no responsive owner is required to be visible/reachable. A single exact-module preload changes only emitted text settings by setting _opacity:mobile_portrait=0, leaving every assertion unchanged. landing_text_inventory exits0 across all25widths, while its own390px DOM record marks155 nonempty text-containing elements invisible; the independent screenshot/observer confirms opacity0 headings/body/navigation. An all-width opacity0 control does fail at the desktop platform-font assertion, isolating the missing narrow-tier oracle. Require a painted/reachable eligible text/run owner or a verified active responsive copy at every tier, preserving intentional hidden-copy and slider controls."
  },
  {
    "id": "R2-4",
    "severity": "P2",
    "file_line": "src/core/understand/review-slider.ts:65",
    "claim": "Loose quote and attribution nodes are forced to fill the slide, losing their designed widths and centering",
    "scenario": "A designer centers a short hugging attribution under a review; conversion stretches the attribution and paints its words against the slide's left edge instead.",
    "evidence": [
      "direct-content-probe.ts",
      "direct-content-snapshot.json",
      "direct-content-observations.json",
      "direct-content-base-1440.png",
      "direct-content-head-1440.png",
      "head-page-shots/s09-0.png"
    ],
    "detail": "The fallback for directly adjacent quote/attribution nodes sets sizing.w=fill on each moved node, rather than keeping the source width/alignment contract. A generic centered long quote and hugging attribution convert with the attribution glyph center at the panel center on base; head keeps the element box centered but its start-aligned glyphs shift left by462.40625px at1440 and73.40625px at390. The quote also widens from760px to1072px at1440. The real testimonial side-by-side exhibits the same left-shifted attribution. Preserve each moved content node's own sizing/alignment (including hug versus fixed/FILL) and test the loose-content path as well as pre-wrapped review bodies."
  }
]
```

Read the final review2 report for additional gate observations. All checks have finished. Its complete browser run has base411/424pass,12fail,1skip and head440/454pass,13fail,1skip. Three head failures beyond the historical ten are page-load timeouts; two also occurred on fresh base. The three exact files passed focused retry7/7, but the complete-run AC16 remains failed because of one additional head-only timeout (inferred source anchors). No production-source causality was established. Preserve those receipts and reproduce/diagnose the remaining difference on a matched environment; a focused retry is not a replacement for required complete-gate proof. Do not silently dismiss it, hide cases or change unrelated source. A genuinely new required owner needs a scoped amendment before changing it.

## Requirements and boundaries

Read all18 AC clauses and named checks in the approved plan. AC1 centred navigation; AC2 header/footer ticks; AC3 sticky navigation; AC4 navigation/contact/action links; AC5 inset panels; AC6 inferred origins; AC7 editable labelled diagrams; AC8 native review-slider structure; AC9 real review interactions; AC10 actual font-face measurement; AC11 safe typed axes through classes/runs/buttons/forms/states; AC12 every text/run; AC13 media provenance/geometry/visibility; AC14 all-section responsive geometry; AC15 links/motion; AC16 complete matched regression gates within the approved available-input scope; AC17 effective designer-confirmed font match; AC18 live Figma/Bricks round trip. Exact plan clauses control.

AC17 remains NON-LIVE HELD: raw opsz9 is not proof of effective automatic optical sizing, the designer checkbox is unknown, and site font files lack optical/custom axes. Do not guess that flag, weaken the criterion, implement conditional Task9b or claim release acceptance. AC18 is user-owned live/not run. The missing Free Estimate URL stays unlinked with the approved warning. Placeholder review content stays explicitly artificial; no invented reviews/autoplay/timing. Source-photo bytes are absent, local captures use stand-ins, and unsupported adjusted-background appearance is disclosed. Those established limits must stay visible.

Justin said to keep going with recommended options while away. This authorizes routine general fixes and the existing approved defaults, not acceptance waivers or a factual answer to the font-source question. Do not ask him repeated permission for authorized fixes.

## Validation and environment

Write failing generic tests before each valid correction, demonstrate they fail for the finding rather than setup, then restore/pass. Prove the text audit itself rejects phone-only invisible text and ancestor-opacity/visibility mutations while accepting intentional inactive copies only through a genuinely painted reachable active owner. Preserve run/content/font requirements at every width. Capture actual content glyph anchors and authored wrapper appearance for loose and pre-wrapped review bodies, and real explicit-link reachability through grouped indicators and ancestor carriers. Preserve existing swiping/dots, placeholder notice, source sizing, stationary artwork and general negative controls. Capture relevant visual proof for affected ACs, not only payload properties or centered element boxes. Preserve source/run/head bindings in receipts. Use actual touch input where interaction is claimed.

Read existing builder/reviewer recipes as environment leads, not pass receipts. Node22 `/home/justin/.local/node-v22.23.3/bin/node`; Chrome `/home/justin/.cache/chrome-for-testing/chrome-f2b`; owned wrapper clears DISPLAY/WAYLAND_DISPLAY with established Linux launch flags. Read testing-pitfalls and shared corpus-paths-on-desktop memory. Use your evidence folder for large outputs/profiles, not RAM-backed /tmp. Do not mutate shared dependencies or the live candidate during isolated base/mutation tests. Complete appropriate targeted and project gates (`npm run check`, browser/UI, performance and `npm run corpus`) and the affected named ACs at the final frozen head. Reuse an unchanged baseline only with exact source/harness/input identity demonstrated; otherwise rerun the matched baseline. Report exact exit statuses and case identities, including existing failures.

Approved corpus is limited available-five: hydraulics/GRO are recovered configured originals; repairs/brainstorm/Services are explicitly extras. Three original old-Mac snapshots and historical v1 code/PNGs are unavailable, Aswatama is missing, and default-path0cases is not coverage. Do not substitute same-name/count files or claim historical coverage. Existing base/head failures and the1font skip must remain disclosed and no new failure/omitted common case may be hidden. Services input runtime-font correction and its negative controls are part of the candidate; preserve them. Plan Task11's golden shorthand resolves to `test/golden/files/convert-sample.json`; do not loosen broad expected outputs to clear findings.

Commit passing fixes with plain git commit, appropriate grouping, no author override/AI trailer/CLAUDE.md staged. Keep ledger/audit/HANDOFF facts current in the same fix commits; no records-only trailing commit after handback. Stop with a clean frozen head, `ready-for-next-review`. Main will dispatch fresh round3, a delta review from this pass's starting head122e0c975af963c7be42c9e892f75a97b62668ed and the code it touches, unless the referee requests full scope. Do not rebase.

Do not delay handback for optional scratch cleanup. When required work/reports are complete, return promptly and name any owned leftovers.

## Report

Write `E/fix-2/report.md` and structured `report.json`: verdict, starting/final head and base, each finding verified/rejected/fixed with rationale/test/evidence/commit, checks and exact outcomes, all18 ac_status (checked/held/live/unproved accurately), remaining limitations. Return reusable `skill_lessons: [{skill, lesson, evidence, enforce}]`; empty is normal. Do not edit skills/memory. End `MAIN SESSION: check and save these skill_lessons now.`
