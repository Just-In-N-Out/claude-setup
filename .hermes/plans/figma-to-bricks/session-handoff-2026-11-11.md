# Session hand-off — FigmaToBricksV2 website importer, 2026-11-11 ~11:35

Read the global `~/.claude/CLAUDE.md` pipeline and the repo `CLAUDE.md` first (the session only orchestrates; fresh
agents on the global role table; standing auto-go; Justin's rules: never write to any WordPress site except his own
`site:upload` / `site:import` runs, never load bdryswi.com without him, nothing paid, plain numbered steps). Every job's
state is in `~/.hermes/plans/figma-to-bricks/evidence/<job>/follow-ups.md`; every brief in
`~/.hermes/plans/figma-to-bricks/briefs/`. Run the earlyoom check each time an agent returns.

## Main
Local `main` = `origin/main` = `0248176342c662b821629d462f4d15a2a2a1df98`, **Build 2026-11-11.3** (pushed). Merged today:
2026-11-10.8 control-weight, 2026-11-11.1 site-one-command (`npm run site:import`, paste check 3dw), 2026-11-11.2
site-menu (menus/pop-ups as Offcanvas, socket gate; 3dx), 2026-11-11.3 capture-refused-styles (the scan survives
bdryswi.com's re-checks; 3dy). Merge lock free. Untracked `site-check-out/` in the main folder: leave it.

## In flight
1. **footer-icon-list** — accepted (`ac-check.sh --reviews`: READY FOR THE USER 9 of 10 on `fb26a529…`, AC6 live). A
   finisher (agent dispatched ~11:33, brief `briefs/footer-icon-list-finisher-rebase.md`) is rebasing it onto
   `02481763` as branch `footer-icon-list-final` and writing a rebase receipt at
   `evidence/footer-icon-list/rebase/receipt-<head7>.log`. If that agent's report is lost with the old session: check
   the branch and the receipt; if the rebase was pure and the receipt ends `EXIT=0`, run
   `ac-check.sh --repo <worktree on the new head> --base 02481763… --plan evidence/footer-icon-list/plan-approved.md
   --reviews evidence/footer-icon-list --rebase-receipt <receipt> evidence/footer-icon-list/verifier/ac.json
   evidence/footer-icon-list/auditor/ac.json`; on ACCEPTED/READY: lock, `git merge --ff-only footer-icon-list-final`,
   merge finisher (BUILD 2026-11-11.4, paste check 3dz, HANDOFF placeholders, CLAUDE.md Status line; recorded limits:
   layered `!important` R2-2, older-capture note count R3-1), verify, release lock. If the rebase conflicted (HANDOFF):
   full path (a short delta review of the resolution → verifier → auditor → ac-check).
2. **site-native-structure** — waits for footer-icon-list. Its state: `evidence/site-native-structure/follow-ups.md`
   (review-4 clean on old main `7eeca437`; needs a move onto main with R4-1, R1-6, the AC14 input swap by amendment,
   control-weight's lifted-child fixture).

## Done today, owed to Justin
- **bdry-demo** (the hand-built backup paste, not the importer): delivered at ~11:20. `evidence/bdry-demo/`
  (`bdry-home-demo.json`, `shots/`, `PASTE-STEPS.md`, `WHAT-STAYS-OUT.md`, `gaps.json`); copies in Windows
  `Downloads\bdry-home-demo.json` and `Downloads\bdry-demo-pictures\`. Accepted READY FOR THE USER 10 of 11 on
  `4721410d` (branch `bdry-demo-fix1`, not merged; a demo). Justin's "Ship now": R2-1 (a 46 px strip above the sticky
  header when logged in at ≤600 px) is a follow-up; demo it logged out.
- **Justin's first clean scan of bdryswi.com** (Build 2026-11-11.3): `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`
  (`capture:check` ok; 52/52 pictures; 22 min, three "I am human" presses). He ran `site:upload` against B-Dry
  staging: 34 pictures uploaded (media 174–207); pastes in `~/Downloads/bdry-test/paste/` (header, page, footer) and
  Windows `Downloads\bdry-paste-2026-11-11\`. **Justin has updated B-Dry staging with this import** (2026-11-11 ~11:35: header, page and
  footer pasted into a new staging page — suggested title "Home import test"; ask him the page's address before reading
  it with `site:live`, which only reads), then Regenerate code signatures, LiteSpeed Purge All, view in incognito. This
  is the live check of 3dt (site:upload), 3dy (scan fix) and, partly, 3dp–3dx; his screenshots of it are the next
  feedback. Expect the footer icon list squashed until
  footer-icon-list merges and he re-scans (`npm run site:import -- https://bdryswi.com/
  https://bdry.staging.growithgro.com --elementor`).
- Clipboard: set with PowerShell `Set-Clipboard` and always read back before telling him (memory `wsl-clipboard`: it
  can go empty; fallback Notepad).

## Follow-ups noted (not started)
- capture-refused-styles A1 (Justin: "merge now will fix later … keep it as a note"): after a renewal in the hidden
  window the tab downloads go out as HeadlessChrome; a site tying its pass to the agent can leave pictures missing.
  Also: `Retry-After` unread; the scan took 22 min with three re-checks (look at why the ranges took 18 min).
- site-menu: R8-2…R10-2, F7-1 (a page's own same-host heartbeat), opened boxes read without hover states (R3-2 of
  footer review).
- site-one-command: `site:upload`'s own typed-ahead yes; R2-1…R2-4.
- bdry-demo: R2-1 sticky-header strip; 34 named in-between-width gaps.
- Live checks owed: 3do–3dy (HANDOFF "End-of-run check list").
- Not yet answered by Justin: the many "not yet confirmed" ⭐ rulings in each HANDOFF section.
