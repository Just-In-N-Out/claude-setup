# REVIEWER, round 4 (delta, report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-4/` (create it).

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach 6a3a2f4` and check `git rev-parse HEAD`. Review and run everything there; never write or run
commands in another worktree. If the checkout is refused, stop with the exact message.

## What to review
- Head `6a3a2f4` (job branch `worktree-agent-a086b9929f80d4e5a`). Story base `dea6296`. **Your range:**
  `git diff ca26c83..6a3a2f4` (fixer 3's commits `f60668c` a test moved unchanged, `052d8c3` R3-2's test, `9765fc0`
  R3-1's fix, `6a3a2f4` records) and what those changes touch. Anything else outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/`, `review-2/` (with
  `justin.json`: Justin chose "Keep going on both") and `review-3/` (R3-1 P1: a footer frame whose links part is a logo
  plus a one-row menu, or link columns under a big heading, above a © bar was split, keeping the links part on the page;
  R3-2 P3: an untested widening of R11). Fixer 3's answers: R3-1 fixed in `9765fc0` (`siteFooter` reports `bare` when it
  finds a © bar alone and exports `footerLinks` and `titled`; over a bare bar the footer starts at the nearest part above
  holding links; a links part right above the footer's own part joins it unless it has a section heading; a bar holding
  the frame's only links leaves alone under a page part), with 17 no-page-part frames pinned at base's outcome and 16
  call-to-action band variants; its ruling R12 (not yet confirmed): when the parts can't say where the frame's links
  are, the whole frame leaves as on base; R3-2 fixed in `052d8c3`. Its evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-3/`; ledger entries in
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Judge whether each fix really closes its finding.
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/` didn't change in this range.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (`bare`, the jump from a bare bar to the nearest links part, the
step up over a links part, the heading exclusion, the "bar holds the only links" rule, R12). Then read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records").

## What to check in the range
- The new footer-start rules against every shape the whole-frame `siteFooter` accepts: columns, a menu row, a
  titled part (a heading ≥ 1.6× body), legal links in the © bar, pills, an address line, links split across two parts,
  a wordmark or spacer, a 1px rule, a CTA band above, both ticks, a drawn phone pair, free-drawn frames. Compare every
  probe with base's whole-frame answer and with `ca26c83` (three trees). Probe each threshold on both sides (3 menu words
  vs 2, the 1.6× heading, `BAR_MAX`). Does the fix lose anything rounds 1–3 fixed, or anything base did right? Does
  `siteFooter`'s new `bare`/export change any page without a stacked footer (it runs on every page: the five real
  files must stay byte-identical)?
- The architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest? The plan amendment: do the amended AC lines say what
  the tests assert?

## Records and report
- Also say (as P3 at most) whether the amended plan's AC1/AC3 lines still say what their tests now assert, so the main
  session knows whether a plan amendment is needed before the verifier.
- Write `review-4/review.json` exactly as review-loop.md "Records" says: `round: 4`, `scope: "delta"`, `from` = the full
  sha of `ca26c83`, `head` = the full sha of `6a3a2f4`, findings `R4-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check from your own worktree, one plain command:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <dea6296
  full sha> ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections`. Exit 2 means your file is wrong: fix it.
  Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-reviewer-4/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-reviewer-4/`. The worktree guard refuses Bash it
can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`,
the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with
Write and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review
in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
