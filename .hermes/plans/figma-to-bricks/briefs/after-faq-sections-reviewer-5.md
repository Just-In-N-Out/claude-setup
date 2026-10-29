# REVIEWER, round 5 (delta, report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-5/` (create it).

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach d74a834` and check `git rev-parse HEAD`. Review and run everything there; never write or run
commands in another worktree. If the checkout is refused, stop with the exact message.

## What to review
- Head `d74a834` (job branch `worktree-agent-a8fa99f98acc26345`). Story base `dea6296`. **Your range:**
  `git diff 6a3a2f4..d74a834` (fixer 4's commits `c3c3d5b` the careful rule in new `src/core/understand/footer-part.ts`,
  `7de0e70` a test for every guard term, `1e21ecd` a drawn-logo row counts as the footer's brand row plus records,
  `d74a834` ledger only) and what those changes touch. Anything else outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-4/` (with
  `review-2/justin.json` "Keep going on both" and `review-4/justin.json`: Justin chose **"Careful rules"**: split a
  footer frame only where the footer's links part is unambiguous; everything uncertain converts exactly as base
  `dea6296`). Review 4: R4-1 P1 titled columns / typed-logo menu rows still split; R4-2 P2 linked card rows read as the
  footer's links; R4-3 P2 a pill band judged two ways; R4-4 P3 the plan's AC3/AC4 lines no longer match the tests.
  Fixer 4's answer: the footer's own part is the © part plus the part right above it if that part holds only the site's
  links, plus wordless parts at their edges; every part above must hold nothing read as links, not start with a drawn
  logo, and hold no link or click but a Button's; the part right above the footer's own part must hold a Button or a
  card; the final `siteFooter` check stays; round 3's step-up, `nearest()`, `headed()` and `bare` are gone. Its rulings
  R13 (not yet confirmed) are in HANDOFF; note one **changed outcome**: a band over columns cut off from the © bar by a
  tall wordless part (round 2's wordmark 180/240 and spacer 160 frames) now splits with the band kept, where it used to
  leave whole. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-4/`; ledger entries in
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Judge whether R4-1 … R4-3 are really closed and whether
  the careful rule really is "base where uncertain".
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/` didn't change in this range.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (every term of `footer-part.ts`, `logoFirst()`, `closing()`, the
final `siteFooter` check). Then read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records").

## What to check in the range
- "Uncertain = base": for every footer shape that isn't plainly a page part over the footer's own links (titled
  columns, typed-logo or drawn-logo rows, social rows, linked cards, pills, trust strips, town cards, links split across
  parts, an address line, two links parts, a brand row with a pill, client logos, wordmarks and spacers, a 1px rule,
  both ticks, a drawn phone pair, free-drawn frames), head must equal base byte for byte (payload and notes). Build your
  own witnesses beyond the reviewers' and fixer 4's (three trees: base, `6a3a2f4`, head), and list the clear positives
  by id before you run them. Judge the changed outcome (wordmark/spacer frames now split) against the careful rule.
- AC1's listed positives still split exactly as before (fixer 4 says byte-identical to `6a3a2f4`); the five real files
  stay byte-identical to base (`closing()` now runs inside `siteFooter` on every page).
- The architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest (33 mutants, F6 killed on the second run)?

## Records and report
- Also say (as P3 at most) what the plan's AC1, AC3 and AC4 lines must say to match their tests now (fixer 4: AC3's test
  asserts exactly its plan line's frames; AC4's splitting variants are 67, not "31 at 7a0bfe1"), so the main session
  can have the plan amended before the verifier.
- Write `review-5/review.json` exactly as review-loop.md "Records" says: `round: 5`, `scope: "delta"`, `from` = the full
  sha of `6a3a2f4`, `head` = the full sha of `d74a834`, findings `R5-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check from your own worktree, one plain command:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <dea6296
  full sha> ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections`. Exit 2 means your file is wrong: fix it.
  Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-reviewer-5/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-reviewer-5/`. The worktree guard refuses Bash it
can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`,
the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with
Write and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review
in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
