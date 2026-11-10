# Role: planner (plan amendment, wording only): site-reviews

You are a fresh planner (Fable 5.2, high). Amend the approved plan's wording where the two fix rounds refined what an AC
states and the head is right; change no source or test, commit nothing, start no agents. Never edit the main folder or
any worktree; never load any live site. Work under `~/.cache/srv-pa/` (the session scratchpad is shared by other agents).

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the paragraph "When Justin decides something mid-build that changes an approved AC, a planner amends the plan": an
Amendments list at the top, changed lines marked, receipts encoding an old expectation named with a sorter grep that
really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s `ac_start`, `bad_id` and `live`
regexes run on old and new with ids, live set and cited test names unchanged, no Amendments-list line starting with an AC
id, each cited test name whole on one line).

## Inputs
- Approved copy (read-only, your base text): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md`
  (no Amendments list yet; AC1–AC9, AC9 live).
- Head: `6fb06ea2b1d3f451d3a3a6c51cd53915fca0b117` (branch `site-reviews-fix2`, base `fd1986dc`; read with
  `git -C /home/justin/Documents/FigmaToBricksV2 show 6fb06ea2:<path>`): `src/web/read/embeds.ts` (`ownPlace`),
  `src/web/assemble.ts`, `src/core/site/live.ts`, `src/core/site/convert.ts`, the AC tests the plan cites,
  `test/web/site-widget-codes.test.ts`, `test/web/capture-widget-alone.test.ts`, `docs/HANDOFF.md` (site-reviews section).
- Reviews 1–3 (`evidence/site-reviews/review-{1,2,3}/review.json`; 3 is clean), the fixers' receipts
  (`evidence/site-reviews/fixer-1/`, `fixer-2/`), and the verifier's "Plan wording against head" (its three points, below;
  its receipts in `evidence/site-reviews/verifier/`).

## What to amend
1. **AC3 and AC8 say the Code element's code is "the snippet".** Since review 1 (R1-1/R1-2) the head pastes the slot's
   own served markup, kept apart as `web.embeds[].slot`; the capture's `snippet` can also carry tags from elsewhere in
   the page (the widget host's tracking tags, web-embeds rule 2), which are never pasted to run on the code route.
   Word both ACs (and the rule text) so they say: the slot's own served markup, or the loader's own tag at its own
   place; nothing else of the page rides along.
2. **AC1 says the snippet is the slot's served markup byte for byte.** True on its fixture; the byte-for-byte one is
   `slot`. Say so.
3. **AC5 says nothing inside the slot is compared.** The head compares the served boxes inside the slot and leaves out
   only what the script made. Say so.
4. **The rule text for a loader outside a served slot** (review 1's R1-3, review 2's R2-1, fixer 2's rule): a script
   tag alone is a widget's whole code only where the capture proves the tag draws it by itself — the tag is all the
   code its box was served with (no other script, style, link or template at any depth; a noscript's content doesn't
   count), the script replaced nothing, and what it drew stands where the tag was served; any doubt keeps the copy and
   the note names it. Add or correct the rule line; name the supporting tests (each whole on one line) under the AC
   they support without changing any AC's cited test.
5. Record, as "to be confirmed with Justin", only what the reviews left to him: R2-3 (a visible visit counter or ad tag
   that drew one thing beside itself pastes to run, named in the note by its host).
- Change nothing else. Don't add, remove or renumber an AC; keep every cited test name; fix a cited name the approved
  copy wraps over two lines by putting it whole on one line (say which).

## Output
1. Write the amended plan to `/home/justin/.hermes/plans/figma-to-bricks/site-reviews-amended.md` (the whole plan).
   Don't touch `plan-approved.md`.
2. Show the regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, receipts that encode an old expectation (with the sorter grep run on the job's heads),
the regex check, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
