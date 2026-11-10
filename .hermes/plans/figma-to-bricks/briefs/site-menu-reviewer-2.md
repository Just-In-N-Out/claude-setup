# Role: reviewer (Full round 2: the whole story, report only): site-menu

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture` on a real site whose ☰ opens a menu or pop-up, then `npm run site` pasted
into Bricks 2.3.9 or 2.4.2, the ☰ opening and closing the menu like the site; `site:check`; captures as fast and as
correct as before; Figma designs converting as before), each with a concrete real-use scenario. Edge cases are P3
(follow-ups). A P0–P2 with no concrete real-use scenario is a P3.
**The capture presses things on a live site (a client's site).** It must never submit a form, follow a link with a real
address, press a button that belongs to a form, or press anything that buys, sends, logs in, deletes or accepts on the
visitor's behalf: any path that can is P0/P1. Check this hardest.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live). The job: the capture presses each opener (Elementor pop-up links, `aria-controls` toggles) and
  records what opens; the paste builds each opened box as a Bricks Offcanvas with Click → Toggle offcanvas Interactions,
  the site's own entrance played and reversed; a closed `details` pastes its hidden content; a capture without `opens`
  pastes as on main; a researched `reference/bricks/offcanvas.json` stands in for Justin's own copy.
- Branch `site-menu-fix1`, head `6e67f8df87c7ed206fe2028b96bde4eb9b2a4ed3` (the last commit is the ledger; `src/` is final
  since `1b9361c9`), base `fd1986dcdbc8cf35f114b80be456e94279346743`. Local `main` has since moved to `3cfc54ac`
  (staging-fit-capture, Build 2026-11-09.4), which also touches `src/web/capture.ts`, `src/core/snapshot/web.ts` and
  `docs/HANDOFF.md`; this branch is **not** rebased yet (a later round reviews the rebase). In your own worktree:
  `git checkout --detach 6e67f8df87c7ed206fe2028b96bde4eb9b2a4ed3`, confirm HEAD and a clean status. Review the whole
  story `git diff fd1986dc...HEAD`, hardest where fix round 1 changed it (`git diff 2681b812..HEAD`).
- Review 1 (`evidence/site-menu/review-1/review.json`: R1-1 P1, R1-2 and R1-3 P2, P3s) and the receipts (read, don't
  trust): `evidence/site-menu/builder/` (`cont/` is the second builder's), `evidence/site-menu/fixer-1/` (`red-green/`,
  `ac-3c911792/`, `mutants/`, `bdry-dryrun/`, `files-final/`).
- What fix round 1 did:
  - R1-1: the capture reads a closed `details`' content while it is open (one at a time, by the `open` attribute, every
    details put back); the open reading replaces the content's elements; new `src/web/readers/details.ts`.
  - R1-2: a box's close is proven in the design width's page load when an opener shows there, else in the widest
    range's where one does; a bare `#` inside an opened box stays `#`.
  - R1-3: a box with no cover that takes clicks has no Backdrop; where the site closes it on an outside click, the paste
    does too through Bricks Interactions (each part's root: Click → Remove attribute class `brx-open`, "Disable:
    preventDefault" on; each opener first sets `data-site-opening` on its box) — read from Bricks 2.2's
    `interactions.php`, run against 2.3.9's `bricks.min.js` in the renderer, not yet round-tripped in Justin's Bricks.
  - Press guards: never a button or input that belongs to a form (as opener or inside an opened box); a pop-up action
    counts only where the address starts with it.
  - `test/web/lib/site-check.ts` no longer counts what a closed `details` holds as drawn.
- **Two changes the fixer flagged as needing a decision — judge each and say which side is wrong:**
  1. It changed another job's AC oracle: `test/web/capture-matched-once.test.ts` (capture-speed AC8, "matched styles
     asked once per element") now counts an opened `details` as a page state of its own, as a forced hover is since
     capture-speed's amendment 1 (Justin, 2026-11-09: "Count per look, speed later (Recommended)"). Is the test still
     able to fail on what AC8 claims (the normal state asked once)? What does a B-Dry capture cost now (the fixer: 521 s
     against 512 s, opening boxes 207 s against 124 s summed over ranges)?
  2. AC7's shape changed for one case: a box with no cover pastes an Offcanvas with the Content Block only (no
     Backdrop); `test/unit/bricks-shapes.test.ts` was updated. Set the plan's AC7 words against the head: a plan line
     the head makes false is a finding (P3 if the head is right and only the words are behind; say what the plan must
     say).
- Check also: the root-level Click → Remove attribute Interaction with preventDefault off — can it break other clicks,
  links or Bricks' own elements in the pasted part, or fire on every click of the page; pasted twice on one site; the
  `details` open-reading's cost and side effects on a live site (a script listening to `toggle`); a capture without
  `opens` and older captures paste byte for byte as base; the fixture's pop-up script against Elementor's public code.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md` with `reference/bricks/offcanvas.json`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs (probes on three trees where it helps: base, `2681b812`, head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
   your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-r2/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of
  your own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step
  commands from a script file written with Write; keep probes and logs under `~/.cache/smn-r2/` (a restart empties
  `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
