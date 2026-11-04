# Role: planner (Mini, bug): web-reload-settled (a site's own check that reloads into the real page fails the whole capture)

You are a fresh planner for FigmaToBricksV2. Plan only: no product code, no tests committed beyond the plan file, no
BUILD bump, no merge, no push, never start other agents. Never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, leave every other worktree alone.

**Mini mode:** load the project skill and only the code/docs sections this touches; finish within about 15 steps.

## The bug (Justin's live run, 2026-11-04 06:07–06:27, Build 2026-11-04.3)

He captured `bdryswi.com` through the panel's address box. He passed the "I am human" check; the capture found the real
switch points (1366, 1024, 1023, 991, 921, 834, 768, 767, 576, 479, 440, 412, 393, 360) and read all 15 ranges (20 min).
Then the panel: **"The capture failed: Not the page itself: page reloaded itself: the 577-767 page load reloaded itself
while it was read (a bot check, a log-in or a redirect script); the capture may not show the page itself"**. The saved
file `/home/justin/Downloads/bdryswi-com-home.f2b-capture.json` (35 MB, read-only for you; copy it if you need it) holds
the real title, all ranges, 781 elements, 65 pictures; `npm run capture:check` FAILs it only on that note. 577-767 is the
first phone-agent range: the site's "Checking your browser…" step ran again there, passed by itself (no button) and
reloaded into the page. Merged web-human-reload (`31321bb4`, HANDOFF section, ruling R1) marks any cut with no check met
as RELOADED; its review flagged exactly this as P3 R1-1/R1-2
(`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload/review-1/review.json`, follow-ups.md), and Justin
has now ruled: **accept it** — when a page's own reload lands on a page that is not a check and stays one document for
the quiet time (2 s), it is the real page and gets no RELOADED note; a page that keeps reloading, lands on a check, a
log-in or another address still fails as today. General for every site, not keyed on bdryswi.com.

## Do

Load `systematic-debugging` first, then `engineering-best-practices` and `implementation-planning`; read the project
skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`
and `references/live-site-reading.md` (Access). Read `src/web/session.ts`, `src/web/human.ts`, `src/web/capture.ts`,
`src/web/check.ts`, `src/web/helper/job.ts`, `test/fixtures/web/check-site.ts`, `test/web/human-reload.test.ts` at main
`31321bb4`.
1. Root cause with file:line: where the 577-767 load gets RELOADED (the self-passing interstitial at a later range; is
   `met` 0 there? the uncut-reload path too?). Reproduce on the stand-in: a site whose phone-agent range shows a
   "Checking your browser…" page with nothing to press that reloads itself into the real page → the capture fails with
   this note today (RED). Never load bdryswi.com.
2. The smallest general fix per Justin's ruling, keeping: a page that keeps reloading → PageKeptReloading's line; a
   reload that lands on a check, a log-in-like page or another address → the note as today.
3. Plan in Mini format with numbered ACs (AC1…, **proposed**), each with one named test on one plan line: the
   self-passing re-check at a later range captures with no note; a single self-reload of an ordinary site into the same
   page captures; the still-failing cases keep failing; web-human-check and web-human-reload tests still pass; nothing
   hidden; Figma replays byte-identical; `AC<n> (proposed) (live)`: Justin's bdryswi.com capture finishes and opens in
   the capture box. One-line Docs & records task (HANDOFF: ruling R1 replaced by Justin's 2026-11-04 ruling).
4. Branch `web-reload-settled` from main `31321bb4`; write `docs/plans/2026-11-04-web-reload-settled.md`, commit it
   (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged), copy to `E/planner/plan.md`
   (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-reload-settled`).

## Rules

- **Hard rule:** nothing may hide that the browser is automated (no new flags, navigator patches, user agents, stealth
  scripts, nor anything that clicks or types into a site's check). Never load bdryswi.com.
- Live reads (GET only) only of the Hostinger site (`?f2b=`) and letsgro.ai; never write to any WordPress site.
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wrs-plan/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own
  at a time, closed after each step. SIGTERM / 143 / 137 / "Killed" may be an earlyoom kill (`journalctl -u earlyoom
  --since "-30 min" -o short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>`. Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate
  plain calls; no redirects, heredocs or the bare word `source`.
- Put any summary in your report.

## Report

Branch, commit SHA, plan path; root cause in two lines with file:line; fix in two lines; ACs one line each (proposed,
live marked); then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills
or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
