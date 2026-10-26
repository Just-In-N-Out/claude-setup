# FINISHER fix pass — found-contacts F1/F2 (NO RELEASE)

Read approved found-contacts.md and original builder brief; worktree /Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/found-contacts, exact reviewed cd1ef6d639e188f6ffb688432914d337928cd641 vs baseb4ed333. Parent verifiedHEAD/trackedclean/main-originunchanged. Preserve all source/evidence. Sol6.1 xhigh, scope narrow C1A/C2A/C3A boundary corrections only.

Load figma-to-bricks, engineering-best-practices/peer-review-strategy, receiving-code-review, git-commit-rules, test-driven-development, systematic-debugging, mutation-testing-discipline, qa-testing-local-cloud. Verify each finding yourself before fixing, RED first, minimal corrective source/strongcontrols; no self-review. Parent will dispatch NEW fresh focused semantic reviewer after your fixes. Children cannot spawn. Stop committed ready-for-review, NOT merge/push/BUILD/cleanup; source semantic changes require fresh rereview and all missingheavygates before anyrelease. No automatic finisherfinishstep overrides this boundary.

## Fresh reviewer findings (verbatim facts from received result)
F1 — P2, introduced:false, blocking_for_plan_acceptance:true. Location src/core/normalise/address.ts:33–35. Title: A valid spaced ID hash marker still contaminates the map query.
Reproduction: `12 Market Street, Springfield IL 62704 • Order ID # 0812 473 1900`.
Expected `12 Market Street, Springfield IL 62704`; actual `12 Market Street, Springfield IL 62704 • Order ID #`.
Explanation: P1A recognizes the number as ID data, but the new residual-field regex accepts ID# only without intervening horizontal space. The metadata survives through conversion into the actual map iframe query. This is an unfixed boundary of assigned C3, also present on the exact base.
Minimal fix: Accept the existing single-marker horizontal spelling in bounded metadata-field cleanup only. Retain raw PHONE grammar, standalone-line association limits and real street/unit/postcode controls.
Evidence: boundary-findings.log F1 fails through convert/map q; compact-hash, spaced-colon and suite-preservation controls pass.

F2 — P2, introduced:true, blocking_for_plan_acceptance:true. Location src/core/normalise/contacts.ts:43. Title: Timestamp projection can overlap an unchanged accepted email.
Reproduction: `😀 Updated +2026-10-21 10:30@workshop.org`.
Actual rejected:[{start:11,end:28,reason:'date'}], found:[{start:26,end:41,kind:'mail',href:'mailto:30@workshop.org'}].
Explanation: timestampAt permits @ after the clock and consumes the numeric email-local slice. The independent EMAIL scan then accepts that same slice, violating the bounded-token/nonoverlapping projection contract. The exact base recognizes the same email but has no rejection for this input, confirming this overlap is introduced.
Minimal fix: Require timestamp ownership/bounds that cannot consume an accepted email slice. Preserve email recognition and unsupported-token legacy behavior; do not suppress the email to hide the overlap.
Evidence: boundary-findings.log F2 overlap assertion fails; a bounded clock followed by separate genuine phone/email controls passes.

## Evidence and tests
Reviewer durable evidence /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-contacts/reviewer-source-cd1ef6d/: review.json, reviewer-manifest.json, boundary-findings.test.mjs, boundary-findings.log, focused/mutationreceipts. Parent readactualrawlog:4tests,2expectedfindingfailures,2positivepass. Read/copy original fixture from disk, don't retype masked phone strings. Reviewer independently165focusedpass,5mutantskilled,55controlsrestored;1396builderentries and562baseblobs checked, staticpairs equal, no renderedacceptance claimed. Preserve all oldrawproof, use new fix-pass evidence directory and exactcodehash.
Allowed sourcechanges address.ts residualmarker boundary, contacts.ts timestamp/emailownership seam only unless a demonstrated essential change within originalallowlist is proposed toparent first. New regression cases in existing feature-owned unit/convert-found-contacts files. Keep separate rawphone/multispacegrammar and all existing controls, designerstyledlinks/card scope/maps/UTF16indices. Add clock+numeric-email boundary variants and boundedfield marker combos, no globalemail suppression or new datetimevocabulary. If exact oldunsupportedtokenlegacy can't be preserved, stop with scopedoptions, no newpolicy.

Heavy slot currently gates reviewer, contacts next AFTER its release. Lightweightunit/typecheck/source-copy mutations now; no fullChrome/corpus/perf or broadcapturesuntilparentallocation. Bounded existingindividual diagnostic possible only if parentgrants, notrequiredforF1/F2 purefix. Missing fullcheck/browser/corpus/render/anchorRGBA/fonts must remain explicit. Baseline reconstruction labelledexactb4ed333, not original. Disk6.6GiB latest, no bulkcopies/deletion. Update ledger/HANDOFF corrective facts/sourceSHA and pendingCLAUDEproposals only; no protectedwrites. Existing payloadstaticproof must rerun on correctedsource, no inheritedgreenidentity.

W-B/ALONE unchanged. Garamond UNVERIFIED/no stand-in/narrowing/historicalwaiver. NO CLAUDEwrites/retries viaanytool/parent. No sitewrites/newdependencies. Return reviewedtip,newtip,eachfindingverification/fix,testREDGREEN/mutations,pendinggates,evidencepaths,found_else,defect_loop_skills. Fresh rereviewrequired, no release.
