# Role: reviewer (round 5: a docs-only rebase onto the new main; report only): site-reviews

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`).
Never load any live site; never write to any WordPress site; no logins. This should be a short review.

## What happened
site-reviews was review-clean (review 4) at `dec9452cbf28b25709d44e829b86bc0c7e91837e`, stacked on site-faq's head
`143a4e19`. site-faq then merged with a build commit: `main` is `e4355044c111c3c4c759e0ee50b22955534704dc` (Build
2026-11-10.1), which touched only `src/shared/build.ts`, `docs/HANDOFF.md` (site-faq's heading, paste-check line, known
limits, end-of-run entry) and site-faq's ledger. A finisher moved site-reviews onto it: branch `site-reviews-stack2`,
head `cd13abf38b5012df17ed7c12d075b98d9fbb4222`. It reports:
- one conflicted commit (`8a64e418` → `4326316a`), `docs/HANDOFF.md` only, two places: this job's section is inserted
  just above site-faq's heading, which main reworded ("build 2026-11-10.1; paste check 3dp owed"); this job's
  end-of-run item is inserted just above site-faq's, which main changed to "3dp." with a new step 1. Resolved: this
  job's lines first, unchanged, placeholders kept, then main's lines exactly as main has them;
- one new last commit, `cd13abf3`, adding only a "Stack 2" section to
  `docs/plans/2026-11-09-site-reviews-ledger.md`;
- 24 of 25 commits with equal full patch-ids; the conflicted one equal by its `-U0` patch-id; `git diff -U0 dec9452c
  59019e95` equal to `git diff -U0 143a4e19 e4355044` (the new head before the ledger commit is the old head plus
  exactly main's build commit). Receipts (read, don't trust):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/stack-2/` (`range-diff.txt`, `patch-ids.txt`,
  `conflicts.txt`, `logs/`).

## Scope (only this)
- In your own worktree: `git checkout --detach cd13abf38b5012df17ed7c12d075b98d9fbb4222`, confirm HEAD and a clean status.
- Prove yourself that no source, test or fixture line of the job changed: outside `docs/`,
  `git diff dec9452c cd13abf3` equals `git diff 143a4e19 e4355044` (say so with the commands' output), and
  `git range-diff 143a4e19..dec9452c e4355044..cd13abf3`.
- `docs/HANDOFF.md`: rebuild the resolution (apply main's own patch `143a4e19 → e4355044` for that file to the old
  head's file, or `git merge-file -p --diff3`/`diff3 -m` and "this job's lines first, then main's"), `cmp` with the
  head's file; nothing of main's site-faq lines (the build, 3dp, the reworded "With Build 2026-11-09.4 or later…",
  the four new known-limit lines) lost or changed; this job's section and end-of-run item unchanged with their
  `<site-reviews id at merge>` placeholders.
- The ledger commit: ledger text only.
- Importer rule: P0–P2 only for a bug a real site or normal use hits; anything else P3.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("After MOVE ON").
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-5/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e4355044c111c3c4c759e0ee50b22955534704dc /home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews` (exit 2 means
your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scripts written with Write under `~/.cache/srv-r5/`.
The worktree's isolation guard may refuse `git merge-file` on files outside the worktree: GNU `diff3 -m` or `patch`
does the same job. Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", `verdict`, `ac_status` ("unchanged by the
rebase" per AC), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
