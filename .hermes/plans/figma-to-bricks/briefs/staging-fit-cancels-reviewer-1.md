# Role: reviewer (Full round 1, the one review of this job; report only): staging-fit-cancels

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"; one review per job):** report
as P0–P2 only bugs a real site or normal use hits (`npm run capture -- <a real site>` then `npm run site`, with or
without `--elementor`, pasted into Bricks 2.3.9 or 2.4.2 and looking like the site at every width; `site:check`; Figma
designs converting as before), each with a concrete real-use scenario. Edge cases are P3 (follow-ups). A P0–P2 with no
concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/plan-approved.md`
  (AC1–AC3; Q1 A, Q2 A taken). Justin's report: on phones the hero buttons of his staging paste lose their background
  and turn into blue link text. Root cause: a website paste wrote each narrower width range as "what changed",
  cancelling a dropped declaration with `revert`, which also cancels the element's own lower-specificity rules.
- Branch `staging-fit-cancels-build`, head `b1329c43ec775fa1770e54e0fa2dde1d11b9f0d6`, base local `main`
  `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4). In your own worktree: `git checkout --detach
  b1329c43ec775fa1770e54e0fa2dde1d11b9f0d6`, confirm HEAD and a clean status. Review `git diff 3cfc54ac...HEAD`.
- What was built (the builder's words; read, don't trust — receipts in `evidence/staging-fit-cancels/builder/`:
  `ac1/`, `ac2/`, `ac3/bytes.log`, `ac-final/`, `mutants/`, `gates/compare.txt`, `bdry-head/`, `shots/`):
  - `src/core/site/blocks.ts`: a property no narrower range drops keeps main's desktop-first blocks byte for byte; a
    property some range drops goes in one block per run of ranges holding one value, bounded by the run's own min and
    max width (the widest run unbounded above, the narrowest below). New helpers `runsOf`, `boundsOf`, `mediaOf`.
  - `controls.ts`: a property is a Bricks control only when none of its blocks is bounded below; otherwise every block
    of it stays custom CSS.
  - `classes.ts` / `motion.ts`: class rules and the reduced-motion held frame print a block's bounds; an entrance's held
    frame leaves a property out where the element has no rest value, instead of `revert`.
  - A shorthand in one range with its longhands in another is covered by the same rule (its own test).
  - Deviations: Task 2 committed before Task 1; Q1 A as a hybrid (AC3 requires byte identity where nothing drops);
    AC3's golden `test/fixtures/site-no-revert-main.json` pins main `3cfc54ac`'s pastes of the hand-made captures, made
    by `tools/site-no-revert-golden.ts`.
  - The builder's `found_else`: **the Elementor accordion's open look still writes `revert`**
    (`src/core/site/elementor-accordion.ts` `openLook`; another job's file, left alone as briefed; the elementor-faq
    fixture's `--elementor` paste holds one, B-Dry's home none); `lookCss` bounds the narrowest run by the range's lower
    end; `tools/site-check.ts --drop-block` matches only `@media (max-width: …)` lines, not a bounded block.
  - The proofs drew with main's renderer (classes as bare `.cls`); live Bricks prints class controls as
    `.cls.brxe-<element>` (0,2,0) and custom CSS as written (another job, staging-fit-renderer, brings that to the
    renderer and is not on this base).
- Check hardest:
  - **the cascade the bounded blocks produce in live Bricks:** a property moved from a Bricks control to custom CSS (or
    split between them) now competes at a different weight and order — `.cls.brxe-<el>` controls (0,2,0) against the
    class's custom CSS (as written), Bricks' own tier cascade 991 → 767 → 478, and `site-reset`. Find any element whose
    winner differs between the head's paste as live Bricks prints it and the site, at each tier and at Elementor's
    1366/1024 switch points (use the Bricks 2.4.2 front-end sample and selector order in `reference/bricks/` or the
    staging-fit planner's saved staging CSS under `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` to
    print it as Bricks does);
  - run boundaries: exact min and max from the capture's own ranges (`web.ranges[].min`), no gap or overlap of 1 px
    between adjacent runs (767/768, 1024/1025, fractional widths, a zoomed browser), the widest run really unbounded
    above and the narrowest below;
  - states and parts: hover, focus, `::before`/`::after`, the open look, `!important` values, a property dropped in a
    middle range only, a value that returns in a narrower range, custom properties (`--x`) and `var()` users,
    shorthands against longhands in different ranges, `display: none` at a tier with the control cascade;
  - AC2's test really covers what it says ("no website paste … contains `revert` outside `site-reset`", both routes,
    both picture modes, both text modes) and can fail; AC3's golden can't be regenerated to hide a change;
  - is the accordion's remaining `revert` a real-use bug of this job's promise (the phone-button class of bug on an
    Elementor FAQ page), and where should its fix go (say plainly; rate by the importer rule);
  - B-Dry (saved stand-ins): the phone buttons keep their background and colour at 390 and 600 on both routes; the
    whole page still within 2 px at every width; only the classes the builder names changed;
  - Figma conversions and pastes of captures where no range drops a declaration byte for byte as base.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Code-route paste traps") and `references/rendering-validation.md`, the repo
`CLAUDE.md` ("CSS stays typed": never regex or string-match CSS; a value that has a Bricks control goes in that
control's key) and `reference/bricks/README.md` ("Class selectors"); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole story for real bugs (probes on base and head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfx-r1/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of
  your own at a time, closed after. A worktree's `node_modules` may lack `.bin` and a scratch tree has no `tsc` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Run multi-step commands from a script file
  written with Write; keep probes and logs under `~/.cache/sfx-r1/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
