# Brief: FINISHER (integration step only) for figma-to-bricks feature "label-floor" (Full pipeline)

Rebase the finished branch onto local `main` and close out its records, so the verifier and the blind AC auditor check the exact head that will merge. Stop at `ready-for-verify`. No merge, no BUILD, no push.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, HEAD 19b9f0c, clean, based on cd9c1c9). Work only there; never edit the main folder.
- Local `main` is f46f8a2 ("Build 2026-10-26.1: faq-answer-space"): it changed `src/core/understand/accordion.ts`, its tests and fixtures (`test/fixtures/faq.ts`, `test/unit/understand-answer-space.test.ts`, `test/unit/emit-accordion.test.ts`, `test/unit/corpus-faq-answer-space.test.ts`, `test/browser/faq-answer-space.test.ts`), its plan/ledger and `docs/HANDOFF.md`, and bumped `src/shared/build.ts`. Re-read `git rev-parse main` right before rebasing; if it moved past f46f8a2, rebase onto whatever it is and say so.
- Approved plan (read-only contract): `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md`. Evidence for this step: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/finish/`.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FINISHER role, its finish section; `references/rules-summary.md`), `engineering-best-practices`, `git-commit-rules`.

## Tasks
1. **Records first, on the branch:** move the ledger `.superpowers/sdd/2026-10-26-label-floor/progress.md` to `docs/plans/2026-10-26-label-floor-ledger.md` (git mv; the project's finish step), and make sure the plan and HANDOFF section are current (review 2's fixes, the rulings, F4's accepted approximation). Commit.
2. **Rebase:** `git rebase main`. On a conflict keep both sides' meaning; HANDOFF sections both stay. Main's faq-answer-space owns paste check **3bl**, so this feature's paste check becomes **3bm** everywhere this branch names it (HANDOFF, ledger, the worktree plan copy; never edit the read-only `plan-approved.md`). Never bare `git stash`; don't use `git rebase -i`.
3. **Gates on the rebased head:**
   - `npm run check` green.
   - Browser suite with `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`: compare failures by name with main's own run on this machine (run the suite on a `git archive` copy of main f46f8a2 too, since main gained faq-answer-space's browser tests; the baseline of 12 font-environment failures is in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`). Only failures that also fail on main are allowed.
   - Unit suite with the corpus re-pointed in a scratch `git archive` copy (corpus.json's hydraulics/gro entries → `corpus/files/`), on the rebased head and on main, compared by test name.
   - **Five files** (hydraulics-home, gro-home, Repairs = repo-root `figma-to-bricks-debug-page-1.json`, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`): replay on main f46f8a2, on 19b9f0c and on the rebased head. The rebased head must equal 19b9f0c's output plus exactly main's faq-answer-space changes, with no other difference: show the by-id diff (rebased head vs main) equals label-floor's own set (19b9f0c vs cd9c1c9), and (rebased head vs 19b9f0c) equals faq-answer-space's set (main vs cd9c1c9). Use the scripts in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/corpus/`. Any extra difference: stop and report it (an interaction between the two features).
   - Lint no worse than main at any width on the five files.
4. Worktree clean (everything committed, scratch outside it). Report the new HEAD.

## Rules
- Plain `git commit -m "…"`; no author override, no `Co-Authored-By` or AI lines; `git diff --cached --name-only` before each commit: CLAUDE.md never staged. Don't push, don't merge, don't bump BUILD, don't edit the worktree's CLAUDE.md or the main folder.
- You can't ask Justin anything. A conflict whose meaning you can't keep for both sides: stop with the options.
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; empty is normal).

## Return
`{name, status: ready-for-verify|stopped, summary, new_head, base (the main commit rebased onto), conflicts[], gates{check, browser, unit_corpus, five_files, lint}, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
