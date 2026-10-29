# REVIEWER, round 3 (delta, report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-3/` (create it).

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach ca26c83` and check `git rev-parse HEAD`. Review and run everything there; never write or run
commands in another worktree. If the checkout is refused, stop with the exact message.

## What to review
- Head `ca26c83` (job branch `worktree-agent-ae26414264555729c`). Story base `dea6296`. **Your range:**
  `git diff 8fa172b..ca26c83` (fixer 2's commits `531baff` … `529e990`, records `7a0bfe1`, and plan amendment 1
  `ca26c83`) and what those changes touch. Anything else you notice outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/review.json` and
  `review-2/review.json` (with `review-2/justin.json`: Justin chose "Keep going on both"). Fixer 2's answers to round
  2: R2-1 (P1) and R2-2 (P2) fixed in `531baff` (the split stands only when `siteFooter`, run on the final list as
  `leaveOut` runs it, finds exactly the part left out; if it finds the footer starting at a kept part, the left-out
  part starts there); R2-3 partly fixed in `4510929`/`19d2f17` (a view carries no fills, opacity 1, no notes, no
  scrolling; the fixer pushed back on clearing `video`, saying a frame's own video is always null after normalise);
  R2-4 fixed in `35ab2aa`/`3bc3978` (tests reach both branches; the `reach.bottom` hand-over removed; a `held` index bug
  from `bands.map(entry)` found and fixed); R2-5 fixed in `c5bae14` (a footer frame narrower than the page is no
  stack); ruling R11 (`SectionInfo.held` left out of the page's section space in `rhythm.ts` `pageSpace`). Its evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-2/`; its ledger entries in
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Judge whether each fix really closes its finding, and
  judge the `video` pushback.
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/` didn't change in this range (the AC7 test
  was amended earlier).

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (the final `siteFooter` check, `viewOf`'s cleared properties,
`held`, the narrow-frame rule, `pageSpace`'s exclusion). Then read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records").

## What to check in the range
- The final `siteFooter` re-check against every footer shape that reaches it: columns with a 1px rule, a wordmark or a
  spacer of 120–240px, a © inside the last part, a CTA band above, a drawn phone pair, both ticks, free-drawn frames;
  probe `BAR_MAX` (200px) and the thin-bar look-back on both sides. Does the fix lose anything rounds 1–2 fixed, or
  anything base did right?
- `rhythm.ts` `pageSpace` excluding `held`: pages without a stacked footer must stay byte-identical (it reads every
  section).
- The architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest? The plan amendment: do the amended AC lines say what
  the tests assert?

## Records and report
- Write `review-3/review.json` exactly as review-loop.md "Records" says: `round: 3`, `scope: "delta"`, `from` = the full
  sha of `8fa172b`, `head` = the full sha of `ca26c83`, findings `R3-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check from your own worktree, one plain command:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <dea6296
  full sha> ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections`. Exit 2 means your file is wrong: fix it.
  Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-reviewer-3/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-reviewer-3/`. The worktree guard refuses Bash it
can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`,
the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with
Write and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review
in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
