# Fixer brief: web-compare, fix pass 5 (after review round 6 of amendment 1)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`, the 2026-10-30 evening entry: "go with the
recommended"): never stop to ask; decide, and record rulings (not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool (the property test and the corpus are the guard every later job is
judged by); read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md` and `references/rendering-validation.md`.

## Start

Your agent worktree starts at `main`, not on the story. Put your copy on the reviewed head without rebasing:
`git checkout --detach 6aaf9859b40ee7d6a5d7f2248e1859fbcced8a7a` then `git switch -c web-compare-fix-5` (the
amendment's branch is `web-compare-matching`). Your commits go on top of `6aaf985`; the story's base stays `3ea33bb`.
Approved plan: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` ("Amendment 1: matching":
design, Q9–Q11, R23–R29, AC12–AC18); the builder's rulings R30–R32 and evidence in
`evidence/web-compare/amendment-1/builder/`; ledger `.superpowers/sdd/2026-10-29-web-compare/progress.md`.

## What to fix

Round 6 (`evidence/web-compare/review-6/review.json`, `self-check.txt`; the reviewer's hold-out probes in
`review-6/probes/probe-r6.ts`, scripts in `review-6/scripts/`, logs `try-a1.log`, `probes-a2-a11.log`,
`probes-a12-a14.log`, `probes-a15.log`, `probes-a4f.log`, `prop-count.log`) found the design sound and its
implementation leaking in four places, each a regression against `c69ef18` on a probe outside the corpus. The
recommended route (`review-6/justin.json`): **fix them inside amendment 1's design, as general rules**:

- **R6-1 (P2) `test/web/lib/measure-content.ts:271`:** gluing ends a word at any whitespace-only text node, but flex
  and grid containers never draw it (Elementor's counter: formatted `98` `%` vs minified `98%` → a false "words on one
  side only"; a real 40px move then reads only as different words). Rule: a whitespace node splits a word only where it
  is drawn (a Range client rect). `test/web/corpus/judge.ts:40-43` copies the same rule: fix the truth too, so AC12 can
  see the class.
- **R6-2 (P2) `test/web/lib/align.ts:149`:** an unpainted band's reference top is its own first matched word, and the
  reader makes each stacked child of an unpainted section its own band, so the reference word is never place-checked:
  a section heading's taller line-height drifts everything below 16–48px with exit 0 (A12, A12.3), and a 20px label
  move is blamed on its neighbour with the opposite sign (A13, A3, A3.w). Rule: no word is exempt from the place check
  because it sets a reference; a move is named on the element that moved.
- **R6-3 (P2) `test/web/lib/word-rows.ts:191`:** R31 drops every later token's place in a box after any one-sided token,
  pictures and icons included, so a line led by a different icon (A4) or an icon-font glyph vs an inline SVG (A4.f, an
  accepted R8 difference) never has its place checked. Rule: a one-sided token never silences the place check of the
  others; only the shift it explains (its own width, the words it adds or removes) is absorbed. Revisit R31's limit
  ("a second move after a word change is folded in") under the same rule.
- **R6-4 (P2) `test/web/lib/word-findings.ts:68`:** R25 reads arrangement from children's word extents, so side-by-side
  columns overlapping vertically by less than half read as a stack (A15, A15.r: a false "stack of 2 → row of 2" and
  the label's real 20px move dropped). Rule: side-by-side columns stay a row on both pages whatever their words'
  vertical overlap; read arrangement so it can't swallow a move.
- **AC14's property test** doesn't model the reader's bands (one band per section vs the reader's one per stacked
  child): with the reader's bands 17 of its 110 downward moves give no finding and 10 name another element. Make the
  generator build the structures the reader really builds (or feed it the reader's own bands), so the property pins
  "same look ⇒ no finding" and "a real move ⇒ a finding on the moved element" as claimed; any class it still excludes
  by design gets its own Chrome probe.
- **Add review 6's hold-out probes** (A1/A1.m, A3/A3.w, A4/A4.f, A12/A12.3, A13, A15/A15.r and the same-look controls
  A6, A7, A9, A10) to the corpus with wants derived from the four-edge word truth, never from the tool's output.
- **P3s, fold in where the same rules cover them, else follow-ups:** R6-5 (`measure-layout.ts:78`: a painted band
  first in a flattened wrapper takes the wrapper's top; same-look A2/A2.f gives 3 findings per width on all trees) and
  R6-6 (HANDOFF claims "a real change always moves some word", checked by the property test: make it true or correct).

**Verify each first** on the head with the reviewer's probes, then fix test-first (RED on `6aaf985`), both directions
(same look: no finding; each real move: a finding on the moved element with the right sign), judging every finding
against the four-edge word truth. Keep AC1–AC18 holding and the review-5 misses caught (AC12 5/5). Kill the mutants
of each new rule.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase. `src/` stays untouched. In this worktree-isolated session write multi-step
  scripts with the Write tool and run `bash <file>`; run git add, diff and commit as separate plain calls.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site. The Hostinger site can stop answering for
  about a minute after several back-to-back 16-width compares: keep such runs, check with one curl, re-run into a new
  folder.
- Re-run the gates after the fixes and compare by test name with `c69ef18`, `6aaf985` and base `3ea33bb` (receipts in
  `amendment-1/builder/gates/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`), the
  browser suite, AC16's live self-compare of the plugin-made home and AC17's cost pair. **This machine (WSL):**
  `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; keep `TMPDIR`
  short (`~/.cache/wc-fix5/tmp`: Chrome won't start with it inside the session scratchpad); long gates as a script
  with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`.
- General logic only.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-5/answers.md`: for R6-1 to R6-6 and the property test,
  **fixed** (test name, RED log, commit), **follow-up** (why) or **rejected** (the evidence). Logs, probes, mutants
  and receipts beside it; copy scratch scripts into `fixer-5/scripts/` as soon as you write them.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
