# Brief: FIXER 2 for figma-to-bricks feature "header-bar" (Full pipeline)

You are a fresh fixer. Act on reviewer 2's findings: verify each one first, fix the valid ones test-first, and push
back with evidence on any that are wrong. Don't re-plan and don't widen the job.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `e630f4d`, base `main` = `dea6296`). Work only there; never edit the main folder or another worktree.
- Reviewer 2's report: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/reviewer-2/review.json` (read it whole),
  with its probes (`probe-variants.log`, `probe-variants2.log`, `probe-variants3.log`, `probe-hover-logo.log`,
  `probe-paste-widths.log`, `mutation-report.txt`, `mutation-report-q6.txt` and the Q6 fix probe itself). Reuse its
  probe fixtures rather than retyping them.
- Earlier rounds: `reviewer-1/review.json` and `fixer-1/` beside it (fixer 1's report is in its ledger entries).
- Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`; Justin's answer
  H1 = A in `~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`. Ledger:
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste:
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (sha256 `f48783e5…`).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-2/`.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
   `references/rules-summary.md`; read `references/testing-pitfalls.md` before any receipt, mutation run or browser
   measurement; only the worktree `CLAUDE.md` sections you need (grep + offset/limit).
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline` (each guard you add or keep must have a test that fails without it),
6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## The findings (reviewer 2, verdict request-changes)
- **F1 (high, a regression against base), `site-header.ts:203`:** the strip hand-over
  (`!realLogo(firstOf(bars[own])) && logoBar(bar)`) fires whenever the header's first layer is 64px or smaller, so a
  real header with a small square logo mark (48px) and a menu hands itself over to any logo-bar-shaped band under it
  (a promo band, a trust bar, a title band, a second info row). Ticked: that band is left out with the header (page
  content lost; base left out only "Header", 73px). Unticked: the band's badge or title links "/" instead of the real
  logo, and both Containers lose their 1440 cap.
- **F2 (high), same line, review 1's "two headers" class still open:** a top strip whose first layer is a picture
  bigger than an icon (an 80×30 badge), with the phone line and its notes grouped, over a real header: the strip
  becomes the header's own bar and the hand-over never fires. Ticked: only the strip is left out, so the design's
  header stays under the site's own (two headers; base left out both). Unticked: the badge links "/".
- **Reviewer 2's suggested fix for F1 and F2 (its probe Q6):** hand over only from a **contact strip**, a bar with no
  menu row, fewer than 3 links and no call to action, whatever the size of its first layer. In its scratch copy all 59
  header tests stayed green and every F1/F2 probe and the call-bar-over-promo/trust-band cases came out right; the
  simpler Q4 and Q5 variants broke AC6's two-bars case and the call bar over a promo band. Start from Q6, but verify it
  yourself, test-first, with F1's and F2's probes as failing tests first.
- **F3 (medium), `site-header.ts:96`:** the typed-words path still takes a section's title row for the header when the
  row ends in any small icon: (title, "View all", arrow) not grouped; (title, group of CTA + arrow); (title, previous,
  next) not grouped. As a page's first band (or under a small-mark header via F1): ticked, the row is left out;
  unticked, the title links "/" and a note calls "Arrow"/"Next" "the menu icon in your header". Base kept all three.
  Suggestion: the closing icon must not be an arrow or chevron (read its drawing, as the link rules do), and the
  actions must hold a contact line or a CTA.
- **F4 (low, a gap; base is the same), `bar-parts.ts:82`:** logos 64px or smaller aren't covered by the new rule (a
  56×56 logo is never recognised; a short typed logo "Acme" is recognised at a 16px phone line but "holds a heading" at
  28px). Fix it only if it falls out of the F1/F2 change with its own tests; otherwise record it in HANDOFF as a
  follow-up.
- **F5 (low), `site-header.ts:125`:** the AC6 note names whatever icon ends the bar: (logo, phone line, CTA, cart) and
  (logo, ☰, cart) both get "Cart: the menu icon … opens nothing". The note must name only a menu icon.
- **F6 (low), `test/browser/header-bar.test.ts:95`:** the edges rule and H1's cap are asserted only in the browser
  test; with either removed every unit test passes (its Q2/Q3). Add a unit assertion on `_widthMax` so `npm run check`
  catches a regression.
- **Check and decide:** reviewer 2 listed "a call band with a 96px illustration is now taken as a header" under
  base-also findings but called it a ruling question. Run it on base and head: if head differs from base, it belongs
  to F1/F3's class and must come out as base does; if base is the same, record it in HANDOFF as a follow-up.
- **Wording:** HANDOFF says "each element's CSS names only its own id"; the Section's CSS also names `#brx-header`, as
  the plan approved. Fix the wording.
- **Not in this job (record in HANDOFF follow-ups, don't fix):** a logo component instance filled by a same-size
  picture is no logo; a mark plus its typed name grouped is no logo; a header drawn as two rows in one frame isn't
  recognised; a header drawn without auto layout gets the edges rule via inference.

## Done means
Every valid finding fixed test-first (a failing test before each change), each guard's test proven to fail without it
(review 2's mutants and your own), `npm run check` green, the header-bar browser tests green with `skipped 0`, the full
browser suite compared by test name with base `dea6296` (no new failures), the AC7/AC8 receipts re-run (byte-identity
list unchanged or each change explained; notes pinned per page), the B-Dry paste tests green (rebuild the paste only if
a plugin change alters its inputs, and give the new sha256), ledger and HANDOFF updated, committed. Stop with
`status: ready-for-review`: no merge, no BUILD. AC14 still waits for Justin's sample (check
`/mnt/c/Users/Admin/Downloads/offcanvas-toggle.json`; if it has arrived, say so and don't build it in this round).

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH, the same
profile for base and head. `npm run corpus` measures nothing here; corpus-backed unit tests need scratch `git archive`
trees with `corpus.json` re-pointed (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/
corpus-paths-on-desktop.md`). The worktree guard refuses Bash it can't prove stays in the worktree (shell variables or
loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text,
the word `source` anywhere, even in a path): write scripts with Write and run `node <absolute script> <absolute args>`,
one plain command per call (a plain `bash <script>` in its own call is allowed). Another job (`after-faq-sections`)
is being fixed in its own worktree: leave it alone.

## Rules
- Commit after each passing fix: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check
  `git diff --cached --name-only` (never CLAUDE.md). Don't push, don't bump BUILD, don't edit the worktree's CLAUDE.md,
  never bare `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else` (one line each, evidence, severity); don't fix them.
- Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line proposal for a check
  that would have caught a broken rule). An empty list is normal. Never edit skills or memory.
- Don't start other agents.

## Return (your final message)
`{name, status: ready-for-review|stopped, findings[{id, verdict: fixed|rejected|partly|follow-up, commit, test,
evidence}], rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, last_commit, shots[], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
