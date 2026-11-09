# staging-fit-cancels: a website paste's per-range rules never cancel another rule (plan, 2026-11-09)

Job B of the staging-fit umbrella (`~/.hermes/plans/figma-to-bricks/staging-fit.md`). Planned against main `fd1986dc`
(Build 2026-11-09.3). **Order: third, built after `staging-fit-capture` merges** (rebase onto it; ideally after
`staging-fit-renderer` too, so its proofs draw Bricks' real selectors). Website importer rules: one real-bug review, edge
cases to follow-ups. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index `README.md`).

## Questions (⭐ = the standing auto-go's answer)

1. **How a narrower range drops a declaration a wider one set.** ⭐ **A:** never `revert`: each property's value goes in
   one block per run of ranges with that value, bounded by the run's own widths (`@media (min-width: …) and (max-width:
   …)`; the widest run unbounded above, the narrowest below), as the FAQ's open look already does
   (`src/core/site/elementor-accordion.ts` `lookCss`), so nothing cancels another rule. Website pastes change bytes, not
   looks; Figma conversions byte-identical. B: keep `revert`, only stop inline-element rules from cancelling.
2. **Bricks controls at tiers.** ⭐ **A:** a property stays a Bricks control only where its runs nest the way Bricks' tiers
   cascade (991 → 767 → 478); otherwise it goes to the class's custom CSS. B: keep today's control choice.

## Playback

On phones the hero buttons of Justin's staging paste lose their background and turn into blue link text, while the site
keeps them painted. The styleless tablet capture made the rule that does it (fixed by staging-fit-capture), but the
mechanism is general: the paste cancels a value with `revert`, which also cancels the element's own rules.

## Root cause (R2, proved)

- `blocksOf`/`blocksOfStates` (`src/core/site/blocks.ts:23-36`) write each narrower range as a block of what changed, a
  dropped declaration as `revert`.
- In the styleless tablet read the hero's button link was an inline word, so its wrapper's class got an inline-element
  rule `.home__protecting-your__inner-dwzn > :nth-child(1)` (`src/core/site/classes.ts:99-100`, `:130`) at `max-width:
  991px`; at `max-width: 767px` it writes `background-image: revert; color: revert; font-size: revert…` (0,2,0). That
  beats the link's own class `.home__protecting-your__inner-fisl` (0,1,0: gradient, `#fff`), and `revert` rolls back the
  whole author origin: the link gets the browser's link blue `rgb(0,0,238)` and no background, in the renderer
  (`probe2/probe3.json`) and on staging (`probe2/staging.json`).
- Counts in `whole.json` (`reverts.ts`): 7,392 `revert`s in the 991 blocks (the styleless capture), 132 in the 767 blocks
  (128 on `> :nth-child` rules), and **61 in correctly read ranges** (37 at 1024, 24 at 1366) plus a few at 921/834/600/
  576/393: cancels remain after a good capture. Any `revert` cancel also cancels a lower-specificity rule the paste
  writes for the same element (another class's inline rule, a state rule, an open look `.acc > .brx-open .cls`).

## Tasks

1. `blocks.ts`: replace "block of what changed + revert" with per-property runs bounded by min and max width (Q1 A);
   a range without the property gets nothing. Keep the widest run's block unbounded and first, so a class without
   per-range change prints byte for byte as before.
2. `controls.ts`: a control keeps its tier keys only where the runs nest as Bricks' tiers cascade (Q2 A).
3. `classes.ts` (`customCss`, inline-element rules, state rules) and `motion.ts` blocks use the same runs.
4. Re-run every site proof (site-code-proof, site-elementor-proof, site-page-proof, site-motion-proof and the B-Dry
   named-only ones) and the corpus; update HANDOFF (rulings Q1 A, Q2 A not yet confirmed), ledger.

## Acceptance criteria (all proposed)

- AC1 (proposed): generic fixture site: a link that is an inline word at 768–991 (`display: inline` there) and its own painted button at other widths; the paste drawn at 600 keeps the button's background and colour (computed style equals the site's); RED on main (`rgb(0,0,238)`, no background).
  Test: `test/web/site-range-cancels.test.ts` › "a narrower range never reverts another rule"
- AC2 (proposed): no website paste of the corpus captures or of the B-Dry capture (named-only) contains `revert` outside the `site-reset` class, over both routes (plain, `--elementor`), both picture modes and both text modes.
  Test: `test/unit/site-no-revert.test.ts` › "website pastes write no revert outside site-reset"
- AC3 (proposed): every existing site proof stays within its tolerance, Figma conversions are byte-identical (`npm run corpus`, replay), and website pastes change bytes only in classes where a range drops a declaration (HANDOFF says so, Q1 A).
  Test: `test/unit/site-no-revert.test.ts` › "classes without a dropped declaration print byte for byte as on main"

## Overlaps

- `staging-fit-capture`: must merge first (its refusal stops the B-Dry capture's styleless ranges; this job's B-Dry
  proofs then use Justin's re-capture, or a fixture where none exists yet).
- `staging-fit-renderer`: its `.cls.brxe-<el>` selectors change which rule wins between controls and custom CSS; build on
  it if merged, else note the proofs' renderer.
- site-faq (`elementor-accordion.ts` `lookCss` already uses bounded runs: reuse, don't duplicate), site-native-structure
  (control vs custom split in `controls.ts`): coordinate edits to `controls.ts` and `classes.ts`.

## Risks

- Every website paste's CSS text changes where ranges drop declarations: existing B-Dry and corpus proofs are the net.
- Bounded runs at Elementor's 1366/1024 switch points need exact min widths (`min-width: 1025px`), from the capture's
  ranges (`web.ranges[].min`), never Bricks' tiers.
