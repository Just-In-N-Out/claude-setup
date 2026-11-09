# Role: reviewer (Full round 1, report only): site-menu

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (`npm run capture` on a real site whose ☰ opens a menu or pop-up, then `npm run site` pasted into Bricks 2.3.9 or
2.4.2, the ☰ opening and closing the menu like the site; `site:check`; Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live). Justin's report: the header ☰ does nothing in the paste. The job: the capture presses each opener
  (Elementor pop-up links, `aria-controls` toggles; never a link with a real address) and records what opens (openers,
  closers, closeOn, cover, side, noScroll, the entrance as it played, per-range nodes); the paste builds each opened box
  as a Bricks Offcanvas (a second root after the part's root, the reset on the site box inside), every opener and × with
  a Click → Toggle offcanvas Interaction, the site's own entrance played and reversed, nothing moving under reduced
  motion; a closed `details` pastes its hidden content; a capture without `opens` pastes as on main; a researched
  `reference/bricks/offcanvas.json` stands in for Justin's own copy. Q1–Q6 A taken.
- Branch `site-menu-build2`, head `2681b8123e04aebe54c054610a24e9d41bb234cf`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach 2681b812…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builders' receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/builder/`
  (the second builder's in `cont/`). The second builder rewrote the fixture's pop-up script to follow Elementor Pro
  4.3.2's real behaviour (templates removed from the page at load, a fresh copy per open; excerpts in
  `cont/elementor-src/`), names a pop-up by its id (`target: "elementor-popup:<id>"`), added `CodeOpen.motion`, and ran an
  offline dry run on the saved B-Dry home (`cont/bdry-dryrun/run3/`). Its `found_else`: no-overlay pop-ups close only by
  Escape and × in the paste; the × sits about 15 px lower (main's reader writes both `margin-block-start` and
  `margin-top`); reading opened boxes adds about 124 s to a B-Dry capture; the estimate pop-up holds a WPForms form that
  pastes as markup and sends nothing. **The capture clicks things on a live site:** check hard that it can never press a
  link with a real address, submit a form, or press anything that writes (Justin's rule: GET/read only; nothing hides
  that Chrome is automated; a person passes person checks).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: the capture pressing something it shouldn't on a real site (navigation, a
   form, a cart, a login, a cookie banner's accept), leaving the page changed for the ranges read after, or hanging on an
   opener that opens nothing; a real Elementor Pro pop-up menu not read or pasted wrong; the Offcanvas shape or the
   Toggle offcanvas Interaction not what Bricks 2.3.9/2.4.2 runs (`reference/bricks/`, Bricks' GPL source); the menu not
   opening, not closing, trapping focus or scroll, or showing while closed; links inside it pointing at the old site; a
   capture without `opens` changing bytes; the plain route or Figma designs no longer byte-identical; tests that can't
   fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-r/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.` Keep probe scripts under `~/.cache/smn-r/`, never the
`/tmp` scratchpad (the PC loses power now and then).
