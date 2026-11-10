# Role: fixer (round 3, after the move onto main: where this job meets the merged jobs): site-native-structure

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). The job (the website importer's `--elementor` paste
becomes Bricks' Section / Container / Block, Heading, Button, Divider and linked Image; a part's root that draws
nothing is left out, "lifted") was review-clean on an old main and has just been rebased onto `main`
`7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4: site-faq, site-reviews, site-slider and
staging-fit-renderer merged). The rebase finisher stopped at its first gate with three things that need a fixer. Fix
them test-first, run the gates it could not run, then stop at `ready-for-review`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, don't rebase, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging** or
any live site (`site:live` runs only against a local stand-in server); no logins; never write to any WordPress site.
Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`, `references/live-site-reading.md` ("Holding a Chrome to read-only") and
`references/rendering-validation.md`, the repo `CLAUDE.md` in the main folder (Status lines of the four merged jobs;
the standing rule "`npm run site:live` only reads a published page"; "Build general logic") and HANDOFF's
staging-fit-renderer and site-slider sections.

## Your copy (you start in your own worktree)
`git checkout -B site-native-structure-fix3 40b980ea6d8a5181a25dba9f0695f015936dab13` (branch
`site-native-structure-stack5`, on `main` `7eeca437`), confirm `git rev-parse HEAD` and a clean status. Report your
branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live; AC6 and AC10 amended).
- The rebase record: `evidence/site-native-structure/stack-5/` (`conflicts.md`, `resolutions/`, `regenerated.md`,
  `meet/`, `logs/slider-golden.log`, `logs/code-page-elementor.log`, `range-diff.txt`) and the ledger's "stack 5"
  section.
- AC14's stand-in capture: `evidence/site-native-structure/inputs/standin-capture-0581852c.json` (sha256 starts
  `b01b4e08`). On the reviewed head (`0581852c`): 15 of 17 Buttons and 4 of 5 linked pictures stand alone; within the
  plan's tolerance at every width. On it all three parts (header, page, footer) lift.

## The three findings
**S5-1 (a merged job's test fails: the only failure in the unit suite):** `test/unit/site-slider-unchanged.test.ts`
"pastes without an Elementor slider are byte-identical" misses 28 sums: exactly the `-elementor` variants of pageCode,
elementorBand, elementorCode, elementorOpen-1, code-page, elementor-faq and elementor-stretch; every `-code` variant
still matches. Its goldens (`test/fixtures/site-slider-base/`) hold main's Elementor-step pastes, which this job
changes by design. The finisher's four-tree table (`stack-5/logs/slider-golden.log`): on the six other inputs head's
Elementor pastes are byte for byte the reviewed head's; on code-page the change old base → old head and main → head is
the same 318 changed lines.
- Check that table yourself first (re-run it; don't trust it). Then regenerate only those 28 `-elementor` entries
  through the test's own generator (`pastesOf`) on your head tree, from the saved input captures (never capturing
  again); the saved captures and every `-code` entry stay byte for byte. Record in the ledger which entries moved, and
  the proof that each moves only by this job's change (that is what makes regenerating from head honest here: the
  golden pins "site-slider changed nothing else", and the four trees show it).
- **Find every other pin of a merged job that this job moves**, not only the unit ones: site-faq's, site-reviews',
  site-slider's and staging-fit-renderer's "unchanged" sums, goldens and byte receipts in `test/web/`, `test/browser/`
  and behind env gates (`F2B_UNCHANGED_SUMS`, `F2B_REAL_CAPTURES`, `F2B_PANEL_CAPTURES`, named-only tests). Same rule
  for each: prove by the trees, then regenerate; a pin that moves for any other reason is a finding to fix or report.

**S5-2 (new logic; a crash):** `tools/site-live.ts` (around line 175) reads `byId.get(rootId)!.settings` for each
part's root; a lifted part has no root element in the paste, so `site:live --elementor` throws a TypeError on any page
whose part lifts (B-Dry's stand-in: all three). Test first, on the tool's own stand-in pattern (a locally served
Bricks-printed page; find how staging-fit-renderer's tests build one): a paste with a lifted part and one with a kept
root, mapped and measured at every width, the drawing compared, exit codes and lines as for an unlifted part. Decide
how a lifted part's extent is read on a published page (its sections are siblings of other parts' content in Bricks'
`#brx-header` / `#brx-content` / `#brx-footer`, or of other pasted content on a whole-page paste) and say why that
holds for a whole-page paste on one page, which is how Justin pastes. **The read-only guard is untouched** (don't edit
`tools/lib/read-only.ts` or how Chrome is started and ended; if you must touch `site-live.ts` near them, re-run the
guard's tests and say so).

**S5-3 (new logic; reasoned from the code, verify it first in Chrome):** `site:check -- <capture> --whole` draws the
parts together; with lifted parts the finisher's resolution draws the page with this job's single-part `wrap` only
when the page holds one lifted part, so on a whole page with several lifted parts `PART` finds nothing and the check
fails. Test first (a whole-page fixture with two or three lifted parts and one with a mix of lifted and kept roots),
then make `--whole` and `--all` measure each lifted part by its own extent (one wrapper per part in the renderer's
page, or the part's own top-level elements: choose what also serves S5-2 and say why). `site:check`'s stdout and
`report.json` stay byte for byte as on main for pastes with no lifted part.

## Also
- Record, don't build (HANDOFF "Deferred" and `evidence/site-native-structure/follow-ups.md`): a slider widget that
  becomes a Bricks Slider (and a folded accordion) gets no Structure-panel label on its widget box, because only boxes
  the fold refuses call `kept(e)`; a decision for Justin.
- Check the finisher's hand port (`resolutions/03-b81088ee.extra.diff`: `MeasuredPart.lifted`, `measure` reading
  `p.lifted ? PART : locate(rootId)` in `tools/lib/site-measure.ts`) against every caller of the moved code.

## Work
1. Verify each finding yourself first. Each fix test-first (RED on `40b980ea`, GREEN on your fix), one commit each;
   mutate what you add (each new condition removed is killed by a named assertion, never a crash) under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
2. **The gates the finisher could not run** (on a `git archive` scratch copy of your head; put
   `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
   each log starts `HEAD=` and ends `EXIT=`):
   - both typechecks and `npm run check` (the parallel unit suite may need an 8G scope): 0 failures;
   - this job's AC tests (each test the approved plan names) and the four merged jobs' own test files (unit, web,
     browser), each web/browser file alone under the 4 GB cap, one Chrome job at a time, compared by name with `main`
     (five browser files fail on main on this desktop: composition-clipping, fonts, hero-pair, peer-sides,
     pill-holder; known flakes: the code-page fixture's 5.09 px load flake, `capture-windows` AC7, `capture-entrances`
     R8-1, `site-elementor-button` pixels-at-rest: rerun a flake alone before calling it a failure);
   - where the sides meet in Chrome, on fixtures with native structure on: a slider plays and `site:check` holds it on
     its first slide; a FAQ opens the site's answers and its open look follows; a live widget's Code element sits at
     its own place and `site:check` stands in for it; each within its own job's tolerance at every width;
   - `test/unit/plugin-convert.test.ts`; the five Figma replays byte-identical to `main`; `npm run corpus` the same as
     `main` (v1's Mac files are missing on this machine);
   - AC14's stand-in (8G scope): `npm run site -- <stand-in> … --elementor`, `site:check -- <stand-in> --all
     --elementor` and `--whole`, against the reviewed head's numbers above; say what moved and why (the merged jobs
     change this page's FAQ, reviews and slider by design; 992 and 767 are site-slider's named tier difference).
3. Records batched into your commits: HANDOFF's site-native-structure section (how `site:live` and `--whole` read a
   lifted part; known limits) and the ledger ("Fix pass 3": findings verified, the pins regenerated with their proof,
   the gates); append what you defer to `evidence/site-native-structure/follow-ups.md`. Placeholders
   `<site-native-structure id at merge>` / `<at merge>` stay.
4. Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff
   --cached --name-only` without CLAUDE.md. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/fixer-3/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-f3/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start (kill by its profile path if Node dies). Scripts written with Write under
`~/.cache/sns-f3/` (a restart empties `/tmp`); one `bash <file>` per Bash call; run long gates on a scratch copy, never
in the worktree while you edit it. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since
"-30 min" -o short-iso | grep sending`): say so, find what grew, rerun under the cap. Waits under 115 s. The PC loses
power now and then and agents can be stopped by a usage limit: write each log's `EXIT=` line; when resumed, read your
finished logs first and never start a second driver on a suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); per finding: verified?, the rule, the fix, tests, RED/GREEN
paths, mutation table; every pin regenerated and its proof; the finisher's hand port checked; each gate against main;
AC14's stand-in numbers; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
