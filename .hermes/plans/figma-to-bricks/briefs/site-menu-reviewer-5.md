# Role: reviewer (round 5: fix round 4 only; report only): site-menu

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits, each with a concrete real-use scenario; edge cases are P3. **The capture presses things on
a client's live site.** It must never submit a form, follow a link with a real address, or cause anything that sends,
buys, logs in, deletes or accepts on the visitor's behalf, nor load another of the site's pages by a press: any path
that can, in normal use, is P0/P1. This is a delta review of one narrow fix round (Justin, 2026-11-10: "Fix the new
window gap").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (a
  planner amends its wording after this round).
- Branch `site-menu-fix4`, head `4dd1a2755937da00b28bd7cf8cdf18ab0f1552fe` (code head `da705c4a`; the two commits after
  it are docs), on `main` `3cfc54ac` (not rebased since; `main` is now `2879e496`, Build 2026-11-10.3 — a later step
  moves the job). In your own worktree: `git checkout --detach 4dd1a2755937da00b28bd7cf8cdf18ab0f1552fe`, confirm HEAD
  and a clean status.
- **Scope: `git diff 06b50a9791069fff808651a9edf54f0cf08e648b..HEAD` and what it touches.** Review 4
  (`evidence/site-menu/review-4/review.json`; probes and logs under `~/.cache/smn-r4/`) found R4-1 (P1). The fixer's
  receipts (read, don't trust): `evidence/site-menu/fixer-4/` (`red-worker-06b50a97.log`, `red-nest-b870a7a6.log`,
  `green-*.log`, `guards-1.log`, `mutants/`, `gates/`, `bdry-dryrun/final-c7b01781/run.log`); its probes
  `~/.cache/smn-f4/probe.ts`, `probe-attach.ts`.
- What fix round 4 did (`src/web/press-guard.ts`):
  - **R4-1:** while any page is pressing, the **browser target** auto-attaches new pages (`Target.setAutoAttach` with
    `waitForDebuggerOnStart`, filter `page`); a new tab whose opener is a pressing page (or a window it opened) gets
    `Network.enable`, `Network.setBypassServiceWorker` and `Runtime.runIfWaitingForDebugger`, all sent at once without
    awaiting (a no-opener window never answers `Network.enable` until it is let go), and is counted as one of the
    press's windows, so its page load reaches the browser's Fetch, which fails and names it; any other new tab (one the
    capture opens itself) just goes on; auto-attach is switched off when the guard stops.
  - **R4-3:** each child's `Fetch.enable`, and a frame's own auto-attach, has 5 s to answer; a child that doesn't is
    dropped and listed (`PressWatch.unheld()`), and `readOpens` names it once in the notes.
  - **R4-4:** each attached frame attaches its own frames, each with its own Fetch (nested cross-site frames).
  - Tests: the `worker` fixture case gains a `window.open('/brochure/')` button and an address-less link a script sends
    to `/booking/` with `target=_blank`; the two worker tests in `test/web/capture-opens-guards.test.ts` run in a second
    Chrome launched with `--disable-popup-blocking`; a nested-frame test with `third.test` mapped to the fixture server
    by `--host-resolver-rules`; unit tests in `web-press-guard`.
- Check hardest (probe with your own fixture pages; count what the fixture server received, by method and path, after
  the capture is done):
  - R4-1 closed: review 4's probe (`probe-writes.ts` variant o) on the head, with the `nav` worker, the every-request
    worker and no worker; `window.open` with and without features, a `target=_blank` link with and without
    `rel=noopener`, a form with `target=_blank` submitted by script, a window that itself opens another;
  - **`--disable-popup-blocking` and `--host-resolver-rules` are test-only:** confirm neither is added to the capture's
    own Chrome launch (`src/web/`, `tools/capture*.ts`), and that with Chrome's pop-up blocker on (the real capture) a
    press-opened window is either blocked by Chrome or held by the guard — never loaded;
  - **browser-level auto-attach with `waitForDebuggerOnStart` beside the rest of the capture:** `npm run capture` reads
    up to 4 width ranges side by side in separate Chrome windows (`--windows <n>`), re-reads a range whose stylesheet
    failed, and opens a visible window for an "I am human" check: can a tab one of those opens while another is
    pressing be left paused (waiting for the debugger), slowed, or wrongly counted as a press's window and failed? Is
    every auto-attached session let go on every path (a press that throws, the guard failing to start, the capture
    stopping on a lost connection)? Run `test/web/capture-windows.test.ts`, `capture-speed-same.test.ts`,
    `capture-styled-ranges.test.ts`, `human-check.test.ts`, `human-reload.test.ts`, `capture-replay.test.ts`,
    `capture-matched-once.test.ts` on the head (4 GB cap, one Chrome job at a time; `capture-windows` "AC7" is a known
    load flake: rerun alone);
  - R4-3's 5 s limit: a slow but honest child (a heavy frame on a busy machine) wrongly dropped and its writes then
    unguarded — how is that reported, and is a dropped child's write still failed by another layer;
  - R4-4: frames nested three deep; a frame that navigates while attached;
  - `test/browser/chrome.ts` (shared by every browser test and tool): additive only;
  - what is still open in normal use, said plainly for Justin (the fixer lists: a window a handler opens after the
    guard has let go of the page; a dedicated worker already running; GETs by design).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the lines on a capture that presses page controls, the form guard, and "Holding a
Chrome to read-only"), the repo `CLAUDE.md` ("The importer never hides that its Chrome is automated"); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-5/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-r5/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin` and a scratch tree has
  no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes
  and logs under `~/.cache/smn-r5/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
