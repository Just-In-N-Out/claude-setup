# Role: planner (plan amendment 2, inputs and wording only): site-native-structure

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan; change no source or test, commit nothing, start no
agents. Never edit the main folder or any worktree; never load any live site. Work under `~/.cache/sns-pa2/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, where the pre-amendment text lives,
`ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names
unchanged, no Amendments-list line starting with an AC id, each cited test name whole on one line; an amendment that swaps
an AC's input also swaps every base input derived from it).

## Inputs
- Approved copy (read-only, your base text): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (amendment 1 installed 2026-11-10; AC1–AC15, AC15 live). Its pre-amendment-1 text: `plan-approved-v1-before-amendments.md`.
- Head `2a38027faad44e16bcb885d264317d8be9df6f57` (branch `site-native-structure-stack6`, code `b2435def`) on base
  `731707c5e84f9495e152b60d302fe640f6f06554` (footer-icon-list, merging as Build 2026-11-11.4). Read with `git -C
  /home/justin/Documents/FigmaToBricksV2 show 2a38027f:<path>`. Review 5 clean (`evidence/site-native-structure/review-5/review.json`);
  state in `evidence/site-native-structure/follow-ups.md` ("Stack 6", "Review 5").

## Amend
1. **AC14's input:** footer-icon-list changed the capture (one name per box side), so AC14's B-Dry stand-in becomes
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-b2435de.json`
   (sha256 `462f292d20eee2292c8f1b21db745ddde09be4a6f1f7059dab2752277f3e0f6d`; the saved 2026-10-29 home served locally
   and captured by the head's own capture code, 38 widths) in place of `standin-capture-0581852c.json`; swap every base
   input derived from it (the base side is captured by the base's own capture from the same served page, or say how the
   old-code run gets its input). Pinned counts stay: 15 of 17 Buttons and 4 of 5 linked pictures alone; boxed `ef454b9`,
   `58a7a74`, `ba89ea2`. Footer and page within the plan's tolerance (receipts: `stack-6/ac14/`, `stack-6/page-bdry/`).
   Any AC text still naming `fd1986dc`, `0581852c` or the old stand-in: update.
2. **AC15 (live) gains one step** (review 5, R5-2): open one of the page's pop-ups (a hotspot or "Get a quote") on B-Dry
   staging and check it opens and looks as on the site — its top box is now a Bricks Section inside the Offcanvas, which
   `reference/bricks/` doesn't hold. Wording only; AC15 stays the one live AC.
3. Nothing else: ids, the live set and cited test names unchanged.

## Write
The amended plan to `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/planner-amend-2/plan-amended.md`
(the main session installs it read-only as `plan-approved.md`, keeping the old copy as
`plan-approved-v2-before-amendment-2.md`), with the regex receipts (old vs new) beside it.

## Report (as text)
The amended plan's path; each change in one line; the regex receipts; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
