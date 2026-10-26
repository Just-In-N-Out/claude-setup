# Fresh corrective re-review — pdf-direct-download

## Role and exact target

NEW FRESH independent REVIEWER, read only, after the R1 fix pass and Justin's explicit R2/font decisions. You are neither the builder nor the prior reviewer/finisher.

- Worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/pdf-direct-download`
- Branch: `worktree-pdf-direct-download`
- Tip: `9df01755d7e39fe13e57707013700c5976604469`
- Corrective source commit: `6bc55591001e7f2575360062016a10f69be598bd`
- Previously reviewed tip: `d2e86e1b388bd36322d051e7d3f3a524acf1bbdc`
- Base: `b4ed333631dba923b73e1731ad420a4f92d880f1`
- Current authoritative plan and Justin's decisions: `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`
- Original fresh review archive: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/reviewer-d2e86e1/`
- Fix-pass archive: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/finisher-r1r2/`
- Builder archive: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/builder/`

The parent verified all 204 original-review evidence targets and all 283 corrective targets/source pins. That establishes archival integrity, NOT the truth of the finisher's behavioral claims. Independently execute important checks. The worktree was tracked-clean except `.superpowers/`; preserve existing evidence and all other sessions' work.

Read the focused delta `d2e86e1..9df0175`, then confirm the complete `main...HEAD` diff still meets the approved contract. This is a focused corrective review, not a fresh mechanism-planning round.

## Skills — load in order

1. `figma-to-bricks`
2. `engineering-best-practices`
3. `requesting-code-review`
4. `code-review-practice`
5. `mutation-testing-discipline`
6. `frontend-ui-repair`
7. `frontend-cross-browser-matrix`
8. `frontend-testing-workflow`

Also load `figma-to-bricks` → `references/link-validation.md` and its rules summary before evaluating the mechanism. You are already the independent reviewer: skip any nested-reviewer/auto-fix instruction. Report only; change no source/tests/records, commit nothing, do not bump BUILD/merge/push or write to the live site. Use isolated scratch snapshots for probes and restore any owned mutations.

## Current product contract — explicit user decisions win

The initial plan was approved 1A/2A/3A/4A. Structural linked Button/Div/Block PDF controls download direct same-origin PDFs; direct foreign PDFs keep no-opener new-tab viewing; linked words, pictures/vectors and whole-linked text stay as viewing links; non-PDF behavior remains unchanged. Plugin-only; no server/script delivery mechanism.

After the correction stopped, Justin explicitly selected:

1. **“Keep direct downloads; accept that redirect limitation.”** A same-origin URL redirected off-site can replace the originating page without downloading. This is an accepted, bounded limitation, NOT an R2 fix. Direct download, direct foreign fallback and ordinary links must still work. Do not block review by demanding the now-replaced universal redirect fallback promise or undertake a new mechanism hunt. Retain truthful regression/limitation receipts; do not disguise them as passing universal fallback tests.
2. **“Allow this PDF release with that font check marked unverified.”** For **pdf-direct-download only**, the pre-existing final-design Garamond Condensed absence may remain explicitly **UNVERIFIED** if all other required gates pass. No substitute, expected-set narrowing, weakened test or waiver for another release. Independently confirm this is still the same pre-existing font gap, not new missing fonts or changed output.

These decisions do not waive review, independent Agent Defect Loop verification, all other project gates, archive integrity or truthful installed-Bricks/browser coverage limits. No merge is authorized to you.

## Findings and finisher answer to verify

**R1 major, introduced:** “PDF-linked pictures unexpectedly download in the panel's default inline-picture mode, violating the explicit unchanged-picture scope.” Earlier cause: `understand/understand.ts:72` turns pictures into Divs under `inlinePictures`; emitter eligibility checked only emitted kind. Both headed/headless Chrome downloaded `cover.pdf` on the candidate instead of opening the base's viewer.

Finisher claims `6bc5559` now excludes preserved image/vector roles. Tests include images, vectors, vector-only frames, masked pictures and marquee copies in both picture modes. Claimed causal RED before fix, unit16/16 and browser8/8 afterward. Challenge negative coverage and inspect all affected provenance transformations; retain positive Button/box controls so conservatism cannot disable the feature wholesale.

**R2 minor, introduced:** same-origin PDF URL redirects to second-origin PDF; `download` causes original page navigation despite `_blank`/`noopener`. Finisher reproduced 42 static-HTML cases and found no approved fix. Justin accepted this exact limitation as above. Confirm scope is documented without claiming universal new-tab fallback. Do not relabel it fixed.

Nonblocking whitespace warning was repaired; independently run `git diff --check`.

## Required independent validation

1. Review the corrective source and all consumers affected by preserved semantic role. Verify both picture modes and all genuine image/vector representations stay view-only while structural control downloads, custom attributes, deterministic IDs and marquee behavior survive.
2. Independently reproduce the original R1 oracle against reviewed versus corrected source, then prove the provenance guard and missing/misplaced download mutations actually fail the intended cases. Do not mutate the assigned worktree in place if an isolated copy can prove it.
3. Run real-PDF Chrome mouse and keyboard paths and unchanged viewing controls, including inline/native picture modes and direct cross-origin fallback. Verify completed bytes/filename, actual anchor, tab/current-page/opener behavior; do not count PDF-viewer scratch files as downloads. Headed proof is required by the plan; other browsers not executed remain unproved.
4. Re-run established project gates as required by the project/loop skills. Compare same-base corpus/debug outputs and full font reports; historical green summaries alone are not current execution. The finisher reports check2128+6, browser252, five payload/HTML pairs equal and same18 v1 identities—verify, do not assume.
5. Preserve the original baseline and distinguish reconstructed or matched-policy recaptures. The one font waiver above permits only its exact pre-existing absence; no new regression is waived.
6. Check records against current external approved plan. Worktree records written before Justin answered can be records-only follow-ups for the finisher; distinguish them from output defects. Do not require an unapproved source change for wording.
7. Installed Bricks 2.3.9 paste/save/copy-back and live page click acceptance are still owed in the approved user-paste workflow; documentation/local renderer is not that proof. No claim of live success or unrun Safari/Firefox/Edge/mobile passes.
8. Avoid another foreground timeout: use a tracked background browser run and `process_manage`, or complete bounded file groups. Preserve raw failures and separate host Chrome startup contention from source assertions; clean only positively identified orphaned roots with PPID1.

## Return and release boundary

Write evidence durably under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/rereviewer-9df0175/`, with exact base/tip, a manifest and all named probes/reports. Do not edit shared board, handoff or found ledger. Report unrelated discoveries separately without fixing or widening scope.

Return `verdict: clean|findings`, `findings[{id,severity,introduced,claim,evidence}]`, `gates[]`, `found_else[]`, `evidence_paths[]`, `defect_loop_skills[]`.

Agent Defect Loop applies (`frontend-ui-repair`, `frontend-cross-browser-matrix`). You are the NEW fresh problem-finder after the correction. The parent still dispatches a records/fix finisher if needed and a separate independent VERIFIER before any release. You may not merge, push, bump BUILD or delete the worktree.
