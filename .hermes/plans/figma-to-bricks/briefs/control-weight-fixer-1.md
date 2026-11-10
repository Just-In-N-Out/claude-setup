# Role: fixer (Mini round 1: review 1's R1-1, plus the test gaps of R1-2): control-weight

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 1's one P2 test-first, close the two test
gaps, record the rest, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase,
leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site (saved captures
and local fixtures only); no logins; never write to any WordPress site. Nothing paid.

**Mini pipeline:** if the fix needs a design decision beyond the plan's Q1, or more than a small change in the job's
own file, stop with `status: stopped`, `stop_reason: escalate to full`.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Code-route paste traps": the capture keeps only each element's winning value; a
class's controls print at `.cls.brxe-<el>`, 0,2,0), and the repo `CLAUDE.md` ("Build general logic"; "Architecture
rules": CSS stays typed).

## Your copy (you start in your own worktree)
`git checkout -B control-weight-fix1 a442672e0d4ad776f0269e2860eaf7af97fb0ed9` (the reviewed head, branch
`control-weight-build`, on staging-fit-cancels' head `ce5b38ac`), confirm `git rev-parse HEAD` and a clean status.
Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md`
  (AC1–AC6).
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/review-1/review.json`; its probe sites
  and outputs `~/.cache/cw-r1/` (`sites/cw-nested`, `cw-leak`, `cw-text`, `cw-words`; `out/nested/report.txt`,
  `head-payload.json`; its `bytes.ts`). The builder's receipts: `evidence/control-weight/builder/`.

## The finding
**R1-1 (P2, `src/core/site/inline-own.ts:72`):** a moved child that is a box takes the parent's nested readings
`i/rest` as `.child > :nth-child(k)` (0,2,0), which loses to the grandchild's own class controls (`.gc.brxe-div`,
0,2,0, printed after). Base wrote them as `.parent > :nth-child(i) > :nth-child(k)` (0,3,0), which won. The reviewer's
probe (`cw-nested`): a link that is `inline-flex` on desktop holds an icon span and a label span; at 768–991 the link
is `display: inline` and the label is 14px with `padding-left: 2px`; head draws the label at 768, 769, 880 and 991
with 18px and 12px (the site's desktop values); base had both right (and the link's line 28 px too tall, which this
job fixes). Real use: a site's "→ Book a visit" button that becomes a word of its line on small tablets with a
smaller label there.
- Fix as a rule, the same reasoning one level down: a reading the capture made of a grandchild through the parent's
  inline reading belongs on **that grandchild's own class** for those widths (one element, one class: nothing left
  to tie), where the paste can prove which grandchild is which by the same proof the job uses for the child (the
  capture's elements match the pasted children one for one; none lifted; shown there); where it can't, the nested
  keys stay in the parent's rule exactly as base wrote them (0,3,0) and only the child's own keys move. Decide how
  deep the rule goes (the capture's inline reading nests as far as the wrapper's content does: handle every depth by
  the same step, or stop at a stated depth and leave deeper keys with the parent), and say why. The reviewer's
  smaller alternative (move an `i/rest` key only when the child is a words element) is the fallback if the general
  step can't be proved.
- Test first (RED on `a442672e`): a fixture variant with an icon and a label inside the link (unit, hand-made capture:
  the label's own class carries its tablet values, the parent and the child write no nested rule for it; and the
  can't-prove case leaves the 0,3,0 rule as base) and the range-cancels fixture site gaining such a link, or a second
  fixture site beside it, drawn in Chrome with both Bricks samples at 767, 768, 769, 880, 991, 992 and at 1200, 600,
  390: the label's font size and padding and the link's display equal the site's, the page within 2 px. AC1's cited
  test keeps its name.

## The test gaps (R1-2; a few lines each)
Two parts of the rule have no test that fails without them (the reviewer's mutants "Mleak" — the link's own
declarations merged into the tablet widths instead of replaced — and "Mcount" — the `steps.size === kids.length` check
dropped — both passed): add a fixture case for an own reading that declares what the inline one doesn't (padding and
background declared only at 992-up and up to 767: nothing of them at 768–991), and one with an extra inline element
before the link that the paste doesn't hold (nothing moves). Each mutant must then die on a named assertion.

## Record, don't build (HANDOFF "Known limits" of this job's section and `evidence/control-weight/follow-ups.md`)
- R1-3: words beside the link (`Questions? <a class=btn>…`): nothing moves, and on base too the parent's `>
  :nth-child(2)` rule lands on the first link because the text's Rich Text counts as a child (probe `cw-words`: one
  link takes the other's background and margin at 768–991); head and base pastes are identical there. HANDOFF's
  limits name only spaces: add this.
- R1-4's notes for the later stack step: a fixture with a lifted child once site-native-structure's `lift` is on main
  (assert nothing moves); a tablet-only child never shown elsewhere can pass the count check (`[dsk, btn]` against
  inline `[tab, btn]` moves `tab`'s reading onto `dsk`; base misapplied it too); footer-icon-list's `statesOf` and the
  other jobs' edits beside `prepare`'s class loop must read `owners.decls` for a moved element, not `t.node.decls`.
- The line the builder reworded in staging-fit-cancels' Known limits ("fixed"): make it say exactly what is fixed
  after your change.

## Work
1. Verify R1-1 yourself first on the reviewer's probe.
2. Each fix test-first, one commit each; mutate what you add (each new condition removed in turn is killed by a named
   assertion, never a crash; rerun the builder's M1–M7 and the reviewer's two) under `systemd-run --user --scope -p
   MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`).
3. Gates: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, the job's unit and web tests (each web file
   alone under the cap), AC4's byte test (named only: 47 captures, 376 pastes byte for byte as base `ce5b38ac`; only
   captures holding the shape differ — say which now differ and why), AC5's golden untouched,
   `test/unit/plugin-convert.test.ts`, the reviewer's probes (`cw-nested`, `cw-leak`, `cw-text`, `cw-words`) re-run on
   your head with 0 differences where the rule applies. Every log starts `HEAD=` and ends with one line `EXIT=`.
   Commit after each passing step (plain `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By
   lines; `git diff --cached --name-only` without CLAUDE.md). Records in the ledger
   (`docs/plans/2026-11-10-control-weight-ledger.md`, "Fix pass 1") and HANDOFF. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/fixer-1/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-f1/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a worktree's
`node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in).
Scripts written with Write under `~/.cache/cw-f1/`; one `bash <file>` per Bash call. SIGTERM / 143 / 137 or "Killed"
may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC
lost power twice this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line (wait on
`^EXIT=`); when resumed, check `git status` and `git cat-file -t HEAD`, read your finished logs first and never start a
second driver on a suite.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); R1-1: verified?, the rule as built (how deep, and what
stays with the parent), tests, RED/GREEN paths; the two gaps' tests and their mutants; the mutation table; what was
recorded; gates; the reviewer's probes on your head; `found_else`; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
