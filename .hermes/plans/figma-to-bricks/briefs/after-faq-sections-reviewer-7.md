# REVIEWER, round 7 (delta, report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-7/` (create it).

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach 7496916` and check `git rev-parse HEAD`. Review and run everything there; never write or run
commands in another worktree. If the checkout is refused, stop with the exact message.

## What to review
- Head `7496916` (job branch `worktree-agent-a9620dc83166c651c`; source and tests as of `7393065`). Story base
  `dea6296`. **Your range:** `git diff b583ece..7496916` (fixer 6's `1d59de4` the three classes with tests and
  fixtures, `7393065` two pinning cases and HANDOFF R13, `7496916` ledger) and what those changes touch. Anything else
  outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-6/` (with
  `review-2/justin.json`, `review-4/justin.json` **"Careful rules"** and `review-6/justin.json` **"One more fix, then
  accept"**: this round's fix closes R6-1 to R6-3; if this review still finds new neighbour drawings, they become known
  limits and the job moves on; see `justin-answers.md`). Review 6: R6-1 P2 punctuated typed brand names on a painted
  panel read as a band; R6-2 P2 one-line hours and linked contact words passed; R6-3 P2 rectangle-behind-words cards and
  fields passed `boxed()`. Fixer 6's answer: `typedLogo()` counts only words with a letter or digit and ignores firm
  abbreviations' periods, and a band checks every text; a new `hours()` reader (clock times, day ranges, a day named
  with a number range or "closed") and `tel:`/`mailto:` run links count as contact details outside a band; `boxed()`
  counts a covering layer, and a line flowing under a band's non-title words is a field (flowing layers only). Its
  rulings and known limits (not yet confirmed) are in HANDOFF R13. Its witness receipt: 388 witnesses, 321 identical to
  base, 67 listed positives, 0 unexpected; 124 mutants all killed; AC4's splitting variants are 88 (the earlier "73"
  was a counting artifact). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-6/`; ledger in
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Judge whether R6-1 … R6-3 are really closed, and say
  for each finding you raise whether it is (a) a regression or a broken AC, or (b) a new neighbour drawing of an
  already-known class (Justin will have those recorded as known limits).
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/` didn't change.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for fixer 6's terms (`typedLogo()`'s word count and abbreviations, the every-text band
check and its "@"/seven-digit exemption, `hours()`'s alternatives, the contact-link rule, `boxed()`'s cover, the
flowing-line field test) and earlier rounds' mutants downstream of them. Then read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records").

## What to check in the range
- "Uncertain = base": every footer shape not on the allow-list must equal base byte for byte (payload and notes), and
  every allow-listed shape must still split as AC1 says. Probe fixer 6's new readers on both sides: brand names with
  "&", "+", "·", abbreviations, "Co" vs "Co.", one-word vs three-word names; hours as one text, one line per day, a day
  range, "24/7", "closed", a card that merely names a day; contact words linked to mailto:/tel: inside and outside a
  band (use a non-sample address); cards and fields drawn as a rectangle, a picture or an underline behind or under
  words, filled or outlined; AC1's badge placed over a band's edge. Three trees: base, `b583ece`, head, with your
  expected positives listed first.
- The five real files stay byte-identical to base; `opening-hours.ts` only exports `DAY` (its behaviour unchanged).
- The architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest (124, all killed; `"spacer"` removed as unreachable)?

## Records and report
- Also say (as P3 at most) what the plan's AC1, AC3 and AC4 lines must say to match their tests now (fixer 6: AC1 and
  AC3 unchanged; AC4's splitting variants are 88 and its receipt is `fixer-6/scripts/base-vs-head.ts`), so the main
  session can have the plan amended before the verifier.
- Write `review-7/review.json` exactly as review-loop.md "Records" says: `round: 7`, `scope: "delta"`, `from` = the full
  sha of `b583ece`, `head` = the full sha of `7496916`, findings `R7-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check from your own worktree, one plain command:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <dea6296
  full sha> ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections`. Exit 2 means your file is wrong: fix it.
  Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-reviewer-7/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-reviewer-7/`. The worktree guard refuses Bash it
can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`,
the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with
Write and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review
in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
