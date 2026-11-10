# Role: fixer (round 2: rebase onto main, then R2-1 and R2-2, both P1, with the press guard that holds for any markup): site-menu

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). First rebase site-menu onto local `main`, then fix review
2's two P1 findings test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging** or any live site (local fixtures and saved
files only; read-only GETs of Elementor's or Bricks' public source are fine); no logins; never write to any WordPress
site. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (the press guards are guards), `git-commit-rules`. Read the
project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md`, `references/live-site-reading.md` (the lines on a capture that presses page controls
and on holding a Chrome to read-only) and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md` with `reference/bricks/offcanvas.json`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix2 6e67f8df87c7ed206fe2028b96bde4eb9b2a4ed3` (the reviewed head, branch `site-menu-fix1`,
on the old main `fd1986dc`), confirm `git rev-parse HEAD` and a clean status (after a machine restart, look for tracked
files of exactly 8388608 bytes and restore them). Report your branch; work only in your own copy.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`. Don't
  change the plan or any AC (a planner amends its wording after this round: review 2's R2-4 and R2-5).
- New base: local `main` `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4, staging-fit-capture merged;
  check `git rev-parse main`). It changed `src/web/capture.ts`, `src/web/session.ts`, `src/core/snapshot/web.ts`,
  `tools/site.ts`, `tools/site-check.ts`, the panel's capture reader and `docs/HANDOFF.md`: a width range read without
  the site's stylesheets is read again, a capture that never gets them stops, and a capture holding such a range is
  refused. This branch also changes `src/web/capture.ts`, `src/core/snapshot/web.ts` and `docs/HANDOFF.md`.
- Review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-2/review.json`; its probes and logs
  under `~/.cache/smn-r2/` (`logs/probe-after.ts.el.log`, the round-1 tree's log, the what-if log,
  `logs/probe-press.ts.form.log`, `probe-press.ts.loose.log`). Fixer 1's receipts: `evidence/site-menu/fixer-1/`.

## Work
1. **Rebase first:** `git rebase main`. Keep both sides' meaning on every conflict (HANDOFF sections both stay; the
   capture fix's re-read, stop and refusal must survive, and so must this job's opened-box reading, `details` reading and
   press guards: the styled-range re-read must also re-read what this job reads in that range, and an opened box must
   never be read from a styleless page load). Record each conflict and resolution in the ledger. Rerun on the rebased
   head: this job's AC tests and staging-fit-capture's own (`capture-styled-ranges`, `capture-styled-loads`, `site-cli`,
   `test/unit/site-styled-ranges.test.ts`) and `capture-matched-once`; stop and report if anything new fails.
2. **R2-1 (P1, `src/core/site/opens.ts:86`):** the outside-close Interaction fix round 1 put on every part's root runs
   on every click and on every no-cover box, open or not. Taking `brx-open` off a box that doesn't have it still writes
   the class attribute, so Bricks' offcanvas watcher runs its close steps on each closed box: `brx-closing` for a tick
   and focus back to that box's last opener, which scrolls the page there (after one hotspot was opened and closed, a
   click 2,089 px further down scrolled the page back to it; the first click into a text field lost focus). General
   rule: a page-wide click Interaction acts only on boxes that are open (the reviewer's what-if: the selector names open
   boxes only, `.<marker>.brx-open:not([data-site-opening])`: no class change, no jump, no lost focus, the outside close
   still works). Test first, in the renderer with Bricks 2.3.9's own script, both routes, 1440 and 390: the idle states
   — nothing ever opened; after one open and close by ×; after an outside close — then clicks on a heading, further down
   the page and into a text field: no class written on any closed box, `scrollY` unchanged, the field keeps focus.
3. **R2-2 (P1, `src/web/readers/openers.ts:190` and `:51`), with R2-3's guard:** the form guard leaves out only `BUTTON`
   and `INPUT` of a form; a link with no address or a `role=button` element inside a form is still pressed (the fixture
   server got `POST /subscribe/`, and the submitting link was recorded as the box's closer). Two layers, both required:
   - **By markup:** never press anything inside a form, whatever its tag, as an opener or inside an opened box.
   - **By what a press does (holds for any markup):** while the capture presses, every non-GET/HEAD/OPTIONS request and
     every main-frame navigation the press starts is failed before it leaves (CDP Fetch on the browser target, as
     `tools/lib/read-only.ts` does for `site:live`: reuse it or its approach; requests the page was already making by
     itself, and the "I am human" check outside the pressing window, are untouched), a press that tried one is never
     counted as an opener or a closer, and the capture's note names it. Dialogs stay bounded as before.
   Test first: `test/web/capture-opens-guards.test.ts` gains a form in an opened box whose Send is an `<a href="#">` and
   a `div role=button` wired to submit, an `aria-controls` link inside a form as an opener, and a non-form button whose
   script POSTs (`/like/`) or navigates away; the fixture server must list no non-GET request and no request for another
   page, and none of those controls is recorded as an opener or closer. RED on the rebased head, then GREEN. The boxes
   the fixture and the B-Dry stand-in really open are still read by their real openers (no AC result changes).
4. Mutate both guards and R2-1's selector (each condition removed in turn kills a test), under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
5. Records batched into your commits: HANDOFF's site-menu section (the rules, "Deferred": R2-6, R2-7, R1-4 and what
   stays of R2-3) and the ledger ("Fix pass 2"); append what you defer to `evidence/site-menu/follow-ups.md`.
6. Gates before stopping: both typechecks, `npm run check`, every AC test (AC1–AC7) with a log `HEAD=` first and `EXIT=`
   last, the offline B-Dry dry run (8G; no other page requested, no non-GET request), `test:web` and `test:browser` file
   by file under the 4 GB cap compared by name with new main (run main's side for files that differ), the five replays
   byte-identical to main, a capture without `opens` pasting byte for byte as main. Commit after each passing step
   (plain `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without
   CLAUDE.md). Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-2/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-f2/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start (kill by its profile path if Node dies). Worktree `node_modules` may lack
  `.bin`: see testing-pitfalls. Run multi-step commands from a script file written with Write, paths spelled out; keep
  scripts and logs under `~/.cache/smn-f2/` (a restart empties `/tmp`); run long gates on a `git archive` scratch copy.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under the 4 GB cap (B-Dry 8G) with a bounded `--test-timeout`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, new base SHA, last commit (full SHA), the rebase conflicts and resolutions, per
finding: verified?, the rule, fix, tests, RED/GREEN paths, mutation; gates vs main; `found_else`; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
