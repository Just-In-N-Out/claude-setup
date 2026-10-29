# Brief: FIXER 5 for figma-to-bricks feature "after-faq-sections" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 1 P0-P2 finding(s) in review-5 at d74a834`. Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296, on its own branch
`worktree-agent-<your id>`). The job's head is `d74a834` on branch `worktree-agent-a8fa99f98acc26345` (never write or
run commands in another worktree). In **your own** worktree run `git merge --ff-only d74a834` and check
`git rev-parse HEAD`. Work and commit there, and leave the worktree in place when you finish. If CLAUDE.md or
node_modules is missing, copy them from the main folder (`cp /home/justin/Documents/FigmaToBricksV2/CLAUDE.md <your
worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`; never stage CLAUDE.md). If
any of this is refused, stop with the exact message.

## Justin's decision in force: "Careful rules" (`review-4/justin.json`)
Split a footer frame only where it's unambiguous which parts are the page's; everything uncertain converts exactly as
base `dea6296` (the whole frame left out, base's note and height).

**Turn the rule into an allow-list.** Review 5 showed fixer 4's rule decides "the page's" by what a part lacks ("no
links, not a drawn-logo row") plus "holds a Button or a box", and the footer's own brand block (a logo, a line about
the firm, a "Contact us" pill, in a row or a centred column, logo drawn or typed, stacked or not, any size), contact or
info cards, painted icon circles and client-logo tiles all pass it. So: a part counts as the page's only when it
matches a shape from an explicit list taken from the plan's AC1 positives and the B-Dry stack (for example a
call-to-action band: a heading at least 1.6× the body plus a Button; a heading part followed by unlinked cards or
steps; a section heading alone right above such cards), and nothing in it is a logo, a row of icons, contact details
or the site's links. Anything else, anywhere in the stack, makes the whole frame convert as base. Write the list as one
short rule in HANDOFF (replacing R13's wording), and keep AC1's listed positives and round 2's changed outcome
(the wordmark/spacer frames splitting with the band kept) as they are now.

## The referee's lines (verbatim)
```
R5-1  P1  src/core/understand/footer-part.ts:39  The careful rule's page test reads the footer's own blocks that hold no links as page parts. pagePart() refuses only what reads as links (footerLinks), a row whose first layer is a drawn logo under 120px each way (site-header.ts logoFirst, photo() threshold) and non-Button links; the part right above the footer's own part then passes when it holds any Button or any painted or outlined box (actionOrCard, line 32). So a footer's brand block drawn as a centred column (logo, a line about the firm, a 'Contact us' pill), with a typed logo, with the logo stacked over its line in a column beside the pill, or with a square badge logo of 120px (119px goes base, 120px splits), contact or info cards (address, hours, service area; two-line town cards), a 'Follow us' row of painted icon circles with image glyphs (vector glyphs are merged by normalise and go base), and 'Trusted by' over client logos on tiles all split. With no page part at all (a brand column over link columns or a centred menu and a (c) bar; contact cards over a centred menu; both ticks too) the frame splits and the footer's own content stays on the page: AC3's 'footers that don't stack page parts above their links convert as before' and HANDOFF R13's 'anything else leaves whole, as before' are false again; with a call-to-action band above, the block is kept beside the band where the rule says uncertain converts as base. Round 4's head split every one of these the same way (head = 6a3a2f4 byte for byte), so fix 4 left them open. Evidence: review-5/probe-witnesses.log (no page part: U1b, U1c, U1e, U2b, U4b, U6b, U9; with a band: U1, U1d free-drawn, U2, U3, U4, U5, U6, U8) and probe-witnesses-2.log (V5, V6, V8; controls V1 vector icons, V4 painted label, V7 119px logo, U10/U11 the fixer's drawn-logo row: base). Fix direction: decide 'the page's' from what a footer never holds rather than from a Button or a box: e.g. a part holding any logo (drawn or a typed wordmark, first in its row or its column, any size) or a row of icons is the footer's, and the part right above the footer's own part must be one the plan's positives share (a call-to-action band with a heading 1.6x the body and a Button, or cards under a heading part), else as before; probe each witness above in auto layout and free-drawn  (repeats R4-1)
R5-2  P3  src/core/understand/footer-part.ts:28  Two guard terms have no witness in the three footer unit files: mutant W1 (wordless() ignores Buttons) and W5 (the one-layer tail's note named by its first part, a wordless rule or wave above the links, instead of the links part) both survive (review-5/mutants.txt); with W1 a 'Back to top' pill between the columns and the bar (witness V2, base today) would split. W3 (logoFirst without the sort by x) survives as an equivalent in auto layout. Every other new term was killed by its intended test (fixer 4's 33, re-read: footer-part.ts bytes c5f65e4e… are head's; W2, W4, W6, W7 killed here)
R5-3  P3  docs/HANDOFF.md:149  Two of R13's lines say more than the code does: 'A row of client logos counts as a brand row (the frame leaves whole)' holds only when a logo is the row's first layer (a 'Trusted by' line over logos on tiles splits, U8); 'Kept parts may hold a call to action's link, never another link' (line 110) misses phone and email links, which are made after footerPart reads the IR: a band whose words hold a phone number is kept with three tel: links in the paste (review-5/probe-tel.log; keeping it is the right outcome, the line is wrong)
R5-4  P3  ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md:346  Plan lines against their tests at d74a834: AC1's line and test agree (unchanged in this range; the 85 footer-stack variants and the CTA/columns/rule case are byte-identical to 6a3a2f4, review-5/stack-ids.log). AC3's line now matches its test exactly (the footerStackPage variants it lists and the seven columns frames: plain, rule, rule with a 64px bar, both ticks, wordmark 120 and 240, spacer 160); reviews 3-4's frames and the careful rule's moved to test/unit/understand-footer-careful.test.ts, which no AC line names (supporting tests). AC4's line must say the splitting variants are 67 (fixer-4/base-vs-head.txt), not '31 at 7a0bfe1', and name fixer 4's copy of base-vs-head.ts (`<E>/fixer-4/scripts/base-vs-head.ts`), not fixer 2's
REVIEW AGAIN: 1 P0-P2 finding(s) in review-5 at d74a834: fix them, then review the fix commits
```

## Also
- **R5-2 (P3):** kill mutants W1 (`wordless()` ignoring Buttons: a back-to-top pill between the columns and the bar,
  witness V2, must stay base) and W5 (the one-layer footer part's note named after a wordless rule or wave above the
  links), or show a guard is dead and remove it.
- **R5-3 (P3):** fix HANDOFF's R13 lines: client logos count as the footer's in any arrangement under the new list
  ("Trusted by" over logo tiles); kept parts may hold a call-to-action's link **and** the phone links the plugin makes
  after the rule decides (`tel:`).
- **The witness receipt:** before you run it, write the expected-positive witness ids to
  `fixer-5/expected-positives.txt` (AC1's positives and the cases your allow-list names); every witness that differs
  from base and isn't listed is UNEXPECTED. Include every witness from reviews 1–5 (review 5's U1–U11 and V1–V8 in
  `review-5/probe-witnesses*.log` and its scripts) and fixers 1–4's. Zero UNEXPECTED is the bar.
- In your report, list what the AC1, AC3 and AC4 tests now assert (review 5's R5-4: AC4's splitting-variant count and
  receipt path must be updated in the plan; the main session will have the plan amended after the next clean review).

## Where
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-5/` (with the two
  `justin.json`). Earlier fixers: `fixer-1/` … `fixer-4/` (fixer 4's `scripts/base-vs-head.ts`, its witnesses and
  mutants). Approved plan (read only, amended): `plan-approved.md` beside them. Ledger
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Build probe fixtures inside a function called after
  `resetIds()`; test linked icons with small `image()` layers (vector icons merge).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-5/`.

## Done means
R5-1 fixed as a class under the allow-list, test-first; R5-2's mutants killed; R5-3's wording fixed; the witness
receipt at zero UNEXPECTED; every guard you keep has a test that fails without it. `npm run check` green (in a scratch
tree, archive the whole commit; run tsc as `node node_modules/typescript/bin/tsc --noEmit -p .` and with
`-p tsconfig.sandbox.json`); the footer-stack browser tests green with `skipped 0`; the full browser suite by test name
against a **built** base (no new failures); the AC4 receipt re-run (five real files × four tick settings byte-identical;
only the splitting variants differ, and each does); the v4 paste tests green (bounded runs) with the paste files
unchanged. Don't edit source while a gate runs. Fold your records into your fix commits. If a plan AC line can't hold,
stop and say which: don't rewrite an AC. Stop with `status: ready-for-next-review`: no merge, no BUILD. Report your
worktree, branch and last commit.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its "Widening a recognizer
   carefully" line and the footer-split pitfall line) and `references/rules-summary.md`; `references/testing-pitfalls.md`
   before any receipt, mutation run or browser measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-fixer-5/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-fixer-5/`. `npm run corpus` measures nothing
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
`{name, status: ready-for-next-review|stopped, worktree, branch, last_commit, allow_list, findings[{id, verdict:
fixed|rejected|removed|partly, commit, test, evidence}], witness_receipt{expected_positives, base_identical, positives,
unexpected}, rulings[], ac_tests_now_assert{AC1, AC3, AC4}, ac_status[{ac, accepted, test, evidence}], paste_sha256,
shots[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
