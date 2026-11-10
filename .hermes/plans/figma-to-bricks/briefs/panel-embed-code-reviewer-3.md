# Role: reviewer (round 3, the last under the cap: fix round 2 and what it touches; report only): panel-embed-code

You are a fresh reviewer who never saw the build or the fixes (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging, a widget vendor's host or any live site
(local fixture servers and saved files only); never write to any WordPress site; no logins. Nothing may hide that the
importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a capture of a real site converted in the Figma panel's website route, or with `npm run
site`, and pasted into Bricks 2.3.9 / 2.4; `npm run capture` on a real site; Figma designs converting as before), each
with a concrete real-use scenario. Edge cases are P3. **What a paste may run on the user's site is this job's guard:
any path by which a pasted Code element carries code that is not the widget's own (a tracking tag, a tag manager, a
loader, another widget's script, a page script, a shared library) is P0/P1.** A P0–P2 with no concrete real-use
scenario counts as P3. This is the job's third and last review round (the project's cap): be exact about what is a
real bug and what is a recorded limit.

## What happened before you
- The job: on both importer routes a pasted Code element runs only a widget's own code; what a capture can't prove is
  an empty box (a floating widget: listed, named).
- Review 1 found a chat started by a starter script was only listed (R1-1) and a site's own box drawn through a CDN
  library pasted the library (R1-2). Fix round 1 followed chains of script loads back to a served tag and skipped
  "libraries that never act alone". Review 2 got a tag manager and eight loaders with hidden or click-gated tracking
  pasted (R2-1, R2-2) and a vendor's button rebuilt as a dead copy noted as the site's own (R2-3).
- **Justin then chose, in a question (`evidence/panel-embed-code/review-2/justin.json`): "Safe rule": paste a floating
  widget's code only when the exact file that drew it is a tag the old page served; anything started by a starter
  script, a tag manager or the page's own script is listed with a plain note (add its install code by hand in one
  Code element).** That a chat started by a starter script is only listed is therefore his choice, not a finding.
- Fix round 2 (yours to review) builds that rule: code is pasted only when (a) the innermost file on the stack at the
  box's creation has its tags in the served HTML and (b) that file is alone on the stack (read 200 frames deep, the
  page's `Error.stackTraceLimit` put back; a stack that fills all 200 frames is marked cut and listed). Otherwise
  `own` is null with `ownWhy` `started` / `page` / `frame` / `unread`. A box drawn by another host's file is rebuilt as
  the site's own box only when the site's code is on its stack **and** the box "holds" only the site's things (a link
  to a page or place of the site, or a picture of its own; nothing that loads or links another host); otherwise it is
  listed. The chain following, the library skip, the per-file action record and the wrapping of fetch / XHR /
  sendBeacon are taken out.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`
  (AC1–AC11; AC11 live). **Known, not findings:** the plan lines to amend are listed in the ledger ("Fix pass 2") and a
  planner amends them after this review (Q4 A / AC7 gain "and that file drew it by itself", lines 188–189, R1-7's
  `e.how === undefined ? "older"`).
- Branch `panel-embed-code-fix2`, head `6b115d3fc55cf483025bf2a909c40194d0bced44`, base
  `f708dfb659049db50bb45df8026faabee2ee0ad7` (`main` has since moved to `7eeca437`: a later step moves the job). In
  your own worktree: `git checkout --detach 6b115d3fc55cf483025bf2a909c40194d0bced44`, confirm HEAD and a clean
  status. **Your scope: `git diff 4cfc7003..HEAD` (five commits) and what it touches**, read against `git diff
  f708dfb6...HEAD` where the fix meets the rest of the story; `4d6c6403` is the head before any fix.
- Review 2: `evidence/panel-embed-code/review-2/review.json`, probes `~/.cache/pec-r2/` (`scripts/probe.ts`, `out/`).
  Review 1: `review-1/review.json`, `~/.cache/pec-r1/`. The fixer's receipts (read, don't trust):
  `evidence/panel-embed-code/fixer-2/` (`red-*.log`, `web-final/`, `mutation.log`, `bytes.log`, `bytes-notes.log`).
  Recorded limits (don't re-report unless you rate one higher, with a scenario): `evidence/panel-embed-code/follow-ups.md`
  and HANDOFF's "Known limits" in the job's section. The fixer's own list of shapes still on the wrong side: a vendor
  function the page hands directly as a handler (`addEventListener("load", Vendor.start)`, `s.onload = Vendor.init`)
  has only the vendor's file on its stack, so its tag pastes and draws nothing; a site's own CDN-made box with no site
  link or picture is listed; a vendor box the site's script starts that links only to the site's pages is rebuilt as
  the site's own; a vendor file drawing through the site's own jQuery is the site's own box; a shadow root isn't read.

## Check hardest (probe with your own pages, outside the repo's fixtures; local servers only; draw each pasted footer
on a fresh page, click it, wait, and count what your servers received)
1. **Rule (b), "alone on the stack": try to get anything but a self-drawing widget file pasted.** The handler shape the
   fixer names (a tag manager or the page doing `s.onload = Vendor.init`, `addEventListener("load", Vendor.start)`,
   `setTimeout(Vendor.init)`, `requestAnimationFrame`, a promise `.then(Vendor.init)`, a `MutationObserver`, a
   `postMessage` handler, `document.currentScript` tricks): the vendor's file is alone on the stack though something
   else started it. What is pasted then: only that vendor's own served tag (the widget's own file: allowed by the
   rule) — or can the same trick paste **a tag manager's or loader's own tag** (a loader file that draws the box
   itself after its own tracking; a tag manager whose own code builds the launcher DOM; a served file that is both
   the tracker and the widget)? A served file that draws the box by itself and also tracks is the widget's own file
   by the plan's standard; say how the note reads for it. Async stacks (`await`, async stack tagging), native frames,
   `eval` / `new Function` / `blob:` code (no file on the stack: who is `made`?), an inline `<script type=module>`, a
   stack whose only file is the page itself, a served file loaded with a query string or hash differing from its
   served tag, a file served twice with different attributes, the same file name on two hosts, a 200-frame-deep
   stack.
2. **"Listed or the site's own" (the `holds` reading).** B1–B3 of review 2 and their neighbours: a vendor launcher
   that is a plain `<a href="/contact">` or links `tel:` only; a WhatsApp-style button (`<a href="https://wa.me/…">`:
   another host → listed? right); a launcher whose picture is a `data:` URI or an inline SVG; a box whose vendor
   content arrives after the read (an empty launcher at capture time); a site's own cookie bar linking a privacy page
   on the site (rebuilt: right) or another host's policy (listed: the note's words?); a `www.` / no-`www.` / subdomain
   site (`cdn.site.com`, `shop.site.com`: the site's or another's?); `srcset`, CSS `url()` in a class not inline, a
   `<picture>`, a background set by a stylesheet. Where a real, common shape lands on the wrong side: is anything
   pasted to run (P0/P1), is another company's widget called the site's own with no word of it (R2-3 again), or is the
   site's own box only listed (safe; rate by how common and what the note tells Justin)?
3. **What was taken out is really gone, and the captured page is touched as lightly as on `4d6c6403`:** no wrapper on
   fetch / XHR / sendBeacon; `createElement` and the stack read cost (200 frames on every element made: time
   `npm run capture` on the heavy local fixture and the offline B-Dry stand-in on `4d6c6403` and on head, twice each,
   same load; a slow-down a person would notice is a finding); the page's own `Error.stackTraceLimit` and
   `prepareStackTrace` behave as before for the page's code.
4. **Captures and both routes:** a capture made before this job, and Justin's saved captures, convert as on
   `4d6c6403` (payload byte for byte; note words aside); the code route byte for byte as base; **a capture carrying an
   `ownWhy` this build doesn't know** (round 1's `"shared"`, or a future reason read by an older plugin build): the
   fixer says it crashes the panel's note lookup — rate it (does a real capture file anywhere carry it? what does the
   panel do: a crash of the whole conversion, or one note?) and name the one-line guard; the panel's sandbox
   (`tsconfig.sandbox.json`); `capture:check`.
5. **Review 1's and review 2's probes re-run on head by you** (don't trust the fixer's run): nothing but self-drawing
   served files pasted, on both routes, every part; trackers, tag managers, SDKs and loaders asked 0 times when the
   paste is drawn and clicked.
6. The notes' words (`started`, `page`, `frame`, `unread`, the pasted line): true, one plain sentence, something
   Justin can act on. The tests can fail (read `mutation.log`; one or two mutants of your own under the 4 GB cap).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the embeds line: it ends with reviews 1 and 2's lessons and the safe rule) and
`references/rendering-validation.md`, the repo `CLAUDE.md` ("Architecture rules"; "Code Figma runs uses only the
language's built-ins"; "Website captures") and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review for real bugs (probes on `4d6c6403`, on `4cfc7003` where it helps, and on head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-3/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   f708dfb659049db50bb45df8026faabee2ee0ad7 /home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code` (exit
   2 means your file is wrong: fix it). Say for each of R2-1, R2-2 and R2-3 whether it is closed.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-r3/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`: it kills the tool's own shell). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch
  tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH
  and symlink the main folder's `node_modules` in). Scripts written with Write; probes and logs under
  `~/.cache/pec-r3/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Known flake: `capture-entrances` "R8-1 a page whose motion never
  stops…" under load. Waits under 115 s. The PC lost power twice this week: keep notes and finished probe results on
  disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), R2-1 / R2-2 / R2-3 closed or not, `verdict`,
`ac_status` (per AC: what the review saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
