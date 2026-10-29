# Brief: FIXER 2 for figma-to-bricks feature "after-faq-sections" (Full pipeline)

You are a fresh fixer. Act on reviewer 2's findings: verify each one first, fix the valid ones test-first, and push
back with evidence on any that are wrong. Don't re-plan and don't widen the job.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296, on its own branch
`worktree-agent-<your id>`). The job's head is `8fa172b` on branch `worktree-agent-adabc0bcca521dc41` (fixer 1's
worktree: never write or run commands there). In **your own** worktree run `git merge --ff-only 8fa172b` and check
`git rev-parse HEAD`. Work and commit there, on your own branch, and leave the worktree in place when you finish. If
CLAUDE.md or node_modules is missing, copy them from the main folder (`cp /home/justin/Documents/FigmaToBricksV2/
CLAUDE.md <your worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`; never stage
CLAUDE.md). If any of this is refused, stop at once with the exact message.

## Where
- Reviewer 2's report: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/reviewer-2/review.json` (read it
  whole), with `probe-variants.log`, `probe-variants-2.log`, `probe-paint.log`, `probe-gap.log`, `probe-badge.log`,
  `mutants.txt`, `fix-probe.log` and `scripts/`. Reuse its probe fixtures and its tried guard rather than retyping.
- Earlier rounds: `reviewer-1/review.json`, `fixer-1/` beside it. Approved plan (read-only) `plan-approved.md` and
  `ac7-amendment-approved.md` in `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/`. Ledger
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. The B-Dry paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/`.
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-2/`.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
   `references/rules-summary.md`; read `references/testing-pitfalls.md` before any receipt, mutation run or browser
   measurement; only the CLAUDE.md sections you need (grep + offset/limit).
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## The findings (reviewer 2, verdict request-changes)
- **R2-F1 (high), `footer-stack.ts:172-184`:** `splitFooterStack` decides with one `siteFooter` call, then merges the
  wordless parts above the footer into one tail view and writes the note; `leaveOut` calls `siteFooter` again on the
  reshaped list and the two disagree. `siteFooter`'s thin-bar path counts the columns only directly above the © bar,
  so a wordless part between them (a big wordmark drawing, an empty spacer) makes the first call find only the bar and
  the columns become a "kept part"; merged into the tail, the bar grows past `BAR_MAX` (200px) and `leaveOut` finds no
  footer. Ticked, the whole footer goes into the paste with a false `Kept "Columns"` note and "footer wasn't left out".
  Base left these frames out whole. Reviewer's fix (tried in `fix-probe.log`; 35 related unit tests and 4 browser tests
  pass, all 8 variants return to base): keep the split and write the note only when `footerOf(final)` finds exactly
  the tail, else return `entries`; better, if that check finds the footer starting at a kept part, move `from` up to it
  and check again (the CTA stays, the columns go with the footer). Failing tests first, from its probe variants.
- **R2-F2 (medium), same cause:** on the common shape (columns, a 1px divider, a © row, no page part) the paste equals
  base, but the notes say `Kept "Columns"…` and `Left out the footer ("Columns", …)`; with a CTA above, the note names
  Columns as kept too. The R2-F1 guard should fix it: pin the exact notes.
- **R2-F3 (low), `footer-stack.ts:87-96` `viewOf` and `section.ts:164-165`:** a view spreads `...frame`, keeping the
  frame's fills, and `sectionIR` puts `behind` (the same fills) under them, so a see-through frame paint is painted
  twice (the strip above the band is darker). The view also copies the frame's opacity, notes (a `pulse` annotation),
  video and scroll setting. Fix: `viewOf` sets `fills: []` and clears those properties, with a test for each.
- **R2-F4 (low):** `gapped()`'s `i > 0` path (line 128) and the `reach` hand-over (164-165) are never reached (mutants
  MA, MD survived). MA off is visible: a 40px gap between two painted parts shows the page colour as a stripe. Add
  tests that reach both and kill MA and MD.
- **R2-F5 (low), `section.ts:165`:** a footer frame narrower than the page (a rounded footer card with side margins)
  splits, and its kept parts' sections paint the frame colour edge to edge, losing the white margins and rounded
  corners. **Ruling to apply:** treat a frame narrower than the page as no stack (base's outcome), unless keeping the
  card's width and radius is a small change you can test fully; record which as "My ruling, not yet confirmed".
- **Ruling to apply (Justin said "go with whatever suggested"):** reviewer 2 showed the frame's held top padding
  (`topHeld()`) counts toward the page's section space S, so whether the footer's first part is painted changes the
  spacing of the white sections above it (fixer 1's pinned case gets S = 48 only because of it). Exclude the held
  padding from the S count, test-first, and fix HANDOFF's wording ("three kept parts draw 48 under their words").
  Record it as "My ruling, not yet confirmed".
- **Not in this job (HANDOFF follow-ups, don't build):** a © text as a narrow child under the columns makes the frame
  no stack (a CTA above is still dropped); a gradient on the footer frame restarts in each kept part's section; a
  footer frame holding a form part above its links stays whole (as the plan says).

## Done means
Every valid finding fixed test-first, each guard's test proven to fail without it (reviewer 2's surviving mutants
killed), `npm run check` green, the footer-stack browser tests green with `skipped 0`, the full browser suite compared
by test name with base `dea6296` (no new failures), the AC4 receipt re-run (five real files × four tick settings still
byte-identical; the fixture list unchanged or each change explained), the v4 paste tests green (bound every run; the
harness's `open()` can hang), the paste files unchanged unless a finding needs it (then new hashes), ledger and HANDOFF
updated, committed. Stop with `status: ready-for-review`: no merge, no BUILD. Report your worktree, branch and last
commit.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH, the same
profile for base and head. `npm run corpus` measures nothing here; corpus-backed unit tests need scratch `git archive`
trees with `corpus.json` re-pointed (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/
corpus-paths-on-desktop.md`). The worktree guard refuses Bash it can't prove stays in your worktree (shell variables or
loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text,
the word `source` anywhere, even in a path): write scripts with Write and run `node <absolute script> <absolute args>`,
one plain command per call (a plain `bash <script>` in its own call is allowed). Another job (`header-bar`) is being
fixed in its own worktree: leave it alone.

## Rules
- Commit after each passing fix: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check
  `git diff --cached --name-only` (never CLAUDE.md). Don't push, don't bump BUILD, don't edit CLAUDE.md, never bare
  `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else` (one line each, evidence, severity); don't fix them.
- Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line proposal for a check
  that would have caught a broken rule). An empty list is normal. Never edit skills or memory.
- Don't start other agents.

## Return (your final message)
`{name, status: ready-for-review|stopped, worktree, branch, last_commit, findings[{id, verdict: fixed|rejected|partly|
follow-up, commit, test, evidence}], rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, shots[],
found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
