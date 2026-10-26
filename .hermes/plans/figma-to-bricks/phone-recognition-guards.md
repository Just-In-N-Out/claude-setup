# phone-recognition-guards — revised bounded semantic policy

**PLANNER revision, October 21, 2026. No implementation authorized by this revision.** Inspected main `dc6713de82f2d74939a38c99b09cd0042f6b898f`, BUILD `2026-10-21.21`; stopped branch `worktree-phone-recognition-guards` at `e303c56d343e1861c072964101540a7f1813f820` (tests/records only). Original .19 plan remains in that branch's `docs/plans/2026-10-21-phone-recognition-guards.md`.

## Justin's approval — October 21, 2026

Justin replied **“A”** directly to the P3 question: **P3A approved**, retaining P1A/P2A. The four-file classification/title/label/target ownership extension below is authorized. Implementation is queued for the next builder slot, on Opus 5.5 medium with fresh Opus 5.5 xhigh review. Earlier statements that approval was still needed are historical.

## Decision first — answered P3A

**P3. When an approved ID/date rejection removes a dial link, may that same data create a guessed page link instead?**
- **A ⭐ Keep rejected data plain; preserve card-link boundaries.**
- B Allow ordinary page inference after removing the dial link.
- C Hold both guards; retain current production behavior.

**Recommendation A:** an otherwise phone-admissible candidate rejected *only* by approved P1A/P2A is neither an automatically dialable contact nor evidence for a page name. It cannot be an inferred title/page label; an inferred target containing that rejected data cannot acquire a new encompassing link. A valid, independent page-naming control outside that data may still link itself; an unrelated sibling card is unaffected. Existing designer links, linked title words, pills, own/ancestor links and B7 genuine-phone behavior win unchanged. This is a **new explicit inferred-navigation policy and file-ownership extension**, not merely a contacts.ts bug fix.

A is deliberately conservative: a card with an ID/date caption remains unlinked even if its real title is obvious and its old false tel link is gone. That protects the old clickable boundary; it is not a claim all dated cards should always be plain. B would permit new whole-card/ID/date page guesses and contradict the currently committed preservation tests; choosing B requires a separate plan/test-expectation revision, not weakening tests during A's build. C leaves the two false-positive findings open.

**Authority record:** P1A/P2A were approved under Justin's bounded away auto-go on October 21 (~16:38 EDT). Justin's later “Why three paused please continue” authorizes this read-only recovery investigation, **not** P3A, extra source ownership, automatic restart, or a global card-inference change. Parent must record the P3 answer and authorized scope before dispatching a builder. No approval inferred from the word “continue.”

**Sizing/routing reassessed:** **in-between**, Opus 5.5 **medium** builder/finisher and a fresh Opus 5.5 **xhigh** reviewer. This now changes an inferred-navigation decision shared by title, label and target selection, with normalise semantics affecting style; it is no longer the original small contacts-only Sol job. Even though proposed edits stay in normalise, the policy-change rule independently requires Opus. No explicit user model override found in this brief; parent checks usage before dispatch and waits rather than downgrading if needed.

## Playback and fixed scope

1. Stop only explicitly marked same-line IDs and valid complete plus-dates becoming automatic dial links/Call sources/phone wrappers.
2. Do **not** let that removal invent page addresses, make the surrounding card clickable, or let rejected data displace a real title.
3. Retain designer URLs/frame links/tel links, title-only linked words and plain surrounding cards, linked pills, supported genuine phone ranges/dial strings and B7 styled-run protection.
4. Use one raw-text classification seam, not duplicated ID/date regexes in page/title/style consumers. No site-specific names/IDs/numbers/years or global switch disabling page inference.

### Already approved, unchanged

- **P1A:** candidate immediately preceded on its same logical text line by a standalone case-insensitive `ID`, optional single `:` or `#`, horizontal whitespace only. No order/account/invoice/serial vocabulary, cross-node label association or NLP. `Phone:`, “For your order call …”, unrelated earlier ID and unmarked identical digits remain supported.
- **P2A:** entire matched candidate is `+YYYY.MM.DD` or `+YYYY-MM-DD`, identical separator, real calendar month/day (leap rules included). No current-year cutoff, new day-first/space/slash shapes, country validation or wider invalid-date suppression. Explicit designer links remain protected. This narrowly supersedes the broad “any number written with +” rule and must be called out in release notes.
- Exact delegated `Order ID08124731900` is already rejected. Canonical open finding is **`Order ID 0812 473 1900`** (`found-else.md:124` in the original investigation). Preserve these identifiers literally; do not pretend the compact token reproduces the bug.

## Recovery, current source and evidence

Loaded `figma-to-bricks` PLANNER, its rules-summary, `systematic-debugging`, and `feature-dispatch`; read the original durable plan first, then only relevant rules/code/ledger/HANDOFF/tests. CLAUDE Start here remains stale at `.12`; actual main source is `.21`. Merged `.19` card-link and `.20` pill/layout semantics are the preservation baseline, not authority to rewrite them.

**Stopped state verified:** branch clean, sole feature commit `e303c56` changes one test and records; `contacts.ts` has no feature diff. Its ledger records original proposal 5 selected recognition/integration passes + 40 existing passes, then 3 downstream preservation failures; source was restored, not released. Its full check/browser/corpus success qualifies only test groundwork. No feature BUILD, merge, production fix or live-paste verification exists.

**New durable evidence:** `/Users/justin/.hermes/plans/figma-to-bricks/evidence/phone-recognition-guards/revise/`.
- `observe-loader.mjs`: diagnostic only. Maps stopped-suite source imports to current main `.21` and, **only in memory**, can load the exact archived, previously rejected contacts proposal. No source is patched or copied into either repository.
- `main21-consumers-green.log`: committed 7-case preservation suite **7 pass, 0 fail** on current `.21` source.
- `main21-proposal-consumers-red.log`: same `.21` source plus archived contacts proposal **4 pass, 3 fail**. Precise failures: new ID card link, new date card link, lost intended title at an equal ID tie. Not import/fixture errors.
- `main21-controls.log`: normalise contacts, B7 runs, convert contacts and `.19` card-link words tests **56 pass, 0 fail/skips**. This is a focused baseline, not a fresh full check/browser/corpus claim.
- `observe.mjs`, `main21-observations.json`, `proposal-observations.json` and corresponding logs: actual conversions of 16 structurally generic cases per source mode, plus raw label/recognition observations. No candidate policy fix is implemented or tested here.
- Original detailed RED/GREEN proposal, saved source/patch, snapshots/payloads, baseline/full restored gates remain under sibling `builder/`; original planner phone matrix/debug observations remain under `planner/`.

Tight, read-only reproducer (second command deliberately exits 1):

```sh
cd /Users/justin/Documents/FigmaToBricksV2
node --import /Users/justin/.hermes/plans/figma-to-bricks/evidence/phone-recognition-guards/revise/observe-loader.mjs --test .claude/worktrees/phone-recognition-guards/test/unit/phone-recognition-guards.test.ts
PHONE_PROPOSAL=1 node --import /Users/justin/.hermes/plans/figma-to-bricks/evidence/phone-recognition-guards/revise/observe-loader.mjs --test .claude/worktrees/phone-recognition-guards/test/unit/phone-recognition-guards.test.ts
```

These use real local source and generic snapshots, without network, Bricks/site access or repository writes. Mutable root debug is unchanged; original planner evidence says its working genuine-phone siblings, not ID/date failures, are present. Builder must refresh its build/root and replay a scratch copy on its actual resumed base.

### Concrete same-base findings

| Case | `.21` original | Archived guards in memory |
|---|---|---|
| No-caption eligible card | `/available-parts/` | identical destination/anchors |
| Real title + small spaced ID caption | card plain, no page address | whole card `/available-parts/` |
| Real title + small plus-date caption | card plain, no page address | whole card `/available-parts/` |
| Equal-size/bold ID and real title | `titleIn` returns real title | `titleIn` null (confirmed integration RED) |
| ID/date as sole short headline | no inferred title/page | invented ID/date destination (original builder probe) |
| `View ID 0812 473 1900` control | no inferred page | **new label-only `/id-0812-473-1900/`** |
| Explicit linked title + ID/date | `/pricing/` linked title, plain card | same intended title destination/plain card; false tel removed |
| Explicit linked pill + ID/date | `/pricing/` pill, plain card | same intended pill destination/plain card; false tel removed |
| Genuine `0812 473 1900` caption | card plain | card and complete anchor inventory identical |

Do not call entire anchor lists unchanged in ID/date explicit-link fixtures: the intended change removes their false telephone anchor. The intended designer target and surrounding plain-card boundary are the invariants.

## Root cause and complete direct-consumer trace

Ranked hypotheses tested: (1) removing contact links unmasks whole-card inference — **confirmed**; (2) rejected text becomes a competing title — **confirmed**; (3) title exclusion alone fixes navigation — **falsified** by the small-caption whole-card case and newly observed label-only destination. B7/emission inventing the number was already falsified upstream: `contactsIn` admits it.

1. **Admission:** `normalise/contacts.ts:9–12,23–30` accepts broad PLUS/ZERO forms, checks digit count/sample, then returns `Found`. No ID-context/date guard. PHONE sees whitespace before the spaced ID, not its preceding meaning; attached ID is already boundary-rejected.
2. **Order:** `normalise/normalise.ts:261–264`: designer label promotion → contact linking → page inference. Contacts create real run links; their removal is not semantically neutral.
3. **Target veto:** `normalise/page-links.ts:46,264–270` forbids links inside the inferred target. Removing the false dial anchor lets a still-valid real title link its whole card. A title-only guard cannot retain that boundary.
4. **Title exclusion:** `normalise/card-title.ts:30–35,52,65–66` excludes `contactsIn(s)` and rejects equal prominent titles. A new rejection makes ID/date text eligible; it can invent a name or tie away the real one. Existing `s` collapses whitespace before recognition — a shared policy must inspect original text **before collapsing logical line breaks**, so `ID\n<number>` is not silently treated as approved same-line ID.
5. **Independent label route:** `normalise/page-words.ts:32–46`, `page-links.ts:188–201` can derive a destination directly from action words without `titleIn`. Actual `View ID …` emits `/id-…/` after rejection. `View +2026.10.21` and `Take me to ID …` are label-recognition controls too. Guarding only titles is insufficient; guarding only whole painted cards misses label-only guesses. Do not block every `pageAddress()` call: that would also affect explicitly linked frames.
6. **Contact consumers:** `normalise/contact-links.ts:57–62` builds shown contacts/captions; `:71` excludes contact-bearing nearby captions; `:102–115` selects button targets; `:174` projects link runs. Only accepted contacts may provide automatic dial sources. Removing a reject intentionally changes false-source selection; true-phone selection/caption controls need explicit tests because nearby-caption eligibility also changes. No selection/range/protection rewrite authorized here.
7. **Style:** `style/phone-numbers.ts:9–12,17–27` reads accepted contacts for wrappers, preserving UTF-16/B7 intervals. Rejected data loses automatic wrapper; genuine controls retain it. No style source edits.
8. **Address:** `normalise/address.ts:24–30` strips accepted contacts before address inference. Rejected data now remains; test map destination/no invented address and valid adjacent address controls. No address-policy edits authorized.

These are all direct production `contactsIn` callers found by source search. `page-words` is an additional indirect-policy consumer needed for the newly reproduced named-label path, not a claim it currently calls `contactsIn`.

## Recommended minimal general seam (proposal, not implementation)

**One scanner, distinct decisions.** Keep grammar, digit-count/sample admission, UTF-16 boundaries and email handling intact. At the existing candidate-admission seam, classify each otherwise admissible phone-shaped match as accepted phone or rejected **marked-ID / valid-plus-date**. Reject reasons/ranges must be available without manufacturing a dial href for rejected data. Preserve the public `contactsIn(s): Found[]` API for accepted contacts/emails; factor a small shared classifier or expose a rejected-candidate projection from that same scan inside `contacts.ts`. No second copy of PHONE/date/ID matching in another file; no mutable global mode, fake contact, dummy link, sentinel href, SceneNode flag or extra emit pass needed.

Consumers ask different questions:
- `contactsIn(raw)`: is this eligible for automatic dial/style/address contact handling?
- rejected-candidate projection on **raw text**: does approved non-contact data disqualify this *inferred* name or encompassing inferred target?

Use the rejected projection narrowly:
1. `card-title.nameLike`: rejected text is ineligible as a name, alongside existing accepted-contact exclusions. Preserve prominence/tie rules and original text; do not strip the rejected token and invent a title from the remainder.
2. `page-words.labelWords`: before whitespace flattening/GO extraction, reject a label containing the same rejected data, so direct label guesses and `ctx.naming` agree with title policy. Ordinary unrelated labels still work; keep `pageAddress`, designer frame resolution and existing GO/ACTION dictionaries unchanged.
3. `page-links.allowed`: veto an **inferred target's own existing descendant text scope** when it contains a rejected candidate. Use the existing target traversal; do not redefine `linked`, mark rejected nodes as real links, scan unrelated ancestor siblings, change `free()` globally, or disable inference throughout the page. A small caption must preserve its card's plain boundary even when the real title remains eligible. An independent `View services` target that contains no rejected data remains allowed; explicit links bypass this inference-only policy and are not removed.

This is the smallest supported complete seam: contact-only failed; title-only misses target and named-label paths; target-only can hide a wrong `titleIn` result or bad `ctx.naming` classification. Four bounded source owners make the policy explicit instead of duplicating the original false-positive recognition as a “legacy phone” API. No original PHONE grammar widening or catch-all identifier/date blacklist.

## Touches, tests and conflicts — proposed approval boundary

**Production allowlist, P3A only:**
- `src/core/normalise/contacts.ts`: single candidate classification + approved P1/P2 filter; preserve `Found` API/offsets.
- `src/core/normalise/card-title.ts`: raw-text rejected-candidate title exclusion only; no ranking/prominence change.
- `src/core/normalise/page-words.ts`: rejected-candidate inferred-label exclusion only; no vocabulary/slug change.
- `src/core/normalise/page-links.ts`: inferred target containment veto only; no designer/provenance promotion or scope expansion.

**Test edit allowlist:**
- Existing committed `test/unit/phone-recognition-guards.test.ts`: retain all seven tests/assertions and the no-caption positive; add approved recognition and generic downstream matrix. It currently asserts the outcome we must preserve, not obsolete behavior.
- New `test/unit/phone-candidate-policy.test.ts` if useful for classifier reasons/raw offsets/one-scanner contract. No shared fixture change necessary; local builders suffice.
- Existing `test/unit/convert-card-link-words.test.ts` **additions only** if title/pill controls are clearer there; preserve all old assertions, especially lines56–63 (linked title stays words; zero native enclosing links), lines20–24/27–53 (plain card/whole pill), and independent-link safeguards in related suites. Prefer keeping feature-specific variations in the owned feature test.

**Read-only regressions:** `normalise-contacts.test.ts`, `normalise-contact-runs.test.ts`, `convert-contacts.test.ts`, `style-text-breaks.test.ts`, `convert-page-links.test.ts`, `convert-text-links.test.ts`, `normalise-maps.test.ts`, `convert-maps.test.ts`; browser `text-link-followups.test.ts`, `text-breaks.test.ts`, and card-link browser proof/helpers. Existing PHONE positive offsets/strings, B7 full-href styled-slice/protected-candidate behavior, frame anchor indices and no-enclosing-link assertions cannot be weakened.

**Not authorized:** source `contact-links.ts`, `address.ts`, `label-links.ts`, `links.ts`, `scene.ts`, style/adapt/emit/UI/site modules or test/browser helpers; dependencies; network/site writes; new Bricks keys; main/worktree cleanup. A verified additional caption/address regression needing these files must stop with exact RED, not silently extend scope. During this PLANNER task **all repository files remain read-only**, including tests and records.

**Parallel coordination:** `.19 card-link-words` is merged and its copy gone; explicitly review this semantic extension against its title-only/pill/plain-card provenance contract. `.20 pill-clip` and `.21 Google ranges` are merged, not queued dependencies: resume on their base and retain them. Current other copies are hero-photo-blend (paint/compositor), list-panel-followups (UI/CSV), media-rename-collision (**site-media/site-pages reserved**), renderer-proof-hardening (browser/render helpers). They do not authorize sharing the proposed four normalise source files or test helpers. Parent must recheck live diffs/owners before build, stagger Chrome/performance gates, and serialize HANDOFF/build/CLAUDE through the merge lock. No need to wait for unrelated user paste/copyback checks.

## Bounded implementation and acceptance — 12 tasks, after P3A approval

1. **Freeze authority/base.** Record P3A and exact four-file/test ownership plus Opus routing. Inspect stopped `e303c56`, current main/build, clean state and active ownership; reuse the existing feature branch without reset/loss. It has a feature commit, so do not assume the empty-branch ff recipe applies. Integrate current main in the feature worktree by the project's normal permitted history workflow, retaining the test/records commit; only finisher handles main/merge/BUILD.
2. **Save true before state.** Copy approved plan to feature docs; establish check and complete corpus baseline on the resumed same base. Preserve full report, payloads/full HTML, fonts/findings, original logs and mutable-debug scratch replay before overwrite. Save initial contact ranges, hrefs, title/label results, target boundaries and PageAddress inventories. Historical .19 restored evidence is not a .21 baseline.
3. **Classifier TDD.** Restore/adapt archived recognition tests as tests first (do not blindly apply the old source patch). Cover varied ID case/colon/hash/horizontal spacing, word boundaries, same-line versus CR/LF/U+2028/U+2029 and separate nodes, styled cuts/UTF-16; valid dot/hyphen/leap/century dates, trailing punctuation, longer last groups, invalid calendar/mixed/space shapes. Fix years, not system clock. Preserve exact compact-ID negative, ordinary Phone/order prose, same-digit regrouping, international/NANP/dotted phones, email/sample/serial negatives. Prove admitted rejects have reasons/ranges but no exposed dial Found; later genuine candidates survive.
4. **RED at all inference paths.** Keep original seven consumer tests; add equal date tie, ID/date-only headline with real body, small caption plus valid title, `View ID …`, `View +date`, `Take me to ID …`, no-caption and same-number genuine positive twins. Separate section heading is mandatory; a lone-section card/two-text field-shaped fixture is not proof. Assert title, label, whole-card link, native/inline hrefs, complete PageAddress list, payload validity and repeat determinism. Show exact RED before source changes.
5. **Implement only the shared classification/admission seam.** One raw candidate scan, two projections; accepted API/dial strings/emails and original digit/sample policy unchanged. Run focused recognition GREEN; consumer cases should still demonstrate why title/label/target work is required. No duplicate patterns, fake links or new IR metadata.
6. **Implement inferred eligibility, one consumer at a time.** Title exclusion, raw label eligibility, then target-containment veto from the same rejected projection. Retain generic no-caption inference and independent valid named-label behavior. Preserve normalise pipeline order; do not link a fallback remainder of rejected text. Run the complete focused matrix GREEN.
7. **Designer-link and scope boundary matrix.** Typed URL/frame-linked title-only words with ID/date captions; plain/arrow/styled pills; own/ancestor links; independent descendant absolute/hidden/run links as existing `.19` safeguards; unrelated sibling card and unrelated valid named label stay eligible. Explicit designer-linked rejected text itself remains linked as designed. Verify only false automatic tel/wrapper/address entries disappear, not existing intended destinations; no nested anchors, consistent run indices/relink/remove/notes.
8. **All remaining consumers.** Test Call no-true-number warning/plain state and mixed true-number selection; own/nearest/by-name/main/hidden controls; genuine range/style/B7 phone grouping and exact offsets. Test nearby-caption eligibility, same-line mixed data+real number, address/map-only and adjacent real-address cases. A source requirement outside the four owners is a real stop with minimal RED and scope recommendation, not silent policy or test change. No claim of unchanged true-phone selection merely from contactsIn unit tests.
9. **Mutation and differential proof.** With source committed, revert each policy piece only in the feature worktree and verify its intended regression turns RED: ID, date, title eligibility, label eligibility, target containment. Restore immediately; never do this in main. Verify removing ID/date caption from the same fixture restores legitimate inference and changing it to a genuine number retains existing contact behavior. Preserve logs and exact tested commits.
10. **Final full gates and visual/link proof.** `npm run check`, separate `npm run test:browser`, `npm run corpus`; rerun B7 and `.19` card-link tests. Compare same-base payloads/full HTML and every finding/width/font set; preserve/non-comparably label font failures. Expected existing v1 corpus exit1 alone is not a regression/pass. Replay current mutable-debug scratch and compare ordinary phones/page/map effects. Use before/after text evidence for links; if removing false wrapper changes geometry, capture affected synthetic fixture and measure desktop +390/375/360/320. No padding/floor/width source change authorized.
11. **Fresh review then bounded finish.** Parent dispatches Opus xhigh review of exact merge-base diff, new P3 policy, original RED and mutations. Opus medium finisher verifies findings test-first, rebases onto then-current main and repeats check/browser/corpus before locked ff merge/build/push. New unapproved inference/selection fallback returns for decision; no clean-up of unrelated pending docs/evidence or ownership.
12. **Docs & records (final task).** Update copied `docs/plans/2026-10-21-phone-recognition-guards.md`; carry forward then finalize `docs/plans/2026-10-21-phone-recognition-guards-ledger.md` with stopped/revised/implemented provenance and durable verified evidence paths. Update `docs/HANDOFF.md` with P1/P2/P3 choices, full gates, limits and next free paste check. Finisher alone bumps BUILD/builds/merges/pushes and updates main CLAUDE “Start here”/“Where things stand”; new confirmed rule and skill rules-summary must distinguish accepted contacts from rejected non-navigational data, preserve `.19/.20`, and explain the narrow plus-rule exception. Respect any denied protected-write workflow. Close only actually implemented canonical findings in `found-else.md`; compact token remains “already rejected,” not a separate fixed finding. Paste owed after release: generic mixed rejected-data/real multi-style phone + title-only/pill fixtures; verify no false dial/Call/page/card destinations and retained designer/real-phone targets. Previously saved false links require re-convert/re-paste; no automatic site repair or global-class replacement claim.

## Current blockers, limitations and other findings

- **Release blocker remains P3 policy/file authorization**; original P1/P2 approval is insufficient. Parent owns the decision/dispatch; this planner does not start a builder.
- The proposed four-owner seam is source-backed and has a reproduced red-capable loop; it is **not implemented or proven GREEN**. New tests/full gates/mutations and final same-base debug/corpus proof remain builder work.
- Contact caption and map semantics are traced potential couplings, not newly verified independent production bugs; their fail-closed extension rule is explicit above.
- **Newly narrowed evidence:** label-only guessed-ID navigation is another manifestation of the *unreleased* guards' coupling, not a current shipping defect or an extra found-else ticket. No unrelated newly established bug, no live requests, no site mutation.
- Repo/main/worktree source, tests, commits, debug JSON and BUILD were not modified during revision. Only this durable plan and the `revise/` diagnostic evidence were written.

## Builder status — October 21, 2026 (P3A build)

Four-file seam implemented and GREEN on main .22 (`worktree-phone-recognition-guards` @ `9495238`; code `98b7196`). **STOPPED, not ready-for-review:** reproduced address/map regression needs `src/core/normalise/address.ts` (outside the allowlist): `withoutContacts` keeps rejected ID/date lines, so a live map query gains `, Order ID 0812 473 1900` / `, Updated +2026.10.21`. Recommended scope: one-line `address.ts` change cutting `rejectedIn` ranges too, plus the archived RED test. Also for the reviewer: Call-by-name caption tie change (`contact-links.ts:71` eligibility). Evidence: `evidence/phone-recognition-guards/p3-builder/`; ledger in the feature copy.


## Ownership clarification — address.ts (2026-10-21 ~20:20 EDT, dispatcher under Justin's autonomous preserve-existing-behaviour grant)

The P3 builder demonstrated a real regression (evidence/phone-recognition-guards/p3-builder/address-scope-red.test.ts + .log: fails 2 on the branch, passes 2 on main .22). A live map query now absorbs an ID or plus-date line (e.g. `, Order ID 0812 473 1900`).

Granted, narrowly:
1. `src/core/normalise/address.ts` may change ONLY so `withoutContacts` (or its equivalent) also strips the ranges the shared classifier REJECTS (ID/date ranges), exactly as main stripped them before. Goal: restore main's address/map output, not new address policy.
2. Promote the archived RED tests into the suite (unit + map integration), keep the adjacent real-address and address-only controls, and show RED then GREEN in the worktree.
3. Nothing else in address/map policy, contact-links.ts, label-links.ts, links.ts, scene.ts or style/adapt/emit/UI files. The Call-by-name caption tie shift stays as-is and is flagged for the reviewer, not redesigned.

## Builder status — P4 (October 21, 2026): READY FOR REVIEW

`address.ts` grant applied (`261b110`): `withoutContacts` also cuts `rejectedIn` ranges; promoted RED test
`test/unit/phone-guards-address.test.ts` (RED 3/3 on branch, GREEN on main .22 archive and fixed branch); 0/5,400
`addressIn` differences vs main .22. check 1870+6, browser 187/187, corpus pastes/HTML/full reports identical to .22
baseline (same 17 v1), debug replay identical. Call-by-name tie flagged for the reviewer. Evidence `p4-builder/`.
