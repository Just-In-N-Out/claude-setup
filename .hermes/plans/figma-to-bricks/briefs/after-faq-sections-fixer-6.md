# Brief: FIXER 6 for figma-to-bricks feature "after-faq-sections" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 3 P0-P2 finding(s) in review-6 at b583ece` (after Justin answered the brake). Verify each
finding first, fix the valid ones test-first, and stop `ready-for-next-review`. Don't re-plan and don't widen the job.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296, on its own branch
`worktree-agent-<your id>`). The job's head is `b583ece` on branch `worktree-agent-ad5fa682a0c219e7f` (never write or
run commands in another worktree). In **your own** worktree run `git merge --ff-only b583ece` and check
`git rev-parse HEAD`. Work and commit there, and leave the worktree in place when you finish. If CLAUDE.md or
node_modules is missing, copy them from the main folder (`cp /home/justin/Documents/FigmaToBricksV2/CLAUDE.md <your
worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`; never stage CLAUDE.md). If
any of this is refused, stop with the exact message.

## Justin's decisions in force
- **"Careful rules"** (`review-4/justin.json`): split a footer frame only where it's unambiguous which parts are the
  page's; everything uncertain converts exactly as base `dea6296`. Fixer 5's allow-list (`footer-part.ts`) is the
  shape of that rule: keep it, and close its blind spots.
- **"One more fix, then accept"** (`review-6/justin.json`, `justin-answers.md`): this round closes R6-1 to R6-3. If
  round 7 still finds new neighbour drawings, they become known limits and the job moves on. So close these three
  **as classes** (every drawing of each), not just the witnesses, and keep the rest of the allow-list as it is.

## The referee's lines (verbatim)
```
R6-1  P2  src/core/understand/footer-part.ts:58  Fix 5's typed-logo test (a title of at most two whitespace-separated words not ending in ? . or !) is narrower than the brand names designers type, and the band branch asks it only of its biggest words (line 74), so the footer's own brand block on a painted panel still reads as a call-to-action band and is kept: 'Smith & Sons' (the ampersand counts as a third word), 'Example Co.' and 'Acme Inc.' (an abbreviation's period reads as a sentence's), and a typed name set smaller than a tagline under it ('Example Co' 18 over a 28px line). Each splits, byte-identical to d74a834, alone above the columns or under a CTA band, in auto layout, free-drawn and with both ticks (review-6/probe-witnesses-final.log: U01, U02, U03, U04, U23, U24, V01, V08); controls equal base: 'Example Co' (V10, fixer 5's typedPanel shape), 'J&R Plumbing' (V02), the panel unpainted (U20, V09), a monogram card in it (U13), free-drawn with a badge across it (V16, V17). HANDOFF R13's 'Fix 5's changes (before: kept, now whole as on base): the footer's brand block ... the logo drawn, typed ...' holds only for a plain two-word name, and the declared limit names only three-word logos. Fix direction: read every text of a band for a typed logo, not only its title; count words without symbol tokens (&, +, |) and let a trailing abbreviation (Co., Inc., Ltd.) still count as a logo; probe each name above, painted and unpainted, band above or not, auto layout and free-drawn  (repeats R5-1)
R6-2  P2  src/core/understand/footer-part.ts:71  The cards' refusals rest on recognizers that miss common footer drawings. openingHours() needs two or more schedule lines in one text, so hours cards whose day and time are separate one-line texts ('Monday to Friday' over '8am to 5pm', V05) or one line each ('Monday to Friday 8am to 5pm', U21) are kept as the page's cards under a three-word heading. Contact cards whose words are Figma text links to mailto:/tel: with no number or address shown ('Email us', 'Call us': U07, free-drawn U08) pass because CONTACT (line 94) exempts tel:/mailto: run links in every part, not only a band's, while contactsIn() (line 78) reads only the words. Each splits, byte-identical to d74a834 (review-6/probe-witnesses-final.log); controls equal base: a two-line hours text (V06), contact cards with an icon picture (V04), fixer 5's contact cards with an address. HANDOFF R13's 'Never in a kept part: ... an address or opening hours; a phone number or email outside a band' and 'contact or town cards (before: kept, now whole as on base)' are not what the code does for these. Fix direction: count a tel:/mailto: run link outside a band as a contact detail (exempt only inside a band), and refuse a card whose texts name a weekday and a time across its lines (read a card's texts together, or any one line holding a day range or a clock time)  (repeats R5-1)
R6-3  P2  src/core/understand/footer-part.ts:47  A band's 'no card' refusal (line 74; fixer 5's cardBand test) misses boxes painted by a rectangle drawn behind their words: boxed() reads only a box's own fills and stroke, while painted() (line 60) also counts a covering shape, and a frame drawn without auto layout holding a rectangle and its words becomes an unfilled box whose rectangle is its cover (review-6/scripts/ir-dump.ts V03: 'box fills=0' over 'shape cover'). So the fixer's own refused shape, a painted band holding two cards and a pill, is kept when its cards are drawn that way (filled V13, outlined V14), and so is a newsletter band whose email field is a rectangle behind its placeholder (V03) or an underline (a placeholder over a 1px line, read as a divider: U06, and alone above the columns with no CTA band, V12). Each splits, byte-identical to d74a834 (review-6/probe-witnesses-final.log); control: the newsletter with an auto-layout white field box equals base (U05). Fix direction: let boxed() count a cover child as painted() does (and probe cards drawn as a rectangle behind their words in the cards branch too), and refuse a band holding a form field (words at the left of a box, or over a line)
R6-4  P3  src/core/understand/footer-part.ts:30  Mutation receipts: fixer 5's 70 mutants check out (each exit 1 with exactly one match applied, control exit 0, each kill line names a frame of its own class; W1 by 'CTA / columns / back to top / bar', W5 by the wave notes: fixer-5/mutants-final.txt, mutants-applied-final.log, mutants-final-kills.txt). Six more terms survive the whole unit suite (2585 tests, 0 fail, the mutant applied in all 177 test processes: review-6/mutants-r6full.txt): M1 adds 'vector' to PAGE_ROLES (widening: review cards with star vectors and a brand panel with a vector logo then split, review-6/mutant-reach.log; HANDOFF R13's 'a logo drawn any size or way' rests on this unpinned member), M3 drops mailto: from CONTACT (every fixture email is at example.com, which the plugin never links), M5 and M6 drop the '.' or '!' of the typed-logo test ('Acme Inc.' and 'Call now!' change outcome), M8 and M10 drop 'divider' and 'spacer' from PAGE_ROLES (a band with a rule under its title goes base under M8)
R6-5  P3  ~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md:346  Plan lines against their tests at b583ece: AC1's and AC3's tests are unchanged in d74a834..b583ece (understand-footer-stack.test.ts:22 and :104; AC1's CTA / columns / rule case still pins 'Columns', 237px) and pass on head (review-6/check.log), so their lines stand as amended. AC4's line must say the splitting variants are 73 (at 3f15403, unchanged at b583ece; fixer 5's script re-run in its ONLY_VARIANTS mode over this reviewer's own base and head trees also counts 73: review-6/ac4-variants.log), not '31 at 7a0bfe1', and name `<E>/fixer-5/scripts/base-vs-head.ts`, not fixer 2's copy; the rest holds: the five real files at four ticks cmp-equal (review-6/replays-cmp.log, 40 of 40) and the 69 base fixture exports equal (review-6/ac4-variants.log)  (repeats R5-4)
REVIEW AGAIN: 3 P0-P2 finding(s) in review-6 at b583ece: fix them, then review the fix commits
```

## What to do
- **R6-1 (P2):** the typed-logo test must not be fooled by punctuation or placement: "&" is not a word, a trailing
  period of "Co."/"Inc."/"Ltd." is not a sentence end, and a small typed name over a larger tagline is a brand panel
  too (ask it of every text in a band, not only the biggest). Witnesses: "Smith & Sons", "Acme Inc.", "Example Co.",
  a small typed name over a 28px tagline, alone and under a band, auto layout and free-drawn, both ticks; controls
  "Example Co", "J&R Plumbing", the panel unpainted. When in doubt, refuse the split (base).
- **R6-2 (P2):** opening hours drawn as one-line texts (a day line over a time line, or one text per line) must be
  read as hours; contact words linked to `mailto:`/`tel:` ("Email us", "Call us") with no number shown must be treated
  as contact details outside a band. Exempt `tel:`/`mailto:` run links only inside a band, as HANDOFF R13 says.
- **R6-3 (P2):** a card or field drawn as a rectangle behind words (a frame without auto layout whose rectangle becomes
  the unfilled box's cover), filled or outlined, and a field drawn as an underline (a 1px line read as a divider) must
  count as boxes, the same way `painted()` counts a cover: a band holding such cards refuses the split, and a
  newsletter band with such a field is not a call-to-action band. Control: a white auto-layout field box equals base.
- **R6-4 (P3):** kill review 6's surviving mutants M1 (a "vector" in PAGE_ROLES), M3 (mailto: dropped: use a
  non-sample address, not example.com, which the plugin never links), M5/M6 ("." / "!" dropped from the typed-logo
  test), M8/M10 (divider/spacer dropped from PAGE_ROLES), with tests.
- **R6-5 (P3):** none for you: the main session has the plan's AC4 line amended (73 variants, your receipt path) after
  the next clean review. Report your final count.
- **The witness receipt:** extend fixer 5's (199 witnesses) with review 6's (`review-6/expected.txt`,
  `probe-witnesses-final.log`, scripts). Write your expected positives with each one's expected outcome to
  `fixer-6/expected-positives.txt` before the run (keep v1 if you must revise it, with a reason per changed id, and
  convert every witness with `b583ece` too). Zero UNEXPECTED is the bar.

## Where
- Review records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/` … `review-5/` (with the two
  `justin.json`). Earlier fixers: `fixer-1/` … `fixer-4/` (fixer 4's `scripts/base-vs-head.ts`, its witnesses and
  mutants). Approved plan (read only, amended): `plan-approved.md` beside them. Ledger
  `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`. Build probe fixtures inside a function called after
  `resetIds()`; test linked icons with small `image()` layers (vector icons merge).
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-6/`.

## Done means
R6-1 to R6-3 closed as classes, test-first; R6-4's mutants killed; the witness receipt at zero UNEXPECTED; every guard
you keep has a test that fails without it. `npm run check` green (in a scratch tree, archive the whole commit; run tsc
as `node node_modules/typescript/bin/tsc --noEmit -p .` and with `-p tsconfig.sandbox.json`); the footer-stack browser
tests green with `skipped 0`; the full browser suite by test name against a **built** base (no new failures); the AC4
receipt re-run (five real files × four tick settings byte-identical; only the splitting variants differ, and each
does); the v4 paste tests green (bounded runs) with the paste files unchanged. Don't edit source while a gate runs.
Fold your records into your fix commits (HANDOFF R13 must say what the code does). If a plan AC line can't hold, stop
and say which: don't rewrite an AC. Stop with `status: ready-for-next-review`: no merge, no BUILD. Report your
worktree, branch and last commit.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its "Widening a recognizer
   carefully" line and the footer-split pitfall line) and `references/rules-summary.md`; `references/testing-pitfalls.md`
   before any receipt, mutation run or browser measurement.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-fixer-6/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-fixer-6/`. `npm run corpus` measures nothing
here; corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). The worktree guard
refuses Bash it can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then
node, `git -C`, the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path):
write scripts with Write and run them as one plain command. Never commit in the same batch of tool calls as the gate
it depends on. Waits: poll in chunks under 170 s. Another job (`header-bar`) is being fixed in its own worktree: leave
it alone.

## Rules
- Plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check `git diff --cached --name-only`
  (never CLAUDE.md). Don't push, don't bump BUILD, never bare `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else`; don't fix them. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (normally
  empty). Never edit skills or memory. Don't start other agents.

## Return (your final message)
`{name, status: ready-for-next-review|stopped, worktree, branch, last_commit, findings[{id, verdict:
fixed|rejected|removed|partly, commit, test, evidence}], witness_receipt{expected_positives, base_identical, positives,
unexpected}, rulings[], ac_tests_now_assert{AC1, AC3, AC4}, ac_status[{ac, accepted, test, evidence}], paste_sha256,
shots[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
