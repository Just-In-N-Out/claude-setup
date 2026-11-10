# Role: fixer (round 2, narrow: review 2's R2-1, plus the named tests' gap): control-weight

Review 2 ended `ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1`. Justin answered in a question on 2026-11-10
(recorded in `evidence/control-weight/review-2/justin.json`): **"Fix it (Recommended)"**: restore the two lines, add a
test page for this shape, fold the nested cases into the named acceptance tests, then one short review of just that
fix. `review-check.sh` now says REVIEW AGAIN.

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix it test-first, then stop at `ready-for-review`.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, don't rebase, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any
live site (saved captures and local fixtures only); no logins; never write to any WordPress site; never run `npm run
site:upload` against anything. Nothing paid. Keep the round small: no new rule.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Code-route paste traps"), and the repo `CLAUDE.md` ("Build general logic";
"Architecture rules").

## Your copy (you start in your own worktree)
`git checkout -B control-weight-fix2 271e7815fe06935387bacd208ee8577ef0f0068e` (the reviewed head, branch
`control-weight-stack12`, on `main` `56a9379faf207c2bfa76211dff1365db7d74be37`), confirm `git rev-parse HEAD`, a clean
status and `git rev-parse main` (if main moved, say so; don't rebase). Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md`
  (AC1–AC6). An amended wording is written and waits for your head
  (`~/.hermes/plans/figma-to-bricks/control-weight-amended.md`: read its Amendments list; it says the nested rule is
  asserted only by supporting tests, which is the gap you close below).
- Review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/review-2/review.json`; its probes and
  outputs `~/.cache/control-weight-review2/` (`sites/cw2-overlap`, `cw2-shapes`, `cw2-ranges`, `cw2-match`;
  `probes/cw2-overlap.test.ts`; `out/cw2-overlap-head-report.txt`; `notes.md`). Review 1's probes: `~/.cache/cw-r1/`.

## The finding
**R2-1 (P2, `src/core/site/inline-own.ts:83` and `:92`):** when two moves overlap, the first one is lost. Fixer 1's
commit `b5967438` (in the rebased history: find it with `git log --oneline -- src/core/site/inline-own.ts`) replaced
`take(out.decls.get(x.path) ?? x.node.decls, …)` with `take(x.node.decls, …)`, and `words[rest]` with
`x.node.inline?.[rest]`, as checks that "can never change the outcome". They can: a link is a word of its wrapper's
line on tablets, and on phones it is a block that reads its own icon and label inline. The wrapper's nested step gives
the label its tablets reading; then the link's own step runs later in the loop and rebuilds the label's declarations
from the original readings, with only the phones reading; the wrapper has already dropped its key, so the tablets
reading is written nowhere. The reviewer's probe (`cw2-overlap`): the label at 18px with 12px left padding at 768,
769, 880 and 991 on both Bricks samples, where main draws 14px and 2px through its 0,3,0 rule (80 values worse than
main). Restoring the two lines in a scratch copy gave 0 differences. Real use: a site's hero button (an arrow and
"Book a visit") that is a word of its line on small tablets with a smaller label, and a full-width block on phones.
- Verify it yourself first, on the reviewer's probe and its unit probe.
- Test first (RED on `271e7815`): a hand-made capture variant (unit: the label's own class carries the tablets
  reading **and** the phones reading, the wrapper and the link write no nested rule for it) and a fixture site case
  (extend `inline-nested` or add one beside it), drawn in Chrome with both Bricks samples at 390, 479, 600, 767, 768,
  769, 880, 991, 992 and 1200: every element's display, font size, padding and colour equal the site's, the page
  within 2 px. Then restore the two reads (or an equivalent that reads the map's current entry: say which and why),
  with a comment that says why they are not dead.
- **The other check fixer 1 removed** (the "not shown" check on the elements in between: the reviewer agrees it was
  dead): leave it removed; say in the ledger why it is dead in one sentence.
- Think of the neighbours of this shape and add a case where it is cheap: three levels where two levels read the same
  grandchild; a child moved at one range by the wrapper and at another by its own parent, where the two ranges
  touch (768–991 and 767 down) and where they overlap.

## The named tests' gap (the amendment planner's finding; Justin's answer covers it)
The nested rule is asserted only by supporting tests. Extend the cited tests themselves, **under their unchanged
names** (the plan cites them: byte for byte): AC2's cited test in `test/unit/site-inline-own.test.ts` ("an element its
parent reads inline at some widths carries those widths in its own class, and the parent writes no rule for it") gains
the `nested` and `deeper` variants and your overlap variant; AC3's cited test ("where the paste's children can't be
proved the capture's inline elements, or the parent is hidden there, the parent's rule stays as before") gains
`nested-hidden`. Keep the supporting tests too if they assert more. For each added clause one mutant on your head,
killed by the cited test's own assertion message.

## Small, in the same commits where they fit
- The stale header comment of `test/web/site-range-cancels.test.ts` (lines 6–7: "the browser's link blue, no
  background"): say what main drew before staging-fit-cancels since the renderer prints class controls as Bricks does
  (background and colour held; corner radius 0 against 6 px and an underline), as HANDOFF now says.
- The header comment of `test/web/lib/site-page-check.ts` says `checkPage` draws as Bricks 2.3.9; it draws with
  `NEWEST_BRICKS` (2.4.2): correct the comment only.
- Record, don't build (HANDOFF "Known limits" of this job's section and `evidence/control-weight/follow-ups.md`):
  R2-2 — a link holding two labels where the first is hidden on tablets, where the link is a word of its line: the
  hidden label pastes visible at 768–991 and the unproved 0,3,0 rule lands on it (the capture's `shown` can't tell
  "read inline" from "hidden" for an element inside an inline parent); main draws it the same.
- HANDOFF's lines "and so does each element inside it" and "at every depth" must be true after your fix: re-read them.

## Work
1. Each fix test-first, one commit each; mutate what you add or restore (each of the two restored reads removed in
   turn is killed by a named assertion; rerun the builder's M1–M7, fixer 1's N1–N9 and the reviewers' mutants) under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`).
2. Gates: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, the job's unit and web tests (each web file
   alone under the cap), AC4's byte test by name against base `main` `56a9379f` (only captures holding the shape
   differ: say which now differ), AC5's golden untouched, `test/unit/plugin-convert.test.ts`, review 1's and review
   2's probes re-run on your head (`cw-nested`, `cw-leak`, `cw-text`, `cw2-overlap`, `cw2-ranges`, `cw2-match`: 0
   differences where the rule applies; `cw-words` and `cw2-shapes` as main). Every log starts `HEAD=` and ends with
   one line `EXIT=`. Commit after each passing step (plain `git commit -m`, or `-F <file>`; no author override, no AI
   or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md). Records in the ledger
   (`docs/plans/2026-11-10-control-weight-ledger.md`, "Fix pass 2": for the planner, which AC sentences may now claim
   the nested rule because their cited tests assert it) and HANDOFF. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/fixer-2/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-f2/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a worktree's
`node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar; never
chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Scripts written with Write under
`~/.cache/control-weight-fixer2/`; one `bash <file>` per Bash call. SIGTERM / 143 / 137 or "Killed" may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC lost power twice
this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line (wait on `^EXIT=`); when
resumed, check `git status` and `git cat-file -t HEAD`, read your finished logs first and never start a second driver
on a suite.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); R2-1: verified?, the fix, tests, RED/GREEN paths; the
neighbours you covered; the cited tests' new clauses and their mutants; the mutation table; the small steps; gates;
both reviews' probes on your head; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
