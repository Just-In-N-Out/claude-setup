# Role: reviewer (Mini round 1: the one full review, plus the verifier's AC work; report only): site-menu-motion

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder or other worktrees. Never load bdryswi.com, B-Dry staging or any live
site (local fixtures and saved files only); no logins; never write to any WordPress site; touch nothing under `~/Downloads`
(Justin's scan is copied to `evidence/site-menu-motion/builder/bdry-capture.json`). The importer never hides that its Chrome
is automated; every Chrome a capture starts launches through `launchCaptureChrome`; presses stay under the press guard.

**Importer rule:** report as P0–P2 only bugs a real site or normal use hits (a real site scanned, converted, pasted into
Bricks 2.3.9/2.4, its menu used on a phone), each with a concrete real-use scenario; edge cases are P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/plan-approved.md` (AC1–AC7;
  AC7 live: `not_run`). The job: inside a box a button opens, where the site's script animates a `<details>`' own height when
  its summary is pressed, the scan records duration and easing (`CodeNode.slide`), and the paste plays the same on open and
  close (a marker class on the list + one Code element in the Offcanvas's Content); reduced motion stands still.
- Branch `site-menu-motion-build`, head `4f0882b1` (full SHA with `git rev-parse`), base main
  `0248176342c662b821629d462f4d15a2a2a1df98`. Review `git diff 02481763...HEAD`. Builder receipts (read, don't trust):
  `evidence/site-menu-motion/builder/`.

## Check hardest
1. The capture: pressing a closed list's summary during the scan — the press guard (no data-sending request, no page load,
   no socket; site-menu's rule), every list put back as it was, no slowdown worth noting, a site whose summary press opens
   a link or navigates, a list that's open by default, nested lists.
2. The paste on a real phone menu: B-Dry's Services (Elementor Nested Accordion in the ☰ Offcanvas) — open and close by tap
   and Enter, a second tap mid-slide, close the drawer mid-slide then reopen it (is the list left half-open?), Escape, two
   lists in one drawer, the Code element's script running once per page when header and page are pasted separately, Bricks'
   "Regenerate code signatures" path, the editor (it doesn't run: what does Justin see?).
3. The script: `self.` only; no global leak; Bricks 2.3.9 and 2.4.2.
4. `src/web/read/opens.ts` at 326 lines (over ~300): note only.

## Verifier's AC work (Mini)
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it: every AC's cited test
on head (pass) and on old code (a `git archive` of `02481763` with head's test files and fixtures copied in; `base_exempt`
with a reason and a mutant where it rightly passes on base, e.g. AC4), named-only AC6 by name with
`F2B_SITE_SLIDE_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/builder/bdry-capture.json`, a picture
per AC, AC7 `not_run`. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/verifier/ac.json` and logs
there (check it's empty first). Gates: `npm run check` on head (8G scope).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/review-1/review.json` (round 1, full SHA), self-checked
with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion`. Load
`requesting-code-review` and `code-review-practice`; read the project skill with `references/live-site-reading.md` and
`references/testing-pitfalls.md`; read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/smr/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). A `git archive` tree needs main's `node_modules` symlinked; piped/chained git
commands may be refused (script files; `git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s; long runs with `setsid
--fork`, waiting on `^EXIT=`. Every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`;
`capture-opens-guards`' service-worker cases flake on main: rerun alone before judging. SIGTERM/143/137/"Killed" may be
earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only review.json, ac.json and logs are written)
Findings one line each (id, P0–P3, file:line, the real-use scenario) or "none"; per AC: test, head, old code, evidence;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
