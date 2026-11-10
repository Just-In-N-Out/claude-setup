# Role: planner (a bug): footer-icon-list — the checks draw B-Dry's footer icon list 69 px off since Build 2026-11-10.4

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Plan only: find the root cause with evidence and
write the plan. Change no source or test in any worktree or the main folder, commit nothing, start no agents. Never
load bdryswi.com (it has a bot check; never without Justin). No logins; never write to any WordPress site. Nothing
paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md`, `references/rendering-validation.md`),
`engineering-best-practices`, `implementation-planning`, `systematic-debugging` (prove the root cause before proposing
any fix). Read the repo `CLAUDE.md` in full ("Build general logic": the fix is a general rule, never keyed on B-Dry;
"Prove it on the plugin first"; the Bricks facts under "Working in this repo") and HANDOFF's sections for
staging-fit-renderer (Build 2026-11-10.4), elementor-footer-fit (2026-11-09.3, fold rule 9) and elementor-phone-fit
(fold rule 8).

## The report (from site-native-structure's fixer 3, on main)
- Since `main` `7eeca437` (Build 2026-11-10.4, staging-fit-renderer merged: "the test renderer prints a class's
  control CSS with the element's `brxe` class on the site route and Bricks 2.4.2's front-end CSS, as Bricks prints the
  page"), the named-only test `site-elementor-page-bdry` fails on main: with `--elementor`, B-Dry's footer icon list
  (Elementor widget `4d37935`) is drawn **69.07 px off at every width**. The previous renderer (main `2879e496`, and
  the old reviewed heads) drew it within 0.11 px. The footer paste itself is byte for byte the same on both.
- It happens with Bricks 2.4.2's CSS and with `--bricks 2.3.9`. Receipts:
  `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/fixer-3/ac14/footer-diag/` (`reviewed.log`,
  `main-239.log`, `main-242.log`, `head-239.log`, `out-*`), `fixer-3/web-main/`.
- It blocks AC14 of site-native-structure (B-Dry's whole page within tolerance at every width), and Justin's own live
  checks would read a false or a real 69 px.

## The question the plan must answer with evidence
**Which side is wrong?**
- (a) The new renderer is right: real Bricks prints this class CSS so that the pasted footer really is 69 px off on
  the published page (hidden before by a renderer that was too kind). Then the bug is in the conversion (how the fold
  or the class CSS carries this icon list's box: a margin, a padding, a gap or a list reset that Bricks' own
  `.brxe-<name>` rule, printed with the class, now beats or adds to), and the fix is a general conversion rule.
- (b) The new renderer is wrong for this shape: real Bricks draws it right and the renderer's new printing (selector
  shape, order, specificity, the 2.4.2 assets) differs from what Bricks prints. Then the fix is in
  `test/browser/render*.ts`, proven against what Bricks really prints.
- Or both in part. Don't guess: reproduce on main, shrink it to the smallest paste that shows it (the widget, its
  classes, its ancestors' rules), name the exact declaration(s) that move the 69 px and which printed rule wins in
  each renderer, then prove which printing real Bricks does.
- **Evidence for what real Bricks prints** (read-only): `reference/bricks/` (README "Paste rules", the
  `frontend-2.4.2/` and `frontend-2.3.9/` assets); Bricks' own GPL PHP source (how it prints a global class's
  settings: selector, order against element-id CSS and against `.brxe-*` defaults; `references/` memory note "Bricks
  source research": GPL Bricks PHP on GitHub); staging-fit's saved real page
  `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/staging/homev2-2.html` and its saved CSS (a real
  Bricks 2.4.2 print of an earlier paste of this very page: does it hold this icon list, and what does it print for
  it?). You may make a **read-only GET with curl** (no Chrome, no login, one request per file, `?f2b=<random>` to pass
  the cache) of Justin's public staging page `https://bdry.staging.growithgro.com/homev2/` and the CSS files it links,
  saved under your evidence folder, if the saved copy is too old to answer; never bdryswi.com, never a POST.
- Also say: which other shapes the same cause reaches (any site's icon list? any list? any widget with this
  declaration?), so the rule is general; whether Builds 2026-11-09.2 / .3's "within 2 px" claims for B-Dry's footer
  still hold under the right reading; whether Justin's pasted staging page is off by this today.

## The plan
- Write `~/.hermes/plans/figma-to-bricks/footer-icon-list.md` (the builder copies it to
  `docs/plans/2026-11-10-footer-icon-list.md` as its Task 0), a plan a fresh agent with no context can build from:
  the playback in plain words; the root cause with file:line evidence; **numbered acceptance criteria AC1, AC2…, each
  with one named test, each test name whole on one plan line** (a line that isn't an AC's definition never starts
  with a list marker, table pipe or heading followed by `AC<n>`); proposed ACs marked **(proposed)**; an AC only
  Justin can check tagged `(live)` right after its id; tasks test-first with RED on base; open questions at the top
  with a ⭐ recommended answer each; your recommendation **Mini or Full** (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`)
  with a reason.
- Base: `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097`. Jobs moving beside it (not merged; keep the fix small and
  in the functions you name): site-native-structure (`site-native-structure-fix3`, on main: `src/core/site/convert.ts`,
  `parts.ts`, `elementor-fold.ts`, `classes.ts`, `test/browser/render.ts` `wrapped`, `test/web/lib/site-check.ts`,
  `tools/site-check.ts`, `tools/lib/site-measure.ts`); site-menu (`kinds.ts`, `convert.ts`, `parts.ts`,
  `test/browser/render.ts`, `chrome.ts`); staging-fit-cancels (the code route's CSS: no `revert`).
- The ACs must include: the named B-Dry test green again for the right reason; a generic fixture (not B-Dry) that
  shows the shape, RED on main; every other paste and Figma design byte for byte as before where the fix is in the
  renderer, or exactly the pastes holding the shape where it is in the conversion; the merged jobs' checks
  (`site:check`, `--whole`, `site:live`'s drawing) unchanged for pastes without the shape.
- You may run tests and probes on `git archive` scratch copies of main (never in the main folder's tree beyond
  reading); scratch under `~/.cache/fil-p/`; evidence under
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/fil-p/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time, closed after (stop it by the
PIDs of its own profile path; never `pkill -f <pattern>`); a `git archive` scratch tree has neither `tsc` nor
`node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
`node_modules` in). B-Dry runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` (export variables
first, no `--setenv=PATH`). SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min"
-o short-iso | grep sending`). Waits under 115 s. The PC lost power twice this week: keep notes and results on disk;
when resumed, read them first.

## Report (as text)
The plan's path; the root cause in three plain sentences (which side is wrong, the declaration, the proof); the ACs one
line each; the questions with their ⭐ answers; Mini or Full and why; what it means for site-native-structure's AC14 and
for Justin's staging page today; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
