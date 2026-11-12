# Role: planner (plan amendment 2): site-no-div — AC4 and rule S against the head's Section/Container rule

You are a fresh planner (**Fable 5.2, high**). Change no source or test, commit nothing, start no agents; never load any live site. Work
under `~/.cache/snd-pa2/`. Load `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph, including its lines on numbered rule lists and on writing cited-test rows; `ac-check.sh`'s regexes).

## Why
Amendment 1 is installed: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md` (sha256 e70cc030…). Its planner
flagged: the builder's ruling (HANDOFF "A website paste holds no Div": a Section stands only for a `div` or `section` box, a Container only for
a `div`) is stricter than AC4 and rule S ("a Section's only shown child that is a box its Container", "when every one is a box"). A blind
auditor given only the plan could call AC4 false. Under Justin's "go with recommended" the stricter rule stands (a row of links or a list is
never a Section); the plan must say what the head does.

## Do
1. Read rule S in the head's code (`git show 374ea2ce2075d86054c70c07daab45ef1148798a:src/core/site/lift.ts` and whatever it calls; never edit
   a worktree): exactly when a part's top box becomes a Section, its child a Container, else a Block — tags, shown widths, section pastes
   (review 1's R1-5: a section paste's root becomes a Section whatever its tag; a follow-up, say so in the plan's risks, don't amend it away).
2. Amend AC4's wording and rule S's prose to the head's rule (`[amended 2]`; AC4's id, `(proposed)` tag and test name unchanged), and check
   AC4's cited test asserts the tag clause; if it doesn't, write the rows for its cases table and run them on `git archive` exports of
   374ea2ce (green) and ae288ac8's parent where the clause is missing (red), as amendment 1 did for AC5 (`planner-amend-1/ac5-rows.txt`).
3. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/planner-amend-2/plan-amended.md` with regex receipts beside it (ids,
   live set and cited test names unchanged; no Amendments line starting with an AC id; headings compared).

## Report (as text)
The path and sha256; each change in one line; the regex receipts; any test rows (with both logs); `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
