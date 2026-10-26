# FIX-ONLY FINISHER — card-hover-shift R1

## Role and mandatory skills

Read this brief, then load `figma-to-bricks` (FINISHER), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`, `systematic-debugging`, `mutation-testing-discipline`, `frontend-ui-repair`. You cannot spawn agents; parent runs fresh review and Agent Defect Loop verification. You are a FIX-ONLY finisher, **not authorized to release**.

## Existing state and scope

Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`; branch `worktree-card-hover-shift`; parent just verified tip `7e13764ebf77c5d57b709a8f37a17a9414e8501a`, only untracked `.superpowers/`. Keep all committed/untracked evidence. Plan `/Users/justin/.hermes/plans/figma-to-bricks/card-hover-shift.md`. Full earlier builder context in `briefs/card-hover-shift-builder.md` alongside this file. Actual implementation b330f86 and original Q3B0263b58 remain.

Justin wanted service-card text and arrows to stay in place on tablet/phone hover. Approved same-size sizing inheritance, wrapper compensation, then narrow responsive room/minimum accounting repair keeping strict ±1px motion test. Explicit model override: 'cant you resume with 6.1 sol'; remaining pipeline Sol6.1 xhigh. Fix the introduced review defect within this approved behavior, not unrelated base-layout policy.

## Fresh review result — verbatim finding

Verdict: `changes_requested; release_held`.

**R1 — P2, introduced:**

> Wrapper matching is not one-to-one: two hover wrappers can both claim the same unmatched original layer. Genuinely added sibling content then receives replacement-only compensation, shrinking its flow footprint and moving later content. Introduced in Q3B0263b58 and retained in this candidate. Reserve proven matches once, or reject ambiguous matches, while leaving newly added content uncompensated.

**Evidence:**

> src/core/understand/overlay.ts:47–56,105–117 never reserve a standsFor match. adversarial-unit.tap reproduces2 compensated wrappers for1 original. duplicate-v2/evidence.json renders distinct Service/New offer labels: the added88px wrapper incorrectly receives margin-right:-8px at1440 and990. At1440 downstream words move308→296px;4px belongs to the real replacement and8px is erroneous additional movement. Fixture, payloads, geometry and screenshots are preserved.

Reviewer evidence `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/reviewer-b330f86/`. Read actual probes and evidence; don't recreate from a summary and accidentally change the case. Verify the finding, fix test-first with appropriate ambiguous/one-to-one/new-content controls and preserve legitimate wrapper behavior, intentional hover changes and strict motion oracle. Independently determine the correct implementation; the review suggestion is not a dispatcher-designed algorithm.

## What the reviewer actually executed

Whole main...HEAD at base b4ed333/tip7e13764. Pinned Node22.19 check2121/2121+6/6 and full browser246/246 pass. Initial Node22.22 background teardown hangs preserved as incomplete, unchanged pinned retries pass. Fresh corpus exit1 same18 baseline identities29widths; four report/paste/fullHTML files identical, hydraulics2hover descendants change. Garamond expected/missing, not green. Strict375 oracle byte-identical to archives; old936cfa4 fails intended case, candidate passes. Nine isolated mutations killed; adversarial28/29 exposes R1. Fresh real input base60/candidate60 measurements, no candidate layout/containment/strict-motion failures. Original333-artifact and stop21-artifact archives verified; new review322-artifact manifest verified. These are prior-review receipts, not your fresh corrected-source checks. Preserve them and label your revision separately.

## Required continuation

1. Confirm source/test ownership before editing, including separately active `hero-media-row` ownership of least.ts interfaces. This fix should stay in the wrapper matcher/tests; don't consume unrelated interface changes. Other session agents are not dead because absent from this chat list.
2. RED regression on original reviewed candidate, then minimal general fix and GREEN, meaningful mutation proof, established affected/project gates and strict375 plus real-layout proof. Use the working runtime the reviewer recorded rather than repeat known teardown hangs without attribution.
3. Refresh corrected-source after proof where output changes; preserve original/provisional pictures and archives. Distinguish completed checks, inherited receipts and still-missing checks. Archive new evidence durably in a separate fix-r1 folder with exact source revision/manifest; don't overwrite original proof.
4. Update plan copy, ledger and HANDOFF with R1 disposition and remaining holds. Commit and return `ready-for-review` or `ready-for-verify` **as a fix-only checkpoint** with precise remaining gates; parent will run a NEW fresh independent review because output changes, then the required independent verifier.
5. **No merge, push, BUILD bump, main CLAUDE edits or cleanup.** Release remains held even if all corrected-source checks pass.

## Explicit unresolved holds

- Literal360 criterion: independently measured base label y25/title63.140625, candidate label24.5/title63.640625. Matching unhovered wrapping is proven, forcing same-label-row is not. Justin has not yet answered match-existing vs base-layout expansion. Do not reinterpret it, change base layout or weaken oracle.
- Garamond Condensed missing on base/candidate remains UNVERIFIED. No substitution/narrowing and no release-specific waiver granted to this feature.
- Fresh independent review after R1 output change and independent verifier still required.
- Installed-Bricks editor/live paste check and authorized release/documentation steps remain owed.

Always explicit workdir. Never retry/bypass denied approvals. List other defects in found_else rather than fixing them. If stopped, commit passing work, name exact evidence and options. Return status, summary, last_commit, worktree, R1 disposition, executed gates, pending gates, evidence path, shots, defect_loop_skills and found_else.
