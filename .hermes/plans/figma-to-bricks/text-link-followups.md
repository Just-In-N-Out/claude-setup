# Text and link follow-ups (B7: text-link-followups)

**Approved by Justin 2026-10-21** (N1A).

**Plan for Justin's approval — not built.** Written 2026-10-21 against main **`aa19bae`, build `2026-10-21.7`**. **Build only after BOTH `text-breaks` (B3) and `link-upload-fixes` (B2) merge.** Their current worktrees were read only; they are evidence of the intended seams, not an approved merged baseline.

Loaded **`figma-to-bricks` (PLANNER)** and **`systematic-debugging`** first, then the rules summary, relevant CLAUDE.md sections, project memory, HANDOFF, the call-links/frame-text-links records, and both predecessor plans. No worktree, branch, application edit, build, commit or site change was made. Only this plan and temporary investigative evidence were written.

## Open questions

Written as if ⭐ is chosen. Phones, hours and keyboard behaviour follow existing user decisions; this is the only new display choice.

**N1. Several different words link to the same page. How should the panel name them?**
- **A ⭐ One note per address, naming all different labels.**
- B A separate note for each different label.

A keeps the panel shorter and keeps its existing address counts. Do not silently omit later labels. Identical labels need not be printed repeatedly. This changes the names shown, not destinations or which pages match.

## Request played back

1. If a designer makes half a phone number bold or another colour, all of that number should still dial the same complete number.
2. Keep the line between two opening-hours entries. A long hours entry is not a paragraph to join up on phones.
3. When several links share an address, name all their different words in the panel, not just the first one.
4. Tab should visit a marquee's original links once, never the invisible loop copies — including links inside a text's HTML.

No upload, redirect, font, card-sizing or marquee-recognition redesign. General rules only, never a branch keyed to Justin's layer names, IDs, wording, colours or dimensions.

## Evidence and tight feedback loop

Investigative scripts and JSON (temporary, not production fixes):
- `/Users/justin/.hermes/cache/scratch/text-link-followups-planner/probe.mjs`
- `/Users/justin/.hermes/cache/scratch/text-link-followups-planner/evidence.json`
- `/Users/justin/.hermes/cache/scratch/text-link-followups-planner/predecessors.mjs`
- `/Users/justin/.hermes/cache/scratch/text-link-followups-planner/predecessors.json`

Run the first with `node /Users/justin/.hermes/cache/scratch/text-link-followups-planner/probe.mjs`. **On planning main it deliberately exits 1: five symptom assertions fail; the single-run phone control passes.** It imports the real normalise/convert/site-note code, and uses the actual renderer plus system Chrome for hours and keyboard traversal. The second script reads the in-flight predecessors and adds an element-link collector probe. Refresh these tests in permanent fixtures; scratch evidence is pruned and cannot be the regression suite.

Existing tight suite run on untouched main:

```sh
node --test test/unit/normalise-contacts.test.ts test/unit/adapt-breaks.test.ts test/unit/ui-site-pages.test.ts test/unit/convert-marquee.test.ts
```

**57 passed, zero failed.** They miss the new cases; one hours assertion actively expects the fault.

Ranked hypotheses checked before proposing changes: (1) telephone matching is run-contained despite whole-text recognition; (2) hours lack a semantic guard before rag classification; (3) address aggregation loses later labels before the panel can print them; (4) marquee focus suppression reaches outer links but not rich-text anchors. The source boundaries and probes confirm all four. These are four real small fixes; none is a stale already-fixed report on main or the inspected predecessor tips.

The user's mutable root debug JSON was read, never edited: **build `2026-10-20.6`, `Hydraulic Cylinder Repairs Final`**, not Services. Its three phone-bearing text layers each have one styled segment; there are no text hyperlinks. It supplies working single-run siblings, not a reproduction of cross-run phones or shared frame-link labels. Generic fixtures therefore carry those regressions; do not claim this file exercises them. None of B7's reports is a newly reported live-site failure needing site-state diagnosis; no authenticated access or site mutation is authorised.

## Item 1 — A phone number crossing styled runs is not dialable

### Root cause

`src/core/normalise/contact-links.ts:165–185` finds contacts in the joined text, then `:175` accepts a match only if its entire `[start,end)` lies in one run. A style boundary inside the number therefore discards it from every run. Detection itself works (`normalise/contacts.ts:23–36`).

Probe: plain `Contact (812) ` plus bold `473-1900 today` produces one recognised `tel:8124731900` range, but both runs retain `link:null`. Main emits `Contact (812) <strong>473-1900 today</strong>`. An otherwise identical single-run number links correctly.

B3's current typography/phone grouping emits a shared `phone-number` wrapper around this number, retaining bold type, **but still no anchor**. Its visual grouping is not a link-creation fix.

### Fix

- Keep recognition in `contactsIn`; use its UTF-16 offsets, not a second telephone regex.
- Replace the whole-run containment limitation for telephone candidates with range intersection: split every intersected run at contact boundaries and link exactly its number slice to the **complete** candidate href. Preserve every run's font, colour, spacing, casing and other metadata, all non-number words, and exact character order.
- Keep the existing **one anchor per linked run** contract. All styled pieces of one number dial the same full number; do not coalesce anchors and accidentally shift `PageAddress.runs[].at`. B3 still owns the single visual no-break unit. A one-Tab-stop/coalesced-anchor redesign is outside this small batch.
- Designer links win. If any portion of a proposed telephone candidate overlaps an existing run link, leave that candidate's automatic linking alone as a whole; do not auto-link just its unlinked suffix to a competing destination. An unrelated designer link elsewhere must not prevent a clean number linking.
- Preserve linked-parent, linked-button, form-field/placeholder and hidden-content policy. Do not change telephone recognition, nearest-button selection or contact priority. Retain existing email behaviour; do not silently turn this into a contact-detection expansion.

### Test first

New focused `test/unit/normalise-contact-runs.test.ts` and conversion cases: two/three style runs; split at punctuation, digit and whitespace; two numbers; recognised international format; UTF-16 prefix; leading/trailing prose; exact boundary and empty-run controls. Check all number slices' full hrefs and style metadata, no empty runs, byte-identical repeat conversion and unchanged characters. Preserve existing in-run email controls.

Negative twins: a partially or wholly designer-linked number (URL and frame origin), an unrelated linked phrase, linked parent/button, placeholder and serial/date. The normalise regression must fail before the fix. In the final rendered payload, assert no nested anchors and every number fragment's href, not merely that some `tel:` appears.

After B3 merges, rerun its glyph-line/overflow tests: a number fitting a full line stays together; a box narrower than the number retains the approved emergency wrap, including closing punctuation. Also place a frame link **after** the split phone and an unrelated typed link in the same text: site relinking/removal must still target the correct anchor, with typed links untouched. Do not assume an old hard-coded anchor index remains valid after new normalised runs.

## Item 2 — Long opening-hours entries lose their separator

### Root cause

Main `src/core/style/rag.ts:18–27` judges rag breaks by line length and terminal punctuation, not whether each line is a separate schedule entry. Long hours can meet both length thresholds. `softBreaks`' prose guard at `:51–63` stops permanent joining, but `adapt/rules/breaks.ts:14–16` still hides their `<br>` below the design width.

`test/unit/adapt-breaks.test.ts:81–90` explicitly expects that hiding rule for its long-hours fixture. This contradicts the existing rule in CLAUDE.md: opening hours keep their typed separators. B3 is fixing addresses and intentionally leaves this hours half unchanged; its current `bodyBreaks` guard excludes addresses only.

The real renderer confirms the long two-line hours fixture's `<br>` is **`display:none` at 390 and 768**, with a **300px actual text box**, and inline at 1440. This is not a guess from Figma's frame width. A DOM-only separator restoration was checked and pictured (`hours-dom-separator-390.png`): both entries remain readable, no clipping. It is feasibility evidence, not an implemented after picture; restored separators also change shrink-to-fit width, so final geometry still needs testing.

### Fix

- Add a small pure opening-hours/line-item recogniser, expected `src/core/normalise/opening-hours.ts`, used by the **merged B3** shared eligibility guard in `style/rag.ts`. Reject recognised schedule items before **both** permanent softening and narrow-screen rag hiding.
- Recognise schedule structure, not this fixture's words: multiple nonblank entries, each beginning with a weekday/day-group heading and a time range or a closed/by-appointment entry. Support full/abbreviated English days, common day-range separators and 12/24-hour clock ranges, including punctuation in abbreviated days. Follow the project's existing English lexical-recognition convention; no localisation/NLP expansion.
- Require evidence on each item line. A passing mention of Monday or a clock time in ordinary prose is not a schedule. Unrecognised text keeps the existing conservative classification; do not make all colon-bearing or digit-bearing paragraphs hard-break items.
- Retain the `<br>` at every width. Each entry may still wrap inside its real box. No `nowrap` around the hours as a whole, font shrinking, extra floors, or new breakpoint policy. Existing desktop typed-line behaviour and B3's address/prose policies remain intact.

### Test first

Split/correct only the hours expectation left after B3's address correction. Add direct recogniser cases plus payload tests: long two-line hours formerly eligible as a rag; abbreviated days with periods; closed/appointment entry; CRLF/U+2028; known and unknown ink; fixed and hug text. Negative controls: flowing prose mentioning a weekday/time, address, heading, blank-line paragraphs and B3's mixed-sentence prose.

Browser regression at **390, 478, 768 and 1440**, using actual emitted box widths: preserved visible separator, second entry cannot join the first entry's last visual line, internal wrapping permitted, no horizontal overflow or clipped text. Include a width where the old joined text actually packs the next heading onto the preceding line — a `<br>` count alone is not the visual test. Keep design-width line geometry stable and record any necessary intrinsic-width change instead of claiming pixel identity without measurement.

## Item 3 — Shared-address notes name only the first label

### Root cause

`src/core/emit/page-addresses.ts:20–25` stores one `PageAddress` per URL and keeps the first `words` value, while `:37–38` and `:49–54` keep adding later element IDs/run positions. Thus the labels are already lost **before** `ui/site-pages.ts:155–188` reads `m.link.words`. Changing only the formatter cannot recover them.

The existing frame-text fixture yields two links, `our pricing` and `the plans`, one address and two run positions. Its missing-page note names only `our pricing`. A separate pure collector probe with two element links gives two IDs but only `Pricing details`, losing `See plans`. B2's inspected notes retain this problem while correctly changing the repair/missing-page wording.

### Fix (N1A)

- Extend `PageAddress` in `src/core/understand/page-links.ts` with optional label-list metadata (for example `labels?: string[]`), keeping existing `words`, `name`, `from`, `ids`, `runs` and matching semantics compatible.
- Collect all distinct nonblank visible labels in first-seen order in `emit/page-addresses.ts` for **both** element and text-run links. Keep the current first-label fallback when no list is present. Avoid an unnecessary list field for a single-label address if that preserves existing metadata shape.
- Format each address's labels together in the existing note, e.g. `"our pricing", "the plans": …`. Repeated identical labels appear once; no silent truncation. Continue to count **addresses**, not all label occurrences, and make no extra site requests.
- Apply that subject formatter consistently to all B2 note paths: missing/unpublished/ambiguous/kept, media-blocked, address changed, verified media move and old-paste warnings. Do not restore B2's false redirect/repair promises or change media counters deduplicated by media ID.
- Do not change page matching, canonical-name selection or relink targets. Typed URLs and the front page remain excluded from the site-check collector. Offline inferred-link notes are not this item's target; preserve their current behaviour rather than widening the change silently.

### Test first

New `test/unit/ui-link-labels.test.ts` plus collector/integration cases: two different text phrases; two element labels; a mixed element/text group; same label repeated; two separate addresses; legacy single-label input; unusual characters/quotes. Assert label order and coverage, one address/one lookup, original IDs/run positions, unchanged summary counts and correct final hrefs.

Exercise all final B2 note categories, especially blocked and changed-address warnings. Run conversion through match/relink/notes, not a formatter-only manufactured object: the regression must catch labels disappearing in the collector. Confirm plain words after media-link removal preserve styling and all affected labels are named.

## Item 4 — Marquee loop-copy HTML links remain reachable by Tab

### Root cause

`src/core/emit/elements.ts:45–46` correctly identifies descendants of copied rounds. However, `marqueeAttributes` at `:30–36` adds `tabindex=-1` only where **`ir.link`** exists. Inline anchors live in `st.html`, copied into `settings.text` at `:74`; the outer text has no `ir.link`.

This is reachable through normal conversion, not only a synthetic impossible IR: a generic words ticker with an inline URL passes today's recogniser (`understand/marquee.ts:47–49` checks the outer link/contact, not run links). It emits an original plus **three loop copies**, all with a focusable inline anchor. Real Chrome Tab order: marquee pause box → original anchor → **three `aria-hidden` copies' anchors** → body. Existing unit tests cover outer linked logos only. Do not fix this by changing which rows count as marquees.

### Fix

- Use emit's existing `copied` descendant set to remove **sequential Tab access** from inline anchors in copied text HTML, while leaving the original round unchanged. Keep existing outer-link attributes and `aria-hidden` rounds.
- Prefer a small pure helper, expected `src/core/emit/text-links.ts`, called only when copied text HTML is assigned in `emit/elements.ts`. It operates on the converter's controlled generated anchor markup, adds/sets `tabindex="-1"` exactly once, and preserves href, escaping, text, nested styling/phone wrappers and anchor count/order.
- This is a generated-HTML attribute operation, not CSS rewriting or a DOM dependency in core. Do not parse Figma's raw text as HTML, import a panel helper into core, remove links, add scripts, introduce unverified Bricks controls, or use new `inert` behaviour. Do not suppress all text links globally.
- Panel relinking must retain the tabindex attribute, including a changed href; removing a blocked frame link still unwraps it cleanly. Existing `ui/text-links.ts` preserves other attributes when changing hrefs; prove the full path.

### Test first

Extend `test/unit/convert-marquee.test.ts` and `test/browser/marquee.test.ts` with a real recognised ticker holding inline typed/frame links, multiple anchors and styled text. A focused helper test should cover existing tabindex, idempotence and escaped literal `<a>` words. Original anchors remain keyboard-reachable; every copied anchor is `-1`; hrefs, visible words and anchor indices remain the same.

Use **actual `page.press("Tab")`**, not only attribute assertions: focus enters the pause box, visits original anchors, then a sentinel after the ticker, never an `aria-hidden` descendant. While focused on the box/original link, animation is paused; movement resumes when focus leaves. Repeat at 390/1440 and with reduced motion; retain linked-logo and ordinary-text controls. No marquee speed, direction, geometry or mouse/touch change is intended.

## Tasks — builder, after approval and both merges

1. **Refresh and baseline.** Re-read actual main/BUILD/HANDOFF and the merged B2/B3 diffs; confirm their real merge commits are ancestors of main. If an item is already fixed by their review passes, prove it and close it accurately rather than implementing again. Create B7's worktree only now, follow the project skill, copy the approved plan, start `.superpowers/sdd/text-link-followups/progress.md`. Run baseline `npm run check`, browser suite and corpus, saving report and each baseline paste. Record known failures, not just exit codes. Preserve the user's debug file read only; replay a scratch copy.
2. **RED → GREEN: cross-run phone links.** Permanent generic range tests first; change only normalise's contact-run projection. Keep B3 grouping and the one-anchor-per-run contract. Prove the frame-link-after-phone integration and existing email/designer-link guards. Commit when green.
3. **RED → GREEN: hours separators.** Before source changes for this visual item, capture `npm run snap -- <generic-hours-debug> <shots/before> 390 478 768 1440 --sides`; include a deterministic narrow-box browser fixture. Add schedule/negative tests, then the shared B3 eligibility guard. Re-run B3 prose/address tests, measure actual output, capture matching after pictures; commit.
4. **RED → GREEN: all shared-address labels.** Collector-through-panel tests first; optional metadata and label formatter only. Retain B2's final destination/repair/cancel/guard semantics. Commit.
5. **RED → GREEN: marquee inline Tab suppression.** Real conversion + keyboard traversal first; small controlled-markup helper in emit, no style-orchestrator edits. Re-run page-address/index/relink and outer-logo focus cases. Commit.
6. **Full verification/evidence.** Run the focused new tests plus `npm run check`, `npm run test:browser`, `npm run corpus` and the user's read-only debug replay. No collision, invalid payload, nondeterministic ID or file/width regression. Compare baseline/final corpus pastes, per-width lint and worse-than-v1 identities; account for known moving-marquee score noise with byte comparisons and measured elements rather than relaxing the gate. Preserve B3's 478/479 phone wrap proof and B2's production payload guard. If the known three stale panel tests still fail on the starting main, name them; never report all-green falsely.
7. **Review handoff.** Return hours before/after section pictures under `/Users/justin/.hermes/plans/figma-to-bricks/shots/text-link-followups/` (390 plus desktop, additional width where wrapping changes). For nonvisual items provide text proof: each number piece → full href; each address → all labels and unchanged counts; original/copy Tab sequence. Prove new tests red without their respective fixes, or with narrow verified mutations. Builder stops **ready-for-review**, committed but unmerged. Fresh Sol reviewer, then a separate finisher's test-first fix pass and rebased gates.
8. **Docs & records** — final task below.

## Files and pipeline parts touched

Expected application edits:
- **Normalise:** `src/core/normalise/contact-links.ts`; new small `src/core/normalise/opening-hours.ts` pure recogniser. Existing `contacts.ts`, `text.ts`, `scene.ts` and address recognition stay read-only.
- **Style:** `src/core/style/rag.ts`, extending B3's shared guard only. No second phone grouper, no typography/class/orchestrator rewrite.
- **Understand metadata:** `src/core/understand/page-links.ts`, optional `PageAddress` labels, no layout/IR transformation.
- **Emit:** `src/core/emit/page-addresses.ts`, `src/core/emit/elements.ts`, new `src/core/emit/text-links.ts`.
- **Panel:** `src/ui/site-pages.ts`, label formatter only, on top of B2.
- **Adapt:** existing `src/core/adapt/rules/breaks.ts` inherits the eligibility result; no planned behavioural edit. Update its explanation only if the final merged comment would otherwise be false. All breakpoint CSS still originates in adapt/rules.

Focused tests: new `test/unit/normalise-contact-runs.test.ts`, `test/unit/opening-hours.test.ts`, `test/unit/ui-link-labels.test.ts`, `test/unit/emit-text-links.test.ts`; edit `test/unit/adapt-breaks.test.ts`, `test/unit/convert-marquee.test.ts`, `test/browser/marquee.test.ts`; add `test/fixtures/text-link-followups.ts` and `test/browser/text-link-followups.test.ts`. Reuse existing builders/text-link/marquee fixtures without growing them unnecessarily. Single-purpose files near 300 lines; do not expand `style/style.ts` (already 356 lines on planning main).

No extract change, network write path, site migration, schema change to Snapshot/Run, Bricks element/key, new CSS class, font rule, CTA/card layout, renderer or snap-tool change is planned.

## Overlaps and what changes after the predecessors land

**B3 text-breaks — hard prerequisite:**
- Direct shared edit: **`src/core/style/rag.ts`**, **`test/unit/adapt-breaks.test.ts`**; possible comment-only **`src/core/adapt/rules/breaks.ts`**. Add hours to B3's final shared body eligibility guard; do not copy main's old guard over its address/prose corrections.
- Shared contracts read/retain, **not edited by this plan**: **`src/core/style/typography.ts`**, **`src/core/style/phone-numbers.ts`**, **`src/core/style/classes.ts`**, **`src/core/style/style.ts`**; **`test/unit/convert-contacts.test.ts`**, **`test/unit/style-phone-numbers.test.ts`**, **`test/unit/style-text-breaks.test.ts`**, **`test/fixtures/text-breaks.ts`**, **`test/browser/text-breaks.test.ts`**. Its grouped HTML must accept new sliced contact anchors without losing visual grouping, punctuation or frame-anchor positions. Final review may move the seam; re-read, don't edit that active worktree.

**B2 link-upload-fixes — hard prerequisite:**
- Direct shared edit: **`src/ui/site-pages.ts`**. Any existing test assertion adjusted because it expects the old subject shares **`test/unit/ui-site-pages.test.ts`**; prefer new label tests so its new repair cases remain intact.
- Shared integration contracts read/retain, **not edited by this plan**: **`src/ui/site-read.ts`**, **`src/ui/site-media.ts`**, **`src/ui/wordpress.ts`**, **`src/ui/run.ts`**, **`src/core/normalise/links.ts`**, **`src/core/emit/payload.ts`**, **`src/core/convert.ts`**; **`test/unit/convert-text-links.test.ts`**, **`test/unit/ui-link-destinations.test.ts`**, **`test/unit/payload.test.ts`** and B2's site-read/media/run tests. B2 changes Match/Held states, honest notes, guarded output and rename/cancel policy. Use its final states/categories and preserve media-ID count deduplication; never restore today's misleading notes to add labels.

**Other work:**
- **frame-text-links (merged .5):** shared contracts `understand/page-links.ts`, `emit/page-addresses.ts`, `ui/site-pages.ts`; preserve `runs[].at` and typed-URL exclusion. `ui/text-links.ts` remains read-only and must retain new tabindex attributes.
- **cta-label-wrap (in review), pill-clip, layout-floors (queued):** no planned shared application file. Do not fix a tight phone box by editing adapt/layout, least, label, unpin or sizing. Their merges can change widths; measure and baseline on final starting main.
- **test-cleanup (queued):** no planned production overlap because B7 avoids `style/style.ts` and `tools/snap.ts`; its tools are used read-only. Avoid `test/browser/panel.test.ts`/shared panel stand-ins. If it changes Chrome/render helpers or moves tests, rebase onto its actual interfaces; do not audit stand-ins here.
- **fonts-cleanup/equal-card-fixes (merged):** include them in the new baseline; do not re-fix them. Fonts affect geometry, so compare the same font state before/after.
- **Every batch's shared records:** `docs/HANDOFF.md`, `src/shared/build.ts` (finisher only), main untracked `CLAUDE.md`, the skill rules summary and `/Users/justin/.hermes/plans/figma-to-bricks/found-else.md`. Preserve other sections, allocate the next free paste check at merge and use the merge lock. Plan/ledger files for B7 are unique.

## Risks and boundaries

- Intersecting a phone range with several styles must not dial a partial number or steal a designer's link. Keep candidate-level overlap protection and UTF-16 tests. One-anchor-per-run means a multiply styled number can have multiple keyboard stops, as existing styled links do; one semantic anchor would be a separately scoped anchor-index change, not silently bundled here.
- Hours recognition must not freeze normal prose that merely mentions a weekday/time. Keep a narrow schedule grammar with negative twins; unknown languages/formats are not newly promised. Do not drop B3's measured prose/address protection.
- A retained separator can change intrinsic text/card height. Compare real boxes at all affected widths, not only HTML strings or a fixture's Figma width; preserve equal-card/layout behaviour.
- Label lists can make one note longer. N1A prefers completeness over hiding labels; counts and matching remain address-based. No loss of B2's honest repair wording or request/cancel policy is acceptable.
- Controlled-HTML changes must not touch escaped literal tags, split anchors or change indexing. Original links stay accessible and Tab continues pausing the ticker. `_attributes`' existing Bricks round-trip check remains owed; generated render output is not proof Bricks preserved it after paste.
- The predecessors are still moving. Their inspected outputs are not a combined tested build. Refresh after both merges; drop already-fixed work with evidence and stop/split if the final seam requires a larger anchor or site architecture change.

## Docs & records (final task)

- Copy the approved plan to `docs/plans/2026-10-21-text-link-followups.md` (use actual build-start date if later). Move the finished ledger to `docs/plans/<dated-plan>-ledger.md`, retaining baseline, RED/GREEN, actual-width measurements, keyboard sequence, review/fix pass and exact gate results.
- Update `docs/HANDOFF.md` with all four outcomes, N1's answer, remaining limitations and the **next free paste check owed**. Do not reserve a number during planning.
- Paste check, one action at a time: reload plugin; Convert/copy the affected design; paste into Bricks and save; regenerate code signatures if the page contains Code elements; LiteSpeed → Purge All. Check a genuinely multi-style phone number (all pieces dial the complete number), visible opening-hours separators at narrow widths, all shared-link labels in the Convert notes, and keyboard focus skipping copied ticker anchors while originals/pause still work. The existing Repairs debug file alone cannot prove the new style/link cases: use a small generic Figma fixture or a real design containing them. Ask Justin to reply *pasted* + page name for the read-only checker; no site writes by agents.
- Finisher alone performs the locked merge, bumps `src/shared/build.ts` to the next actual BUILD, rebuilds dist and pushes main. Update main CLAUDE.md **Start here** and **Where things stand** after merge, and the skill rules summary where a rule changes. If a protected write is denied, follow the pending-edits procedure; do not route around it.
- Record the general rules: telephone range linking survives style boundaries without overriding designer links; recognised hours keep separators in both reflow paths; site-check notes preserve all labels for an address; loop-copy inline anchors are not sequential Tab stops. Preserve B3's phone fallback and B2's repair/no-write policies explicitly.
- Re-read `/Users/justin/.hermes/plans/figma-to-bricks/found-else.md` at merge and mark **each of the four B7 entries**, and only those entries, as `~~item~~ ✅ fixed in build <BUILD> (text-link-followups)`. If a predecessor already fixed an item, use its real build/provenance instead of claiming B7 did it. Leave other batches' entries intact. Never stage CLAUDE.md, screenshots or the user's debug JSON.

## Other things found

No additional out-of-scope bug confirmed. The ticker recogniser's handling of run-linked words explains why item 4 is reachable; changing recognition is not part of this fix. Known stale panel tests, corpus animation noise and style-orchestrator size already have owners and are not new B7 fixes.

## Dispatcher ownership clarification (2026-10-21, after phone task)

Narrow exception: B7 may update ONLY the cross-styled-run case in `test/unit/style-phone-numbers.test.ts` (old lines 29–33). That assertion encoded the old lack of cross-run dial links, directly contradicting the approved B7 fix. Replace the obsolete no-anchor expectation with stronger checks: every number slice links to the full telephone, the one visual phone wrapper and punctuation remain intact, styles and exact characters remain unchanged, and no nested anchors. Keep all other B3 guards/tests intact. No other source/file scope expansion is authorized. This is alignment with the approved feature, not permission to weaken tests.

## Justin's answers (2026-10-21)
- N1A (⭐). Builds after text-breaks AND link-upload-fixes merge.
