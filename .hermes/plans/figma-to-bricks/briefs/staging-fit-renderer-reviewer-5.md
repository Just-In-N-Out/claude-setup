# Role: reviewer (round 5: fix round 4 only; report only): staging-fit-renderer

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging, an embed host or any live site (local stand-in servers and
saved files only); never write to any WordPress site; no logins. Nothing may hide that the tool's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run site:live -- <a published Bricks page> …` run by Justin or an agent on his
WordPress staging site; `npm run site:check`; the browser tests' renderer; Figma designs converting as before), each
with a concrete real-use scenario. Edge cases are P3. **Justin's rule "Never write to any WordPress site; GET/read only"
is this job's guard: anything but GET/HEAD/OPTIONS reaching the published site in normal use of `site:live` is P0/P1.**
**This is a delta review of one fix round; what is not a real-use bug goes to P3.**

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`.
- Branch `staging-fit-renderer-stack1-fix4`, head `9feaf48f9bd43f676e3b4fa921fdf5f9bc99f960` (code head `7b64eca5`; the
  last commit is records), on the stack `main 3cfc54ac ← site-faq ← site-reviews ← site-slider (7d9754ed) ← this job`.
  In your own worktree: `git checkout --detach 9feaf48f9bd43f676e3b4fa921fdf5f9bc99f960`, confirm HEAD and a clean
  status.
- **Scope: `git diff 898e0ebd71533244fe87fdc0eaf2c3c537a3ce3f..HEAD` and what it touches.** Review 4
  (`evidence/staging-fit-renderer/review-4/review.json`; probes `~/.cache/sfr-r4/probes/`, logs `~/.cache/sfr-r4/logs/`)
  found R4-1 and R4-2 (P2). The fixer's receipts (read, don't trust): `evidence/staging-fit-renderer/fixer-4/` (the
  `red-*`/`green-*` logs, `mutants/summary.txt`, `gates/`, `plain/plain.log`).
- What fix round 4 did:
  - **R4-1:** one shared predicate `libraryCopy` (`test/web/lib/site-check.ts`): a copy an element library makes of a
    pasted element (`.splide__slide--clone`, or anything inside one) is never one of the paste's elements. Used by
    `site:live`'s mapping walk `kids()` (copies skipped, counted, never marked), its part-root search, the new
    `locateInPage` (readSection's `{id}`, `{tag}` and `{css}` locators take the first match that is not a copy, or
    null — the old id rule fell back to the copy), `shootSection` and `shootSections`' section selector.
    `report.json` `parts.<part>.copies` and one tool line name the copies left out.
  - **R4-2:** in `site:live`'s drawing each live slot is stood in at the published page's own slot box at that width
    (measured from the page just before; the capture's size when the page shows no slot at a width); `liveStandIn`
    takes a new `onPage` box; a loader's own place becomes a block keeping the capture's margins; the new `setStandIn`
    helper is shared by `site:check` (its inline copy replaced) and `site:live`; the slot is left out of
    `compareDrawings` and named in `report.json` `renderer.live` and the tool's line.
  - **R4-3:** `site:live` calls `unstyledLine` after `loadSnapshot` (exit 2, the same line as `site` and `site:check`,
    before Chrome starts). **R4-5:** `shootSection` goes through `locateInPage`.
  - New tests: `test/web/site-live-slider.test.ts`, `site-live-standin.test.ts`, `site-live-unstyled.test.ts`,
    `shoot-section.test.ts`.
- Check hardest:
  - **`site:check` is used by every importer job's proofs, and its code changed** (`setStandIn` replacing its inline
    copy; `locateInPage` now returning null where the old id rule fell back to a copy; the `{tag}`/`{css}` locators and
    `shootSections`' selector gaining the copy rule): does any `site:check` or site-proof result change on a page with
    a live widget, a looping slider (several slides in view, so copies sit first), or neither? Run the stacked jobs' AC
    web files (`site-check-live-widget`, `site-widget-places`, `site-widget-codes`, `site-check-settle`,
    `site-elementor-swiper8`, `site-elementor-slider`, `site-elementor-carousels`, `site-elementor-open-item`,
    `site-cli`) and compare a `site:check` `report.json` of the swiper8 and live-widget fixtures between `898e0ebd` and
    the head.
  - R4-1 closed through `site:live` itself: the reviewer's own probe (`~/.cache/sfr-r4/probes/slider-live.ts`) on the
    head; a slider with one slide in view, with several in view, a slider inside a slider's slide, and a page with two
    looping sliders; can skipping copies now hide a real missing element (a paste element that only exists as a copy)?
  - R4-2 closed: the reviewer's probe (`widget-drawing.ts`) on the head; the stand-in at the page's own box must not
    hide a real difference **outside** the slot (a widget pushing the page 40 px further than the paste says: is that
    still reported where it matters, or silently absorbed?); what `report.json` says when the published page shows no
    slot at all (the widget's script failed, or code signatures weren't regenerated — the real first-run case on
    Justin's staging: would he be told plainly?); the read-only guard still lets nothing but GET/HEAD/OPTIONS reach the
    published stand-in while the widget's loader runs there.
  - The three surviving mutants (M2, M5, M13: "none reachable by any fixture") — reachable on a real page?
  - A plain page's `report.json` unchanged but for the cache-buster.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-5/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7d9754ed8adb5308bd525b309e7ba4672e284104 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer` (exit
2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-r5/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time; check with `ps` by your profile path that none is left, and never signal a
  process group other agents' Chromes are in. A worktree's `node_modules` may lack `.bin` and a scratch tree has no
  `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes and
  logs under `~/.cache/sfr-r5/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
