# Role: reviewer (round 4, a short delta: the move onto main, stack 14; report only): control-weight

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees. Never load any live site; no
logins; never write to any WordPress site; never run `npm run site:upload` against anything.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, with a concrete real-use
scenario; edge cases are P3. The job's own three review rounds are done (review 3: MOVE ON at
`8ec7d0ee9290ee68bce0115a9498fc86283b6f7d` on main `56a9379faf207c2bfa76211dff1365db7d74be37`). This round exists only
because the job was then rebased onto a newer main with one conflict: a conflicted rebase is reviewed before the job
is verified. Keep it short and exact.

## What to review
The job (on the website importer's code route, an element its parent reads as an inline word at some widths carries
those widths in its own class, at every depth the reading nests) was moved by a finisher onto local `main`
`7ec16d6060a76b441e42581b78ad3a502461fd66` (Build 2026-11-10.7: panel-embed-code merged). Branch
`control-weight-stack14`, head `90437f41fe20826125d376821cbabf41d861db54` (14 rebased commits ending at
`1ea9f5cf982c5550d39e207f408b27ac9014308a`, then one ledger commit, docs only). The finisher reports one conflict, in
`docs/HANDOFF.md` only, context only (commit 4 of 14, `37250f54` → `d285c69e`: this job's section and main's
panel-embed-code section inserted at the same place; resolved as this job's first, then main's as main has it).

**Your scope: the move.** That is: (a) is every patch unchanged, (b) is the conflict resolved keeping both sides'
meaning, (c) does the job still do what review 3 accepted on the new main (where panel-embed-code changed
`src/core/snapshot/{embed-code,web}.ts`, `src/core/normalise/{embeds,floating}.ts`, `src/core/site/live.ts`,
`src/web/read/{tracker,floating}.ts`, `src/web/map/snippets.ts`, `src/web/assemble.ts` and tests; this job changes
`src/core/site/inline-own.ts`, nine lines of `src/core/site/convert.ts` and tests), (d) the ledger commit says only
what is true.

In your own worktree: `git checkout --detach 90437f41fe20826125d376821cbabf41d861db54`, confirm HEAD and a clean
status. The finisher's receipts (read, don't trust):
`/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/stack-14/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md`, `resolutions/`, `meet/`, `logs/`). Recorded limits (not findings unless you rate one higher, with a
scenario): `evidence/control-weight/follow-ups.md` and HANDOFF's "Known limits" in the job's section.

## Check (do each yourself)
1. **Patches unchanged:** your own `git range-diff 56a9379f..8ec7d0ee 7ec16d60..1ea9f5cf` (13 `=`, 1 `!` whose
   difference is context only); `git diff -U0 8ec7d0ee 1ea9f5cf` equals `git diff -U0 56a9379f 7ec16d60` after
   dropping `^(index |@@ )` lines; every path the branch changes against main other than `docs/HANDOFF.md` and the
   ledger is byte for byte the old head's blob (`git ls-tree`), CLAUDE.md in no commit, `git ls-files .superpowers/`
   empty.
2. **The conflict:** HANDOFF at head holds this job's section whole (as at `8ec7d0ee`) and main's sections whole (as
   at `7ec16d60`: panel-embed-code's reads Build 2026-11-10.7 and 3dv), no line lost, doubled or reordered inside a
   section, the end-of-run check list holding both jobs' entries; this job's `<control-weight id at merge>`
   placeholders still placeholders; the bullet this job wrote into staging-fit-cancels' Known limits as at
   `8ec7d0ee`. The ledger commit (`git show 90437f41`): docs only, and each claim in its "Stack 14" section true
   against what you measured.
3. **Where the sides meet (local fixtures only):** convert the job's shape fixtures (`range-cancels`,
   `inline-nested`, `inline-overlap`), captured fresh with head's capture code, on head and on main `7ec16d60`: head's
   pastes carry the widths in the element's own class as review 3 saw; main's don't. One probe of your own that both
   jobs touch: a page holding a third-party widget slot or floating widget **and** an inline-read link (the shape of
   `inline-nested` beside one of panel-embed-code's fixtures, `test/fixtures/sites/embeds-*`): the Code element and its
   note are byte for byte as on main, and the inline-read element carries its widths. The job's AC4 byte test by name
   against base main `7ec16d60`.
4. **Gates:** both typechecks (the sandbox config too) and `npm run check` on head (the parallel unit suite may need
   an 8G scope); `test/unit/site-inline-own.test.ts`, `test/unit/site-no-revert.test.ts`,
   `test/unit/plugin-convert.test.ts`; the job's web files (`site-inline-nested`, `site-range-cancels`), each alone
   under the cap; panel-embed-code's sums with `F2B_UNCHANGED_SUMS=1` on head. A merged job's env-gated story pin
   (`F2B_STORY_PINS=1`: site-media-upload's AC4 fails on main the same way) is that job's receipt, not a finding.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking lines) with
`references/testing-pitfalls.md`. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/review-4/review.json` (round 4, a delta: the move
from `8ec7d0ee` on `56a9379f` to `90437f41` on `7ec16d60`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7ec16d6060a76b441e42581b78ad3a502461fd66 /home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight` (exit 2
means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-r4/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one
Chrome job at a time, closed after: stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a
worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar; never
chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Scripts written with Write under
`~/.cache/control-weight-review4/`. Heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`
(8G for the parallel unit suite; export variables first, no `--setenv=PATH`). SIGTERM / 143 / 137 may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three
times this week: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", `verdict`, `ac_status` (per AC: what the
review saw on the new main), then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
