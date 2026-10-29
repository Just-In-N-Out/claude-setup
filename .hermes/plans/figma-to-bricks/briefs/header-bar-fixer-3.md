# Brief: FIXER 3 for figma-to-bricks feature "header-bar" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 4 P0-P2 finding(s) in review-3 at 11dfd5e`, after its
brake asked Justin and he chose **"Careful rules"**: make the plugin's new header rules conservative. Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Justin's decision (2026-10-29, `review-3/justin.json`): "Careful rules (Recommended)"
Three review rounds have each found neighbouring designs the header rule gets wrong: the fixes patched examples, not
the class. So fix the **class**, conservatively:
- **New behaviour only where a bar is clearly a site header.** A top bar that holds a real logo (a drawn picture
  bigger than an icon, or typed words), a contact line (a phone number or email with at most 4 other words), and ends in
  a menu icon whose drawing reads as one (bars), with or without a button: that shape, which AC1 lists and which the
  B-Dry header is, stays recognised and gets the home link. Decide what "clearly" means from the plan's AC1 positives
  and the reviewers' shapes; write it as one short rule in HANDOFF.
- **Everything uncertain converts exactly as base `dea6296` does**: a strip over a bar, a band under a header, a badge
  first, a title with icons or words after it, a header without a readable menu icon, an icon on a backdrop the reader
  can't judge. Where base and head would differ for such a shape, head must equal base (payload and notes). Port every
  witness from reviews 1–3 (their probes in `reviewer-1/`, `reviewer-2/`, `review-3/probes/`) as tests: each must
  either be a clear header (new behaviour, positive) or equal base (negative). Add your own class-level controls on both
  sides of every threshold you keep.
- Removing a rule that can't be made safe is allowed (say so as "My ruling, not yet confirmed"), as long as AC1's
  listed positives, AC2's home link on them, AC4's edges and H1's cap, AC6's note on a clearly drawn ☰, and the B-Dry
  paste's plugin inputs stay as they are. If a plan AC line can't hold under the careful rule, stop and say which:
  don't rewrite an AC.

## The referee's lines (verbatim)
```
R3-1  P2  src/core/understand/site-header.ts:165  handsOver lets a taller band under a real header take it over when the band shows a 'menu': showsMenu counts any row of three short items, so a trust band with a badge at its left and a row of three selling points (ticked or plain) under a header that has no menu row and no links ([logo, menu icon], or the AC1 call bar) becomes the header's own. Ticked, the trust band is left out with the header (the note names 'Trust', 163-180px); unticked, the BBB badge links home, the real logo does not, and the header's menu note is lost. Base kept the band under a [logo, menu icon] header (probes/probe.log S1d: base ['Header'], head ['Header','Trust']); round 2's head kept it under every shape (S1, S1b, S1d, S1e). The same happens for a taller band ending in a picture icon with no drawing (S8, as on round 2). The tests only probe trust bars thinner than the header or headers with a menu row.  (repeats R2-1)
R3-2  P2  src/core/understand/site-header.ts:165  R2-2 is closed only when the header under the strip shows a menu row, 3 links, or ends in a menu-like icon: a badge strip (80x30 badge, phone line, hours) over a header that ends in its button or a cart ([logo, phone line, Get A Quote], [logo, menu icon, button], [logo, button, 'MENU' + menu icon], [logo, menu icon drawn, cart drawn], or a menu icon drawn on a round button, see R3-3) is still the header alone: ticked, only the 40px strip is left out and the drawn header stays; unticked, the badge links home and the header's menu note is lost. Base left out both strip and header for all five shapes (probes/probe.log S2-S5 and probes/probe2.log C5: base ['Top strip','Header'], head ['Top strip']); the HANDOFF's 'still leaves the paste alone, as on base (two headers)' is wrong for them.  (repeats R2-2)
R3-3  P2  src/core/normalise/menu-shape.ts:19  menuShape measures THIN and LONG against the whole drawing's size, backdrop included (glyphOf's size), so a menu icon Figma exports with its button's fill (a 48px circle with 18px bars, a 56px tile with 20px bars, a 64px tile with 24px bars) reads 'other' (probes/menu-shape-probe.log). menuLike is then false, and fix 2's new rule in blocked (site-header.ts:175, contact line excused only before a menu icon) makes the AC1 call bar with a 28px phone line 'hold a heading': ticked, nothing is left out; unticked, no logo home link and no menu note (probes/probe2.log C2, C3; round 2's head recognised both, base did not). At a 16px phone line the header is kept but its note is lost (C4), and a strip over it keeps R3-2's shape (C5). The HANDOFF says 'a ring or tile behind them allowed'. Mutant R3M3 (size from the bars' own drawing) passes all 45 focused tests (probes/mutation.txt), so nothing pins the backdrop-relative size.
R3-4  P2  src/core/understand/site-header.ts:104  logoBar's two-layer clause (kids.length === 2 && iconOnly(last)) still takes a section's title row for the header when the title is followed by one layer: an arrow drawn pointing on, a chevron, a plus, or a short word ('View all'). Fix 2 put menuLike only on the three-layer clause (acaafd8) and 449393c's 'a short word is never a header's icon ... for recognition' misses this clause. Ticked the title band is left out (as base); unticked the title links to the home page (new in this story; round 2 also named the arrow as the menu icon) (probes/probe4.log U1-U4; the control U5, a typed logo and a drawn menu icon, stays the header). The R2-3 test 'however its end is drawn' covers only three-layer rows and [title, [button, arrow]].  (repeats R2-3)
R3-5  P3  src/core/understand/site-header.ts:153  Two new guards have no test that can fail: showsMenu's 'links(bar) >= LINKS' clause (mutant R3M1, dropped: all 45 focused tests pass) and menuShape's top-to-bottom sort (R3M2, dropped: all pass; a menu icon whose SVG lists its bottom bar first would read 'other' without it). holdsContact's slice(1) (R3M4) also survives (near-equivalent: a typed logo is rarely a contact line). probes/mutation.txt.
R3-6  P3  docs/HANDOFF.md:99  Records overstate fix 2: the header-bar section says a strip over a header showing neither a menu row nor a menu icon 'still leaves the paste alone, as on base (two headers)', but base left out both for a badge strip over [logo, phone line, button] (R3-2); and 'a ring or tile behind them allowed' holds only when the bars are at least 40% of the backdrop (R3-3).
R3-7  P3  src/core/normalise/menu-shape.ts:16  menuShape reads an equals sign and an align-left text icon as a menu icon's bars (probes/menu-shape-probe.log), so such an icon at a header's end is named as a menu icon that opens nothing; and unlike arrowShape it has no SVG size cap or memo though each header icon is read several times per bar (logoBar, showsMenu, blocked, headerMenuIcon).
REVIEW AGAIN: 4 P0-P2 finding(s) in review-3 at 11dfd5e: fix them, then review the fix commits
```

## Where
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `11dfd5e`, base `dea6296`). Work only there.
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/`, `review-2/` (with `justin.json`),
  `review-3/` (its `review.json`, `justin.json`, `probes/`: `probe.log`, `probe2.log`, `probe4.log`,
  `menu-shape-probe.log`, `mutation.txt`, scripts). Earlier reviewers' reports: `reviewer-1/review.json`,
  `reviewer-2/review.json`; earlier fixers: `fixer-1/`, `fixer-2/`. Approved plan (read only, amended):
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`. Ledger:
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste:
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (sha256 `f48783e5…`; its plugin inputs come from
  `fx-header.ts`: rebuild them on your head and confirm they're byte-identical, or rebuild the paste and give the new
  hash with the reason).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-3/`.

## Done means
R3-1 to R3-4 fixed under the careful rule (or the rule removed where unsafe), R3-5's surviving mutants (R3M1, R3M2)
killed or their guards removed, R3-6's HANDOFF wording fixed, R3-7 (menuShape reads "=" and an align-left icon as ☰;
no SVG size cap or memo like `arrowShape`) fixed if the careful rule still uses menuShape. Every new guard's test fails
without it. `npm run check` green; the header-bar browser tests green with `skipped 0`; the full browser suite by test
name against a **built** base (no new failures); the AC7/AC8 receipts re-run with notes pinned per page (hydraulics,
page-1, Services differ from base only by the logo's home link); the B-Dry paste tests green. Fold your records
(ledger, HANDOFF) into your fix commits to keep the next review's range small. Stop with
`status: ready-for-next-review`: no merge, no BUILD.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
   `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
   measurement (it now covers icon readers on backdrops and fixtures built after `resetIds()`).
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-fixer-3/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-fixer-3/`. `npm run corpus` measures nothing here;
corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
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
`{name, status: ready-for-next-review|stopped, careful_rule, findings[{id, verdict: fixed|rejected|removed|partly,
commit, test, evidence}], rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, last_commit, shots[],
found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
