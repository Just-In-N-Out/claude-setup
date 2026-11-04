# Role: method reviewer (read only): is the website importer's method right?

You are a fresh, independent reviewer for FigmaToBricksV2. Investigate and report only: change no source, commit
nothing, start no agents, never touch the main folder `/home/justin/Documents/FigmaToBricksV2` except to read it. Never
load bdryswi.com (a bot check; work from the saved capture). Never write to any WordPress site.

## Why

Justin (2026-11-04), after pasting bdryswi.com's homepage made by the importer into Bricks: "it looks really bad",
"the header is still chopped", "the review was not captured", and "I feel like the way we are importing is wrong … lets
pause everything and go back and see the method". All building is paused until he decides the method.

## The method today (read, don't trust this summary)

Plan and Justin's answers: `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` (§ Justin's answers, the
recommendation, §1–§3, §6). Spec: `docs/specs/web-capture.md`. Code: `src/web/` (capture: reads the live page in Chrome at
every switch point and writes a Snapshot shaped like the Figma debug file), then the plugin's Figma converter
(`src/core/`: normalise → understand → style → adapt → emit; `adapt/site/` and rule `site.tiers` for per-width layouts).
Built: waves 1–2 (capture, compare, panel, address box, tiers, embeds) + fixes (human-check, photo-crop, human-reload).
Not built: ranges/stretchy sizes (J3), hover (J6), sliders/accordions (J8), motion (J7), forms (J9), flip/hotspots/pop-ups
(J10). HANDOFF has each job's section, rulings and known limits.

## Inputs

- The capture he pasted: `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdryswi-com-home-2026-11-04-0627.f2b-capture.json`
  (35 MB, Build 2026-11-04.3; all 15 ranges; its 577-767 range was read while the site reloaded itself). It holds the
  site's own screenshots/boxes per width (find them in the snapshot's `web` data).
- Convert it with main's code as the panel does (Page, Header, Footer; header/footer ticks as the panel defaults), e.g.
  `node tools/replay.ts <capture> <out> --part=page|header|footer`, and render the pastes with the repo's renderer
  (`npm run snap`-style / `test/browser/render.ts`) at 1920, 1440, 1024, 768 and 390.

## Work

Load `engineering-best-practices` and `systematic-debugging`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md`.
1. **Side by side:** for each section of the homepage (top to bottom) and each width above, the site's own shot vs the
   rendered paste. Save pairs as PNGs in `E/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/method-review/`).
2. **Sort every visible difference** into exactly one bucket, with the cause traced to file:line or capture data:
   - **(1) not built yet** (a planned job covers it: name the job);
   - **(2) a bug in something built** (name the stage and file);
   - **(3) a weakness of the method itself**: information the capture never records, or that is lost by squeezing the
     site's CSS into the Figma-shaped Snapshot (fixed px sizes instead of the site's rules: %, auto, aspect-ratio,
     flex/grid tracks, max-width, clamp; absolute positions; text wrapping), so fixing one case at a time won't converge.
   Look hard at the two he named: the **header "chopped"** (header part and how the page starts under it) and the
   **reviews** (a Trustindex widget: captured? pasted as a Code element? would it run on the live page after Regenerate
   code signatures?).
3. **Count** the differences per bucket, weighted by how visible they are (a broken hero counts more than a 2px gap).
4. **The method question:** given the buckets, is the method right but unfinished, or wrong at its core? Compare, with
   evidence from this capture, these alternatives and say what each would fix and break (editability in Bricks, 1:1
   fidelity at every width, work left, risk):
   - A (today): measure boxes per width → rebuild native Bricks elements through the Figma converter.
   - A′: same capture, but carry the site's own CSS rules per element and per range (class + custom CSS / Bricks
     settings from computed or authored CSS) instead of measured px, bypassing Figma-shaped sizing where it loses intent.
   - D: a direct HTML/CSS → Bricks route (the site's DOM and stylesheets mapped to Bricks elements with its classes),
     not through the Figma converter.
   - E: Bricks' own tools (Migration Engine for Elementor; Bricks 2.3+ "HTML & CSS to Bricks"), with what they need.
   Name the one you recommend and the first concrete step, in plain words.

## Output

`E/report.md`: plain words for Justin (no jargon without a one-line meaning), short. Start with the answer in three lines,
then the bucket table with counts and the biggest examples (each with its PNG pair), then the method comparison and the
recommendation. Keep file paths and code detail in an appendix at the end. Also `E/findings.json` (each difference:
section, width, bucket, cause, file:line, images).

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/mrv/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` or the CPU wrapper
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job at a time, closed
  after each step. Work in your own worktree on main `31321bb4`; the worktree's `node_modules` may lack `.bin` (see
  testing-pitfalls).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls; no
  redirects, heredocs or the bare word `source`.

## Report

Three-line answer, the bucket counts, the recommendation, the report path; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
