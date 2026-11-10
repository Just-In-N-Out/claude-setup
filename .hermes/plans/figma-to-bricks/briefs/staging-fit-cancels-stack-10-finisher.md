# Finisher (step 1, in a copy): stack 10 — move staging-fit-cancels onto the new main

You are a fresh finisher (**Opus 5.5, high**). One job has merged since this job was last moved: local `main` is now
`f40ce6ce729af831186dab85c673653d7187744e` (Build 2026-11-10.5: site-media-upload merged, with its build commit).
staging-fit-cancels is review-clean (review 2: MOVE ON) on the **previous** main: branch `staging-fit-cancels-stack7`,
head `ce5b38acbb959c12218e319560608c660c753b70`, base `7eeca437ea100c821bcfb82cdbbe516a023ff097`. Files both sides
changed: `docs/HANDOFF.md` only. (site-media-upload changed `src/core/site/{media,kinds,convert,parts}.ts`,
`src/ui/uploader.ts`, `package.json` and added `tools/site-upload.ts` and tests; this job changes
`src/core/site/{blocks,classes,controls}.ts` and tests: no shared source file.)

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site; no
logins; never write to any WordPress site; **never run `npm run site:upload` against anything** (its tests start only
their own 127.0.0.1 stand-in). Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-cancels-stack10 ce5b38acbb959c12218e319560608c660c753b70` then `git rebase --onto main
7eeca437ea100c821bcfb82cdbbe516a023ff097` (check `git rev-parse main` = `f40ce6ce…`; if main moved again, use it and
say so).

## Rules
- **A rebase with no conflict gets no new commit at all** (the branch stays a pure rebase; touch no file).
- **A rebase with a conflict:** keep both sides' meaning (HANDOFF: every section stays, this job's first, then main's
  lines exactly as main has them — site-media-upload's section and end-of-run entry now read Build 2026-11-10.5 and
  3dt; this job's `<staging-fit-cancels id at merge>` / `<at merge>` placeholders stay). Resolve the same way in every
  commit of this job that touches HANDOFF. Record each conflict and its resolution in this job's ledger (find it under
  `docs/plans/`) as the branch's last commit, and say so plainly: a conflicted rebase is reviewed before the job is
  verified. A conflict outside `docs/` is not expected: if one appears, stop and report it exactly.
- Prove every patch unchanged: `git range-diff 7eeca437..ce5b38ac main..<new head before any ledger commit>`;
  patch-ids commit by commit (`git show --full-index <c> | git patch-id --stable`); for a context-only conflict the
  `-U0` patch-id of that commit; and `git diff -U0 ce5b38ac <new head before any ledger commit>` equal to `git diff
  -U0 7eeca437 f40ce6ce` after dropping `^(index |@@ )` lines.
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Where the sides meet (probe on the rebased head; local fixtures only)
site-media-upload's media map turns a mapped picture's address into a library picture in Image settings and in CSS
`url()` values (backgrounds, masks) inside the classes this job prints. Convert one fixture capture that has a CSS
background at a width range a narrower range drops or changes (or the job's own range fixtures with a hand-made media
map naming a background), with and without the map, plain and `--elementor`: the bounded runs this job writes carry
the library address wherever main's blocks did, no `revert` appears, and without a map the paste is byte for byte this
job's old head's. site-media-upload's story pins (`F2B_STORY_PINS=1`: its AC4 "without a media map every paste is byte
for byte as main makes it") **compare with main's pastes, which this job changes by design where a range drops a
declaration**: run them on the rebased head; if one fails, prove by the four trees (old main `7eeca437`, old head
`ce5b38ac`, new main, new head; same inputs) that it moves only by this job's change, record the table, and **stop on
it** (regenerating a pin is a fixer's job, never yours).

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH
and symlink the main folder's `node_modules` in; a piped, chained or redirected git command is refused: `git archive
-o <file> <sha>` in its own call, then untar): both typechecks and `npm run check` (the parallel unit suite may need an
8G scope); this job's AC tests (`test/web/site-range-cancels.test.ts` alone under `systemd-run --user --scope -p
MemoryMax=4G -p MemorySwapMax=0`, export variables first, no `--setenv=PATH`; `test/unit/site-no-revert.test.ts`,
`site-runs`); `test/unit/plugin-convert.test.ts`. Each log starts `HEAD=` and ends with one line `EXIT=`. Stop and
report if anything fails that isn't a named flake (the code-page fixture's 5.09 px load flake).

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/stack-10/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md` or "none", `meet/`, `logs/`), scripts under `~/.cache/sfc-s10/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-s10/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (stop it by the PIDs of
its own profile path; never `pkill -f <pattern>`). Multi-step commands from a script file written with Write. SIGTERM /
143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s.
The PC lost power twice this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line; when
resumed, check `git status` and `git cat-file -t HEAD`, and read your finished logs first.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA), "a pure rebase: every patch-id equal" or the conflicts and
resolutions commit by commit with the ledger commit; where the sides meet: what you probed and saw (and any pin you
stopped on, with its four-tree table); each gate's result; then `found_else`, then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check
and save these skill_lessons now.`
