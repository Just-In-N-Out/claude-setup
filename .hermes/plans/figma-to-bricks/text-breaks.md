# Text breaks: keep phone numbers together and let prose wrap cleanly (B3)

**Approved by Justin 2026-10-21** (answers T1A T2A, all ⭐).

Planner only, 2026-10-21. **Three live bugs; the fourth item is already fixed.** No worktree, branch, application-code edit, build or commit made.

Loaded `figma-to-bricks` (PLANNER), its rules summary and the relevant CLAUDE.md sections, and `systematic-debugging` first. Read the early-line-breaks plan and ledger (`docs/plans/2026-10-21-early-line-breaks*.md`, build .2), HANDOFF, and project memory. Investigated main `f3d6ed8`, **build 2026-10-21.4** (`src/shared/build.ts:2`); CLAUDE.md's headline still says .2. The builder must start **after frame-text-links merges**, then take a fresh baseline.

## Open questions

Plan written with the ⭐ choices; these are proposals for approval, not new user rulings.

1. A paragraph can happen to end a sentence at one of Figma's normal wraps. Should that stop the whole paragraph reflowing?
   - **A ⭐ Reflow proven prose, even at a sentence end.**
   - B Keep all breaks if any line ends a sentence.
   - C Change this only below the design width.
   - Recommended A extends L1A's existing fixed-width-wrap policy, not a blanket removal of typed breaks. Keep headings, addresses, blank-line paragraphs and one-sentence-per-line items; require the existing wrap evidence at every break. Hug-width text keeps L2A.
2. What if a phone number is wider than its entire box?
   - **A ⭐ Keep it whole if it fits; otherwise allow a wrap.**
   - B Never split it, even if it spills out.
   - C Shrink the number's font until it fits.
   - Recommended A: never change the font or widen the layout. This is a real edge case: at 479px the homepage's held three-card row gives this text only **101px**. At 478px it has 384px and the number can move intact to the next line.

## Request played back

1. A phone number should move together to the next line, rather than leaving its area code behind.
2. Reviews and other flowing paragraphs should not keep desktop line breaks that create a long line followed by a short fragment on phones.
3. An address's street/city break is deliberate. Keep it instead of joining the city onto the street on narrower screens.
4. Check the report about rules reading replaced source words. Do not rebuild a fix already in main.

## Evidence and reproduction

Read-only probes used the real `convert` → `renderPage` → system-Chrome renderer, not a Figma-width approximation. Only scratch evidence was written, under `~/.hermes/cache/scratch/text-breaks-planner/`:

- `measurements.json`: real box widths, rendered lines, `<br>` display and phone links at 390/452/478/479/768/1440/1728 (address also checked through 990–1440).
- `before-phone-478.png` and `before-quote-390.png`: inspected; both show the reported faults.
- `root-cause-checks.json`: three explicit assertions fail on main: the Gary quote should go soft; the address should not be a rag; the address should get no hiding rule.
- `hypothesis-followups.json`: DOM-only experiments confirmed the proposed capped phone unit plus closing punctuation stays together at 478 and has no overflow/orphan period in the 101px box at 479; the quote's five lines at its real 430px design-width box are unchanged when the breaks are hidden; restoring the address separator at 390 keeps `Fort Collins` off the street line. These are feasibility probes, not implemented fixes.
- `candidate-audit.json`: a read-only eligibility probe over all **five corpus designs plus the user's Repairs and inspo debug files**. Allowing a sentence boundary only inside otherwise proven wrapped prose adds **just the Gary quote** to today's soft-paragraph candidates. This is a scope check, not proof of a completed fix.
- `node --test test/unit/adapt-breaks.test.ts`: **13 passed**. Existing tests miss the quote and explicitly bless the address's narrow-screen hiding rule. The replaced-word regression already passes.

Files actually used: `corpus/files/hydraulics-home.json`; corpus-configured Services `/Users/justin/Desktop/figmaplugin/figma-to-bricks-debug-page-1.json`; corpus-configured address `/Users/justin/Desktop/figmaplugin/figma-to-bricks-debug-design.json`. The repository-root `figma-to-bricks-debug-page-1.json` is **Repairs**, not Services, and was read only. Do not substitute it for the Services reproduction.

Hypotheses checked, in likelihood order: missing atomic phone treatment; an over-strict prose classifier; semantic address protection applied only to permanent softening; a stale report about replaced words. Each was checked at the source/payload boundary, then in the renderer where visible. No production fix was trialled.

## Item 1 — Phone numbers split across lines

### Root cause

- Phone recognition already exists: `src/core/normalise/contacts.ts:23–36`; `normalise/contact-links.ts:165–185` gives a number wholly inside one run a `tel:` link.
- `src/core/style/typography.ts:63–85` serialises runs and links but gives the number no atomic wrapping behaviour. An ordinary inline `<a>` permits a wrap at its space and hyphen. Protecting all telephone *buttons* or the whole paragraph would address the wrong unit.
- Current homepage text (`506:1545`, emitted `gdntxb`) at **478px**: a **384px** box renders `…night at (800)` / `457-3160.`. Its link is correctly `tel:8004573160`; it is one link spread across two lines. At 452px today it does not split: the source report's triggering width shifted with phone-side-padding.
- A temporary DOM-only atomic-unit experiment moved the complete number to the next line at 478px without changing the paragraph's height. At 479px the complete number does not fit its 101px box, so a strict no-wrap would need overflow or an unrelated card-layout change.

### Fix

- Treat the **recognised phone-number range**, not its link or the full sentence, as one inline visual unit. Reuse `contactsIn()` and its UTF-16 offsets; do not add a second phone regex or change contact/link policy.
- A focused style helper computes phone ranges across the joined styled runs. Text HTML groups each range while retaining the original run styling and existing anchors. It must work even if the enclosing text/card is already linked, and must never add nested anchors.
- Use one purpose-named parent behaviour class (for example `text-phone-numbers`) with an inline marker (`phone-number`) and descendant-part CSS. Register/attach the parent class through existing style/class machinery so emit retains it; an unattached global class would be discarded by `emit/elements.ts:120–122`.
- For choice 2A, make the unit an inline block with max-content width capped at its parent's width; permit normal/emergency internal wrapping only when the **whole** unit exceeds that width. Do not merely use a shrink-to-fit inline block, which can split in the leftover space on the current line. No font shrinking, fixed px width, extra layout floor or breakpoint needed.
- Keep immediately adjoining closing punctuation with the visual unit, without putting that punctuation into the telephone href. A probe with the number alone exposed an orphan period in the 101px box: the regression must cover that.
- Leave the source words and dialled number unchanged. Do not broaden telephone detection or fix cross-run *link creation* in this batch (see Other things found).

### Test first

New generic fixtures and focused unit/browser tests: number in running prose, two numbers, international format already recognised by `contactsIn`, number across differently coloured/bold runs, explicit run link, enclosing card link, and no-number/email-only controls. Assert exact words/styles/hrefs, valid non-nested anchors, no phone wrapper on unrelated words, and deterministic payload.

In Chrome, constrain a paragraph so the number fits the complete line but not the remainder: **all phone glyphs must have one line Y**, while surrounding prose can wrap. Also test a box narrower than the number: emergency wrapping is allowed but no horizontal overflow or isolated closing punctuation. Counting an inline block's `getClientRects()` is insufficient: it can report one rect while its contents wrap. Verify per-character ranges. Check 478/479 on the real homepage too.

## Item 2 — Typed prose breaks make long/short pairs on phones

### Root cause

- `style/rag.ts:16–21` rejects the **whole text** if *any* non-final typed line ends in `. ! ? :`. `ragBreaks` uses that result at lines 25–28; `softBreaks` depends on it at lines 60–63.
- Gary's quote (`528:4312`) is a fixed auto-height box, 430px wide, 16px body type. Its second typed line ends `customers.`. That one punctuation mark makes `ragBreaks=false`, so neither early-line-breaks' permanent softening nor the narrow-screen `text.breaks` rule applies.
- The working adjacent reviews (`528:4289`, `528:4335`) have the same fixed-box/body pattern but no sentence-ending typed boundary; both go soft. Every Gary break passes the existing ink/next-word wrap proof: spare letters are approximately −0.21, −1.21, −2.21 and −5.21. There is no room to have kept that next word on the preceding line.
- At **390px** the actual box is **296px**: main renders **10 lines**, with short `ton of companies`, `of work for these`, `go with another` fragments. Temporarily hiding only this quote's four `<br>` nodes produces **8 flowing lines**, height 255.94 → 204.75px. At its 1728px design width the box really is 430px and main has five lines.

### Fix

- Separate **fixed-width prose that provably copies wrap** from the legacy hug-width rag test. A sentence ending within otherwise flowing prose is not enough to reject all its breaks.
- For fixed-width softening, retain the existing body-size/heading guard, no blank-line paragraphs, minimum/relative line-length checks, known ink measurement, and the exact `copiesWrap` letter-slack boundaries. Allow an isolated sentence-ending boundary when all breaks meet that wrap proof; reject one-sentence-per-line item sets (including closing quote/bracket punctuation) and recognised addresses. Do not soften on a punctuation-only or unknown-metrics guess.
- Keep L1A: eligible fixed-width prose writes spaces at **every width**, not a new phone-only override. Keep L2A and designer breaks: the existing hug-width behaviour stays; a fixed box with a demonstrably deliberate break still keeps it. Do not just delete the sentence guard globally from `ragBreaks`.
- The resulting `softBreaks` decision still drives both HTML and `typedLines` handling in `style/style.ts:190–204`; a softened paragraph must never acquire the old from-design `white-space: nowrap` hold.

### Test first

A generic paragraph with one sentence-ending typed boundary among several mid-sentence wraps must go soft; an otherwise identical one-sentence-per-line list must keep its breaks. Negative twins: address with an abbreviation, heading at body size, blank line, unknown ink, wide box/designer break, and existing letter-slack boundary cases. Include a styled-run boundary around the break, CRLF and Figma line separators, retaining whitespace/escaping behaviour.

Browser test at the paragraph's real narrowed width: compare it with a space-joined reference, not just a `<br>` count. At design width, line geometry must remain the same within font-rendering tolerance. Replay the Services quote and its two working siblings at 390/478/479/768/1440/1728; retain early-line-breaks' homepage and inspo designer-break proofs.

## Item 3 — A two-line address is treated as a rag

### Root cause

- Early-line-breaks F2 added the prose guard **only to `softBreaks`** (`style/rag.ts:51–63`). It prevents permanent loss of an address's break but does not protect it from `ragBreaks` → `text.breaks` below the design width.
- The real address (`I646:9344;319:2430`) has a U+2028 street/city break; it is a 292px fixed-width box, 20px type, no heading. On current main `ragBreaks=true`, `softBreaks=false`. `adapt/rules/breaks.ts:14–16` emits `br { display:none }` through max-width 1727px.
- At **390px** in the normal snap-style renderer (Mont unavailable; fallback font), its 292px box reads `2133 S Timberline Rd, Suite 100 Fort` / `Collins, CO 80525`. At **768px**, the 124.19px box reads `…Suite 100 Fort` / `Collins, CO…`. This confirms the reported street/city merge. Font stand-ins change the exact wrapping but cannot make hiding a deliberate separator correct.
- `normalise/address.ts:59–66` already recognises these words as an address. Reuse that pure recogniser; do not guess from the layer name, comma count alone, or a specific city/postcode.
- `test/unit/adapt-breaks.test.ts:81–90` explicitly expects both the long address and hours fixture to get the hiding rule. That is why the 13 existing tests pass despite this bug.

### Fix

Exclude recognised addresses from **both** permanent softening and narrow-screen rag-break hiding. Preserve their `<br>` at every width; each address line may still wrap normally within its available box. Do not make the whole address, city or postcode unbreakable, or shrink the type.

Keep this item limited to addresses. The analogous long-hours case is listed below rather than silently added to B3. Split the existing combined hours/address test: address expectations change; unrelated hours behaviour does not.

### Test first

Generic long two-line address that meets the old rag thresholds: `<br>` remains and no `br {display:none}` rule is emitted. Include a street abbreviation containing a period, U+2028/CRLF, and another address format supported by `addressIn`; preserve ordinary prose reflow as a negative control. Do not broaden the address recogniser itself.

In a deterministic browser fixture, assert the city cannot join the street's final visual line, even though either address line may wrap internally. Replay corpus design at 390/768/990/1024/1440/1728; inspect the separator and lines, recording the Mont fallback rather than claiming exact custom-font fidelity.

## Item 4 — `text.breaks` reads replaced IR source words: already fixed

**Drop the implementation task.** Main already contains early-line-breaks commit **`4d39693`**, shipped in **build 2026-10-21.2**.

- `adapt/rules/breaks.ts:14` requires `n.words === null`. A copy whose displayed words were replaced does not inherit its source layer's break rule.
- `adapt-breaks.test.ts:116–123` specifically checks FAQ answer placeholders get no rule while the open answer still does; this test passed in the 13-test run.
- Preserve that guard/test throughout B3; add no new IR schema, emitted-HTML parser or breakpoint logic for this stale report. If rebasing changes the seam, re-run it. Correct the found-items record at merge with the **actual .2 provenance**, not a claim that B3 newly fixed it.

## Tasks (builder, only after approval and frame-text-links merge)

1. **Baseline and pictures, before source changes.** Create the text-breaks worktree using the project skill; refresh context and inspect frame-text-links' merged diff, especially `textHtml`. Run the existing unit loop and baseline `npm run corpus`; save report and each `corpus/out/v2/*/bricks.json`. Run `npm run snap -- <file> <shots/before> <widths> --sides` for homepage, Services and design using the actual paths above. Copy the user's mutable debug file to scratch before replaying it. Keep a ledger in `.superpowers/sdd/text-breaks/progress.md`.
2. **RED → GREEN: phone-number visual units.** Add a focused generic fixture and new unit/browser tests; prove the fit-but-not-remainder case fails on baseline. Implement only recognition-range grouping, shared class wiring and the agreed narrow-box fallback. Re-run link/HTML tests from frame-text-links; commit when green.
3. **RED → GREEN: wrapped prose with mixed sentence boundaries.** Add the generic failing mixed-prose test and item/designer-break controls. Separate fixed-width proof from legacy rag eligibility without weakening ink/slack guards. Verify existing L1A/L2A/typed-line/whitespace regressions and real siblings; commit.
4. **RED → GREEN: address separator.** Add the failing long-address classification and browser test; reuse `addressIn`, preserve its separator in both paths. Correct only the address half of the old combined test. Re-run FAQ replaced-word regression and commit.
5. **Full verification and pictures.** `npm run check`, `npm run test:browser`, `npm run corpus`; rerun exact regressions and capture `shots/after` with the same inputs, options and fonts. Assert no collisions, stable IDs and byte-identical repeat conversion. Compare each corpus paste/changed element and every width's lint against this worktree's saved baseline; no new worse-than-v1 item or file/width regression. Do not treat the known corpus exit 1 as a new failure. Investigate score movement against byte-identical pastes and known animation noise. Do not claim all-green if the known panel tests remain red; name them if they also fail on the starting main.
6. **Evidence for review.** Prove each new test red without its own production fix (or a targeted mutation for a guard) and green with it. Return before/after crops under `~/.hermes/plans/figma-to-bricks/shots/text-breaks/`: phone 478 and narrow 479, Services review 390 and 1728, address 390 and 768, plus unchanged homepage/inspo checks. Assert glyph line positions, links and overflow, not just snapshots. Stop at ready-for-review, committed and unmerged; a separate reviewer/finisher owns review and merge.
7. **Docs & records** — final task below.

## Files and pipeline parts touched

Planned application edits:
- `src/core/style/typography.ts` — range-aware phone HTML; preserve merged frame-text link markup.
- New `src/core/style/phone-numbers.ts` — small pure range/grouping helper, existing `contactsIn` reused.
- `src/core/style/classes.ts` — shared phone-text behaviour/part CSS.
- `src/core/style/style.ts` — minimal behaviour registration/attachment; existing soft/typed decision wiring only. It is already 356 lines: no unrelated refactor; coordinate test-cleanup's picture split.
- `src/core/style/rag.ts` — fixed-width prose eligibility and address guards.
- `src/core/adapt/rules/breaks.ts` — keep replaced-word guard; adjust the comment/decision only if needed to match the now-protected addresses. All breakpoint writes remain here; style must not write new media CSS.

Tests: new `test/fixtures/text-breaks.ts`, `test/unit/style-phone-numbers.test.ts`, `test/unit/style-text-breaks.test.ts`, `test/browser/text-breaks.test.ts`; edit the address expectations in `test/unit/adapt-breaks.test.ts`. Prefer these focused files over growing `style.test.ts`.

Pipeline: **style + existing adapt text-break rule**, with existing normalise recognisers read-only. No extraction/schema/IR/normalise mutation, WordPress/UI/network write, emit-key change, card-sizing rule, `adapt/layout.ts`, `adapt/rules/unpin.ts`, `style/sizing.ts` or `tools/snap.ts` change is planned.

## Overlaps / order

- **frame-text-links: hard dependency.** Shared **`src/core/style/typography.ts` / `textHtml`**. Build B3 only after it merges; preserve its markers/attributes, escaping and rewritten/removed anchor behaviour. We read but do not edit its `normalise/text.ts`, `normalise/page-links.ts`, scene run types, `emit/page-addresses.ts`, `ui/site-read.ts`, `ui/site-pages.ts`. If implementation needs any of those, stop and name the new overlap rather than quietly expanding scope.
- **test-cleanup:** definite shared **`src/core/style/style.ts`** (its picture-code extraction versus our text-class wiring). Also its snapshot work changes **`tools/snap.ts`**, which B3 uses but does not edit. Coordinate/rebase; no second split. Its fixtures/browser helpers remain read-only here.
- **fonts-cleanup:** its currently written plan is UI font files; **no planned shared application/test file** with B3. Font results can change visual line metrics: baseline and compare on the same merged code/font state, not screenshots from two different font states.
- **link-upload-fixes:** B2 can run beside B3 after frame-text-links. **No planned shared application file**: B3 does not edit site UI, upload code or `emit/payload.ts`.
- **cta-label-wrap:** no shared planned application files (`adapt/layout.ts`, `adapt/least.ts`, `adapt/rules/unpin.ts`, `label.ts`, `index.ts` are outside B3). Do not fix the 479px row by changing its sizing.
- **equal-card-fixes:** its known fixes are in card layout/style helpers; **`src/core/style/style.ts` is a possible shared wiring file** if its eventual plan uses it. Recheck its completed plan before dispatch; do not assume separate hunks mean no coordination.
- **layout-floors:** no planned shared application file (`adapt/layout.ts` / `unpin.ts` are read-only here); it follows B4. Real narrow boxes in its work are why B3 needs the approved emergency-wrap fallback.
- **Every batch shares records:** **`docs/HANDOFF.md`, `src/shared/build.ts` (finisher only), the main untracked `CLAUDE.md` (finisher only), and `~/.hermes/plans/figma-to-bricks/found-else.md`**. Keep all sections/entries, allocate the next free paste-check number at merge, and use the merge lock. B3's own plan/ledger filenames are unique.

## Risks

- A designer's deliberate sentence boundary can resemble a wrap. Require all the existing measured wrap evidence, preserve item sets/blank lines/headings/addresses, and keep the generous-box and inspo regressions. Do not infer intent from prose text or layer names.
- Phone grouping must preserve text/HTML/run and frame-link boundaries. Test cross-run styled numbers, existing links and enclosing links before accepting a string-only implementation.
- An unbreakable number cannot fit a box narrower than itself. Choice 2A is an explicit overflow-safe fallback, not a promise that impossible layouts never split; the 479px case must remain in the acceptance evidence.
- Renderer fonts are not the live site's Theme Style or uploaded fonts. Saira loaded for the phone/review reproductions; Mont was unavailable for the address. Record fallback use and complete the live paste check after the relevant font fixes. No site mutation is authorised by this plan.
- Source state is moving. Take the real build/commit and gates after frame-text-links, not the stale CLAUDE.md headline or this planning baseline. Test-cleanup and B4 may share the style orchestrator.

## Docs & records (final task)

- Copy this approved plan to `docs/plans/2026-10-21-text-breaks.md`; move the finished ledger to `docs/plans/2026-10-21-text-breaks-ledger.md`.
- Update `docs/HANDOFF.md` with decisions, exact verification results, remaining known failures and the **next free paste check** (do not reserve a number now).
- Paste check: reload plugin → Convert and copy the affected page → paste into Bricks and save → LiteSpeed Purge All. If that page already contains Code elements, regenerate Bricks code signatures as usual before checking it; B3 introduces no new Code element. Check homepage phone number at 478, its dial link and 479 overflow fallback; Services quote at 390 and desktop; the address's street/city separator at narrow widths. The user replies *pasted* + page name for read-only live checking.
- The finisher alone bumps `BUILD`, rebuilds dist, merges/pushes and updates main `CLAUDE.md` **Start here** and **Where things stand**. Correct its stale build headline while doing so; follow the protected-file pending-edit procedure if blocked.
- Record the approved general rules: proven wrap breaks in fixed-width flowing prose can go soft even at an isolated sentence end; addresses keep typed separators; telephone visual units move together when they fit, with the agreed too-narrow fallback. Preserve L1A/L2A and the existing replaced-word guard explicitly.
- At merge, mark each of the three live entries in `~/.hermes/plans/figma-to-bricks/found-else.md` as `~~item~~ ✅ fixed in build <BUILD> (text-breaks)`. Mark the fourth accurately as `~~item~~ ✅ fixed in build 2026-10-21.2 (early-line-breaks; verified by text-breaks)`; it is a stale-record correction, not a fourth new fix. Re-read the file first so concurrent planners' entries survive.

## Other things found

- **Medium — a phone number split across styled runs gets no automatic dial link.** `normalise/contact-links.ts:175` only links a match wholly contained in one run. Read-only generic probe `Contact (812) ` + bold `473-1900 today` emitted `Contact (812) <strong>473-1900 today</strong>` with no `<a>`. B3 must group the number visually without silently taking on link creation; track that separately.
- **Low — long two-line opening hours can also lose their deliberate separator below design width.** `adapt-breaks.test.ts:81–90` uses a long two-line hours string and explicitly expects the hiding rule. This is the same legacy rag heuristic, but this batch's listed item is the address: leave the hours baseline alone and offer a separate line-item follow-up rather than changing extra content unnoticed.
- **Low, records — CLAUDE.md's headline build is stale.** `CLAUDE.md:7` says 2026-10-21.2; `src/shared/build.ts:2` and git HEAD show 2026-10-21.4. No protected instructions were edited by the planner; finisher updates the records at merge.

## Justin's answers (2026-10-21)
- T1A T2A (all ⭐). Builds after frame-text-links merges.
