# VERIFIER, round 2 (read only): after-faq-sections (FigmaToBricksV2)

You are a fresh, independent verifier. Do everything in
`/home/justin/.hermes/plans/figma-to-bricks/briefs/after-faq-sections-verifier.md`: its rules, skills, independent work,
machine notes and return format. The pins, folders and leads are this round's, as follows. Prove every AC again on
this head against this base. Don't reuse, copy or hard-link any earlier receipt (round 1's `verifier-r1-ca26c83/`
included).

## This round
- **Step 0:** you start in your own throwaway worktree (`isolation: worktree`, from `main` at dea6296). In it run
  `git checkout --detach 974c4a6` and confirm `git rev-parse HEAD` = `974c4a6ccd1ac92298b06a96b2ccc18f44627686`, a clean
  `git status --porcelain --untracked-files=all` and `git merge-base HEAD main` = `dea6296`. The job's canonical copy is
  `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3f78512a3c169997` (branch
  `worktree-agent-a3f78512a3c169997`, head `974c4a6`): your `ac.json` must name that head. Never write or run commands in
  another worktree.
- **Your evidence folder:** `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/verifier/` (fresh; round 1's is
  `verifier-r1-ca26c83/`). Scratch: a fresh `after-faq-sections-verifier-2/` under the session scratchpad; TMPDIR,
  Chrome profiles and built trees under `/home/justin/.cache/after-faq-sections-verifier-2/`.
- **The approved plan** is now amendment 2 (`plan-approved.md`; older copies beside it). Its Amendments list records:
  Justin's A1 = A (AC7's measure), "Careful rules", "One more fix, then accept", and the accepted known limits R7-1 and
  R7-2. AC4's line: 349 variants, 88 splitting, receipt `fixer-6/scripts/base-vs-head.ts` (it reads its 19 fix-6
  splits from `join(E, '../fixer-6/expected-positives-v2.txt')`, so pass an evidence dir that is a direct child of
  `<E>`, e.g. `<E>/verifier`; it needs `E/base/replay`, `E/head/replay` and `E/{base,head}/fixtures.json` first:
  `review-8/scripts/ac4.sh` shows the full recipe).
- **The review loop is clean:** review 8 says `MOVE ON: review-8 at 974c4a6 is clean`. Rounds 1–8 and their
  `justin.json` are in `review-1/` … `review-8/`; `follow-ups.md` holds the P3 notes; `justin-answers.md` Justin's
  decisions. Fix rounds: fixer 1 (`8fa172b`), fixer 2 (`7a0bfe1`), amendment 1 (`ca26c83`), fixer 3 (`6a3a2f4`), fixer
  4 (`d74a834`), fixer 5 (`b583ece`), fixer 6 (`7496916`), records (`974c4a6`). Use their reports only as leads.
- **Known limits are not failures:** R7-1, R7-2 (Justin accepted them) and the HANDOFF R13 known limits. A footer shape
  in those classes that splits is not a finding; anything outside them that differs from base, or any AC clause that
  fails, is.
- **AC12 is live** (paste check 3bt): `accepted: false`, `not_run: "live: Justin pastes after-faq-sections.json under the
  FAQ on /homev2/, saves, regenerates code signatures and checks laptop, tablet and phone (paste check 3bt)"`.
- Another job (`header-bar`) is under review in its own worktree: leave it alone.

Return the JSON in the round-1 brief, ending with the line `MAIN SESSION: check and save these skill_lessons now.`

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
