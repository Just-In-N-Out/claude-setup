# Role: planner (plan amendments, wording only): panel-embed-code

You are a fresh planner (**Opus 5.5, high**). Amend the approved plan's wording where the build, three fix rounds,
three reviews and one decision of Justin's refined what an AC states; change no source or test, commit nothing, start
no agents. Never edit the main folder or any worktree; never load any live site; no logins. Work under
`~/.cache/pec-pa/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, receipts encoding an old expectation
named with a sorter that really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id — check wrapped lines too —, each cited test name whole on one line; a
reviewer's suggested wording is set against the head's real output before it is adopted; supporting tests go on an
"Also (supporting, never the cited test)" line under the AC they support, without quoting their full names where that
would let a report cite one for an AC).

## Inputs
- **The approved copy** (read-only, your base text; no Amendments list yet):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md` (AC1–AC11; AC11 live; Q1 A –
  Q5 A taken on Justin's "Panel widget code go").
- Head: `ca7d6046e7d342f23b27ccc69e9267f95b3b3305` (branch `panel-embed-code-fix3`, on `f708dfb6`; a fixer is moving it
  onto main beside you without changing its rule; read with `git -C /home/justin/Documents/FigmaToBricksV2 show
  ca7d6046:<path>`): `src/core/snapshot/embed-code.ts`, `src/core/normalise/embeds.ts`, `normalise/floating.ts`,
  `src/core/site/live.ts`, `src/web/read/tracker.ts`, `src/web/read/floating.ts`, `src/web/map/snippets.ts`,
  `src/web/assemble.ts`, `src/core/snapshot/web.ts`, the AC tests the plan cites, the fix rounds' tests
  (`test/web/panel-floating-chain.test.ts`, `floating-holds`, `tracker-stack`, `test/unit/floating-origin.test.ts`,
  `panel-floating-why`), `docs/HANDOFF.md` (the panel-embed-code section), `docs/specs/web-capture.md` and the ledger
  under `docs/plans/` ("Fix pass 1", "Fix pass 2", "Fix pass 3" list the plan lines that read false or true again).
- Reviews 1–3 (`evidence/panel-embed-code/review-{1,2,3}/review.json`), **Justin's answer** in
  `review-2/justin.json` ("Safe rule (Recommended)": paste a floating widget's code only when the exact file that drew
  it is a tag the old page served; anything started by a starter script, a tag manager or the page's own script is
  listed with a plain note: add its install code by hand in one Code element), the fixers' receipts (`fixer-1/`,
  `fixer-2/`, `fixer-3/`), `evidence/panel-embed-code/follow-ups.md`.

## What to amend
1. **A floating widget's own code (Q4 A, AC7, AC3 where it speaks of it, lines 188–189, the code sketch's comments):**
   state the rule as the head has it and as Justin chose it. Code is pasted only when (a) the file that drew the box
   is a script tag the old page's server sent (kept as served; served twice: both tags) **and** (b) that file drew it
   by itself: no other file, no code that belongs to no served file (an injected inline script, `eval`, `new
   Function`, a timer given a string, a `javascript:`, `data:` or `blob:` script) and none of the page's own code on
   the stack when the box is made (the stack read 200 frames deep; a stack cut at that depth counts as not alone;
   the browser's own frames and the tracker's don't count). Otherwise nothing is pasted and the capture records why
   (`ownWhy`: `started`, `page`, `frame`, `unread`), each with its one-sentence note. A box another host's file drew
   with the site's own code on its stack is the site's own box, rebuilt as other site-own fixed boxes are, only when
   it holds nothing of another host and a link to the site or a picture of its own; otherwise it is listed. Say
   plainly that fix round 1's reading (a starter script's chain; "libraries") was withdrawn after review 2 and
   Justin's answer, and that a chat started by a starter script is listed by his choice.
2. **R1-7 (the builder's ruling, upheld by review 1):** the plan's code block `e.how === undefined ? "older"` and the
   sentence beside it: with a code reading in the capture, an embed with no `how` is "unproven" (add it by hand), not
   "older" (capture again), because `how` predates the code reading; set it against `embed-code.ts` on the head.
3. **The notes' words** (AC lines or rule lines that quote them): the reasons' sentences as the head prints them; the
   pasted floating widget's note now ends with the sentence that it runs that host's own file as the old page did,
   with whatever else that file loads (R3-2); the `page` note's new words for a box drawn through another host's file
   (R3-6); "capture the page again (a new capture may paste it)" for an unread served page; no "your <cdn host>
   account".
4. **A capture this build doesn't know** (R3-4): a reason value the build doesn't know falls through to the unproven
   note; say it where the plan speaks of older and newer captures.
5. **Open, "to be confirmed with Justin":** (a) R3-2: a served file that draws its box by itself is pasted by the rule
   he chose; that file can be a tag manager inserting a button as plain markup; keep the rule with the honest note
   (as built), or never paste a floating widget's code (always listed); (b) the builder's AC1 ruling in item 2.
6. **Known limits as the reviews left them** (a Risks / Known limits list, each one line with its finding id): a
   bootstrap with several chunks of its own; a vendor function handed directly as a handler or drawing after an
   `await` (its tag pastes and draws nothing); a vendor file that builds templates with `eval`; a site's own CDN-made
   box with no site link or picture is listed; a vendor box the site's script starts that links only to the site's
   pages is rebuilt as the site's own; shadow roots; R1-3, R1-4, R1-5; the stack read's cost (R3-5); a page that
   leaves a `prepareStackTrace` returning call sites. The paste-check id: "the next free id at the merge".
- Don't add, remove or renumber an AC; keep every cited test name; put a cited name the approved copy wraps over two
  lines whole on one line (say which). Check every AC sentence against what its cited test still asserts on the head
  (three fix rounds rewrote tests: where an AC's cited test no longer covers a clause of the AC's sentence, say so in
  your report — that is a gap for a fixer, not something wording may paper over).

## Output
1. `/home/justin/.hermes/plans/figma-to-bricks/panel-embed-code-amended.md` (the whole plan). Don't touch
   `plan-approved.md`.
2. The regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, what is marked "to be confirmed with Justin", any AC whose cited test no longer covers
its sentence, receipts that encode an old expectation (with the sorter run on the job's heads `4d6c6403`, `4cfc7003`,
`6b115d3f`, `ca7d6046`), the regex check; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
