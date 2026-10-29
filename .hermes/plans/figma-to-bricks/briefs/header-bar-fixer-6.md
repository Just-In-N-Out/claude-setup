# Brief: FIXER 6 for figma-to-bricks feature "header-bar" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 1 P0-P2 finding(s) in review-6 at b8d1d01` (after Justin
answered the brake). Verify each finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't
re-plan and don't widen the job.

## Justin's decisions in force (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`)
- **"Careful rules"**: the new header rules apply only where a bar is clearly a header; everything uncertain converts
  exactly as base `dea6296` (payload and notes).
- **"Keep AC1 as written"**: a logo or picture wider than an icon followed by a group of two short notes with no link
  of its own stays a header; anything beyond that exact shape converts as base.
- **"One more fix, then accept"** (`review-6/justin.json`): this round closes R6-1 and the round-6 records; if round 7
  finds new neighbour designs, they become known limits.
- **R6-5, "Both are the header"**: a call bar (phone line, button, ☰) drawn right above a plain nav bar (a home icon and
  4 unlinked menu words) is one header: with the header tick on, both bars are left out, as base does. Review 6's
  F5-A5, R6-P1 and R6-P2 must equal base at all four ticks.
- **S1 (the 64px size line):** unchanged; the lone-band class stays a recorded known limit.

## The referee's lines (verbatim)
```
R6-1  P2  src/core/understand/site-header.ts:157  R5-1 is closed only when the real header is the second of the top bars. topBars reads two sections at most (bars.ts:13) and site-header passes clearOwn bars[r.last + 1], so with an announcement strip on top, a trust strip (BBB badge, 4 selling points, BOOK NOW) or a utility bar (16px pin icon, 4 linked links, PAY ONLINE) in second place is still read as a clear menu header over the real header (now the page's third section, which clearOwn never sees): ticks off or footer only, its first picture links home and both top bars' Containers drop their 1440 cap; base links nothing, the tick takes the same bars. Witnesses review-6/probe6-r6.log R6-A1, A2 (header menu linked), A3 (utility bar), G1 (drawn 1920 wide), G2 (beside a drawn phone design: the desktop badge linked), each identical to the round-5 head; the two-bar form (R6-A4, R5-B6b, R5-A1) is fixed. Candidate R6C1 (pass the section right after the run, `next = sections[run.length]`, already computed at site-header.ts:150) brings A1, A2, A3, G1 and G2's desktop part to base with the 61 focused tests green and every one of the 242 earlier witnesses classified as before (review-6/classify-cand1-v2.txt); it also turns R6-H1 (an announcement strip over the real header, a trust band with a button as the third section) into the same false negative as R6-A5, see R6-2.  (repeats R5-1)
R6-2  P3  src/core/understand/clear-header.ts:108  Fixer 5's rule makes AC2's real header (logo, menu of 4, GET A QUOTE) convert as base whenever a band of R5-2's class sits right under it: a trust band (badge, 4 points, BOOK NOW), a category bar (16px icon, 4 linked categories, SHOP NOW) or a filter bar (24px icon, 4 words, a button) under the header takes away the logo's home link, the menu note and the wide Container it had at the round-5 head (R6-A5, A7, F4, G3 at 1280; byte-identical to base, so allowed by the careful rule). HANDOFF:160 and its false-negative list (HANDOFF:188) name only two menu headers stacked and a menu header over a call bar or a logo with its menu icon, not this class. The outcome also depends on an unrelated strip on top: with an announcement strip over the same header and the same trust band, the header stays clear (R6-H1), because 'right after it' is read as the next of two top bars. Informational candidate R6C2 (a clear bar under it blocks only when the header's own bar is thinner than it, as R5-1's strip was) keeps A5, A7, F4, G3 clear and with R6C1 still brings R6-A1-A3, G1 and every R5-1 witness to base, 61 focused tests green, the 242 earlier witnesses classified as before (review-6/classify-cand2-v2.txt, mutation6-cand.txt). A false negative, base's outcome: record the class, or Justin's call on 'thinner'.
R6-3  P3  docs/HANDOFF.md:175  R5-2's known-limit class is wider than recorded: HANDOFF says 'with no header drawn', but a trust strip (badge, 4 points, BOOK NOW) as the page's only top bar over a hero holding the real header drawn inside it (a common way headers over photos are drawn) links its badge home and uncaps its Container, ticks off or footer only, base nothing (R6-A9; identical at the round-5 head). Neither candidate changes it (the hero is no bar). Records: add 'or drawn inside the hero' to the class.
R6-4  P3  docs/HANDOFF.md:36  Records overstate two things. (a) 'Every witness reviews 1-5 built is a test, each a clear header or base's outcome': R5-2's known-limit witnesses (R5-B1 product thumbnail, R5-B2 filter icon, R5-B9 PAY ONLINE …) are neither and appear in no test, only in the receipt. (b) The ledger (progress.md:463) and commit 4bbbfb7 say AC1's test now covers both terms of linkedAround, but the linksHere(n) term has no killing case: mutant R6M17 (clicks only) survives the 61 focused tests (review-6/mutation6.txt); fixer 5's F5N10b/F5N11 kill the path and the click term, not this one. Likely equivalent for groupedBar today (a plugin-made link without a Figma click, a page link or a contact link, can't sit on the bar or on the frame around AC1's exact logo and two notes), so name it equivalent in the receipt or add a case.
R6-5  P3  src/core/understand/site-header.ts:143  The brief's F5-A5 question: a call bar over another header-like bar converts unlike base in what the tick leaves out, not only in the call bar's logo link. Base reads the lower bar as the header and leaves both bars out; head keeps the wider reading (stands: the call bar is clear) and leaves only the call bar, so with 'My site already has its header' ticked the lower bar stays in the paste under the site's header: F5-A5 (a logo, 4 menu words, a button), R6-P1 (a 16px home icon and 4 unlinked menu words), R6-P2 (… and a button) all differ from base at all four ticks; R6-P3 (the words linked: the bar joins the run) differs only by the link, as base takes both (review-6/probe6-p.log). Under the careful rule's letter this stack is uncertain and should convert as base, and its effect (a menu bar left in the page) would be P2-grade; but it predates this delta (identical at e195c65; the run comes from read/stands, untouched here, and clearOwn's call-bar exemption only adds the link), so the delta scope caps it at P3. Worth Justin's call: is a call bar with its menu icon over an unlinked nav bar one header (base: both leave) or the header over page content (head)?
REVIEW AGAIN: 1 P0-P2 finding(s) in review-6 at b8d1d01: fix them, then review the fix commits
```

## What to do
- **R6-1 (P2):** apply review 6's candidate R6C1: `clearOwn` reads the section right after the header's run
  (`sections[run.length]`, already computed at `site-header.ts:150`), not `bars[r.last + 1]`, so an announcement strip on
  top can't hide the real header. Witnesses R6-A1, A2, A3, G1, G2 (desktop design) as tests at base's outcome; the
  two-bar form (R6-A4, R5-A1, R5-B6b) stays at base. Re-run AC7's real-file replays with it (the section after the run
  can now be the hero). Also apply R6C2 (block only when the header's own bar is thinner than the clear bar under it)
  if it stays green and keeps AC2's real header clear over a trust/category/filter band (R6-A5, A7, F4, G3), with zero
  UNEXPECTED; otherwise list those as false negatives in HANDOFF.
- **R6-5 (Justin's "both are the header"):** make the call bar over a plain nav bar convert as base (both bars left out
  with the tick on; base's notes), test-first with F5-A5, R6-P1, R6-P2.
- **R6-3 (P3):** HANDOFF's known-limit class: say it also covers a trust strip as the only top bar with the real header
  drawn inside the hero (R6-A9).
- **R6-4 (P3):** HANDOFF must not say every review witness is a test (R5-B1, B2, B9 are receipt-only: say so, or add
  them as tests); kill R6M17 (`linksHere(n)` in `linkedAround`) with a plugin-made link case (a page or contact link,
  which sets `IRNode.link` without a Figma click), or name it equivalent with the reason in the receipt.
- **The witness receipt:** extend fixer 5's (242) with review 6's 30 + P1–P3 (`review-6/`). Write your expected
  positives with outcomes to `fixer-6/expected-positives.txt` before the run (keep v1 if you revise, with a reason per
  changed id, and convert every witness with `b8d1d01` too). Zero UNEXPECTED is the bar (known limits listed).

## Where
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `b8d1d01`, base `dea6296`). Work only there.
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-6/` (review 6's
  `review.json`, `probe6-*.log`, `classify-cand1-v2.txt`, `classify-cand2-v2.txt`, `mutation6*.txt`, scripts). Earlier
  fixers: `fixer-1/` … `fixer-5/`. Approved plan (read only, amended): `plan-approved.md` beside them. Ledger
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/
  bdry-paste/header-v1/` (sha256 `f48783e5…`; rebuild its plugin inputs with `fx-header.ts` on your head and confirm
  they're byte-identical).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-6/`.

## Done means
R6-1 and R6-5 fixed test-first; R6-3, R6-4 handled; the witness receipt at zero UNEXPECTED; every guard you keep has a
test that fails without it (re-run earlier mutants downstream of what you change). `npm run check` green; the
header-bar browser tests green with `skipped 0`; the full browser suite by test name against a **built** base (no new
failures); the AC7/AC8 receipts re-run (hydraulics, page-1, Services differ from base only by the logo's home link;
notes pinned per page); the B-Dry paste tests green. Don't edit source while a gate runs. Fold your records into your
fix commits. If a plan AC line can't hold, stop and say which: don't rewrite an AC. Stop with
`status: ready-for-next-review`: no merge, no BUILD.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its "Widening a recognizer
   carefully" line) and `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run
   or browser measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-fixer-6/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-fixer-6/`. Scratch trees for `npm run check` archive the
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
evidence}], witness_receipt{expected_positives, base_identical, positives, known_limits, false_negatives, unexpected},
rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, last_commit, shots[], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
