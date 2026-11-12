# Role: reviewer (round 4, a SHORT notes-only review of a rebase; report only): bricks-icons

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command). Never load any live site. Justin's
notes-only rule: a rebase whose only conflict is HANDOFF needs a short review proving the code is identical and the notes whole, plus an AC
receipt. Keep it to 15–20 minutes.

## Scope
Head `37687fcbb68cf9b3e3bfc4d0eb7e4cffe06b0797` (branch `bricks-icons-final2`; `git checkout --detach 37687fcb…`) = `643109ec54f2060fdbf66c1db891d2b00505ec18`
(review 3 clean) rebased onto main `6cd6154e4af692699aaecf6d5ab905380c4c9dfd` (Build 2026-11-12.2). Records:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/rebase-2/` (theirs; rerun what you rely on).

Check: `git range-diff 56b5076b..643109ec 6cd6154e..37687fcb` — every commit identical except the HANDOFF-only change; `git diff 643109ec 37687fcb
-- . ':!docs/HANDOFF.md'` equals `git diff 56b5076b 6cd6154e -- . ':!docs/HANDOFF.md'` (the code moved only by main's own commits); HANDOFF
against main removes 0 lines and adds exactly this job's lines; the job's `test/fixtures/later-jobs.ts` allow-list equals `git diff --name-status
6cd6154e...37687fcb -- src`; the receipt `receipt-37687fc.log` runs every AC1–AC6 by name with `ok` and `EXIT=0` (rerun one Chrome AC yourself).
Where site-fonts-match's code (`src/core/site/`, `src/web/`) and this job's (`src/core/understand|style|emit`, `src/ui/`, `test/browser/render.ts`)
could meet at runtime: none expected (no Icon in site pastes) — confirm with one site paste through `render.ts` on the head.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/review-4/review.json` (round 4, **scope delta** from
`643109ec54f2060fdbf66c1db891d2b00505ec18` as rebased; full SHA `head` 37687fcb…), in review-3's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base 6cd6154e4af692699aaecf6d5ab905380c4c9dfd
/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons` and quote its last line. Load `requesting-code-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bir4/t1`); scripts under `~/.cache/bir4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; one Chrome suite at a time under `systemd-run --user --scope -p
MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write
tool. Use `tail -n 3`.

## Report (as text; only review.json is written)
Findings or "none"; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
