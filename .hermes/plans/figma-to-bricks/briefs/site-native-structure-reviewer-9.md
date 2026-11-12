# Role: reviewer (round 9, a short DELTA review of the merge-prep commits; report only): site-native-structure

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder). Never load any live site; never write to any WordPress site. Justin's
notes-only rule: a test-only pin update or HANDOFF-only change gets a short delta review plus an AC re-run receipt. **Importer rule:** P0–P2
only for bugs a real paste or a real test run hits, with a concrete scenario; edge cases P3. Keep it short (15–25 minutes).

## Scope
`git diff d6f169848744d4f23f8dd2a8b2b6787dae1872f7..172be61aacaa19e8fcf06f926ea7cdfecc94707d` (branch `site-native-structure-merge`;
`git checkout --detach 172be61a…` in your worktree). Review 8 was clean on d6f16984. Two commits:
1. `02c60b05`: `test/unit/media-avif-untouched.test.ts` and `test/unit/site-import-figma-unchanged.test.ts` get an exact `LATER_JOBS` list of
   this job's 13 `src/core/site` files (plus `tools/site-check.ts`, `tools/site-live.ts` in the first). Check: the list equals
   `git diff --name-status 4f8b61165d98002e64f97aa2e4330f6cf9801c1d...172be61a -- src tools` for the paths each pin guards, nothing wider (no glob,
   no folder); every other file still byte-pinned; `dist/` check unchanged; each test still fails on a stray `src/core/site` file and on
   one changed byte of a pinned file (run them yourself; logs in `evidence/site-native-structure/finisher-merge-prep/` are the finisher's —
   rerun, don't trust).
2. `172be61a`: `docs/HANDOFF.md` (this job's section: paste-check step 1 and new step 8, three Deferred lines) and
   `docs/plans/2026-11-09-site-native-structure.md` (`cmp` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`).
   Check: nothing else in HANDOFF changed; the steps are plain and correct for Justin.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-9/review.json` (round 9, **scope delta** from
`d6f169848744d4f23f8dd2a8b2b6787dae1872f7`; full SHA `head` 172be61a…), in review-8's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base 4f8b61165d98002e64f97aa2e4330f6cf9801c1d
/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`. Load `requesting-code-review` and `code-review-practice`; read
both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sr9/t1`); scripts under `~/.cache/sr9/s/`;
memory scope `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
