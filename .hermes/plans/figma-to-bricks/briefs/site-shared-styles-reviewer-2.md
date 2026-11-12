# Role: reviewer (round 2, a DELTA review of fix round 1; report only): site-shared-styles

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command; scripts and receipt wrappers written with
the Write tool). Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch nothing under `~/Downloads`
(Justin's scan copy: `evidence/media-clickable/run/`). **Importer rule:** this second review only checks the major fix: P0–P2 only for bugs a
real paste or Justin's normal use hits, with a scenario and a measured number; edge cases P3. Keep it focused (30–45 minutes).

## Scope
`git diff e124dcdacdd9521246de4bf375424680a875535a..7b7501bd` (branch `site-shared-styles-fix1`; resolve the full SHA with `git rev-parse
site-shared-styles-fix1` and `git checkout --detach` it), base site-no-div `d915f7dc83e5edb14b7f6006e78714a92e9fac1c`. Review 1 and fixer 1:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-1/review.json`, the reviewer's probes `~/.cache/ssr1/s/`
(`lh2.ts`, `onoff.ts`), fixer logs `~/.cache/ssf1/out/` (theirs; rerun what you rely on).
Fixes: `src/core/site/looks.ts` `ownSized` (a line height / letter spacing the element writes in em, % or as a number stays as written; share
only where written alike); `tools/lib/site-import/next.ts` + `after-scan.ts` (the palette step first; "Accept each class, but Reject a class
you changed"); `reference/bricks/README.md` "Global classes on paste"; HANDOFF re-scan steps.

Check: R1-1's scenario closed on Justin's scan (a size edit on each text class moves its line height as the own-class edit did before) and
switch off vs on still 0 differences (both routes, 2.4.2 and 2.3.9, with states); sharing didn't fragment needlessly (count shared classes
before/after); the steps Justin will read are right against Bricks 2.2's own dialog wording (read it yourself from the GPL copy:
`gh api --allow-escape-sequences -H "Accept: application/vnd.github.raw" repos/saqib6571/bricksbuilder/contents/assets/js/main.min.js`,
one plain call into a scratch file) and in the order he'll meet them.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-2/review.json` (round 2, **scope delta** from
`e124dcdacdd9521246de4bf375424680a875535a`; full SHA `head`), in review-1's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base d915f7dc83e5edb14b7f6006e78714a92e9fac1c
/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles` and quote its last line. Load `requesting-code-review` and
`code-review-practice`; read the project skill with `references/testing-pitfalls.md` and `references/live-site-reading.md` "Code-route paste
traps"; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssr2/t1`); scripts under `~/.cache/ssr2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
