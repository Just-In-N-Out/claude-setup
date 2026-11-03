# Role: planner (Mini): web-human-check (website importer: Justin passes a site's "I am human" check himself)

You are a fresh planner for FigmaToBricksV2. You plan only: no product code, no tests committed beyond the plan file,
no BUILD bump, no merge, no push, never start other agents. Never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, leave every other worktree alone.

**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## The request (Justin, 2026-11-03)

Justin wants to build the B-Dry site from bdryswi.com (his client's site, WordPress.com + Elementor) with the importer's
address box. The capture fails: bdryswi.com answers the importer's Chrome with a bot check ("Checking your browser…",
"Confirm you are human", an **I am human** button, "We need to check you're not a robot before you can enter this
site.", HTTP 403; saved check page: `/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`). Asked how to get past
it without turning the site's protection off, he chose **"I click 'I am human'"**: the helper opens a real, visible
Chrome window; he presses "I am human" himself; the capture then carries on in that same browser. Pipeline: **Mini**.

**Hard rule (Justin's and the permission system's):** nothing may hide that the browser is automated: no
`--disable-blink-features=AutomationControlled`, no patched `navigator.webdriver`, no faked user agent, no "stealth"
scripts, no solving or clicking the check by code. A human passes a human check; the capture stays honest. Agents never
load bdryswi.com: its real pass is a `(live)` AC for Justin.

## What exists (read at the code)

- Helper: `tools/capture-serve.ts` (127.0.0.1:47811, pairing code, jobs, progress lines to the panel); CLI
  `tools/capture.ts` (`npm run capture -- <url> [--all --owned --out]`); the capture `src/web/` (`capture.ts`); the
  Chrome launcher the capture uses (find it: `test/browser/chrome.ts` and/or `src/web`'s own; it finds Chrome by itself,
  on this PC `~/.cache/chrome-for-testing/chrome-f2b` with `--disable-software-rasterizer --use-gl=disabled`); the
  check-page refusal ("Not the page itself: page answered HTTP 403…", "the page holds almost nothing", F10).
- Panel: `src/ui/address-box.ts` (status lines, pairing, "your client's own site?").
- Spec `docs/specs/web-capture.md` ("Typing an address (web-address)"); HANDOFF's web-address section.
- Your worktree starts at `main` = `70be9c09` (Build 2026-11-03.2). `git switch -c web-human-check`; write the plan as
  `docs/plans/2026-11-03-web-human-check.md`, commit it (plain `git commit -m`, no author override, no AI lines, no
  CLAUDE.md staged), copy it to `E/planner/plan.md`, report the branch and commit SHA.
- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check` (yours: `E/planner/`).

## Questions the plan must settle (each with a ⭐ answer; Justin takes the ⭐s under his standing auto-go)

1. **Can a visible window open here?** The helper runs in WSL on the Windows desktop (Windows 11, WSL2 kernel 6.18):
   probe whether WSLg shows a Chrome window on Windows (`DISPLAY`/`WAYLAND_DISPLAY`, a headful launch of the same Chrome
   on a harmless page such as `https://darksalmon-badger-335429.hostingersite.com/?f2b=<random>`, closed right after).
   On the Mac it's Google Chrome. Name anything Justin must do once.
2. **When the window shows:** ⭐ candidates: the helper notices a check page (its existing refusal signals) and only then
   shows a visible window, or a panel tick / CLI flag "Show the browser". Mind that a pass is usually a cookie tied to the
   browser that earned it (a headless browser has its own user agent), so after a pass the rest of that site's capture
   (every width, every page with `--all`) should stay in the browser that passed. Pick the smallest honest design.
3. **Waiting for Justin:** what the panel and the helper's window say ("bdryswi.com asks you to prove you're human:
   press **I am human** in the Chrome window that opened"), how long it waits (⭐), how it knows the check is passed
   (the page is no longer a check page), and what happens on timeout or when the window is closed.
4. **The capture in a visible window:** the 12 widths, scrolling and screenshots still work the same (device metrics
   emulation); the window may stay open until the site is done, then closes.
5. **Tests without bdryswi.com:** a local stand-in check page (answers 403 with an "I am human" button until a cookie is
   set, then the real page) proving: the check is noticed, the capture waits, a click (a test may click it, standing in
   for Justin) lets it continue, and the result is the real page; plus a test that the launch flags, user agent and
   `navigator.webdriver` are exactly what the plain launch gives (nothing hidden).

## Skills

Read the repo `CLAUDE.md` (Status and "Working in this repo" only), the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md`.
Load `engineering-best-practices`, then `implementation-planning` and `security-best-practices`.

## The plan (short, Mini format)

Playback, the five answers with evidence, the change, touched files, a one-line Docs & records task (spec, HANDOFF
section with paste check "id given at the merge"), questions at the top, and numbered ACs (AC1…, **proposed**) with one
named test each, each test name on one plan line: the check noticed, the wait and its panel line, the pass continuing the
same browser, the real page captured, nothing hidden, timeout/closed window, Figma replays byte-identical, and a
`(live)` AC: Justin captures bdryswi.com's home in Figma desktop after pressing I am human, and its Page converts.

## Rules

- Live reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only; never bdryswi.com; never write to any WordPress site.
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` at most 38 characters
  (`~/.cache/whc-plan/tmp`). One Chrome job of your own at a time, closed after each step. SIGTERM / exit 143 / 137 /
  "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun such a
  check under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Write multi-step scripts with Write
  and run `bash <file>`; git commands as separate plain calls; no redirects or the bare word `source` in a command.
- Put any summary in your report, not in a separate summary file.

## Report

Branch, commit SHA, plan path; the five answers one line each with their ⭐; the ACs one line each (proposed, live
marked); then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
proposal; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
