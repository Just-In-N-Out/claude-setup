# Role: planner (a bug): control-weight — a Bricks class control outweighs a copied rule that wins on the site

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Plan only: find the root cause with evidence and
write the plan. Change no source or test in any worktree or the main folder, commit nothing, start no agents. Never
load bdryswi.com (it has a bot check; never without Justin). No logins; never write to any WordPress site. Nothing
paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md` — "Code-route paste traps": Bricks prints a class's
control CSS as `.cls.brxe-<element>` (0,2,0) while custom CSS stays as written (0,1,0) —, and
`references/rendering-validation.md`), `engineering-best-practices`, `implementation-planning`, `systematic-debugging`
(prove the root cause before proposing any fix). Read the repo `CLAUDE.md` in full ("Build general logic": a general
rule for every converted site, never keyed on B-Dry; "Architecture rules": CSS stays typed; a value that has a Bricks
control goes in that control's key, the rest in custom CSS; Justin's decision "Output style: editable structure first
… Bricks settings instead of custom CSS … Custom CSS only where Bricks has no setting", and his importer memory:
native structure, not "div div div") and HANDOFF's sections for staging-fit-renderer (Build 2026-11-10.4) and
staging-fit (the phone-button bug of 2026-11-09).

## The report (from staging-fit-cancels' move onto main, on main and on its head alike)
- On the code route (`npm run site`), a generic fixture's link is an inline word at 768–991 (the site's wrapper rule
  `.wrapper > :nth-child(1) { display: inline }` at that range) and its own painted button at other widths. In the
  paste, inside 768–991 the link is drawn `inline-block` where the site's is `inline`, and its line is **28 px taller
  at 768, 880 and 991**.
- The reported cause: the link's own class control prints as `.cls.brxe-div { display: inline-block }` (0,2,0, printed
  after), which beats the wrapper's copied rule `.wrapper > :nth-child(1)` (0,2,0) by order. On the site the link's
  own class rule is 0,1,0 and loses to the wrapper's 0,2,0. Turning a declaration into a Bricks control raises its
  weight above what the site wrote, so a copied rule of another element that wins on the site can lose in Bricks.
- Receipts: `~/.hermes/plans/figma-to-bricks/evidence/staging-fit-cancels/stack-7/logs/repro-850.log` (the smallest
  repro), `probe-ac1.log`, `ac1-main-red.log`; the fixture and the `todo` test that asserts the limit are on branch
  `staging-fit-cancels-stack7` (`ce5b38ac`: `test/web/site-range-cancels.test.ts`, read with `git show`).
- The fixer's words: "On B-Dry this is the hero buttons' own case at 768–1024, so it is worth its own job before the
  3do re-paste is judged at tablet widths." Prove or refute that on B-Dry's saved stand-in capture
  (`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`): which
  elements, which widths, how many px.
- The same family, already planned as its own job (don't re-plan it; do read it so the two rules fit together):
  footer-icon-list (`~/.hermes/plans/figma-to-bricks/footer-icon-list.md`: a box side written by a physical and a
  logical name; the physical one, as a control at 0,2,0, beat the logical one in custom CSS).

## The question the plan must answer with evidence
1. **How wide is the class of bug?** For every property the code route turns into a control: where a copied rule of
   higher weight than the element's own class rule (a parent's structural selector, an id, a compound or state
   selector, `!important`, a later rule of equal weight) sets the same property on the same element at some range or
   state, does the control at 0,2,0 now win where the site's own rule lost? Measure it: on the fixtures and on five
   saved real captures (B-Dry's stand-in, the 2026-11-04 captures under `~/.hermes/plans/figma-to-bricks/evidence/`,
   letsgro, darksalmon), count elements and properties where the paste's computed value differs from the capture's at
   a captured width for this reason, plain and `--elementor`; say what a person sees (px, colours).
2. **What does real Bricks print?** Confirm the control's selector and order against the copied rules in `_cssCustom`
   and in other classes' custom CSS (`reference/bricks/`, Bricks' GPL PHP source, staging-fit's saved real page
   `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/staging/`; a read-only curl GET of the public staging
   page and its CSS is allowed, no Chrome, no login, never a POST; never bdryswi.com). Does the element-id CSS
   (`#brxe-<id>`) or the tier controls change the picture?
3. **The fix, as a general rule, weighed against Justin's "editable structure first".** Candidates to judge with
   evidence, not to pick by taste: keep a property out of an element's controls (leave it in custom CSS at the site's
   own weight) exactly where the capture shows another rule beating the element's own class rule for it at some range
   or state (the capture reads the browser's matched rules per element: what does it keep of the winning selector and
   its weight? `src/web/read/code.ts`, `src/core/site/classes.ts`, `controls.ts`, `blocks.ts`); or weigh the copied
   rule up; or print the contested range as a bounded run on the element itself. For each: bytes changed in pastes
   that don't hold the shape (must be none), what Justin sees in Bricks' panel for that element (a control he can
   edit, or custom CSS), and what breaks when he edits it.
4. **Does it need a decision from Justin?** If the honest fix trades editable controls for exactness on contested
   properties, put that as an open question at the top with a ⭐ recommended answer and a one-line plain-words
   trade-off (his standing rule: ask before a design decision with trade-offs; under the repo's auto-go the builder
   takes the ⭐ answer unless he says otherwise).

## The plan
- Write `~/.hermes/plans/figma-to-bricks/control-weight.md` (the builder copies it to
  `docs/plans/2026-11-10-control-weight.md` as its Task 0), a plan a fresh agent with no context can build from: the
  playback in plain words; the root cause with file:line evidence; **numbered acceptance criteria AC1, AC2…, each with
  one named test, each test name whole on one plan line** (a line that isn't an AC's definition never starts with a
  list marker, table pipe or heading followed by `AC<n>`); proposed ACs marked **(proposed)**; an AC only Justin can
  check tagged `(live)` right after its id; tasks test-first with RED on base (prove each planned RED by applying only
  the test to a clean export of the base); open questions at the top with a ⭐ answer each; your recommendation **Mini
  or Full** (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`) with a reason.
- Base: `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097` (check `git rev-parse main`; footer-icon-list may merge
  while you work: it adds `src/core/site/sides.ts` and two lines in `statesOf`, `src/core/site/blocks.ts`). Jobs moving
  beside it, not merged (keep the fix small and in the functions you name; say where it would conflict):
  staging-fit-cancels (`staging-fit-cancels-stack7`: `src/core/site/blocks.ts` — the bounded runs: `runsOf`,
  `boundsOf`, `mediaOf` —, `classes.ts`, `controls.ts`; this job's fixture and `todo` test live there: say whether
  this job should be built on top of that branch, and plan for the order you recommend); site-native-structure
  (`convert.ts`, `parts.ts`, `elementor-fold.ts`, `classes.ts` `ClassCss.parts`); site-menu (`kinds.ts`, `convert.ts`,
  `parts.ts`).
- The ACs must include: the generic fixture's link `inline` inside 768–991 and the painted button outside it, within
  2 px at every width, with both Bricks samples; B-Dry's named case if you proved it; every paste that doesn't hold
  the shape and every Figma design byte for byte as before; the merged jobs' checks unchanged for pastes without the
  shape.
- You may run tests and probes on `git archive` scratch copies (never in the main folder's tree beyond reading);
  scratch under `~/.cache/cw-p/`; evidence under
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-p/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time, closed after (stop it by the
PIDs of its own profile path; never `pkill -f <pattern>`); a `git archive` scratch tree has neither `tsc` nor
`node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
`node_modules` in). B-Dry runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` (export variables
first, no `--setenv=PATH`). SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min"
-o short-iso | grep sending`). Avoid regexes with nested `[^}]*` over the 800 KB saved HTML files (they backtrack for
minutes). Waits under 115 s. The PC lost power twice this week and agents can be stopped by a usage limit: keep notes
and results on disk; when resumed, read them first.

## Report (as text)
The plan's path; the root cause in three plain sentences; how wide it is (counts on the captures; B-Dry's case proved
or refuted); the ACs one line each; the questions with their ⭐ answers, and whether one is a design decision for
Justin; Mini or Full and why; the build order against staging-fit-cancels and footer-icon-list; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line
check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
