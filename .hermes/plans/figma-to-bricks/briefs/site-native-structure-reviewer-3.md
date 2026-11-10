# Role: reviewer (round 3: the rebase onto main and fix round 2; report only): site-native-structure

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a captured Elementor page pasted into Bricks 2.3.9 or 2.4.2 by `npm run site --elementor`,
looking like the site and reading as Sections, Buttons and so on in Bricks' Structure panel; the plain route and Figma
designs converting as before), each with a concrete real-use scenario. Edge cases are P3 (follow-ups). **This is the
last review round of this job** (the project caps review rounds at 3): what is not a real-use bug goes to P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live). A planner amends AC6's and AC10's wording after this round (review 2's R2-2: a Button or
  linked picture stands alone wherever fold rule 10 proves its place; elsewhere one labelled box stays, with a note):
  judge the code, and name any further plan line the head makes false as a P3.
- Branch `site-native-structure-fix2`, head `0581852c7fd95092ad6be1e2650cc3beb8c1808b`, now on local `main`
  `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4, staging-fit-capture: adds
  `src/core/site/styled-ranges.ts`; a capture holding a width range read without the site's styles is refused). In your
  own worktree: `git checkout --detach 0581852c7fd95092ad6be1e2650cc3beb8c1808b`, confirm HEAD and a clean status.
- Review 2 (`evidence/site-native-structure/review-2/review.json`: R2-1 P2; its probes in that folder) and the fixer's
  receipts (read, don't trust): `evidence/site-native-structure/fixer-2/` (`rebase/gates/`, `red/`, `gates/SUMMARY.txt`,
  `mutation/SUMMARY.txt`, `ac14-sense/`).

## Scope
1. **The rebase** of the reviewed head `db582920` (on `fd1986dc`) onto `3cfc54ac` (its tip is `6988ba59`):
   `git range-diff fd1986dc..db582920 3cfc54ac..6988ba59`. The fixer reports one conflicted commit, `docs/HANDOFF.md`
   in two places (both sides kept), no source conflict. Confirm no source, test or fixture line of the job changed
   (outside `docs/`, `git diff db582920 6988ba59` equals `git diff fd1986dc 3cfc54ac`), and rebuild the docs-only
   resolution as `review-loop.md` "After MOVE ON" says.
2. **Fix round 2** (`git diff 6988ba59..HEAD`):
   - R2-1 (`sharesAcross` in `src/core/site/elementor-place.ts`, wired into `foldable` and `merge` in
     `elementor-fold.ts`): where a folded body's own % width, min-width or max-width sits beside px side margins (0 or
     more) on the boxes around it and the widget box is stretched across its column or grid cell with no width of its
     own, the share is written as `calc(p% - p·M/100 px)`; a row's item or a centring column refuses (the box stays,
     the note names it); a margin that isn't a px length of 0 or more, or a share that isn't a plain %, refuses; a
     widget box with a width of its own keeps it; a linked picture's capped img needs nothing.
   - R2-3 (`mirrored`): on a right-to-left line a body placed at a side keeps its box; centred bodies and a row's items
     still stand alone.
   - R2-2's test half: AC14's test pins the B-Dry stand-in's counts (17 Buttons with 15 alone, 5 linked pictures with 4
     alone, the three boxed ones by id; ids only in that named test).
- Check hardest:
  - the `calc`: is `calc(p% - p·M/100 px)` right for every case it is written in (the percentage's containing block
    before and after the fold; margins on the widget box **and** on wrappers between it and the body; left and right
    different; margins that change per Elementor breakpoint, so per range; padding on the container; `box-sizing`;
    `min-width`/`max-width` beside a `width`; a grid cell against a flex column; a column with `gap`)? Probe in Chrome
    with Bricks' front-end CSS: your own fixture pages, the site's box against the paste's within 0.5 px at several
    widths;
  - what "stretched across its column with no width of its own" misses or wrongly includes (`align-self` set on the
    widget box, `width: auto` against `unset`/`initial` — the fixer notes the two checks disagree there —,
    `max-width` on the widget box, a wrapping row);
  - the refusals: is any common real shape now boxed that stood alone at review 2's head (the B-Dry stand-in keeps 15 of
    17 and 4 of 5; the saved page's three parts are byte-identical with and without the rule, the fixer says);
  - R2-3 not refusing left-to-right pages (a `dir` attribute on a wrapper, `direction` inherited);
  - AC14's pinned counts: an honest test that can fail (`ac14-sense/`), and not a rule keyed on B-Dry in the source;
  - the fixer's `found_else`: on main too, a block-level body sized by a % (a heading with `width: 50%`) folds out of a
    widget box with side margins and keeps its % — how real, and is it this job's to fix (rate by the importer rule);
  - AC11 (headings, pictures and text keep fold rule 2), every earlier fold rule's proofs, B-Dry within 2 px at every
    width, the plain route and Figma conversions byte for byte as main.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the wrapper-fold lines) and `references/rendering-validation.md`, the repo `CLAUDE.md`
and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-3/review.json`, then
self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
--base 3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`
(exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-r3/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin` and a scratch tree has
  no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes
  and logs under `~/.cache/sns-r3/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
