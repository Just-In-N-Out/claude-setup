# Role: reviewer (Full round 2: the whole story, report only): site-native-structure

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a captured Elementor page pasted into Bricks 2.3.9 or 2.4.2 by `npm run site --elementor`,
looking like the site and reading as Sections, Buttons and so on in Bricks' Structure panel; the plain route and Figma
designs converting as before), each with a concrete real-use scenario. Edge cases are P3 (follow-ups). A P0–P2 with no
concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live). Justin's ask (2026-11-09, Bricks' Structure panel showing "Div, Div, Div"): "I want the
  structure to work like the plug-in when we copy it from Figma to Bricks … I don't want it to be all div div div." The
  job, on the `--elementor` route only: top-level Elementor containers are Sections (inner box the Container, nested ones
  Blocks), labels by role, an Elementor button widget one Bricks Button, a divider one Divider, a linked picture one
  Image with Link to — each only where a rule proves the same boxes within 2 px, otherwise the site's elements stay,
  named. The plain route and Figma designs byte-identical.
- Branch `site-native-structure-fix1`, head `db5829201a3e546da0a861fb5e7d234a7a91e07d`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. Local `main` has since moved to `3cfc54ac` (staging-fit-capture, Build
  2026-11-09.4: adds `src/core/site/styled-ranges.ts`, touches HANDOFF); this branch is **not** rebased yet. In your own
  worktree: `git checkout --detach db5829201a3e546da0a861fb5e7d234a7a91e07d`, confirm HEAD and a clean status. Review
  the whole story `git diff fd1986dc...HEAD`, hardest where the fix round changed it (`git diff d83b68c7..HEAD`).
- History: review 1 was clean; the verifier then found AC6 false on `d83b68c7` (a Div labelled "Button" stayed around
  every real Button: 0 of 17 alone on the B-Dry stand-in). Fixer 1 built fold rule 10, "Placed bodies"
  (`src/core/site/elementor-place.ts`): an inline-level body (a button's or linked picture's `a`, an inline-block img)
  folded into its widget box becomes its container's item — only where the widget box is a flex or grid item wherever
  the body shows; a widget box stretched across a flex column or grid cell gives the merged element `align-self` /
  `justify-self` of the line's text-align and drops a `width: 100%` taken from the widget box; any other widget box
  writes nothing and the body must already have its place (a % width refuses; in a never-wrapping row a padded or
  bordered body must keep one width over the range's measured widths); proof on the capture's boxes at every width of
  every kept range within 0.5 px; for a Button or linked Image a wrapper's px padding around the body becomes its
  margin; where the place can't be proven one labelled box stays and the notes say why. It also fixed review 1's R1-1
  (an icon Button keeps `display: none` where its wrappers hide it).
- Receipts (read, don't trust): `evidence/site-native-structure/fixer-1/` (`gates/SUMMARY.txt`, `mutation/SUMMARY.txt`,
  `probes/`, the `red-*.log` files), the earlier `builder/` (`cont/` is the second builder's), `review-1/review.json`,
  and the verifier's finding in `verifier-1-d83b68c7/`.
- The fixer's counts: natives fixture 6 of 6 Buttons alone; B-Dry stand-in (captured afresh) 15 of 17 Buttons and 4 of 5
  linked pictures alone, 552 → 531 elements, worst row 1.09 px. Still boxed, with notes: a header button whose widget
  box is 74% wide with the button at its right; a footer button in a padded holder pulled out by −5px margins; the
  phone header's logo in a 60% wide widget box.
- **Set the plan's AC6 (and the linked-picture AC) against the head and say which side is wrong:** AC6 says an
  Elementor button widget "is one Bricks Button"; the head gives a Button alone only where rule 10 proves its place,
  else one labelled box with a note. If the head is right and only the words are behind, that is a P3 naming exactly
  what the plan must say; if a real, common button shape is boxed that a sound rule could place, say which and rate it
  by the importer rule.
- Check hardest:
  - rule 10 moving a button or linked picture on a real page: a stretched widget box in a column that centres or ends
    its items; a button in a row with siblings; a grid cell; wrapping rows; a button whose alignment changes per
    Elementor breakpoint (`align-self` written per range?); right-to-left; hover and focus looks and the icon mask
    still on the merged element; the padding-to-margin move when the body's own margin or a neighbour's collapses;
  - AC11 (headings, pictures, text keep fold rule 2) and every earlier fold rule's proofs unchanged;
  - B-Dry: the header, page and footer still within 2 px at every width, both picture modes;
  - the changed tests are honest (the unit AC6 test "boxes shaped as a capture holds them"; AC14 now requires only "at
    least one Button alone" plus a note for every kept box: can it still fail on what its AC states?);
  - the fixer's `found_else` 1 (Elementor's `height: 100%` left on a merged holder: 36 px too tall in a grid that aligns
    its items to the start; the fixer moved its own fixture's case into a column): how real, and is the fixture still an
    honest proof;
  - the plain route, pastes of captures without Elementor markers and Figma conversions byte for byte as base.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the wrapper-fold lines) and `references/rendering-validation.md`, the repo `CLAUDE.md`
("Output style … editable structure first") and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs (probes on three trees where it helps: base, `d83b68c7`, head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-2/review.json`, then
   self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-r2/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of
  your own at a time, closed after. Worktree `node_modules` may lack `.bin` (put the main folder's `node_modules/.bin`
  on PATH for a scratch tree): see testing-pitfalls. Run multi-step commands from a script file written with Write;
  keep probes and logs under `~/.cache/sns-r2/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
