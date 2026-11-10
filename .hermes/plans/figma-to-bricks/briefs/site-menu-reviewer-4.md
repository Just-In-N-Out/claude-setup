# Role: reviewer (round 4: fix round 3 only; report only): site-menu

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits, each with a concrete real-use scenario; edge cases are P3. **The capture presses things on
a client's live site.** It must never submit a form, follow a link with a real address, or cause anything that sends,
buys, logs in, deletes or accepts on the visitor's behalf: any path that can, in normal use, is P0/P1. This is a delta
review of one narrow fix round.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (a
  planner amends its wording after this round).
- Branch `site-menu-fix3`, head `06b50a9791069fff808651a9edf54f0cf08e648b`, on local `main` `3cfc54ac` (not rebased
  since; `main` is now `e4355044`, Build 2026-11-10.1 — a later step moves the job). In your own worktree:
  `git checkout --detach 06b50a9791069fff808651a9edf54f0cf08e648b`, confirm HEAD and a clean status.
- **Scope: `git diff 66dc86a5e7ad9ff278326986e2097ae6336140dc..HEAD` and what it touches.** Review 3
  (`evidence/site-menu/review-3/review.json`; probes and logs under `~/.cache/smn-r3/`) found R3-1 (P1). The fixer's
  receipts (read, don't trust): `evidence/site-menu/fixer-3/` (`red-66dc86a5-worker.log`, `red-3099a2ff-msg.log`,
  `green-*.log`, `mutants/`, `gates/`, `bdry-dryrun/final-c61c6174/run.log`).
- What fix round 3 did (`src/web/press-guard.ts`, on the guard's second session of the tab):
  - **R3-1:** before its Fetch the guard runs `Network.enable` (no buffers) and
    `Network.setBypassServiceWorker({ bypass: true })`; when it detaches it sets the bypass back to false and runs
    `Network.disable`, so the rest of the capture reads the page through its worker as served.
  - **Part of R3-4:** `Target.setAutoAttach({ autoAttach: true, waitForDebuggerOnStart: false, flatten: true })` on that
    session attaches what is already running beside the page (a frame of another site, the page's service worker, a
    dedicated worker); each attached child gets its own Fetch before the presses start (a dedicated worker's session has
    no Fetch: left open, recorded); a child's write is failed and recorded as the page's (same site: the press counts
    for nothing; another site: the reports list); its reads go on. New `Page.child()` in `test/browser/chrome.ts`.
  - Fixture `test/fixtures/web/site-menu-more.ts` case `worker` (modes `nav`, `all`, `none`, `msg`) and
    `test/fixtures/web/third-party/listen.html`; new tests in `test/web/capture-opens-guards.test.ts`.
- Check hardest (probe with your own fixture pages; count what the fixture server received, by method and path, after
  the capture is done):
  - R3-1 closed: review 3's probes (`probe-g`, `probe-sw`, `probe-wct`) on the head; a network-first, a cache-first and
    a stale-while-revalidate worker; a worker registered at a narrower scope than the page; a worker that takes control
    only after a reload (`skipWaiting` / `clients.claim`); a page whose content only shows through its worker (does the
    bypass change what the capture reads while pressing? the fixer says the boxes equal the no-worker capture's on the
    fixture);
  - the bypass and auto-attach are really undone after each page load's presses and also when the guard fails to start
    or a press throws (a `finally`?), so the "I am human" check, the stylesheet gate's re-read and the kept-page replay
    behave as before; `Network.enable` on the twin session not slowing or changing the rest of the capture;
  - auto-attach side effects: does attaching to a cross-site frame, a service worker or a worker pause or break them
    (`waitForDebuggerOnStart: false`), leak sessions across page loads, or change what the page shows; a page with many
    frames (ads, embeds, a reCAPTCHA or Cloudflare Turnstile frame) — would failing a third-party frame's POST during
    the pressing window break the site's own bot check or make the capture look hostile; the fixer's ruling stands that
    an other-site write is failed but not counted against a press;
  - `chrome.ts` is shared by every browser test and the capture: `Page.child()` additive only;
  - what is still open in normal use, said plainly for Justin: a dedicated worker already running; GETs by design; a
    window a press opens loading through the site's worker (not probed by the fixer: probe it);
  - the one flaky failure the fixer saw (the boxes-equal comparison in the worker tests under load, cause unknown): can
    you reproduce it, and is it a real difference in what is read with a worker bypassed mid-capture?
  - cost: the B-Dry stand-in dry run took 586 s (fixer 2: 686 s; the builder: 512 s).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the lines on a capture that presses page controls, the form guard, and "Holding a
Chrome to read-only"), the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-4/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-r4/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin` and a scratch tree has
  no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes
  and logs under `~/.cache/smn-r4/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
