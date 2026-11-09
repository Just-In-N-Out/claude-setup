# Role: reviewer (Full round 2, report only): site-slider

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (a captured Elementor page pasted into Bricks 2.3.9 or 2.4.2 by `npm run site --elementor`, its sliders playing like the
site; `site:check`; the plain route and Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`
  (AC1–AC10; AC10 live). The job: on the `--elementor` route a captured Elementor carousel (Swiper) becomes one Bricks
  Slider (Nestable) of its real slides, with Bricks' settings from Elementor's `data-settings` (interval = delay + speed),
  the site's arrows and dots, Splide's CSS restored under the site reset by a shared class `site-slider-<4>`, and
  `site:check` holding paste sliders on their first slide; the plain route and Figma designs byte-identical. Q1–Q4 A taken.
- Branch `site-slider-fix1`, head `84e591dbdaf6fe3e6237be89098204fb9ea8c085`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach 84e591db…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builders' receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/builder/`
  (the second builder's in `cont/`). Their deviations (ledger, HANDOFF): AC7's "fails when the hold is removed" holds for
  the named test, not the fixture's own `site:check` exit; an icon-font arrow keeps Splide's chevron and arrows the page
  lacks are Bricks' own (both noted); AC3's RED is by mutants M32–M35; after a visitor uses the arrows Bricks keeps
  playing where the old site stopped (a note). Staging runs Bricks 2.4.2; `reference/bricks/` is 2.3.9.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: a real Elementor site's carousel pasting wrong in Bricks 2.3.9/2.4.2 (slides
   missing or doubled, loop copies kept, the wrong interval or type, arrows or dots misplaced or dead, the slider's CSS
   cancelled by the site reset on the live page, several sliders on a page, a slider inside a slide or a tab, slides per
   view > 1), a page without a slider changing bytes, the plain route or Figma designs no longer byte-identical, the
   renderer now running Bricks' own Splide differently from real Bricks, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-r2/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`

## Round 2 note
Round 1 (`evidence/site-slider/review-1/review.json`) found three P2s: R1-1 (Elementor Pro's carousel keys `show_arrows`,
`loop`… unread: no arrows, rewind instead of loop), R1-2 (`pauseOnHover: false` stored, which Bricks' `isset()` reads as
ticked), R1-3 (tiers sampled at exactly 991/767/478 read Elementor's tablet value for sideways phones). Fixer 1
(`7170a5a3` and around it; receipts `evidence/site-slider/fixer-1/`, read, don't trust): arrows, dots and loop come from
either key family or from what the captured page shows (noted); one writer for every checkbox that only ever writes
`true`, and the site renderer reads checkboxes with isset; a Bricks tier takes the part that covers most of its widths
(**Q4 A is now read "what the site shows across most of the tier", not "the value at each tier's widest width": say
whether the approved plan's AC text needs an amendment**), with the remaining difference (1 slide at exactly 767, 3 at
992–1023 for Elementor's 3/2/1) named in the note; a new fixture `elementor-carousels`; `BRICKS_TIERS` exported from
`src/core/site/controls.ts`; a checkbox line in `reference/bricks/README.md`. Its `found_else`: the Figma route's
`emit/carousel.ts` `manualSettings` stores `autoplay: false` on main (not this job). Review the whole story again from
`fd1986dc` and check those fixes hold on a real Elementor site. Keep probe scripts under `~/.cache/ssl-r2/`, never the
`/tmp` scratchpad (the PC loses power now and then).
