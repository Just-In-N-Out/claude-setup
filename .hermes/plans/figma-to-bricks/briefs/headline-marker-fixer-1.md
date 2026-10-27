# FIXER 1 — headline-marker (FigmaToBricksV2)

Fix the valid findings of reviewer 1 on `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`
(branch `worktree-headline-marker`, head bb86429, base main f46f8a2). The approved plan's read-only copy:
`~/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`. The review with its probes:
`~/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-1/` (read its probes before fixing).

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review` (verify each finding before fixing;
push back with evidence on any you find invalid), `test-driven-development` (a failing test first for every fix),
`mutation-testing-discipline` (run any harness detached with a marker file naming the mutated file; a session restart
kills its process group), `git-commit-rules`.

## Findings to verify and fix (test first, one commit each)
- **F1 (medium):** `normalise/text-lines.ts:62-63` takes a one-line text's line height from its box and anchors line
  tops at `box.y`, so a one-line text in a taller box (textAutoResize NONE, fill height, a trailing empty line) or a
  vertically centred/bottom-aligned box squashes the mark and the ring cuts through the words. Take a single line's
  height from the text's own line height when known and smaller than the box; place line tops from the baselines and
  the vertical alignment. Test NONE-height and fill-height one-line headings (unit and the AC9 browser width sweep).
- **F2 (medium):** `understand/headings.ts:29-39` `joined` keeps only the first piece's marks, so a ring on a later
  stacked piece vanishes while the panel claims success. Carry each later piece's marks shifted by its offset in the
  joined characters; add a test (ring on piece 2).
- **F3 (medium):** `normalise/marks.ts` `ownLook`/`standsOut`: when the circled words hold most of the text's letters
  they count as the text's own style, the stroke stays placed and the note asks for a style they already have (short
  headings like "Over 60 Years"). A covered chunk stands out when some other chunk has a different look; keep the
  single-style-line rule (Q4A). Test the short-heading case.
- **F4 (low):** the 8 surviving reviewer mutants (R1 the R10 Button/copy guard; R2 turned text; R3 an emptied parent
  frame kept; R4 a flat stroke on line 2 read as an underline of line 1; R5 a whole single-style line marked; R6
  `sweepFor` unchecked numbers; R7 the trailing space trimmed from the words' box; R8 the between-lines guard): add a
  generic test for each (at least R10, the whole-line mark, the trailing space, the second-line underline/strike) and
  re-run the mutants with a load hook or a detached harness with a marker file; record each kill.
- **F5 (low):** `style/typography.ts` `markGroups` widens a mark to a link or phone number that fully contains it;
  widen only when another group crosses a mark edge partly. Test a styled part of a phone number.
- **found_else (low, small):** `text-lines.ts` `decode` throws on an out-of-range `&#…;` entity: guard it (keep the
  text as is) with a test.
- The reviewer's evidence: `~/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-1/` (probes/ reproduce
  F1–F3, F5; mutation/ has F4's mutants and harness).

## Gates after the fixes
`npm run check` (0 fail); the headline-marker browser file alone with `skipped 0`; the full browser suite compared by test name with
main's; replays of hydraulics, GRO, debug-page-1 (a scratch copy) and brainstorm byte-identical to main (bricks.json and warnings.txt); the corpus-skipped unit tests in
scratch git-archive trees (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
`export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Run gates in the foreground. Keep every changed file
under ~300 lines. Update HANDOFF, the ledger and the plan copy for any changed ruling.

## Rules
Commit to the branch (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump
BUILD, never edit the main folder, never bare `git stash`. Other features are building or in review in their own worktrees; don't touch them.

## Report
Return `{name, status: ready-for-review|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, found_else[], skill_lessons[{skill, lesson, evidence}]}` and end with
`MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.

Paste check id stays 3bo. Long gates: write the log with an end marker (`echo EXIT=$? >> log`) and wait with
`until grep -q '^EXIT=' log; do sleep 2; done`; a foreground call is moved to the background after ~180s.
