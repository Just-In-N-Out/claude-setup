# Role: reviewer (round 1, FULL review of the whole story; report only): site-no-div

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder). Never load bdryswi.com, B-Dry staging or any live site;
never write to any WordPress site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: copies in `evidence/media-clickable/run/`
and `evidence/site-menu-motion/builder/bdry-capture.json`). **Importer rule (Justin, 2026-11-02):** one review per job, P0–P2 only for bugs a
real site or normal use hits, each with a concrete scenario; edge cases are P3 (follow-ups).

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md` (AC1–AC14; AC14 live).
  The job (Justin: "I do not want to see Div anymore… it should look as if it was built with Bricks"): every website paste, both routes,
  holds no Div: wrappers become Section / Container / Block, links Text link / Button / linked Image, spans Rich Text, neutral wrappers
  folded (rule N), each box labelled; the plain route with `native: false` equals base with Div renamed Block; Figma designs byte for byte.
- Branch `site-no-div-build`, head `ae288ac8559c353d5ddd81a30cbf412eccd0a2e4`, base local main `56b5076b5c1d665abd5bad4bcc78861739cc01e9`
  (Build 2026-11-12.1, site-native-structure merged): `git checkout --detach ae288ac8…`; review `git diff 56b5076b...HEAD` (10 commits, 94
  files; a replayed range `6d685a72..200c5e7e` doesn't compile, fixed in `4937268b`).
- Builder's rulings beyond the plan (judge each): Section only for a `div`/`section` box, Container only for a `div`; a menu's `li > a`
  lifted to its own element (`natives.ts` `linkBoxes`); `structure.txt` written by `site`, `site:upload`, `site:import` from one writer;
  rule N's extra keeps (`Folded.refused`, state-look triggers, an opened box's entrance); a kept header root on the plain route too.

## Check hardest
1. Real pastes: Justin's scan and the B-Dry stand-in on both routes, drawn in Chrome on Bricks 2.4.2 and 2.3.9 at 1440 and 390 — any
   look, hover, focus, link or opener that differs from the site or from base; a Text link/Button/Image whose link, target or hover is lost;
   a folded wrapper that carried layout (gap, padding, grid, an id a script or a look names via marker class).
2. Every merged job it sits on still holds: scroll-lock, sticky header (stay class, kept root), menu motion (slide in the Offcanvas),
   media-clickable (Background image settings on the right element after folding), footer one-name sides, site-native-structure's fold
   and labels, media-avif-alt (uploader unchanged).
3. The test-only changes to merged jobs' tests (the list in the ledger): each still guards its rule (no assertion weakened beyond the
   lifted-root locator and `native: false`); goldens regenerated honestly (`scripts/regen.ts` reproduces main's goldens on main's tree).
4. Gaps: the ~72 capture-*/compare-* web files weren't re-run on the rebased head — run the ones the diff can reach.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/review-1/review.json` (round 1, **scope full**, from `56b5076b`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
56b5076b5c1d665abd5bad4bcc78861739cc01e9 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md` "Code-route paste traps"; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdr1/t1`); scripts under `~/.cache/sdr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry 8G). Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s;
long suites with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; each builder's ruling: holds or not; `verdict`; `ac_status`;
`skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
