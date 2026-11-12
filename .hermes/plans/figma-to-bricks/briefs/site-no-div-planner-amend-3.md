# Role: planner (plan amendment 3): site-no-div — AC5's words for fix round 2's refusals

You are a fresh planner (**Fable 5.2, high**). Change no source or test, commit nothing, start no agents; never load any live site. Work
under `~/.cache/snd-pa3/` (delete large exports when done). Load `implementation-planning`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the plan-amendment paragraph and its lines on rule lists,
cited-test rows and clause mutants; `ac-check.sh`'s regexes).

## Why
Amendment 2 is installed (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md`, sha 60206e75…). Fixer 2 (head
`d915f7dc83e5edb14b7f6006e78714a92e9fac1c`, branch `site-no-div-fix2`) narrowed rule N: in a flex or grid row a `width: 100%`/`height: 100%`
wrapper lets through only the element's own 100% along that axis (and the element adds no margin, content-box padding or border, nor a size of
its own there); a % `text-indent` reads the wrapper's width; a new refusal "its element would read a text setting of its wrapper another way"
(`readsAnother`, keyed on the capture's `CodeNode.inherited`, or an em/ex/ch/% value meeting a font of the element's own). AC5's words say a
percentage along the width folds where "the wrapper isn't `width: 100%` itself" and don't name the text-setting refusal: a blind auditor
could call AC5 false.

## Do
Amend AC5's sentence and rule N's N4 prose to the head's code (`git show d915f7dc…:src/core/site/fold-boxes.ts`; `[amended 3]`; AC5's id,
tag and cited test name unchanged). Check AC5's cited test already holds a row per new clause (fixer 2 added R2-1/R2-2 rows); if a clause of
your amended sentence has none, write the rows and prove them (green on a `d915f7dc` export, red on clause mutants). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/planner-amend-3/plan-amended.md` with regex receipts beside it (ids, live set,
cited test names unchanged; no Amendments line starting with an AC id; headings compared).

## Report (as text)
The path and sha256; each change in one line; the regex receipts; any rows; `skill_lessons[]`, ending with: `MAIN SESSION: check and save
these skill_lessons now.`
