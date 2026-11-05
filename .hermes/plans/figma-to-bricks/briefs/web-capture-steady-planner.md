# Role: planner (Mini, bug): web-capture-steady (captures with no gaps: a width that meets the check is waited for, a settled reload is the page, the CLI finds Chrome)

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, high effort: Justin's code-method jobs run on high). Plan only: no
product code, no tests committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Never
touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, leave every other
worktree alone. Never load bdryswi.com. Another job (web-code-page) is planning/building the whole-page converter in
`src/core/site/`, `src/web/read/code*.ts` and `tools/site*.ts`: stay out of those files.

## The live evidence (Justin, 2026-11-04 evening, Build 2026-11-04.7)

`npm run capture -- https://bdryswi.com/` first failed: "Chrome not found at /Applications/Google Chrome.app/…; set
CHROME_PATH" (the CLI lacks the helper's Chrome finder). With `CHROME_PATH=~/.cache/chrome-for-testing/chrome-f2b` it ran:
he pressed "I am human" six times; 16 ranges read; then **"Not the page itself: page reloaded itself: the 1024-1024 page
load reloaded itself …; page answered HTTP 403: the server answered the 1024-1024 page load with an error …; page reloaded
itself: the 992-1023 page load …; page reloaded itself: the 394-412 page load …"**. The file saved
(`/home/justin/.hermes/plans/figma-to-bricks/evidence/bdryswi-com-home-2026-11-04-code.f2b-capture.json`, read-only copy);
`npm run site:check` on one section: 0 px at 47 of 48 widths, **1024 "missing"** (that range holds the check page).

Earlier (06:27, the panel): the same "page reloaded itself" refusal at 577-767. A planned, unbuilt fix exists: plan
`docs/plans/2026-11-04-web-reload-settled.md` on branch `web-reload-settled` at `7767ff7e` (approved copy
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-reload-settled/plan-approved.md`; Justin's ruling: a reload that
lands on the same address, not a check, no password field, status < 400, staying put 2 s, is the real page). Its builder
was stopped when the method review paused everything.

## Plan

1. Fold the reload-settled plan into this job (re-check its file:line against current main; reuse its stand-in options).
2. **A range load that lands on a check** (403 or the check shape) waits for Justin in the visible window like the first
   check does, then reads that range again; never records a check page as a range. Root cause with file:line for why the
   1024 load got a 403 check page with no wait (the check at a later range with the window already visible?).
3. **The CLI finds Chrome by itself** exactly as the helper does (one shared finder).
4. Numbered ACs (AC1…, **proposed**), one named test each on one plan line, on the local stand-in (a site that re-checks
   at a later range with a 403 page, reloads itself after a pass, and passes on the same address), plus: nothing hidden
   (no flags, navigator patches, user agents, stealth, nothing that clicks a check); the web-human-check/-reload tests
   still pass; Figma replays byte-identical; `(live)`: Justin's `npm run capture` of bdryswi.com ends with no
   not-the-page note and `site:check` shows every width (no "missing").
5. Branch `web-capture-steady` from current main (`git rev-parse main`); `docs/plans/2026-11-04-web-capture-steady.md`
   committed (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged); a copy at
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture-steady/planner/plan.md`.

## Skills, machine, report

Load `systematic-debugging`, `engineering-best-practices`, `implementation-planning`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md` and
`references/testing-pitfalls.md`. **Hard rule:** nothing may hide that the browser is automated. WSL: Node
`/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcs-plan/tmp`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time. SIGTERM / 143 / 137 /
"Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Write scripts
with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls; no redirects, heredocs or
the bare word `source`. Report: branch, commit, plan path, root causes with file:line, the fix, ACs one line each, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
