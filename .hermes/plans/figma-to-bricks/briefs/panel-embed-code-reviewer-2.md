# Role: reviewer (Full round 2, the whole story with fix round 1 at its centre; report only): panel-embed-code

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging, a widget vendor's host or any live site
(local fixture servers and saved files only); never write to any WordPress site; no logins. Nothing may hide that the
importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a capture of a real site converted in the Figma panel's website route, or with `npm run
site`, and pasted into Bricks 2.3.9 / 2.4; Figma designs converting as before; `npm run capture` on a real site), each
with a concrete real-use scenario. Edge cases are P3. **What a paste may run on the user's site is this job's guard:
any path by which a pasted Code element carries code that is not the widget's own (a tracking tag, a tag manager,
another widget's script, a page script, a shared library) is P0/P1.** A P0–P2 with no concrete real-use scenario
counts as P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`
  (AC1–AC11; AC11 live; Q1 A – Q5 A taken). **Known, not findings:** the plan lines fix round 1 made false are listed
  in the ledger ("Fix pass 1") and a planner amends them after this review (Q4 A and AC7 "the very file that made the
  box", lines 188–189, the code sketch, R1-7's `e.how === undefined ? "older"`). The main session's reading of Q4 A,
  not yet confirmed by Justin: a floating widget's own code is the served tag that starts the chain of script loads
  ending in the file that drew the box (a bootstrap counts; a tag manager, a tracking loader or an inline root never).
  Rate whether the code carries that reading out safely, not whether the plan's old words still hold.
- Branch `panel-embed-code-fix1`, head `4cfc700313821a96ffce78e026bdf5cf04529015`, base
  `f708dfb659049db50bb45df8026faabee2ee0ad7` (`main` has since moved to `7eeca437`, Build 2026-11-10.4: a later step
  moves the job). In your own worktree: `git checkout --detach 4cfc700313821a96ffce78e026bdf5cf04529015`, confirm HEAD
  and a clean status. Review `git diff f708dfb6...HEAD`; fix round 1 is `git diff 4d6c6403..HEAD` (three commits:
  `9dc5f38c`, `1743f3b8`, `4cfc7003`).
- Review 1 (round 1 found R1-1 and R1-2, both P2): `evidence/panel-embed-code/review-1/review.json`, its probe site
  `~/.cache/pec-r1/`. The fixer's receipts (read, don't trust): `evidence/panel-embed-code/fixer-1/` (`logs/`,
  `mutants.jsonl`), its probes `~/.cache/pec-f1/`. Deferred items: `evidence/panel-embed-code/follow-ups.md` (don't
  re-report what is recorded there unless you rate it higher, with a scenario).
- The fixer's words: the tracker (`src/web/read/tracker.ts`) now records every script file on the stack (to 40 frames,
  the page's own `Error.stackTraceLimit` put back) and what each file did (elements it made that can load something;
  requests it sent through fetch, XMLHttpRequest and sendBeacon); `src/web/read/floating.ts` `originOf` / `chainOf`
  follow who inserted each `<script>` back to a served tag; a file on the way may do nothing but load the next file (a
  style, a stylesheet link, a box around the floating one and never-inserted feature tests are allowed), else `ownWhy:
  "shared"` and the widget is listed; an inline root or a step by the page's own script is `"page"`, listed; a
  "library" is a file of another host that never acts alone, skipped when reading who drew a box, so a site script's
  box drawn through it is the site's own; new capture fields `ownWhy`, `ownLoads`, `unread`; the consumer
  `src/core/normalise/floating.ts` pastes `own` even with an empty snippet; new fixture site `embeds-chained`; tests
  `test/web/panel-floating-chain.test.ts`, `test/unit/floating-origin.test.ts`, `test/unit/panel-floating-why.test.ts`.

## Check hardest (probe with your own pages, outside the repo's fixtures; local servers only; count what your servers
received when the paste is drawn)
1. **The structural test that keeps a tag manager out. Try to get a tracker pasted** through a served root tag, by the
   ways real loaders send and load that the tracker may not see: `new Image().src` (the commonest pixel), an `<img>`
   or `<script>` written with `innerHTML` / `insertAdjacentHTML` / `document.write`, `import()`, a Worker,
   `navigator.sendBeacon` kept by reference before the capture's script ran, a cached `fetch` reference, an XHR made
   in an iframe's window, a `<link rel=preconnect|prefetch|modulepreload>`, a load started from a timer, a promise, an
   event handler or the bundle's `onload` (whose file is on the stack then?), a tag manager that loads the chat and,
   only later (a consent click, 5 s), a tracker; a root file that both loads the chat and is itself the tracker's
   library, sending nothing until called. For each: is the root pasted, and what reached your server when the paste was
   drawn? Each real hole is P0/P1 with the loader shape named; say how common the shape is.
2. **The library rule (R1-2), both ways.** (a) A site script calling a CDN library: the site's own box, the library
   never pasted (jQuery-depth stacks; a library called from a timer, an event handler, `$(function(){…})`). (b) **A
   vendor's file that does nothing until the page's inline script calls it** (the embed-code shape of many badge,
   booking and chat widgets: `<script src=vendor.js>` then `Vendor.init({...})` inline): does it now read as a
   "library", its launcher as the site's own box, pasted as a dead still copy of another company's button with no
   note? What did base (main) paste for it and did it work there? Rate it by the importer rule and say how common. (c)
   A vendor file that acts alone only sometimes (after its config loads). (d) A site that serves its theme from its own
   CDN host (recorded as pre-existing: rate only if the fix made it worse).
3. **What the tracker now does to a real page during `npm run capture`:** wrapping `fetch`, `XMLHttpRequest`,
   `sendBeacon` and reading 40-frame stacks on every element made. Does a page behave differently while captured (a
   site that checks `fetch.toString()` / native code, a wrapped method losing `this`, a thrown error changing an
   error's stack or `stackTraceLimit` seen by the page, a streaming or aborted fetch, `XMLHttpRequest` subclasses,
   keepalive)? Is the capture's reading otherwise the same as on `4d6c6403` (convert two fixture sites and the saved
   captures both ways)? **Capture time:** time `npm run capture` on a heavy local fixture site on `4d6c6403` and on
   head (same machine load, twice each); a slow-down a person would notice on a real page is a finding (capture-speed's
   live check is bdryswi.com under 10 min; the saved B-Dry home took 3.4–3.7 min offline).
4. **The capture's new fields** (`ownWhy`, `ownLoads`, `unread`, `web.embeds[].unread`): the format's version and
   `capture:check`; an older capture (none of the fields) through both routes, byte for byte with `4d6c6403` except
   note words; the panel's sandbox (`tsconfig.sandbox.json`; `src/core` uses only the language's built-ins); the
   helper → panel path carries them.
5. **The consumer:** `own` pasted with an empty snippet only where the capture proved it; never widened; a root served
   twice; a root that draws two boxes pasted once; two widgets of one host; the notes' words (page, shared, frame,
   unread, loads, older, unproven): true, one plain sentence, something Justin can act on.
6. **Round 1's ground still holds:** nothing but a widget's own code in any pasted Code element on both routes, every
   embed kind, both picture modes, every part (re-run review 1's probe site on head); widgets that worked on main and
   on `4d6c6403` still work; the code route byte for byte as base on the widget fixtures and on captures without
   widgets; Figma designs byte for byte (`test/unit/plugin-convert.test.ts`, the five replays); the "unchanged sums"
   test honest.
7. The tests can fail (read the mutant receipts; one or two of your own under the 4 GB cap). The fixer's fixture edit
   (`notesCapture`'s `help.example` box: `own` set to null) is honest.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the embeds line and "Holding a Chrome to read-only") and
`references/rendering-validation.md`, the repo `CLAUDE.md` ("Architecture rules"; "Code Figma runs uses only the
language's built-ins"; "Website captures"; "The importer never hides that its Chrome is automated") and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review for real bugs (probes on `4d6c6403`, on base and on head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   f708dfb659049db50bb45df8026faabee2ee0ad7 /home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code` (exit
   2 means your file is wrong: fix it). Say for each of R1-1 and R1-2 whether it is closed.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-r2/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin`, and a `git archive`
  scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
  PATH and symlink the main folder's `node_modules` in). Scripts written with Write; probes and logs under
  `~/.cache/pec-r2/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Known flake: `capture-entrances` "R8-1 a page whose motion never stops…" under load. Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), R1-1 and R1-2 closed or not, `verdict`, `ac_status`
(per AC: what the review saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
