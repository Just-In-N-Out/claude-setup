# Role: fixer (round 3, small: stale "unchanged" sums after stacking): site-slider

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). One unit test of this job fails since the job was stacked
on two other jobs; fix it without weakening what it proves, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase,
leave other worktrees alone, start no agents. Never load any live site; no logins; never write to any WordPress site.

**Skills to load:** `receiving-code-review` (verify the finding first), `engineering-best-practices`,
`test-driven-development`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-slider-stack1-fix3 fb3512912b59ed664de2657ded4ef3e2fde35496` (the head of `site-slider-stack1`),
confirm `git rev-parse HEAD` and a clean status. The stack is
`main 3cfc54ac ← site-faq-stack1 143a4e19 ← site-reviews-stack1 dec9452cbf28b25709d44e829b86bc0c7e91837e ← site-slider-stack1`.

## The finding (the stack finisher's, `evidence/site-slider/stack-1/unchanged-probe/`)
`test/unit/site-slider-unchanged.test.ts` "pastes without an Elementor slider are byte-identical" (this job's AC8)
misses 12 of 84 comparisons on the stacked head: the saved `code-page` in all 8 variants and the saved
`elementor-slider` in its 4 code-method variants. Its committed sums (`site.code-page.sha256.json`,
`site.elementor-slider.sha256.json`) are the **old** main's output, notes included; site-reviews, now underneath,
rewords the copied-elements note by design. The finisher's probe: main and site-faq match all 28 sums; site-reviews'
head and this head miss the same 12, and the only differing line in each is that note; site-reviews' head against this
head is 28 of 28 byte-identical. So this job still changes none of those pastes; only the sums are stale.

## Work
1. Verify it yourself: convert the same saved captures with a `git archive` tree of `dec9452c` (the job's new base) and
   of your head, in one process each, and compare each to the committed sums and to each other. If the head differs
   from its base in anything, stop and report (that would be a real change, not stale sums).
2. Regenerate the sums **from the job's base tree** (`dec9452c`), with the generator the repo documents for them (find
   it in the test file's header, the ledger or HANDOFF; never by copying the head's own output), and commit them. The
   test must keep comparing whole pastes, notes included, and must still fail when the head changes a paste: prove it
   with one mutant on a scratch copy (a one-character change in a non-slider paste path makes the test fail) and
   restore.
3. In the same commit: one ledger line ("Fix pass 3: the unchanged sums regenerated from the stack's base `dec9452c`
   after site-reviews' note rewording; what was compared"). Nothing else changes; don't touch HANDOFF or the plan.
4. Gates: both typechecks, `npm run check` (exit 0 now), `test/unit/site-slider.test.ts`,
   `test/unit/site-elementor-unchanged.test.ts`. Commit with a plain `git commit -m` (no author override, no AI or
   Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/fixer-3/` (logs `HEAD=` first, `EXIT=` last).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; a worktree's `node_modules` may lack `.bin` and a
scratch tree has no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with
Write under `~/.cache/ssl-f3/`. The parallel unit suite may need an 8G scope (`systemd-run --user --scope -p
MemoryMax=8G -p MemorySwapMax=0 <cmd>`); SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min"
-o short-iso | grep sending`). Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, last commit (full SHA), verified?, how the sums were regenerated (the command and
the tree), the mutant, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
