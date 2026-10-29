# Brief: FIXER 4 for figma-to-bricks feature "after-faq-sections" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 3 P0-P2 finding(s) in review-4 at 6a3a2f4`, after its
brake asked Justin and he chose **"Careful rules"**: make the plugin's footer-split rule conservative. Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296, on its own branch
`worktree-agent-<your id>`). The job's head is `6a3a2f4` on branch `worktree-agent-a086b9929f80d4e5a` (never write or
run commands in another worktree). In **your own** worktree run `git merge --ff-only 6a3a2f4` and check
`git rev-parse HEAD`. Work and commit there, and leave the worktree in place when you finish. If CLAUDE.md or
node_modules is missing, copy them from the main folder (`cp /home/justin/Documents/FigmaToBricksV2/CLAUDE.md <your
worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`; never stage CLAUDE.md). If
any of this is refused, stop with the exact message.

## Justin's decision (2026-10-29, `review-4/justin.json`): "Careful rules (Recommended)"
Rounds 2, 3 and 4 each found neighbouring footer designs the split gets wrong: the fixes patched examples, not the
class. So fix the **class**, conservatively:
- **Split only where the footer's links part is unambiguous.** Decide "unambiguous" from the plan's AC1 positives and
  the reviewers' shapes, for example: the frame ends in the footer's own part (link columns or a menu row of short
  words) and a © bar, the whole-frame `siteFooter` answer agrees, and every part kept above holds no links of any kind
  and nothing that reads as a menu (no row of 3+ short items, no 3+ links, no linked cards or pills). Write it as one
  short rule in HANDOFF.
- **Everything uncertain converts exactly as base `dea6296` does** (the whole frame left out with base's note and
  height): titled columns, a typed-logo menu row, linked card rows, pill bands, links split across parts, anything
  where two branches of the rule could disagree. Port every witness from reviews 1–4 (`review-1/` … `review-4/` probes,
  `reviewer-1/`, `reviewer-2/`) as tests: each is either a clear split (positive) or equal to base (negative). Add your
  own class-level controls on both sides of every threshold you keep, and ask the same question the same way in every
  branch.
- Removing a branch that can't be made safe is allowed ("My ruling, not yet confirmed"), as long as AC1's listed
  positives, AC2's paint behind kept parts, AC4's byte-identity of the five real files and the v4 paste stay as they
  are. If an AC line can't hold under the careful rule, stop and say which: don't rewrite an AC.

## The referee's lines (verbatim)
```
R4-1  P1  src/core/understand/footer-stack.ts:216  Fix 3's step-up joins a links part to the footer's own part only when it holds no text 1.6x the body size (titled(), site-footer.ts:78). That test also matches the footer's own links: link columns under a big heading, and a menu row whose logo is typed in words of 26px or more (body 16). So a footer frame with no page part at all, drawn as titled link columns over a logo-and-menu row over a (c) bar, or as a typed-logo menu row over link columns and a (c) bar, is still split: the titled columns ('Let's build', 'Careers') or the menu row ('Shop', 'Example Co') stay on the page with 'Kept "Columns"' / 'Kept "Footer top"', and only the rest leaves, where base left the whole frame out. AC3's 'footers that don't stack page parts above their links convert as before' is false for them, and HANDOFF R12's 'never a split that keeps links' too. Same with a call-to-action band above, auto layout or drawn without it. Thresholds: titled 25px and typed logo 22px join (base outcome); titled 26px and logo 28px are kept. Evidence: review-4/probe-three-trees.log (shapes 'titled 32 / menu row / bar', 'free: titled 32 / menu row / bar', 'menu row (typed logo 28) / columns / bar', 'titled 25/26 / menu row / bar', 'CTA / menu row (typed logo 22) / columns / bar'); mutant V5 (a bar with its own links not bare) is killed only because 'titled, bar 3 links' then keeps the titled columns the same way (review-4/mutants.txt). Fix direction: let the step-up's heading test skip parts that hold columns of links, and not count a menu row's logo words as a section heading (or ask, at the split's end, whether any kept part holds columns or a menu the tail does not)  (repeats R3-1)
R4-2  P2  src/core/understand/footer-stack.ts:186  holds() is footerLinks(), i.e. hasMenu() for anything without two columns: three distinct links anywhere in the part, or a row of three short one-line words. The step-up (line 216) and nearest() (189-193) therefore take a page part right above the footer's own part for the footer's links: a row of three review or service cards each linking to its own page, or a trust strip ('Licensed', 'Insured', 'Local'), leaves with the footer, and the heading drawn as its own part above it stays on the page with nothing under it. B-Dry's own stack shape (band, steps, reviews heading, reviews, then the menu row and (c) bar) loses its reviews row this way when the review cards link. Round 3's head kept these parts; base left the whole frame. HANDOFF R12 says such a part makes the whole frame leave as before; instead the split goes on and drops just that part. Evidence: review-4/probe-three-trees.log: 'CTA / reviews title / reviews 3 linked / columns / bar' (head: left 'Reviews' 309px, paste has 'What customers say' but no 'Reviewer 1'; prev: left 'Columns' 196px, all kept; unlinked control: same as prev), 'CTA / steps / reviews title / reviews 3 linked / menu row / bar' (head: left 'Reviews' 245px, title kept), 'CTA / trust strip / columns / bar' (head: left 'Trust strip' 256px), and the same drawn without auto layout. No test has a linked card row or a word row above the links. Fix direction: count as the footer's links only columns of links or a menu row of short words that are not cards or a centred badge row (or require the part to join only when the tail would otherwise lose links), and probe linked card rows
R4-3  P2  src/core/understand/footer-stack.ts:189  Over a (c) bar found alone, nearest() takes the closest part holding links without the heading test the step-up applies, so a call-to-action band (a 36px heading) whose row of three pills reads as a menu is taken for the footer's links part and the whole frame leaves (band and the parts under it with it), while the same band with one pill stays and the bar alone leaves; directly over columns the three-pill band is kept (test '3 pills, columns'). The AC3 test pins 'CTA 3 pills, bar 3 links' at base's whole-frame outcome, so the rule contradicts itself by branch: R12 calls this a case where 'the parts can't say', but the band's heading says it, as the step-up's own rule reads it. Evidence: review-4/probe-three-trees.log: 'CTA 3 pills / steps / bar 3 links' (head = base: left 'Footer' 584px, no words; prev: band and steps kept, 'Bottom bar' 48px left), 'CTA 1 pill / steps / bar 3 links' (head keeps band and steps); mutant V1 (nearest skips headed parts) is killed by 'titled, bar 3 links', so the fix must still accept titled link columns (headed but holding columns). Fix direction: in nearest() skip a headed part unless it holds columns of links
R4-4  P3  test/unit/understand-footer-stack.test.ts:135  The amended plan's AC3 line no longer says what its test asserts: the AC3 test now also pins 15 no-page-part frames the line doesn't list (a menu row, titled columns, three legal links, an address or menu row before the bar, the links in two halves), 2 frames WITH a page part pinned at base's whole-frame outcome ('CTA, halves', 'CTA 3 pills, bar 3 links'; HANDOFF and the brief count these 17 as 'no-page-part'), a two-word menu (no footer found, band or not), and 16 frames that split (bandKept: the band kept, the footer's own part left out), which are AC1's kind of outcome, not 'as before'. AC1's line and test are unchanged in this range and still agree. A plan amendment is needed for AC3 (and AC4's variant count, '31 at 7a0bfe1') before the verifier
REVIEW AGAIN: 3 P0-P2 finding(s) in review-4 at 6a3a2f4: fix them, then review the fix commits
```

## Where
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-4/` (with
  `review-2/justin.json`, `review-4/justin.json`; review 4's probes `probe-three-trees.log` and scripts). Earlier fixers:
  `fixer-1/`, `fixer-2/`, `fixer-3/`. Approved plan (read only, amended): `plan-approved.md` beside them. Ledger
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Build probe fixtures inside a function called after
  `resetIds()`.
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-4/`.

## Done means
R4-1, R4-2, R4-3 fixed under the careful rule (or the branch removed where unsafe); review 4's surviving mutant V6
(`headed()`'s body size vs a fixed 16) killed or the guard simplified; the `bare` comment's wording fixed. Every guard
you keep has a test that fails without it. `npm run check` green; the footer-stack browser tests green with
`skipped 0`; the full browser suite by test name against a **built** base (no new failures); the AC4 receipt re-run
(five real files × four tick settings byte-identical; only the splitting variants differ, and each does); the v4 paste
tests green (bounded runs) with the paste files unchanged. Fold your records into your fix commits. In your report,
list what the AC1, AC3 and AC4 tests now assert (review 4's R4-4: the plan's AC3 line no longer matches its test; the
main session will have the plan amended after the next clean review). Stop with `status: ready-for-next-review`: no
merge, no BUILD. Report your worktree, branch and last commit.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
   `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
   measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-fixer-4/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-fixer-4/`. `npm run corpus` measures nothing
here; corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). The worktree guard
refuses Bash it can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then
node, `git -C`, the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path):
write scripts with Write and run them as one plain command. Never commit in the same batch of tool calls as the gate
it depends on. Waits: poll in chunks under 170 s. Another job (`header-bar`) is being fixed in its own worktree: leave
it alone.

## Rules
- Plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check `git diff --cached --name-only`
  (never CLAUDE.md). Don't push, don't bump BUILD, never bare `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else`; don't fix them. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (normally
  empty). Never edit skills or memory. Don't start other agents.

## Return (your final message)
`{name, status: ready-for-next-review|stopped, worktree, branch, last_commit, careful_rule, findings[{id, verdict:
fixed|rejected|removed|partly, commit, test, evidence}], rulings[], ac_tests_now_assert{AC1, AC3, AC4}, ac_status[{ac,
accepted, test, evidence}], paste_sha256, shots[], found_else[], skill_lessons[]}`. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
