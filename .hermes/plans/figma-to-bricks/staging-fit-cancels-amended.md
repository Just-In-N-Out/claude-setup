# staging-fit-cancels: a website paste's per-range rules never cancel another rule (plan, 2026-11-09; amended 2026-11-10)

## Amendments (2026-11-10, after stack 7 and reviews 1–2; wording only, no AC added, removed or renumbered)

The job moved onto main `7eeca437` (Build 2026-11-10.4, staging-fit-renderer merged) as branch `staging-fit-cancels-stack7`, head `ce5b38acbb959c12218e319560608c660c753b70`. Reviews 1 (`b1329c43`) and 2 (`ce5b38ac`) are clean. Changed lines end with `[amended: <n>]`. The pre-amendment text: `git -C /home/justin/Documents/FigmaToBricksV2 show ce5b38ac:docs/plans/2026-11-09-staging-fit-cancels.md` (byte for byte the read-only `evidence/staging-fit-cancels/plan-approved.md` of 2026-11-09).

1. The bug on main, and the words of AC1: main's renderer now prints a class's controls as `.cls.brxe-<element>` (0,2,0), as live Bricks does, so on main the fixture's link keeps its background and colour at 600 (they are controls, printed after main's `revert` rule) and loses only what sits in its custom CSS: corner radius 0 against the site's 6 px, and an underline, at 300, 390 and 600 (`stack-7/logs/ac1-main-red.log`, `probe-ac1.log`). The criterion is now stated by its rule: outside 768–991 the link keeps the site's whole look at every width the test reads, drawn as Bricks 2.3.9 and 2.4.2 print it; RED on main at the widths below 768 on the looks a `revert` rolls back. The browser's link blue `rgb(0,0,238)` stays only as what main `fd1986dc`/`3cfc54ac` showed under the renderer of that time and what staging showed.
2. The criterion no longer reaches 768–991: there, on head and main alike, the link is `inline-block` where the site's is `inline` (28 px taller at 768, 880 and 991), because the link's own class control (0,2,0) beats the wrapper's inline-element rule (0,2,0) by order. It is its own job, `control-weight`, and a `todo` test asserts it (Known limits).
3. The two named exceptions in the no-`revert` criterion (AC2's line): an Elementor accordion's open look (site-faq's `openLook`) and a slider's arrows and dots that are `<button>`s (site-slider's `partStates`), each with why it is not the cancel kind; `test/fixtures/site-drops.ts` `excepted` is how the test names them. Review 2's R2-2 goes under Known limits.
4. What the move added to the job's reach, under the criterion each supports (supporting only, never a cited test): site-reviews' boxes inside a live slot now print as bounded runs (main wrote `max-width: revert` there), with no code change; site-reviews' unit test `site-live-widget` R1-4 and site-slider's elementor-stretch sums were updated, with a four-tree proof. The byte-for-byte golden of the third criterion is now made from main `7eeca437`.
5. Known limits as the reviews left them (R1-1/R2-1, R1-2, R1-3, R2-2, R2-3, R2-4) and the paste-check id: "the next free id at the merge".
6. Q1 A is recorded as built (a hybrid: a property no narrower range drops keeps main's blocks), as HANDOFF says; Q1 A and Q2 A are still not confirmed by Justin. Overlaps say staging-fit-capture and staging-fit-renderer have merged.

No cited test name was wrapped over two lines in the approved copy (all three were whole on one line); they stay whole, unchanged.

**Receipts that encode an old expectation** (the verifier and auditor re-run on `ce5b38ac`; sort evidence heads with the greps below):
- Old AC1 RED and looks: `evidence/staging-fit-cancels/builder/ac1/red-base.log`, `builder/shots/ac1-base-600.txt`, `builder/shots/ac1-base-390.txt` (main `3cfc54ac`, bare `.cls` renderer: `rgb(0, 0, 238)`, no background, underline) and `builder/ac-final/ac1.log` (head `b1329c43`, one Bricks sample, 768–991 compared in full). Now expected: RED on main `7eeca437` by radius 0 and underline at 300–767 with background and colour holding (`stack-7/logs/ac1-main-red.log`); GREEN on head outside 768–991 on both Bricks samples, plus one `todo` test. Sorter: `git show <head>:test/web/site-range-cancels.test.ts | grep -c 'BRICKS_VERSIONS'` gives 0 on `b1329c43`, 2 on `ce5b38ac`; `grep -c 'todo:'` 0 and 1.
- Old AC2 receipt: `builder/ac-final/ac2.log` (`b1329c43`, no exception named). Now expected: the named run's diagnostic names the exceptions (`stack-7/logs/named-head2.log`: 82 captures, 6,592 pastes, `{"accordion open look":16}`). Sorter: `git show <head>:test/unit/site-no-revert.test.ts | grep -c 'excepted'` gives 0 on `b1329c43`, 4 on `ce5b38ac`.
- Old AC3 receipts: `builder/ac-final/ac3.log`, `builder/ac3/` (golden base `3cfc54ac`). Now expected: the golden's base `7eeca437`, every entry as before (`stack-7/golden.md`: 676 entries, 0 moved). Sorter: `git show <head>:test/fixtures/site-no-revert-main.json | grep -o '"base": *"[0-9a-f]*"'` gives `3cfc54ac…` on `b1329c43`, `7eeca437…` on `ce5b38ac`.
- Mutant receipts (`builder/mutants*`) stay valid where the assertion a mutant failed on is unchanged at `ce5b38ac` (AC1's background and colour at 600, AC2's revert list for a class outside the exceptions); stack 7's 13 mutants (`stack-7/logs/mutants.log`) are on this stack's code.

Job B of the staging-fit umbrella (`~/.hermes/plans/figma-to-bricks/staging-fit.md`). Planned against main `fd1986dc`
(Build 2026-11-09.3); moved at stack 7 onto main `7eeca437` (Build 2026-11-10.4: staging-fit-capture, site-faq, site-reviews, site-slider and staging-fit-renderer merged). [amended: 6]
**Order: third, built after `staging-fit-capture` merges** (rebase onto it; ideally after
`staging-fit-renderer` too, so its proofs draw Bricks' real selectors). Website importer rules: one real-bug review, edge
cases to follow-ups. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (index `README.md`).

## Questions (⭐ = the standing auto-go's answer)

1. **How a narrower range drops a declaration a wider one set.** ⭐ **A:** never `revert`: each property's value goes in
   one block per run of ranges with that value, bounded by the run's own widths (`@media (min-width: …) and (max-width:
   …)`; the widest run unbounded above, the narrowest below), as the FAQ's open look already does
   (`src/core/site/elementor-accordion.ts` `lookCss`), so nothing cancels another rule. Website pastes change bytes, not
   looks; Figma conversions byte-identical. B: keep `revert`, only stop inline-element rules from cancelling.
   As built (HANDOFF "The rule"): a hybrid. A property some narrower range drops is written in bounded runs; a property no narrower range drops keeps main's desktop-first blocks, byte for byte. Not yet confirmed by Justin. [amended: 6]
2. **Bricks controls at tiers.** ⭐ **A:** a property stays a Bricks control only where its runs nest the way Bricks' tiers
   cascade (991 → 767 → 478); otherwise it goes to the class's custom CSS. B: keep today's control choice. Not yet confirmed by Justin. [amended: 6]

## Playback

On phones the hero buttons of Justin's staging paste lose their background and turn into blue link text, while the site
keeps them painted. The styleless tablet capture made the rule that does it (fixed by staging-fit-capture), but the
mechanism is general: the paste cancels a value with `revert`, which also cancels the element's own rules.
Which of the element's looks a `revert` rolls back depends on where Bricks prints them: its custom CSS (`.cls`, 0,1,0) loses to the cancel, while its class controls, which live Bricks prints as `.cls.brxe-<element>` (0,2,0) after it, win. On the generic fixture under main `7eeca437`'s renderer the link therefore keeps its background and colour below 768 and loses its corner radius and gains an underline. [amended: 1]

## Root cause (R2, proved)

- `blocksOf`/`blocksOfStates` (`src/core/site/blocks.ts:23-36`) write each narrower range as a block of what changed, a
  dropped declaration as `revert`.
- In the styleless tablet read the hero's button link was an inline word, so its wrapper's class got an inline-element
  rule `.home__protecting-your__inner-dwzn > :nth-child(1)` (`src/core/site/classes.ts:99-100`, `:130`) at `max-width:
  991px`; at `max-width: 767px` it writes `background-image: revert; color: revert; font-size: revert…` (0,2,0). That
  beats the link's own class `.home__protecting-your__inner-fisl` (0,1,0: gradient, `#fff`), and `revert` rolls back the
  whole author origin: on staging (`probe2/staging.json`) and in main `fd1986dc`'s renderer of the time, which drew a class as a bare `.cls` (`probe2/probe3.json`), the link gets the browser's link blue `rgb(0,0,238)` and no background. [amended: 1]
- Under main `7eeca437`'s renderer (a class's controls as `.cls.brxe-<element>`, both Bricks samples) the same cancel on the generic fixture rolls back only the link's custom-CSS looks: radius 0 against 6 px and an underline at 300, 390 and 600; background and colour hold (`evidence/staging-fit-cancels/stack-7/logs/ac1-main-red.log`, `probe-ac1.log`). [amended: 1]
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
5. Stack 7 (done at `ce5b38ac`): the move onto main `7eeca437`, the golden made again from it, every `revert` the merged jobs write judged (one cancel kind, site-reviews' live slot, now bounded; two named exceptions), the merged jobs' unit test and sums updated, the proofs re-run under main's renderer on both Bricks samples. [amended: 3, 4]

## Acceptance criteria (all proposed)

- AC1 (proposed): generic fixture site: a link that is an inline word at 768–991 (`display: inline` there) and its own painted button at every other width; each paste of it (the whole page and the hero alone, Rich Text and Basic Text), drawn as Bricks 2.3.9 and 2.4.2 print it (a class's controls as `.cls.brxe-<element>`), keeps the link's whole look (computed background, colour, corner radius, underline, padding, font size and box equal the site's, as for every other listed element) at every width the test reads outside 768–991 (300 under the capture's narrowest, 390, 600, 1200), and the page is within 2 px of the site at every width read outside 768–991; RED on main at the widths below 768 on the looks a `revert` rolls back (main `7eeca437`: corner radius 0 against 6 px and an underline, background and colour holding); it claims nothing inside 768–991 (Known limits, job `control-weight`). [amended: 1, 2]
  Test: `test/web/site-range-cancels.test.ts` › "a narrower range never reverts another rule"
- AC2 (proposed): no website paste of the corpus captures or of the B-Dry capture (named-only) contains `revert` outside the `site-reset` class, over both routes (plain, `--elementor`), both picture modes and both text modes, but two named uses that are not the cancel kind (`test/fixtures/site-drops.ts` `excepted`: every selector of the rule under the class's own, in one of these shapes): an Elementor accordion's open look on Bricks' open item (`.<accordion> > .brx-open …`, site-faq's `openLook`: on the open item alone, where every closed item declares a value and the site's open item declares nothing, so it gives the site's own value) and a slider's arrows and dots that are `<button>`s (`.<slider> > .splide__arrows > .splide__arrow…`, `.<slider> > .splide__pagination…`, site-slider's `partStates`: parts Splide makes, no element of the paste, sent back from Bricks' and Splide's button CSS to the browser's own button, as the site's are). [amended: 3]
  Test: `test/unit/site-no-revert.test.ts` › "website pastes write no revert outside site-reset"
  Supporting, not this criterion's test: site-reviews' boxes inside a live slot (`src/core/site/convert.ts` `inside`, printed through `classes.ts` `rules`) were the cancel kind on main (`@media (max-width: 767px) { … max-width: revert }`) and now print as a bounded run `@media (min-width: 768px) { … max-width: 700px; }` through this job's helpers with no code change; site-reviews' unit test `site-live-widget` R1-4 was updated to assert that and no revert in the slot's class (RED on main, `stack-7/logs/redgreen.log`). [amended: 4]
- AC3 (proposed): every existing site proof stays within its tolerance, Figma conversions are byte-identical (`npm run corpus`, replay), and website pastes change bytes only in classes where a range drops a declaration (HANDOFF says so, Q1 A); the golden of main's pastes (`test/fixtures/site-no-revert-main.json`) is made from main `7eeca437` (stack 7: every entry as `3cfc54ac`'s, only its `base` line moved). [amended: 4]
  Test: `test/unit/site-no-revert.test.ts` › "classes without a dropped declaration print byte for byte as on main"
  Supporting, not this criterion's test: site-slider's `test/unit/site-slider-unchanged.test.ts` elementor-stretch sums were made again (through the conversion step on the saved capture) because that page's three boxes main wrote a `revert` in now print as bounded runs; the four-tree proof (`stack-7/logs/fourtrees.log`: old base, old head, new main, new head on site-slider's saved captures) shows code-page, the FAQ and the slider with new main equal to new head, and elementor-stretch with old base equal to new main and old head equal to new head, only those three boxes changing. [amended: 4]

## Known limits (as reviews 1 and 2 left them) [amended: 2, 3, 5]

- **Inside 768–991 (head and main alike; its own job `control-weight`):** where a parent's words hold the link as an inline element, the wrapper's inline-element rule `.wrapper > :nth-child(1)` (0,2,0, its bounded run) loses by order to the link's own class control `.cls.brxe-div { display: inline-block }` (0,2,0, printed after it: `stack-7/logs/repro-850.log`), so the link is `inline-block` where the site's is `inline` and the line is 28 px taller at 768, 880 and 991; its paint there (background, colour, padding, font size) equals the site's. The cure (keep such an element's contested properties out of its controls, or weigh the inline rule up) changes classes no range drops, a design change. Asserted by the second test of `test/web/site-range-cancels.test.ts`, a `todo` (not a cited test; it never proves AC1). [amended: 2]
- **The accordion exception and hover (R2-2, predicted from source, not run; site-faq's design, on main too):** the open look's `.acc > .brx-open .cls { prop: revert }` (0,3,0) also beats the same element's own `.cls:hover` (0,2,0), so where an open item's moved property also changes on hover the open item loses its hover look; the site keeps it. [amended: 3]
- **Sub-pixel gap between neighbouring runs (R1-1, R2-1):** bounds are whole px, so at a fractional width such as 767.5 (a zoomed browser) neither `(max-width: 767px)` nor `(min-width: 768px)` matches and the dropped value is missing there, now also in a live slot's box (no max-width, the desktop margin-top). Main had no such gap. An exact close needs `(width > 767px)` range syntax, which Safari before 16.4 drops with its whole block. [amended: 4, 5]
- **R1-2:** a shorthand some narrower range drops, beside one of its longhands declared at every range, prints its bounded block after the longhand's base rule and wins where both hold; only an unexpanded shorthand reaches this (the capture expands shorthands). [amended: 5]
- **R1-3 (predicted from source, not run):** an entrance whose site name is an animate.css name holding In keeps it as its Bricks type; where the site drops the animation, head writes nothing, so Bricks' own `.brx-animate-<name>` plays there (main wrote `revert`; neither matches the site; the Interaction has no width limit, older than this job). [amended: 5]
- **R2-3 (test gap):** the rewritten `site-live-widget` R1-4 assertion no longer checks that `max-width` is absent from the box's base rule. [amended: 4, 5]
- **R2-4 (test gap):** the `todo` test reads what the first test fills; on main the first test fails at 600 before filling it, so main's todo passes without proving anything; on head it reports the limit truthfully. [amended: 2, 5]
- **Paste check:** the next free id at the merge (HANDOFF's `<staging-fit-cancels id at merge>`). [amended: 5]

## Overlaps

- `staging-fit-capture`: must merge first (its refusal stops the B-Dry capture's styleless ranges; this job's B-Dry
  proofs then use Justin's re-capture, or a fixture where none exists yet). Merged (Build 2026-11-09.4); Justin's capture is refused (styleless 768–991), so the B-Dry proofs use the stand-in served from the saved 2026-10-29 files. [amended: 6]
- `staging-fit-renderer`: its `.cls.brxe-<el>` selectors change which rule wins between controls and custom CSS; build on
  it if merged, else note the proofs' renderer. Merged (Build 2026-11-10.4); the proofs draw with its renderer on both Bricks samples. [amended: 1, 6]
- site-faq (`elementor-accordion.ts` `lookCss` already uses bounded runs: reuse, don't duplicate), site-native-structure
  (control vs custom split in `controls.ts`): coordinate edits to `controls.ts` and `classes.ts`.

## Risks

- Every website paste's CSS text changes where ranges drop declarations: existing B-Dry and corpus proofs are the net.
- Bounded runs at Elementor's 1366/1024 switch points need exact min widths (`min-width: 1025px`), from the capture's
  ranges (`web.ranges[].min`), never Bricks' tiers.
