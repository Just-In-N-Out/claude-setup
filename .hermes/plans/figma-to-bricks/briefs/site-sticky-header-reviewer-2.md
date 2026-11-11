# Role: reviewer (round 2, a delta: fix round 1; report only): site-sticky-header

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents. Never
load any live site; never write to any WordPress site; touch nothing under `~/Downloads`. **Time box: 30 minutes.**

**Importer rule:** report as P0–P2 only bugs a real site or normal use hits, each with a concrete real-use scenario; edge
cases are P3.

## What to review
Branch `site-sticky-header-fix1`, head `c370ffa23f5157776d5c7bb710f6a4c9608b7cb6`; the fix commits since review 1's head
`ad041d3d8a73b34eaa2f3de2ab941013f0238e1b`: `git diff ad041d3d c370ffa2` (and what they touch). Base main
`0248176342c662b821629d462f4d15a2a2a1df98`. Review 1: `evidence/site-sticky-header/review-1/review.json` (R1-1 P2: the guard
stopped Bricks' `body.no-scroll` from holding the page; R1-4 AC4's test used `includes()`; R1-5 the sums helper proved
against its own output). Approved plan, amendment 1 (AC4: exactly five rules):
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md`. Fixer receipts (read, don't
trust): `evidence/site-sticky-header/fixer-1/`.

## Check
1. R1-1 fixed: in your own worktree (`git checkout --detach c370ffa2…`) draw the code-page fixture (Bricks 2.4.2 and 2.3.9,
   1440 and 390, in the page and in a Header template, with and without `html, body { overflow-x: hidden }` in Additional
   CSS, with and without site-scroll-lock's class from branch `site-scroll-lock-build`): scroll 600, add `no-scroll`, turn a
   real wheel (`Input.dispatchMouseEvent` `mouseWheel`, never `scrollTo`) → bar at 0, page at 600; remove `no-scroll`, wheel
   → page moves. Also open and close a real Bricks Offcanvas with "No scroll" if a fixture has one.
2. The two new rules don't break anything else: a page with no pop-up scrolls normally; nothing else on the page changes
   (`overflow-y` on html/body only while `no-scroll`).
3. R1-4: AC4's unit test is an exact five-line comparison; a sixth rule fails it.
4. R1-5: the sums helper reads main's sums from git; the eight new sums are honest (each variant minus class and note equals
   main's).
5. One mutant of your own on the new lines under a 4 GB cap.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/review-2/review.json` (round 2, a delta from `ad041d3d`;
full SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base 0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header`.
Load `requesting-code-review` and `code-review-practice`; read the project skill's `references/testing-pitfalls.md` (the wheel
and sibling-class mutant lines).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sh2/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`); every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
Piped/chained git commands may be refused (script files; `git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first.

## Report (as text; only review.json is written)
Findings or "none"; each check's result; `verdict`; `ac_status` (AC1–AC4 on the fix); `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
