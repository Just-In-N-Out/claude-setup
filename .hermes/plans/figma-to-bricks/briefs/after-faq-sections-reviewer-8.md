# REVIEWER, round 8 (delta, records only, report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-8/` (create it).

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach 974c4a6` and check `git rev-parse HEAD`. Review and run everything there; never write or run
commands in another worktree. If the checkout is refused, stop with the exact message.

## What to review
- Head `974c4a6` (job branch `worktree-agent-a3f78512a3c169997`), one records-only commit on top of `7496916`, which
  review 7 cleared (MOVE ON, with Justin accepting R7-1 and R7-2 as known limits). Story base `dea6296`. **Your range:**
  `git diff 7496916..974c4a6`: the plan (`docs/plans/2026-10-29-after-faq-sections.md`, amendment 2: AC4's line now
  says 349 variants, 88 splitting, receipt `fixer-6/scripts/base-vs-head.ts`), `docs/HANDOFF.md` (this job's section:
  the accepted known limits, review 7's follow-ups, R13 wording) and the ledger moved to
  `docs/plans/2026-10-29-after-faq-sections-ledger.md`. **No source or test may change in this range: check that
  first.**
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-7/`
  (with their `justin.json`), `justin-answers.md`, `follow-ups.md`. The approved plan is now amendment 2:
  `plan-approved.md` (the old copies are beside it as `plan-approved-v1-…` and `plan-approved-v2-…`).

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
and nothing else for this records-only round. Then read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records").

## What to check in the range
- The range is records only (`git diff --stat 7496916..974c4a6` shows no `src/` or `test/` file) and the tree is clean.
- Amendment 2 follows ac-verification.md lines 21–23: AC ids, the live set and every test-name line unchanged (run
  `ac-check.sh`'s regexes on `plan-approved-v2-…` and `plan-approved.md`); no Amendments line starts with an AC id; AC4's
  line says what `fixer-6/scripts/base-vs-head.ts` asserts (run it if cheap: 349 variants, 88 splitting, ok 1).
- HANDOFF says what the code does (R13, the known limits, the follow-ups), touches only this job's section and replaces
  no other section's `## ` heading; the ledger move is a pure rename plus a closing note.

## Records and report
- Write `review-8/review.json` exactly as review-loop.md "Records" says: `round: 8`, `scope: "delta"`, `from` = the full
  sha of `7496916`, `head` = the full sha of `974c4a6`, findings `R8-1`… on Justin's P0–P3 scale (a records slip that
  misstates behaviour is P3; a source or test change in this range would be P1); every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check from your own worktree, one plain command:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <dea6296
  full sha> ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections`. Exit 2 means your file is wrong: fix it.
  Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-reviewer-8/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-reviewer-8/`. The worktree guard refuses Bash it
can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`,
the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with
Write and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review
in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
