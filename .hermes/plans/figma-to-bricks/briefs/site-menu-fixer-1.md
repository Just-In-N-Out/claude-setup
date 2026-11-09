# Role: fixer (round 1: R1-1 P1, R1-2, R1-3 P2, and the capture's press guards): site-menu

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 1's three findings and tighten what the
capture may press, test-first, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. **Never load bdryswi.com** or any live site (read-only GETs of Elementor's or Bricks'
public source are fine); no logins; never write to any WordPress site. Nothing paid. Nothing may hide that the
importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix1 2681b8123e04aebe54c054610a24e9d41bb234cf` (branch `site-menu-build2`, on local `main`
`fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean status (after a restart, restore tracked files of
exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc` (if it moved, say so; don't rebase).

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (AC1, AC3, AC5, Q5 A, Q6 A).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-1/review.json` (R1-1 P1; R1-2, R1-3 P2;
  R1-4…R1-7 P3); its probes and logs: `/home/justin/.cache/smn-r/` (`probe1`–`probe6.ts`, `cmp.ts`, `out/`).
- The builder's B-Dry stand-in capture with the opened menu:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/builder/cont/bdry-dryrun/run3/standin-menu.f2b-capture.json`
  (a saved stand-in, never the live site) and its dry-run scripts in `builder/cont/scripts/`.

## Work
1. **R1-1 (P1; `src/core/site/tree.ts:61`):** the menu's "Services" `details` opens in the paste but none of its 7 links
   is drawn on B-Dry's real markup: Elementor's rule `.e-n-accordion-item:not([open]) .e-con{display:none}` is read as
   the content's declared value and pasted on its class without the `:not([open])` condition. General rule: a hidden
   content of a closed `details` is pasted with the look it has when its `details` is open (the state the capture can
   read by opening it, as it reads opened boxes), and what hides it while closed is the `details` element itself (the
   browser's own closed state), never an unconditional `display: none`. Test first on a generic fixture whose `details`
   carries a page-builder-style `:not([open])` rule, and on the stand-in capture (named-only): open the menu, press
   Services, 7 links drawn, both routes, 1440 and 390 — RED on `2681b812`, then GREEN.
2. **R1-2 (P2; `src/web/read/opens.ts:74`, `:150`):** how a box closes is proven only in the design width's page load,
   so a box whose opener shows only at other widths (a phone-only ☰) gets `closers: []`: its × carries no Interaction,
   its bare `#` link is rewritten to `/#`, and pressing it navigates away with the menu still open. General rule: a
   box's close proof is read in the widest range where one of its openers shows; and a bare `#` link inside an opened
   box is never rewritten to a page address (it stays inert or closes the box when it is the box's proven closer).
3. **R1-3 (P2; `src/web/readers/openers.ts:149`, `open-paste.ts:49`):** a pop-up with no overlay (its root
   `pointer-events: none`, as B-Dry's three hotspot pop-ups) pastes with a transparent Backdrop that takes every click
   and `closeOn: "esc"`, so the page is blocked while it is open; on the site Elementor closes such a pop-up on any
   outside click and the click reaches the page (`dialog.js` `hide.onOutsideClick`). General rule: the paste copies what
   the site does with a click outside — the box closes and the click reaches what was under it (no click-eating
   backdrop for a box without a cover), using what Bricks' Offcanvas offers or the smallest CSS that does it; say what
   you chose. Test with two hotspots: open the first, press the second: the first closes and the second opens.
4. **Press guards (Justin's standing rule "GET/read only; never write to a site"; review's R1-5):** the capture never
   presses an opener that is a form's submit button (or sits in a form and could submit it), and the pop-up action match
   is anchored so an absolute address ending in the action hash is never followed. Give openers every guard closers
   have. Tests with the fixture's server counting requests: no POST, no navigation.
   Each: RED on `2681b812`, then GREEN; mutate each guard under the cap.
5. Put R1-4, the rest of R1-5, R1-6, R1-7 in HANDOFF's site-menu "Deferred" list (they are in
   `evidence/site-menu/follow-ups.md`); correct HANDOFF's claims (the Services list, the hotspots) to what is now true.
6. Gates before stopping: both typechecks, `npm run check`, AC1–AC7's tests, the AC8 pre-check and the dry run on the
   stand-in (8G scope), the five replays byte-identical to main, `test:web` and `test:browser` file by file under the
   4 GB cap compared by name with the builder's `evidence/site-menu/builder/cont/` gate logs (a `git archive` scratch
   copy with `dist/` built, logs starting `HEAD=<sha> (archive)`; rerun only differing files on main).
7. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-1/` (logs `HEAD=` first, `EXIT=` last). Keep
   scripts and logs under `~/.cache/smn-f/`, never the `/tmp` scratchpad.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-f/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write); start long drivers
  with `setsid --fork` and wait on their final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry 8G). Waits under 115 s. The PC loses power now and then (a
  failing UPS): commit often.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), per item: verified?, the rule, fix, tests, RED/GREEN
paths, mutation; gates; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
