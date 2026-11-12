# Role: planner (plan amendment 3, wording only): site-native-structure — a header kept at the top keeps one wrapper

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan; change no source or test, commit nothing, start no agents; never
load any live site. Work under `~/.cache/sns-pa3/`. Load `implementation-planning`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the plan-amendment paragraph: Amendments list at
the top, `[amended]` marks, `ac-check.sh`'s `ac_start`, `bad_id`, `live` regexes on old and new, ids/live set/cited test names unchanged
unless the amendment says why, no Amendments-list line starting with an AC id, each cited name whole on one line).

## Why
Approved plan (amendment 2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`. The move onto
main (Build 2026-11-11.10, which now holds site-sticky-header 11.7 and site-scroll-lock 11.5) found a meet: site-sticky-header's stay class
landed on every top Section of a lifted header, so a two-section header's second bar slid over the first. The finisher fixed it test first
(commit `e4f51759` on branch `site-native-structure-final`, head `9043fa88aea926a88e44b94510d423743de78889`): **a header the paste keeps at
the top (it carries the stay class) keeps its root when it holds two or more sections — one Block labelled "Header" carrying the stay class,
with the note "the header's root stays: it keeps the header's N sections together at the top of the window, as the old site does"**; a
single-section kept header still lifts (its Section carries the class); a header that doesn't stay lifts as before. Justin's B-Dry scan has
this shape (two header Sections). Also `602aea15`: on a lifted part the scroll lock sits on each top Section. Records:
`evidence/site-native-structure/stack-8/`, HANDOFF on the branch.

## Amend
- AC2 (a root that draws nothing is left out) and AC15 (live: the Structure panel's top rows are Sections) gain the exception above,
  worded as the rule (any site), with its note; AC15's step for B-Dry: the header is one Block "Header" holding its two Sections, both bars
  staying at the top together. Name the new tests that pin it (`test/unit/site-native-stay.test.ts`, `test/web/site-native-stay.test.ts`)
  as supporting tests, or add them to AC2's line if the plan's style cites one test per AC (say which).
- Q for Justin with ⭐: ⭐ A keep one "Header" Block (the header sticks as one, as on the site); B two Sections each sticky (bars overlap) —
  not viable; C make the header sticky through Bricks' own Header template setting instead (only when pasted in a template). Mark A taken
  under his standing "go with recommended", not yet confirmed.
- Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/planner-amend-3/plan-amended.md` with the regex receipts
  (the main session installs it read-only, keeping the old copy as `plan-approved-v3-before-amendment-3.md`).

## Report (as text)
The amended plan's path and sha256; each change in one line; the regex receipts; `skill_lessons[]` (empty is normal), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
