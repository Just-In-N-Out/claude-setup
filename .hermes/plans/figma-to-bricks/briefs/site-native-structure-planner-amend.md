# Role: planner (plan amendment, wording only): site-native-structure

You are a fresh planner (**Opus 5.5, high**). Amend the approved plan's wording where the fix rounds refined what an AC
states and the reviews found the head right; change no source or test, commit nothing, start no agents. Never edit the
main folder or any worktree; never load any live site. Work under `~/.cache/sns-pa/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, receipts encoding an old expectation
named with a sorter that really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id, each cited test name whole on one line; an amendment that swaps an AC's
input also swaps every base input derived from it).

## Inputs
- Approved copy (read-only, your base text): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (no Amendments list yet; AC1–AC15, AC15 live).
- Head: `0581852c7fd95092ad6be1e2650cc3beb8c1808b` (branch `site-native-structure-fix2`, now on local `main`
  `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1`; read with `git -C /home/justin/Documents/FigmaToBricksV2 show
  0581852c:<path>`): `src/core/site/elementor-place.ts` (fold rule 10, "Placed bodies"; `sharesAcross`; `mirrored`),
  `elementor-fold.ts`, `elementor-button.ts`, the AC tests the plan cites, `test/web/site-elementor-places.test.ts`,
  `test/web/site-native-bdry.test.ts`, `docs/HANDOFF.md` (site-native-structure section).
- Reviews 1–3 (`evidence/site-native-structure/review-{1,2,3}/review.json`; 3 is clean), the first verifier's finding
  (`verifier-1-d83b68c7/`: AC6 false, a Div labelled "Button" around every real Button), the fixers' receipts
  (`fixer-1/`, `fixer-2/`).

## What to amend
1. **AC6 (the Button) and AC10 (the linked picture)** — review 2's R2-2, the reviewer's suggested wording: "…is one
   Bricks Button…; it stands for its widget box in its container, with no box around it, wherever fold rule 10 proves
   its place on the capture's boxes at every width of every kept range (`align-self` or `justify-self` from its line's
   text-align in a stretched column or grid cell); elsewhere one box labelled Button stays around it and the notes say
   why (`not folded: button <id>: <rule>`)." Bring both ACs and the rule text (the "Placed bodies" rule, its refusals:
   a body that doesn't fill its widget box, a padded holder, a `width: 100%` button in a row or centring column, a
   padded body shrunk by a never-wrapping row, a widget box stretched taller than its body, a body in a block parent, a
   side placement on a right-to-left line; the px padding of a wrapper becoming the body's margin; a % width, min-width
   or max-width beside side margins written as `calc(p% - p·M/100 px)` where the widget box is stretched with no width
   of its own and refused elsewhere) to the head. **Mark this "the fixers' and reviewers' reading under Justin's
   standing 'go with recommended', to be confirmed with Justin"**: on the B-Dry stand-in 15 of 17 Buttons and 4 of 5
   linked pictures stand alone; the three that keep a box are a header button whose widget box is 74% wide, a footer
   button in a padded holder pulled out by −5px margins, and the phone header's logo in a 60% wide widget box.
2. **AC14** (B-Dry, named-only): it now pins those counts and requires a note for every kept box; it runs on a clean
   B-Dry stand-in capture (never Justin's 2026-11-09 capture, which `main` refuses since Build 2026-11-09.4). Say which
   file the fixers used (find it in `fixer-2/gates/SUMMARY.txt` and the test's variables), by path and sha256, that it
   is the saved 2026-10-29 home served locally and not the live site, and that Justin's re-capture replaces it once it
   exists (AC15 carries the live proof).
3. **AC13 and its pins** still name the old base `fd1986dc` (review 3's R3-5): the base is now `3cfc54ac`; say the pins
   stay meaningful because `fd1986dc..3cfc54ac` changes nothing a paste is built from, or re-word to "the base commit
   (`git merge-base HEAD main`)".
4. Any other AC line or rule line the head makes false (read the three reviews' P3s and the HANDOFF section's
   "builder's ruling" / "not yet confirmed" lines against each AC): mark it, say which finding it follows.
- Change nothing else. Don't add, remove or renumber an AC; keep every cited test name; put a cited name the approved
  copy wraps over two lines whole on one line (say which).

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/site-native-structure-amended.md` (the whole
   plan). Don't touch `plan-approved.md`.
2. Show the regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, what is marked "to be confirmed with Justin", receipts that encode an old expectation
(with the sorter run on the job's heads), the regex check, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
