# Brief: FIXER 7 for figma-to-bricks feature "header-bar" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 2 P0-P2 finding(s) in review-7 at 96a4d47`. Justin is
asleep under an away grant (`~/.hermes/plans/figma-to-bricks/away-2026-10-29.md`: "keep the agents running and going
and go with recommended stuff… if an agent is lost then it will have to do research to figure it out"). Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Justin's decisions in force (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`)
- **"Careful rules"**: new header behaviour only where a bar is clearly a header; uncertain shapes convert as base.
- **"Keep AC1 as written"**.
- **"One more fix, then accept"**: new *neighbour* shapes become known limits. Review 7's two P2s are **regressions
  from fix 6** (b8d1d01 handled them better), so they are fixed now, narrowly.
- **R6-5 "Both are the header"**: a call bar (phone line, button, ☰) drawn right above a plain nav bar (a home icon and
  4 unlinked menu words) is one header: **with the header tick on, both bars are left out.** That's the outcome he chose,
  whatever base does.

## The referee's lines (verbatim)
```
R7-1  P2  src/core/understand/clear-header.ts:68  (a) Regression from this delta that undoes R3-1's fix. holdsMenu, which oneHeader calls (site-header.ts:138), counts any bar of four short items as a nav bar. So the B-Dry-style call bar from AC1, drawn right over a band of four selling points, four tabs, four crumbs or four stats, now converts as base. With the header tick on, base's outcome on those pages is harmful. (1) Where base takes the band for the header (a trust band with a badge, 4 points and BOOK NOW, 64px or 96px, also drawn 1280 wide and beside a drawn phone design; a title with 4 filter tabs), the band leaves the paste along with the call bar: 'Licensed' and 'Our Work' appear 0 times on head and once on b8d1d01 (review-7/paste-words.txt). (2) Where base finds no header (a strip of 4 selling points with or without BOOK NOW, a breadcrumb strip, a stats strip, an announcement strip over the call bar and a trust band), the tick leaves AC1's own call bar in the paste: 'Call Us At' appears once on head and 0 times on b8d1d01. b8d1d01 left out only the call bar and kept the band, and so does every twin with three items (R7-A1t to A5t). HANDOFF:77 still says 'R3-1: a trust band under a call bar stays'. With the ticks off, the call bar's logo is no longer linked. Witnesses: review-7/probe7.log R7-A1 to A11 (head equals base at all four ticks and differs from b8d1d01 at all four). Fixer 6's receipt never probed a four-item band that is not a nav bar; its ruling compares only with R3-1's three-item trust bars. A centred strip of four selling points (R7-A3) and a centred nav bar of four menu words (F6-W2) have the same structure, so where the line falls is Justin's call. b8d1d01's outcome, the call bar alone left out and the band kept, loses no page content.  (repeats R3-1)
R7-2  P2  src/core/understand/site-header.ts:155  (a) This breaks Justin's R6-5 answer for its own class, and the tick does worse than b8d1d01. Justin's answer: a call bar right over a plain nav bar is one header, and 'with the header tick on, both bars are left out'. Fixer 6 built it as 'converts as base'. Base finds no header when the same nav bar has no picture at its left: four menu words starting at the bar's left (R7-B1), centred (F6-W2), the site-parts menu with its dropdown chevron centred (R7-B4), the nav bar as the third section under an announcement strip (F6-W3), and a second call bar under the call bar (F6-W12, fixer 6's second ruling). In each of these, the tick leaves both bars, AC1's call bar included, in the paste under the site's own header: 'Call Us At' appears once on head and 0 times on b8d1d01 (review-7/paste-words.txt). b8d1d01 at least left the call bar out. Only the forms with a home icon (R6-P1, P2, R7-B2 with five words, B3 with a 24px icon), a logo with its menu icon (F6-W11, R7-C4) and a shop header (R7-C1) leave both out, as the answer says. HANDOFF records the outcome above as fixer 6's unconfirmed ruling ('there base finds no header and the tick leaves both in the page'), and the test 'R6-5 (careful)' pins it (header-stacked.test.ts:125, 126, 133: nothing left out). But that outcome contradicts the answer's own words, and it breaks AC1's opening clause ('ticked, a bar holding a logo, a phone line, a button and a ☰ is left out') for these drawings.
R7-3  P3  src/core/understand/clear-header.ts:116  (b) A neighbour of R5-1, R5-2 and R6-3's known-limit class, outside this delta (head equals b8d1d01). The real header is drawn as two rows: a logo and GET A QUOTE over their bar of four links. A trust strip over it (badge, 4 points, BOOK NOW) is still read as the clear header (R7-D1), and so is the same page under an announcement strip, where the header is the third section that barAfter now reads (R7-D2). With the ticks off or footer only, the BBB badge links home and both Containers lose their 1440 cap; base links nothing. clearOwn blocks only a clear bar right under the strip, and a logo-and-button bar is not one, because its menu is the bar under it and menuBelow is not part of clearBar. The class record says 'with no header drawn, or drawn inside the hero'; add 'or drawn as two rows (a logo and a button over its bar of links) under it'.
R7-4  P3  src/core/understand/site-header.ts:138  (b) Coverage of fixer 6's second ruling, outside this delta (head equals b8d1d01). 'Another header's bar' means a clear bar only. A logo-and-button bar under the call bar (R7-C3: a logo and GET A QUOTE, a header whose menu is hidden) is not one, so the call bar stays clear. Ticked, only the call bar leaves and the logo bar stays in the paste, while base takes both. A real header whose menu is linked (R7-C2) joins the call bar's run: both are left out and the call bar's logo links home. That matches 'Both are the header' and HANDOFF's 'the bars of its own run'. Record C3's class, or ask Justin whether a logo-and-button bar under a call bar is the header too.
R7-5  P3  src/core/understand/bars.ts:12  isBar's two lines have no test on their far side. R7M1 (a bar exactly 200px tall is no bar) and R7M2 (a bar exactly 80% of the page wide is no bar) survive all 63 focused tests (review-7/mutation7.txt). The behaviour at both lines is right: R7-E1 (200px) and R7-E3 (1152px) block, R7-E2 (201px) and R7-E4 (1151px) do not, as HANDOFF says. These are base's topBars lines, which barAfter now shares. R7M6 (clear reads the bar after the wider run) also survives, but it is equivalent: it changes none of the 329 witnesses at any tick (review-7/r7m6-compare.txt). The wider and final runs differ only where base keeps a strip that the wider reading handed over. That strip cannot be clear: stripOver demands that it is no clearBar, and its menuBelow sees an empty run. The rest of the receipt holds: fixer 6's 178 mutants give the same 144 KILLED, 5 equivalent and 29 SETUP-FAIL here; R7M3, M4v2, M5, M7 and M8 are KILLED.
REVIEW AGAIN: 2 P0-P2 finding(s) in review-7 at 96a4d47: fix them, then review the fix commits
```

## What to do (the recommended route, taken under the away grant)
- **R7-2 (P2):** implement Justin's R6-5 answer literally: where a call bar sits right above a real nav bar, the tick
  leaves **both** bars out, including where base finds no header (nav words starting at the bar's left, a centred nav,
  the site-parts menu with its chevron, an announcement strip on top). Witnesses R7-B1, R7-B4, F6-W2, F6-W3 in
  `review-7/probe7.log` (and the tests pinning the old outcome at `test/unit/header-stacked.test.ts:125, 126, 133`: those
  pins change to "both left out", with the reason in the test). Fixer 6's second ruling (a call bar over a second call
  bar, F6-W12) is not Justin's: give it b8d1d01's outcome (the call bar left out, the lower bar kept) unless both bars are
  plainly one header; say which in `rulings[]`.
- **R7-1 (P2):** a band of four short items that is **not** a nav bar (selling points, tabs, crumbs, stats, a trust band
  with a badge and BOOK NOW, a title with four tabs) under a call bar gets b8d1d01's outcome again (only the call bar
  left out; the band stays in the paste). Tell a real nav bar from a four-item band by structure that holds across
  designs (e.g. items that are the site's page links or menu words with no badge, no button, no numbers or long
  phrases, a home icon), never by B-Dry's words; when it's unclear, the band stays (b8d1d01). Witnesses R7-A1 to A11.
- **R7-5 (P3):** kill R7M1 and R7M2 with tests on the far side of `isBar`'s 200px and 80% lines.
- **R7-3, R7-4 (P3):** record in HANDOFF (R7-3 adds "drawn as two rows" to the known-limit class; R7-4 a call bar over a
  logo-and-quote bar as a known gap).
- **Records:** HANDOFF:77 ("R3-1: a trust band under a call bar stays") must say what the code does after your fix.
  Fold records into your fix commits.
- **The witness receipt:** extend fixer 6's (295) with review 7's 34 (`review-7/`). Write your expected positives with
  outcomes to `fixer-7/expected-positives.txt` before the run (keep v1 if you revise, with a reason per changed id;
  convert every witness with `96a4d47` and `b8d1d01` too). For every witness that moves to base or changes its ticked
  outcome, print the ticked left-out labels on the previous head and on head (review 7's lesson: "as base" is safe only
  where base's ticked outcome is). Zero UNEXPECTED is the bar.
- If you get lost, research it (the code, the earlier reports, the live pages) and implement your best, recording each
  call as "My ruling, not yet confirmed"; don't stop to ask.

## Where
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `96a4d47`, base `dea6296`). Work only there.
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-7/` (review 7's
  `review.json`, `probe7.log`, `probe7-all.log`, `paste-words.txt`, `mutation7*.txt`, scripts). Earlier fixers: `fixer-1/`
  … `fixer-6/`. Approved plan (read only, amended): `plan-approved.md` beside them. Ledger
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/
  bdry-paste/header-v1/` (sha256 `f48783e5…`; rebuild its plugin inputs with `fx-header.ts` on your head and confirm
  they're byte-identical).
- Live pages (read only): https://bdryswi.com/ and https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-7/`.

## Done means
R7-1 and R7-2 fixed test-first; R7-3 to R7-5 handled; the witness receipt at zero UNEXPECTED; every guard you keep has a
test that fails without it (re-run earlier mutants downstream of what you change). `npm run check` green; the
header-bar browser tests green with `skipped 0`; the full browser suite by test name against a **built** base (no new
failures); the AC7/AC8 receipts re-run (hydraulics, page-1, Services differ from base only by the logo's home link);
the B-Dry paste tests green. Don't edit source while a gate runs. If a plan AC line can't hold, stop and say which:
don't rewrite an AC. Stop with `status: ready-for-next-review`: no merge, no BUILD.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its "Widening a recognizer
   carefully" line) and `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run
   or browser measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-fixer-7/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-fixer-7/`. Scratch trees for `npm run check` archive the
whole commit; run tsc as `node node_modules/typescript/bin/tsc --noEmit -p .` and with `-p tsconfig.sandbox.json`.
Corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). The worktree guard
refuses Bash it can't prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then
node, `git -C`, the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path):
write scripts with Write and run them as one plain command. Never commit in the same batch of tool calls as the gate
it depends on. Waits: poll in chunks under 170 s. Other jobs are running in their own worktrees: leave them alone.

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
