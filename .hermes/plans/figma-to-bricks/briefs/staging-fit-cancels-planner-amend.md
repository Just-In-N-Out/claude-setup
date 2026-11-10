# Role: planner (plan amendments, wording only): staging-fit-cancels

You are a fresh planner (**Opus 5.5, high**). Amend the approved plan's wording where the move onto a newer main and
two reviews changed what an AC's words describe and the reviews found the head right; change no source or test, commit
nothing, start no agents. Never edit the main folder or any worktree; never load any live site; no logins. Work under
`~/.cache/sfc-pa/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, receipts encoding an old expectation
named with a sorter that really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id — check wrapped lines too —, each cited test name whole on one line; a
reviewer's suggested wording is set against the head's real output before it is adopted).

## Inputs
- **The approved copy** (read-only, your base text; no Amendments list yet):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md` (AC1–AC3, proposed; a live
  AC if it lists one; Q1 A as built — a hybrid: properties no range drops keep main's blocks — and Q2 A, not yet
  confirmed by Justin).
- Head: `ce5b38acbb959c12218e319560608c660c753b70` (branch `staging-fit-cancels-stack7`, on `main` `7eeca437`, Build
  2026-11-10.4; read with `git -C /home/justin/Documents/FigmaToBricksV2 show ce5b38ac:<path>`): `src/core/site/blocks.ts`
  (`runsOf`, `boundsOf`, `mediaOf`), `classes.ts`, `controls.ts`, `elementor-accordion.ts` (`openLook`),
  `slider-look.ts` (`partStates`), `test/fixtures/site-drops.ts` (`excepted`), the AC tests the plan cites
  (`test/web/site-range-cancels.test.ts` and the unit tests it names), `test/unit/site-live-widget.test.ts` (R1-4),
  `test/unit/site-slider-unchanged.test.ts`, `docs/HANDOFF.md` (the job's section) and its ledger under `docs/plans/`
  ("stack 7").
- Reviews 1 and 2 (`evidence/staging-fit-cancels/review-{1,2}/review.json`; both clean), the move's record
  (`evidence/staging-fit-cancels/stack-7/`: `golden.md`, `conflicts.md`, `logs/probe-ac1.log`, `ac1-main-red.log`,
  `repro-850.log`, `fourtrees.log`, `named-head2.log`), `evidence/staging-fit-cancels/follow-ups.md`.

## What to amend
1. **AC1's words about main, and the plan's playback of the bug** (the lines that say the link gets the browser's
   link blue `rgb(0,0,238)` and no background on main): main is now `7eeca437`, whose renderer prints a class's
   controls as `.cls.brxe-<element>` (as real Bricks does), so on main the link's background and colour hold at 600 and
   main fails there on the corner radius (0 against 6 px) and an underline. State AC1 by its rule (outside 768–991 the
   link keeps the site's whole look at every width read, with both Bricks samples, 2.3.9 and 2.4.2; RED on main at
   widths below 768 on the looks a `revert` rolls back), not by one colour. Set every sentence against the head's test
   and review 2's run on main before you write it.
2. **The known limit inside 768–991** (head and main alike, its own job `control-weight`): the link is drawn
   `inline-block` where the site's is `inline`, 28 px taller at 768, 880 and 991, because the link's own class control
   (0,2,0) beats the wrapper's rule by order; asserted by a `todo` test (review 2's R2-4: on main that todo passes
   without proving anything, because the first test fails before filling what it reads). AC1 must not claim 768–991.
3. **AC2's exceptions** (the words "no website paste … contains `revert` outside the `site-reset` class"): two named
   uses stay, by design, each with why it is not the cancel kind: an Elementor accordion's open look (site-faq's
   `openLook`: on the open item alone, where the site's open item declares nothing) and a slider's arrows and dots
   that are `<button>`s (site-slider's `partStates`: parts Splide makes, sent back to the browser's own button as the
   site's are). `excepted` in the test fixture is how AC2's test names them. Record review 2's R2-2 (the accordion
   exception at 0,3,0 also beats the same element's own hover rule: site-faq's design, on main too) under known
   limits.
4. **What the move added to the job's reach:** site-reviews' boxes inside a live slot now print as bounded runs (main
   wrote `max-width: revert` there: the cancel kind), with no code change; a merged job's unit test
   (`site-live-widget` R1-4) and site-slider's elementor-stretch sums were updated with a four-tree proof. Name them
   under the AC they support (supporting, never an AC's cited test). AC3's golden is now made from main `7eeca437`.
5. Known limits as the reviews left them: the sub-pixel gap between neighbouring runs (R1-1 / R2-1: at a width such as
   767.5 in a zoomed browser the dropped value is missing, now also in a live slot's box); R1-2, R1-3; R2-3 and R2-4
   (test gaps). The paste-check id: "the next free id at the merge".
- Don't add, remove or renumber an AC; keep every cited test name; put a cited name the approved copy wraps over two
  lines whole on one line (say which).

## Output
1. `/home/justin/.hermes/plans/figma-to-bricks/staging-fit-cancels-amended.md` (the whole plan). Don't touch
   `plan-approved.md`.
2. The regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, what is marked "to be confirmed with Justin", receipts that encode an old expectation
(with the sorter run on the job's heads `b1329c43` and `ce5b38ac`), the regex check; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
