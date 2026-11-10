# Role: reviewer (Full, round 3: the fix commits only, report only): site-slider

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture -- <a real Elementor site>` then `npm run site -- … --elementor`, its
carousels and hero sliders pasted on Bricks 2.3.9 / 2.4 as Slider (Nestable); pastes without a slider and the plain
route as before; Figma designs converting as before), each with a concrete real-use scenario. Edge cases are P3.
**This is the last review round of this job** (the project caps review rounds at 3): what is not a real-use bug goes to
P3.

## Inputs
- Approved plan (read-only, **amended today**, amendments 1–6 listed at its top; the pre-amendment copy is
  `plan-approved-v1-before-amendments.md` beside it): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`.
  The amendment was written while fix round 2 was still under way, so set its marked lines against the head: amendment 4
  (AC4: the restore class's text against Bricks' `splide-layer.min.css`), the rule's and AC9's `height "auto"` lines,
  and AC6's "one per real slide" against what the head does for a carousel showing several slides at once (review 2's
  R2-4, deferred, named in the paste's note). A plan line the head makes false is a finding (say which side is wrong).
- Branch `site-slider-fix2`, head `a97b102c3e8325394bb9bf9d554245b13fa3d9a8` (code head `b9a084ad`; the last commit is
  the ledger), on local `main` `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3). In your own worktree:
  `git checkout --detach a97b102c3e8325394bb9bf9d554245b13fa3d9a8`, confirm `git rev-parse HEAD` and a clean status.
- **Scope: the fix commits `git diff 84e591dbdaf6fe3e6237be89098204fb9ea8c085..HEAD` and what they touch:**
  - R2-1 (`slider-look.ts`): a slide's own declared height (anything but `auto`, percentages too) is repeated
    `!important` on the slider's class per run of ranges, on `.splide__slide` where slides agree, else on each slide's
    own class; the row's own height (but Swiper's 100%) on Splide's list.
  - R2-2 (`slider-css.ts`): a restored Splide rule reaching into a slide's content is wrapped whole in `:where()`.
  - R2-3 (`elementor-slider.ts` `placedLike`): the site's arrow and dot places are copied when the box they answered to
    on the site is the box Bricks' arrows and dots answer to in the paste; both notes reworded.
  - `test/web/lib/site-check.ts`: `site:check` reads a looping slider's real slide, never Splide's copy.
  - The new fixture `test/fixtures/web/sites/elementor-swiper8/` (Elementor's Swiper 8.4.5 and Pro Elements' Slides CSS
    by byte copy; `SOURCES.txt`, `SHA256SUMS`) and `test/web/site-elementor-swiper8.test.ts`.
- Review 2 (`evidence/site-slider/review-2/review.json`, its probes under `~/.cache/ssl-r2/`) and the fixer's receipts
  (read, don't trust): `evidence/site-slider/fixer-2/` (`logs/`, `mutation-head/`, `gates/`, `swiper8-check/`,
  `probes/`).
- Check hardest:
  - the `!important` height: a hero whose slides size by `min-height`, `vh`, `aspect-ratio` or content; a height that
    changes per Elementor breakpoint; the same class on Splide's loop copies; B-Dry's own hero (AC9) unchanged;
  - `:where()` scoping: nothing else in the restore class lost its weight; selector lists not voided;
  - `placedLike`: arrows or dots answering to different boxes on site and paste now copied wrongly (a carousel inside
    a positioned column; a fixed part);
  - the `site-check.ts` change: can it hide a real missing element (reading a real slide where the paste draws none)?
  - the fixer's `found_else` 2: `site:check --all --elementor` fails at 992 on a default Image Carousel whose pictures
    fill their slides (the paste shows the desktop count from 992 to 1023, amendment 1's named difference; the fixture's
    pictures were made 300 px wide so its own check passes). Is the fixture still an honest proof, and how will a real
    site's check read? Rate it by the importer rule and say what Justin would see.
  - pastes without a slider, the plain route and Figma conversions byte for byte as before.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Site sliders") and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md` with the slider sample under `reference/bricks/`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs (three trees per probe where it helps: base, `84e591db`, head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/review-3/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-r3/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of
  your own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step
  commands from a script file written with Write; keep probes and logs under `~/.cache/ssl-r3/` (a restart empties
  `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
