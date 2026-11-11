# Role: planner (Mini, a bug): site-sticky-header — the pasted header doesn't stay at the top while the page scrolls

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com** (its bot check; Justin's rule), B-Dry staging or any live site; no logins;
never write to any WordPress site. Read-only on `~/Downloads` (copy what you need into your evidence folder).

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`,
`systematic-debugging` (prove the root cause with evidence before any fix). Mini mode
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`): load the project skill and only the
code/docs sections this touches; skip the full Step 1 context load; finish within about 20 steps. If this is bigger or
riskier than a Mini job, say so and recommend Full. Read the repo's `CLAUDE.md` (main folder
`/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3, `02481763`), its "Website captures" decision
("A part's own fixed content stays in its part": a sticky header bar stays inside its part's root, marked
`web.position: "fixed"`) and HANDOFF's sections on the header (web-header-spacer, site-menu, the whole-page paste).

## What Justin reported (his words, 2026-11-11)
"the header does not scroll down with the user as they are scrolling down with the page we need to fix that."
On bdryswi.com the header stays at the top while you scroll; on his paste on B-Dry staging (Bricks 2.4.2) it scrolls away.
His answers: **Mini**; he pasted `header.json` **into the page itself** (at the top, above `page.json`), not into a Bricks
Header template; he doesn't know whether `html, body { overflow-x: hidden }` is in staging's Additional CSS (it may be —
he uses it on other sites; that rule stops `position: sticky` from sticking, so the fix must hold either way, or the plan
says plainly what he must check).

## The run that shows it (files on this PC)
Scan of bdryswi.com's home with Build 2026-11-11.3: capture `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`;
pastes `~/Downloads/bdry-test/paste/` (`header.json`, `page.json`, `footer.json`, `notes.txt`, …). The saved served home
of 2026-10-29 with its CSS bundles (`~/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/inputs/bdry-2026-10-29/`)
and `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` show how the site makes its header stay (Elementor's sticky
— a script that switches the bar to `position: fixed` on scroll, with a spacer — or CSS `position: sticky`; read it).

## The plan must settle
1. Root cause with file:line evidence: what the capture records about the header's stuck state, what the paste writes
   (position, top, z-index, the bar's parent, a spacer), and why it doesn't stick in Bricks 2.4.2 when pasted in the page
   (a sticky element only sticks within its parent's box: a header Section whose parent is only as tall as the header
   never sticks; an `overflow` ancestor; Bricks' own wrappers `#brx-content`/`#brx-header`). Draw it with the repo's
   renderer (`test/browser/render.ts`, Bricks 2.4.2's front-end CSS) and scroll.
2. The general fix for every scanned site whose header stays put (sticky or fixed on the site), for **both** places a
   person pastes it: in the page itself (Justin's way) and in a Bricks Header template (Bricks' own sticky header
   setting, if a sample shows it: `reference/bricks/`; never from memory) — ⭐ recommend which the paste targets and say
   what Justin does in Bricks. The stuck look the site switches to on scroll (a smaller logo, a shadow) if the capture
   holds it, or stays out, named. No header on a site that doesn't stick changes; Figma designs byte for byte.
3. The overlap with job **site-scroll-lock** (running now: it adds a sideways-scroll lock to every importer paste and
   uses `overflow-x: clip` so sticky keeps working): name the shared files and make sure the two meet (the lock must not
   stop this header sticking).
4. Numbered ACs, AC1, AC2…, each with one named test (each name whole on one line; a line that isn't an AC's definition
   never starts with a list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin re-pastes on
   B-Dry staging and the header stays at the top while he scrolls, on desktop and phone.

## Write
`~/.hermes/plans/figma-to-bricks/site-sticky-header.md` (the builder copies it to
`docs/plans/2026-11-11-site-sticky-header.md`): playback in 3 plain lines, questions at the top with ⭐ answers (Justin's
standing auto-go runs the builder at once on them), root cause, fix, ACs, touched files, tasks, a one-line Docs &
records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssh/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`). One plain git command per call, `git -C <absolute path>`. Use `tail -n 3`. Waits under
115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first.

## Report (as text)
The plan's path; the playback; the root cause; the fix and where he pastes; the ACs one line each (the live one named);
questions with ⭐; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
