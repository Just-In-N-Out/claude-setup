# Role: reviewer (round 5, DELTA review of rebase 2 onto main; report only): site-shared-styles

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site
capture or paste with `SITE_OFFLINE`); never write to any WordPress site; touch nothing under `~/Downloads`. Keep it to about 20 minutes.
This is the notes-only rebase rule (Justin, 2026-11-11): a short delta review plus the finisher's AC receipt replace a new verifier and auditor.

## Inputs
- Head `f971b30691f6c00c0580793c99c8b415ba9bebe3` on main `392f67e2a6b52c40a64acaf7d344a50c934dee26`: review 4 MOVE ON, verifier 2 PASS 14/15 (AC15
  live); its blind auditor 2 runs on f971b306 now. Rebased by the finisher onto main `6bca11764334673ec1fb077415a78209cdfd38a1` (Build
  2026-11-14.3, importer-app) as branch `site-shared-styles-final2`, head **`1eec2afaf52340c162d259fa951de7c44d70a67a`** (26 commits; a
  HANDOFF-only conflict in commit 12; commit 24 changed one context line beside the pin edit in `test/unit/media-avif-untouched.test.ts`,
  auto-merged with importer-app's `package.json` allowance; no test change of its own).
- Finisher's records: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/rebase-2/` (`conflicts.txt`, `range-diff.txt`,
  `pins-1eec2af.log`, `pins-story-mutants-1eec2af.log`, `receipt-1eec2af.log`, `summary.txt`).

## Check
1. `git merge-tree --write-tree 6bca1176 f971b306` diffed against `1eec2afa`: outside `docs/HANDOFF.md` nothing differs (so the code
   is the reviewed and verified code plus main's importer-app files untouched).
2. HANDOFF: the diff from 6bca1176 deletes no main line except this job's own planned edit to site-no-div's section (Q6 A); every
   importer-app line kept word for word; this job's section first; the job's `<… at merge>` placeholders kept for the after-merge finisher.
3. `test/unit/media-avif-untouched.test.ts`: both allowances exactly (bricks-icons-site's, this job's five LATER_JOBS files, importer-app's
   one `package.json` line); a stray file and a one-byte change still fail it (`F2B_STORY_PINS=1`, the 56b5076b archive with main's
   `build.ts` laid over it, `--test-concurrency=1`).
4. The receipt: `HEAD=1eec2afa…` first, AC1–AC14 `ok` by their plan names
   (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`), skipped 0, `EXIT=0` last.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-5/review.json` (round 5, scope delta, `from`
`f971b30691f6c00c0580793c99c8b415ba9bebe3`, full SHA `head`, a `note` saying what you checked), in review-4's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
6bca11764334673ec1fb077415a78209cdfd38a1 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles` and quote its last line; if it
asks for another scope, say so. Load `requesting-code-review` and `code-review-practice`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sssr5/t1`); scripts under
`~/.cache/sssr5/s/`; memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo
(set `GIT_DIR`). Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
