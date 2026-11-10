# Role: planner (plan amendment 2, wording only): site-slider

You are a fresh planner (Fable 5.2, high). Amend the approved plan's wording where review 3 found the head right and the
plan's text behind it; change no source or test, commit nothing, start no agents. Never edit the main folder or any
worktree; never load any live site. Work under `~/.cache/ssl-pa2/` (the session scratchpad is shared by other agents).

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the paragraph "When Justin decides something mid-build that changes an approved AC, a planner amends the plan": changed
lines marked, the Amendments list at the top extended, receipts encoding an old expectation named, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id, each cited test name whole on one line).

## Inputs
- Approved copy, already amended 1–6 (read-only, your base text): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`.
- Head: `a97b102c3e8325394bb9bf9d554245b13fa3d9a8` (branch `site-slider-fix2`; read with
  `git -C /home/justin/Documents/FigmaToBricksV2 show a97b102c:<path>`): `src/core/site/elementor-slider.ts`
  (`placedLike`), `slider-look.ts`, `slider-css.ts`, `test/unit/site-slider.test.ts`,
  `test/web/site-elementor-swiper8.test.ts`, `docs/HANDOFF.md` (site-slider section).
- Review 3 (clean, P3s only): `evidence/site-slider/review-3/review.json` — R3-1, R3-2, R3-3 (R3-4 is the repo copy,
  handled by the merge finisher). Fixer 2's receipts: `evidence/site-slider/fixer-2/`.

## What to amend (continue the numbering: amendments 7…)
- **R3-2 (the rule's places line and amendment 4's "R2-3 changes no criterion"):** the plan says the site's arrow and dot
  places are copied "only when the arrow's containing block has the slider root's box". The head copies them whenever the
  box the part answered to on the site is the box Bricks' own part answers to in the paste (the slider where it is
  positioned there, else the nearest positioned box above the root; the same element or two measured alike; never for a
  fixed part or one with no positioned box above it). Bring the rule's text, AC5/AC6's words where they say otherwise,
  and the notes' wording to the head.
- **The Look list has no line for a slide's own height:** a height a slide declares itself (anything but `auto`,
  percentages too) is repeated `!important` on the slider's class per run of ranges (on every slide where they agree,
  else on each by its own class); the row's own height (but Swiper's 100%) on Splide's list; content-sized slides keep
  `height: "auto"`. Mark it "fixer 2's ruling, to be confirmed with Justin" (it is edited in that CSS line, not in the
  slide's Height control).
- **R3-3 (AC6 "one per real slide"):** true where one slide is in view; a carousel showing several at once gets one dot
  per page from Splide, named in the paste's note (R2-4, deferred). Word AC6 so it states what its cited test proves and
  names the difference; keep its cited test name.
- **R3-1 (amendment 1's named difference):** add that `site:check --all --elementor` reads it at the capture's widths
  992 (the paste shows the desktop count) and 767 (the paste shows the phone count) on a default 3/2/1 carousel whose
  pictures fill their slides; "to be confirmed with Justin" stays.
- `site:check` reads a looping slider's real slide, never Splide's copy (fixer 2): add where AC7's rule text describes
  what the check reads, only if a line says otherwise.
- Change nothing else. Don't add, remove or renumber an AC; keep every cited test name whole on one line.

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/site-slider-amended-2.md` (the whole plan).
   Don't touch `plan-approved.md`.
2. Show the regex checks' output (current approved copy vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, receipts that encode an old expectation (or "none: wording only"), the regex check, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
