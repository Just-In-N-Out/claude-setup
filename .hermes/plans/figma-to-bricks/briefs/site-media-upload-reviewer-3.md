# Role: reviewer (round 3, a short delta: the move onto main; report only): site-media-upload

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees. **You never run `site:upload`,
or any upload, against anything but a stand-in WordPress on 127.0.0.1; you use no login, password or key of any kind
and never look for one; you load no live site.** (For this review you should need no upload at all.)

## What to review
The job was review-clean at `c66ded408ca965502ec0f2f7c3038645cf364532` (review 2: MOVE ON) on the old main `2879e496`. A
finisher then rebased it onto `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4,
staging-fit-renderer merged): branch `site-media-upload-stack8`, head `c1b52ce2751fe18229d5ac7484e69ec9efff3114` (the
ledger commit; the code head under it is `31a17faedb4888bba306e8dcfed37dcd96c14c7d`). It reports two conflicts, both
context-only, in `package.json` and `docs/HANDOFF.md`, and one ledger commit. **Your scope is the move alone:** is the
new head the reviewed head plus exactly the base move, with both sides kept?

In your own worktree: `git checkout --detach c1b52ce2751fe18229d5ac7484e69ec9efff3114`, confirm HEAD and a clean
status. The finisher's record: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/stack-8/`
(`range-diff.txt`, `patch-ids.txt`, `conflicts.md`, `meet/`, `logs/`).

## Check (do each yourself; don't trust the record)
1. `git range-diff 2879e496..c66ded40 7eeca437..31a17fae`: every commit `=` except the ones the finisher names (10, 14,
   27), and for those the changed lines are identical (`git show -U0 <c> | git patch-id --stable` on both sides).
2. `git diff -U0 c66ded40 31a17fae` equals `git diff -U0 2879e496 7eeca437` after dropping `^(index |@@ )` lines (the
   new head is the old head plus exactly main's move). Outside `docs/` and `package.json`, `git diff c66ded40 31a17fae`
   holds only what `git diff 2879e496 7eeca437` holds.
3. `package.json`: main's 21 script keys all present with main's values, plus `site:upload` once; valid JSON; no other
   field changed against main except what the job itself adds (compare with `git diff 7eeca437 31a17fae --
   package.json` against `git diff 2879e496 c66ded40 -- package.json`).
4. `docs/HANDOFF.md`: nothing of main's removed or reworded (`git diff 7eeca437 31a17fae -- docs/HANDOFF.md` adds lines
   only); this job's section and end-of-run entry first, then staging-fit-renderer's as main has them (Build
   2026-11-10.4, 3ds); the `<site-media-upload id at merge>` placeholders intact; the live steps still start with the
   re-capture.
5. The ledger commit `c1b52ce2` touches only the job's ledger under `docs/plans/`, says what happened truthfully, and
   holds nothing password-shaped beyond the tests' made-up password already in the repo's tests; `git diff
   --name-only 31a17fae c1b52ce2`; no CLAUDE.md; `git ls-files .superpowers/` empty; author and committer `Justin
   <issajustin04@gmail.com>` on every commit of `7eeca437..c1b52ce2`, no AI or Co-Authored-By lines.
6. One behaviour check where the sides meet, by reading and one cheap run: both typechecks on your head; the story
   pins (`F2B_STORY_PINS=1 node --test` on the AC4, AC12, AC13 files) and `test/unit/site-upload-cli.test.ts` pass (these
   start only the 127.0.0.1 stand-in). The finisher's found_else (the checks' `drawPictures` lists a library picture
   as "not drawn"; no command line reaches it today because `site:check` and `site:live` take no `--media`) is
   recorded: rate it only if you find a command line that does reach it.
Importer rule: P0–P2 only for a bug real use hits, with a scenario; the rest P3.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill's stacking
lines (`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, "Step 4"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/review-3/review.json` (round 3, a delta from
`c66ded40`), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
<your worktree> --base 7eeca437ea100c821bcfb82cdbbe516a023ff097
/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload` (exit 2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smu-r3/t1`); a
worktree's `node_modules` may lack `.bin` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH).
Scripts written with Write under `~/.cache/smu-r3/`. Any tool run uses a scratch `HOME` (link `.cache/chrome-for-testing`
and `.cache/chrome-libs` into it if a run needs Chrome), never the real `~/.config/figma-to-bricks/`. SIGTERM / 143 /
137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", `verdict`, `ac_status` (one line: the move
changes no AC's proof, or what it changes), a line confirming no upload ran against anything but a 127.0.0.1 stand-in
and no real login was used, then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
