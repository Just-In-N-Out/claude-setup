# Role: planner (Mini, a bug): site-fonts-match — the pasted page's font looks different from the old site's

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com** (Justin's rule) or B-Dry staging or any live site; no logins; never write to any WordPress site.
Read-only on `~/Downloads` (copy what you need into your evidence folder).

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`, `systematic-debugging`
(prove the root cause with evidence before any fix). Mini mode (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`):
load the project skill and only the code/docs sections this touches; finish within about 20 steps; if bigger, recommend Full. Read the
repo's `CLAUDE.md` (main `11f07742`, Build 2026-11-11.5): the font rules (weights single whole hundreds; Google's link; "Every paste
carries `@font-face` rules for the design's families"; `site-fonts` class), HANDOFF's importer font sections.

## What Justin reported (2026-11-11)
"I personally felt there was a difference in font between the two pages, the official bdry page and what I copy pasted… Do we need
to import the fonts in WP manually?" (Mini; the standing "go with recommended".)

## What the main session saw (a lookup)
His pastes `~/Downloads/bdry-test/paste/{header,page,footer}.json` (Build 2026-11-11.3 scan, `--elementor`, pasted on B-Dry
staging, Bricks 2.4.2): header and page each carry two `@font-face` rules as embedded `data:` fonts — `"Roboto Flex"` (one face)
and `"elementskit"` (icons); the footer carries none; no Google Fonts link. Capture: `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`.
The saved served page and its CSS (`~/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/inputs/bdry-2026-10-29/`,
`evidence/bdry-source/`) show how the site loads its fonts.

## The plan must settle (file:line evidence)
1. What the site draws: each text element's computed `font-family`, `font-weight`, `font-stretch`/`font-variation-settings`,
   `font-style`, `font-size`, `letter-spacing`, `line-height` at 1440 and 390 (from the capture and the saved page served
   locally), and which font file(s) the browser actually used (CDP `CSS.getPlatformFontsForNode`).
2. What the paste draws: the same, drawn in the test renderer as Bricks 2.4.2 prints it (whole page: header + page + footer), with
   the paste's own `@font-face` — which faces it embeds (one Roboto Flex face: a variable font covering every weight/width, or one
   static weight?), whether the footer's text finds the font (no `@font-face` in footer.json: does the page's face reach it when all
   three are pasted on one page? when the footer goes into a Footer template?), and what staging's Bricks Theme Style / theme might
   add (read B-Dry staging's saved builder files in the evidence folders; never load staging).
3. The root cause, per difference (family, weight, width, size, hinting), and the general fix for every scanned site; whether
   Justin needs to do anything in WordPress (⭐ recommend: nothing — the paste carries what the site draws).
4. Numbered ACs, AC1, AC2…, each with one named test (each name whole on one line; a line that isn't an AC's definition never starts
   with a list marker followed by `AC<n>`), all **proposed**; one `(live)` AC: Justin re-pastes and the words on staging match
   bdryswi.com's side by side at desktop and phone.

## Write
`~/.hermes/plans/figma-to-bricks/site-fonts-match.md` (builder copies it to `docs/plans/2026-11-11-site-fonts-match.md`): playback in
3 plain lines, questions with ⭐ answers (auto-go), a side-by-side table of the differences found, root cause, fix, ACs, touched
files, tasks, one-line Docs & records. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/planner/` (a site |
paste picture of the same heading and paragraph at 1440 and 390). Overlaps: site-shared-styles (text classes; planned), site-no-div,
media-avif-alt (none expected).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sfm/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (`pgrep -f '[u]ser-data-dir=<path>'`);
every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Write scripts with the Write tool; `git -C
<absolute path>`. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since
"-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; you may write the plan file)
The plan's path; playback; the differences table; root cause; fix; whether Justin must do anything in WordPress; ACs one line each
(live named); questions with ⭐; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
