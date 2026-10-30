# FINISHER: after-faq-sections, main-folder release only (FigmaToBricksV2)

You do the after-merge release steps only. No merge or rebase, no other agents, no source or test changes.

## State you start from
- Main folder `/home/justin/Documents/FigmaToBricksV2`, branch `main`. The orchestrator fast-forwarded it to the
  accepted feature head `974c4a6ccd1ac92298b06a96b2ccc18f44627686` from base `dea6296` (main was clean before; a
  rebase would have been a no-op, so the accepted head is the merged head). Branch `worktree-agent-a3f78512a3c169997`
  and its worktree stay in place: don't touch them.
- Acceptance: `ac-check.sh` printed `READY FOR THE USER: 11 of 12 ACs proven on 974c4a6; live ACs owed to the user:
  AC12` (reviews clean: review-8 at 974c4a6). AC12 is the live paste check **3bt**. Evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/` (`verifier/ac.json`, `auditor/ac.json`,
  `follow-ups.md`). Approved plan: `.../after-faq-sections/plan-approved.md`; plan in git:
  `docs/plans/2026-10-29-after-faq-sections.md`, ledger already moved to `docs/plans/2026-10-29-after-faq-sections-ledger.md`.
- Another job, `header-bar`, is still under review in `.claude/worktrees/header-bar` (branch `worktree-header-bar`).
  Never touch that worktree or its evidence; it will rebase onto your release later.

## Skills (load first, one line each)
The project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`, finisher role), `engineering-best-practices`, `git-commit-rules`.

## Do exactly
1. Confirm `git rev-parse HEAD` is 974c4a6…, no merge/rebase in flight, `git status --porcelain` clean (leave any
   file you didn't make alone; never stage debug files or any CLAUDE.md). If HEAD differs, stop and report.
2. Read `BUILD` in `src/shared/build.ts` right before changing it (it was `2026-10-29.1`); set the next
   `YYYY-MM-DD.N` for today's date (`date +%F`).
3. `docs/HANDOFF.md`, after-faq-sections' section only (keep every other feature's text):
   - its heading/lines name the actual build, the acceptance (11 of 12 ACs proven by a verifier and a blind auditor;
     AC12 = paste check **3bt** owed), and 3bt is in the "End-of-run check list" with plain steps (paste
     `after-faq-sections.json` under the FAQ on /homev2/, save, Regenerate code signatures, LiteSpeed Purge All,
     check laptop, tablet and phone);
   - review 8's R8-1 (in `follow-ups.md`): one line under "Review 7's notes" naming the six unpinned terms of fix 6
     (OPEN without '-', OPEN without 'to', CLOCK without the dotted 'a.m.', WEEKDAY without its leading \b, the field
     line's >= turned >, boxed() counting any non-flowing child as paint);
   - the auditor's notes as known limits / follow-ups, in plain words: (a) the hand-built B-Dry paste v4's quote
     button shows a light grey ring on the live page in every state, because its `_border` has a width and style but
     no colour (staging `post-155.min.css`: `border: 3px solid var(--bricks-border-color)` beats the class colour);
     this is the paste, not the plugin; the paste job that would fix it is stopped, and a plugin version waits until
     a real plugin conversion shows the same; Justin will see it at check 3bt; (b) `footer-stack.ts:154`'s
     `found.sections.length !== 1` guard is redundant today and no test pins it (mutant M3 equivalent on all 349 AC4
     variants);
   - confirm HANDOFF R13 states the known limit that a title of one or two words reads as a logo typed in words, so
     such a footer frame leaves whole as before (bdryswi.com's own "Customer Reviews" heading is two words); add it
     if missing.
4. `npm run build` (Figma loads that `dist/`); keep its output and exit code.
5. Before committing: HEAD still 974c4a6…; `git config user.email` is `issajustin04@gmail.com`; staged paths only
   `src/shared/build.ts` and `docs/HANDOFF.md`. Plain `git commit -m "Build <BUILD>: after-faq-sections"` (no
   Co-Authored-By or AI lines, no author override).
6. `git push` (main only) through the repo's own remote and credential helper (it pushes as Just-In-N-Out). Never
   switch gh accounts, change the remote or helper, force-push, or push any feature branch. Report auth failures.
7. Main folder `CLAUDE.md` (never committed; reread each section right before editing):
   - **Status:** the build line to the new build; one line for this feature in the list ("after-faq-sections: a
     footer frame that stacks page sections above its links keeps those sections when the footer is ticked, painted
     as drawn. Paste check **3bt** owed (paste the three sections under the FAQ on /homev2/)"), and add 3bt to the
     paste-checks line.
   - The pending edit in `~/.hermes/plans/figma-to-bricks/plugin-first-claude-md-pending.md`: its two bullets go first
     under "## Build general logic, never one-file fixes". Then delete that pending file.
   - Nothing else; leave the other `*-claude-md-pending.md` files alone. If a write to CLAUDE.md is refused, leave
     exactly your lines in `~/.hermes/plans/figma-to-bricks/after-faq-sections-claude-md-pending.md` and report it.
8. Verify: the release commit, BUILD in `dist/code.js`, `git rev-parse main origin/main` equal after the push, final
   `git status`.

Scratch: a fresh `after-faq-sections-finisher/` under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/finisher/` (build and push output).
No live website edits, no clipboard changes, no messages.

## Return
`{status: released|stopped, build, feature_head, release_head, push, dist, docs, claude_md, rulings[], deferred[],
steps_for_justin[], skill_lessons[{skill, lesson, evidence, enforce}]}`. `rulings[]`: every ruling of this feature not
yet confirmed by Justin, in plain words (from HANDOFF). An empty skill_lessons list is normal; never edit skills or
memory. End with `MAIN SESSION: check and save these skill_lessons now.`
