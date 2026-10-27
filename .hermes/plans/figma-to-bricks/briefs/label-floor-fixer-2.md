# Brief: FIXER 2 for figma-to-bricks feature "label-floor" (Full pipeline)

Fix review 2's valid findings test-first, then stop at `ready-for-verify`. No merge, no rebase, no BUILD.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, reviewed HEAD 72c47b4, base cd9c1c9). Work only there; never edit the main folder.
- Approved plan (contract, read-only): `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md` (AC1–AC15; AC9 live). Worktree copy `docs/plans/2026-10-26-label-floor.md`; ledger `.superpowers/sdd/2026-10-26-label-floor/progress.md` (commit it with each fix); HANDOFF section in `docs/HANDOFF.md`.
- Review 2's report: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/review2/review2.json`; its probes (`probes/`), mutation runs (`muts/muts-r2.out.json`), shots (`shots/`) and scratch copies are in the same folder. Review 1's rulings: `~/.hermes/plans/figma-to-bricks/briefs/label-floor-fixer-1.md`. Write your evidence to `~/.hermes/plans/figma-to-bricks/evidence/label-floor/fix2/`.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FINISHER role, and `references/rules-summary.md`; only the worktree `CLAUDE.md` sections you need), `engineering-best-practices`, `receiving-code-review` (verify each finding before fixing it; push back with evidence on any that isn't valid), `test-driven-development`, `mutation-testing-discipline`.

## Review 2 findings (verdict approve-with-fixes) and the main session's ruling on each
Read each finding's full claim and evidence in `review2.json` and reproduce its probe before fixing.

- **R2-F1 (medium): a hover copy of a tight row doesn't give way.** `overlay.ts` `prune` copies `minFont` from the twin but not `giveWay`, so on hover the copy's labels grow while its row keeps the drawn gap and width (43px past its row at 1440; wraps at 1200/1024/768).
  → **Fix:** carry `twin.giveWay` onto box copies in `prune`, like tag, element and minFont. Unit test plus a Chrome test with the card hovered (the row keeps one line and its width, as the page row does).
- **R2-F2 (medium, introduced by fix 1's F2, 88b0ec0): a tight row passes its widening up to a parent that never decides.** `planGiveWay` skips the last resort whenever the parent's flow is a row, but only rows `rowOf` accepts ever decide; a hugging row, a fixed row holding only this one, a row that wraps as drawn or a divided row never check for room, so the words grow and spill or wrap with no note (probes `wrapped-group*`, `hug-parent*`: 22px past at 1440/1200, two lines at 768/375; at 6cfd9e2 they stayed drawn with a note).
  → **Fix the class conservatively:** a tight row passes its widening up only to a parent row that will decide (`rowOf` accepts it); otherwise walk up through hugging rows and apply `widens()` at the first column above; if neither has room, the last resort (words keep their drawn size, with the note, hover and phone copies included). Where uncertain, keep 6cfd9e2's output. Tests for both probe structures, a grid cell, and a control that the ruled F2 cases ("Free buttons", "Inner buttons", "Chain") keep their current output.
- **R2-F3 (low): a push grows with a widened row.** `nudgeStyle` writes a push along the row as a share of the drawn inner width, so after widening it grows by push × widen / inner, which `planGiveWay` counted at drawn px ("SEE ALL WORK" two lines at 1300/1200 with pushes 30/60/120).
  → **Fix:** make the written push and the counted need agree (take the share against inner + widen, or count the growth in the need), whichever keeps every current output byte-identical where no push meets a widening. Test with the reviewer's push probe.
- **R2-F4 (low): the last resort misses phone-only copies.** `planPhones` copies the hero and intro calls to action before `markMinFonts`; `keepDrawn` walks only the row, so the "Phone buttons" copy shows 13px on phones while the page keeps 11px. AC12 says phone copies keep the drawn size too.
  → **Fix:** where words keep their drawn size, their `copy:` nodes do too. Test with the reviewer's hero-band probe.
- **R2-F5 (low): tabs and segmented switches.** In a row of unlinked plain words with the chosen one in a round painted box, the chosen one grows 12 → 13 while its neighbours stay 12 (`currentItem` only applies when the neighbours are links).
  → **Fix, same class as F1:** the chosen item of a tab row or switch keeps its drawn size, like a menu's current item (`currentItem` accepts unlinked plain neighbours of one look, with the same holder check as menus). Keep a lone pill beside a sentence or a heading growing (control). Record "My ruling, not yet confirmed: tabs and switches keep their size, like menus" in the ledger and HANDOFF.
- **R2-F6 (low): pill words nested in a group inside the pill get the link minimum 15, not 13.** The pill rule only reads the text's direct parent.
  → **Fix:** look through unpainted wrappers (no paint, no outline, no own padding) inside a pill when finding a text's pill, so its words get 13. Test.
- **R2-F7 (low): surviving mutants N2, N7, N8, N9, N16, N17, N20, N22.**
  → Add the cheap tests (the Wide gap row's clamp ends; a box-pill current item; a tight row in a grid cell; alike cards whose planned widths differ; the menu-guard widenings) and re-run review 2's mutants (`muts/`, the script in `review1/scripts/mutate.mjs`) to show them killed. Any that is truly equivalent: document why in the ledger.

## Also at this step
- Keep the plan's AC wording; record in the ledger and HANDOFF that AC12's "inside another row" now reads "where no row or column up the chain has room" (fix 1's F2 ruling, refined here).
- Don't rebase: the final finisher rebases onto main (f46f8a2, which now owns paste check 3bl; this branch's becomes 3bm then).

## This machine
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Browser baseline at main: 12 font-environment failures, compared by name (`~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`).
- `npm run corpus` measures nothing here (Mac paths). In a scratch `git archive` copy (never the worktree), re-point corpus.json's hydraulics/gro entries to `corpus/files/` to un-skip the corpus unit tests. Measure the five files (hydraulics-home, gro-home, Repairs = repo-root debug-page-1, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) with replay and the scripts in `evidence/label-floor/corpus/`; compare with 72c47b4. Expected: byte-identical unless a fix proves a change necessary (name each).

## Gates before you stop
`npm run check` green; browser suite only the 12 known failures; five files by-id diff vs 72c47b4 with every change explained; lint no worse; AC1–AC15's named tests green; worktree clean (everything committed, scratch outside it).

## Rules
- Commit each fix separately (`git commit -m "Review 2 R2-F1: …"`, no author override, no `Co-Authored-By` or AI lines; `git diff --cached --name-only` first: CLAUDE.md never staged). Don't push, merge, rebase or bump BUILD. Don't edit the worktree's CLAUDE.md. Never bare `git stash`.
- You can't ask Justin anything. Rulings: "My ruling, not yet confirmed" in `rulings[]`, the ledger and HANDOFF. A fix needing a new product decision: stop with the options.
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; empty is normal).

## Return
`{name, status: ready-for-verify|stopped, summary, findings[{id, verdict: fixed|pushed-back|recorded, commit, test, evidence}], rulings[], last_commit, shots[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
