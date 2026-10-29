# Brief: FIXER 5 for figma-to-bricks feature "header-bar" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 1 P0-P2 finding(s) in review-5 at e195c65`. Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Justin's decisions in force
- **"Careful rules"** (`review-3/justin.json`): the new header rules apply only where a bar is clearly a header;
  everything uncertain converts exactly as base `dea6296` (payload and notes).
- **"Keep AC1 as written"** (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`): a logo (or a
  picture wider than an icon) followed by a group of two short notes with no link of its own stays the site's header;
  anything beyond that exact shape converts as base.

## The referee's lines (verbatim)
```
R5-1  P2  src/core/understand/site-header.ts:157  The narrowed clear test still makes a badge strip 'the header's own bar' when the real, clear header is drawn right under it, so R4-1's own scenario is closed only for a strip without a button. Two paths: (a) menuBelow (clear-header.ts:76-79) reads any bar of 4+ links under the strip as 'its menu drawn as a bar of links', including the real header [logo, linked menu of 4, CTA]; a strip [BBB badge, 3 selling points, BOOK NOW] over it is clear: unticked or footer-only the BBB badge links home, both Containers drop their 1440 cap, the real logo is not linked (review-5/classify5.txt R5-A1; drawn 1280 wide R5-D2; a strip of 3 linked social icons and a button over it, R5-A3/A3b: both Containers uncapped). (b) showsMenu takes a strip [badge, 4 points, BOOK NOW] over an unlinked real header (base keeps that header in the page) as a clear menu header: the badge links home (R5-B6b). Base linked nothing; all identical at round 4's head. Neither path asks whether a clear header bar sits under the bar it judges, a structural signal the lone-band known limit lacks. A candidate (review-5/mutation5b.txt R5M5c: a menu reading makes no clear header while a clear header bar sits in the run under it or right after it; call and icon bars as before) brings all five witnesses to base byte for byte with the 57 focused tests green; the broader R5M5 (any clear bar under it) breaks the pinned '[mark, menu icon] over [logo, menu, button]' case.  (repeats R4-1)
R5-2  P3  src/core/understand/clear-header.ts:46  Fixer 4's known limit is wider than HANDOFF records ('a badge before four or more short words and a button'). drawnFirst accepts any picture up to the 64px icon size (only an icon before a contact line is excluded), though Justin's decision text defines a real logo as 'a drawn picture bigger than an icon'; so a page's lone first band [picture, 4+ short items or links, button] links its picture home and uncaps its Container (ticks off or footer only; base nothing): a 16px phone icon before 'Call us', the number, 4 words and PAY ONLINE (R5-B9), a 24px filter or search icon before 4 filter words (R5-B2, B2b; beside a drawn phone design R5-P2), a 56px product thumbnail before 4 tabs and BUY NOW (R5-B1, B1b), a Google logo before 4 review notes (R5-B6d), a badge before 4 points (R5-B6a, B6c; 1920 wide R5-D1; beside a phone design R5-P1); and through menuBelow a badge or illustration with a button over a bar of 4 linked categories (R5-A4, R5-A7). Only reachable with no header drawn and the header tick off, where base already names the band 'the page's header' in its note, so P3; but the record should list the whole class for Justin to confirm, or narrow what is separable (mutant R5M4, a first picture bigger than an icon, removes the icon cases but fails fix round 2's pinned 48px mark headers, so any size line needs Justin).  (repeats R4-1)
R5-3  P3  src/core/understand/clear-header.ts:53  menuIn counts a group's links before looking inside it, so a header whose linked menu row and button are grouped ([logo, Right[4 linked menu words, GET A QUOTE]]) takes the group as 'the menu', ctaIn then skips the button inside it, and the header converts as base (no home link), though HANDOFF's rule calls it clear and the same header with an unlinked menu is clear (header-clear.test.ts 'a logo, then its menu and a button grouped'): review-5/classify5.txt R5-B12, R5-B13 (round 4's head linked the logo). A false negative, base's outcome, so allowed by the careful rule; mutant R5M6 (look for the menu row inside first, count links last) makes both clear with the 57 focused tests green.
R5-4  P3  src/core/understand/clear-header.ts:107  Three narrowed guards have no killing test (review-5/mutation5.txt): N15 (notes.length >= 2) is not equivalent as fixer 4's receipt says: three notes stacked in a column are no base menu row (menuRow needs a row), and under the mutant [logo, column of 3 notes] is recognised and left out ticked where head and base keep it (R5M3, witness R5-C8, all four ticks differ); menuIn's row-mode test (R5M2: a column or free frame of four short items counts as a menu) and note's one-short-line test (R5M7: any text without a contact line is a note) survive all 57 focused tests too.
REVIEW AGAIN: 1 P0-P2 finding(s) in review-5 at e195c65: fix them, then review the fix commits
```

## What to do
- **R5-1 (P2):** a strip whose reading is clear only through a menu reading (`showsMenu` or `menuBelow`) must not be
  clear while a clear header bar sits under it in the run or right after it; call bars and icon bars work as before.
  Review 5's candidate R5M5c does this (all five witnesses equal base byte for byte, no other witness changes, 57
  focused tests green; `review-5/mutation5b.txt`); the broader R5M5 breaks the pinned case "a mark and a menu icon over
  a logo, a menu and a button". Verify it, then implement it test-first with witnesses R5-A1, R5-A3, R5-A3b, R5-B6b,
  R5-D2 as tests at base's outcome.
- **R5-3 (P3):** `menuIn` counts a group's links before looking inside it, so a header whose linked menu row and button
  sit in one group converts as base though HANDOFF's rule calls it clear (B12, B13). Apply R5M6 (find the menu row
  first, count links last) if it stays green and adds no unexpected witness.
- **R5-4 (P3):** kill R5M3 (N15 is not equivalent: a logo with a column of 3 notes, witness C8), R5M2 (`menuIn`'s
  row-mode check) and R5M7 (a note's one-short-line check) with tests, and correct fixer 4's receipt.
- **R5-2 (P3, record only, don't change the 64px line):** HANDOFF's known limit must list the whole class review 5
  found: a lone first band made of a picture up to 64px (a phone, filter or search icon, a product thumbnail, a Google
  logo, a badge), 4+ short items or links and a button links its picture home and uncaps its Container, with no header
  drawn and the tick off (base already calls such a band the page's header). Moving the line to "bigger than an icon"
  breaks fix round 2's pinned 48px mark headers: that size line is Justin's decision, so write it as an open question
  in HANDOFF, not a fix.
- **Optional, if cheap and safe:** review 5's B3 (a logo, 4 linked social icons and a button reads as clear because
  the 4-link menu test counts icons): a menu's links should be words. Do it only with a test and zero UNEXPECTED.
- **The witness receipt:** extend fixer 4's (166 witnesses, `fixer-4/expected-positives.txt`) with review 5's 49
  (`review-5/expected-positives*.txt`, `classify5.txt`, scripts). Write your expected positives with each one's expected
  outcome (labels linked home, or recognition only) to `fixer-5/expected-positives.txt` before the run. Zero
  UNEXPECTED is the bar, apart from the R5-2 known-limit class, which you list explicitly as known limits.

## Where
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `e195c65`, base `dea6296`). Work only there.
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-5/`. Earlier fixers:
  `fixer-1/` … `fixer-4/`. Approved plan (read only, amended): `plan-approved.md` beside them. Ledger
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/
  bdry-paste/header-v1/` (sha256 `f48783e5…`; rebuild its plugin inputs with `fx-header.ts` on your head and confirm
  they're byte-identical).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-5/`.

## Done means
R5-1 fixed test-first; R5-3 and R5-4 handled; R5-2 recorded; the witness receipt at zero UNEXPECTED (known limits
listed); every guard you keep has a test that fails without it (re-run earlier rounds' mutants downstream of anything
you narrow). `npm run check` green; the header-bar browser tests green with `skipped 0`; the full browser suite by test
name against a **built** base (no new failures); the AC7/AC8 receipts re-run (hydraulics, page-1, Services differ from
base only by the logo's home link; notes pinned per page); the B-Dry paste tests green. Don't edit source while a gate
runs. Fold your records into your fix commits. If a plan AC line can't hold, stop and say which: don't rewrite an AC.
Stop with `status: ready-for-next-review`: no merge, no BUILD.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its "Widening a recognizer
   carefully" line) and `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run
   or browser measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-fixer-5/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-fixer-5/`. Scratch trees for `npm run check` archive the
whole commit; run tsc as `node node_modules/typescript/bin/tsc --noEmit -p .` and with `-p tsconfig.sandbox.json`.
Corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). The worktree guard
refuses Bash it can't prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then
node, `git -C`, the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path):
write scripts with Write and run them as one plain command. Never commit in the same batch of tool calls as the gate
it depends on. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is being fixed in its own
worktree: leave it alone.

## Rules
- Plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check `git diff --cached --name-only`
  (never CLAUDE.md). Don't push, don't bump BUILD, don't edit the worktree's CLAUDE.md, never bare `git stash`. Files
  under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else`; don't fix them. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (normally
  empty). Never edit skills or memory. Don't start other agents.

## Return (your final message)
`{name, status: ready-for-next-review|stopped, findings[{id, verdict: fixed|rejected|recorded|partly, commit, test,
evidence}], witness_receipt{expected_positives, base_identical, positives, known_limits, unexpected}, rulings[],
open_questions_for_justin[], ac_status[{ac, accepted, test, evidence}], paste_sha256, last_commit, shots[], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
