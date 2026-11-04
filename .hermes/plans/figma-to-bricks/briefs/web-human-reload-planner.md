# Role: planner (Mini, bug): web-human-reload (the capture dies when a checked site reloads its page after a pass)

You are a fresh planner for FigmaToBricksV2. Plan only: no product code, no tests committed beyond the plan file, no
BUILD bump, no merge, no push, never start other agents. Never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, leave every other worktree alone.

**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## The bug (Justin's live run, 2026-11-04 ≈01:30–01:50, Build 2026-11-04.1)

Justin captured bdryswi.com (his client's WordPress.com site) with the panel's address box. The new web-human-check
(merged as `39d96c98`, HANDOFF "web-human-check" section) worked at first:
1. Helper: `bdryswi.com asks you to prove you're human: press its button … in the Chrome window that just opened.`
2. He pressed it: `Check passed: capturing bdryswi.com in that window (it closes by itself when done)`.
3. `Switch points found: 1366, 1024, 1023, 991, 921, 834, 768, 767, 600, 576, 479, 440, 412, 393, 360 (32 boundaries checked)` (panel timer then ≈5:35).
4. Later, a **second** `bdryswi.com asks you to prove you're human…`; he pressed again; `Check passed: capturing bdryswi.com in that window…`.
5. Then the panel: **`The capture failed: Inspected target navigated or closed (-32000)`**. The window vanished on its own
   (the helper closes Chrome on failure); he didn't close it. No earlyoom kill; memory was fine.
The helper window's stack trace is being fetched from Justin; the main session will forward it to you by message if it
arrives while you work. Plan with or without it.

Known leads (verify, don't assume): review 1 of web-human-check reported as P3s
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check/review-1/review.json` R1-1 (a pass that reloads isn't
always seen) and **R1-5** (`src/web/human.ts:120`: any new non-check document counts as passed, so a "verifying" page or
the site's own follow-up navigation after the click is reloaded over while it may still be finishing), with probes beside
it; the builder's deferred item "closing the window mid-capture after the pass ends with the driver's own error". CDP's
`-32000 Inspected target navigated or closed` is what Chrome answers a command (e.g. `Runtime.evaluate`, DOM reads) whose
page navigated away mid-command.

## Do

Load `systematic-debugging` first, then `engineering-best-practices` and `implementation-planning`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (its Access lines). Read `src/web/human.ts`, `src/web/human-run.ts`,
`src/web/session.ts`, `src/web/read/browser-fetch.ts`, `test/browser/chrome.ts`, `test/fixtures/web/check-site.ts`,
`test/web/human-check.test.ts` at `39d96c98`.
1. **Root cause with file:line evidence:** where the second check is met (which page load: a phone user agent's? which
   width?), what the code does right after "Check passed", and which command dies when the site navigates (its own
   post-pass redirect/reload, or a re-check on a later load). Reproduce it on the local stand-in: extend the stand-in
   (a mode where, after the click, the site navigates through an interstitial or reloads itself again shortly after, and/or
   re-checks a later load) so the capture fails with the same `-32000` (RED), never by loading bdryswi.com.
2. **The fix, general:** e.g. a pass counts only once the page has settled (no navigation for a short quiet time, its
   load finished) and any page read that dies of a navigation mid-capture waits for the page to settle and reads again
   (bounded), so a site's own reloads never end a capture; a failure still ends with a plain line. Smallest honest change.
3. Plan in Mini format: playback, root cause, fix, touched files, numbered ACs (AC1…, **proposed**), each with one named
   test on one plan line: the reproduction now passes; the existing human-check ACs still pass; nothing hidden (no new
   flags, input or user agent); Figma replays byte-identical; and `AC<n> (proposed) (live)`: Justin's bdryswi.com capture
   completes after his presses and its Page converts. A one-line Docs & records task (HANDOFF follow-up R1-5 closed, spec).
4. Branch `web-human-reload` from main `39d96c98`; write `docs/plans/2026-11-04-web-human-reload.md`, commit it (plain
   `git commit -m`, no author override, no AI lines, no CLAUDE.md staged), copy to `E/planner/plan.md`
   (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-reload`).

## Rules

- **Hard rule:** nothing may hide that the browser is automated (no `AutomationControlled` flag, no `navigator.webdriver`
  patch, no new user agent, no stealth script, nothing that clicks or types into a site's check). Never load bdryswi.com.
- Live reads (GET only) only of `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and
  `https://www.letsgro.ai/`; never write to any WordPress site.
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/whr-plan/tmp`); Chrome found by itself. One Chrome job of your own at a time, closed after each step.
  SIGTERM / 143 / 137 / "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Write multi-step scripts
  with Write and run `bash <file>`; git commands as separate plain calls; no redirects or the bare word `source`.
- Put any summary in your report.

## Report

Branch, commit SHA, plan path; the root cause in two lines with file:line; the fix in two lines; the ACs one line each
(proposed, live marked); then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never
edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
