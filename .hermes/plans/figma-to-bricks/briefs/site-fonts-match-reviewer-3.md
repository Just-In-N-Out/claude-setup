# Role: reviewer (round 3, a DELTA review of the rebase resolution, re-pins and AC7 sums; report only): site-fonts-match

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder). **Never load bdryswi.com** or any live site (Google Fonts only as
`site:check` does); never write to any WordPress site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: read-only copy
`evidence/media-clickable/run/`). P0–P2 only for bugs a real paste or a real test run hits, with a concrete scenario; edge cases P3. Keep it
focused (30–45 minutes).

## Scope
site-fonts-match was accepted (READY FOR THE USER 8/9, review 2 clean) on `dde550599bebc51772b0100a8a27941bd3138a51` (base `e61c0ca0`). It was
rebased onto local main `56b5076b5c1d665abd5bad4bcc78861739cc01e9` (Build 2026-11-12.1, site-native-structure merged) → 9 job commits ending
`cc929a2b`, a test-only re-pin commit `45b9c3e0`, and a test-only AC7 sums commit → head **`c8ad17b88a345eb9f1dbcb7946bca7e236a837c2`**
(branch `site-fonts-match-fix2`; `git checkout --detach c8ad17b8…`). Records: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/rebase/`
(`conflicts.md`, `range-diff.txt`, receipts) and `fixer-2/` — theirs; rerun what you rely on.

Review:
1. **The resolution** (`git range-diff e61c0ca0..dde55059 56b5076b..cc929a2b`): commit 3's source conflicts — `src/core/site/convert.ts`
   `PrepareExtra` (main's `part?` + the job's `fonts?`), `src/core/site/parts.ts` imports and the `prepare(…)` call (`{…openers, part:
   x.part, …(carried ? {fonts: carried} : {})}`, `prepareBoxes(…, carried)`); HANDOFF both kept. Do the two jobs meet right: main's lifted
   top Sections (no root) still get the fonts class and the page-named family on both routes; the kept "Header" Block too; `site:check`'s
   `checkParts` with lifted parts; the Elementor fold's Buttons/Headings carrying the renamed family. Probe: a fixture site with a site-served
   family whose header lifts (two bars never shown together) and one whose header keeps its root — the fonts class on every top element of
   each part, no plain carried name in any Typography control, Chrome drawing the site's file in the paste at 1440 and 390.
2. **Commit 45b9c3e0 (test-only re-pins):** `media-avif-untouched`, `site-import-figma-unchanged` allow exactly this job's changed files under
   their pinned paths (`git diff --name-status 56b5076b...c8ad17b8 -- src tools`), every other file still pinned; a stray file and a one-byte
   mutant still fail them (rerun with `F2B_STORY_PINS=1`, `F2B_BASE_TREE` = an archive of 56b5076b).
3. **Commit c8ad17b8 (AC7 sums):** only the 3 `elementor` entries moved, made by the builder's generator on a 56b5076b tree; AC7 still fails
   on a mutant of the `fontsRead` guard; Justin's scan pastes byte for byte as main on both routes.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/review-3/review.json` (round 3, **scope delta** from
`dde550599bebc51772b0100a8a27941bd3138a51` as rebased; full SHA `head` c8ad17b8…), in review-2's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base 56b5076b5c1d665abd5bad4bcc78861739cc01e9
/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match` (if it says run a full review from the base, say so and stop). Load
`requesting-code-review` and `code-review-practice`; read the project skill with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (fonts lines, Code-route paste traps); read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sfr3/t1`); scripts under `~/.cache/sfr3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
