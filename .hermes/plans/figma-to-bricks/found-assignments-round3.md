# Found-item assignments — round 3 (2026-10-21)

User authorization: '...all the new bugs ... associate each model with the bug ... send out an agent whether ... Opus5.5 medium or ChatGPT6.1 Sol ... Start sending out agents ...'. Start planners now; builders only within approved bounded bug scope, new decisions presented to Justin. Existing found-else.md remains canonical open/fixed evidence; this file deduplicates ownership, not a second closure ledger. Exclude all struck-through fixed rows. Model/effort set per area, no duplicate source ownership. Re-evaluate findings against latest main; old line numbers are clues, not proof.

## A. renderer-proof-hardening — small, Sol6.1 high
Own: pdf reviewer FE1 render.ts synthesizes noopener ignoring native rel; FE2 linked-image tabindex attrs on image instead of anchor; photo-hover clipping assertion compares frame rect and misses missing overflow; external-stylesheet fontStatus false negative; busy-Chrome showcase zoom test flake investigate only if same helpers.
Expected: test/browser/render.ts, showcase browser tests, fontStatus/capture helper. Test-only fidelity corrections, not production Bricks changes. Use explicit expected requested-family set (without inventing loaded status) if needed; keep honest prior reports. Do not update corpus widths in parallel. Plan root cause per item and bounded negative regressions. Never relax perf/tolerances or claim renderer equals actual Bricks.

## B. media-rename-collision — small/tricky, Sol6.1 xhigh
Own: LINK-RENAME-COLLISION ui/site-media.ts moves owned media onto another protected href and fails to re-index. Offline saved reviewer probes; preserve active-run cancellation, inline read-only, own-cache IDs, exact-ID readback, serial writes, file/id unchanged, all protected destinations safe. No live WordPress writes. src/ui/site-media.ts + focused new isolated tests; request coordination if site-pages/run edits necessary.

## C. phone-recognition-guards — small, Sol6.1 high
Own: normalise/contacts.ts accepts Order ID08124731900 and +2026.10.21. Narrow false-positive guards only, no new locale/NLP/dial policy; preserve real international/formatting styles and B7 cross-run links. New negative twins + valid positive controls. Do not touch label-links.ts (card task) or typography/pdf code. If distinguishing identifier/phone is ambiguous, return explicit policy question rather than silently suppressing genuine phones.

## D. list-panel-followups — in-between, Opus5.5 medium; reviewer Opusxhigh
Own: leftover CSV columns overwrite non-PDF action labels; list minor issues (empty name, two lists desktop+phone frames, status after Remove, no large CSV warning, TSV support); csv PDF deferred no Cancel during long PDF upload and connection refresh requires reconvert; ui/main.ts581lines structural debt within touched wiring. Deduplicate already fixed issues on actual .16+.
Plan batch boundaries carefully: bug corrections can proceed; new TSV capability/multi-list policy/auto-reconnect/major main.ts split may need separate approval/sequence. Do not implement new features as if mere test fixes. No live uploads. Preserve .16 row-data-vs-action safety and .18 PDF new-tab. Prefer small focused list files, keep main wiring narrow; if refactoring main necessary propose staged no-output-change extraction not entire rewrite. Existing no-op CSV output and PDF cache permissions preserved.

## E. google-font-range-policy — in-between, Opus5.5 medium; reviewer Opusxhigh
Own: returned CSS range100900 can reach paste despite no-range rule; descriptor hardening .13 explicitly deferred. Need coherent emitted CSS + supplied metadata, subsets and exact Figma weights, no regex CSS rewrite, no silent usable-face loss, no new requests/substitution. Synthetic reproduction not live observed response. Planner must resolve supported safe approach and any preservation-vs-transform choice with Justin before builder. Keep duplicate-loader stage2 HELD for live proof; do not remove either loader under this scope.

## Existing owners — DO NOT spawn competing builders
- pill-clip (Solxhigh current builder): laptop/992 clipping, GRO Let's talk/04/Contact/Lifestyle cuts, small-phone min floors, wrapping row least-width overcount, uneven alike pill padding/F3, button-floor ceil, CTA279px wider than248px row. Investigate only same-area safe changes; wider grid/ALONE policy not implicitly approved.
- hero-photo-blend (Solxhigh H1B planner): independent multiple shadows and corrected single-shadow mapping. Pale fringe separate source/AVIF diagnostic, NO duplicate picture/media agent; needs original Figma export to distinguish compression vs source.
- card-link-words (Solxhigh current finisher): linked-pills/title/no-whole-card rules and stale corresponding documentation; don't reintroduce old whole-card decision from ledger wording.

## Held/shared-layout work — Opus5.5 medium after pill-clip, no parallel builder
- inspo Industries strip + Selected-work offscreen/carousel/silhouette overlap (multiple ledger lines same area), twoShare tablet tile shrink, row reflow desktop-only guard (not yet reproduced).
- ALONE/rowCentred: user policy keeps alike cards side by side; ask explicit change approval, don't reverse it under bug cleanup.
- Global corpus375/360/320 coverage: Solhigh tooling batch later after renderer-proof-hardening, baseline existing failures explicitly; don't turn existing narrow-width regressions into silently relaxed pass.
- F7 drawn-input/button ambiguity and F9 shared whitespace classes: decision/refactor deferred; same adapt/label owner as pill-clip. Not independent quick fixes.

## Non-code / records (no implementation agent)
- Header template weight600 and debug re-export require Justin; old export lacks current text links/remanufactured design.
- Global classes already pasted require Bricks replace-class import/re-paste; no auto site writes.
- Missing external-link sample: pdf-new-tab archived official schema2.4.3 but installed2.3.9 copy-back still owed; verify existing reference before requesting duplicate.
- Malformed reference/bricks/card-row-and-phone-slider.json offset6157: reference integrity followup, not regenerate guessed content; verify original source/sample and ask if unrecoverable.
- CLAUDE.md pending content must be applied in a permitted session; no protected-write bypass. Current main may advance while work runs.

## Execution
Start A/B/C on Sol and D/E on Opus, planners only (can inspect read-only in parallel). Each returns plan + concrete file ownership. Shared renderer-vs-global-width helper changes serialize; list/main vs media/site changes coordinate if discovered. General fixes, TDD, independent fresh review, merge lock, truthful complete corpus/baseline evidence. Docs-only shared HANDOFF/build edits serialized by finishers. Main dispatcher checks actual branch diffs before builder starts; planners drop duplicates/fixed reports. No claimant says 'all fixed' until exact found rows verified closed after merge.
