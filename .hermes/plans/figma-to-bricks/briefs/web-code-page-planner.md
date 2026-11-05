# Role: planner: web-code-page (the code method for the whole page: header, page body, footer)

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, high effort at Justin's word). Plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never bare `git stash`, leave every other worktree alone. Never
load bdryswi.com: work from Justin's live capture (below) and the saved 2026-10-29 page.

## Why (Justin, 2026-11-04 evening)

web-code-proof (Build 2026-11-04.7, HANDOFF section, `docs/plans/2026-11-04-web-code-proof.md` with its design of the
whole switch) proved the code method live: Justin's capture of bdryswi.com
(`/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`, 36.1 MB, made with `npm run capture`, holds `web.code`;
copy it, don't change it) gives the "Many waterproofing companies" section 0 px off at 47 of 48 widths (1024 read the
check page), and his paste in Bricks looks right. Then: **"brother I need it to paste the whole page"**. So this job makes
the code method paste the whole page: the header part, the page body and the footer part, each its own paste as today.

What blocks it today: `npm run site -- <capture> <out> --path "body/div:0/div:0/div:0/div:0/main:0/article:0"` exits 2:
"The section holds what the proof can't map yet: svg (…)" (icons, a heading's inline svg, the service cards' svgs), and
the plan named frames, videos, form fields and drawings too.

## What to plan (smallest route to a whole-page paste that is 1:1 where CSS draws it)

1. **Every element kind on this page mapped** (find them all in the capture's `web.code`): inline `svg` (Bricks SVG
   element or an inline-SVG route proved against `reference/bricks/` samples; never from memory: if no sample fits, say
   what sample Justin must copy), `iframe` (the Google map → the plugin's existing map route; other frames → Code element
   or note), `video`, `form` and fields (static look now, the Bricks Form later: say so), `button`, `a` around anything,
   `picture/source`, lists, `br`, `i`/icon fonts and `::before` icons, hidden device-only copies (Elementor's
   `elementor-hidden-*` classes are just CSS: keep them), text beside elements (review P3 R1-6).
2. **The parts:** header, page, footer from the capture's existing parts (`web.parts`), each a paste; the header's sticky
   bar as the site's own CSS; floating extras.
3. **Widgets not built yet, honestly:** the hero slider (Elementor/Swiper: its slides as the site's markup with the first
   slide shown, or the Bricks Slider later; pick the faithful static choice now and say what moves later), the menu pop-up
   (later job), Trustindex reviews (server-rendered HTML/CSS: copy as is, with its own CSS, or the shortcode: ⭐ answer),
   scripts dropped (named in a note).
4. **Size and classes:** the whole page has ~800 elements; Elementor class names renamed by purpose with identical styles
   shared (proof's rule), wrappers kept (folding is a later job), the `site-reset` once per paste.
5. **The 1:1 check per section** with `npm run site:check` over the whole page (every section, every width), plus the
   capture's missing 1024 range handled (skip ranges the capture marks as not the page, named in the report).
6. **How Justin runs it:** `npm run site -- <capture> <out> --part header|page|footer` (or one command writing three
   files) and the clip steps (ASCII paste). The panel route stays a later job.
7. Questions for Justin with ⭐ answers (the build takes them under the standing auto-go); numbered ACs (AC1…,
   **proposed**), each one named test on one plan line, generic fixtures for each new element kind, the bdryswi.com page
   offline (saved inputs) and on his capture, Figma designs byte-identical, and a `(live)` AC: Justin pastes header, page
   and footer into staging and compares with bdryswi.com at 1440/1024/768/390.

Keep it to what gets the whole page pasting this round; list the rest as the next jobs.

## Skills and inputs

Load `engineering-best-practices`, then `implementation-planning`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md` and
`references/testing-pitfalls.md`; the repo `CLAUDE.md`; `reference/bricks/README.md` and samples; `docs/plans/2026-11-04-web-code-proof.md`
and its ledger; `src/core/site/`, `src/web/read/code*.ts`, `tools/site*.ts`; the follow-ups
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/follow-ups.md` (fold in the ones this job meets,
e.g. the CLI's Chrome finder: `npm run capture` failed on the desktop until `CHROME_PATH` was set).

## Write

Branch `web-code-page` from main (read `git rev-parse main` first; another session merges there: rebase-friendly plans);
`docs/plans/2026-11-04-web-code-page.md` committed (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md
staged); a copy at `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/planner/plan.md`.

## Rules

- Live reads (GET only) only of `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and
  `https://www.letsgro.ai/`; never bdryswi.com; never write to any WordPress site; never call alttext.ai.
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wpg-plan/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after each
  step. SIGTERM / 143 / 137 / "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Write scripts with
  Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls; no redirects, heredocs or the
  bare word `source`.
- Put any summary in your report.

## Report

Branch, commit SHA, plan path; every element kind found with its mapping in one line each; the widgets' choices; the
questions with ⭐; the ACs one line each (proposed, live marked); size estimate; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
