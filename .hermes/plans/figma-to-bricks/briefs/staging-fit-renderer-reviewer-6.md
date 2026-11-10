# Role: reviewer (round 6: fix round 5 only; report only): staging-fit-renderer

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging, an embed host or any live site (local stand-in servers and
saved files only); never write to any WordPress site; no logins. Nothing may hide that the tool's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run site:live -- <a published Bricks page> …` run by Justin or an agent on his
WordPress staging site; `npm run site:check`, which every importer job's proofs run through; the browser tests'
renderer; Figma designs converting as before), each with a concrete real-use scenario. Edge cases are P3. **Justin's
rule "Never write to any WordPress site; GET/read only" is this job's guard.** This is a delta review of one narrow fix
round; what is not a real-use bug goes to P3.

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`.
- Branch `staging-fit-renderer-stack1-fix5`, head `abf1271404d62df57118e90b1fa9b12d0b02a384` (code head `0dcc7a4e`; the
  last commit is HANDOFF and the ledger). In your own worktree: `git checkout --detach
  abf1271404d62df57118e90b1fa9b12d0b02a384`, confirm HEAD and a clean status.
- **Scope: `git diff 9feaf48f9bd43f676e3b4fa921fdf5f9bc99f960..HEAD` and what it touches.** Review 5
  (`evidence/staging-fit-renderer/review-5/review.json`; probes `~/.cache/sfr-r5/probes/`, logs `~/.cache/sfr-r5/logs/`)
  found R5-1 (P2). The fixer's receipts (read, don't trust): `evidence/staging-fit-renderer/fixer-5/` (`red/`, `green/`,
  `ab/check-ab.log`, `ab/live-ab.log`, `mutants/summary.txt`, `gates/summary.txt`).
- What fix round 5 did:
  - **R5-1:** `locateInPage` (`test/web/lib/site-check.ts`): an `{ id }` locator is the element's id, else its
    `brxe-<id>` class, each the first match that is no library copy (`libraryCopy`); an element Bricks prints with its
    id and no such class is still found by its id. `readSection` and `shootSection` go through it; `shootSections`
    (`tools/lib/site-measure.ts`) now takes a locator and calls `shootSection` (`site:check` passes `{ id }`,
    `site:live` the mark); `liveStandIn` names its slot `:is(#brxe-<id>, .brxe-<id>) > :first-child`.
  - **R5-2:** `drewNothing(widths, at, captured)`: where the page's live slot is under 1 px tall while the capture's is
    1 px or taller, `site:live` prints one line naming the widget, its host, the part, the slot and the widths ("…if
    this is a fresh paste, regenerate code signatures in Bricks and purge the cache"); exit code unchanged.
  - New tests: `test/web/locate-remount.test.ts`, `site-live-carousels.test.ts`, `site-live-drew-nothing.test.ts`,
    `test/unit/site-drew-nothing.test.ts`.
- Check hardest:
  - **the class fallback finding the wrong element:** a `brxe-<id>` class is not unique the way an id is — a Bricks
    query loop, a slider's loop copies (skipped by `libraryCopy`), an element pasted twice on one page, a nested
    component, a global element printed in header and page, a `brxe-<id>` substring of another class (`brxe-abc` against
    `brxe-abcdef`: is the selector exact?). Can `site:check` or `site:live` now read or shoot another element where the
    old id rule read the right one or null? `site:check` must stay byte for byte: confirm on the five fixtures the
    fixer named and on one of your own with two elements sharing a `brxe-` class;
  - R5-1 closed through `site:live` itself (review 5's probe `carousel-missing.ts` / `slider-live.ts` on the head): the
    carousels fixture's paste as Bricks 2.4.2 prints it, renderer OK at every width, nothing missing; a slider with
    several slides in view; the control without per-width settings unchanged;
  - `liveStandIn`'s new selector: its specificity against the paste's own rules for the slot (the fixer says it keeps
    one id's specificity), with and without the id present;
  - R5-2: the line when the widget drew nothing (loader 404), no line when it drew, no line when the old site also
    showed the slot empty or the page doesn't show the slot at that width; the wording is true for a fresh paste and
    not misleading for a widget whose host is down;
  - the read-only guard untouched (nothing but GET/HEAD/OPTIONS reaches the published stand-in in the new tests);
  - the fixer's `found_else` 1 (a suspicion, not proven): on a live Bricks page a slide its own CSS targets as
    `#brxe-<id>` may lose that CSS after Splide re-mounts a slider with per-width settings. Say from the code and the
    Bricks sample whether an importer paste's slides carry any `#brxe-<id>`-keyed CSS at all (the importer writes global
    classes), and so whether this can touch a pasted carousel; it concerns another job (site-slider), so rate it as a
    note, not a finding of this job, unless this diff causes it.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-6/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7d9754ed8adb5308bd525b309e7ba4672e284104 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer` (exit
2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-r6/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time; check with `ps` by your profile path that none is left, and never signal a
  process group other agents' Chromes are in. A worktree's `node_modules` may lack `.bin` and a scratch tree has no
  `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes and
  logs under `~/.cache/sfr-r6/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
