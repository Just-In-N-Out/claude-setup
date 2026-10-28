# FIXER 1: closing-cta → section rhythm (FigmaToBricksV2)

You are the fixer for reviewer 1's findings. Verify each finding yourself first, fix the valid ones test first, and push
back with evidence on any you find wrong. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`, branch `worktree-closing-cta`,
  head `572c793`, base `main` (`5e2f98b`). Work only there; never edit the main folder.
- Approved plan (read only; wins over the worktree copy): `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`
  (R1–R13 at line ~267; AC1–AC12, AC12 is Justin's live check).
- Reviewer 1's report: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/reviewer-1/review.json`, with its probes
  (`chrome-probe*.txt`, `probe-variants.txt`, `mutants-r1*.txt`) and scripts in `scripts/` beside it. Reuse its probe
  fixtures as the starting point for your failing tests.
- Builder's evidence: `../builder/`; ledger `.superpowers/sdd/2026-10-28-closing-cta/progress.md` (continue it, with a
  "Review 1 fixes" section). Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/fixer-1/`.
- Scratch: use your own role-named folder (e.g. `<session scratchpad>/fixer-1/`). Other roles' scratch trees (the
  builder's `base/`, the reviewer's) are not yours: never re-extract into them.

## Findings (reviewer 1, verdict request-changes)
- **F1 (high):** next to a section keeping its own space because it is drawn at a fixed height (a hero, or any
  fixed-height section), the rhythm side is `max(0, S − measured)` where measured includes the min-height slack;
  `size.unpin` releases that min height from 991px down, and `sectionSide` writes no tier value when the desktop value
  is 0, so the two sections' words touch on tablets and phones (0.0px at 991/768/390; base 67/67/48). Reviewer's
  suggestion: keep the design-width value, but step tiers against the padding that survives the unpin (the section's
  own plus its wrapper's), writing tier values even when the desktop value is 0; add both probe variants (unpainted
  fixed hero, words centred, padding 0 and 40; a mid-page fixed-height section) to AC6's Chrome test.
- **F2 (medium):** an unpainted inset card's own padding isn't in the arithmetic: between two rhythm sections the lower
  card's top padding adds on top of S, and `S − card` under its words isn't exact below the design width; the card
  subtraction has no test (mutant R2 survived). Add `closingPage({ own: [40, 40] })` to AC5 and AC6.
- **F3 (medium):** with the footer ticked, a line drawn as its own layer between the last section and the footer stays,
  as a 1px four-border box with the free gap above it and Part 1's gap below it, on top of the closing's S (259px at
  1440 where S is 96). Leave out line-only sections between the rhythm's end and a left-out footer (or the page end),
  and have `besideLeft` skip that case.
- **F8 (medium):** a top bar not recognised as the site's header becomes the "first" section, so the real hero below it
  follows the rhythm, against approved Q5 A (the first section keeps its own). Count leading one-row bars as part of the
  top so the first real section stays the hero; add the case to AC8. Make the detection structural and general (no
  names, no Home numbers).
- **F4 (low):** a kept footer drawn more than 2px over the last section is skipped by R9, but the last section's bottom is
  still replaced by S: mark it settled before the overlap `continue`.
- **F5 (low):** M19b is killable (reviewer's `mutants-r1b.txt`, `scripts/r1-probe.test.ts`): add the test that kills it
  and correct the ledger's equivalents list.
- **F6 (low):** untested guards whose mutants survived: R11 (an inset card at a fixed height counts as fixed), R12
  ("free gaps included" in the tight check), R17 (a kept header/footer counts as painted, masked because the fixture's
  footer is painted), R1 (the space carried on a wrapper Container, exercised only by Services, which isn't in the repo
  tests). Add a fixture case for each; prove each kills its mutant.
- **F7 (low):** S 120 next to a hugging hero keeping 100: the next section's top is 20 / 14 / 16 (design / tablet /
  phone), not monotone, though the pair is exact. Make the side monotone if it can be done without breaking the pair's
  exactness; otherwise say why in the ledger.
- Reviewer's rulings notes (no action unless your fix touches them): R4a sound; residual: a one-row CTA bar drawn with
  under 40px keeps 0 under its button; plan's R5: a closing CTA with a decorative layer placed on it, drawn flush with
  the footer, keeps 0 under its buttons. List these two in `open_questions` for Justin; don't change them.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (FIXER role;
   `references/rules-summary.md` first; worktree CLAUDE.md sections via grep + offset/limit). Note its lines on
   `space.ramp`, section rhythm, `size.unpin` and fixed-height sections, and two-frame fixtures.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development` (a failing test before each
   change), 5. `mutation-testing-discipline` (every new or changed guard), 6. `systematic-debugging` when anything fails
   unexpectedly.

## Done means
- Every valid finding fixed test first (the new test red on 572c793, green after), each new guard mutation-proved, each
  rejected finding answered with evidence.
- AC6's Chrome test covers the F1 and F2 variants and passes with `skipped 0`; AC5/AC8 gain the F2/F8 cases.
- `npm run check` green; the full browser suite compared by test name with base 5e2f98b (no new failures); corpus-backed
  unit tests in scratch `git archive` trees (head and base, `corpus.json` re-pointed, `node_modules` linked, a scratch
  `bin/tsc` link first on PATH) compared by test name.
- AC9 still holds: GRO and brainstorm byte-identical at all four tick settings; golden `convert-sample.json` unchanged;
  if Home/Services/Repairs output changes because of a fix, list every changed element with before → after at
  1440/768/390 and say why it is right. AC10 (Home in Chrome 120/105.9/84/84/64) still green. AC11 lint no worse
  (re-run the lint receipt if any real file's output changed).
- Ledger and HANDOFF updated (rulings changed or added, marked "not yet confirmed"); committed per passing fix.

## This machine
- Chrome: your own wrapper script in your scratch containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"`, as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; same profile for base and head; record it in the ledger.
  `npm run corpus` finds no files here; never edit `corpus/corpus.json` in the worktree. A headless Chrome (PID 232915)
  from 03:10 isn't yours: leave it alone.
- Five real files: Home `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root
  `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/services.json` (never in the worktree).
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`, heredoc then node, the word git inside a grep pattern). Write scratch scripts with Write and run
  `node <absolute script> <absolute args>`, one plain command per call. Long gates to a log ending in
  `echo EXIT=$? >> log`, then wait on it.

## Rules
- Commit to the branch after each passing fix: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI
  lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't
  bump `BUILD`. Don't edit the worktree's CLAUDE.md. Never bare `git stash`.
- Keep files under about 300 lines (`style/style.ts` is at 300: helpers go in new or existing small files).
- Don't weaken any existing test; any test you change, old → new and why, in the ledger. "Build general logic, never
  one-file fixes": no names, ids, Home numbers or section order.
- You can't ask Justin anything. On a real trade-off, rule and write "My ruling, not yet confirmed" in `rulings[]` and
  the ledger. Don't narrow the rule to make a number pass.
- If you run low on steps, commit what passes and stop with `status: stopped`, naming the last commit and what's left.
- Other bugs: `found_else` (one line each, evidence, severity). Reusable lessons: `skill_lessons[{skill, lesson,
  evidence}]` only; never edit skills or memory; empty is normal. Don't start other agents.

## Return (your final message)
`{status: ready-for-review|stopped, summary, findings_resolution[{id, valid, action, test, commit, evidence}], rulings[],
open_questions[], real_page_changes[], gates[], last_commit, ac_evidence[{ac, test, screenshot}], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
