# Role: reviewer (round 3: the rebase onto main only, report only): site-faq

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** P0–P2 only for bugs a real
site or normal use hits, each with a concrete scenario; everything else is P3.

## What happened
site-faq was review-clean (review 2) at `a4b74bcb87213a6403e9796b4bda9367c71b7723` on the old `main` `fd1986dc`, and
accepted by a verifier and a blind auditor there. `main` then moved to `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1`
(Build 2026-11-09.4, staging-fit-capture). A finisher rebased the job onto it: branch `site-faq-stack1`, head
`143a4e19a6428e961c29a5f16f5cd715da91b7c1`. It reports one conflicted commit, one file — `docs/HANDOFF.md`, two places
(the job's section and its end-of-run list item; both sides kept, site-faq's first, then main's staging-fit-capture
section and item 3do unchanged) — and one new last commit that adds only a "Stack 1" section to the job's ledger
(`docs/plans/2026-11-09-site-faq-ledger.md`).

## Scope (only this)
- In your own worktree: `git checkout --detach 143a4e19a6428e961c29a5f16f5cd715da91b7c1`, confirm HEAD and a clean status.
- `git range-diff fd1986dc..a4b74bcb 3cfc54ac..143a4e19`: every commit's patch is unchanged but the HANDOFF one, and the
  one added commit is ledger text only. Confirm that no source, test or fixture line differs:
  `git diff a4b74bcb 143a4e19 -- . ':!docs'` must equal `git diff fd1986dc 3cfc54ac -- . ':!docs'` (the capture fix's
  own change), and say so with the commands' output.
- The docs-only resolution, rebuilt as `review-loop.md` "After MOVE ON" says: `git merge-file -p --diff3 <old head's
  HANDOFF> <old base's> <new base's>`, apply "both sides stay, the job's first" per conflict, `cmp` with the head's
  file; and `cmp` the changed lines of `git diff a4b74bcb 143a4e19 -- docs/HANDOFF.md` against
  `git diff fd1986dc 3cfc54ac -- docs/HANDOFF.md`. Nothing of main's HANDOFF (the staging-fit-capture section, item
  3do, the build line) may be lost or reordered wrongly; nothing of the job's.
- The finisher's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/stack-1/`
  (`range-diff.txt`, `changed-commits.txt`, `changed-lines.txt`, `conflicts.txt`, `logs/`).
- One semantic check the rebase can't show in a diff: staging-fit-capture now refuses a capture holding a width range
  read without the site's styles (`npm run site`, `site:check`, the panel reader). Does anything in site-faq's shipped
  code or its tests now behave differently on the new base (the finisher: the job's unit and web AC files and the
  named-only AC7 all pass on the rebased head; AC7 calls `siteToBricks` directly)? Run the job's two unit files and
  `test/web/site-elementor-open-item.test.ts` once on the head to confirm (4 GB cap).

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/review-3/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq` (exit 2 means your
file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfq-r3/tmp`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job of your own at a time, closed after; a
worktree's `node_modules` may lack `.bin` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH).
Scripts written with Write under `~/.cache/sfq-r3/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom
--since "-30 min" -o short-iso | grep sending`). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: unchanged by the
rebase, or what you saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never
edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
