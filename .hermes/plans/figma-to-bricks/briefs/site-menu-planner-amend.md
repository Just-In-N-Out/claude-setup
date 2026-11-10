# Role: planner (plan amendments, wording only): site-menu, and capture-speed's AC8

You are a fresh planner (**Opus 5.5, high**). Amend two approved plans' wording where four fix rounds refined what an AC
states and the reviews found the head right; change no source or test, commit nothing, start no agents. Never edit the
main folder or any worktree; never load any live site. Work under `~/.cache/smn-pa/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, receipts encoding an old expectation
named with a sorter that really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id, each cited test name whole on one line; a reviewer's suggested wording is
set against the head's real output before it is adopted).

## Inputs
- **site-menu's approved copy** (read-only, your base text; no Amendments list yet):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (AC1–AC8, AC8 live).
- Head: `4dd1a2755937da00b28bd7cf8cdf18ab0f1552fe` (branch `site-menu-fix4`, on `main` `3cfc54ac`; read with
  `git -C /home/justin/Documents/FigmaToBricksV2 show 4dd1a275:<path>`): `src/web/press-guard.ts`,
  `src/web/readers/openers.ts`, `src/web/readers/details.ts`, `src/web/read/opens.ts`, `src/web/capture.ts`,
  `src/core/snapshot/web.ts` (`CodeOpen`), `src/core/site/opens.ts`, `open-paste.ts`, `links.ts`, the AC tests the plan
  cites, `test/unit/bricks-shapes.test.ts`, `test/web/capture-opens-guards.test.ts`, `site-opens-more.test.ts`,
  `test/web/capture-matched-once.test.ts`, `docs/HANDOFF.md` (site-menu section), and the payload of a real output to
  check wording against (`evidence/site-menu/fixer-4/bdry-dryrun/final-c7b01781/`).
- Reviews 1–5 (`evidence/site-menu/review-{1,2,3,4,5}/review.json`; 5 is clean), Justin's answer in
  `review-4/justin.json` ("Fix the new window gap"), the fixers' receipts (`fixer-1/` … `fixer-4/`), and
  `evidence/site-menu/follow-ups.md`.
- **capture-speed's plan** (merged on `main` as Build 2026-11-08.2; AC8, "matched styles asked once per element"; its
  Amendment 1 on AC8 is Justin's, 2026-11-09: "Count per look, speed later (Recommended)"): the in-repo copy
  `git -C /home/justin/Documents/FigmaToBricksV2 show 4dd1a275:docs/plans/2026-11-07-capture-speed.md` and the approved
  copy `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-speed/plan-approved.md`.

## What to amend in site-menu's plan
1. **A box with no cover** (review 2's R2-4): lines the head makes false — AC7 "every emitted Offcanvas matches the
   sample's shape", AC2 "Content and Backdrop Blocks", Task 4's "nothing else gets `_interactions`", the "Openers" and
   "How the Offcanvas is built" paragraphs, the `CodeOpen` type. The plan must say: a box whose outside clicks reach the
   page has the Content Block only, `closeOn` esc or none, and closes on an outside click through Interactions on each
   part's root (acting only on its **open** boxes: the selector names `.brx-open`, review 2's R2-1) and on its openers;
   `CodeOpen` gains `through` and `motion`. Set every sentence against the real payload before you write it.
2. **A closed `details`** (review 1's R1-1): its content is read while it is open (one at a time, every details put
   back) and the open reading replaces the content's elements; the paste holds the open look.
3. **Which page load proves a box's close** (R1-2): the design width's when an opener shows there, else the widest
   range's where one does; a bare `#` inside an opened box stays `#`.
4. **What the capture may press, and the press guard** (reviews 2–5; the rule as the head has it): nothing inside a
   form or tied to one by `form=`, whatever its tag, as an opener or inside an opened box; from a page load's first
   press to its last, every non-GET/HEAD/OPTIONS request and every main-frame or new-window page load a press starts is
   failed before it leaves (a second session on the tab with its own Fetch; the page's service worker bypassed for the
   guard's span; frames and the service worker already running, and nested cross-site frames there at the start, held
   too; a press-opened window's worker bypassed before its first request); a press that tried a write counts for
   nothing and is named in the notes; a write to another site is failed, listed apart and never counted against a
   press (the fixer's ruling, upheld by review 3: mark it "to be confirmed with Justin"); everything is undone when the
   guard stops. List under known limits what the reviews left open in normal use: a window a handler opens after the
   guard has let go; a dedicated worker already running; a frame of another site added inside a frame after the guard
   starts; GETs by design (a pop-up plugin's open beacon); the guard's cost (about 30 % more capture time).
5. Any other AC line or rule line the head makes false (read all five reviews' P3s and the HANDOFF section's "builder's
   ruling" / "not yet confirmed" lines against each AC): mark it, say which finding it follows.
- Don't add, remove or renumber an AC; keep every cited test name; put a cited name the approved copy wraps over two
  lines whole on one line (say which). Name supporting tests under the AC they support ("never a report's cited test").

## What to amend in capture-speed's plan (a separate output file)
- **Amendment 2 on AC8 — "to be confirmed with Justin"** (site-menu review 2's R2-5: neither the code nor the test is
  the wrong side): an opened closed `details` is one more look, as a forced hover is since amendment 1 — the test's spy
  counts asks per page state, the normal state's asks are still compared with what the page needs and never twice per
  element, and the fixture allows one opening per page load with at most four asks, all of the details' own elements.
  Take the in-repo copy at `4dd1a275` as the base text if it is the newer one (say which copy you used and how the two
  differ), mark the changed lines, extend its Amendments list, change nothing else.

## Output
1. `/home/justin/.hermes/plans/figma-to-bricks/site-menu-amended.md` (the whole site-menu plan).
2. `/home/justin/.hermes/plans/figma-to-bricks/capture-speed-amended-2.md` (the whole capture-speed plan).
   Don't touch any `plan-approved.md`.
3. For each: the regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
Per plan: the amendments one line each, what is marked "to be confirmed with Justin", receipts that encode an old
expectation (with the sorter run on the job's heads), the regex check; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
