# Role: reviewer (round 5, a short delta: the hop onto the newest main; report only): panel-embed-code

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees. Never load any live site; no
logins; never write to any WordPress site; never run `npm run site:upload` against anything.

## What to review
The job was review-clean at `8fd45d25f70eb6dbad796c1f512b77b3491cf836` (review 4: MOVE ON) on an earlier main
`7eeca437`. Two jobs then merged (site-media-upload, Build 2026-11-10.5; staging-fit-cancels, Build 2026-11-10.6:
`main` is `56a9379faf207c2bfa76211dff1365db7d74be37`), and a finisher rebased this job onto it: branch
`panel-embed-code-stack11`, head `f961b365ee7305b2a48e459051f8cf4e282bd382` (the ledger commit; the code head under it
is `c0f504f46c30ea551fc07fd5cd3860c263bcd2bf`). It reports one context-only conflict in `docs/HANDOFF.md` and one
ledger commit. **Your scope is the hop alone:** is the new head the reviewed head plus exactly main's move, with both
sides kept, and do the jobs fit where they meet?

In your own worktree: `git checkout --detach f961b365ee7305b2a48e459051f8cf4e282bd382`, confirm HEAD and a clean
status. The finisher's record: `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/stack-11/`
(`range-diff.txt`, `patch-ids.txt`, `conflicts.md`, `resolutions/`, `pins.md`, `meet/`, `logs/`).

## Check (do each yourself; don't trust the record)
1. `git range-diff 7eeca437..8fd45d25 56a9379f..c0f504f4`: every commit `=` except the one the finisher names, and for
   it the changed lines are identical (`git show -U0 <c> | git patch-id --stable` on both sides).
2. `git diff -U0 8fd45d25 c0f504f4` equals `git diff -U0 7eeca437 56a9379f` after dropping `^(index |@@ )` lines.
   Outside `docs/`, `git diff 8fd45d25 c0f504f4` holds only what `git diff 7eeca437 56a9379f` holds.
3. `docs/HANDOFF.md`: nothing of main's removed or reworded (`git diff 56a9379f c0f504f4 -- docs/HANDOFF.md`: the only
   removed lines are this job's own intended edits, which the same diff on the old base also removes: compare the two
   diffs' `-` lines); this job's section and end-of-run entry first, then staging-fit-cancels' (Build 2026-11-10.6,
   3du) and site-media-upload's (Build 2026-11-10.5, 3dt) as main has them; the `<panel-embed-code id at merge>`
   placeholders intact. (To rebuild a docs-only resolution in an isolated worktree: save the three files with
   separate `git show <sha>:<path>` calls into scratch, `diff3 -m ours base theirs`, resolve ours first, `cmp` with
   head's file.)
4. The ledger commit `f961b365` touches only the job's ledger under `docs/plans/` and says what happened truthfully;
   no CLAUDE.md; `git ls-files .superpowers/` empty; author and committer `Justin <issajustin04@gmail.com>` on every
   commit of `56a9379f..f961b365`, no AI or Co-Authored-By lines.
5. **Where the jobs meet** (one probe of your own, local fixtures only; this job's guard: a pasted Code element runs
   only a widget's own code): a capture holding a live widget and a floating widget beside the site's own pictures,
   converted on the code route with a media map that also names the widget's own files and pictures (a "hostile"
   map): the widget's Code element's code is byte for byte the same with and without the map (a widget's tag is
   never rewritten to a library address), and the site's own pictures become library pictures; the panel route as on
   the old head. A live widget's inner box (site-reviews' `inside`) prints as a bounded block on head, as on main,
   with the Code element's code and notes unchanged.
6. **The pins:** this job's AC9 sums (`F2B_UNCHANGED_SUMS=1`) and `test/unit/site-no-revert.test.ts` pass on the head;
   site-media-upload's env-gated story pin (`F2B_STORY_PINS=1`, `site-media-unchanged`) fails on the head exactly as
   on main (`saved.elementor-stretch`, moved by staging-fit-cancels by design: that merged job's receipt, not
   regenerated): check only that head's failing entries equal main's.
7. `npm run check` on your head (the parallel unit suite may need an 8G scope); both typechecks (the sandbox config
   too).
Importer rule: P0–P2 only for a bug real use hits, with a scenario; the rest P3.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill's stacking
lines (`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, "Step 4"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-5/review.json` (round 5, a delta from
`8fd45d25`), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
<your worktree> --base 56a9379faf207c2bfa76211dff1365db7d74be37
/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code` (exit 2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
(`~/.cache/pec-r5/t1`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time,
closed after: stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a worktree's `node_modules`
may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar; never
chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Scripts written with Write under
`~/.cache/panel-embed-code-review5/`. Heavy runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`
(export variables first, no `--setenv=PATH`). SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since
"-30 min" -o short-iso | grep sending`). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", `verdict`, `ac_status` (one line: the hop
changes no AC's proof, or what it changes), then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
