# Role: reviewer (round 3, a delta: the HANDOFF-only moves onto Builds 11.8 and 11.9; report only): media-avif-alt

You are a fresh reviewer (**Opus 5.5, high**). Review only; change nothing, commit nothing, start no agents; never load any live site;
never call alttext.ai or any WordPress. **Time box: 20 minutes.**

## What happened
media-avif-alt was accepted (READY FOR THE USER 15/17) on `caf9291f681e1b6fed7862de125dddb40084da21` (base `02481763`). It was rebased
(HANDOFF-only conflicts, both times in commit 12, the job's docs commit) onto main `20ce41a8`, then onto main
`5bf71692c98497dd0411e2a42d23cbd93f457769` (Build 2026-11-11.9) as branch `media-avif-alt-final2`, head
`7f53ecf9fe02dba712b24a5e23e8b7364a85fff3`. Receipt: `evidence/media-avif-alt/rebase/receipt-7f53ecf.log` (EXIT=0). Records:
`evidence/media-avif-alt/rebase/` (`conflicts.md`, `range-diff.txt`). Justin's rule: a HANDOFF-only conflict takes a short review + the
receipt.

## Check (your own worktree, `git checkout --detach 7f53ecf9…`; plain `git`, never `git -C` the main folder)
1. Outside `docs/HANDOFF.md`, the story's diff from `5bf71692` equals its diff from `02481763` to `caf9291f`, with hunk numbers and
   `index` lines removed (`sed -E 's/^@@ -[0-9,]+ \+[0-9,]+ @@/@@/'`); list the files main and the story both touched and check the
   edits don't overlap.
2. HANDOFF: main's sections and check-list entries (3dz, 3ee, 3eb, 3ec, 3ed, 3ea …) exactly as on main; this job's section and entry as
   on the accepted head (`<id at merge>`); nothing lost or doubled; no markers.
3. `test/web/site-upload-ai-alt.test.ts` alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` with `TMPDIR` under 31 characters (`~/.cache/ma3/t1`).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/review-3/review.json` (round 3, a delta from `caf9291f`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
5bf71692c98497dd0411e2a42d23cbd93f457769 /home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt`. Load `requesting-code-review`
and `code-review-practice`.

## Report (as text; only review.json is written)
Findings or "none"; each check; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
