# Finisher (step 1, in a copy): stack 14 — move control-weight onto the new main

You are a fresh finisher (**Opus 5.5, high**). One job has merged since this job was last moved: local `main` is now
`7ec16d6060a76b441e42581b78ad3a502461fd66` (Build 2026-11-10.7: panel-embed-code merged, with its build commit).
control-weight is review-clean (review 3: MOVE ON) on the **previous** main: branch `control-weight-fix2`, head
`8ec7d0ee9290ee68bce0115a9498fc86283b6f7d` (14 commits), base `56a9379faf207c2bfa76211dff1365db7d74be37`. Files both
sides changed: `docs/HANDOFF.md` only. (panel-embed-code changed `src/core/snapshot/{embed-code,web}.ts`,
`src/core/normalise/{embeds,floating}.ts`, `src/core/site/live.ts`, `src/web/read/{tracker,floating}.ts`,
`src/web/map/snippets.ts`, `src/web/assemble.ts` and tests; this job changes `src/core/site/inline-own.ts`, nine lines
of `src/core/site/convert.ts` and tests: no shared source file.)

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site; never run `npm run site:upload` against anything. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B control-weight-stack14 8ec7d0ee9290ee68bce0115a9498fc86283b6f7d` then `git rebase --onto main
56a9379faf207c2bfa76211dff1365db7d74be37` (check `git rev-parse main` = `7ec16d60…`; if main moved again, use it and
say so).

## Rules
- **A rebase with no conflict gets no new commit at all** (the branch stays a pure rebase; touch no file).
- **A rebase with a conflict:** keep both sides' meaning (HANDOFF: every section stays, this job's first, then main's
  lines exactly as main has them — panel-embed-code's section and end-of-run entry now read Build 2026-11-10.7 and
  3dv; this job's `<control-weight id at merge>` placeholders stay; the merged bullet this job wrote into
  staging-fit-cancels' Known limits stays as this job's head has it). Resolve the same way in every commit of this
  job that touches HANDOFF. Record each conflict and its resolution in this job's ledger
  (`docs/plans/2026-11-10-control-weight-ledger.md`) as the branch's last commit, and say so plainly: a conflicted
  rebase is reviewed before the job is verified. A conflict outside `docs/` is not expected: if one appears, stop and
  report it exactly.
- Prove every patch unchanged: `git range-diff 56a9379f..8ec7d0ee main..<new head before any ledger commit>`;
  patch-ids commit by commit (`git show --full-index <c> | git patch-id --stable`); for a context-only conflict the
  `-U0` patch-id of that commit; and `git diff -U0 8ec7d0ee <new head before any ledger commit>` equal to `git diff
  -U0 56a9379f 7ec16d60` after dropping `^(index |@@ )` lines.
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Where the sides meet (probe on the rebased head; local fixtures only)
panel-embed-code changed what the capture records for floating widgets and embeds and what the panel route pastes;
it changed no code-route class. Convert the shape fixtures (`range-cancels`, `inline-nested`, `inline-overlap`:
captured fresh with the rebased head's capture code, since the capture's tracker changed) on both trees: the pastes
equal the old head's (`8ec7d0ee`) for the same capture, and a capture made by the new tracker gives the same
code-route pastes as one made by the old (the inline readings don't depend on the tracker). This job's AC4 byte test
by name against base `main` `7ec16d60` passes (47 captures; only captures holding the shape differ). The default-suite
pins pass (`test/unit/site-no-revert.test.ts`; panel-embed-code's `F2B_UNCHANGED_SUMS=1` sums: this job changes
code-route pastes only for captures holding the shape — if a sum fails, prove by four trees that it moves only by this
job's design, record the table and **stop on it**: regenerating a pin is a fixer's job). A merged job's env-gated
story pin (`F2B_STORY_PINS=1`) is that job's receipt: record and move on.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH
and symlink the main folder's `node_modules` in; put multi-step git work in a script file run with `bash <file>`, with
`git -C <absolute path>`): both typechecks and `npm run check` (the parallel unit suite may need an 8G scope); the
job's tests (`test/unit/site-inline-own.test.ts`; `test/web/site-range-cancels.test.ts` and
`test/web/site-inline-nested.test.ts`, each alone under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0`, export variables first, no `--setenv=PATH`); `test/unit/plugin-convert.test.ts`. Each log starts
`HEAD=` and ends with one line `EXIT=`. Stop and report if anything fails that isn't a named flake (the code-page
fixture's 5.09 px load flake).

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/stack-14/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md` or "none", `meet/`, `logs/`), scripts under `~/.cache/control-weight-stack14/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
(`~/.cache/cw-s14/t1`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start
(stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). Multi-step commands from a script file
written with Write. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
sending`). Waits under 115 s. The PC lost power twice this week and agents were stopped by a usage limit twice: write
each log's `EXIT=` line; when resumed, check `git status` and `git cat-file -t HEAD`, and read your finished logs first.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA), "a pure rebase: every patch-id equal" or the conflicts and
resolutions commit by commit with the ledger commit; where the sides meet: what you probed and saw (and any pin you
stopped on, with its four-tree table); each gate's result; then `found_else`, then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check
and save these skill_lessons now.`
