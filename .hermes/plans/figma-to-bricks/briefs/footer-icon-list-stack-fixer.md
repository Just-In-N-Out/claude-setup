# Role: stack fixer (move footer-icon-list onto main Build 2026-11-11.2)

You are a fresh fixer (**Opus 5.5, high**). footer-icon-list is review-clean (review 2, a full review: MOVE ON) at
`316c5f674888352baa292d9049d3d3237c5457e6` (branch `footer-icon-list-fix1`) on main
`11e885fda5d08863a5875f939085350c007ac732`. Main has moved three builds since: site-one-command (Build 2026-11-11.1,
tools only), site-menu (Build 2026-11-11.2: the capture presses menu / pop-up buttons and records `web.code.opens`;
Offcanvas in the paste). Local `main` = `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`. Move the job onto it, keep both
sides' meaning, prove nothing was lost, and stop at `ready-for-review` (a rebase that resolves source conflicts is
reviewed before the job is verified).

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site
(local fixture servers and the offline B-Dry stand-in only); no logins; never write to any WordPress site; never run
`npm run site:upload` or `npm run site:import` against anything but the tests' own 127.0.0.1 stand-in. Nothing may
hide that the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you didn't
start; touch nothing under `~/Downloads`.

**Skills:** `git-commit-rules`, `engineering-best-practices`, `test-driven-development`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines: patch-ids with `--full-index`, context-only conflicts, "a clean textual resolution can still lose the join",
"saved capture files predate a lower job's new capture shapes: capture its new fixture sites fresh") with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Code-route paste traps"; "Writing readers").

## Where the sides meet
Files both changed: `src/web/read/code.ts` (this job: the side rule — one name per box side, the cascade's winner —
via `code-sides.ts`, `NESTED` expansion, `web.code.oneName`; site-menu: what it reads of an opened box),
`src/core/snapshot/web.ts` (this job: `oneName`; site-menu: `opens`, `CodeOpen.makers`), `src/core/site/convert.ts`
(this job's older-capture note; site-menu's Offcanvas, `pointer(t)`, the `opens` parts), `docs/HANDOFF.md`. **The
opened box's own elements must also get the side rule:** a box site-menu reads after a press is read by the same
code reader — check that its states keep one name per side too, and that an Offcanvas pasted from a capture made by
the joined reader shows the site's spacing (a box whose list rows are spaced by a reset plus `margin-block-start`).

## Your copy (you start in your own worktree)
`git checkout -B footer-icon-list-stack3 316c5f674888352baa292d9049d3d3237c5457e6` then `git rebase --onto main
11e885fda5d08863a5875f939085350c007ac732` (check `git rev-parse main` = `e16d3d1e…`; if main moved again, use it and
say so). On each conflict keep both sides' meaning; HANDOFF: this job's section first, then main's lines exactly as
main has them (`<footer-icon-list id at merge>` placeholders stay). Typecheck at each conflicted commit before `git
rebase --continue`. Save each conflicted file before and after under `resolutions/`.

## Proofs
- `git range-diff 11e885fd..316c5f67 e16d3d1e..<new head before any ledger commit>`; patch-ids commit by commit
  (`git show --full-index <c> | git patch-id --stable`; for a context-only conflict the `-U0` patch-id); for each
  conflicted commit, the +/- lines per file compared with the old commit's.
- `git diff -U0 316c5f67 <new head>` equals `git diff -U0 11e885fd e16d3d1e` after dropping `^(index |@@ )` lines,
  except the conflicted files (listed, each explained).
- **Where the sides meet** (local fixtures, captured fresh with the joined head's capture code): this job's AC tests
  (AC1 B-Dry named whole-page test against a fresh capture of the offline stand-in by the joined reader — footer ≤ 2 px;
  AC2 `site-logical-sides`; AC3; AC7/AC8 `site-twice-sides*`; AC9; AC10's capture-time and byte test if load allows)
  and site-menu's (`capture-opens`, `site-opens-proof`, `site-opens`, `site-opens-old`, `bricks-shapes`,
  `capture-opens-guards`); a probe of your own: an opened drawer whose rows use a reset plus logical spacing, captured
  by the joined head: the box's states hold one name per side and the pasted Offcanvas draws the site's spacing when
  opened (both Bricks samples), where `e16d3d1e` draws it off. Default-suite pins (`site-no-revert`, control-weight's
  `site-inline-own-bytes`, site-slider's AC8 goldens, `F2B_UNCHANGED_SUMS=1`): if one fails, prove by four trees that
  it moves only by this job's design and stop on it (regenerating a pin is a fixer's decision you record, not a
  silent change). A merged job's env-gated story pin (`F2B_STORY_PINS=1`) is that job's receipt: record and move on.
  The capture's own fixture-capture pins (capture-speed "AC1 every fixture site captures as it did before") differ by
  `/web/code/oneName` only: say so.

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the new head: both typechecks and `npm run check` (8G scope); the files above, each
web file alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G; export variables
first; no `--setenv=PATH`); `test/unit/plugin-convert.test.ts`; the five Figma replays byte-identical to main's. Each
log starts `HEAD=` and ends with one line `EXIT=`. Known flakes (`capture-entrances` R7-2/R8-1; `site-motion-proof`
AC5 under load; F6-5 in `capture-opens-guards`; the code-page 5.09 px): rerun alone before judging.

## Records and commits
The ledger (this job's `docs/plans/…-footer-icon-list-ledger.md`: a "Stack 3" section: each conflict and its
resolution, the proofs, where the sides meet, the gates) as the branch's last commit; correct HANDOFF:55 and the
ledger lines that name the overwritten capture (`fixer-1/ac1-out-g4/standin-capture.json`, sha `ccc3484c…`): the
read-only head capture is `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/inputs/standin-capture-head-8afa7506.json`
(made by the pre-move reader; say whether your fresh joined capture's sha differs and save it read-only beside it,
`install -m 444`, named by its sha). Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or
Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md. Evidence in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/stack-3/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md`, `resolutions/`, `meet/`, `logs/`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fil3/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc or a shell
function may be refused: write such steps to a script file with Write and run `bash <file>`; `git -C <absolute
path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against. Scripts under
`~/.cache/footer-icon-list-stack3/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
short-iso | grep sending`). Waits under 115 s. The PC restarted three times this week: write each log's `EXIT=` line;
after a restart check `git status` and `git cat-file -t HEAD`, read your finished logs first.

## Report (as text)
`status: ready-for-review`, branch, the new HEAD (full SHA), its base (full SHA), the conflicts and resolutions commit
by commit, where the sides meet (the opened-box probe), each gate's result, any pin and its four-tree table,
`found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
