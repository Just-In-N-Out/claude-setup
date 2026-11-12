# Role: reviewer (round 3 — the LAST review round; a DELTA review of fix round 2; report only): site-no-div

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder). Never load bdryswi.com, B-Dry staging or any live site; never write to any
WordPress site; touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). **Importer rule and the project's
round cap:** this is the last review round. P0–P2 only for a bug a real paste hits (Justin's sites, a common hand-built or theme page), with a
concrete scenario and a measured number; rarer shapes are P3 and go to follow-ups. Keep it focused (30–45 minutes).

## Scope
`git diff 374ea2ce2075d86054c70c07daab45ef1148798a..d915f7dc83e5edb14b7f6006e78714a92e9fac1c` (branch `site-no-div-fix2`; `git checkout --detach
d915f7dc…`), base main `56b5076b5c1d665abd5bad4bcc78861739cc01e9`. Review 2's findings and fixer 2's answers:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/review-2/review.json`, `…/fixer-2/` (theirs; rerun what you rely on).
Fixes in `src/core/site/fold-boxes.ts` (N4: flex/grid-row 100% exception narrowed; % text-indent; new `readsAnother` on `CodeNode.inherited`),
`lift.ts` exports `INHERITED_TEXT`; test-only rows added to AC5's and AC4's cited tests (plan amendments 1 and 2); HANDOFF; plan copy.

Check: review 2's probes c and d (in `review-2/probes/`, with its rule-N-off hook) at 0 px on Bricks 2.4.2 and 2.3.9; `readsAnother` doesn't
keep wrappers it needn't on common pages (a paragraph in a plain div with the site's own font size, a link in a card) — Justin's scan and the
B-Dry stand-in byte-identical to 374ea2ce on both routes (confirm); the added test rows are honest (each fails on a mutant of its clause).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/review-3/review.json` (round 3, **scope delta** from
`374ea2ce2075d86054c70c07daab45ef1148798a`; full SHA `head` d915f7dc…), in review-2's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base 56b5076b5c1d665abd5bad4bcc78861739cc01e9
/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div` and quote its last line. Load `requesting-code-review` and
`code-review-practice`; read the project skill with `references/testing-pitfalls.md` and `references/live-site-reading.md` "Code-route paste
traps"; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdr3/t1`); scripts under `~/.cache/sdr3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
