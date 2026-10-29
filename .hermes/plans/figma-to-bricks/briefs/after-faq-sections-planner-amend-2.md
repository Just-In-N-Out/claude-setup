# Brief: PLANNER (amend mode) + records for figma-to-bricks feature "after-faq-sections"

Make the job's last records commit before verification: amend the plan's AC lines to what the tests assert, record
Justin's accepted known limits in HANDOFF, and move the ledger to its final place. Don't re-plan, don't change source
or tests, don't start agents. Be quick: about 20 steps.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). The job's head is
`7496916` on branch `worktree-agent-a9620dc83166c651c` (never write or run commands in another worktree). In **your
own** worktree run `git merge --ff-only 7496916` and check `git rev-parse HEAD`. Commit there (one commit, plain
`git commit -m "after-faq-sections: plan amendment 2, known limits, ledger moved"`, no author override, no AI lines,
never CLAUDE.md), and leave the worktree in place. If refused, stop with the exact message.

## What to change (records only)
1. **The plan** `docs/plans/2026-10-29-after-faq-sections.md` (amend mode: read
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` lines 21–23 and follow them):
   - AC4's line: the splitting variants are **88** (349 variants in all), the receipt is
     `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-6/scripts/base-vs-head.ts`; drop "31 at 7a0bfe1"
     and fixer 2's copy. Its test name stays exactly the same.
   - Check AC1, AC2 and AC3 against their tests (review 7 says their tests are unchanged and the lines stand; confirm).
   - Amendments list at the top: amendment 2, its date, the decisions behind it (`review-4/justin.json` "Careful rules",
     `review-6/justin.json` "One more fix, then accept", `review-7/justin.json` accepting R7-1 and R7-2), each changed
     line, and where the pre-amendment text lives (`git show 7496916:docs/plans/2026-10-29-after-faq-sections.md`). No
     Amendments line starts with an AC id.
   - Run `ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes on the approved copy
     (`~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`) and the amended plan: AC1–AC12
     unchanged, live set AC12 unchanged, every test-name line unchanged.
   - Write a copy to `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/amendment-2/plan-amended.md`.
2. **HANDOFF** (`docs/HANDOFF.md`, this job's section; never replace another section's `## ` heading): add the accepted
   known limits R7-1 (brand names with other abbreviations such as "S.A.", "Ltda.", "LLP.", and a "Lic. 4829163" line,
   still read as a band) and R7-2 (hours formats such as "M–F" over "8–5", plural day names, "by appointment",
   "Open 24 hours", "Open 7 days a week", and contact words linked to sms:/callto:/skype:, still pass), as Justin's
   decision ("One more fix, then accept"); and review 7's P3 notes from
   `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/follow-ups.md` (R7-3 field drawings, R7-4 narrowings to
   base and the "@" wording, R7-5 drawn cards beyond review cards) as follow-ups. Keep R13 saying what the code does.
3. **The ledger:** move `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md` to
   `docs/plans/2026-10-29-after-faq-sections-ledger.md` (with `git mv` if tracked), adding one closing line that the
   verifier, auditor and finish results are recorded outside the branch (evidence folder and the post-merge HANDOFF).
- `git status --porcelain --untracked-files=all` must be clean after your commit.

## Skills
Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (planner role) and `references/rules-summary.md`;
load `implementation-planning`.

## Rules
The worktree guard refuses Bash it can't prove stays in your worktree (shell variables or loops around `node`/`git`/
`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word `source`
anywhere): write scripts with Write and run them as one plain command. Lessons: `skill_lessons[{skill, lesson,
evidence, enforce}]` (normally empty); never edit skills or memory.

## Return
`{status: amended|stopped, worktree, branch, last_commit, changed_files[], ac_ids_old[], ac_ids_new[], live_old[],
live_new[], test_lines_unchanged, copy_path, skill_lessons[]}`. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
