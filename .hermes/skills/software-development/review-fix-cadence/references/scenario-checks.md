# Cadence scenarios

## Should trigger
- Fix the first review's blockers before Opus looks again.
- Sol reviewed it; have Sol repair it, then get Opus.
- First review found a security issue; second reviewer is unstarted.
- Change our flow to review, fix, review, fix.
- Repair known failures while Claude waits for quota.
- Send the corrected candidate to the next independent reviewer.
- Opus found another bug; assign Sol the fix pass.
- Save the multi-model review and repair order for future work.

## Should not trigger
- Translate this sentence.
- List ClickUp tasks without starting work.
- What time is it?
- Write a song about code review.
- Show sports results.
- Summarize a document without changes.
- Stop all agents and do not resume them.
- A plan awaits go and no implementation is approved.

## Output contract cases
1. **Sol review has two valid introduced blockers; Opus is unstarted.** Scoped Sol fix on the existing feature branch; real RED/GREEN and required gates; stop ready-for-next-review. Opus later reviews corrected heads, not the broken original.
2. **Sol review is clean.** Fresh full Opus review; no no-op fixer. Preserve all live/hosted holds.
3. **Sol fix complete; Opus quota guarded.** Hold Opus with corrected heads and brief; verify actual usage later. No silent model substitute or unverified timed start.
4. **Opus finds a valid defect.** Sol fixes test-first; behavioural changes still receive fresh independent review and applicable separate loop verification.
5. **Opus is clean.** Required verifier, remaining acceptance and records; no invented edits. Publication permission is unchanged.
6. **A reviewer is already running on an older frozen candidate.** Do not mutate its input or stop it automatically; label its report revision and integrate safely.
7. **One finding proposes a new product fallback while other fixes are independent.** Hold the fallback for the user's decision; generic fix approval cannot reverse accepted behaviour. Continue demonstrably independent fixes under existing authorization. Record the scoped answer in current instructions before steering the same fixer, preserving any explicit separate-go requirement.
8. **No implementation go exists.** This cadence does not authorize building or publication.
9. **A fixer-owned gate subprocess exits zero while its agent still owns the fix pass.** Credit only that gate. Do not dispatch the next reviewer or claim the fixer finished before the complete role handoff is returned and admitted.
10. **A required gate fails during an active fix pass.** Preserve the full original failure and keep diagnosis with the same owner. If an approved behavior change invalidates an old output assertion, require a strengthened replacement oracle, a mutation restoring the unsafe behavior and a passing required rerun; never silently remove the assertion.
11. **Passing gates record the precommit HEAD but their consumed-source hashes match the final commit.** Preserve the original receipts, verify that byte-identity binding and distinguish it from a postcommit run. Re-run affected checks only if consumed bytes changed or project policy requires exact-commit execution.
12. **A producer seals an exact evidence set before returning.** Rehash the complete declared set, check for extras, and write parent intake outside the sealed root. A matching manifest digest or a clean publication subset alone does not prove source freshness, full-directory privacy or independent review.

13. **A report mixes annotated command records with raw receipts and aggregate evidence.** Validate each discriminator and referenced path first. Separate declared report annotations from the complete execution payload before comparing it with the raw receipt; reject unexplained differences. Validate sensitivity/dependency/preservation aggregates under their own schemas. Correct a reader mismatch without inventing a successful exit, rewriting producer evidence or replaying unchanged gates.
14. **Routine notices include failing mutation variants and a successful enclosing runner.** Leave classification with the current reviewer and await its qualified handoff. Neither variant failure nor wrapper success changes the phase; avoid repeating unchanged pending-status replies.
15. **Native laptop input is paused while code review remains authorized.** Carry the task-scoped no-click/type/focus boundary into successor briefs, continue independent review, and keep genuine manual acceptance unverified. A build resume or passing fixture does not restore input permission or satisfy the operator checklist.

16. **Back navigation restores the correct page but the protocol lifecycle waiter fails.** Preserve the original trace. Require actual restore-event and destination-DOM evidence before classifying a harness-only failure; a fixture workaround does not prove default-browser-wide coverage.
17. **A browser journey passes but owned-profile teardown fails.** Keep the required invocation failed until corrected normal/cancelled cleanup proves owned process/profile absence. Do not accept journey assertions alone, silently ignore teardown, or remove another browser's data.
18. **A timing command runs after failed resource admission.** Preserve the attempt as contaminated and exclude it from calibrated claims. Require a separately prospectively admitted, fail-closed launch under the same approved threshold; a later quiet observation cannot retroactively admit the first run.

19. **Source review is clean, but the required browser run never completes.** Preserve clean-source/validation-held as separate facts. Use a validation-and-records-only assignment with the original failed attempts and spent budget, not an invented source fix. Require a discriminating new observation before another costly execution; partial/focused passes cannot close the complete independent gate.
20. **The user accepts one retained image-equality gap while browser proof is incomplete.** Bind the release-only acceptance to the archived pair and measured discrepancy; keep its unknown cause and red proof honestly labelled. Update and steer the current owner, skip redundant research into the accepted gap, and continue independent browser work. Do not extend the waiver to a font gap, a new image difference, privacy verification or runtime interaction.

21. **Former witnesses and canonical gates pass, but a valid nested-content class still fails.** Keep the finding OPEN and return an honest stopped partial with exact failing inputs, source binding and preserved passing work. Do not commission another approval review or accept a narrower supported subset implicitly. If the fix exceeds the approved design, route read-only architectural replanning and retain the approval gate for broader code or feasibility execution.
22. **The execution ledger includes a formatter with changed-source flags.** Verify its actual command, owned paths and intended delta, then classify it as authoring rather than a read-only test. Do not label that expected mutation a failed test, count it as validation, or relax stability checks for real gates. Bind subsequent required checks to the resulting final bytes.

23. **A resource-admission repair passes adversarial cases, uniform size padding and tiny shipped fixtures.** Do not infer that ordinary supported content is preserved. Carry realistic ordinary and code-heavy inputs at supported size boundaries, valid nested/mixed contexts and the original hostile controls into the corrective brief. Use a trusted path or explicit semantic contract rather than the new guard's thresholds as the oracle; compare the same input bytes on baseline and candidate. A fast false-positive fallback is still a correctness regression unless its precise limitation was explicitly accepted.

24. **The user changes a diagnostic-only instruction to applying an existing fix.** Record the new source-write authority without inventing a validation or publication waiver. Resolve only any still-unanswered material product choice, then dispatch the scoped fixer on the existing branch; do not require a second implementation approval or restart architecture research.
25. **A proposed experiment leaves the implementation gate unresolved under every possible outcome.** Label it diagnostic-only before requesting permission, name the decision it can inform and the clearance still required, and do not describe its successful completion as readiness to apply or ship the fix.
26. **Prototype examples pass while application source is unchanged.** Say the story is not done when asked. Report prototype evidence separately from application implementation, remaining validation, independent review and operator acceptance.
27. **Round 3 (a delta review of the fix commits) is clean.** `review-check.sh` prints MOVE ON: its P3 lines go to `<evidence>/follow-ups.md` and the verifier starts. No extra full review, and the main session rules on no finding.
28. **Round 4 repeats round 3's P2 with no new fact.** `review-check.sh` prints ASK JUSTIN (brake d): dispatch nothing until Justin answers. Record his words in `<evidence>/review-4/justin.json` (`accept` for known limits, `"continue": true` to keep going), then rerun the referee and follow its new last line.
29. **The verifier finds a bug after MOVE ON.** A fixer fixes it test-first, then a fresh delta review of that fix, until `review-check.sh` prints MOVE ON for the new head; only then the verifier again, then the auditor and `ac-check.sh --reviews`. A records-only commit after MOVE ON needs the same short review.

## Operational handoff cases

- **Required artifact admission passed; optional preview packaging is unfinished.** Start the prepared eligible independent reviewer before optional packaging or lengthy record cleanup. Keep privacy inspection mandatory before sharing, and preserve deferred manual acceptance; neither is silently promoted to a pass.
- **Shared routing is nondefault while a reviewer is queued.** Identify the actual routing owner and unfinished dispatch interval before declaring a hold or clearing settings. Record the owner and release condition without building a new monitoring workflow. On the next task-capable turn, fresh released-state, candidate and quota checks lead directly to native dispatch, actual-model verification and scoped reset; no renewed approval or stale waiting status.
- **Old helper failures arrive after their replacement has already completed.** Match the process IDs to saved dispositions. Preserve the historical errors without restarting helpers, reopening product validation or claiming useful work is active. A monitor timing out does not release another owner's reservation.
- **The user asks whether work is running after several helper notices.** Inspect the named feature's live registry and board; answer yes or no first. Distinguish its productive reviewer from completed checks, queued briefs, helpers and other stories. If the approved next role is now unblocked, launch and verify it before announcing it running. Keep the review estimate separate from whole-story completion.

These are fixtures/expected outcomes. Record structural checks separately from actual agent executions. The active workflow is the live trial, not an already-passed multi-case experiment.
