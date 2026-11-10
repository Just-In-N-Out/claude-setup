# Finisher (step 1, in a copy): stack 11 — move panel-embed-code onto the new main

You are a fresh finisher (**Opus 5.5, high**). Two jobs have merged since this job was last moved: local `main` is now
`56a9379faf207c2bfa76211dff1365db7d74be37` (Build 2026-11-10.6: site-media-upload as Build 2026-11-10.5 and
staging-fit-cancels as Build 2026-11-10.6, each with a build commit). panel-embed-code is review-clean (review 4: MOVE
ON) on an earlier main: branch `panel-embed-code-stack9`, head `8fd45d25f70eb6dbad796c1f512b77b3491cf836`, base
`7eeca437ea100c821bcfb82cdbbe516a023ff097`. Files both sides changed: `docs/HANDOFF.md` only. (site-media-upload changed
`src/core/site/{media,kinds,convert,parts}.ts`, `src/ui/uploader.ts`, `package.json`, added `tools/site-upload.ts`;
staging-fit-cancels changed `src/core/site/{blocks,classes,controls}.ts`; this job changes
`src/core/snapshot/embed-code.ts`, `src/core/normalise/{embeds,floating}.ts`, `src/core/site/live.ts`,
`src/web/read/{tracker,floating}.ts`, `src/web/map/snippets.ts`, `src/web/assemble.ts`, `src/core/snapshot/web.ts` and
tests: no shared source file.)

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging, a widget vendor's
host or any live site; no logins; never write to any WordPress site; never run `npm run site:upload` against anything.
Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B panel-embed-code-stack11 8fd45d25f70eb6dbad796c1f512b77b3491cf836` then `git rebase --onto main
7eeca437ea100c821bcfb82cdbbe516a023ff097` (check `git rev-parse main` = `56a9379f…`; if main moved again, use it and
say so).

## Rules
- **A rebase with no conflict gets no new commit at all** (the branch stays a pure rebase; touch no file).
- **A rebase with a conflict:** keep both sides' meaning (HANDOFF: every section stays, this job's first, then main's
  lines exactly as main has them — site-media-upload's and staging-fit-cancels' sections and end-of-run entries now
  read their builds and ids, 3dt and 3du; this job's `<panel-embed-code id at merge>` / `<at merge>` placeholders
  stay). Resolve the same way in every commit of this job that touches HANDOFF. Record each conflict and its
  resolution in this job's ledger (find it under `docs/plans/`) as the branch's last commit, and say so plainly: a
  conflicted rebase is reviewed before the job is verified. A conflict outside `docs/` is not expected: if one
  appears, stop and report it exactly.
- Prove every patch unchanged: `git range-diff 7eeca437..8fd45d25 main..<new head before any ledger commit>`;
  patch-ids commit by commit (`git show --full-index <c> | git patch-id --stable`); for a context-only conflict the
  `-U0` patch-id of that commit; and `git diff -U0 8fd45d25 <new head before any ledger commit>` equal to `git diff
  -U0 7eeca437 56a9379f` after dropping `^(index |@@ )` lines.
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Where the sides meet (probe on the rebased head; local fixtures only)
- **site-media-upload:** a capture holding a live or floating widget beside the site's own pictures, converted on the
  code route with a media map (`npm run site … --media`, a hand-made map): this job's Code elements and empty boxes
  are untouched by the map (a widget's own tag is never rewritten to a library address; a picture inside a pasted
  widget's markup stays as served), and the site's own pictures still become library pictures. The panel route
  (`convert()` with the capture) with and without the panel's own uploads behaves as on the old head.
- **staging-fit-cancels:** a live widget's inner boxes (site-reviews' `inside`) now print as bounded runs: this job's
  live Code element (`src/core/site/live.ts`) and its notes are as on the old head; the default-suite pin
  `test/unit/site-no-revert.test.ts` passes on the rebased head (this job changes no code-route paste: if it fails,
  record the proof and stop on it).
- This job's "unchanged sums" (`F2B_UNCHANGED_SUMS=1`, AC9) pin the base's pastes: staging-fit-cancels changed
  code-route classes where a range dropped a declaration, so a sum can be stale on the new main. If one fails, prove
  by four trees (old main `7eeca437`, old head `8fd45d25`, new main, new head; the same saved inputs) that the entry
  moves only by the merged job's change, record the table and **stop on it** (regenerating a pin is a fixer's job).
  A merged job's env-gated story pin (`F2B_STORY_PINS=1`) is that job's receipt: if this job moves one by design,
  record the table and move on.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH
and symlink the main folder's `node_modules` in; a piped, chained or redirected git command is refused: `git archive
-o <file> <sha>` in its own call, then untar; never chain a git command after a `cd` into a scratch folder: `git -C
<absolute path>`): both typechecks and `npm run check` (the parallel unit suite may need an 8G scope); the job's unit
files with `F2B_UNCHANGED_SUMS=1`, `plugin-convert`, `sandbox-convert`; the job's web files
(`panel-floating-chain`, `floating-holds`, `tracker-stack`, `capture-floating`, `capture-embeds`, `panel-embed-code`),
each alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first, no
`--setenv=PATH`). Each log starts `HEAD=` and ends with one line `EXIT=`. Stop and report if anything fails that
isn't a named flake (`capture-entrances` R8-1; the code-page fixture's 5.09 px load flake).

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/stack-11/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md` or "none", `meet/`, `logs/`), scripts under `~/.cache/panel-embed-code-stack11/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
(`~/.cache/pec-s11/t1`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start
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
