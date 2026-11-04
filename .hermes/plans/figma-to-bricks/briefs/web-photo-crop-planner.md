# Role: planner (Mini, bug): web-photo-crop (captured pictures cut at the bottom)

You are a fresh planner for FigmaToBricksV2. Plan only: no product code, no tests committed beyond the plan file, no
BUILD bump, no merge, no push, never start other agents. Never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, leave every other worktree alone.
Another job (web-human-reload) works on the capture's "I am human" browser code at the same time: stay out of
`src/web/human*.ts`, `src/web/session.ts` and `test/browser/chrome.ts`.

**Mini mode:** load the project skill and only the code/docs sections this touches; finish within about 15 steps. If
this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## The bug (Justin, 2026-11-04 ≈02:10, his paste of bdryswi.com's home into Bricks)

Three photo cards in a row ("Settling Foundation", "Basement Leaks", "Dangerous Moisture"): each picture has its own
label band baked into its bottom (logo, title, chevrons). In the paste the bottom of each picture is cut: the band's
words are half hidden. On bdryswi.com the whole picture shows. Screenshot: his message (bands cut through the words).

The capture: `/home/justin/Downloads/bdryswi-com-home.f2b-capture.json` (23.1 MB, 2026-11-04 ≈02:20, Build 2026-11-04.1;
note it has one range only, because of the other job's bug, so judge the desktop width). Its page converts with the panel's
Page choice (header/footer ticks on).

## Do

Load `systematic-debugging` first, then `engineering-best-practices` and `implementation-planning`; read the project
skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`.
1. **Prove it on the plugin first:** convert that capture's Page the way the panel does (replay/convert a capture: see
   HANDOFF's web-panel section and `tools/`), render it (`npm run snap`-style or the web renderer) at desktop width and
   find the three pictures: their boxes' height vs the picture's own ratio, `object-fit`, the capture's recorded size of
   each picture box and its parent (fixed height? `aspect-ratio`? a cropped `overflow`?) and what the site does.
2. **Root cause with file:line** (capture side or converter side), general for any site whose picture shows whole.
3. **The fix, general:** a picture the site shows whole stays whole in the paste at every width; a picture the site
   crops (cover) stays cropped. No key on this site, its names, sizes or words.
4. Plan in Mini format: playback, root cause, fix, touched files, numbered ACs (AC1…, **proposed**), each with one named
   test on one plan line (a generic fixture of the pattern, never a copy of bdryswi.com), plus: Figma replays
   byte-identical (or the exact intended change named), and `AC<n> (proposed) (live)`: Justin's re-paste shows the three
   pictures whole. A one-line Docs & records task.
5. Branch `web-photo-crop` from main `39d96c98`; write `docs/plans/2026-11-04-web-photo-crop.md`, commit it (plain `git
   commit -m`, no author override, no AI lines, no CLAUDE.md staged), copy to `E/planner/plan.md`
   (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop`).

## Rules

- Never load bdryswi.com (work from the saved capture). Live reads (GET only) only of the Hostinger site (`?f2b=`) and
  letsgro.ai; never write to any WordPress site; never call alttext.ai.
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wpc-plan/tmp`); Chrome found by itself or `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job of your own at a
  time, closed after each step. SIGTERM / 143 / 137 / "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since
  "-30 min" -o short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0
  <cmd>`. Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; no redirects or
  the bare word `source`.
- Put any summary in your report.

## Report

Branch, commit SHA, plan path; root cause in two lines with file:line; fix in two lines; ACs one line each (proposed,
live marked); then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills
or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
