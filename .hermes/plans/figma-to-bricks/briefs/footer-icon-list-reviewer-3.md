# Role: reviewer (round 3, a short delta: the move onto Build 2026-11-11.2; report only): footer-icon-list

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`).
Never load bdryswi.com, B-Dry staging or any live site (local fixture servers, the offline B-Dry stand-in site and
saved files only); no logins; never write to any WordPress site; never run `npm run site:upload` or `site:import`
against anything but the tests' own 127.0.0.1 stand-in. Nothing may hide that the importer's Chrome is automated.
Justin may be running his own Chrome: never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. From round 3 the referee asks Justin when only P2 is left: rate each finding
exactly.

## What happened
footer-icon-list (the capture's reader keeps each box side by one name — the one the site's cascade applied — so a
site writing a side by a physical and a logical name pastes the site's value; new captures are marked
`web.code.oneName: true`; older captures paste as before with one note) was review-clean (review 2, a full review:
MOVE ON) at `316c5f674888352baa292d9049d3d3237c5457e6` on main `11e885fd`. Main moved to
`e16d3d1ea2c752bac7e405ce00bfc25accbc8de9` (Builds 2026-11-11.1 site-one-command and 2026-11-11.2 site-menu: the capture
presses menu / pop-up buttons and reads each opened box with `readCode(…, { root })`; `web.code.opens`; Offcanvas in the
paste). A stack fixer rebased the job: conflicts in `src/core/snapshot/web.ts` (both fields kept), `src/web/read/code.ts`
imports (joined), HANDOFF (context only); `convert.ts` applied cleanly but its patch-id changed (site-menu's
`linkNote` lines now follow this job's `olderPairs` lines). It found no join code needed: an opened box goes through
the same `readOnce` where the side rule runs; its probe shows a drawer whose rows are spaced by a reset plus logical
names pastes 0.00 px on head and 80.5 px off on main. **Nobody has reviewed the resolutions.**

## Inputs
- Approved plan (read-only, v2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`
  (AC1–AC10; AC6 live).
- Branch `footer-icon-list-stack3`, head `fb26a529ee24bfa97f9b563756eb2698e826c328` (records commit; code head
  `719826bd37cae048d6b838168736e36f3dbb6033`), base main `e16d3d1e`. In your own worktree: `git checkout --detach
  fb26a529ee24bfa97f9b563756eb2698e826c328`, confirm HEAD and a clean status. **Your scope:** the move (`git range-diff
  11e885fd..316c5f67 e16d3d1e..719826bd`) and the records commit (`git show fb26a529`), and what they touch.
- The fixer's record (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/stack-3/`
  (`conflicts.md`, `range-diff.txt`, `patch-ids.txt`, `whole-diff.txt`, `resolutions/`, `meet/` with `probe-src/`,
  `logs/` with `fourtree-inline-own-bytes.log`).

## Check hardest
1. **The resolutions keep both jobs whole:** `snapshot/web.ts` (both `opens?` / `CodeOpen` and `oneName?`), `code.ts`
   (both imports; nothing of site-menu's reading of an opened box lost; the side rule's `NESTED` expansion still runs
   for the page and for a box), `convert.ts` (this job's older-capture note and site-menu's `linkNote`: both notes
   reach each part, in the right part, once). Your own range-diff and patch-ids; `git diff -U0 316c5f67 719826bd` vs
   `git diff -U0 11e885fd e16d3d1e` after dropping `^(index |@@ )` lines.
2. **Where the sides meet, by you:** an opened box (drawer, dialog, `<details>`) whose rows are spaced by a reset plus
   logical names, and one whose side is set by both names with the physical one winning — captured with head's
   reader: the box's states hold one name per side; the pasted Offcanvas, opened, draws the site's spacing on both
   Bricks samples at 1440 and 390; main draws the first off. A capture made by main's reader of the same page,
   converted by head: the older-capture note names the box's pairs in the part that holds the Offcanvas. Hover and
   focus looks inside a box. A box opened at one width range only.
3. **The pins:** control-weight's `site-inline-own-bytes` (named) fails on the B-Dry captures by this job's AC9 note —
   check the fixer's four-tree table is right (old base→old head equals new main→new head, the footer's note the only
   difference). site-menu's AC tests on head (`capture-opens`, `site-opens`, `site-opens-proof`, `site-opens-old`,
   `bricks-shapes`, `capture-opens-guards`). The fixer saw that the offline B-Dry stand-in capture holds no
   `web.code.opens` on either tree, while site-menu's verifier read five boxes from "the offline B-Dry stand-in": find
   out why (a different stand-in input, a variable, the press step off for that test) and say whether either job's
   check is wrong.
4. **The records commit:** HANDOFF's corrected proof line and the ledger name existing read-only files with the right
   sha256 (`inputs/standin-capture-head-8afa7506.json`, `inputs/standin-capture-joined-f0948ab2.json`); the dropped
   stray `<staging-fit-cancels id at merge>` line was truly stray (main lists staging-fit-cancels as 3du).
5. **Gates:** both typechecks and `npm run check` (8G scope); AC1 (fresh capture of the stand-in by head's reader:
   footer ≤ 2 px), AC2, AC3, AC7/AC8, AC9's files; the five Figma replays byte-identical; each web file alone under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G; export variables first; no
   `--setenv=PATH`). Known flakes rerun alone before judging.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Code-route paste traps"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/review-3/review.json` (round 3, a delta: the move
from `316c5f67` on `11e885fd` to `fb26a529` on `e16d3d1e`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e16d3d1ea2c752bac7e405ce00bfc25accbc8de9 /home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list` (exit 2
means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fil-r3/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop it by the
PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" may be refused: write such steps to a script file with Write and run `bash
<file>`; `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against.
Scripts under `~/.cache/footer-icon-list-review3/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since
"-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three times this week: keep notes and
finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the resolutions judged; the box probe
table; the pins (and the stand-in `opens` question answered); `verdict`; `ac_status`; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
