# Brief: FIXER 4 for figma-to-bricks feature "header-bar" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 2 P0-P2 finding(s) in review-4 at cca0aba`. Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Justin's decisions in force
- **"Careful rules"** (`review-3/justin.json`): the plugin's new header rules apply only where a bar is clearly a
  header; everything uncertain converts exactly as base `dea6296` (payload and notes).
- **"Keep AC1 as written"** (2026-10-29, `~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`): a
  logo (or a picture wider than an icon) followed by a group of two short notes with no link of its own stays the site's
  header, as AC1 says, even though a badge followed by two grouped notes looks the same. **Anything beyond AC1's exact
  shape** (a picture followed by grouped buttons, short words, ☰s, or more than two notes) converts as base.

## The referee's lines (verbatim)
```
R4-1  P2  src/core/understand/clear-header.ts:42  The careful rule's 'clear header' test inherits base's own misreadings, so shapes Justin's decision names as uncertain ('a badge first', 'a title with icons or words after it') still get the new behaviour instead of converting as base: showsMenu calls any picture or short typed words before a row of three short items, or before three links, clear (base's whole menu reading), and site-header.ts:157 also sets LeftPart.own for any base logo bar with a bar of three links under it (r.last > r.own). Unticked or footer-only, head links the badge or title to '/' and drops its Container's 1440 cap; base linked nothing (review-4/probe4.log: A1/A1b/A1c a title 'Our Work' before three filter words, chips or linked categories; A2/A2b/A2c and G3 (1280 wide) a badge before three selling points; F3 that trust strip over a real [logo, menu, CTA] header: the BBB badge links home, the real logo does not; F1/F2 a title with an arrow or 'View all' over a bar of three linked categories: 'Our Projects' links home; G1 at 1920, G6 in a drawn-phone pair). Identical at round 3's head, so the careful rule left them open. It also breaks AC7's headline ('designs without a header bar convert byte-identical to base') outside its receipt's file list. Mutant X9 (showsMenu out of clearBar) fails AC2's sitePage, so a narrower test must keep a logo + menu + CTA header (review-4/mutation4.txt).  (repeats R3-1)
R4-2  P2  src/core/understand/clear-header.ts:67  groupedBar, the one non-clear reading the careful rule lets stand (site-header.ts:144, when no logo bar follows), takes any picture wider than an icon followed by groups of buttons, short words or drawn menu icons, while AC1 names only 'a logo followed by a group of two notes'. Ticked, such a first band is left out of the paste; unticked, the paste says it holds the page's header and the rhythm keeps its spacing as a site part; base kept it with 'no bar at the top holds a logo and a menu' (review-4/probe4.log B2 a 140px badge then 'Call now' and 'Get a quote' grouped, B4 a badge then two groups (rating words, a button), B7 a badge then a question and a linked 'Contact us', G7 in a drawn-phone pair: head left out ['Promo'], base ['-'], all four ticks differ). Round 3's head did the same, so it is left open from review 1's widened reading. AC1's own shape (B3, a partner logo before 'Proud member of' / 'Home Builders Association') is equally 'a badge first'; the fixer recorded that as a ruling rather than stopping as the fixer-3 brief asked when an AC line can't hold under the careful rule.  (repeats R1-1)
R4-3  P3  src/core/understand/site-header.ts:129  Three guards of the careful rule have no killing test (review-4/mutation4.txt, focused 53 tests): logoLike's callBar branch (X2) and groupedBar branch (X3), which keep base's reading when a call bar or a grouped bar sits under AC1's grouped bar (e.g. a badge and hours strip over a call bar would be left out alone, keeping the call bar), and rowOf's left-third check (X4, the only position check showsMenu has). The fixer's 46 mutants are otherwise all killed except the equivalent S6 (no memo), which holds; X8 (same=false) is equivalent too.
R4-4  P3  docs/HANDOFF.md:49  Records: the 'Which bar is the header's own' bullet says a strip may hold 'a phone icon or words' at its left, but stripOver's !realLogo(firstOf(s)) counts short typed words as a logo (wordmark), so a strip starting 'Open today' or 'Mon-Fri 8am-6pm' over a clear header keeps base's reading and the header's logo is not linked home (review-4/probe4.log C1; mutant X7 allowing words survives: no test pins it either way). The careful-rule paragraph (docs/HANDOFF.md:15-28) also omits the second way LeftPart.own is set (a logo bar with a bar of three links under it, site-header.ts:157), which the ledger and code comment state.
R4-5  P3  src/core/understand/clear-header.ts:27  The unread-icon fallback (a vector with no SVG, as in v1 files or a failed export) makes a call band a clear call bar when it ends in any icon: a v1-style band of a 96px illustration, a 32px phone line and a button grouped with an arrow is left out ticked (base: 'holds a heading') and unticked its illustration links home and the note calls 'Arrow' the menu icon (review-4/probe4.log E4); [logo, phone line, button, cart] still names 'Cart' (E1). v2 exports give these icons a drawing, so only v1 or failed-export files reach it.  (repeats R2-5)
REVIEW AGAIN: 2 P0-P2 finding(s) in review-4 at cca0aba: fix them, then review the fix commits
```

## What to do
- **R4-1 (P2):** the "clear header" test reuses base's whole menu reading (`showsMenu`; and `r.last > r.own` gives
  `LeftPart.own` to any base logo bar with a bar of 3 links under it), so a badge or a title before 3 short items or 3
  links counts as clear and gets the home link and the wide Container. Narrow it, don't remove it (review 4's mutant X9
  shows removal breaks AC2's sitePage): a clear menu header needs a real logo (not a badge or a title: decide from
  structure, e.g. a drawn logo picture or typed brand words that are not a section title) and a menu row of the site's
  links, and must keep logo + menu + CTA headers and the real files' Brandmark headers as they are now. The `r.last >
  r.own` hand-over follows the same test. Port review 4's witnesses (`review-4/probe4.log`: A1/A1b/A1c, A2/A2b/A2c, G3,
  F1/F2/F3, G1, G6) as tests at base's outcome.
- **R4-2 (P2):** narrow `groupedBar` to AC1's exact shape (Justin kept it): a logo or a picture wider than an icon
  followed by one group of exactly two short notes, the group holding no link of its own. Review 4's B2, B4, B7, G7
  (grouped buttons, short words or ☰s after a picture) convert as base. AC1's own case (B3) stays a header.
- **R4-3 (P3):** add killing tests for X2 (callBar branch of `logoLike`), X3 (groupedBar branch) and X4 (rowOf's
  left-third check), or remove a guard that turns out dead.
- **R4-4 (P3):** HANDOFF's careful-rule paragraph: say what a strip may hold at its left (short typed words count as a
  logo), and name the `r.last > r.own` way of setting `own`. Kill mutant X7 or explain it.
- **R4-5 (P3, v1 files only):** a call band ending in an undrawn arrow becomes a clear call bar. If cheap and safe,
  require the undrawn last icon to be the bar's only icon at its right end and the bar to hold a contact line; else
  record it as a known limit in HANDOFF.
- **The witness receipt:** before you run it, write the expected-positive witness ids (the clear shapes from AC1–AC6
  and the B-Dry bar) to `fixer-4/expected-positives.txt`; the classifier marks every witness that differs from base and
  isn't listed as UNEXPECTED. Include base's own misreadings (a title before 3 filter words, a badge before 3 selling
  points) and review 4's 45 witnesses plus fixer 3's 89. Zero UNEXPECTED is the bar.

## Where
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `cca0aba`, base `dea6296`). Work only there.
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-4/` (review 4's
  `review.json`, `probe4.log`, `mutation4.txt`, `probe-fixer3-witnesses.log`, scripts). Earlier fixers: `fixer-1/` …
  `fixer-3/` (fixer 3's `witnesses.ts`, `probe.ts`, `classify.txt`). Approved plan (read only, amended):
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`. Ledger
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/
  bdry-paste/header-v1/` (sha256 `f48783e5…`; rebuild its plugin inputs with `fx-header.ts` on your head and confirm
  they're byte-identical).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-4/`.

## Done means
R4-1 and R4-2 fixed test-first under the two decisions above, R4-3 to R4-5 handled, the witness receipt at zero
UNEXPECTED, every guard you keep with a test that fails without it. `npm run check` green; the header-bar browser tests
green with `skipped 0`; the full browser suite by test name against a **built** base (no new failures); the AC7/AC8
receipts re-run (hydraulics, page-1, Services differ from base only by the logo's home link; notes pinned per page);
the B-Dry paste tests green. Don't edit source while a gate runs. Fold your records into your fix commits. If a plan
AC line can't hold, stop and say which: don't rewrite an AC. Stop with `status: ready-for-next-review`: no merge, no
BUILD.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its "Widening a recognizer
   carefully" line) and `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run
   or browser measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-fixer-4/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-fixer-4/`. `npm run corpus` measures nothing here;
corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). The worktree guard
refuses Bash it can't prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then
node, `git -C`, the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path):
write scripts with Write and run them as one plain command. Never commit in the same batch of tool calls as the gate
it depends on. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is under review in its own
worktree: leave it alone.

## Rules
- Plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check `git diff --cached --name-only`
  (never CLAUDE.md). Don't push, don't bump BUILD, don't edit the worktree's CLAUDE.md, never bare `git stash`. Files
  under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else`; don't fix them. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (normally
  empty). Never edit skills or memory. Don't start other agents.

## Return (your final message)
`{name, status: ready-for-next-review|stopped, findings[{id, verdict: fixed|rejected|removed|partly, commit, test,
evidence}], witness_receipt{expected_positives, base_identical, positives, unexpected}, rulings[], ac_status[{ac,
accepted, test, evidence}], paste_sha256, last_commit, shots[], found_else[], skill_lessons[]}`. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
