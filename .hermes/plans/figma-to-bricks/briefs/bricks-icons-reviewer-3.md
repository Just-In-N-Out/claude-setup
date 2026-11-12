# Role: reviewer (round 3, a DELTA review of the rebase resolution and re-pins; report only): bricks-icons

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder). Never load any live site; never write to any WordPress site. P0–P2 only for
bugs a real paste or a real test run hits, with a concrete scenario; edge cases P3. Keep it focused (30–45 minutes).

## Scope
bricks-icons M1 was accepted (READY FOR THE USER 6/7, review 2 clean) on `c78fa0cfcbc7ce9a9b9689613274f633130012ef` (base `02481763`). It was
rebased onto local main `56b5076b5c1d665abd5bad4bcc78861739cc01e9` (Build 2026-11-12.1) → `9bf4d3a058cea36bfb81ee7d3f4aaa6a2972fa15`, plus one
test-only commit → head **`643109ec54f2060fdbf66c1db891d2b00505ec18`** (branch `bricks-icons-final`; `git checkout --detach 643109ec…`). Records:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/rebase/` (`conflicts.md`, `range-diff.txt`, `repin-*.log`, `receipt-643109e.log`)
— the finisher's; rerun what you rely on.

Review:
1. **The resolution:** `git range-diff 02481763..c78fa0cf 56b5076b..9bf4d3a0`. Three commits changed by it: `reference/bricks/README.md` (both
   sections kept), `docs/HANDOFF.md` (both kept: 0 lines of main removed), and **`test/browser/render.ts`** (main's `wrapped(body(...),
   opts.wrap)` with this job's `holdsIcon(...) ? <style>ICON_SITE_CSS|ICON_BASE_CSS</style>` insert). Is the icon CSS still printed in
   every render path main now has (wrapped and unwrapped, site route and Figma route, both Bricks looks)? Does main's code (site pages, the
   `_background` printer, lifted parts) draw the same with this job in? Run `test/browser/icon-elements.test.ts` and a few of main's site
   web tests that render through `render.ts` (`site-native-stay`, `site-elementor-button`, `site-check-lifted`).
2. **This job meeting main's code** beyond the conflicts: the website importer now pastes Buttons/Dividers/Images natively (site-native-
   structure) — does any Icon path reach site pastes when it must not (M1 is the Figma plugin only; the importer half is a later job)? The
   panel's tick wording (plugin-header-footer-ticks) beside "Icons as: SVG".
3. **Commit 643109ec (test-only):** `test/fixtures/later-jobs.ts` and the four pins (`media-avif-untouched`, `site-import-figma-unchanged`,
   `site-scroll-lock-base` test 1, `panel-embed-unchanged` panel sums): allowed files exactly `git diff --name-status 56b5076b...643109ec --
   src`; every other file still pinned; the build overlay honest; the dropped `icons` field guarded (a made Icon with Icons off still fails).
   Rerun each with its variables, plus a stray-file and a one-byte mutant.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/review-3/review.json` (round 3, **scope delta** from
`c78fa0cfcbc7ce9a9b9689613274f633130012ef` as rebased; full SHA `head` 643109ec…), in review-2's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base 56b5076b5c1d665abd5bad4bcc78861739cc01e9
/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons` (if it says run a full review from the base, say so and stop). Load
`requesting-code-review` and `code-review-practice`; read the project skill with `references/testing-pitfalls.md` and
`references/rendering-validation.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bir3/t1`); scripts under `~/.cache/bir3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
