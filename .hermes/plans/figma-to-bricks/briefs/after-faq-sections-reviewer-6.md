# REVIEWER, round 6 (delta, report only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-6/` (create it).

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). In **your own** worktree
run `git checkout --detach b583ece` and check `git rev-parse HEAD`. Review and run everything there; never write or run
commands in another worktree. If the checkout is refused, stop with the exact message.

## What to review
- Head `b583ece` (job branch `worktree-agent-ad5fa682a0c219e7f`; source and tests as of `3f15403`). Story base
  `dea6296`. **Your range:** `git diff d74a834..b583ece` (fixer 5's `cd2e19e` the allow-list with its tests and
  HANDOFF, `8ee6947` one witness per condition, `651b1b6` a dead guard dropped, `3f15403` witnesses for three surviving
  mutants, `b583ece` ledger) and what those changes touch. Anything else outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-5/` (with
  `review-2/justin.json` "Keep going on both" and `review-4/justin.json` **"Careful rules"**: split a footer frame only
  where it's unambiguous which parts are the page's; everything uncertain converts exactly as base `dea6296`). Review
  5: R5-1 P1 the footer's own brand blocks, info cards, icon circles and client logos split as page parts; R5-2 to R5-4
  P3. Fixer 5's answer: an **allow-list** in `src/core/understand/footer-part.ts`: a part above the footer's own part is
  the page's only as a call-to-action band (painted, Buttons under a title ≥ 1.25× its other words, no card, the title
  not a typed logo), steps (a title over 2+ lines), a heading alone right above cards or steps, or cards (every word in
  a painted or outlined box, no Button, under such a heading); the last kept part must be a band or cards; any picture,
  the site's links, a non-Button link (except `tel:`/`mailto:`), an address or hours, or a phone/email outside a band
  refuses the split. `logoFirst()` is removed (site-header.ts byte-identical to base again). It used 1.25 rather than
  review 5's 1.6 because 1.6 loses AC1's own band and the phone design's heading. Its rulings (not yet confirmed) are in
  HANDOFF R13. Its witness receipt: v1 31 ids, v2 28 ids with a reason per change; final 199 witnesses, 171 identical
  to base, 28 positives, 0 unexpected (`fixer-5/`). Evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-5/`; ledger "Fix pass 5" in
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Judge whether R5-1 … R5-3 are really closed and whether
  the allow-list really is "base where uncertain": build your own witnesses (three trees: base, `d74a834`, head), listing
  your expected positives with their expected outcome first.
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/` didn't change.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the allow-list's terms (every shape and every refusal in `footer-part.ts`, the
1.25 ratio, the typed-logo test, "the last kept part must be a band or cards", the free-drawn band-by-band reading),
and earlier rounds' mutants downstream of them. Then read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records").

## What to check in the range
- "Uncertain = base": every footer shape not on the allow-list must equal base byte for byte (payload and notes):
  brand blocks in every arrangement, logos, icon rows, client logos, contact/town/review cards with icons or avatars,
  addresses, hours, linked words, a band with its Button beside its title, an unpainted band, a photo band, a typed logo
  of 3+ words on a painted panel (fixer 5's known limit: judge it), drawn phone pairs, free-drawn frames with a layer
  across two parts, both ticks. And every allow-listed shape must still split as AC1 says (fixer 5 says AC1's frames are
  unchanged). Probe the 1.25 ratio and each count on both sides.
- The five real files stay byte-identical to base (`site-header.ts` is base again; `footer-part.ts` runs only on a
  stacked footer).
- The architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest (70 mutants, all killed on `3f15403`; two guards dropped
  rather than kept untested)?

## Records and report
- Also say (as P3 at most) what the plan's AC1, AC3 and AC4 lines must say to match their tests now (fixer 5: AC1 and
  AC3 unchanged; AC4's splitting variants are 73 and its receipt is `fixer-5/scripts/base-vs-head.ts`), so the main
  session can have the plan amended before the verifier.
- Write `review-6/review.json` exactly as review-loop.md "Records" says: `round: 6`, `scope: "delta"`, `from` = the full
  sha of `d74a834`, `head` = the full sha of `b583ece`, findings `R6-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check from your own worktree, one plain command:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <dea6296
  full sha> ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections`. Exit 2 means your file is wrong: fix it.
  Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-reviewer-6/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-reviewer-6/`. The worktree guard refuses Bash it
can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`,
the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with
Write and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review
in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
