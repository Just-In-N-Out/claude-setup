# Role: planner: web-code-proof (the website importer's new method: the site's own HTML + CSS → Bricks, proved on one section)

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, high effort at Justin's word). Plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, leave every other worktree alone. Never
load bdryswi.com (bot check): work from saved captures; the capture tool may be extended but agents never run it there.

## Why (Justin, 2026-11-04)

His bdryswi.com paste "looks really bad"; he: "I feel like the way we are importing is wrong", "I want a method that can
help us get one to one, not relying on photos or images but actual code". The method review
(`/home/justin/.hermes/plans/figma-to-bricks/evidence/method-review/report.md`, `findings.json`, `pairs/`) found today's
route (measure boxes → Figma-shaped Snapshot → the Figma converter) right only at 1440 and wrong at its core, and
recommended **D**: map the site's own elements one for one to Bricks elements, its classes to Bricks classes, its CSS
rules (media queries included) as they are, keeping today's capture driver, panel and helper. Justin: "go with what the
planner said … the HTML and the CSS part". First a proof on one section, then the whole switch.

## What to plan

1. **A short design of the whole switch (one page in the plan, not built now):** the new route's stages (capture of DOM +
   classes + matching CSS rules per element and per site width / the site's own media queries; a converter DOM + rules →
   Bricks JSON with Bricks classes, native controls where Bricks has them and custom CSS otherwise; cancelling Bricks' and
   the theme's base CSS once; Elementor wrapper flattening and class renaming by purpose; pictures/fonts/links through the
   existing panel; widgets: slider → Bricks slider, pop-up → Bricks pop-up/Offcanvas, server-rendered plugin widgets →
   their shortcode), what of today's code carries over and what is retired for websites (`src/web/map` into the Figma
   converter), how Figma designs stay untouched, and the job order after the proof (header with the menu button and
   sticky bar; reviews → Trustindex shortcode; then the whole page, then other pages). Respect the repo's architecture
   rules (CLAUDE.md "Architecture rules", typed CSS until emit, deterministic ids, Bricks samples in `reference/bricks/`,
   payloadProblems, the "Bricks caps every element at its parent's width", layout keys by element and Align-self
   gotchas) or say where the website route needs its own module and why.
2. **The proof, fully planned for a builder:** the section "Many waterproofing companies…" (photo + text, capture layer
   `w265` in `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdryswi-com-home-2026-11-04-0627.f2b-capture.json`).
   The saved capture lacks classes and stylesheets: decide how the proof gets the section's real code without loading
   bdryswi.com (the 2026-10-26 saved home HTML `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-source/home.html`
   and its referenced CSS if saved; or a local stand-in built from it; or a capture-tool extension proved on the
   Hostinger site and a local Elementor-like fixture, with bdryswi.com's own run left to Justin as a live AC). The pass
   bar from the review: render the Bricks paste at every width the capture read (45) and match every word and picture
   within 2 px of the site's boxes; plus a generic fixture (not a copy of bdryswi.com) proving the converter on another
   structure, and Figma conversions byte-identical.
3. **Questions for Justin** with ⭐ answers (the build takes the ⭐s under the standing auto-go): e.g. class naming
   (keep Elementor's vs rename by purpose), how much Elementor wrapper flattening, where the new route lives (a new
   `src/web/bricks/` emitter vs extending `src/core/emit`), how the panel offers it (replace the old route for websites
   or a choice), Bricks base-CSS cancelling scope.
4. Numbered ACs (AC1…, **proposed**), one named test each on one plan line, `(live)` right after the id for Justin's own
   checks (his paste of the section into Bricks next to bdryswi.com at desktop/tablet/phone).

## Skills and inputs

Load `engineering-best-practices`, then `implementation-planning`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md`,
`references/testing-pitfalls.md`; the repo `CLAUDE.md`; `reference/bricks/README.md` and the samples; `docs/specs/web-capture.md`;
`src/web/` (driver, `read/authored.ts`, `read/page-reader.ts`, `capture.ts`, `session.ts`); `src/core/emit/`. Research
Bricks 2.3's "HTML & CSS to Bricks" (https://academy.bricksbuilder.io/article/html-css-to-bricks/) for how Bricks itself
maps tags, classes and media queries, and use what fits.

## Write

Branch `web-code-proof` from main `31321bb4`; `docs/plans/2026-11-04-web-code-proof.md` committed (plain `git commit -m`,
no author override, no AI lines, no CLAUDE.md staged); a copy at
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/plan.md`.

## Rules

- Live reads (GET only) only of `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and
  `https://www.letsgro.ai/`; never bdryswi.com; never write to any WordPress site; never call alttext.ai.
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wcp-plan/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own
  at a time, closed after each step. SIGTERM / 143 / 137 / "Killed" may be an earlyoom kill (`journalctl -u earlyoom
  --since "-30 min" -o short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>`. Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate
  plain calls; no redirects, heredocs or the bare word `source`.
- Put any summary in your report.

## Report

Branch, commit SHA, plan path; the design in five lines; the proof's tasks in one line each; the questions with ⭐; the
ACs one line each (proposed, live marked); size estimate of the whole switch (jobs); then `skill_lessons[{skill,
lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
