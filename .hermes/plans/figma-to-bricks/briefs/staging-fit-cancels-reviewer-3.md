# Role: reviewer (round 3, a short delta: the hop onto the newest main; report only): staging-fit-cancels

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees. Never load any live site; no
logins; never write to any WordPress site; never run `npm run site:upload` against anything.

## What to review
The job was review-clean at `ce5b38acbb959c12218e319560608c660c753b70` (review 2: MOVE ON) on the previous main
`7eeca437`. One job then merged (site-media-upload, Build 2026-11-10.5: `main` is
`f40ce6ce729af831186dab85c673653d7187744e`), and a finisher rebased this job onto it: branch
`staging-fit-cancels-stack10`, head `4a352ffd1dd34210512abfc9abe3e23df3858c2f` (the ledger commit; the code head under
it is `f05f9759d1f846e9683994c89f8bdba163a5c661`). It reports one context-only conflict in `docs/HANDOFF.md` and one
ledger commit. **Your scope is the hop alone:** is the new head the reviewed head plus exactly main's move, with both
sides kept, and do the two jobs fit where they meet?

In your own worktree: `git checkout --detach 4a352ffd1dd34210512abfc9abe3e23df3858c2f`, confirm HEAD and a clean
status. The finisher's record: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/stack-10/`
(`range-diff.txt`, `patch-ids.txt`, `conflicts.md`, `meet/meet.md`, `meet/pin-four-trees.md`, `logs/`).

## Check (do each yourself; don't trust the record)
1. `git range-diff 7eeca437..ce5b38ac f40ce6ce..f05f9759`: every commit `=` except the ones the finisher names, and for
   those the changed lines are identical (`git show -U0 <c> | git patch-id --stable` on both sides).
2. `git diff -U0 ce5b38ac f05f9759` equals `git diff -U0 7eeca437 f40ce6ce` after dropping `^(index |@@ )` lines.
   Outside `docs/`, `git diff ce5b38ac f05f9759` holds only what `git diff 7eeca437 f40ce6ce` holds.
3. `docs/HANDOFF.md`: nothing of main's removed or reworded (`git diff f40ce6ce f05f9759 -- docs/HANDOFF.md` adds lines
   only); this job's section and end-of-run entry first, then site-media-upload's as main has them (Build
   2026-11-10.5, 3dt); the `<staging-fit-cancels id at merge>` placeholders intact. (To rebuild a docs-only resolution
   in an isolated worktree: save the three files with separate `git show <sha>:<path>` calls into scratch, `diff3 -m
   ours base theirs`, resolve ours first, `cmp` with head's file.)
4. The ledger commit `4a352ffd` touches only the job's ledger under `docs/plans/` and says what happened truthfully;
   no CLAUDE.md; `git ls-files .superpowers/` empty; author and committer `Justin <issajustin04@gmail.com>` on every
   commit of `f40ce6ce..4a352ffd`, no AI or Co-Authored-By lines.
5. **Where the jobs meet** (one probe of your own, local fixtures only): site-media-upload's media map turns a mapped
   picture into a library address in Image settings and in CSS `url()` values inside the classes this job prints as
   bounded runs. Convert one capture holding a CSS background that a width range drops or changes, with a hand-made
   media map naming it, plain and `--elementor`: every `url()` of that picture in the bounded blocks is the library's;
   no `revert` outside the site-reset class and the job's two named exceptions; without a map the paste is byte for
   byte the old head's (`ce5b38ac`). `sourceUrl` is set as on main.
6. **The story pin, not a finding by itself:** site-media-upload's AC4 pin (`F2B_STORY_PINS=1`,
   `test/unit/site-media-unchanged.test.ts`: "without a media map every paste is byte for byte as main makes it") fails
   on the rebased head for `saved.elementor-stretch` only. It is that merged job's story-time receipt, kept out of the
   default suite, and this job changes those pastes by design (the three boxes where main wrote `flex-*: revert`). It
   is **not** regenerated. Check the claim only: on four `git archive` trees (old main `7eeca437`, old head `ce5b38ac`,
   new main, new head) the sums read old main = new main = the golden, old head = new head, and no other capture of
   the pin moves; and that the default suite (`npm run check`) is green on the head. Report a finding only if the pin
   moves for another reason or another capture moves.
7. `npm run check` on your head (the parallel unit suite may need an 8G scope); both typechecks;
   `test/unit/site-no-revert.test.ts` and `site-runs`.
Importer rule: P0–P2 only for a bug real use hits, with a scenario; the rest P3.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill's stacking
lines (`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, "Step 4"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/review-3/review.json` (round 3, a delta from
`ce5b38ac`), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
<your worktree> --base f40ce6ce729af831186dab85c673653d7187744e
/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels` (exit 2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-r3/t1`); a
worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar).
Scripts written with Write under `~/.cache/sfc-r3/`. Heavy runs under `systemd-run --user --scope -p MemoryMax=8G -p
MemorySwapMax=0` (export variables first, no `--setenv=PATH`). SIGTERM / 143 / 137 may be earlyoom (`journalctl -u
earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", `verdict`, `ac_status` (one line: the hop
changes no AC's proof, or what it changes), the pin's four-tree result, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
