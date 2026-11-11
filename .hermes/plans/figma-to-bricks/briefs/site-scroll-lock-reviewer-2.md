# Role: reviewer (round 2, a delta: the rebase's HANDOFF-only resolution; report only): site-scroll-lock

You are a fresh reviewer (**Opus 5.5, high**). Review only; change nothing, commit nothing, start no agents; never load any
live site. **Time box: 20 minutes.**

## What happened
site-scroll-lock was accepted on `ad5bd862faeae4ed025df224a9bf966198ef71a1` (base `02481763`). It was rebased onto main
`088ee066eef9e004c6ea61516628b4719ec96304` (Build 2026-11-11.4, media-clickable) as branch `site-scroll-lock-final`, head
`c37528ced95f707ccade6627b6a59c0e05cedfa4`. Conflicts **only in `docs/HANDOFF.md`** at commit 6 (`81d4ccf2 → 83f15f0c`): this
job's section first, then media-clickable's; the check list: this job's `<id at merge>` item, then `3ea`, then `3dy`.
Range-diff: commits 1–5 and 7 identical, 6 differs only in context.

## Check (in your own worktree, `git checkout --detach c37528ce…`, clean status)
1. Outside `docs/HANDOFF.md`: `git diff 088ee066 c37528ce -- . ':(exclude)docs/HANDOFF.md'` equals `git diff 02481763 ad5bd862 --
   . ':(exclude)docs/HANDOFF.md'` after dropping `^index ` lines (byte for byte).
2. HANDOFF: media-clickable's section and its 3ea check-list entry exactly as on main; this job's section and entry exactly as on
   the accepted head; no line lost, doubled or reordered; no conflict markers.
3. `site-check-cli` "--whole draws the parts together…" alone under a 4G scope, twice (the finisher saw one 5.1 px failure under
   load and three alone-passes).
4. `npm run check` (8G scope) exit 0.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/review-2/review.json` (round 2, a delta from `ad5bd862` to
`c37528ce`; full SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base 088ee066eef9e004c6ea61516628b4719ec96304 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock`.
Load `requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sl2/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; piped/chained git commands may be
refused (script files; `git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings or "none"; the code-identity proof; the HANDOFF check; the site-check-cli runs; `verdict`; `ac_status` (the move
changes no AC: say so with the proof); `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
