# Role: planner (Mini, a bug): site-menu-motion — a menu's sub-list jumps open instead of sliding as on the site

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com** (its bot check; Justin's rule), B-Dry staging or any live site; no logins;
never write to any WordPress site. Read-only on `~/Downloads` (copy what you need into your evidence folder).

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`,
`systematic-debugging` (prove the root cause with evidence before any fix). Mini mode
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`): load the project skill and only the
code/docs sections this touches; skip the full Step 1 context load; finish within about 20 steps. If this is bigger or
riskier than a Mini job, say so and recommend Full. Read the repo's `CLAUDE.md` (main folder
`/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3, `02481763`) and HANDOFF's site-menu section
(Build 2026-11-11.2: the capture presses menu, pop-up and drawer buttons; the paste carries each box as Bricks' Offcanvas
"opening and closing as on the site (its own animation…)") and site-motion (Build 2026-11-09.1).

## What Justin reported (2026-11-11, with a phone screenshot of the pasted menu drawer open)
"this service card here when someone clicks the arrow button the animation is not as smooth as it is on the official
website we need to fix that." The screenshot: B-Dry staging's phone menu drawer open, "Services ⌄" with its seven items
(Foundation Repair … Yard Drainage) shown under it, then About Us, Service Areas, Warranty, Contact Us, a phone icon and
"Get Your Estimate". His answers: **Mini**; on staging, tapping the arrow beside Services makes the list **jump open
instantly** (no slide); on bdryswi.com it slides open smoothly.

## The run that shows it (files on this PC)
Scan with Build 2026-11-11.3: capture `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`; pastes
`~/Downloads/bdry-test/paste/` (`header.json`, `page.json`, `footer.json`, `notes.txt`, …). The saved served home of
2026-10-29 with its CSS and scripts (`~/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/inputs/bdry-2026-10-29/`,
`~/.hermes/plans/figma-to-bricks/evidence/bdry-source/`) show how the site animates the sub-list (Elementor's nav menu:
likely jQuery `slideDown`/`slideUp` — a script-driven height animation, not a CSS transition — read it and say).

## The plan must settle
1. Root cause with file:line evidence: what the capture records about the sub-list's open motion (site-menu reads opened
   boxes; does it read a script's height animation, its duration and easing?), what the paste writes for the sub-list
   (a Bricks native element, a toggle, `<details>`, a Code element?) and why it jumps in Bricks 2.4.2.
2. The general fix for every scanned site whose menu sub-lists slide open (any duration/easing the site uses, open and
   close, Escape, reduced motion stands still), keeping the native Bricks structure (memory "importer native
   structure"; Bricks' own Nav/Dropdown/Offcanvas shapes only from `reference/bricks/` samples, never from memory). A CSS
   route (e.g. `grid-template-rows: 0fr → 1fr` or `interpolate-size`) vs a script: ⭐ recommend, with browser support.
   Menus that don't animate on the site stay as they are; Figma designs byte for byte.
3. Overlap with jobs running now (site-sticky-header: the header; site-scroll-lock: page-wide CSS): name shared files.
4. Numbered ACs, AC1, AC2…, each with one named test (each name whole on one line; a line that isn't an AC's definition
   never starts with a list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin re-pastes on
   B-Dry staging and the Services list slides open and closed on his phone as on the site.

## Write
`~/.hermes/plans/figma-to-bricks/site-menu-motion.md` (the builder copies it to
`docs/plans/2026-11-11-site-menu-motion.md`): playback in 3 plain lines, questions at the top with ⭐ answers (Justin's
standing auto-go runs the builder at once on them), root cause, fix, ACs, touched files, tasks, a one-line Docs &
records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/smm/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`). One plain git command per call, `git -C <absolute path>`. Use `tail -n 3`. Waits under
115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first.

## Report (as text)
The plan's path; the playback; the root cause; the fix; the ACs one line each (the live one named); questions with ⭐;
then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
