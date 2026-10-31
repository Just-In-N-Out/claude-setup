# Finisher brief: website importer wave 1 (web-capture J1 + web-compare J0), before the merge

**Role:** finisher (fresh Opus 5.5, xhigh). Justin (2026-10-31): "I need this to be built fast … stop the fixes and just
keep building." Both jobs' fix rounds are over: their last fix passes (web-capture fix 10, web-compare fix 7) go in
without another review, at his word. Your job is to put both on top of local `main` in one line, prove the combined
tree passes, and stop. Never stop to ask; decide and record.

**Skills:** load `git-commit-rules` and `engineering-best-practices` with the Skill tool; read the project skill with
Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`. Read the repo's CLAUDE.md "Finish" steps
(step 1 is yours).

## Steps (in your agent worktree; local `main` is at `@MAIN@`)

1. **web-capture:** `git checkout --detach @CAP@` then `git switch -c web-capture-final`. Move the ledger
   `.superpowers/sdd/2026-10-29-web-capture/progress.md` to `docs/plans/2026-10-29-web-capture-ledger.md`; in HANDOFF's
   web-capture section add one line: fix pass 10 merged without a review at Justin's word (2026-10-31), its rulings
   F40–F42 not yet confirmed; append `~/.hermes/plans/figma-to-bricks/evidence/web-capture/follow-ups.md`'s open items to
   HANDOFF "Deferred" where they aren't already. Commit. Then `git rebase main`.
2. **web-compare:** `git checkout --detach @CMP@` then `git switch -c web-compare-final`. The same for its ledger
   (`.superpowers/sdd/2026-10-29-web-compare/progress.md` → `docs/plans/2026-10-29-web-compare-ledger.md`), its
   HANDOFF line (fix pass 7 unreviewed, its rulings not yet confirmed, named limits as fix 7 left them) and its
   `evidence/web-compare/follow-ups.md`. Commit. Then `git rebase web-capture-final`, so one line holds both.
3. **Conflicts:** keep both sides' meaning. HANDOFF sections both stay. The two jobs share the `test:web` script line
   in `package.json` and the `Page.cdp(method, params)` method, written character for character the same: keep one.
   If the rebase stops on a real code conflict, resolve it, run that file's tests, and list it in your report.
4. **Gates on `web-compare-final`'s head** (the combined tree), each compared by test name with `main` (`@MAIN@`):
   both typechecks, `npm run check`, `npm run test:web` (`skipped 0` apart from AC14's live sites, which need
   `F2B_WEB_SITES`), `npm run test:browser`, `npm run corpus`, and the five real Figma files replayed byte-identical
   with `main`. A failure that main doesn't have and that comes from putting the two together: fix it test first in the
   smallest way, commit, and list it. A failure main has too: name it, don't fix it. Never weaken a test.
5. **Stop and report.** Don't merge, push, bump `BUILD` or touch the main folder.

## Rules

- Plain `git commit -m`, no author override, no AI lines; `git diff --cached --name-only` holds no CLAUDE.md. Never bare
  `git stash`; never `reset --hard` a branch you didn't make; leave `web-capture-fix-10`, `web-compare-fix-7` and every
  other copy alone.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` short (`~/.cache/w1-finish/tmp`). Long gates as a
  script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. In this worktree-isolated
  session write multi-step scripts with the Write tool and run `bash <file>`; run git commands as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it.** Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site.
- Receipts and logs in `~/.hermes/plans/figma-to-bricks/evidence/website-importer-wave1/finisher/`.

## Report

`web-capture-final` head, `web-compare-final` head (the one to merge; it holds both), what each rebase did (conflicts
and how resolved), gate tallies against `main` by test name (say plainly any that failed or didn't run), any fix you
made, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
