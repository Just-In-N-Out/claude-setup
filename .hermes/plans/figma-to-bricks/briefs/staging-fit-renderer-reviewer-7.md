# Role: reviewer (round 7: a docs-only rebase onto the new main; report only): staging-fit-renderer

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`).
Never load any live site; never write to any WordPress site; no logins. This should be a short review.

## What happened
staging-fit-renderer was review-clean (review 6) at `abf1271404d62df57118e90b1fa9b12d0b02a384`, on an old stack base
`7d9754ed8adb5308bd525b309e7ba4672e284104`. Three jobs then merged with build commits: `main` is
`2879e4968438e7a442594d1021cb024dd85b3976` (Build 2026-11-10.3). Outside `docs/`, `git diff 7d9754ed 2879e496` is
`src/shared/build.ts` only. A finisher moved this job onto it: branch `staging-fit-renderer-stack4`, head
`8a8ec104bdad91635bfbb0732a0ebc1a0673d9b5` (the last commit is the ledger; code head `d0495f9b`). It reports:
- one conflicted commit (`29d28b27` → `9869f59f`), `docs/HANDOFF.md` only, two places: this job's section and its
  end-of-run entry are inserted just above site-slider's heading and entry, which main reworded ("build 2026-11-10.3;
  paste check 3dr owed"; "3dr. … build 2026-11-10.3"). Resolved: this job's lines first, unchanged, placeholders kept,
  then main's lines exactly as main has them;
- one more commit whose patch changed by context only (`f53a545d` → `8c6e7fe5`, fix 1's HANDOFF), no conflict;
- one new last commit, `8a8ec104`, adding only "## Stack 4 (finisher)" to
  `docs/plans/2026-11-09-staging-fit-renderer-ledger.md`;
- 40 of 42 full patch-ids equal, all 42 `-U0` patch-ids equal; `git diff -U0 abf12714 d0495f9b` equal to
  `git diff -U0 7d9754ed 2879e496` once `index` and `@@` lines are dropped. Receipts (read, don't trust):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/stack-4/`.

## Scope (only this)
- In your own worktree: `git checkout --detach 8a8ec104bdad91635bfbb0732a0ebc1a0673d9b5`, confirm HEAD and a clean status.
- Prove yourself that no source, test or fixture line of the job changed: outside `docs/`,
  `git diff abf12714 8a8ec104` equals `git diff 7d9754ed 2879e496` (say so with the commands' output), and
  `git range-diff 7d9754ed..abf12714 2879e496..8a8ec104`.
- `docs/HANDOFF.md`: rebuild the resolution (apply main's own patch `7d9754ed → 2879e496` for that file to the old
  head's file, or `diff3 -m` and "this job's lines first, then main's"), `cmp` with the head's file; nothing of the
  merged jobs' lines (their builds, 3dp, 3dq, 3dr, their reworded and added lines) lost or changed; this job's section
  and end-of-run entry unchanged with their placeholders.
- The other docs changes between the two heads are main's own (the merged jobs' plan files and ledgers) plus this job's
  ledger section: confirm.
- Importer rule: P0–P2 only for a bug a real site or normal use hits; anything else P3.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("After MOVE ON").
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-7/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
2879e4968438e7a442594d1021cb024dd85b3976 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer` (exit
2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scripts written with Write under `~/.cache/sfr-r7/`.
The worktree's isolation guard may refuse `git merge-file` on files outside the worktree: GNU `diff3 -m` or `patch`
does the same job. Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", `verdict`, `ac_status` ("unchanged by the
rebase" per AC), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
