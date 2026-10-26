# Early line breaks in card text (planner, main at build 2026-10-20.15)

**Approved by Justin 2026-10-21** (answers L1A L2A).

## Open questions
1. When should a typed break that only copies Figma's own wrap be dropped?
   - A ⭐ Always, in fixed-width text boxes (the browser wraps it alone)
   - B Keep the break only while the text box is as wide as Figma's (container query)
   - C Leave as is (break holds at the design screen width)
2. Text boxes that hug their text (Figma "auto width"), where the breaks set the width?
   - A ⭐ Keep today's rule (break holds from the design width up)
   - B Treat them like fixed-width boxes too

## Request played back
1. In the hydraulics home Info cards (row of three under the logo marquee), text breaks too early: "…hurry? Give" / "us a call…" and "…Atlas Copco in" / "stock…".
2. Find why, with evidence; fix by general logic so text wraps like Figma at Figma's width and reflows at every other width.

## Root cause (confirmed)
- The break is really in Figma's text: `corpus/files/hydraulics-home.json` characters are `"…in a hurry? Give\nus a call anytime…"` and `"…Atlas Copco in\nstock ready…"`. Both boxes are `textAutoResize: HEIGHT`, `layoutSizingHorizontal: FILL`, 432.67 px wide, 50 px tall = 2 lines. So in Figma the `\n` sits exactly where the line would wrap anyway: a rag break left by the website import. Figma looks fine.
- `src/core/style/typography.ts:63` turns every `\n` into `<br>` (emitted: `"…hurry? Give <br>us a call…"` in `corpus/out/v2/hydraulics/bricks.json`).
- `src/core/adapt/rules/breaks.ts` (`text.breaks`) correctly sees these as rag breaks, but hides the `<br>` only `@media (max-width: 1727px)` (design width 1728). It keys on the **screen** width, not the **text box** width. At 1728 the Bricks card text is about 365 px wide (screenshot `shots/equal-card-heights/after-info-cards-1728.png`) vs Figma's 432 px, because the page sits in the 1440 container with gutters. So the browser wraps "Give" early, then the kept `<br>` forces a second break → short line.
- Same cause can hit any fixed-width text whose box is narrower in Bricks than in Figma at the design width (wider screens too, since the container caps at 1440).
- Corpus: texts with typed breaks — hydraulics-home 30 (HEIGHT, NONE and WIDTH_AND_HEIGHT), gro-home 2. 24 of hydraulics' get the `br {display:none}` rule today.

## Approach
In `text.breaks`, when the text box has a fixed width in Figma (`textAutoResize` HEIGHT or NONE) and the breaks are rag breaks (existing `ragged()` test), emit no `<br>` at all for them (a space instead) at every width: the browser wraps at the box's real width, which equals Figma's wrap at Figma's width. Hug-width texts (WIDTH_AND_HEIGHT) keep today's behaviour, since their breaks define the width. Items, headings, blank-line paragraphs unchanged.
Because the rule must not edit HTML (typography owns the text), the clean way: understand/style passes a "soft breaks" flag the text HTML honours (break → space); `text.breaks` keeps the media rule only for hug texts. Builder checks whether `textAutoResize` reaches `src.text`; if not, add it in extract/normalise.

## Tasks
1. Test first: generic fixture — a fixed-width (HEIGHT) body text, 2 lines, rag `\n` mid-sentence, inside a card narrower than the box in Bricks → expect no `<br>` in the text and no `br` media rule; a WIDTH_AND_HEIGHT twin keeps `<br>` + the `(max-width: W-1)` rule; an item list (hours) keeps its `<br>`.
2. Carry `textAutoResize` into the text data if missing (extract/normalise + snapshot schema).
3. Soft-break flag in the text HTML (`src/core/style/typography.ts`), set from the same rag test (move `ragged()` to a shared helper so rule and style agree).
4. `src/core/adapt/rules/breaks.ts`: skip fixed-width rag texts (already soft), keep hug texts.
5. `npm run check`, `npm run test:browser`, `npm run corpus` before/after; cmp pastes, no file worse.
6. Docs & records (below).

## Tests
Generic fixture as Task 1, plus a rule test that `text.breaks` no longer fires on fixed-width rag text. No names, texts, IDs or pixel values.

## Pictures (builder)
`npm run snap -- corpus/files/hydraulics-home.json <out> --sides`; section: Info cards (row under the logo marquee); widths 1728, 1440, 390. Also the FAQ intro ("Straight answers…", a hug text) at 1728 to show it unchanged. Save to `~/.hermes/plans/figma-to-bricks/shots/early-line-breaks/`.

## Choices (as recommended)
1A, 2A.

## Risks
- Font metrics differ slightly from Figma: at exactly Figma's width a line might wrap one word differently. Acceptable vs a forced short line.
- A designer's deliberate mid-sentence break in a fixed box would be lost; the `ragged()` test (lines fill ≥60 % of the longest, no sentence end) limits this.
- Corpus scores may move slightly in hydraulics.

## Pipeline parts touched
extract/normalise (maybe `textAutoResize`), style (`src/core/style/typography.ts`), adapt (`src/core/adapt/rules/breaks.ts`), tests.

## Overlaps
- test-cleanup splits `src/core/style/style.ts`: no direct clash (I touch typography.ts), but if the soft-break flag is wired through style.ts, build after it or rebase carefully.
- frame-text-links touches text links in `typography.ts` (`textHtml`): same function — build in sequence (after frame-text-links) or expect a small rebase.
- phone-side-padding (adapt/rules spacing): no clash.

## Docs & records
- Plan copied to `docs/plans/2026-10-21-early-line-breaks.md`; ledger to `docs/plans/2026-10-21-early-line-breaks-ledger.md`.
- `docs/HANDOFF.md` updated with the next free paste check after 3ab (renumber at merge if taken): paste hydraulics home, Info cards wrap with no short line at 1728 and 1440.
- `BUILD` bumped and main `CLAUDE.md` "Start here"/"Where things stand" updated by the finisher at merge; add a CLAUDE.md rule: "rag breaks in fixed-width text are soft (wrap by the box), not by screen width".

## Other things found
- None outside this plan.


## Justin's answers (2026-10-21)

1A: always drop breaks that only copy Figma's wrap, in fixed-width text boxes. 2A: hug-width text keeps today's rule. All recommended.
